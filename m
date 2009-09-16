From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] libosd: osd_dev_info: Unique Identification of an
 OSD device
Date: Wed, 16 Sep 2009 11:47:42 -0600
Message-ID: <1253123262.4842.39.camel@mulgrave.site>
References: <4AA4ED94.2050805@panasas.com>
	 <1252322784-19390-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50676 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219AbZIPRrm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Sep 2009 13:47:42 -0400
In-Reply-To: <1252322784-19390-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On Mon, 2009-09-07 at 14:26 +0300, Boaz Harrosh wrote:
> Define an osd_dev_info structure that Uniquely identifies an OSD
> device lun on the network. The identification is built from unique
> target attributes and is the same for all network/SAN machines.
> 
> osduld_info_lookup() - NEW
>     New API that will lookup an osd_dev by its osd_dev_info.
>     This is used by pNFS-objects for cross network global device
>     identification.
> 
> osduld_device_info() - NEW
>     Given an osd_dev handle returns its associated osd_dev_info.
>     This is used by exofs to encode the device information for
>     network clients. (Get-device-info). The ULD fetches this
>     information at startup and hangs it on each OSD device. (This is
>     a fast operation that can be called at any condition)
> 
> osd_auto_detect_ver() - REVISED
>     Now returns an osd_dev_info structure. Is only called once
>     by ULD as before. See added comments for how to use.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/osd/osd_initiator.c |   22 +++++++++++----
>  drivers/scsi/osd/osd_uld.c       |   53 +++++++++++++++++++++++++++++++++++++-
>  include/scsi/osd_initiator.h     |   37 +++++++++++++++++++++++---
>  3 files changed, 101 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 7a117c1..26e1b41 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -73,7 +73,8 @@ static const char *_osd_ver_desc(struct osd_request *or)
>  
>  #define ATTR_DEF_RI(id, len) ATTR_DEF(OSD_APAGE_ROOT_INFORMATION, id, len)
>  
> -static int _osd_print_system_info(struct osd_dev *od, void *caps)
> +static int _osd_get_print_system_info(struct osd_dev *od,
> +	void *caps, struct osd_dev_info *odi)
>  {
>  	struct osd_request *or;
>  	struct osd_attr get_attrs[] = {
> @@ -137,8 +138,13 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
>  	OSD_INFO("PRODUCT_SERIAL_NUMBER  [%s]\n",
>  		(char *)pFirst);
>  
> -	pFirst = get_attrs[a].val_ptr;
> -	OSD_INFO("OSD_NAME               [%s]\n", (char *)pFirst);
> +	odi->osdname_len = get_attrs[a].len;
> +	if (odi->osdname_len) {
> +		odi->osdname = kzalloc(odi->osdname_len + 1, GFP_KERNEL);
> +		memcpy(odi->osdname, get_attrs[a].val_ptr, odi->osdname_len);
> +	} else
> +		odi->osdname = NULL;
> +	OSD_INFO("OSD_NAME               [%s]\n", odi->osdname);
>  	a++;
>  
>  	pFirst = get_attrs[a++].val_ptr;
> @@ -171,6 +177,9 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
>  				   sid_dump, sizeof(sid_dump), true);
>  		OSD_INFO("OSD_SYSTEM_ID(%d)\n"
>  			 "        [%s]\n", len, sid_dump);
> +
> +		odi->systemid_len = len;
> +		memcpy(odi->systemid, get_attrs[a].val_ptr, len);
>  		a++;
>  	}
>  out:
> @@ -178,16 +187,17 @@ out:
>  	return ret;
>  }
>  
> -int osd_auto_detect_ver(struct osd_dev *od, void *caps)
> +int osd_auto_detect_ver(struct osd_dev *od,
> +	void *caps, struct osd_dev_info *odi)
>  {
>  	int ret;
>  
>  	/* Auto-detect the osd version */
> -	ret = _osd_print_system_info(od, caps);
> +	ret = _osd_get_print_system_info(od, caps, odi);
>  	if (ret) {
>  		osd_dev_set_ver(od, OSD_VER1);
>  		OSD_DEBUG("converting to OSD1\n");
> -		ret = _osd_print_system_info(od, caps);
> +		ret = _osd_get_print_system_info(od, caps, odi);
>  	}
>  
>  	return ret;
> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> index 0bdef33..8c069f9 100644
> --- a/drivers/scsi/osd/osd_uld.c
> +++ b/drivers/scsi/osd/osd_uld.c
> @@ -87,6 +87,7 @@ struct osd_uld_device {
>  	struct osd_dev od;
>  	struct gendisk *disk;
>  	struct device *class_member;
> +	struct osd_dev_info odi;
>  };
>  
>  static void __uld_get(struct osd_uld_device *oud);
> @@ -216,6 +217,48 @@ free_od:
>  }
>  EXPORT_SYMBOL(osduld_path_lookup);
>  
> +static inline bool _the_same_or_null(const u8 *a1, unsigned a1_len,
> +				     const u8 *a2, unsigned a2_len)
> +{
> +	if (!a2_len) /* User string is Empty means don't care */
> +		return true;
> +
> +	if (a1_len != a2_len)
> +		return false;
> +
> +	return 0 == memcmp(a1, a2, a1_len);
> +}
> +
> +struct osd_dev *osduld_info_lookup(const struct osd_dev_info *odi)
> +{
> +	unsigned i;
> +
> +	for (i = 0; i < SCSI_OSD_MAX_MINOR; i++) {
> +		char dev_str[16];
> +		struct osd_uld_device *oud;
> +		struct osd_dev *od;
> +
> +		sprintf(dev_str, "/dev/osd%d", i);

Embedding specific forms user device paths into the kernel really looks
wrong here ... why are you doing this?  What happens if the user uses
udev to give them different names?

> +		od = osduld_path_lookup(dev_str);
> +		if (IS_ERR(od))
> +			continue;
> +
> +		oud = od->file->private_data;
> +		if (_the_same_or_null(oud->odi.systemid, oud->odi.systemid_len,
> +				      odi->systemid, odi->systemid_len) &&
> +		    _the_same_or_null(oud->odi.osdname, oud->odi.osdname_len,
> +				      odi->osdname, odi->osdname_len))

Why not NULL terminate these strings as you pick them out of the device
info?  Then you can dispense with the length and use standard kernel
string comparisons instead of rolling your own.

James


