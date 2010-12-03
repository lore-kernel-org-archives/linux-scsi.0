From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 08/12] qla4xxx: cache new IP address acquired via DHCP
Date: Thu, 2 Dec 2010 22:12:43 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872243F411F@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:3258 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab0LCGMp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 01:12:45 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Prasanna Mumbai <prasanna.mumbai@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Prasanna Mumbai <prasanna.mumbai@qlogic.com>

Prior to firmware state change from ACQUIRING to READY, an
0x8029 AEN is received. Added code to check previous state
being ACQUIRING in order to update the ip address in the driver.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Prasanna Mumbai <prasanna.mumbai@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_isr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index ca862b1..90a217f 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -554,7 +554,8 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			/* mbox_sts[2] = Old ACB state
 			 * mbox_sts[3] = new ACB state */
 			if ((mbox_sts[3] == ACB_STATE_VALID) &&
-			    (mbox_sts[2] == ACB_STATE_TENTATIVE))
+			    ((mbox_sts[2] == ACB_STATE_TENTATIVE) ||
+			    (mbox_sts[2] == ACB_STATE_ACQUIRING)))
 				set_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags);
 			else if ((mbox_sts[3] == ACB_STATE_ACQUIRING) &&
 			    (mbox_sts[2] == ACB_STATE_VALID))
-- 
1.7.3.2

