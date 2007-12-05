From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in
 directory)
Date: Tue, 4 Dec 2007 16:57:38 -0800
Message-ID: <20071204165738.48003b8a.akpm@linux-foundation.org>
References: <20071128172132.GA30202@schlund.de>
	<20071129123150.GA24851@schlund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbXLEA6N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2007 19:58:13 -0500
In-Reply-To: <20071129123150.GA24851@schlund.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anders Henke <anders.henke@1und1.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, 29 Nov 2007 13:31:50 +0100
Anders Henke <anders.henke@1und1.de> wrote:

> On November 28 2007, Anders Henke wrote:
> > As "everything is reported as being zero" is quite odd an Jan took a
> > guess that it might be block-layer or driver-related, I've assumed
> > that the driver is responsible for this; just out of the curiousity, 
> > I've manually replaced the dpt_i2o driver by the 2.6.19 one by copying 
> > driver/scsi/dpt_i2o.c driver/scsi/dpti.h and driver/scsi/dpt/ into a 
> > vanilla 2.6.23.1. kernel; using this kernel fixed the issue for me.
> > 
> > I haven't yet fine-tested from which kernel release on the dpt_i2o driver 
> > behaves like this and spews out zeroed blocks when trying to mount
> > the rootfs. Maybe this is just some timing issue.
> 
> I've started the fine-tests and can say so far that dpt_i2o from 
> 2.6.22 is still fine. Test is simple:
> 
> anders@ista:/usr/src/linux-2.6.22/drivers/scsi/dpt$ cp -r dpt/ dpt_i2o.c dpti.h /usr/src/linux-2.6.23.1/drivers/scsi/
> 
> ... recompile the kernel, reboot: works.
> 
> 2.6.22 and 2.6.23 differ in terms of the dpt_i2o driver by two different
> patch sets:
> -one 2 Kb small set of patches from 2.6.22 to 2.6.22-rc1
> -one 7 Kb set of patches from 2.6.23-rc2 to 2.6.23-rc3
> -one 162 Kb set of patches from 2.6.23-rc9 to 2.6.23-rc10.
> 
> When applying the 2.6.23-rc1-based driver to "my" 2.6.31.1 kernel,
> the "zero blocks"-symptom show up, so it's the "lucky" situation
> that the smallest patch actually seams to be the broken one.
> 
> According to the 2.6.23-rc1 short-form changelog, there is
> one major edit on the dpt_i2o driver:
> 
> FUJITA Tomonori 
> 
>       [SCSI] dpt_i2o: convert to use the data buffer accessors
> 
> Stephen Rothwell 
>       dpt_i2o depends on virt_to_bus
> 
> Fujita, would you please take a look at this?

He won't have seen this.  cc's added.

> I think that something's broken in there, leading to the dpt_i2o 
> sending out blocks of zeroes right after initialization, at least on
> some specific controllers (in this case, Adaptec 2010S on Intel
> SE7501WV2S-based boxes).
> 
> I don't have insight kernel driver development knowledge, so I'm
> quite out of help right now. Nevertheless, I'll add the diff
> from 2.6.22 to 2.6.23-rc1 in terms of dpt_i2o:
> 

Can you please confirm that this revert (against 2.6.24-rc4) fixes the data
corruption problems?

Thanks.


diff -puN drivers/scsi/dpt_i2o.c~revert-dpt_i2o-convert-to-use-the-data-buffer-accessors drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~revert-dpt_i2o-convert-to-use-the-data-buffer-accessors
+++ a/drivers/scsi/dpt_i2o.c
@@ -2062,13 +2062,12 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pH
 	u32 *lenptr;
 	int direction;
 	int scsidir;
-	int nseg;
 	u32 len;
 	u32 reqlen;
 	s32 rcode;
 
 	memset(msg, 0 , sizeof(msg));
-	len = scsi_bufflen(cmd);
+	len = cmd->request_bufflen;
 	direction = 0x00000000;	
 	
 	scsidir = 0x00000000;			// DATA NO XFER
@@ -2125,21 +2124,21 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pH
 	lenptr=mptr++;		/* Remember me - fill in when we know */
 	reqlen = 14;		// SINGLE SGE
 	/* Now fill in the SGList and command */
+	if(cmd->use_sg) {
+		struct scatterlist *sg = (struct scatterlist *)cmd->request_buffer;
+		int sg_count = pci_map_sg(pHba->pDev, sg, cmd->use_sg,
+				cmd->sc_data_direction);
 
-	nseg = scsi_dma_map(cmd);
-	BUG_ON(nseg < 0);
-	if (nseg) {
-		struct scatterlist *sg;
 
 		len = 0;
-		scsi_for_each_sg(cmd, sg, nseg, i) {
+		for(i = 0 ; i < sg_count; i++) {
 			*mptr++ = direction|0x10000000|sg_dma_len(sg);
 			len+=sg_dma_len(sg);
 			*mptr++ = sg_dma_address(sg);
-			/* Make this an end of list */
-			if (i == nseg - 1)
-				mptr[-2] = direction|0xD0000000|sg_dma_len(sg);
+			sg++;
 		}
+		/* Make this an end of list */
+		mptr[-2] = direction|0xD0000000|sg_dma_len(sg-1);
 		reqlen = mptr - msg;
 		*lenptr = len;
 		
@@ -2148,8 +2147,16 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pH
 				len, cmd->underflow);
 		}
 	} else {
-		*lenptr = len = 0;
-		reqlen = 12;
+		*lenptr = len = cmd->request_bufflen;
+		if(len == 0) {
+			reqlen = 12;
+		} else {
+			*mptr++ = 0xD0000000|direction|cmd->request_bufflen;
+			*mptr++ = pci_map_single(pHba->pDev,
+				cmd->request_buffer,
+				cmd->request_bufflen,
+				cmd->sc_data_direction);
+		}
 	}
 	
 	/* Stick the headers on */
@@ -2178,7 +2185,7 @@ static s32 adpt_i2o_to_scsi(void __iomem
 	hba_status = detailed_status >> 8;
 
 	// calculate resid for sg 
-	scsi_set_resid(cmd, scsi_bufflen(cmd) - readl(reply+5));
+	cmd->resid = cmd->request_bufflen - readl(reply+5);
 
 	pHba = (adpt_hba*) cmd->device->host->hostdata[0];
 
_

