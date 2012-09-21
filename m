From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Fri, 21 Sep 2012 13:48:44 +0800
Message-ID: <20120921054844.GB2987@mint-spring.sh.intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
 <201209191450.37735.rjw@sisk.pl>
 <5059D488.6070208@intel.com>
 <201209202200.51303.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201209202200.51303.rjw@sisk.pl>
Sender: linux-ide-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 20, 2012 at 10:00:51PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, September 19, 2012, Aaron Lu wrote:
> > Thanks Rafael, and if there is any question/problem,
> > please kindly let me know.
> 
> Well, unfortunately my initial review indicates that the patchset is not
> quite ready to go upstream yet.
> 
> I'll send comments in replies to the individual patches, but overall I can
> say that at this stage of development, when I look at the patches, it should
> be clear to me not only what is being changed, but _why_ it is being changed
> in the first place and, secondly, why it is being changed in this particular
> way.  It's far from that, though.

I'm adding zero power support for optical disk drive(ZPODD), which is
made possible with the newly defined device attention(DA) pin introduced
in SATA 3.1 spec.

The idea here is to use runtime pm to achieve this, so I basically did 2
things:
1 Add runtime pm support for ODD;
2 Add power off support for ODD after it is runtime suspended.

Patch 2 is runtime pm support for ODD, the reason it is done this way is
discussed here:
http://www.spinics.net/lists/linux-scsi/msg61551.html

The basic idea is, the ODD will be runtime suspended as long as there is
nobody using it, that is, no programs opening the block device.

The ODD will be polled periodically, so it will be runtime resumed
before checking if there is any events pending and suspended when done.
The only exception is, if we found a disc is just inserted, we will not
idle it immediately at the end of the poll, reason explained in another
mail.

This is the rational I wrote patch 2, and patch 1 is used by patch 2.

Patch 3 is adding power off support for ODD after it is runtime
suspended, the condition is specified in section 15:
ftp://ftp.seagate.com/sff/INF-8090.PDF

That is, for tray type ODD: no media inside and door closed; for slot
type ODD: no media inside.

The is the reason sr_suspend is written, for non-ZPODD capable devices,
it does nothing; for ZPODD devices, it will check the above condition to
see if it is ready to be powered off. The ready_to_power_off flag will be
used by ATA layer to decide if power can be removed.

When in powered off state, if user presses the eject button or insert a
disc, an ACPI event will be generated and our acpi wake handler will
pm_runtime_resume the ODD. And if it is a tray type ODD, its tray should
be ejected(need_eject flag) after powered on. This is patch 3.

And patch 4-6 introduces a new sysfs file may_power_off to give user a
chance to disable the power off of the device due to various reasons
like the ODD claims support of device attention while actually it is
broken.

I hope it makes more sense to you now.

Thanks,
Aaron

> 
> The first patch in the series doesn't even have a changelog.  How the changelog
> of the second patch is related to it's actual contents is more than quite
> unclear to me.  Etc.
> 
> Thanks,
> Rafael
