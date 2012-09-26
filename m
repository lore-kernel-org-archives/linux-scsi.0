From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Wed, 26 Sep 2012 09:20:19 +0200
Message-ID: <1434443.RRHkHMkq2z@linux-lqwf.site>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <1627578.tkYE3uqGuq@linux-lqwf.site> <5061C3AE.6030103@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab2IZHWF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2012 03:22:05 -0400
In-Reply-To: <5061C3AE.6030103@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Tuesday 25 September 2012 22:46:06 Aaron Lu wrote:
> On 09/25/2012 10:23 PM, Oliver Neukum wrote:

> >> BTW, if sr_suspend should be generic, that would suggest I shouldn't
> >> write any ZPODD related code there, right? Any suggestion where these
> >> code should go then?
> > 
> > libata. Maybe some generic hooks can be called in sr_suspend().
> 
> Thanks for the suggestion.
> The problem is, I need to know whether the door is closed and if there
> is a medium inside. I've no way of getting such information in libata.

Hooks can be called with the necessary parameters. I suggest
a triplett of medium presence, tray state and door lock state.
That should cover most types of drives.

> > PS: Are you sure sr_suspend() handles DVD-RAMs correctly?
> 
> No. Is there a spec for it?

Mount Fuji I presume.

> Considering there are many different drives sr handle, is it possible to
> write a generic sr_suspend?

There are two different issues. sr handles some different devices:
CD/DVD/BD-ROMs, -writers and -RAMs. For those you can have different
code paths in sr. That is no problem at all.

In addition devices can be attached by different hardware. In fact
the same drive can be attached in a USB enclosure or by SATA.
>From the perspective of power management they are no longer
the same device.

Those are best handled in callbacks and limited use of special cases in
sr.

> Maybe your suggestion of callback is the way to go.
> What about this idea, if we find this is a ZPODD capable drive, we
> enable runtime suspend for it and write a suspend callback according to
> ZPODD spec. For other drives that does not have a suspend callback, we
> do not enable runtime suspend.
> Does this sound reasonable?

No. It would badly harm usb-storage.
You need to leave paths open for other device types.

	Regards
		Oliver

