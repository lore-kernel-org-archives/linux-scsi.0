From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] target: Fix zero-length INQUIRY additional sense code regression
Date: Tue, 29 Jan 2013 22:26:13 +0000
Message-ID: <1359498375-8040-2-git-send-email-nab@linux-iscsi.org>
References: <1359498375-8040-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1359498375-8040-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Roland Dreier <roland@purestorage.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a minor regression introduced in v3.8-rc1 code
where a zero-length INQUIRY was no longer returning the correct
INVALID FIELD IN CDB additional sense code.

This regression was introduced with the following commit:

  commit de103c93aff0bed0ae984274e5dc8b95899badab
  Author: Christoph Hellwig <hch@lst.de>
  Date:   Tue Nov 6 12:24:09 2012 -0800

      target: pass sense_reason as a return value

and this patch has been tested with the following zero-length CDB:

  sg_raw /dev/sdd 12 00 83 00 00 00
  SCSI Status: Check Condition

  Sense Information:
   Fixed format, current;  Sense key: Illegal Request
   Additional sense: Invalid field in cdb

Cc: Christoph Hellwig <hch@lst.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_spc.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 84f9e96..f8857d4 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -641,11 +641,10 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 
 out:
 	rbuf = transport_kmap_data_sg(cmd);
-	if (!rbuf)
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-
-	memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
-	transport_kunmap_data_sg(cmd);
+	if (rbuf) {
+		memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
+		transport_kunmap_data_sg(cmd);
+	}
 
 	if (!ret)
 		target_complete_cmd(cmd, GOOD);
-- 
1.7.2.5
