From: Andrew Morton <akpm@zip.com.au>
Subject: Re: 2.5.32 IO performance issues
Date: Thu, 29 Aug 2002 15:23:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D6E9EDC.ED1E546C@zip.com.au>
References: <3D6E6B64.66203783@zip.com.au> <200208292055.g7TKte224951@eng2.beaverton.ibm.com> <20020829145342.A25892@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, linux-kernel@vger.kernel.org, Gerrit Huizenga <gerrit@us.ibm.com>, Hans-J Tannenberger <hjt@us.ibm.com>, Janet Morgan <janetmor@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, Martin Bligh <mjbligh@us.ibm.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

Patrick Mansfield wrote:
> 
> On Thu, Aug 29, 2002 at 01:55:40PM -0700, Badari Pulavarty wrote:
> > >
> > > block-highmem is bust for scsi. (aic7xxx at least).  Does
> > > http://www.zip.com.au/~akpm/linux/patches/2.5/2.5.32/2.5.32-mm2/broken-out/scsi_hack.patch
> > > fix it?
> >
> > Hmm !! This patch fixed it. I remember you gave me this patch for 2.5.31. But 2.5.31
> > was doing fine without it. But 2.5.32 seem to need it.
> >
> 
> The above patch works fine to get back to the previous (pre-2.5.32) state.
> But, it makes no sense to modify the bounce_limit based on the type of
> storage that is attached to an adapter.

I agree.  Hence the name "scsi_hack" ;)

> We want to allow high mem for block devices other than SCSI direct access
> devices (TYPE_DISK), such as CD ROM (SDpnt->type TYPE_ROM), WORM devices
> (TYPE_WORM), and optical disks (TYPE_MOD).
> 
> So it is better to patch scsi_initialize_merge_fn:
> 
> --- 1.16/drivers/scsi/scsi_merge.c      Fri Jul  5 09:43:00 2002
> +++ edited/drivers/scsi/scsi_merge.c    Thu Aug 29 14:30:12 2002
> @@ -140,7 +140,7 @@
>          * Enable highmem I/O, if appropriate.
>          */
>         bounce_limit = BLK_BOUNCE_HIGH;
> -       if (SHpnt->highmem_io && (SDpnt->type == TYPE_DISK)) {
> +       if (SHpnt->highmem_io) {
>                 if (!PCI_DMA_BUS_IS_PHYS)
>                         /* Platforms with virtual-DMA translation
>                          * hardware have no practical limit.
> 

That will certainly fix it.  But who added the TYPE_DISK check,
and why???
