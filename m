From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Fri, 21 Sep 2012 23:18:27 +0200
Message-ID: <201209212318.28137.rjw@sisk.pl>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <201209202200.51303.rjw@sisk.pl> <20120921054844.GB2987@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120921054844.GB2987@mint-spring.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Friday, September 21, 2012, Aaron Lu wrote:
> On Thu, Sep 20, 2012 at 10:00:51PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, September 19, 2012, Aaron Lu wrote:
> > > Thanks Rafael, and if there is any question/problem,
> > > please kindly let me know.
> > 
> > Well, unfortunately my initial review indicates that the patchset is not
> > quite ready to go upstream yet.
> > 
> > I'll send comments in replies to the individual patches, but overall I can
> > say that at this stage of development, when I look at the patches, it should
> > be clear to me not only what is being changed, but _why_ it is being changed
> > in the first place and, secondly, why it is being changed in this particular
> > way.  It's far from that, though.
> 
> I'm adding zero power support for optical disk drive(ZPODD), which is
> made possible with the newly defined device attention(DA) pin introduced
> in SATA 3.1 spec.
> 
> The idea here is to use runtime pm to achieve this, so I basically did 2
> things:
> 1 Add runtime pm support for ODD;
> 2 Add power off support for ODD after it is runtime suspended.
> 
> Patch 2 is runtime pm support for ODD, the reason it is done this way is
> discussed here:
> http://www.spinics.net/lists/linux-scsi/msg61551.html

Why isn't it explained in the patch changelog, then?  People should be able
to learn why things are done the way they are done from git logs.

> The basic idea is, the ODD will be runtime suspended as long as there is
> nobody using it, that is, no programs opening the block device.
> 
> The ODD will be polled periodically, so it will be runtime resumed
> before checking if there is any events pending and suspended when done.

OK.  So what happens if we power off the drive via runtime PM.  Does it
it really make sense to resumie it through polling in that case?

> The only exception is, if we found a disc is just inserted, we will not
> idle it immediately at the end of the poll, reason explained in another
> mail.
> 
> This is the rational I wrote patch 2, and patch 1 is used by patch 2.
> 
> Patch 3 is adding power off support for ODD after it is runtime
> suspended, the condition is specified in section 15:
> ftp://ftp.seagate.com/sff/INF-8090.PDF
> 
> That is, for tray type ODD: no media inside and door closed; for slot
> type ODD: no media inside.
> 
> The is the reason sr_suspend is written, for non-ZPODD capable devices,
> it does nothing; for ZPODD devices, it will check the above condition to
> see if it is ready to be powered off. The ready_to_power_off flag will be
> used by ATA layer to decide if power can be removed.

Now, James says he doesn't like the way ready_to_power_off is used.  Sure
enough, it is totally irrelevant to the majority of SCSI devices.  It actually
is totally irrelevant to everything in the SCSI subsystem except for the sr
driver and libata.  So I wonder if you have considered any alternative
way to address the use case at hand?

> When in powered off state, if user presses the eject button or insert a
> disc, an ACPI event will be generated and our acpi wake handler will
> pm_runtime_resume the ODD. And if it is a tray type ODD, its tray should
> be ejected(need_eject flag) after powered on. This is patch 3.

That sounds reasonable enough, but the role of the powered_off and
need_eject flags could be explained a bit better.  In particular, it would
be nice to have explained why they have to be present in struct scsi_device,
because they don't seem to be particularly useful for many SCSI devices
that aren't CD drives (the need_eject one in particular).

> And patch 4-6 introduces a new sysfs file may_power_off to give user a
> chance to disable the power off of the device due to various reasons
> like the ODD claims support of device attention while actually it is
> broken.

User space has an interface to disable runtime PM of any device and it looks
like that interface should be sufficient to disable the feature in question.
Why do you think the new interface is needed?

> I hope it makes more sense to you now.

Well, thanks for the explanation. :-)

Rafael
