From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 07/17] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
Date: Sun, 19 Jan 2014 02:44:30 +0000
Message-ID: <1390099480-29013-8-git-send-email-nab@daterainc.com>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates sbc_emulate_readcapacity_16() to set
P_TYPE and PROT_EN bits when DIF emulation is enabled by
the backend device.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 26e8bfb..75364c7 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -106,6 +106,11 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 	buf[9] = (dev->dev_attrib.block_size >> 16) & 0xff;
 	buf[10] = (dev->dev_attrib.block_size >> 8) & 0xff;
 	buf[11] = dev->dev_attrib.block_size & 0xff;
+	/*
+	 * Set P_TYPE and PROT_EN bits for DIF support
+	 */
+	if (dev->dev_attrib.pi_prot_type)
+		buf[12] = (dev->dev_attrib.pi_prot_type - 1) << 1 | 0x1;
 
 	if (dev->transport->get_lbppbe)
 		buf[13] = dev->transport->get_lbppbe(dev) & 0x0f;
-- 
1.7.10.4
