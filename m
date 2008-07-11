From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: [Bugme-new] [Bug 11045] New: Bug in MPT Fusion 2.6.26-rc7
	unbootable
Date: Fri, 11 Jul 2008 12:33:53 +0800
Message-ID: <6A4D764DC1BDE14495DA8DC60A3D69531E95D72503@hkgmail01.lsi.com>
References: <1215736925.3353.111.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1215736925.3353.111.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: kurk <kurk@shiftmail.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>, "Support, Software" <support@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>
List-Id: linux-scsi@vger.kernel.org

I did a recheck on this, except FC 919X and 929X boards, everything else should work fine with MSI. Hence the SPI boards (1030) should work with MSI and the problem might be with the motherboard.
But we would like to keep the MSI disabled for SPI controllers since we have not tested internally with MSI and FC enabled by default for them in our recent drivers.
So I would like to request to pull in the patch to disable MSI for SPI & FC.
-Thanks
Sathya

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
Sent: Friday, July 11, 2008 6:12 AM
To: Andrew Morton
Cc: kurk; Prakash, Sathya; Bjorn Helgaas; Support, Software; linux-scsi@vger.kernel.org; linux-acpi@vger.kernel.org; bugme-daemon@bugzilla.kernel.org; Moore, Eric
Subject: Re: [Bugme-new] [Bug 11045] New: Bug in MPT Fusion 2.6.26-rc7 unbootable

On Thu, 2008-07-10 at 16:44 -0700, Andrew Morton wrote:
> On Thu, 10 Jul 2008 16:52:01 +0200 kurk <kurk@shiftmail.org> wrote:
>
> > Prakash, Sathya wrote:
> > > This may  be a problem due to enabling MSI for SPI controllers. I have posted another message in the list providing the correction patch which is already in scsi-misc tree.
> > > If the problem is gone with changing the module parameter mpt_msi_enable=0 or by applying the patch http://marc.info/?l=linux-scsi&m=121131228827682&w=4 then it might be due to MSI enabling.
> > >
> > Another good news: I confirm that yes, the problem is also fixed by
> > the patch linked above by Sathya, and in that case it is not needed
> > to specify option mpt_msi_enable=0 for mptbase. Any one of the two
> > (patch or option) is enough to fix the problem.
> > It would be nice to see this patch in the final release of the
> > 2.6.26 kernel Thank you
>
> James, shouldn't we put that into 2.6.26?

I'm still not sure ... if it's a fault on the board with MSI, then yes, we need it in ... although the form would then be wrong because we probably should be identifying the faulty parts and blacklisting them.

If it's actually a fault on the motherboard with MSI, then no, this isn't the patch series that should be in we need the motherboard strings to blacklist it.

Unfortunately, I can't seem to get an answer out of LSI on this question, It looks like the commit will cherry pick easily enough ...
although now I look at it the parameter's description is wrong.

> That whole patch series looks pretty desirable actually..

Well, it was billed as a driver update ... and it has a lot more than just trivial changes, so on an eve of release quality issue, I'd tend to say that wouldn't be a good idea.

James


