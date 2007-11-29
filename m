From: Jan Kara <jack@ucw.cz>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in directory) (fwd)
Date: Thu, 29 Nov 2007 14:03:19 +0100
Message-ID: <20071129130319.GA2642@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37905 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762787AbXK2NDU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Nov 2007 08:03:20 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp
Cc: Anders Henke <anders.henke@1und1.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

  Adding relevant people and lists to CC...

									Honza

----- Forwarded message from Anders Henke <anders.henke@1und1.de> -----

Date:	Thu, 29 Nov 2007 13:31:50 +0100
From: Anders Henke <anders.henke@1und1.de>
To: linux-kernel@vger.kernel.org
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in directory)
User-Agent: Mutt/1.5.13 (2006-08-11)

On November 28 2007, Anders Henke wrote:
> As "everything is reported as being zero" is quite odd an Jan took a
> guess that it might be block-layer or driver-related, I've assumed
> that the driver is responsible for this; just out of the curiousity, 
> I've manually replaced the dpt_i2o driver by the 2.6.19 one by copying 
> driver/scsi/dpt_i2o.c driver/scsi/dpti.h and driver/scsi/dpt/ into a 
> vanilla 2.6.23.1. kernel; using this kernel fixed the issue for me.
> 
> I haven't yet fine-tested from which kernel release on the dpt_i2o driver 
> behaves like this and spews out zeroed blocks when trying to mount
> the rootfs. Maybe this is just some timing issue.

I've started the fine-tests and can say so far that dpt_i2o from 
2.6.22 is still fine. Test is simple:

anders@ista:/usr/src/linux-2.6.22/drivers/scsi/dpt$ cp -r dpt/ dpt_i2o.c dpti.h /usr/src/linux-2.6.23.1/drivers/scsi/

... recompile the kernel, reboot: works.

2.6.22 and 2.6.23 differ in terms of the dpt_i2o driver by two different
patch sets:
-one 2 Kb small set of patches from 2.6.22 to 2.6.22-rc1
-one 7 Kb set of patches from 2.6.23-rc2 to 2.6.23-rc3
-one 162 Kb set of patches from 2.6.23-rc9 to 2.6.23-rc10.

When applying the 2.6.23-rc1-based driver to "my" 2.6.31.1 kernel,
the "zero blocks"-symptom show up, so it's the "lucky" situation
that the smallest patch actually seams to be the broken one.

According to the 2.6.23-rc1 short-form changelog, there is
one major edit on the dpt_i2o driver:

FUJITA Tomonori 

      [SCSI] dpt_i2o: convert to use the data buffer accessors

Stephen Rothwell 
      dpt_i2o depends on virt_to_bus

Fujita, would you please take a look at this?

I think that something's broken in there, leading to the dpt_i2o 
sending out blocks of zeroes right after initialization, at least on
some specific controllers (in this case, Adaptec 2010S on Intel
SE7501WV2S-based boxes).

I don't have insight kernel driver development knowledge, so I'm
quite out of help right now. Nevertheless, I'll add the diff
from 2.6.22 to 2.6.23-rc1 in terms of dpt_i2o:

---cut
diff -Nur linux-2.6.22/drivers/scsi/dpt_i2o.c linux-2.6.23-rc1/drivers/scsi/dpt_i2o.c
--- linux-2.6.22/drivers/scsi/dpt_i2o.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.23-rc1/drivers/scsi/dpt_i2o.c	2007-07-22 22:41:00.000000000 +0200
@@ -2078,12 +2078,13 @@
 	u32 *lenptr;
 	int direction;
 	int scsidir;
+	int nseg;
 	u32 len;
 	u32 reqlen;
 	s32 rcode;
 
 	memset(msg, 0 , sizeof(msg));
-	len = cmd->request_bufflen;
+	len = scsi_bufflen(cmd);
 	direction = 0x00000000;	
 	
 	scsidir = 0x00000000;			// DATA NO XFER
@@ -2140,21 +2141,21 @@
 	lenptr=mptr++;		/* Remember me - fill in when we know */
 	reqlen = 14;		// SINGLE SGE
 	/* Now fill in the SGList and command */
-	if(cmd->use_sg) {
-		struct scatterlist *sg = (struct scatterlist *)cmd->request_buffer;
-		int sg_count = pci_map_sg(pHba->pDev, sg, cmd->use_sg,
-				cmd->sc_data_direction);
 
+	nseg = scsi_dma_map(cmd);
+	BUG_ON(nseg < 0);
+	if (nseg) {
+		struct scatterlist *sg;
 
 		len = 0;
-		for(i = 0 ; i < sg_count; i++) {
+		scsi_for_each_sg(cmd, sg, nseg, i) {
 			*mptr++ = direction|0x10000000|sg_dma_len(sg);
 			len+=sg_dma_len(sg);
 			*mptr++ = sg_dma_address(sg);
-			sg++;
+			/* Make this an end of list */
+			if (i == nseg - 1)
+				mptr[-2] = direction|0xD0000000|sg_dma_len(sg);
 		}
-		/* Make this an end of list */
-		mptr[-2] = direction|0xD0000000|sg_dma_len(sg-1);
 		reqlen = mptr - msg;
 		*lenptr = len;
 		
@@ -2163,16 +2164,8 @@
 				len, cmd->underflow);
 		}
 	} else {
-		*lenptr = len = cmd->request_bufflen;
-		if(len == 0) {
-			reqlen = 12;
-		} else {
-			*mptr++ = 0xD0000000|direction|cmd->request_bufflen;
-			*mptr++ = pci_map_single(pHba->pDev,
-				cmd->request_buffer,
-				cmd->request_bufflen,
-				cmd->sc_data_direction);
-		}
+		*lenptr = len = 0;
+		reqlen = 12;
 	}
 	
 	/* Stick the headers on */
@@ -2232,7 +2225,7 @@
 	hba_status = detailed_status >> 8;
 
 	// calculate resid for sg 
-	cmd->resid = cmd->request_bufflen - readl(reply+5);
+	scsi_set_resid(cmd, scsi_bufflen(cmd) - readl(reply+5));
 
 	pHba = (adpt_hba*) cmd->device->host->hostdata[0];
 
---cut

Personally I guess that it's the large drop from lines 2164 on
that's broken, who replaces a mapping routine by some static assignment.


Regards,

Anders
-- 
1&1 Internet AG              System Design
Brauerstrasse 48             v://49.721.91374.50
D-76135 Karlsruhe            f://49.721.91374.225

Amtsgericht Montabaur HRB 6484
Vorstand: Henning Ahlert, Ralph Dommermuth, Matthias Ehrlich, Andreas Gauger,
Thomas Gottschlich, Matthias Greve, Robert Hoffmann, Norbert Lang, Achim Weiss
Aufsichtsratsvorsitzender: Michael Scheeren
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----
