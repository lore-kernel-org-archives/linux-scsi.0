From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 14/14] tcm_loop: Enable DIF/DIX modes in SCSI host LLD
Date: Wed,  8 Jan 2014 20:15:57 +0000
Message-ID: <1389212157-14540-15-git-send-email-nab@daterainc.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates tcm_loop_driver_probe() to set protection
information using scsi_host_set_prot() and scsi_host_set_guard(),
which currently enabled all modes of DIF/DIX protection, minus
DIF TYPE0.

Also, update tcm_loop_submission_work() to pass struct scsi_cmnd
related protection into target_submit_cmd_map_sgls() during CDB
dispatch.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index c6f1427..8d3355f 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -217,7 +217,8 @@ static void tcm_loop_submission_work(struct work_struct *work)
 			scsi_bufflen(sc), tcm_loop_sam_attr(sc),
 			sc->sc_data_direction, 0,
 			scsi_sglist(sc), scsi_sg_count(sc),
-			sgl_bidi, sgl_bidi_count, NULL, 0);
+			sgl_bidi, sgl_bidi_count,
+			scsi_prot_sglist(sc), scsi_prot_sg_count(sc));
 	if (rc < 0) {
 		set_host_byte(sc, DID_NO_CONNECT);
 		goto out_done;
@@ -462,7 +463,7 @@ static int tcm_loop_driver_probe(struct device *dev)
 {
 	struct tcm_loop_hba *tl_hba;
 	struct Scsi_Host *sh;
-	int error;
+	int error, host_prot;
 
 	tl_hba = to_tcm_loop_hba(dev);
 
@@ -486,6 +487,13 @@ static int tcm_loop_driver_probe(struct device *dev)
 	sh->max_channel = 0;
 	sh->max_cmd_len = TL_SCSI_MAX_CMD_LEN;
 
+	host_prot = SHOST_DIF_TYPE1_PROTECTION | SHOST_DIF_TYPE2_PROTECTION |
+		    SHOST_DIF_TYPE3_PROTECTION | SHOST_DIX_TYPE1_PROTECTION |
+		    SHOST_DIX_TYPE2_PROTECTION | SHOST_DIX_TYPE3_PROTECTION;
+
+	scsi_host_set_prot(sh, host_prot);
+	scsi_host_set_guard(sh, SHOST_DIX_GUARD_CRC);
+
 	error = scsi_add_host(sh, &tl_hba->dev);
 	if (error) {
 		pr_err("%s: scsi_add_host failed\n", __func__);
-- 
1.7.10.4
