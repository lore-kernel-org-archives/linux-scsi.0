From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 08/17] target/spc: Expose ATO bit in control mode page
Date: Sun, 19 Jan 2014 02:44:31 +0000
Message-ID: <1390099480-29013-9-git-send-email-nab@daterainc.com>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44556 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaASDF0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2014 22:05:26 -0500
In-Reply-To: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates spc_modesense_control() to set the Application
Tag Owner (ATO) bit when when DIF emulation is enabled by the
backend device.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_spc.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 73fdff5..43c5ca98 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -858,6 +858,19 @@ static int spc_modesense_control(struct se_device *dev, u8 pc, u8 *p)
 	 * status (see SAM-4).
 	 */
 	p[5] = (dev->dev_attrib.emulate_tas) ? 0x40 : 0x00;
+	/*
+	 * From spc4r30, section 7.5.7 Control mode page
+	 *
+	 * Application Tag Owner (ATO) bit set to one.
+	 *
+	 * If the ATO bit is set to one the device server shall not modify the
+	 * LOGICAL BLOCK APPLICATION TAG field and, depending on the protection
+	 * type, shall not modify the contents of the LOGICAL BLOCK REFERENCE
+	 * TAG field.
+	 */
+	if (dev->dev_attrib.pi_prot_type)
+		p[5] |= 0x80;
+
 	p[8] = 0xff;
 	p[9] = 0xff;
 	p[11] = 30;
-- 
1.7.10.4

