From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: Fusion problems with 2.6.5rc1 on AMD x86-64 IV
Date: Wed, 17 Mar 2004 10:58:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57040DB1E2@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:49288 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261644AbUCQP61 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 10:58:27 -0500
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-scsi@vger.kernel.org, "Moore, Eric Dean" <Emoore@lsil.com>, James.Bottomley@HansenPartnership.com

There is a bug in the driver where we do three
seperate memory allocations for the request/reply FIFOs 
that need to be on the same 4gb boundary. This is on my todo list,
hope to fix soon.


A temporary fix is there in the driver. Please recompile
with the following line uncommented in the Makefile
will put these allocations below 4gb:

EXTRA_CFLAGS += -DMPTBASE_MEM_ALLOC_FIFO_FIX

Eric Moore


On Wednesday, March 17, 2004 2:07 AM,  Andi Kleen wrote:
> 
> On Wed, 17 Mar 2004 10:00:40 +0100
> Andi Kleen <ak@suse.de> wrote:
> 
> > On Wed, 17 Mar 2004 06:03:32 +0100
> > Andi Kleen <ak@suse.de> wrote:
> > 
> > 
> > > The actual problem is the recent consistent_dma_mask 
> change from James. For some reason
> > > the x86-64 pci_alloc_consistent always sees an 
> 0xffffffffffffffff dma mask now
> > > and that breaks Fusion.
> > 
> > I found some bugs in x86-64 code now that explained the 
> problem. For some reason
> > the consistent mask patchkit seems to have triggered them. 
> It's fixed now.
> 
> Sorry for the many follow ups to myself :-)
> 
> Anyways the consistent mask problem is still with us. I just 
> have a workaround that 
> works (force it to 4GB) and there were related bugs in the 
> x86-64 IOMMU code.
> 
> James, can you take a look at that please? From a first look 
> i didn't find the place
> where it is set to 0xffffffffffffffff. It isn't the driver.
> 
> -Andi
> 
