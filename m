From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: iommu_iova leak [inside 3w-9xxx]
Date: Sun, 18 Sep 2011 18:01:49 +0400
Message-ID: <1316354509.27722.1.camel@dabdike>
References: <4E734467.3040703@bootc.net>
	 <1316256305.24257.25.camel@shinybook.infradead.org>
	 <AD4B8103-C98F-4BC5-9F7F-496D220781F3@bootc.net>
	 <3A4FADE6-3653-46C5-B225-8200F9DCE35B@bootc.net>
	 <CAHtARFHfxpU1JKu4092ZshvhsrRY-hx_pfnL3_+T32B3ncgWvg@mail.gmail.com>
	 <B4A636AC-B127-42DD-BC8C-419D07A83FBD@bootc.net>
	 <1316353140.12001.15.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1316353140.12001.15.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: Chris Boot <bootc@bootc.net>, adam radford <aradford@gmail.com>, lkml <linux-kernel@vger.kernel.org>, Adam Radford <linuxraid@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2011-09-18 at 13:39 +0000, Woodhouse, David wrote:
> On Sun, 2011-09-18 at 13:06 +0100, Chris Boot wrote:
> > On 17 Sep 2011, at 20:22, adam radford wrote:
> > > On Sat, Sep 17, 2011 at 7:29 AM, Chris Boot <bootc@bootc.net> wrote:
> > >> On 17 Sep 2011, at 12:57, Chris Boot wrote:
> > >>> On 17 Sep 2011, at 11:45, Woodhouse, David wrote:
> > >>>> I suppose it's vaguely possible that we're leaking them in such a way
> > >>>> that they remain on the rbtree, perhaps if the deferred unmap is never
> > >>>> actually happening... but I think it's a whole lot more likely that the
> > >>>> PCI driver is just never bothering to unmap the pages it maps.
> > > 
> > > If you think 3w-9xxx is not unmapping pages it maps, please re-run with
> > > CONFIG_PCI_DMA_DEBUG=y
> > 
> > Adam,
> > 
> > I installed a fresh Debian system on a SATA disk connected to the built-in SATA controller, then played with loading/unloading the 3w-9xxx module and doing a few basic things. Without even prodding very much, I got this result:
> > 
> > [ 1142.363173] ------------[ cut here ]------------
> > [ 1142.368507] WARNING: at lib/dma-debug.c:697 dma_debug_device_change+0x172/0x1a6()
> > [ 1142.377162] Hardware name: S1200BTL
> > [ 1142.381193] pci 0000:01:00.0: DMA-API: device driver has pending DMA allocations while released from device [count=37]
> > [ 1142.381194] One of leaked entries details: [device address=0x00000000fff9a000] [size=4096 bytes] [mapped with DMA_TO_DEVICE] [mapped as scather-gather]
>  ...
> > [ 1142.381254] Mapped at:
> > [ 1142.381255]  [<ffffffff811c35b1>] debug_dma_map_sg+0x3b/0x140
> > [ 1142.381256]  [<ffffffffa00cb0db>] scsi_dma_map+0x9b/0xb7 [scsi_mod]
> > [ 1142.381260]  [<ffffffffa012c675>] twa_scsiop_execute_scsi+0x141/0x3a5 [3w_9xxx]
> > [ 1142.381263]  [<ffffffffa012ce3b>] twa_scsi_queue+0xd6/0x16a [3w_9xxx]
> > [ 1142.381265]  [<ffffffffa00c4620>] scsi_dispatch_cmd+0x192/0x236 [scsi_mod]
> 
> Seems like a smoking gun to me, although at first glance I can't see an
> *obvious* leak in the 3w-9xxx code. Adam?

Hardly ... all it's saying is that twa_exit doesn't wait for pending I/O
to complete, so when you remove the module it tears down in the middle
of an I/O.  A bug, yes, but it's not indicative of any sort of leak in
the maps/unmaps.

James
