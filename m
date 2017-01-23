From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 09/24] aacraid: Added support for read medium error
Date: Mon, 23 Jan 2017 10:08:53 -0800
Message-ID: <20170123180908.3465-10-RaghavaAditya.Renukunta@microsemi.com>
References: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0077.outbound.protection.outlook.com ([104.47.34.77]:55013
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751293AbdAXArB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Jan 2017 19:47:01 -0500
In-Reply-To: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Banesh@microsemi.com

This patch processes Raw IO read medium errors.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c  | 10 ++++++++++
 drivers/scsi/aacraid/aacraid.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 5465c8a..e762c7b 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -62,6 +62,7 @@
 #define SENCODE_END_OF_DATA			0x00
 #define SENCODE_BECOMING_READY			0x04
 #define SENCODE_INIT_CMD_REQUIRED		0x04
+#define SENCODE_UNRECOVERED_READ_ERROR		0x11
 #define SENCODE_PARAM_LIST_LENGTH_ERROR		0x1A
 #define SENCODE_INVALID_COMMAND			0x20
 #define SENCODE_LBA_OUT_OF_RANGE		0x21
@@ -1994,6 +1995,15 @@ static void io_callback(void *context, struct fib * fibptr)
 		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
 			     SCSI_SENSE_BUFFERSIZE));
 		break;
+	case ST_MEDERR:
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+			SAM_STAT_CHECK_CONDITION;
+		set_sense(&dev->fsa_dev[cid].sense_data, MEDIUM_ERROR,
+		  SENCODE_UNRECOVERED_READ_ERROR, ASENCODE_NO_SENSE, 0, 0);
+		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
+		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
+			     SCSI_SENSE_BUFFERSIZE));
+		break;
 	default:
 #ifdef AAC_DETAILED_STATUS_INFO
 		printk(KERN_WARNING "io_callback: io failed, status = %d\n",
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index f749215..fb46252 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1462,6 +1462,7 @@ struct aac_dev
 #define		ST_IO		5
 #define		ST_NXIO		6
 #define		ST_E2BIG	7
+#define		ST_MEDERR	8
 #define		ST_ACCES	13
 #define		ST_EXIST	17
 #define		ST_XDEV		18
-- 
2.7.4

