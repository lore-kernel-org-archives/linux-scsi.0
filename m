From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove CONFIG_LBD ifdefs from fusion
Date: Sun, 4 Jul 2004 16:18:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040704141809.GA17577@lst.de>
References: <20040531115348.GB16143@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:18147 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265690AbUGDOSO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jul 2004 10:18:14 -0400
Content-Disposition: inline
In-Reply-To: <20040531115348.GB16143@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org

On Mon, May 31, 2004 at 01:53:48PM +0200, Christoph Hellwig wrote:
> The CONFIG_LBD case is also fine for !CONFIG_LBD, just a bit more
> complicated in the source (but the compile optimizes that away -
> ->bios_param isn't exactly a fast-path either..)

Still doesn't seem to be merged.  Here's the patch again:

--- 1.41/drivers/message/fusion/mptscsih.c	2004-05-29 17:10:51 +02:00
+++ edited/drivers/message/fusion/mptscsih.c	2004-05-31 13:07:29 +02:00
@@ -3195,19 +3099,14 @@
 	int		heads;
 	int		sectors;
 	sector_t	cylinders;
-#ifdef CONFIG_LBD
 	ulong 		dummy;
-#endif
 
 	heads = 64;
 	sectors = 32;
-#ifdef CONFIG_LBD
+
 	dummy = heads * sectors;
 	cylinders = capacity;
 	sector_div(cylinders,dummy);
-#else
-	cylinders = (ulong)capacity / (heads * sectors);
-#endif
 
 	/*
 	 * Handle extended translation size for logical drives
@@ -3216,13 +3115,9 @@
 	if ((ulong)capacity >= 0x200000) {
 		heads = 255;
 		sectors = 63;
-#ifdef CONFIG_LBD
 		dummy = heads * sectors;
 		cylinders = capacity;
 		sector_div(cylinders,dummy);
-#else
-		cylinders = (ulong)capacity / (heads * sectors);
-#endif
 	}
 
 	/* return result */
