From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 0/5] Migrate SCSI drivers to use dev_pm_ops
Date: Fri, 12 Oct 2012 11:07:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1210121105200.1605-100000@iolanthe.rowland.org>
References: <1350025178-2976-1-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45757 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754867Ab2JLPHT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Oct 2012 11:07:19 -0400
In-Reply-To: <1350025178-2976-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Fri, 12 Oct 2012, Aaron Lu wrote:

> v3:
> Only patch 4 is modified:
> Remove the special case for system freeze in scsi_bus_suspend_common
> as pointed out by Alan Stern;
> Updated some comments;
> Removed the use of typedef (*pm_callback_t)(struct device *).
> 
> v2:
> Change the runtime suspend behaviour of sd driver by putting the device
> into stopped power state.
> Revert 2 patches which are no longer needed as pointed out by Alan Stern.
> Find out device callbacks in bus callbacks as suggested by Alan Stern.
> 
> Due to these changes, patch number grows from 2 -> 5.
> 
> v1:
> The 2 patches will migrate SCSI drivers to use the pm callbacks defined
> in dev_pm_ops as pm_message is deprecated and should not be used by driver.
> Bus level callback is changed to use callbacks defined in dev_pm_ops when
> needed and sd's pm callback is updated to use what are defined in dev_pm_ops.
> 
> Aaron Lu (5):
>   sd: put to stopped power state when runtime suspend
>   Revert "[SCSI] scsi_pm: set device runtime state before parent
>     suspended"
>   Revert "[SCSI] runtime resume parent for child's system-resume"
>   pm: use callbacks from dev_pm_ops for scsi devices
>   sd: update sd to use the new pm callbacks
> 
>  drivers/scsi/scsi_pm.c | 97 +++++++++++++++++++++++++++-----------------------
>  drivers/scsi/sd.c      | 18 +++++++---
>  2 files changed, 66 insertions(+), 49 deletions(-)

Remember to run all the patches through checkpatch.pl before submitting
them.  Aside from that, for the whole series:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

