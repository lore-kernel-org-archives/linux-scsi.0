From: akpm@osdl.org
Subject: [patch 4/5] Fix issue reported by coverity in drivers/scsi/scsi_ioctl.c
Date: Fri, 28 Oct 2005 15:07:51 -0700
Message-ID: <200510282207.j9SM7XKW022284@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:48310 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030263AbVJ1WHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 18:07:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, jchandra@digeo.com, c.jayachandran@gmail.com


From: "Jayachandran C." <jchandra@digeo.com>

This patch attempts to fix an issue found in drivers/scsi/scsi_ioctl.c by
Coverity.

Error reported:
CID: 3437
Checker: FORWARD_NULL (help)
File: /export2/p4-coverity/mc2/linux26/drivers/scsi/scsi_ioctl.c
Function: scsi_ioctl_send_command
Description: Variable "buf" tracked as NULL was passed to a function that dereferences it.

Patch description:
buf can be NULL if inlen and outlen are both 0. This patch adds check if the
length is non-zero before calling copy from/to user.

Signed-off-by: Jayachandran C. <c.jayachandran@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/scsi_ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_ioctl.c~fix-issue-reported-by-coverity-in-drivers-scsi-scsi_ioctlc drivers/scsi/scsi_ioctl.c
--- 25/drivers/scsi/scsi_ioctl.c~fix-issue-reported-by-coverity-in-drivers-scsi-scsi_ioctlc	Fri Oct 28 15:06:39 2005
+++ 25-akpm/drivers/scsi/scsi_ioctl.c	Fri Oct 28 15:06:39 2005
@@ -281,7 +281,7 @@ int scsi_ioctl_send_command(struct scsi_
 	 * Obtain the data to be sent to the device (if any).
 	 */
 
-	if(copy_from_user(buf, cmd_in + cmdlen, inlen))
+	if(inlen && copy_from_user(buf, cmd_in + cmdlen, inlen))
 		goto error;
 
 	switch (opcode) {
@@ -325,7 +325,7 @@ int scsi_ioctl_send_command(struct scsi_
 		if (copy_to_user(cmd_in, sense, sb_len))
 			result = -EFAULT;
 	} else {
-		if (copy_to_user(cmd_in, buf, outlen))
+		if (outlen && copy_to_user(cmd_in, buf, outlen))
 			result = -EFAULT;
 	}	
 
_
