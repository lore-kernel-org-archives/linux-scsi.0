From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Wed, 28 Nov 2012 01:51 +0100
Message-ID: <21511277.LLinyDpbAK@vostro.rjw.lan>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com> <35648985.61QNrr0Knq@vostro.rjw.lan> <1353906191.2523.25.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1353906191.2523.25.camel@dabdike>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday, November 26, 2012 09:03:11 AM James Bottomley wrote:
> On Mon, 2012-11-26 at 01:33 +0100, Rafael J. Wysocki wrote:
> > On Monday, November 19, 2012 03:06:51 PM James Bottomley wrote:
> > > > I really think we need a way for (auto)pm and event polling to talk to
> > > > each other so that autopm can tell event poll to sod off while pm is
> > > > in effect.  Trying to solve this from inside libata doesn't seem
> > > > right.  The problem, again, seems to be figuring out which hardware
> > > > device maps to which block device.  Hmmm... Any good ideas?
> > > 
> > > I've asked the PM people several times about this, because it's a real
> > > problem for almost everything:  PM needs some type of top to bottom
> > > stack view, which the layering isolation we have within storage really
> > > doesn't cope with well.  No real suggestion has been forthcoming.
> > 
> > Actually, I think that the particular case in question is really special
> > and the fact that there's the pollig loop that user space is involved in
> > doesn't make things more stratightforward.
> > 
> > And PM really doesn't need to see things top to bottom, but the polling
> > needs to know what happens in the PM land.  We need to be able to tell it
> > "from now on tell user space that there are no events here".  The question
> > is where to put that information so that it's accessible to all parts of the
> > stack involved.
> 
> Right, open to suggestions ...

Having considered that a bit more I'm now thinking that in fact the power state
the device is in at the moment doesn't really matter, so the polling code need
not really know what PM is doing.  What it needs to know is that the device
will generate a hardware event when something interesting happens, so it is not
necessary to poll it.

In this particular case it is related to power management (apparently, hardware
events will only be generated after the device has been put into ACPI D3cold,
or so Aaron seems to be claiming), but it need not be in general, at least in
principle.

It looks like we need an "event driven" flag that the can be set in the lower
layers and read by the upper layers.  I suppose this means it would need to be
in struct device, but not necessarily in the PM-specific part of it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
