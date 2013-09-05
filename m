From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] scsi: sr: use block layer runtime PM
Date: Thu, 5 Sep 2013 10:25:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1309051007220.1121-100000@iolanthe.rowland.org>
References: <52281C16.5040108@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47483 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753581Ab3IEOZE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2013 10:25:04 -0400
In-Reply-To: <52281C16.5040108@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: James Bottomley <JBottomley@parallels.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 5 Sep 2013, Aaron Lu wrote:

> Migrate SCSI Optical Disk Drive(ODD) driver sr to make use of block
> layer runtime PM. Accordingly, the SCSI bus layer runtime PM callback is
> simplified as all SCSI devices that implement runtime PM are now request
> based.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
> Note that due to ODD will be polled every 2 seconds, for suspend to
> actually happen, the autosuspend_delay can not be set to more than 2
> seconds.

Or the polling delay must be increased.

> Also, make sure to use the util-linux utility of version 2.23.2 or later,
> as there is a bug fix for eject command to correctly update the ODD's
> locked state. If the fix is not applied, after the ODD is ejected with the
> eject command, it will not be able to enter runtime suspend state any
> more due to SCSI EH code will submit a lock door command for the ODD
> right after its parent ATA port is runtime suspended.
> https://git.kernel.org/cgit/utils/util-linux/util-linux.git/commit/?id=12272030e563201e0b06732d8a87d8cea7157a04

I think this patch will cause a compile warning if you have
CONFIG_PM_RUNTIME set and CONFIG_PM_SLEEP disabled.  The
scsi_dev_type_suspend and scsi_dev_type_resume routines will be defined
but not used.

Otherwise it seems okay.

Alan Stern

