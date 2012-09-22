From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Sat, 22 Sep 2012 09:32:57 +0200
Message-ID: <7102619.L8oEHmBsA2@linux-lqwf.site>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <20120921054844.GB2987@mint-spring.sh.intel.com> <201209212318.28137.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <201209212318.28137.rjw@sisk.pl>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lu@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Friday 21 September 2012 23:18:27 Rafael J. Wysocki wrote:

> Now, James says he doesn't like the way ready_to_power_off is used.  Sure
> enough, it is totally irrelevant to the majority of SCSI devices.  It actually
> is totally irrelevant to everything in the SCSI subsystem except for the sr
> driver and libata.  So I wonder if you have considered any alternative
> way to address the use case at hand?

Strictly speaking, USB on very modern systems could use it, but doesn't
in the current implementation.

> That sounds reasonable enough, but the role of the powered_off and
> need_eject flags could be explained a bit better.  In particular, it would

I think need_eject needs to be renamed. Something like "media_change_detected"

> be nice to have explained why they have to be present in struct scsi_device,
> because they don't seem to be particularly useful for many SCSI devices
> that aren't CD drives (the need_eject one in particular).

There are sd devices with removable media.
 
> User space has an interface to disable runtime PM of any device and it looks
> like that interface should be sufficient to disable the feature in question.
> Why do you think the new interface is needed?

Because this is not equivalent to doing no runtime PM at all. SCSI
now defines some powersaving states which do not involve powering
down and thus losing state.

	Regards
		Oliver

