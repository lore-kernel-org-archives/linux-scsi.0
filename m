From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [Bug 14159] AIC79xx is not working properly with an attached scsi tape since 2.6.29
Date: Mon, 14 Sep 2009 11:24:38 -0600
Message-ID: <200909141124.39379.bjorn.helgaas@hp.com>
References: <bug-14159-11613@http.bugzilla.kernel.org/> <200909140718.n8E7ImIE010519@demeter.kernel.org> <1252938312.8584.37.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1252938312.8584.37.camel@mulgrave.site>
Content-Disposition: inline
Sender: linux-acpi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Stefan Assmann <sassmann@novell.com>
List-Id: linux-scsi@vger.kernel.org

On Monday 14 September 2009 08:25:12 am James Bottomley wrote:
> > --- Comment #3 from g.giorgetti@teamsystem.com  2009-09-14 07:18:46 ---
> > today after building and installing the latest stable kernel 2.6.31 I can tell
> > you that the problem is still there.
> > 
> > Here is the machine's /proc/interrups
> > 
> >            CPU0       CPU1       
> >   0:         44          0   IO-APIC-edge      timer
> >   1:          0          2   IO-APIC-edge      i8042
> >   3:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2, ohci_hcd:usb5,
> > ohci_hcd:usb6
> >   4:          0          2   IO-APIC-edge    
> >   8:          0          1   IO-APIC-edge      rtc0
> >   9:          0          0   IO-APIC-fasteoi   acpi, sata_svw
> >  12:          0          4   IO-APIC-edge      i8042
> >  14:         63      92631   IO-APIC-edge      ide0
> >  19:          0          0   IO-APIC-fasteoi   aic79xx
> 
> So this is the problem, as predicted: the card isn't getting interrupts.
> This would strongly suggest an ACPI problem.  Can you try booting with
> pci=noacpi?

You might also try "pci=noioapicquirk".  Commit bbe194433bae [1]
fiddles with boot interrupts on AMD 813x devices, which you seem
to have.

Bjorn

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=bbe194433baeadc953f49e3795b41ffffc5486dd
