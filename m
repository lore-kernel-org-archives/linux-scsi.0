From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] SCSI: add dynamic Power Management infrastructure
Date: Mon, 03 Mar 2008 17:24:19 -0600
Message-ID: <1204586659.3043.92.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0803031107360.3611-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58304 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854AbYCCXYY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 18:24:24 -0500
In-Reply-To: <Pine.LNX.4.44L0.0803031107360.3611-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

On Mon, 2008-03-03 at 11:09 -0500, Alan Stern wrote:
> This patch (as1042) introduces dynamic Power Management for the SCSI
> stack.  It keeps track of devices' logical state and adds a
> notification callback to tell the host adapter driver when some or all
> of the devices on a SCSI bus are no longer in use, so the link can be
> powered down.
> 
> It also adds autosuspend capability (disabled initially) that can be
> controlled by userspace, using the same sort of sysfs API as the USB
> autosuspend implementation.
> 
> Everything is managed by a new Kconfig option:
> CONFIG_SCSI_DYNAMIC_PM.  If that symbol isn't set then essentially
> nothing is changed (some code gets moved from one source file to
> another).

First the general comments/questions:

1. It's done at the wrong level: suspend "device" is actually a target
function.  There's no way on a multi-lun device we want to keep the
flags and last_busy anywhere but in the target

2. As you say in the comment, the thing we're trying to power down is
the link.  In most SCSI implementations, the link has a rather complex
relationship to the target, what we want to do in
periodic_autosuspend_scan() is run over the devices on each link, and if
they're not busy suspend the link?  What's probably needed is a set of
adjunct helpers for the transport classes to do this.

3. The link power down is much faster than device spin down ... in your
patch these two things seem to be coupled ... we really need to keep
them separate.

4. The entanglement with error handling is incredibly problematic (since
eh is a nastily complex state machine in its own right).  What do
transports that use eh_strategy_handler do about all of this?


Then the specific code:

> +scsi_mod-y                     += scsi_scan.o scsi_sysfs.o scsi_devinfo.o \
> +                                  scsi_pm.o

If you just said N to SCSI_DYNAMIC_PM why does it still get compiled in?



> 		.name		= "sd",
>  		.probe		= sd_probe,
>  		.remove		= sd_remove,
> -		.suspend	= sd_suspend,
> -		.resume		= sd_resume,
>  		.shutdown	= sd_shutdown,
>  	},
>  	.rescan			= sd_rescan,
>  	.done			= sd_done,
> +	.suspend		= sd_suspend,
> +	.resume			= sd_resume,
>  };

You're duplicating the driver suspend/resume methods in scsi_driver.  We
just had a discussion about this at the storage summit.  Those methods
are staying, so we might as well not duplicate them.

James


James


