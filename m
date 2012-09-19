From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Wed, 19 Sep 2012 16:03:30 +0800
Message-ID: <20120919080328.GA4283@mint-spring.sh.intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi James,

May I know if this patchset will enter v3.7?

Thanks,
Aaron

On Wed, Sep 12, 2012 at 04:29:51PM +0800, Aaron Lu wrote:
> v7:
> Re work of runtime pm of sr driver, based on ideas of Alan Stern and
> Oliver Neukum.
> 
> Jeff, due to the ready_to_power_off flag added, there is a small
> change in [PATCH v7 6/6] libata: acpi: respect may_power_off flag,
> please check if I can still get your ack, thanks.
> 
> v6:
> When user changes may_power_off flag through sysfs entry and if device
> is already runtime suspended, resume resume it so that it can respect
> this flag next time it is runtime suspended as suggested by Alan Stern.
> Call scsi_autopm_get/put_device once in sr_check_events as suggested by
> Alan Stern.
> 
> v5:
> Add may_power_off flag to scsi device.
> Alan Stern suggested that I should not mess runtime suspend with
> runtime power off, but the current zpodd implementation made it not
> easy to seperate. So I re-wrote the zpodd implementation, the end
> result is, normal ODD can also enter runtime suspended state, but
> their power won't be removed.
> 
> v4:
> Rebase on top of Linus' tree, due to this, the problem of a missing
> flag in v3 is gone;
> Add a new function scsi_autopm_put_device_autosuspend to first mark
> last busy for the device and then put autosuspend it as suggested by
> Oliver Neukum.
> Typo fix as pointed by Sergei Shtylyov.
> Check can_power_off flag before any runtime pm operations in sr.
> 
> v3:
> Rebase on top of scsi-misc tree;
> Add the sr related patches previously in Jeff's libata tree;
> Re-organize the sr patches.
> A problem for now: for patch
> scsi: sr: support zero power ODD(ZPODD)
> I can't set a flag in libata-acpi.c since a related function is
> missing in scsi-misc tree. Will fix this when 3.6-rc1 released.
> 
> v2:
> Bug fix for v1;
> Use scsi_autopm_* in sr driver instead of pm_runtime_*;
> 
> v1:
> Here are some patches to make ZPODD easier to use for end users and
> a fix for using ZPODD with system suspend.
> 
> Aaron Lu (6):
>   block: genhd: add an interface to set disk poll interval
>   scsi: sr: support runtime pm
>   scsi: sr: support zero power ODD(ZPODD)
>   scsi: pm: add may_power_off flag
>   scsi: sr: use may_power_off
>   libata: acpi: respect may_power_off flag
> 
>  block/genhd.c              | 23 +++++++++----
>  drivers/ata/libata-acpi.c  | 30 +++++++++++-----
>  drivers/scsi/scsi_sysfs.c  | 37 +++++++++++++++++++-
>  drivers/scsi/sr.c          | 86 +++++++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/sr.h          |  1 +
>  drivers/scsi/sr_ioctl.c    |  7 +++-
>  include/linux/genhd.h      |  1 +
>  include/scsi/scsi_device.h |  4 +++
>  8 files changed, 168 insertions(+), 21 deletions(-)
> 
> -- 
> 1.7.12.21.g871e293
> 
