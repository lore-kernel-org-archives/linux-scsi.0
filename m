From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 11045] New: Bug in MPT Fusion 2.6.26-rc7
	unbootable
Date: Tue, 08 Jul 2008 16:57:35 -0500
Message-ID: <1215554255.3214.48.camel@localhost.localdomain>
References: <bug-11045-10286@http.bugzilla.kernel.org/>
	 <200807081051.33892.bjorn.helgaas@hp.com>
	 <1215537813.3214.22.camel@localhost.localdomain>
	 <200807081456.53460.bjorn.helgaas@hp.com>
	 <20080708144720.998a13f2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20080708144720.998a13f2.akpm@linux-foundation.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, "Support, Software" <support@lsi.com>, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsi.com>, kurk@shiftmail.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-07-08 at 14:47 -0700, Andrew Morton wrote:
> On Tue, 8 Jul 2008 14:56:53 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > On Tuesday 08 July 2008 11:23:33 am James Bottomley wrote:
> > > On Tue, 2008-07-08 at 10:51 -0600, Bjorn Helgaas wrote:
> > > > Which ACPI screw up is that?  And what's the usual recipe?
> > > 
> > > The usual screw up where subtle ACPI breakage from release to release
> > > causes some IRQs to get misrouted.
> > > 
> > > Usually you start with noacpi and cycle through the pci routing options
> > 
> > Don't worry, I wasn't trying to talk you out of an ACPI bug report;
> > I just wanted to get enough specifics so I could see whether it was
> > something I could fix.
> > 
> > > If you actually read this bug report, you'll see there was a message
> > > 
> > > ACPI: Resource is not an IRQ entry
> > > 
> > > Just before the fusion IRQ failed to get delivered, so I think it's a
> > > good indicator that there *are* ACPI problems ...
> > 
> > These messages also happen with 2.6.25, where the MPT Fusion driver
> > worked, so Kurk opened a separate bugzilla,
> >   http://bugzilla.kernel.org/show_bug.cgi?id=11049
> > for them.
> > 
> > Yakui Zhao thinks the messages are harmless because they're
> > related to interrupt link devices that we don't use in IOAPIC mode,
> > and given that the driver works in 2.6.25, that seems plausible
> > to me.
> > 
> > Regardless, the messages are alarming and annoying.  I'd like
> > to understand them better, but I'll pursue that in the 11049
> > bugzilla.
> > 
> 
> Let us not forget the other part of this report:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000034c
> IP: [<f885cc5e>] :mptspi:mptspi_dv_renegotiate_work+0xa/0x9f
> Oops: 0000 [#1] SMP

That's fixed in the scsi-rc-fixes tree ... but it's a symptom, not a
cause.  If essential storage is on this adapter, the system will still
be unbootable.

James


