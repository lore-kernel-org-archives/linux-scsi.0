From: Doug Maxey <dwm@austin.ibm.com>
Subject: Re: Loading PATA_PDC2027x as a module
Date: Mon, 21 Aug 2006 18:06:08 -0500
Message-ID: <11901.1156201568@falcon10.austin.ibm.com>
References: <BAY113-F2401E0634D22FB7C0EC841DF410@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <BAY113-F2401E0634D22FB7C0EC841DF410@phx.gbl> 
Sender: linux-ide-owner@vger.kernel.org
To: John Treubig <jtreubig@hotmail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 21 Aug 2006 16:32:58 CDT, "John Treubig" wrote:
>Thanks for the quick response.  

You are most welcome.

> Spent most of the day figuring out how to 
>build the ramdisk.  Built both drivers (pata_pdc2027x and pdc202xx_old) and 

My "clarity in writing" courses must have worn off. :)

With only the pata_pdc2027x driver in the initrd, it wins the race, and
gets loaded.  With both, the old ide driver loads first, and cannot be
unloaded do to some, ah, features, of the old ide stack.

With the libata stack (via the pata_pdc2027x), those particular features
are no longer present.  So no need for the pdc202xxx... driver.

>the ramdisk, loaded the ramdisk at boot and still system is using IDE driver 
>for the Promise attached drives.  Have attached the boot log and the verbose 
>output of the ramdisk build.  Got any ideas as to what might be the hang up? 
>  I am using the M/B controller for system disk and it is not of the Promise 
>variety.   The Promise is a PCI card in the I/O card bay.
>
>Best wishes,
>John
>
>
>From: Doug Maxey <dwm@enoyolf.org>
>To: "John Treubig" <jtreubig@hotmail.com>
>CC: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,        
>dwm@bebe.enoyolf.org
>Subject: Re: Loading PATA_PDC2027x as a module
>Date: Mon, 21 Aug 2006 11:08:52 -0500
>
>
>On Mon, 21 Aug 2006 10:38:12 CDT, "John Treubig" wrote:
> > Can I load pata_pdc2027x as a module or must it be built as part of the
> > kernel?  I am using RedHat Fedora with 2.6.17.1 stock kernel.  LibATA has
> > been installed in the kernel with ATA_ENABLE_PATA undefined.  The
> > pata_pdc2027x driver is not part of the Fedora build, so I have been able 
>to
> > build pata_pdc2027x as a module with ATA_ENABLE_PATA defined for the 
>module.
> >   When I try to load the pata_pdc2027x module it will not displace the 
>IDE
> > native driver.  What's the mechanism that is used to determine if the IDE
> > driver grabs the device or LibATA/pata_pdc_2027x?
>
>The base kernel needs the old driver (pdc202xxx...) built as a module
>(or not at all) to give the pata_pdc2027x module a chance to load.
>
>Once that is done, you can add the module as required to mkinitrd and
>it should be the first loaded, which prevents the other driver from
>loading.
>
> >
> > You may ask why I don't just live with the IDE driver.  This stems from
> > problems we saw in accessing the Promise PDC2027x drives under 2.6.10 
>where
> > the system lost time.  In discussions with Albert Lee, it was resolved 
>that
> > the best approach was to convert our access to use LibATA.  After usage 
>of
> > the LibATA access, the time loses issue has gone away.  I know that there
> > have been changes in both the IDE and LibATA structures, so I'm open to
> > additional advice.
> >
> > Best wishes,
> > John Treubig
> > VT Miltope
> > Senior Test Engineer
>
>


