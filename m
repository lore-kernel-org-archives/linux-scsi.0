From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Don't blatt first element of prv in sg_chain()
Date: Mon, 7 Jan 2008 15:38:42 +1100
Message-ID: <200801071538.43371.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:54559 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbYAGEjB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jan 2008 23:39:01 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

I realize that sg chaining is a ploy to make the rest of the kernel
devs feel the pain of the SCSI subsystem.  But this was a little
unsubtle.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r b3aec596b841 include/linux/scatterlist.h
--- a/include/linux/scatterlist.h	Mon Jan 07 12:43:56 2008 +1100
+++ b/include/linux/scatterlist.h	Mon Jan 07 15:01:51 2008 +1100
@@ -188,8 +188,8 @@ static inline void sg_chain(struct scatt
 	/*
 	 * offset and length are unused for chain entry.  Clear them.
 	 */
-	prv->offset = 0;
-	prv->length = 0;
+	prv[prv_nents - 1].offset = 0;
+	prv[prv_nents - 1].length = 0;
 
 	/*
 	 * Set lowest bit to indicate a link pointer, and make sure to clear
