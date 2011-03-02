From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-FOR-38] target: Fix READ_CAPACITY_16 regression
Date: Wed,  2 Mar 2011 15:52:51 -0800
Message-ID: <1299109971-27268-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm24-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.222]:27191 "HELO
	nm24-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756151Ab1CBXxQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2011 18:53:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Ben Jarvis <bjarvismn@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James,

This patch fixes a regression for READ_CAPACITY to trigger SAI READ_CAPACITY_16 for
>= 0xffffffff virtual backends.  This occured during v4.0.0-rc6 when the backend
read_capacity* handlers where moved into generic target_core_cdb.c code, and the
'unsigned long long blocks_long' piece was dropped from target_emulate_readcapacity().

This fix has been tested with TCM_Loop on .38-rc7 with lio-4.1 and is working as expected
with large block virtual backends:

[67826.897061] TARGET_CORE[loopback]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
[67826.897061] scsi 7:0:1:0: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0 ANSI: 5
[67826.900933] sd 7:0:1:0: [sdd] 2621440000001 512-byte logical blocks: (1.34 PB/1.19 PiB)
[67826.901510] sd 7:0:1:0: [sdd] Write Protect is off
[67826.901684] sd 7:0:1:0: [sdd] Mode Sense: 2f 00 00 00

Please include into scsi-rc-fixes going to Linus for-38 mainline target code.

Reported-by: Ben Jarvis <bjarvismn@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_cdb.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 366080b..7f19c8b 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -667,7 +667,13 @@ target_emulate_readcapacity(struct se_cmd *cmd)
 {
 	struct se_device *dev = SE_DEV(cmd);
 	unsigned char *buf = cmd->t_task->t_task_buf;
-	u32 blocks = dev->transport->get_blocks(dev);
+	unsigned long long blocks_long = dev->transport->get_blocks(dev);
+	u32 blocks;
+
+	if (blocks_long >= 0x00000000ffffffff)
+		blocks = 0xffffffff;
+	else
+		blocks = (u32)blocks_long;
 
 	buf[0] = (blocks >> 24) & 0xff;
 	buf[1] = (blocks >> 16) & 0xff;
-- 
1.5.6.5

