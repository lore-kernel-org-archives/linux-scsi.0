From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [Bugme-new] [Bug 11045] New: Bug in MPT Fusion 2.6.26-rc7
	unbootable
Date: Fri, 11 Jul 2008 09:05:34 -0500
Message-ID: <1215785134.3272.8.camel@localhost.localdomain>
References: <6A4D764DC1BDE14495DA8DC60A3D69531E95D72503@hkgmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <6A4D764DC1BDE14495DA8DC60A3D69531E95D72503@hkgmail01.lsi.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kurk <kurk@shiftmail.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>, "Support, Software" <support@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2008-07-11 at 12:33 +0800, Prakash, Sathya wrote:
> I did a recheck on this, except FC 919X and 929X boards, everything
> else should work fine with MSI. Hence the SPI boards (1030) should
> work with MSI and the problem might be with the motherboard.

Right ... that's why I was asking ... my 1030 works fine with MSI.  If
there's a fault with the FC boards, then certainly they should have MSI
disabled.

The motherboard was my suspicion ... especially as older ones have SPI
and newer ones have SAS (and the older ones are most likely to have MSI
faults).  However, I think you can see from our point of view that if
the problem is the motherboard, disabling MSI in the fusion is the wrong
way to fix it.  If we do it this way, we'll promptly get another slew of
nasty bug reports for the next driver that enables MSI and doesn't work
on this platform

> But we would like to keep the MSI disabled for SPI controllers since
> we have not tested internally with MSI and FC enabled by default for
> them in our recent drivers.
> So I would like to request to pull in the patch to disable MSI for SPI & FC.

Yes, we'll do that ... I'll also see if the PCI maintainer can determine
the information needed to blacklist the motherboards so that we don't
get this all over again with them and a different driver.

James


