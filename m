From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 3/4] Enable link power management for ata drivers
Date: Wed, 01 Aug 2007 17:27:39 +0900
Message-ID: <46B043FB.5090005@gmail.com>
References: <20070705194909.337398431@intel.com> <20070705130530.5873afeb.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.231]:25729 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759545AbXHAI1s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 04:27:48 -0400
Received: by qb-out-0506.google.com with SMTP id e11so137445qbe
        for <linux-scsi@vger.kernel.org>; Wed, 01 Aug 2007 01:27:47 -0700 (PDT)
In-Reply-To: <20070705130530.5873afeb.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

Kristen Carlson Accardi wrote:
> libata drivers can define a function (enable_pm) that will
> perform hardware specific actions to enable whatever power
> management policy the user set up from the scsi sysfs 
> interface if the driver supports it.  This power management 
> policy will be activated after all disks have been 
> enumerated and intialized.  Drivers should also define
> disable_pm, which will turn off link power management, but
> not change link power management policy.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Please update the patch against the current libata-dev#upstream and
there are several lines where tab follows space and git-applymbox isn't
happy about it.  Those lines are in other patches too.

> +int ata_scsi_set_link_pm_policy(struct Scsi_Host *shost,
> +		enum scsi_host_link_pm policy)
> +{
> +	struct ata_port *ap = ata_shost_to_port(shost);
> +	int rc = -EINVAL;
> +	int i;
> +
> +	/*
> + 	 * make sure no broken devices are on this port,
> + 	 * and that all devices support interface power
> + 	 * management
> + 	 */
> +	for (i = 0; i < ATA_MAX_DEVICES; i++) {
> +		struct ata_device *dev = &ap->device[i];
> +
> +		/* only check drives which exist */
> +		if (!ata_dev_enabled(dev))
> +			continue;
> +
> +		/*
> + 		 * do we need to handle the case where we've hotplugged
> + 		 * a broken drive (since hotplug and ALPM are mutually
> + 		 * exclusive) ?
> + 		 *
> + 		 * If so, if we detect a broken drive on a port with
> + 		 * alpm already enabled, then we should reset the policy
> + 		 * to off for the entire port.
> + 		 */
> +		if ((dev->horkage & ATA_HORKAGE_ALPM) ||
> +			!(dev->flags & ATA_DFLAG_IPM)) {
> +			ata_dev_printk(dev, KERN_ERR,
> +				"Unable to set Link PM policy\n");
> +			ap->pm_policy = SHOST_MAX_PERFORMANCE;
> +		}
> +	}
> +
> +	if (ap->ops->enable_pm)
> +		rc = ap->ops->enable_pm(ap, policy);
> +
> +	if (!rc)
> +		shost->shost_link_pm_policy = ap->pm_policy;
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(ata_scsi_set_link_pm_policy);

This function is directly called from SCSI sysfs write, right?  You
can't do this without synchronizing with EH.  The best way is to define
an EH action and ask EH to transit between powersave states.

> @@ -2021,6 +2021,9 @@ int ata_dev_configure(struct ata_device 
>  	if (dev->flags & ATA_DFLAG_LBA48)
>  		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
>  
> +	if (ata_id_has_hipm(dev->id) || ata_id_has_dipm(dev->id))
> +		dev->flags |= ATA_DFLAG_IPM;

Is it safe to use ALPM on a device which only claims to support DIPM?

> @@ -2046,6 +2049,13 @@ int ata_dev_configure(struct ata_device 
>  		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
>  					 dev->max_sectors);
>  
> +	if (ata_device_blacklisted(dev) & ATA_HORKAGE_ALPM) {
> +		dev->horkage |= ATA_HORKAGE_ALPM;

I think this should be ATA_HORKAGE_IPM.

> @@ -6385,6 +6426,8 @@ int ata_host_register(struct ata_host *h
>  		struct ata_port *ap = host->ports[i];
>  
>  		ata_scsi_scan_host(ap);
> +		ata_scsi_set_link_pm_policy(ap->scsi_host,
> +				ap->pm_policy);

Again, this should be done from EH.

> @@ -321,6 +321,8 @@ struct ata_taskfile {
>  	  ((u64) (id)[(n) + 0]) )
>  
>  #define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
> +#define ata_id_has_hipm(id)	((id)[76] & (1 << 9))
> +#define ata_id_has_dipm(id)	((id)[78] & (1 << 3))

We probably need !0xffff test here.

-- 
tejun
