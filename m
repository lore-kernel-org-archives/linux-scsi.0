Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9821C84A6
	for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2026 21:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777496797; cv=none; b=B7K/zEOQdzK6HAFSJS/fQwDjbhQ300enMAf3eTsuc2Z1O22caix/fxELzJv/Es3GoeZ0zFqlRzoa4RWqlcCvG+mrVtBfJkt/Y/RZygt+6rhMaObCKLibbMz1f/oTMyycXmvBULbFta4KYbdlDWvkWmzpDThTaPtGYCLHMBdTlfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777496797; c=relaxed/simple;
	bh=QabG8u9QAMpTxOtbPlyXIKt5yOAvbisWQ7X6Ue2XD48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xgjavv8PBKYttMNFEpaAYKozfW37OZcHCk8GcwrZ3tC39jmYmyn6Kddg6NCYj1X6ztP75VYc/aBympdF8+6BKvfw2qT/TGrlJT77sdk9EEmteRe/LEO9TZchugNlPPmjHvPjXvRLLQsxJtTTxaMUp1GbQKL+Y6px049WwhpiJgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hrknk8GC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hrknk8GC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF8FC19425;
	Wed, 29 Apr 2026 21:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777496796;
	bh=QabG8u9QAMpTxOtbPlyXIKt5yOAvbisWQ7X6Ue2XD48=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Hrknk8GCPBYLmWZ6mlF/sYHdTzTHq+/ixUjPuEmBIBDFKEufmIYt1xTh0awIeNyNN
	 JIszKLePtOPK99jkd85jbSQ4fO8riPmPsuUUReU4xsryLiY7W7hhD1asvn7xhDcH0y
	 nEt0NZLznYgC3G5WIvYO9XTBFm+rjsKpZL4yx2srXhf6gDNyKG1CjJuAe7mAPUqwL0
	 WSZHrJRDI23oNX0s+04Ab0A5F8fB7K1qNaKqVRAOJWXjobrDmDBUI+giT6DjfnMYom
	 0RyQZz6naxvwwnDLWKw8Qrh+Mp5mPbcUN0tZOBumGaGkkcu3ew8xhijqb99XxXzfo9
	 LV30v+CzHSipA==
Message-ID: <dbaecbf2-be76-44d4-949b-d2703ff4a7e2@kernel.org>
Date: Thu, 30 Apr 2026 06:06:34 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: hare@suse.de, Krishna Kant <krishna.kant@purestorage.com>
References: <0a89cb03-31d6-4f5f-a84c-a838d4d99ab5@suse.de>
 <20260429012733.40855-1-brian@purestorage.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260429012733.40855-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/29/26 10:27, Brian Bunker wrote:
> All INQUIRY-derived sysfs attributes (type, scsi_level, vendor, model,
> rev, cdl_supported, and the binary inquiry attribute) read data that
> can be updated during device rescan. These reads must be protected
> against concurrent updates.
> 
> Use the existing inquiry_mutex to protect access to these sysfs
> attributes. This ensures that userspace always sees consistent INQUIRY
> data, even if a rescan is updating the buffer concurrently.
> 
> Replace the sdev_rd_attr macro with two new helpers,
> sdev_rd_inquiry_attr_int and sdev_rd_inquiry_attr_str, which generate
> the show functions for INQUIRY-derived integer and string fields and
> take the inquiry_mutex around the field access.
> 
> This is preparatory work for adding INQUIRY data update support during
> device rescan operations.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> ---
> v2:
>   - Protect all INQUIRY-derived fields (type, scsi_level, cdl_supported),
>     not just the string fields (vendor, model, rev) and binary inquiry
>     attribute. If we accept that INQUIRY data can change, we cannot assume
>     which fields will change.
>   - Replace the sdev_rd_attr macro with sdev_rd_inquiry_attr_int and
>     sdev_rd_inquiry_attr_str helpers to avoid duplicating the lock/unlock
>     boilerplate across each show function.
> 
>  drivers/scsi/scsi_sysfs.c | 69 +++++++++++++++++++++++++++++++--------
>  1 file changed, 55 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index dfc3559e7e04f..4a2b89e13b7bf 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -636,22 +636,58 @@ sdev_show_##field (struct device *dev, struct device_attribute *attr,	\
>  }									\
>  
>  /*
> - * sdev_rd_attr: macro to create a function and attribute variable for a
> - * read only field.
> + * sdev_rd_inquiry_attr_int: macro to create a function and attribute for a
> + * read-only INQUIRY-derived integer field. The inquiry_mutex protects
> + * against concurrent updates during device rescan.
>   */
> -#define sdev_rd_attr(field, format_string)				\
> -	sdev_show_function(field, format_string)			\
> -static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL);
> +#define sdev_rd_inquiry_attr_int(field)					\
> +static ssize_t								\
> +sdev_show_##field(struct device *dev, struct device_attribute *attr,	\
> +		  char *buf)						\
> +{									\
> +	struct scsi_device *sdev = to_scsi_device(dev);			\
> +	ssize_t ret;							\
> +									\
> +	mutex_lock(&sdev->inquiry_mutex);				\
> +	ret = snprintf(buf, 20, "%d\n", sdev->field);			\

sysfs_emit() ?

> +	mutex_unlock(&sdev->inquiry_mutex);				\
> +	return ret;							\
> +}									\
> +static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL)
> +
> +/*
> + * sdev_rd_inquiry_attr_str: macro to create a function and attribute for a
> + * read-only INQUIRY-derived string field. The inquiry_mutex protects
> + * against concurrent updates during device rescan.
> + */
> +#define sdev_rd_inquiry_attr_str(field, accessor, len)			\
> +static ssize_t								\
> +sdev_show_##field(struct device *dev, struct device_attribute *attr,	\
> +		  char *buf)						\
> +{									\
> +	struct scsi_device *sdev = to_scsi_device(dev);			\
> +	ssize_t ret;							\
> +									\
> +	mutex_lock(&sdev->inquiry_mutex);				\
> +	if (sdev->inquiry)						\
> +		ret = snprintf(buf, 20, "%.*s\n", len,			\
> +			       accessor(sdev->inquiry));		\
> +	else								\
> +		ret = snprintf(buf, 20, "\n");				\

Same here.

> +	mutex_unlock(&sdev->inquiry_mutex);				\
> +	return ret;							\
> +}									\
> +static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL)
>  
>  /*
>   * Create the actual show/store functions and data structures.
>   */
> -sdev_rd_attr (type, "%d\n");
> -sdev_rd_attr (scsi_level, "%d\n");
> -sdev_rd_attr (vendor, "%.8s\n");
> -sdev_rd_attr (model, "%.16s\n");
> -sdev_rd_attr (rev, "%.4s\n");
> -sdev_rd_attr (cdl_supported, "%d\n");
> +sdev_rd_inquiry_attr_int(type);
> +sdev_rd_inquiry_attr_int(scsi_level);
> +sdev_rd_inquiry_attr_int(cdl_supported);
> +sdev_rd_inquiry_attr_str(vendor, scsi_inq_vendor, SCSI_INQ_VENDOR_LEN);
> +sdev_rd_inquiry_attr_str(model, scsi_inq_product, SCSI_INQ_PRODUCT_LEN);
> +sdev_rd_inquiry_attr_str(rev, scsi_inq_revision, SCSI_INQ_REVISION_LEN);
>  
>  static ssize_t
>  sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
> @@ -915,12 +951,17 @@ static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
>  {
>  	struct device *dev = kobj_to_dev(kobj);
>  	struct scsi_device *sdev = to_scsi_device(dev);
> +	ssize_t ret;
>  
> +	mutex_lock(&sdev->inquiry_mutex);
>  	if (!sdev->inquiry)
> -		return -EINVAL;
> +		ret = -EINVAL;
> +	else
> +		ret = memory_read_from_buffer(buf, count, &off, sdev->inquiry,
> +					       sdev->inquiry_len);
> +	mutex_unlock(&sdev->inquiry_mutex);
>  
> -	return memory_read_from_buffer(buf, count, &off, sdev->inquiry,
> -				       sdev->inquiry_len);
> +	return ret;
>  }
>  
>  static const struct bin_attribute dev_attr_inquiry = {


-- 
Damien Le Moal
Western Digital Research
