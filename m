From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Fri, 21 Dec 2007 16:49:51 -0600
Message-ID: <1198277391.3130.73.camel@localhost.localdomain>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <20071217031841.f483e5ac.akpm@linux-foundation.org>
	 <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>
	 <47666904.8060605@panasas.com>
	 <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
	 <476C1472.1040103@redhat.com>
	 <1198271036.3130.60.camel@localhost.localdomain>
	 <476C4177.3030902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [76.243.235.52] ([76.243.235.52]:35223 "EHLO
	accolon.hansenpartnership.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754386AbXLUWuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2007 17:50:19 -0500
In-Reply-To: <476C4177.3030902@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Filippos Papadopoulos <psybases@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


On Fri, 2007-12-21 at 17:43 -0500, Chuck Ebbert wrote:
> On 12/21/2007 04:03 PM, James Bottomley wrote:
> > On Fri, 2007-12-21 at 14:30 -0500, Chuck Ebbert wrote:
> >> On 12/19/2007 03:48 AM, Filippos Papadopoulos wrote:
> >>> On Dec 17, 2007 2:18 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> >>>> I have found one problem. Please try patch [2] below and report.
> >>>> If it still fails try to enable debugging by setting with patch [1]
> >>>> these values at top of drivers/scsi/initio.c. And send dmsgs.
> >>>>
> >>>> Boaz
> >>>>
> >>>
> >>> I tried patch[2] (addition of   sg++)  at 2.6.24-rc5-mm1 but the
> >>> system hangs after some seconds when the initio driver loads.
> >>> I will try patch[1] next week to see what happens.
> >>>
> >>> Would it be better to open a bug report at bugzilla?
> >>>
> >> There is also a Fedora bug report against 2.6.23. The user has
> >> applied commit e9e42faf47255274a1ed0b9bf1c46118023ec5fa from
> >> 2.6.24-rc plus the two additional fixes under discussion and it
> >> hangs for him too.
> >>
> >> https://bugzilla.redhat.com/show_bug.cgi?id=390531
> > 
> > It really sounds like there's some problem applying the patches.  The
> > consistent report throughout is this one:
> > 
> > initio: I/O port range 0x0 is busy.
> > 
> > Which should be fixed by 99f1f534922a2f2251ba05b14657a1c62882a80e.  I
> > didn't actually find that in the bug thread anywhere, but maybe I missed
> > it?
> > 
> 
> The "I/O port 0" bug just prints the message and the system continues
> to run. It's only after that is fixed that the system just hangs on
> boot shortly after loading the driver.

That should happen unless the PCI BAR is genuinely misconfigured; it's
saying we got zero when we requested the starting address of BAR0.  What
does lspci -vv show for this device?

James


