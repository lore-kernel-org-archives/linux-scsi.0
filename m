From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: 2 KiB/block loopback found where
Date: 29 Sep 2003 11:12:50 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064855570.3184.3.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2>
	 <20030929164654.GS15415@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:40424 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263752AbTI2RMf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 13:12:35 -0400
In-Reply-To: <20030929164654.GS15415@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

> > I want a 2 KiB/block loopback device ...
> > I get 0.5 KiB/block ...
> > 0.5 KiB divides evenly into 2 KiB.
>
> Add a quick hack to loop
> to set 2kb block size,
> grep for set_blocksize.

Great hint forward, thanks.  My first guess at what we mean follows,
I'll report back to say how this goes.

Pat LaVarre

diff -Nur linux-2.6.0-test6/drivers/block/loop.c linux/drivers/block/loop.c 

--- linux-2.6.0-test6/drivers/block/loop.c	2003-09-27 18:50:29.000000000 -0600
+++ linux/drivers/block/loop.c	2003-09-29 11:06:50.057826432 -0600
@@ -732,7 +732,7 @@
 	mapping_set_gfp_mask(inode->i_mapping,
 			     lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
 
-	set_blocksize(bdev, lo_blocksize);
+	set_blocksize(bdev, 0x800); // not lo_blocksize);
 
 	lo->lo_bio = lo->lo_biotail = NULL; 


