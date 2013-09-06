From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: sr: use block layer runtime PM
Date: Fri, 06 Sep 2013 08:00:04 -0700
Message-ID: <1378479604.2063.13.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1309051007220.1121-100000@iolanthe.rowland.org>
	 <52293763.5070206@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58757 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039Ab3IFPAG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 11:00:06 -0400
In-Reply-To: <52293763.5070206@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2013-09-06 at 10:01 +0800, Aaron Lu wrote:
> Migrate SCSI Optical Disk Drive(ODD)

I'm not very keen on this description because it's not quite accurate.
sr stands for SCSI ROM.  You could say optical SCSI ROM perhaps, but
Magneto Optical disks are handled by sd not sr.

>  driver sr to make use of block

I'd just say "Migrate sr to make use of .."

> layer runtime PM. Accordingly, the SCSI bus layer runtime PM callback is
> simplified as all SCSI devices that implement runtime PM are now request
> based.

OK, let's now try for a descriptive changelog.  All SCSI devices
(including sr) are "request based".  I think what you mean is "all SCSI
devices which implement runtime PM have an exposed block device"?

> Note that due to ODD will be polled every 2 seconds,

Since the device will be polled every 2 seconds

>  for suspend to
> actually happen, the autosuspend_delay can not be set to more than 2
> seconds or the polling interval has to be increased.

Is this true?  What about event driven devices?  Supposing a distro has
a different interval.

How about

If your Distribution polls the device, the autosuspend interval cannot
be set to longer than the polling interval otherwise the device will
never suspend.

James


