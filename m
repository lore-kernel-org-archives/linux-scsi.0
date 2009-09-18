From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: LSI MegaRAID not recognised correctly in 64-bit.  2.6.29.6
Date: Fri, 18 Sep 2009 22:00:53 +0900
Message-ID: <20090918215950P.fujita.tomonori@lab.ntt.co.jp>
References: <4AB25F49.4060201@attglobal.net>
	<1253212785.7845.38.camel@mulgrave.site>
	<1253219291.7845.152.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:58065 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509AbZIRNPE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 09:15:04 -0400
In-Reply-To: <1253219291.7845.152.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: stunnel@attglobal.net, linux-scsi@vger.kernel.org, bo.yang@lsi.com, fujita.tomonori@lab.ntt.co.jp

On Thu, 17 Sep 2009 14:28:11 -0600
James Bottomley <James.Bottomley@suse.de> wrote:

> On Thu, 2009-09-17 at 18:39 +0000, James Bottomley wrote:
> > On Thu, 2009-09-17 at 09:09 -0700, Eddie wrote:
> > > James Bottomley wrote:
> > > > On Wed, 2009-09-16 at 19:59 -0700, Eddie wrote:
> > > >   
> > > >>>> How much memory does your system have?
> > > >>>>
> > > >>>> Best guess in the 64 bit case is that the physical memory the kernel is
> > > >>>> doing DMA to isn't within the range of the card.  You might be able to
> > > >>>> test this by booting with the max_addr=4G parameter in the 64 bit case.
> > > >>>>
> > > >>>> If it is, we'll have to get the DMA mask for this thing set up
> > > >>>> correctly.
> > > >>>>
> > > >>>> James
> > > >>>>   
> > > >>>>         
> > > >>> James,
> > > >>>
> > > >>> It's got 8Gig.
> > > >>>
> > > >>> I'll try your suggestion tonight, when I get home.
> > > >>>
> > > >>> Cheers,
> > > >>> Eddie
> > > >>>
> > > >>>       
> > > >> OK, adding addappend = " max_addr=4G" to my lilo.conf made no 
> > > >> difference.  It still booted with all 8G.  :(
> > > >>
> > > >> But, changing it to addappend = " mem=4G" seemed to do the trick.
> > > >>
> > > >> And, your guess might be correct.  I now see the correct messages for 
> > > >> the MegaRAID:
> > > >>
> > > >> scsi 4:4:0:0: Direct-Access     MegaRAID LD 0 RAID5 1430G N661 PQ: 0 ANSI: 2
> > > >> sd 4:4:0:0: [sda] 2930307072 512-byte hardware sectors: (1.50 TB/1.36 TiB)
> > > >> sd 4:4:0:0: [sda] Write Protect is off
> > > >> sd 4:4:0:0: [sda] Mode Sense: 00 00 00 00
> > > >> sd 4:4:0:0: [sda] Asking for cache data failed
> > > >> sd 4:4:0:0: [sda] Assuming drive cache: write through
> > > >> sd 4:4:0:0: [sda] 2930307072 512-byte hardware sectors: (1.50 TB/1.36 TiB)
> > > >> sd 4:4:0:0: [sda] Write Protect is off
> > > >> sd 4:4:0:0: [sda] Mode Sense: 00 00 00 00
> > > >> sd 4:4:0:0: [sda] Asking for cache data failed
> > > >> sd 4:4:0:0: [sda] Assuming drive cache: write through
> > > >>  sda: sda1
> > > >> sd 4:4:0:0: [sda] Attached SCSI disk
> > > >> sd 4:4:0:0: Attached scsi generic sg1 type 0
> > > >>     
> > > >
> > > > Hmm, so the driver looks to do this correctly.  By default it sets a 32
> > > > bit DMA mask but it raises it to 64 bits for certain boards which can
> > > > support that (based on the PCI ids).  Can you do an lspci -n -v and send
> > > > the output?  That will tell me whether the board got a 64 bit mask.
> > > >
> > > > Thanks,
> > > >
> > > > James
> > > >
> > > >   
> > > James,
> > > 
> > > This is when booted with the "mem=4G" override still in place.  If you 
> > > need it without that, when it fails to "see" the device, let me know, 
> > > and I'll re-boot tonight to gather it:
> > > 
> > > 01:04.0 0104: 101e:1960 (rev 02)
> > >         Subsystem: 101e:0511
> > 
> > This is sufficient.  That's an AMI Megaraid3.  They're not 64 bit
> > capable and they should only have a 32 bit DMA mask.  The block layer
> > should be doing the right thing, so there must be something from a >4GB
> > pool leaking into the driver somewhere: probably a stray kmalloc of a
> > DMA buffer without the right flags ... I'll run over the driver and see
> > if I can spot it.
> 
> OK, I analysed the code paths; I'm nearly certain the dma_map_sg() is
> returning addresses greater than the 32 bits allowable, which would
> point to some type of pci gart DMA failure (cc'ing Tomo for input).

>From a quick look, seems GART IOMMU properly handles dma_mask.

Let's confirm that dma_map_sg returns an invalid address.

Eddie, can you try a kernel with the following patch and send kernel
messages?

Note that the patch doesn't fix the problem; just print debug
information.


diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 234f0b7..0d0a02f 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1391,7 +1391,12 @@ megaraid_mbox_mksgl(adapter_t *adapter, scb_t *scb)
 
 	scb->dma_type = MRAID_DMA_WSG;
 
+	printk("%x %lx\n", scp->cmnd[0],
+	       (unsigned long)*(scp->device->host->shost_gendev.parent->dma_mask));
+
 	scsi_for_each_sg(scp, sgl, sgcnt, i) {
+		printk("%lx %u\n", (unsigned long)sg_dma_address(sgl),
+		       sg_dma_len(sgl));
 		ccb->sgl64[i].address	= sg_dma_address(sgl);
 		ccb->sgl64[i].length	= sg_dma_len(sgl);
 	}

