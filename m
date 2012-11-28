From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Tue, 27 Nov 2012 17:39:28 -0800
Message-ID: <20121128013928.GB15971@htj.dyndns.org>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
 <35648985.61QNrr0Knq@vostro.rjw.lan>
 <1353906191.2523.25.camel@dabdike>
 <21511277.LLinyDpbAK@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34821 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab2K1Bje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Nov 2012 20:39:34 -0500
Content-Disposition: inline
In-Reply-To: <21511277.LLinyDpbAK@vostro.rjw.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

Hey, Rafael.

On Wed, Nov 28, 2012 at 01:51:00AM +0100, Rafael J. Wysocki wrote:
> Having considered that a bit more I'm now thinking that in fact the power state
> the device is in at the moment doesn't really matter, so the polling code need
> not really know what PM is doing.  What it needs to know is that the device
> will generate a hardware event when something interesting happens, so it is not
> necessary to poll it.
> 
> In this particular case it is related to power management (apparently, hardware
> events will only be generated after the device has been put into ACPI D3cold,
> or so Aaron seems to be claiming), but it need not be in general, at least in
> principle.
> 
> It looks like we need an "event driven" flag that the can be set in the lower
> layers and read by the upper layers.  I suppose this means it would need to be
> in struct device, but not necessarily in the PM-specific part of it.

We already have that.  That's what gendisk->async_events is for (as
opposed to gendisk->events).  If all events are async_events, block
won't poll for events, but I'm not sure that's the golden bullet.

* None implements async_events yet and an API is missing -
  disk_check_events() - which is trivial to add, but it's the same
  story.  We'll need a mechanism to shoot up notification from libata
  to block layer.  It's admittedly easier to justify routing through
  SCSI tho.  So, we're mostly shifting the problem.  Given that async
  events is nice to have, so it isn't a bad idea.

* Still dunno much about zpodd but IIUC the notification from
  zero-power is via ACPI.  To advertise that the device doesn't need
  polling, it should also be able to do async notification while
  powered up, which isn't covered by zpodd but ATA async notification.
  So, ummm... that's another obstacle.  If zpodd requires the device
  to support ATA async notification, it might not be too bad tho.

Thanks.

-- 
tejun
