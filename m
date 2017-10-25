From: jeffy <jeffy.chen@rock-chips.com>
Subject: Re: [PATCHv6,2/5] scsi: Export blacklist flags to sysfs
Date: Wed, 25 Oct 2017 09:48:10 +0800
Message-ID: <59EFED5A.5050209@rock-chips.com>
References: <1506954397-2237-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.140]:47090 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdJYBsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2017 21:48:22 -0400
In-Reply-To: <1506954397-2237-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

Hi guys,

maybe we need to add the generated scsi_devinfo_tbl.c into 
drivers/scsi/.gitignore :)

On 10/02/2017 10:26 PM, Hannes Reinecke wrote:
> Each scsi device is scanned according to the found blacklist flags,
> but this information is never presented to sysfs.
> This makes it quite hard to figure out if blacklisting worked as
> expected.
> With this patch we're exporting an additional attribute 'blacklist'
> containing the blacklist flags for this device.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>   drivers/scsi/Makefile     |  8 ++++++++
>   drivers/scsi/scsi_scan.c  |  1 +
>   drivers/scsi/scsi_sysfs.c | 37 +++++++++++++++++++++++++++++++++++++
>   3 files changed, 46 insertions(+)
>
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 93dbe58..c4298c7 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -191,6 +191,14 @@ clean-files :=	53c700_d.h 53c700_u.h
>
>   $(obj)/53c700.o $(MODVERDIR)/$(obj)/53c700.ver: $(obj)/53c700_d.h
>
> +$(obj)/scsi_sysfs.o: $(obj)/scsi_devinfo_tbl.c
> +
> +quiet_cmd_bflags = GEN     $@
> +	cmd_bflags = sed -n 's/.*BLIST_\([A-Z0-9_]*\) *.*/BLIST_FLAG_NAME(\1),/p' $< > $@
> +
> +$(obj)/scsi_devinfo_tbl.c: include/scsi/scsi_devinfo.h
> +	$(call if_changed,bflags)
> +
>   # If you want to play with the firmware, uncomment
>   # GENERATE_FIRMWARE := 1
>
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index e7818af..26edd61 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -984,6 +984,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   		scsi_attach_vpd(sdev);
>
>   	sdev->max_queue_depth = sdev->queue_depth;
> +	sdev->sdev_bflags = *bflags;
>
>   	/*
>   	 * Ok, the device is now all set up, we can
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index bf53356..fde3f44 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -20,6 +20,7 @@
>   #include <scsi/scsi_dh.h>
>   #include <scsi/scsi_transport.h>
>   #include <scsi/scsi_driver.h>
> +#include <scsi/scsi_devinfo.h>
>
>   #include "scsi_priv.h"
>   #include "scsi_logging.h"
> @@ -966,6 +967,41 @@ static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth,
>   }
>   static DEVICE_ATTR(wwid, S_IRUGO, sdev_show_wwid, NULL);
>
> +#define BLIST_FLAG_NAME(name) [ilog2(BLIST_##name)] = #name
> +static const char *const sdev_bflags_name[] = {
> +#include "scsi_devinfo_tbl.c"
> +};
> +#undef BLIST_FLAG_NAME
> +
> +static ssize_t
> +sdev_show_blacklist(struct device *dev, struct device_attribute *attr,
> +		    char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	int i;
> +	ssize_t len = 0;
> +
> +	for (i = 0; i < sizeof(sdev->sdev_bflags) * BITS_PER_BYTE; i++) {
> +		const char *name = NULL;
> +
> +		if (!(sdev->sdev_bflags & BIT(i)))
> +			continue;
> +		if (i < ARRAY_SIZE(sdev_bflags_name) && sdev_bflags_name[i])
> +			name = sdev_bflags_name[i];
> +
> +		if (name)
> +			len += snprintf(buf + len, PAGE_SIZE - len,
> +					"%s%s", len ? " " : "", name);
> +		else
> +			len += snprintf(buf + len, PAGE_SIZE - len,
> +					"%sINVALID_BIT(%d)", len ? " " : "", i);
> +	}
> +	if (len)
> +		len += snprintf(buf + len, PAGE_SIZE - len, "\n");
> +	return len;
> +}
> +static DEVICE_ATTR(blacklist, S_IRUGO, sdev_show_blacklist, NULL);
> +
>   #ifdef CONFIG_SCSI_DH
>   static ssize_t
>   sdev_show_dh_state(struct device *dev, struct device_attribute *attr,
> @@ -1151,6 +1187,7 @@ static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
>   	&dev_attr_queue_depth.attr,
>   	&dev_attr_queue_type.attr,
>   	&dev_attr_wwid.attr,
> +	&dev_attr_blacklist.attr,
>   #ifdef CONFIG_SCSI_DH
>   	&dev_attr_dh_state.attr,
>   	&dev_attr_access_state.attr,
>
>
