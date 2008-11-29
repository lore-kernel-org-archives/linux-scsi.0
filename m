From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12120] New: [Block layer or SCSI] requests aborted too
	early during check_partition()
Date: Sat, 29 Nov 2008 12:35:28 -0600
Message-ID: <1227983728.4636.2.camel@localhost.localdomain>
References: <bug-12120-11613@http.bugzilla.kernel.org/>
	 <tkrat.ff41089ef3c5d74f@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45847 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbYK2Sfb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2008 13:35:31 -0500
In-Reply-To: <tkrat.ff41089ef3c5d74f@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, bugme-daemon@bugzilla.kernel.org

On Sat, 2008-11-29 at 16:12 +0100, Stefan Richter wrote:
> On 29 Nov, bugme-daemon@bugzilla.kernel.org wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=12120
> > 
> >            Summary: [Block layer or SCSI] requests aborted too early during
> >                     check_partition()
> >            Product: IO/Storage
> >            Version: 2.5
> >      KernelVersion: 2.6.28-rc
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: SCSI
> >         AssignedTo: linux-scsi@vger.kernel.org
> >         ReportedBy: stefan-r-bz@s5r6.in-berlin.de
> > OtherBugsDependingO 11808
> >              nThis:
> >         Regression: 1
> > 
> > 
> > Latest working kernel version: 2.6.27.4
> > Earliest failing kernel version: 2.6.28-rc6  (I didn't test earlier -rcs yet)
> > 
> > Hardware Environment: OxSemi 912 and 92x based FireWire harddisks
> > 
> > 
> > See http://marc.info/?l=linux-scsi&m=122774022130397 --
> > Disks may still spin their motor up when the kernel attempts to read
> > partitions. In kernel 2.6.27, this was handled transparently.  But since
> > 2.6.28-rc?, the kernel immediately aborts the associated requests and sets the
> > new scsi_device offline.
> > 
> > 
> 
> I tried a workaround in firewire-sbp2:  Check whether the new sdev is
> offline right after scsi_add_device.  If so, remove the sdev and try
> everything again.  However,
>   - a regression still remains because the addition of the HDD takes
>     about 30...40 seconds instead of only a few seconds like in 2.6.27.
>   - The workaround works with OXFW912 and OXUF922, but not with
>     OXUF924DSB.  Login retries don't succeed with the latter at all.
>   - The workaround would be very hard to implement in the older
>     ieee1394/sbp2 driver.
>   - Other hardware besides FireWire may be affected.

It sounds like the device isn't being spun up, so commands which require
media read are being failed with not ready.  Could we get some traces to
show this; just enable all tracing in the boot up sequence:

echo 0xffffffff > /sys/module/scsi_mod/parameters/scsi_logging_level

James


