From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: 2.6.23-rc9 boot failure (megaraid?)
Date: Wed, 03 Oct 2007 09:09:33 +0900
Message-ID: <20071003090933E.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.64.0710021242510.6275@postal>
	<20071002181518.GC10852@stusta.de>
	<1191357493.3530.129.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:54123 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbXJCAJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 20:09:38 -0400
In-Reply-To: <1191357493.3530.129.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: bunk@kernel.org, bwindle@fint.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, sumant.patro@lsi.com, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org

On Tue, 02 Oct 2007 15:38:13 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Tue, 2007-10-02 at 20:15 +0200, Adrian Bunk wrote:
> > Cc's added, the complete bug report is at
> >   http://lkml.org/lkml/2007/10/2/243
> > 
> > On Tue, Oct 02, 2007 at 12:48:26PM -0400, Burton Windle wrote:
> > > 2.6.23-rc9 fails to boot for me; 2.6.22.9 works fine.
> > >
> > > System is a Dell Poweredge with PERC 2/DC with RAID1 volume.
> > >...
> > 
> > Thanks for your report.
> > 
> > Diff'ing the dmesg's shows:
> > 
> > <--  snip  -->
> > 
> >  scsi0: scanning scsi channel 4 [P0] for physical devices.
> >  scsi0: scanning scsi channel 5 [P1] for physical devices.
> >  st: Version 20070203, fixed bufsize 32768, s/g segs 256
> > -sd 0:0:0:0: [sda] 17547264 512-byte hardware sectors (8984 MB)
> > +sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
> > +sd 0:0:0:0: [sda] 1 512-byte hardware sectors (0 MB)
> >  sd 0:0:0:0: [sda] Write Protect is off
> >  sd 0:0:0:0: [sda] Asking for cache data failed
> >  sd 0:0:0:0: [sda] Assuming drive cache: write through
> > -sd 0:0:0:0: [sda] 17547264 512-byte hardware sectors (8984 MB)
> > +sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
> > +sd 0:0:0:0: [sda] 1 512-byte hardware sectors (0 MB)
> >  sd 0:0:0:0: [sda] Write Protect is off
> >  sd 0:0:0:0: [sda] Asking for cache data failed
> >  sd 0:0:0:0: [sda] Assuming drive cache: write through
> >   sda: sda1
> > + sda: p1 exceeds device capacity
> > 
> > <--  snip  -->
> > 
> > -	case MEGA_BULK_DATA:
> > -		if (scb->cmd->use_sg == 0)
> > -			length = scb->cmd->request_bufflen;
> > -		else {
> > -			struct scatterlist *sgl =
> > -				(struct scatterlist *)scb->cmd->request_buffer;
> > -			length = sgl->length;
> > -		}
> > -		pci_unmap_page(adapter->dev, scb->dma_h_bulkdata,
> > -			       length, scb->dma_direction);
> > -		break;
> > -
> 
> This is the problem piece I think.  We've reintroduced a very old bug:
> 
> commit 51c928c34fa7cff38df584ad01de988805877dba
> Author: James Bottomley <James.Bottomley@SteelEye.com>
> Date:   Sat Oct 1 09:38:05 2005 -0500
> 
>     [SCSI] Legacy MegaRAID: Fix READ CAPACITY
>     
>     Some Legacy megaraid cards can't actually cope with the scatter/gather
>     version of the READ CAPACITY command (which is what we now send them
>     since altering all SCSI internal I/O to go via the block layer).  Fix
>     this (and a few other broken megaraid driver assumptions) by sending
>     the non-sg version of the command if the sg list only has a single
>     element.
>     
>     Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
> 
> So what we have to do is put back the check for use_sg == 1 and send
> that as a bulk transfer command.

Sorry again. Needs to check sg count before dma mapping.


diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 3907f67..ae0b220 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1737,9 +1737,12 @@ mega_build_sglist(adapter_t *adapter, scb_t *scb, u32 *buf, u32 *len)
 	Scsi_Cmnd	*cmd;
 	int	sgcnt;
 	int	idx;
+	int bulkdata;
 
 	cmd = scb->cmd;
 
+	bulkdata = (scsi_sg_count(cmd) == 1) ? 1 : 0;
+
 	/*
 	 * Copy Scatter-Gather list info into controller structure.
 	 *
@@ -1753,6 +1756,14 @@ mega_build_sglist(adapter_t *adapter, scb_t *scb, u32 *buf, u32 *len)
 
 	*len = 0;
 
+	if (bulkdata && !adapter->has_64bit_addr) {
+		sg = scsi_sglist(cmd);
+		scb->dma_h_bulkdata = sg_dma_address(sg);
+		*buf = (u32)scb->dma_h_bulkdata;
+		*len = sg_dma_len(sg);
+		return 0;
+	}
+
 	scsi_for_each_sg(cmd, sg, sgcnt, idx) {
 		if (adapter->has_64bit_addr) {
 			scb->sgl64[idx].address = sg_dma_address(sg);
