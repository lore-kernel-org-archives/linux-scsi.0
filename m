From: "Jayachandran C." <jchandra@digeo.com>
Subject: [PATCH] Fix issue reported by coverity in drivers/scsi/scsi_ioctl.c
Date: Thu, 27 Oct 2005 15:51:13 -0700
Message-ID: <20051027225113.GE20378@random.pao.digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from packet.digeo.com ([12.110.80.53]:16550 "EHLO packet.digeo.com")
	by vger.kernel.org with ESMTP id S932648AbVJ0WvW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2005 18:51:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, Andrew Morton <akpm@osdl.org>

This patch attempts to fix an issue found in drivers/scsi/scsi_ioctl.c by Coverity.

Error reported: 
CID: 3437
Checker: FORWARD_NULL (help)
File: /export2/p4-coverity/mc2/linux26/drivers/scsi/scsi_ioctl.c
Function: scsi_ioctl_send_command
Description: Variable "buf" tracked as NULL was passed to a function that dereferences it.

Patch description:
buf can be NULL if inlen and outlen are both 0. This patch adds check if the
length is non-zero before calling copy from/to user.

Signed-off-by: Jayachandran C. <c.jayachandran at gmail.com>

---

 scsi_ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.14-rc4-git2.clean/drivers/scsi/scsi_ioctl.c	2005-10-13 11:42:32.000000000 -0700
+++ linux-2.6.14-rc4-git2/drivers/scsi/scsi_ioctl.c	2005-10-26 11:51:50.171230856 -0700
@@ -281,7 +281,7 @@
 	 * Obtain the data to be sent to the device (if any).
 	 */
 
-	if(copy_from_user(buf, cmd_in + cmdlen, inlen))
+	if(inlen && copy_from_user(buf, cmd_in + cmdlen, inlen))
 		goto error;
 
 	switch (opcode) {
@@ -325,7 +325,7 @@
 		if (copy_to_user(cmd_in, sense, sb_len))
 			result = -EFAULT;
 	} else {
-		if (copy_to_user(cmd_in, buf, outlen))
+		if (outlen && copy_to_user(cmd_in, buf, outlen))
 			result = -EFAULT;
 	}	
 
