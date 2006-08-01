From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/4] qla2xxx: Log Trace/Diagonostic asynchronous events.
Date: Tue,  1 Aug 2006 13:48:14 -0700
Message-ID: <11544652961436-git-send-email-andrew.vasquez@qlogic.com>
References: <20060801204542.GR4154@jdlab1.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:35231 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1750714AbWHAUtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 16:49:18 -0400
In-Reply-To: <20060801204542.GR4154@jdlab1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_isr.c |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 139ea0e..0930260 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -487,6 +487,7 @@ #define MBA_IP_LOW_WATER_MARK	0x8025	/* 
 #define MBA_IP_RCV_BUFFER_EMPTY 0x8026	/* IP receive buffer queue empty. */
 #define MBA_IP_HDR_DATA_SPLIT	0x8027	/* IP header/data splitting feature */
 					/* used. */
+#define MBA_TRACE_NOTIFICATION	0x8028	/* Trace/Diagnostic notification. */
 #define MBA_POINT_TO_POINT	0x8030	/* Point to point mode. */
 #define MBA_CMPLT_1_16BIT	0x8031	/* Completion 1 16bit IOSB. */
 #define MBA_CMPLT_2_16BIT	0x8032	/* Completion 2 16bit IOSB. */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 795bf15..de06131 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -587,6 +587,11 @@ #define LS_UNKNOWN	2
 		DEBUG2(printk("scsi(%ld): Discard RND Frame -- %04x %04x "
 		    "%04x.\n", ha->host_no, mb[1], mb[2], mb[3]));
 		break;
+
+	case MBA_TRACE_NOTIFICATION:
+		DEBUG2(printk("scsi(%ld): Trace Notification -- %04x %04x.\n",
+		ha->host_no, mb[1], mb[2]));
+		break;
 	}
 }
 
-- 
1.4.2.rc2.gbc9e

