From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] SCSI: Make megaraid_ioctl() check copy_to_user() return value
Date: Fri, 15 Sep 2006 14:43:11 +0200
Message-ID: <200609151443.12941.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:1806 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751343AbWIOMnb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Sep 2006 08:43:31 -0400
Received: by nf-out-0910.google.com with SMTP id o25so2224475nfa
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2006 05:43:29 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Seokmann Ju <Seokmann.Ju@lsil.com>, Neela Syam Kolli <Neela.Kolli@engenio.com>, linux-scsi@vger.kernel.org, akpm@osdl.org, James.Bottomley@steeleye.com, jesper.juhl@gmail.com


Check copy_to_user() return value in drivers/scsi/megaraid.c::megadev_ioctl()
This gets rid of this little warning:
  drivers/scsi/megaraid.c:3661: warning: ignoring return value of 'copy_to_user', declared with attribute warn_unused_result


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/megaraid.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.18-rc7-git1-orig/drivers/scsi/megaraid.c	2006-09-15 13:51:15.121774000 +0200
+++ linux-2.6.18-rc7-git1/drivers/scsi/megaraid.c	2006-09-15 14:27:32.377407763 +0200
@@ -3658,8 +3658,9 @@ megadev_ioctl(struct inode *inode, struc
 			 * Send the request sense data also, irrespective of
 			 * whether the user has asked for it or not.
 			 */
-			copy_to_user(upthru->reqsensearea,
-					pthru->reqsensearea, 14);
+			if (copy_to_user(upthru->reqsensearea,
+					pthru->reqsensearea, 14))
+				rval = -EFAULT;
 
 freemem_and_return:
 			if( pthru->dataxferlen ) {



