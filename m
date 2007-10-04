From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.23-rc9 boot failure (megaraid?)
Date: Thu, 4 Oct 2007 09:28:34 +0200
Message-ID: <20071004072834.GD5236@kernel.dk>
References: <20071003090058R.fujita.tomonori@lab.ntt.co.jp> <0631C836DBF79F42B5A60C8C8D4E8229CC39C7@NAMAIL2.ad.lsil.com> <20071004084651L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:10384 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbXJDH07 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Oct 2007 03:26:59 -0400
Content-Disposition: inline
In-Reply-To: <20071004084651L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Sumant.Patro@lsi.com, James.Bottomley@SteelEye.com, bunk@kernel.org, bwindle@fint.org, linux-kernel@vger.kernel.org, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org

On Thu, Oct 04 2007, FUJITA Tomonori wrote:
> On Wed, 3 Oct 2007 17:32:55 -0600
> "Patro, Sumant" <Sumant.Patro@lsi.com> wrote:
> 
> >  
> > 
> > > -----Original Message-----
> > > From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp] 
> > > Sent: Tuesday, October 02, 2007 5:01 PM
> > > To: James.Bottomley@SteelEye.com
> > > Cc: bunk@kernel.org; bwindle@fint.org; 
> > > linux-kernel@vger.kernel.org; jens.axboe@oracle.com; 
> > > fujita.tomonori@lab.ntt.co.jp; Patro, Sumant; DL-MegaRAID 
> > > Linux; linux-scsi@vger.kernel.org
> > > Subject: Re: 2.6.23-rc9 boot failure (megaraid?)
> > > 
> > > On Tue, 02 Oct 2007 15:38:13 -0500
> > > James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > > 
> > > > On Tue, 2007-10-02 at 20:15 +0200, Adrian Bunk wrote:
> > > > > Cc's added, the complete bug report is at
> > > > >   http://lkml.org/lkml/2007/10/2/243
> > > > > 
> > > > > On Tue, Oct 02, 2007 at 12:48:26PM -0400, Burton Windle wrote:
> > > > > > 2.6.23-rc9 fails to boot for me; 2.6.22.9 works fine.
> > > > > >
> > > > > > System is a Dell Poweredge with PERC 2/DC with RAID1 volume.
> > > > > >...
> > > > > 
> > > > > Thanks for your report.
> > > > > 
> > > > > Diff'ing the dmesg's shows:
> > > > > 
> > > > > <--  snip  -->
> > > > > 
> > > > >  scsi0: scanning scsi channel 4 [P0] for physical devices.
> > > > >  scsi0: scanning scsi channel 5 [P1] for physical devices.
> > > > >  st: Version 20070203, fixed bufsize 32768, s/g segs 256 -sd 
> > > > > 0:0:0:0: [sda] 17547264 512-byte hardware sectors (8984 MB)
> > > > > +sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
> > > > > +sd 0:0:0:0: [sda] 1 512-byte hardware sectors (0 MB)
> > > > >  sd 0:0:0:0: [sda] Write Protect is off  sd 0:0:0:0: [sda] Asking 
> > > > > for cache data failed  sd 0:0:0:0: [sda] Assuming drive 
> > > cache: write 
> > > > > through -sd 0:0:0:0: [sda] 17547264 512-byte hardware 
> > > sectors (8984 
> > > > > MB)
> > > > > +sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
> > > > > +sd 0:0:0:0: [sda] 1 512-byte hardware sectors (0 MB)
> > > > >  sd 0:0:0:0: [sda] Write Protect is off  sd 0:0:0:0: [sda] Asking 
> > > > > for cache data failed  sd 0:0:0:0: [sda] Assuming drive 
> > > cache: write 
> > > > > through
> > > > >   sda: sda1
> > > > > + sda: p1 exceeds device capacity
> > > > > 
> > > > > <--  snip  -->
> > > > > 
> > > > > -	case MEGA_BULK_DATA:
> > > > > -		if (scb->cmd->use_sg == 0)
> > > > > -			length = scb->cmd->request_bufflen;
> > > > > -		else {
> > > > > -			struct scatterlist *sgl =
> > > > > -				(struct scatterlist 
> > > *)scb->cmd->request_buffer;
> > > > > -			length = sgl->length;
> > > > > -		}
> > > > > -		pci_unmap_page(adapter->dev, scb->dma_h_bulkdata,
> > > > > -			       length, scb->dma_direction);
> > > > > -		break;
> > > > > -
> > > > 
> > > > This is the problem piece I think.  We've reintroduced a 
> > > very old bug:
> > > > 
> > > > commit 51c928c34fa7cff38df584ad01de988805877dba
> > > > Author: James Bottomley <James.Bottomley@SteelEye.com>
> > > > Date:   Sat Oct 1 09:38:05 2005 -0500
> > > > 
> > > >     [SCSI] Legacy MegaRAID: Fix READ CAPACITY
> > > >     
> > > >     Some Legacy megaraid cards can't actually cope with the 
> > > scatter/gather
> > > >     version of the READ CAPACITY command (which is what we 
> > > now send them
> > > >     since altering all SCSI internal I/O to go via the 
> > > block layer).  Fix
> > > >     this (and a few other broken megaraid driver 
> > > assumptions) by sending
> > > >     the non-sg version of the command if the sg list only 
> > > has a single
> > > >     element.
> > > >     
> > > >     Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
> > > > 
> > > > So what we have to do is put back the check for use_sg == 1 
> > > and send 
> > > > that as a bulk transfer command.
> > > 
> > > Sorry about this. Can this fix the problem?
> > > 
> > > Thanks,
> > > 
> > > 
> > > diff --git a/drivers/scsi/megaraid.c 
> > > b/drivers/scsi/megaraid.c index 3907f67..da56163 100644
> > > --- a/drivers/scsi/megaraid.c
> > > +++ b/drivers/scsi/megaraid.c
> > > @@ -1753,6 +1753,14 @@ mega_build_sglist(adapter_t *adapter, 
> > > scb_t *scb, u32 *buf, u32 *len)
> > >  
> > >  	*len = 0;
> > >  
> > > +	if (scsi_sg_count(cmd) == 1 && !adapter->has_64bit_addr) {
> > > +		sg = scsi_sglist(cmd);
> > > +		scb->dma_h_bulkdata = sg_dma_address(sg);
> > > +		*buf = (u32)scb->dma_h_bulkdata;
> > > +		*len = sg_dma_len(sg);
> > > +		return 0;
> > > +	}
> > > +
> > >  	scsi_for_each_sg(cmd, sg, sgcnt, idx) {
> > >  		if (adapter->has_64bit_addr) {
> > >  			scb->sgl64[idx].address = sg_dma_address(sg);
> > > 
> > 
> > 
> > With this patch I see the correct logical disk size reported.
> > Thanks.
> 
> Great, thanks for testing!
> 
> Can you try the following patch instead of the above patch?
> 
> http://marc.info/?l=linux-scsi&m=119137033016550&w=2
> 
> 
> I know the changes are pretty trivial and it should work...

Tomo, this is the patch I added.

-- 
Jens Axboe

