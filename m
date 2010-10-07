From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 08/15] qla4xxx: Add support for 8130/8131 AENs.
Date: Wed, 6 Oct 2010 22:49:40 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8712940678B@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:37549 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab0JGFtn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:49:43 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Shyam Sundar <shyam.sundar@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Shyam Sundar <shyam.sundar@qlogic.com>

AEN 8130 Corresponds to an event representing the insertion (detection)
of a transceiver. It also reports the type of the SFP+.
AEN 8131 corresponds to the removal of a transceiver.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Shyam Sundar <shyam.sundar@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h  |    2 ++
 drivers/scsi/qla4xxx/ql4_isr.c |   12 ++++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 0336c6d..d65dac4 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -416,6 +416,8 @@ struct qla_flt_region {
 #define MBOX_ASTS_IPV6_ND_PREFIX_IGNORED	0x802C
 #define MBOX_ASTS_IPV6_LCL_PREFIX_IGNORED	0x802D
 #define MBOX_ASTS_ICMPV6_ERROR_MSG_RCVD		0x802E
+#define MBOX_ASTS_TXSCVR_INSERTED		0x8130
+#define MBOX_ASTS_TXSCVR_REMOVED		0x8131
 
 #define ISNS_EVENT_DATA_RECEIVED		0x0000
 #define ISNS_EVENT_CONNECTION_OPENED		0x0001
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 1076fbf..a5fa655 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -621,6 +621,18 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			}
 			break;
 
+		case MBOX_ASTS_TXSCVR_INSERTED:
+			DEBUG2(printk(KERN_WARNING
+			    "scsi%ld: AEN %04x Transceiver"
+			    " inserted\n",  ha->host_no, mbox_sts[0]));
+			break;
+
+		case MBOX_ASTS_TXSCVR_REMOVED:
+			DEBUG2(printk(KERN_WARNING
+			    "scsi%ld: AEN %04x Transceiver"
+			    " removed\n",  ha->host_no, mbox_sts[0]));
+			break;
+
 		default:
 			DEBUG2(printk(KERN_WARNING
 				      "scsi%ld: AEN %04x UNKNOWN\n",
-- 
1.6.6

