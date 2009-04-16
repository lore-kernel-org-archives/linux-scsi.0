From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/2] Add 'tpgs' sysfs attribute for SCSI devices
Date: Thu, 16 Apr 2009 09:30:16 -0700
Message-ID: <1239899416.1196.10.camel@chandra-ubuntu>
References: <20090319080634.918B718C79D@pentland.suse.de>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:50161 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZDPQ37 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 12:29:59 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3GGQexD010435
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 10:26:40 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3GGTnre040486
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 10:29:56 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3GGTlJL023854
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2009 10:29:48 -0600
In-Reply-To: <20090319080634.918B718C79D@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Looks good to me

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Thu, 2009-03-19 at 09:06 +0100, Hannes Reinecke wrote:
> We need the 'TGPS' setting of the inquiry data
> to properly support ALUA. So just add an accessor
> for the stored inquiry data and display it
> in sysfs.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_sysfs.c  |   10 ++++++++++
>  include/scsi/scsi_device.h |    5 +++++
>  2 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index fa4711d..cccdd89 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -586,6 +586,15 @@ sdev_store_timeout (struct device *dev, struct device_attribute *attr,
>  static DEVICE_ATTR(timeout, S_IRUGO | S_IWUSR, sdev_show_timeout, sdev_store_timeout);
> 
>  static ssize_t
> +sdev_show_tpgs (struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_device *sdev;
> +	sdev = to_scsi_device(dev);
> +	return snprintf(buf, 20, "%d\n", scsi_device_tpgs(sdev));
> +}
> +static DEVICE_ATTR(tpgs, S_IRUGO, sdev_show_tpgs, NULL);
> +
> +static ssize_t
>  store_rescan_field (struct device *dev, struct device_attribute *attr,
>  		    const char *buf, size_t count)
>  {
> @@ -745,6 +754,7 @@ static struct attribute *scsi_sdev_attrs[] = {
>  	&dev_attr_vendor.attr,
>  	&dev_attr_model.attr,
>  	&dev_attr_rev.attr,
> +	&dev_attr_tpgs.attr,
>  	&dev_attr_rescan.attr,
>  	&dev_attr_delete.attr,
>  	&dev_attr_state.attr,
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 3f566af..6ac6321 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -450,6 +450,11 @@ static inline int scsi_device_protection(struct scsi_device *sdev)
>  	return sdev->scsi_level > SCSI_2 && sdev->inquiry[5] & (1<<0);
>  }
> 
> +static inline int scsi_device_tpgs(struct scsi_device *sdev)
> +{
> +	return (sdev->inquiry[5] >> 4) &3;
> +}
> +
>  #define MODULE_ALIAS_SCSI_DEVICE(type) \
>  	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
>  #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"

