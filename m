From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Mon, 26 Nov 2012 11:32:22 +0400
Message-ID: <1353915142.2523.36.camel@dabdike>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
	  <20121119145605.GC15971@htj.dyndns.org>
	  <1353337611.2444.32.camel@dabdike.int.hansenpartnership.com>
	  <35648985.61QNrr0Knq@vostro.rjw.lan> <1353906191.2523.25.camel@dabdike>
	 <50B2F96D.9080405@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <50B2F96D.9080405@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-11-26 at 13:09 +0800, Aaron Lu wrote:
> On 11/26/2012 01:03 PM, James Bottomley wrote:
> > On Mon, 2012-11-26 at 01:33 +0100, Rafael J. Wysocki wrote:
> >> On Monday, November 19, 2012 03:06:51 PM James Bottomley wrote:
> >>>> I really think we need a way for (auto)pm and event polling to talk to
> >>>> each other so that autopm can tell event poll to sod off while pm is
> >>>> in effect.  Trying to solve this from inside libata doesn't seem
> >>>> right.  The problem, again, seems to be figuring out which hardware
> >>>> device maps to which block device.  Hmmm... Any good ideas?
> >>>
> >>> I've asked the PM people several times about this, because it's a real
> >>> problem for almost everything:  PM needs some type of top to bottom
> >>> stack view, which the layering isolation we have within storage really
> >>> doesn't cope with well.  No real suggestion has been forthcoming.
> >>
> >> Actually, I think that the particular case in question is really special
> >> and the fact that there's the pollig loop that user space is involved in
> >> doesn't make things more stratightforward.
> >>
> >> And PM really doesn't need to see things top to bottom, but the polling
> >> needs to know what happens in the PM land.  We need to be able to tell it
> >> "from now on tell user space that there are no events here".  The question
> >> is where to put that information so that it's accessible to all parts of the
> >> stack involved.
> > 
> > Right, open to suggestions ...
> > 
> >>> The reason I think it should be emulated (in the acpi layer, not libata,
> >>> but as long as it's not in SCSI, I'm not so fussed where it ends up) is
> >>> because ZPODD is the software equivalent of ZPREADY, which will be done
> >>> in hardware and will be effectively invisible to autopm in the same way
> >>> that SCSI (and ATA) power management is mostly invisible.  If we
> >>> currently do ZPREADY emulation in the low layer (i.e. ZPODD has exact
> >>> ZPREADY emulation), we won't care (except for flipping the sofware bit)
> >>> whether the device support ZPODD or ZPREADY and it will all just
> >>> work(tm).  The industry expectation is that ZPODD is just a transition
> >>> state between current power management and ZPREADY.
> >>
> >> Well, if you poll a ZPREADY-capable drive, it will go off and on in cycles
> >> transparently, but still it won't save as much energy as it can.  We'll need
> >> to do something about the polling in that case too, it seems.
> > 
> > No: with ZPREADY, the device effectively lies to the poll.  The Spec
> > says that when it powers off the mechanical pieces, it must reply from
> > firmware to a certain preset emulations of SCSI commands and not wake
> > from power off.  These commands include TEST UNIT READY and a few
> > others, so the device will happily reply to polls while being off (it
> > replies with the original state before power was lost).  When you issue
> > actual medium access commands, or manually insert or remove media it
> > will wake up.
> > 
> > That's why I think ZPODD should emulate this behaviour.
> 
> I suppose you are refering to section 15.3.5?

That's the recommendation for emulating ZPREADY in ZPODD devices, yes.

> I don't think the SPEC says what the host software _must_ do, it's
> informative. And I agree that when possible, we should emulate the
> command without powering up the ODD, but if we can eliminate the noise,
> wouldn't that be better?

The way I look at it is we currently have no real power management for
actual SCSI devices, we rely on the internal timers of the device to
effect power management for us.  ZPREADY fits right into this scheme (as
I think it was designed to) so it seems odd to me that we would
introduce a software PM based scheme for ZPODD, which is an interim spec
until everything supports ZPREADY, and then go back to doing nothing for
ZPREADY.

I'm amenable to a proposal that we *shouldn't* be doing nothing for SCSI
PM and perhaps it should be plumbed into software PM, but it looks odd
to me to have sofware PM for ZPODD but not for at least ZPREADY and
probably for SCSI PM as well.

If we elect to do nothing about ZPREADY and SCSI PM, then I think ZPODD
should be implemented in a way that emulates ZPREADY (i.e. as section
15.3.5 recommends).

James


