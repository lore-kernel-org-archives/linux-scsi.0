From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: IO buffer alignment for block devices
Date: Mon, 13 Sep 2004 20:12:34 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0409131952170.4529@kai.makisara.local>
References: <41459729.5060106@il.marvell.com> <1095084876.1762.8.camel@mulgrave>
  <4145B9DF.7020408@il.marvell.com> <1095089305.1762.73.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:47067 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S268086AbUIMRMf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 13:12:35 -0400
In-Reply-To: <1095089305.1762.73.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Saeed Bishara <Saeed.Bishara@il.marvell.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 13 Sep 2004, James Bottomley wrote:

> On Mon, 2004-09-13 at 11:16, Saeed Bishara wrote:
> >     isn't the default 512, this is what I see in blk_queue_make_request.
> > 
> > <http://lxr.linux.no/ident?v=2.6.8.1;i=blk_queue_make_request>
> 
> In the block layer, yes.  In SCSI we tune that down to be 8 for backward
> compatibility with 2.4, I think, but LLDs can tune it up again.
> 
We don't. The alignment has been 512 bytes after this patch in 2.6.4:

<James.Bottomley@SteelEye.com>
        [PATCH] Undo SCSI 8-byte alignment relaxation
        
        This makes the default alignment requirements be 512 bytes for SCSI,
        the way it used to be.
        
        Jens will fix the SCSI layer problems, but low-level drivers might have
        other restrictions on alignment.

As you can guess, I have not been too happy with this situation ;-)

Any driver can change this restriction in slave_configure(). I have for 
some time had the following patch in my system to change the alignment for 
my tape drive to 8 bytes:

--- linux-2.6.9-rc1-bk1/drivers/scsi/sym53c8xx_2/sym_glue.c~	2004-08-27 19:33:34.000000000 +0300
+++ linux-2.6.9-rc1-bk1/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-08-28 12:54:49.000000000 +0300
@@ -1097,6 +1097,8 @@
 
 	spi_dv_device(device);
 
+	blk_queue_dma_alignment(device->request_queue, 7);
+
 	return 0;
 }
 

-- 
Kai
