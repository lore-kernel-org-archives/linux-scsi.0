From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] target: Fix zero-length READ_CAPACITY_16 regression
Date: Tue, 29 Jan 2013 22:26:15 +0000
Message-ID: <1359498375-8040-4-git-send-email-nab@linux-iscsi.org>
References: <1359498375-8040-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1359498375-8040-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Roland Dreier <roland@purestorage.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a regression introduced in v3.8-rc1 code where a
zero-length READ_CAPACITY_16 was no longer returning GOOD status, but
instead returning TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE to generate
a CHECK_CONDITION status.

This regression was introduced with the following commit:

  commit de103c93aff0bed0ae984274e5dc8b95899badab
  Author: Christoph Hellwig <hch@lst.de>
  Date:   Tue Nov 6 12:24:09 2012 -0800

      target: pass sense_reason as a return value

and this patch has been tested with the following zero-length CDB:

  sg_raw /dev/sdd 9e 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  SCSI Status: Good

  Sense Information:
  sense buffer empty

Also, convert sbc_emulate_readcapacity() to follow the same method
of handling transport_kmap_data_sg() return values, but we never
expect a zero-length request here.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 26a6d18..a664c66 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -58,11 +58,10 @@ sbc_emulate_readcapacity(struct se_cmd *cmd)
 	buf[7] = dev->dev_attrib.block_size & 0xff;
 
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
 
 	target_complete_cmd(cmd, GOOD);
 	return 0;
@@ -97,11 +96,10 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 		buf[14] = 0x80;
 
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
 
 	target_complete_cmd(cmd, GOOD);
 	return 0;
-- 
1.7.2.5
