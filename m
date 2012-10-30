From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v4 0/5] Migrate SCSI drivers to use dev_pm_ops
Date: Tue, 30 Oct 2012 18:17:57 +0800
Message-ID: <20121030101756.GA30125@aaronlu.sh.intel.com>
References: <1350293219-8154-1-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1350293219-8154-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi James,

Sorry to bother you, will this patchset enter 3.8?

Thanks,
Aaron

On Mon, Oct 15, 2012 at 05:26:54PM +0800, Aaron Lu wrote:
> v4:
> Only Patch 4 is modified:
> Fixed a line over 80 characters warning by checkpatch.pl;
> Update the changelog so that it is no more a try :-)
> 
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
> 
> Aaron Lu (5):
>   sd: put to stopped power state when runtime suspend
>   Revert "[SCSI] scsi_pm: set device runtime state before parent
>     suspended"
>   Revert "[SCSI] runtime resume parent for child's system-resume"
>   pm: use callbacks from dev_pm_ops for scsi devices
>   sd: update sd to use the new pm callbacks
> 
>  drivers/scsi/scsi_pm.c | 98 +++++++++++++++++++++++++++-----------------------
>  drivers/scsi/sd.c      | 18 +++++++---
>  2 files changed, 67 insertions(+), 49 deletions(-)
> 
> -- 
> 1.7.12.21.g871e293
> 
