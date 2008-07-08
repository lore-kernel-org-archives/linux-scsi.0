From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [Bugme-new] [Bug 11045] New: Bug in MPT Fusion 2.6.26-rc7 unbootable
Date: Tue, 8 Jul 2008 14:56:53 -0600
Message-ID: <200807081456.53460.bjorn.helgaas@hp.com>
References: <bug-11045-10286@http.bugzilla.kernel.org/> <200807081051.33892.bjorn.helgaas@hp.com> <1215537813.3214.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:3645 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYGHU5N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 16:57:13 -0400
In-Reply-To: <1215537813.3214.22.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Support, Software" <support@lsi.com>, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsi.com>, kurk@shiftmail.org

On Tuesday 08 July 2008 11:23:33 am James Bottomley wrote:
> On Tue, 2008-07-08 at 10:51 -0600, Bjorn Helgaas wrote:
> > Which ACPI screw up is that?  And what's the usual recipe?
> 
> The usual screw up where subtle ACPI breakage from release to release
> causes some IRQs to get misrouted.
> 
> Usually you start with noacpi and cycle through the pci routing options

Don't worry, I wasn't trying to talk you out of an ACPI bug report;
I just wanted to get enough specifics so I could see whether it was
something I could fix.

> If you actually read this bug report, you'll see there was a message
> 
> ACPI: Resource is not an IRQ entry
> 
> Just before the fusion IRQ failed to get delivered, so I think it's a
> good indicator that there *are* ACPI problems ...

These messages also happen with 2.6.25, where the MPT Fusion driver
worked, so Kurk opened a separate bugzilla,
  http://bugzilla.kernel.org/show_bug.cgi?id=11049
for them.

Yakui Zhao thinks the messages are harmless because they're
related to interrupt link devices that we don't use in IOAPIC mode,
and given that the driver works in 2.6.25, that seems plausible
to me.

Regardless, the messages are alarming and annoying.  I'd like
to understand them better, but I'll pursue that in the 11049
bugzilla.

Bjorn
