From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Fri, 11 Jan 2008 09:44:55 -0600
Message-ID: <1200066295.3286.19.camel@localhost.localdomain>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>
	 <47666904.8060605@panasas.com>
	 <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
	 <476C1472.1040103@redhat.com>
	 <1198271036.3130.60.camel@localhost.localdomain>
	 <476C4177.3030902@redhat.com>
	 <1198277391.3130.73.camel@localhost.localdomain>
	 <9f00bd9d0801031618l324e9078i56b0679a35e27f69@mail.gmail.com>
	 <1200028577.5337.8.camel@localhost.localdomain>
	 <9f00bd9d0801110154i3b2f9c1flf076823747950196@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36564 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760303AbYAKPo7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 10:44:59 -0500
In-Reply-To: <9f00bd9d0801110154i3b2f9c1flf076823747950196@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Filippos Papadopoulos <psybases@gmail.com>
Cc: linux-scsi@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 11:54 +0200, Filippos Papadopoulos wrote:
> On Jan 11, 2008 7:16 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > On Fri, 2008-01-04 at 02:18 +0200, Filippos Papadopoulos wrote:
> > > First of all let me wish a happy new year.
> > > I come back from the vacations and i compiled the initio driver with
> > >
> > > #define DEBUG_INTERRUPT 1
> > > #define DEBUG_QUEUE     1
> > > #define DEBUG_STATE     1
> > > #define INT_DISC        1
> > >
> > > I used the sources from 2.6.24-rc6-git9 kernel. At kernel boot time the initio
> > > driver prints the following:
> > >
> > > " scsi: Initio INI-9X00U/UW SCSI device driver
> > > Find scb at c0c00000
> > > Append pend scb c0c00000;"
> > >
> > > After 3 seconds the whole system freezes there and i have to reboot.
> > >
> > >
> > >
> > > P.S  here is the info from 'lspci -vv' running 2.6.16.13 kernel:
> > >
> > > "00:08.0 SCSI storage controller: Initio Corporation 360P (rev 02)
> > >         Subsystem: Unknown device 9292:0202
> > >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > > ParErr- Stepping- SERR- FastB2B-
> > >         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> > > >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> > >         Latency: 32, Cache Line Size 08
> > >         Interrupt: pin A routed to IRQ 11
> > >         Region 0: I/O ports at d000 [size=256]
> >
> > This proves the BAR0 to be non zero, but I also take it from your report
> > that the
> >
> > initio: I/O port range 0x0 is busy.
> >
> > message is also gone?
> >
> 
> 
> I havent reported "initio: I/O port range 0x0 is busy."

Sorry ... we appear to have several reporters of different bugs in this
thread.  That message was copied by Chuck Ebbert from a Red Hat
bugzilla ... I was assuming it was the same problem.

> > >         Region 1: Memory at ef000000 (32-bit, non-prefetchable) [size=4K]
> > >         [virtual] Expansion ROM at 50000000 [disabled] [size=128K]
> > > "
> >
> > I think there's still one remaining bug from the sg_list conversion,
> > namely that cblk->sglen is never set, but it is used to count the number
> > of elements in the sg array.  Could you try this patch (on top of
> > everything else) and see if the problem is finally fixed?
> >
> 
> I applied the patch on 2.6.24-rc6-git9 but unfortunatelly same thing happens.

First off, has this driver ever worked for you in 2.6?  Just booting
SLES9 (2.6.5) or RHEL4 (2.6.9) ... or one of their open equivalents to
check a really old kernel would be helpful.  If you can get it to work,
then we can proceed with a patch reversion regime based on the
assumption that the problem is a recent commit.

Thanks,

James


