From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH 4/4] scsi_debug: Implement WRITE BUFFER command
Date: Thu,  4 Dec 2014 11:49:28 -0500
Message-ID: <1417711768-24167-5-git-send-email-emilne@redhat.com>
References: <1417711768-24167-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092AbaLDQtc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 11:49:32 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sB4GnWGH009485
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2014 11:49:32 -0500
Received: from emilne.csb ([10.18.25.104])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sB4GnUgG011313
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2014 11:49:32 -0500
In-Reply-To: <1417711768-24167-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Accept the WRITE BUFFER command and do nothing other than
set the appropriate "microcode has been changed" UA on the LU.

>From an earlier patch by Doug Gilbert.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 74 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 648abf2..5ac04d6 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -93,6 +93,8 @@ static const char *scsi_debug_version_date = "20141022";
 #define THRESHOLD_EXCEEDED 0x5d
 #define LOW_POWER_COND_ON 0x5e
 #define MISCOMPARE_VERIFY_ASC 0x1d
+#define MICROCODE_CHANGED_ASCQ 0x1	/* with TARGET_CHANGED_ASC */
+#define MICROCODE_CHANGED_WO_RESET_ASCQ 0x16
 
 /* Additional Sense Code Qualifier (ASCQ) */
 #define ACK_NAK_TO 0x3
@@ -184,7 +186,9 @@ static const char *scsi_debug_version_date = "20141022";
 #define SDEBUG_UA_MODE_CHANGED 2
 #define SDEBUG_UA_CAPACITY_CHANGED 3
 #define SDEBUG_UA_LUNS_CHANGED 4
-#define SDEBUG_NUM_UAS 5
+#define SDEBUG_UA_MICROCODE_CHANGED 5	/* simulate firmware change */
+#define SDEBUG_UA_MICROCODE_CHANGED_WO_RESET 6
+#define SDEBUG_NUM_UAS 7
 
 /* for check_readiness() */
 #define UAS_ONLY 1	/* check for UAs only */
@@ -330,6 +334,7 @@ static int resp_write_same_10(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_same_16(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_xdwriteread_10(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_comp_write(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_write_buffer(struct scsi_cmnd *, struct sdebug_dev_info *);
 
 struct opcode_info_t {
 	u8 num_attached;	/* 0 if this is it (i.e. a leaf); use 0xff
@@ -484,8 +489,9 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	{0, 0x53, 0, F_D_IN | F_D_OUT | FF_DIRECT_IO, resp_xdwriteread_10,
 	    NULL, {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xc7,
 		   0, 0, 0, 0, 0, 0} },
-	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* WRITE_BUFFER */
-	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0x3b, 0, F_D_OUT_MAYBE, resp_write_buffer, NULL,
+	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc7, 0, 0,
+	     0, 0, 0, 0} },			/* WRITE_BUFFER */
 	{1, 0x41, 0, F_D_OUT_MAYBE | FF_DIRECT_IO, resp_write_same_10,
 	    write_same_iarr, {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff,
 			      0xff, 0xc7, 0, 0, 0, 0, 0, 0} },
@@ -837,6 +843,19 @@ static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
 			if (debug)
 				cp = "capacity data changed";
 			break;
+		case SDEBUG_UA_MICROCODE_CHANGED:
+			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
+				 TARGET_CHANGED_ASC, MICROCODE_CHANGED_ASCQ);
+			if (debug)
+				cp = "microcode has been changed";
+			break;
+		case SDEBUG_UA_MICROCODE_CHANGED_WO_RESET:
+			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
+					TARGET_CHANGED_ASC,
+					MICROCODE_CHANGED_WO_RESET_ASCQ);
+			if (debug)
+				cp = "microcode has been changed without reset";
+			break;
 		case SDEBUG_UA_LUNS_CHANGED:
 			/*
 			 * SPC-3 behavior is to report a UNIT ATTENTION with
@@ -3070,6 +3089,55 @@ resp_write_same_16(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return resp_write_same(scp, lba, num, ei_lba, unmap, ndob);
 }
 
+/* Note the mode field is in the same position as the (lower) service action
+ * field. For the Report supported operation codes command, SPC-4 suggests
+ * each mode of this command should be reported separately; for future. */
+static int
+resp_write_buffer(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	u8 *cmd = scp->cmnd;
+	struct scsi_device *sdp = scp->device;
+	struct sdebug_dev_info *dp;
+	u8 mode;
+
+	mode = cmd[1] & 0x1f;
+	switch (mode) {
+	case 0x4:	/* download microcode (MC) and activate (ACT) */
+		/* set UAs on this device only */
+		set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+		set_bit(SDEBUG_UA_MICROCODE_CHANGED, devip->uas_bm);
+		break;
+	case 0x5:	/* download MC, save and ACT */
+		set_bit(SDEBUG_UA_MICROCODE_CHANGED_WO_RESET, devip->uas_bm);
+		break;
+	case 0x6:	/* download MC with offsets and ACT */
+		/* set UAs on most devices (LUs) in this target */
+		list_for_each_entry(dp,
+				    &devip->sdbg_host->dev_info_list,
+				    dev_list)
+			if (dp->target == sdp->id) {
+				set_bit(SDEBUG_UA_BUS_RESET, dp->uas_bm);
+				if (devip != dp)
+					set_bit(SDEBUG_UA_MICROCODE_CHANGED,
+						dp->uas_bm);
+			}
+		break;
+	case 0x7:	/* download MC with offsets, save, and ACT */
+		/* set UA on all devices (LUs) in this target */
+		list_for_each_entry(dp,
+				    &devip->sdbg_host->dev_info_list,
+				    dev_list)
+			if (dp->target == sdp->id)
+				set_bit(SDEBUG_UA_MICROCODE_CHANGED_WO_RESET,
+					dp->uas_bm);
+		break;
+	default:
+		/* do nothing for this command for other mode values */
+		break;
+	}
+	return 0;
+}
+
 static int
 resp_comp_write(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
-- 
1.7.11.7

