From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: fix prevent_allow+verify regressions
Date: Mon, 06 Apr 2015 11:05:41 -0400
Message-ID: <5522A0C5.9030804@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060601020804080505090706"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:42544 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbbDFPGK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Apr 2015 11:06:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, jbottomley@odin.com
Cc: util-linux@vger.kernel.org, sweet_f_a@gmx.de

This is a multi-part message in MIME format.
--------------060601020804080505090706
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Ruediger Meier observed a regression with the PREVENT ALLOW
MEDIUM REMOVAL command in lk 3.19:
   http://www.spinics.net/lists/util-linux-ng/msg11448.html

Inspection indicated the same regression with VERIFY(10).

The patch is against lk 3.19.3 and also works with lk 4.0.0-rc6.
With this patch both commands are accepted and do nothing.
VERIFY(10) could be implemented since it shares logic with
COMPARE AND WRITE which is implemented; however that would
be an enhancement.

ChangeLog:
   - fix the lk 3.19 regression so that the PREVENT ALLOW
     MEDIUM REMOVAL command is supported once again
   - same fix for VERIFY(10)

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------060601020804080505090706
Content-Type: text/x-patch;
 name="sdebug319regr1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sdebug319regr1.patch"

--- a/drivers/scsi/scsi_debug.c	2015-02-11 17:47:09.276206425 -0500
+++ b/drivers/scsi/scsi_debug.c	2015-04-03 22:42:36.343971372 -0400
@@ -455,8 +455,9 @@ static const struct opcode_info_t opcode
 	     0} },
 	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* MAINT OUT */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
-	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* VERIFY */
-	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0x2f, 0, F_D_OUT_MAYBE | FF_DIRECT_IO, NULL, NULL, /* VERIFY(10) */
+	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc7,
+	     0, 0, 0, 0, 0, 0} },
 	{1, 0x7f, 0x9, F_SA_HIGH | F_D_IN | FF_DIRECT_IO, resp_read_dt0,
 	    vl_iarr, {32,  0xc7, 0, 0, 0, 0, 0x1f, 0x18, 0x0, 0x9, 0xfe, 0,
 		      0xff, 0xff, 0xff, 0xff} },/* VARIABLE LENGTH, READ(32) */
@@ -467,8 +468,8 @@ static const struct opcode_info_t opcode
 	    {10,  0x13, 0xff, 0xff, 0, 0, 0, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0,
 	     0} },
 /* 20 */
-	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* ALLOW REMOVAL */
-	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0x1e, 0, 0, NULL, NULL, /* ALLOW REMOVAL */
+	    {6,  0, 0, 0, 0x3, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0x1, 0, 0, resp_start_stop, NULL, /* REWIND ?? */
 	    {6,  0x1, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* ATA_PT */

--------------060601020804080505090706--
