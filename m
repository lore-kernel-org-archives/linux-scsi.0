From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 12/13] target: Add compare_and_write_post() completion callback fall through
Date: Mon, 26 Aug 2013 21:13:45 +0000
Message-ID: <1377551626-27447-13-git-send-email-nab@daterainc.com>
References: <1377551626-27447-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377551626-27447-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Kent Overstreet <kmo@daterainc.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch changes target_complete_ok_work() to fall through
after calling the se_cmd->transport_complete_callback() ->
compare_and_write_post() callback, by keying off the existance
of SCF_COMPARE_AND_WRITE_POST.

This is necessary because once SCF_COMPARE_AND_WRITE_POST has
been set by compare_and_write_post(), the SCSI response needs
to be sent via TFO->queue_status().

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_sbc.c       |    3 ++-
 drivers/target/target_core_transport.c |   19 ++++++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 4076828..bb1b42b 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -375,7 +375,8 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd)
 	buf = kzalloc(cmd->data_length, GFP_KERNEL);
 	if (!buf) {
 		pr_err("Unable to allocate compare_and_write buf\n");
-		return TCM_OUT_OF_RESOURCES;
+		ret = TCM_OUT_OF_RESOURCES;
+		goto out;
 	}
 
 	write_sg = kzalloc(sizeof(struct scatterlist) * cmd->t_data_nents,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 672cb37..e53c59b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1909,17 +1909,18 @@ static void target_complete_ok_work(struct work_struct *work)
 		sense_reason_t rc;
 
 		rc = cmd->transport_complete_callback(cmd);
-		if (!rc)
+		if (!rc && !(cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE_POST)) {
 			return;
+		} else if (rc) {
+			ret = transport_send_check_condition_and_sense(cmd,
+						rc, 0);
+			if (ret == -EAGAIN || ret == -ENOMEM)
+				goto queue_full;
 
-		ret = transport_send_check_condition_and_sense(cmd,
-					rc, 0);
-		if (ret == -EAGAIN || ret == -ENOMEM)
-			goto queue_full;
-
-		transport_lun_remove_cmd(cmd);
-		transport_cmd_check_stop_to_fabric(cmd);
-		return;
+			transport_lun_remove_cmd(cmd);
+			transport_cmd_check_stop_to_fabric(cmd);
+			return;
+		}
 	}
 
 	switch (cmd->data_direction) {
-- 
1.7.2.5
