From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 06/14] target/spc: Add protection related bits to INQUIRY EVPD=0x86
Date: Wed,  8 Jan 2014 20:15:49 +0000
Message-ID: <1389212157-14540-7-git-send-email-nab@daterainc.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates spc_emulate_evpd_86() (extended INQUIRY) to
report GRD_CHK (Guard Check) and REF_CHK (Reference Check) bits
when DIF emulation is enabled by the backend device.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_spc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 6b06f01..d99eb95 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -441,6 +441,15 @@ spc_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
 	struct se_device *dev = cmd->se_dev;
 
 	buf[3] = 0x3c;
+	/*
+	 * Set GRD_CHK + REF_CHK for TYPE1 protection, or GRD_CHK
+	 * only for TYPE3 protection.
+	 */
+	if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE1_PROT)
+		buf[4] = 0x5;
+	else if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE3_PROT)
+		buf[4] = 0x4;
+
 	/* Set HEADSUP, ORDSUP, SIMPSUP */
 	buf[5] = 0x07;
 
-- 
1.7.10.4
