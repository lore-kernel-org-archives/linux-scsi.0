From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: LSI MegaRAID not recognised correctly in 64-bit.  2.6.29.6
Date: Sat, 19 Sep 2009 16:55:08 +0900
Message-ID: <20090919165404D.fujita.tomonori@lab.ntt.co.jp>
References: <20090918141106.GA29475@parisc-linux.org>
	<20090918231745O.fujita.tomonori@lab.ntt.co.jp>
	<4AB48254.4000404@attglobal.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:60958 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbZISHzU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Sep 2009 03:55:20 -0400
In-Reply-To: <4AB48254.4000404@attglobal.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stunnel@attglobal.net
Cc: fujita.tomonori@lab.ntt.co.jp, matthew@wil.cx, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, bo.yang@lsi.com

On Sat, 19 Sep 2009 00:03:48 -0700
Eddie <stunnel@attglobal.net> wrote:

> FUJITA Tomonori wrote:
> > On Fri, 18 Sep 2009 08:11:07 -0600
> > Matthew Wilcox <matthew@wil.cx> wrote:
> >
> >   
> >> On Fri, Sep 18, 2009 at 10:00:53PM +0900, FUJITA Tomonori wrote:
> >>     
> >>> Let's confirm that dma_map_sg returns an invalid address.
> >>>
> >>> Eddie, can you try a kernel with the following patch and send kernel
> >>> messages?
> >>>
> >>> Note that the patch doesn't fix the problem; just print debug
> >>> information.
> >>>       
> >> This is going to be quite noisy,
> >>     
> >
> > Seems that READ_CAPACITY always fails in his environment so it's not
> > so noisy. :)
> >
> >
> >   
> >> and not give us all that much information.
> >> Why not try this patch instead?
> >>
> >> diff --git a/drivers/scsi/scsi_lib_dma.c b/drivers/scsi/scsi_lib_dma.c
> >> index ac6855c..a179ff8 100644
> >> --- a/drivers/scsi/scsi_lib_dma.c
> >> +++ b/drivers/scsi/scsi_lib_dma.c
> >> @@ -20,7 +20,8 @@
> >>   */
> >>  int scsi_dma_map(struct scsi_cmnd *cmd)
> >>  {
> >> -	int nseg = 0;
> >> +	int i, nseg = 0;
> >> +	struct scatterlist *sgl;
> >>  
> >>  	if (scsi_sg_count(cmd)) {
> >>  		struct device *dev = cmd->device->host->shost_gendev.parent;
> >> @@ -29,6 +30,11 @@ int scsi_dma_map(struct scsi_cmnd *cmd)
> >>  				  cmd->sc_data_direction);
> >>  		if (unlikely(!nseg))
> >>  			return -ENOMEM;
> >> +		scsi_for_each_sg(cmd, sgl, nseg, i) {
> >> +			if (sg_dma_address(sgl) > *dev->dma_mask) {
> >>     
> >
> > I think that it should be
> >
> > if (sg_dma_address(sgl) + sg_dma_len(sgl) > *dev->dma_mask)
> >
> >   
> >> +				printk("IOMMU bug, command %d, dma mask %llx, but returned %lx %u for phys %lx\n", cmd->cmnd[0], *dev->dma_mask, (unsigned long)sg_dma_address(sgl), sg_dma_len(sgl), (unsigned long)sg_phys(sgl));
> >> +			}
> >> +		}
> >>  	}
> >>  	return nseg;
> >>  }
> >>
> >>
> >>     
> >>> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
> >>> index 234f0b7..0d0a02f 100644
> >>> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> >>> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> >>> @@ -1391,7 +1391,12 @@ megaraid_mbox_mksgl(adapter_t *adapter, scb_t *scb)
> >>>  
> >>>  	scb->dma_type = MRAID_DMA_WSG;
> >>>  
> >>> +	printk("%x %lx\n", scp->cmnd[0],
> >>> +	       (unsigned long)*(scp->device->host->shost_gendev.parent->dma_mask));
> >>> +
> >>>  	scsi_for_each_sg(scp, sgl, sgcnt, i) {
> >>> +		printk("%lx %u\n", (unsigned long)sg_dma_address(sgl),
> >>> +		       sg_dma_len(sgl));
> >>>  		ccb->sgl64[i].address	= sg_dma_address(sgl);
> >>>  		ccb->sgl64[i].length	= sg_dma_len(sgl);
> >>>  	}
> >>>
> >>>       
> OK, there are 2 dmesg outputs stored at ftp://ftp.BogoLinux.net/pub
> 
> dmesg.2a contains Fujita's patch and Matthew's
> 
> dmesg.2b contains Fujita's patch and his update to Matthew's.

Thanks, now the problem is clear; the driver uses 64bit dma_mask but
the hardware is not capable of 64bit dma according to James. Seems
that hardware lies about the dma capability.

Can you try the following patch?


diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 234f0b7..9ead856 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -888,6 +888,8 @@ megaraid_init_mbox(adapter_t *adapter)
 	if (((magic64 == HBA_SIGNATURE_64_BIT) &&
 		((adapter->pdev->subsystem_device !=
 		PCI_SUBSYS_ID_MEGARAID_SATA_150_6) &&
+		(adapter->pdev->device !=
+		PCI_DEVICE_ID_AMI_MEGARAID3) &&
 		(adapter->pdev->subsystem_device !=
 		PCI_SUBSYS_ID_MEGARAID_SATA_150_4))) ||
 		(adapter->pdev->vendor == PCI_VENDOR_ID_LSI_LOGIC &&

