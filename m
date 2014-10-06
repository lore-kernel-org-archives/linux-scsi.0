From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 23/29] atari_scsi: Convert to platform device
Date: Mon, 6 Oct 2014 18:05:35 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1410061754280.26699@nippy.intranet>
References: <20141002065628.256592712@telegraphics.com.au> <20141002065633.766165263@telegraphics.com.au> <CAMuHMdWmxEUMabRrbQpjhWTE1W4WD4CDkmXZNem06C0ScnKkFw@mail.gmail.com> <alpine.LNX.2.00.1410032054150.12643@nippy.intranet> <54308629.6060800@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <54308629.6060800@gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Sun, 5 Oct 2014, Michael Schmitz wrote:

> > On Fri, 3 Oct 2014, Geert Uytterhoeven wrote:
> >
> >   
> > > > +       if (ATARIHW_PRESENT(TT_SCSI)) {
> > > > +               atari_scsi_reg_read  = atari_scsi_tt_reg_read;
> > > > +               atari_scsi_reg_write = atari_scsi_tt_reg_write;
> > > > +       } else if (ATARIHW_PRESENT(ST_SCSI)) {
> > > > +               atari_scsi_reg_read  = atari_scsi_falcon_reg_read;
> > > > +               atari_scsi_reg_write = atari_scsi_falcon_reg_write;
> > > >       
> > > Can these be handled through the platform_device's resources?
> > >
> > >     
> >
> > I don't know.
> >   
> 
> Should be possible - I've seen that used in the ISP116x HCD driver 
> (arch-dependent post-register access delay function passed via platform 
> data).

Yes, possible, but is it desirable?

> >   
> > > > +#ifdef REAL_DMA
> > > > +       /* If running on a Falcon and if there's TT-Ram (i.e., more than
> > > > one
> > > > +        * memory block, since there's always ST-Ram in a Falcon), then
> > > > +        * allocate a STRAM_BUFFER_SIZE byte dribble buffer for
> > > > transfers
> > > > +        * from/to alternative Ram.
> > > > +        */
> > > > +       if (ATARIHW_PRESENT(ST_SCSI) && !ATARIHW_PRESENT(EXTD_DMA) &&
> > > > +           m68k_num_memory > 1) {
> > > > +               atari_dma_buffer = atari_stram_alloc(STRAM_BUFFER_SIZE,
> > > > "SCSI");
> > > > +               if (!atari_dma_buffer) {
> > > > +                       pr_err(PFX "can't allocate ST-RAM double
> > > > buffer\n");
> > > > +                       return -ENOMEM;
> > > > +               }
> > > > +               atari_dma_phys_buffer =
> > > > atari_stram_to_phys(atari_dma_buffer);
> > > > +               atari_dma_orig_addr = 0;
> > > > +       }
> > > > +#endif
> > > >       
> > > More platform data?
> > >     
> 
> Perhaps.
> 
> > >     
> > > > +       if (IS_A_TT())
> > > > +               instance->irq = IRQ_TT_MFP_SCSI;
> > > > +       else
> > > > +               instance->irq = IRQ_NONE;
> > > >       
> > > platform_device resource?
> > >     
> >
> > If I thought it possible to parameterize the driver such that it never 
> > had to test IS_A_TT(), I'd probably agree that this would be more 
> > elegant.
> >
> > Otherwise I'd prefer not to have parts of the logic separated off into 
> > the platform resources while the remaining logic remains in the driver 
> > itself.
> >
> > While I don't think platform resources are desirable in this driver, I 
> > would like to hear Michael's views.
> >   
> 
> The IRQ is a good candidate to be passed via platform data.

Geert didn't say so, but after thinking about his review comments I 
imagine that he wants all the Atari IRQ numbers kept in one place and all 
the Mac IRQ numbers in a different place, and so on. Makes sense.

> Register access primitives can be done via platform data as well. 
> Likewise, the ST-DMA locking primitives. That still leaves the DMA setup 
> and completion code - Falcon and TT differ here in that they require a 
> different order of DMA setup and NCR setup (the Falcon SCSI chip is 
> hooked up via the ST-DMA, the TT one memory mapped so DMA setup must 
> come last on Falcon, and DMA completion check first. TT has that 
> reversed. That's a bit more hassle and might require lib_NCR5380 
> approach similar to the ESP SCSI driver.
> 
> > Aside from TT and ST, is there a third configuration that might benefit from
> > a more data driven configuration?
> >   
> 
> TT and Falcon, not sure any of the ST/STE series ever had a SCSI adapter.
> Medusa is TT compatible

If there's no third configuration then I see little to be gained from 
completely parameterizing the driver using a bunch of resources.

What am I missing? Why would it be desirable to have bits of driver code 
in arch/m68k/ and other bits of the same driver kept elsewhere in the 
tree (in drivers/)?

> 
> > > (and IRQ_NONE is wrong, you should use 0)
> > >
> > >     
> > > > +       if (IS_A_TT()) {
> > > >       
> > > Check for instance->irq instead?
> > >     
> >
> > Yes, you'd think so, but a later patch (not in this set) would have to 
> > change it back to IS_A_TT().
> >
> > Further patches align atari_NCR5380.c with NCR5380.c, such that the 
> > core driver then checks host->irq to find out whether an IRQ is in 
> > use. For Atari ST, request_irq() is not called even though the ST DMA 
> > irq is in use.
> >   
> That's why the IRQ is set to 0, I guess? Works for me.

My patch tests for IS_A_TT not 0 because 0 has a different meaning 
depending on which core driver you use. I don't want to support three 
forks of NCR5380.c. One of the objectives of this patch series is to try 
to move toward convergence on a common core driver.

> The old code states that setting instance->irq = 0 keeps the midlevel 
> from tampering with the SCSI IRQ during queuecmd which would interfere 
> with IDE and floppy.

I don't know what you mean. AFAIK, the SCSI mid layer doesn't care about 
instance->irq.

> I guess this is still relevant - I would not have seen the ST-DMA locked 
> by IDE during SCSI queuecmd otherwise.

Lock-ups were due to disabling local IRQs. Please see,

[PATCH 22/29] atari_scsi: Fix atari_scsi deadlocks on Falcon

in this series and (from our personal correspondence) the patch called
ncr5380-atari_scsi-stdma_try_lock

-- 
