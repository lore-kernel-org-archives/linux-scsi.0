From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Fri, 21 Apr 2006 22:58:44 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0604212255290.3237@poirot.grange>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
 <20060413132932.31871824.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50645 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932467AbWDUU6q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Apr 2006 16:58:46 -0400
In-Reply-To: <20060413132932.31871824.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, lenehan@twibble.org

On Thu, 13 Apr 2006, Randy.Dunlap wrote:

> On Sun, 2 Apr 2006 21:57:43 +0200 (CEST) Guennadi Liakhovetski wrote:
> 
> > + * scsi_kmap_atomic_sg - find and atomically map an sg-elemnt
> 
> s/elemnt/element/

...

> > +/**
> > + * scsi_kunmap_atomic_sg - atomically unmap a virtual address, previously
> > + *			   mapped with scsi_kmap_atomic_sg
> 
> First line of function kernel-doc must be just one line long.  Sorry.  :(
> You can add more descriptive text after the parameter(s) plus one
> blank line if you want to do it that way.

Does the below look good?

James, I hope it will be close enough to your current scsi-misc...

Thanks
Guennadi
---
Guennadi Liakhovetski

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff -ur a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	2006-04-20 00:42:59.000000000 +0200
+++ b/drivers/scsi/scsi_lib.c	2006-04-20 00:17:21.000000000 +0200
@@ -2352,7 +2352,7 @@
 EXPORT_SYMBOL_GPL(scsi_target_unblock);
 
 /**
- * scsi_kmap_atomic_sg - find and atomically map an sg-elemnt
+ * scsi_kmap_atomic_sg - find and atomically map an sg-element
  * @sg:		scatter-gather list
  * @sg_count:	number of segments in sg
  * @offset:	offset in bytes into sg, on return offset into the mapped area
@@ -2398,9 +2398,11 @@
 EXPORT_SYMBOL(scsi_kmap_atomic_sg);
 
 /**
- * scsi_kunmap_atomic_sg - atomically unmap a virtual address, previously
- *			   mapped with scsi_kmap_atomic_sg
+ * scsi_kunmap_atomic_sg - atomically unmap a virtual address
  * @virt:	virtual address to be unmapped
+ *
+ * unmap a virtual address, previously mapped with
+ * scsi_kmap_atomic_sg
  */
 void scsi_kunmap_atomic_sg(void *virt)
 {
