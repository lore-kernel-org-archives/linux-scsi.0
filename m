From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 11045] New: Bug in MPT Fusion 2.6.26-rc7
	unbootable
Date: Tue, 08 Jul 2008 12:23:33 -0500
Message-ID: <1215537813.3214.22.camel@localhost.localdomain>
References: <bug-11045-10286@http.bugzilla.kernel.org/>
	 <20080708015756.baec287c.akpm@linux-foundation.org>
	 <1215526126.3214.8.camel@localhost.localdomain>
	 <200807081051.33892.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38993 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752983AbYGHRXh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 13:23:37 -0400
In-Reply-To: <200807081051.33892.bjorn.helgaas@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Support, Software" <support@lsi.com>, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsi.com>, kurk@shiftmail.org

On Tue, 2008-07-08 at 10:51 -0600, Bjorn Helgaas wrote:
> On Tuesday 08 July 2008 08:08:46 am James Bottomley wrote:
> > That said, this line:
> > 
> > mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000009!
> > 
> > is absolutely characteristic of a lost interrupt.
> > 
> > With the current LSI driver, we have two possible causes for this.  One
> > is the usual ACPI screw up that we never seem to be able to fix.
> 
> Which ACPI screw up is that?  And what's the usual recipe?

The usual screw up where subtle ACPI breakage from release to release
causes some IRQs to get misrouted.

Usually you start with noacpi and cycle through the pci routing options

> I know about the ancient "pci=routeirq" recipe, but as far as I know,
> there are no current problems that require that.

If you actually read this bug report, you'll see there was a message

ACPI: Resource is not an IRQ entry

Just before the fusion IRQ failed to get delivered, so I think it's a
good indicator that there *are* ACPI problems ...

James


