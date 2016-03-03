From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] sg: fix dxferp in from_to case
Date: Thu, 3 Mar 2016 00:31:29 -0500
Message-ID: <56D7CC31.3070800@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000308000709040902060106"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:57181 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbcCCFbe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Mar 2016 00:31:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, dvyukov@google.com

This is a multi-part message in MIME format.
--------------000308000709040902060106
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

This patch is in response to this report:
    http://www.spinics.net/lists/linux-scsi/msg93456.html

One of the strange things that the original sg driver did was let
the user provide both a data-out buffer (it followed the
sg_header+cdb) _and_ specify a reply length greater than zero. What
happened was that the user data-out buffer was copied into some
kernel buffers and then the mid level was told a read type operation
would take place with the data from the device overwriting the same
kernel buffers. The user would then read those kernel buffers back
into the user space.

 From what I can tell, the above action was broken by a change in
2008 and syzkaller found that out recently.

    ChangeLog:
       make sure that a user space pointer is passed through
       when data follows the sg_header structure and command.
       Fix the abnormal case when a non-zero reply_len is also
       given.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------000308000709040902060106
Content-Type: text/x-patch;
 name="sg_null_deref.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg_null_deref.patch"

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5e82067..ae7d9bd 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -652,7 +652,8 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	else
 		hp->dxfer_direction = (mxsize > 0) ? SG_DXFER_FROM_DEV : SG_DXFER_NONE;
 	hp->dxfer_len = mxsize;
-	if (hp->dxfer_direction == SG_DXFER_TO_DEV)
+	if ((hp->dxfer_direction == SG_DXFER_TO_DEV) ||
+	    (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV))
 		hp->dxferp = (char __user *)buf + cmd_size;
 	else
 		hp->dxferp = NULL;

--------------000308000709040902060106--
