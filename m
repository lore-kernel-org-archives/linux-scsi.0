From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Correct typo in linux/scsi/scsi.h and introduce new
	scsi_status_is_good macro
Date: 08 May 2003 10:15:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052403312.2097.35.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-6eOBL2twQohn7REnkQRn"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:31750 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261564AbTEHOCl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2003 10:02:41 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id h48EFCI32103
	for <linux-scsi@vger.kernel.org>; Thu, 8 May 2003 10:15:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-6eOBL2twQohn7REnkQRn
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I notice we seem to have a typo in the SAM_ status codes (they say
IMMEDIATE where they mean INTERMEDIATE).

I've also introduced a new macro who's job is to return true if any of
the possible good return codes is found.  This means

SAM_STAT_GOOD
SAM_STAT_INTERMEDIATE
SAM_STAT_INTERMEDIATE_CONDITION_MET

and for now

SAM_STAT_COMMAND_TERMINATED

By and large, this is currently irrelevant to us, since we don't use
linked commands and I've never met a device using COMMAND TERMINATED,
but it may help us in the future.

James


--=-6eOBL2twQohn7REnkQRn
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D include/scsi/scsi.h 1.9 vs edited =3D=3D=3D=3D=3D
--- 1.9/include/scsi/scsi.h	Thu Jan 23 10:50:27 2003
+++ edited/include/scsi/scsi.h	Thu May  8 10:09:33 2003
@@ -111,13 +111,38 @@
 #define SAM_STAT_CHECK_CONDITION 0x02
 #define SAM_STAT_CONDITION_MET   0x04
 #define SAM_STAT_BUSY            0x08
-#define SAM_STAT_IMMEDIATE       0x10
-#define SAM_STAT_IMMEDIATE_CONDITION_MET 0x14
+#define SAM_STAT_INTERMEDIATE    0x10
+#define SAM_STAT_INTERMEDIATE_CONDITION_MET 0x14
 #define SAM_STAT_RESERVATION_CONFLICT 0x18
 #define SAM_STAT_COMMAND_TERMINATED 0x22	/* obsolete in SAM-3 */
 #define SAM_STAT_TASK_SET_FULL   0x28
 #define SAM_STAT_ACA_ACTIVE      0x30
 #define SAM_STAT_TASK_ABORTED    0x40
+
+/** scsi_status_is_good - check the status return.
+ *
+ * @status: the status passed up from the driver (including host and
+ *          driver components)
+ *
+ * This returns true for known good conditions that may be treated as
+ * command completed normally
+ */
+static inline int scsi_status_is_good(int status)
+{
+	/* mask out the relevant bits
+	 *
+	 * FIXME: bit0 is listed as reserved in SCSI-2, but is
+	 * significant in SCSI-3.  For now, we follow the SCSI-2
+	 * behaviour and ignore reserved bits. */
+=09
+	status &=3D 0xfe;
+
+	return ((status & SAM_STAT_GOOD)
+		|| (status & SAM_STAT_INTERMEDIATE)
+		|| (status & SAM_STAT_INTERMEDIATE_CONDITION_MET)
+		/* FIXME: this is obsolete in SAM-3 */
+		|| (status & SAM_STAT_COMMAND_TERMINATED));
+}
=20
 /*
  *  Status codes. These are deprecated as they are shifted 1 bit right

--=-6eOBL2twQohn7REnkQRn--

