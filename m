From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] SAM-3 status codes
Date: Thu, 23 Jan 2003 10:10:18 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2F24DA.50206@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020109050705050908020802"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-33.triode.net.au [202.147.125.33])
	by iggy.triode.net.au (8.12.7/8.12.7) with ESMTP id h0MN9FvJ010629
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2003 10:09:16 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020109050705050908020802
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The perverse CHECK_CONDITION in include/scsi/scsi.h seems
to have struck again (see "Can't burn DVD under 2.5.59 with
ide-cd" thread on the linux kernel list). Most users of
CHECK_CONDITION found out to their surprise that it is
shifted 1 bit (right) from those values found in the
standards.

The attachment marks the orginal list of SCSI status codes
as deprecated and supplies defines taken from the most
recent SAM-3 draft.

The patch is against 2.5.59 but may also be suitable for
the lk 2.4 tree.

Doug Gilbert

--------------020109050705050908020802
Content-Type: text/plain;
 name="sam_stats_2559.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sam_stats_2559.diff"

--- linux/include/scsi/scsi.h	2002-12-24 18:12:54.000000000 +1100
+++ linux/include/scsi/scsi.h2559sam	2003-01-23 09:54:00.000000000 +1100
@@ -104,7 +104,26 @@
 
 
 /*
- *  Status codes
+ *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
+ *  T10/1561-D Revision 4 Draft dated 7th November 2002.
+ */
+#define SAM_STAT_GOOD            0x00
+#define SAM_STAT_CHECK_CONDITION 0x02
+#define SAM_STAT_CONDITION_MET   0x04
+#define SAM_STAT_BUSY            0x08
+#define SAM_STAT_IMMEDIATE       0x10
+#define SAM_STAT_IMMEDIATE_CONDITION_MET 0x14
+#define SAM_STAT_RESERVATION_CONFLICT 0x18
+#define SAM_STAT_COMMAND_TERMINATED 0x22	/* obsolete in SAM-3 */
+#define SAM_STAT_TASK_SET_FULL   0x28
+#define SAM_STAT_ACA_ACTIVE      0x30
+#define SAM_STAT_TASK_ABORTED    0x40
+
+/*
+ *  Status codes. These are deprecated as they are shifted 1 bit right
+ *  from those found in the SCSI standards. This causes confusion for
+ *  applications that are ported to several OSes. Prefer SAM Status codes
+ *  above.
  */
 
 #define GOOD                 0x00

--------------020109050705050908020802--

