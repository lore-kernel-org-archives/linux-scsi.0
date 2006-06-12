From: Mark Haverkamp <markh@osdl.org>
Subject: RE: [PATCH 1/3] aacraid: Fix return code interpretation (re-update)
Date: Mon, 12 Jun 2006 10:53:58 -0700
Message-ID: <1150134838.5661.7.camel@markh3.pdx.osdl.net>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F028560BD@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:65497 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750715AbWFLRyH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jun 2006 13:54:07 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F028560BD@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-06-09 at 13:10 -0400, Salyzyn, Mark wrote:
> Yes, that is the intent. A 32 bit application is calling a 64 bit
> driver. The pointers in the 32 bit application merely need the virtual
> address upper word zero'd to pass themselves off as 64 bit virtual
> pointers. Yes, the clear_user call could be replaced with an =0 on the
> last element, but it was more generic to clear it out completely before
> copying in the subset. copy_[in|out]_user works with the constructed 64
> bit virtual pointer.
> 
> Sincerely -- Mark Salyzyn

Given Mark's explanation, here is the original patch from last week.
Unless there is a better way to do this.

---

Received from Mark Salyzyn

clear_user return is 0 for success, the code fragment is written to
assume that it is the count of the number of bytes zero'd.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-06-08 09:37:43.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-06-12 10:44:33.000000000 -0700
@@ -564,7 +564,7 @@
 		
 		f = compat_alloc_user_space(sizeof(*f));
 		ret = 0;
-		if (clear_user(f, sizeof(*f)) != sizeof(*f))
+		if (clear_user(f, sizeof(*f)))
 			ret = -EFAULT;
 		if (copy_in_user(f, (void __user *)arg, sizeof(struct fib_ioctl) - sizeof(u32)))
 			ret = -EFAULT;


-- 
Mark Haverkamp <markh@osdl.org>

