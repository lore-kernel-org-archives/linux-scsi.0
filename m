From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 1/2] scsi: lpfc: avoid harmless comparison warning
Date: Fri, 15 Jul 2016 12:16:06 -0700
Message-ID: <645bbd12-a11b-96af-f9d2-2d7eeafe97e3@broadcom.com>
References: <20160615204231.3784044-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:33229 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbcGOTQO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2016 15:16:14 -0400
Received: by mail-qk0-f171.google.com with SMTP id p74so110174599qka.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2016 12:16:14 -0700 (PDT)
In-Reply-To: <20160615204231.3784044-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Hannes Reinicke <hare@suse.de>, James Bottomley <JBottomley@Odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Patch is good.

Thanks

-- james


Signed-off-by: James Smart <james.smart@broadcom.com>

On 6/15/2016 1:42 PM, Arnd Bergmann wrote:
> When building with -Wextra, we get a lot of warnings for the lpfc driver
> concerning expressions that are always true, starting with:
>
> drivers/scsi/lpfc/lpfc_attr.c: In function 'lpfc_enable_npiv_init':
> drivers/scsi/lpfc/lpfc_attr.c:2786:77: error: comparison of unsigned expression >= 0 is always true [-Werror=type-limits]
> drivers/scsi/lpfc/lpfc_attr.c: In function 'lpfc_enable_rrq_init':
> drivers/scsi/lpfc/lpfc_attr.c:2802:76: error: comparison of unsigned expression >= 0 is always true [-Werror=type-limits]
> drivers/scsi/lpfc/lpfc_attr.c: In function 'lpfc_suppress_link_up_init':
> drivers/scsi/lpfc/lpfc_attr.c:2812:2050: error: comparison of unsigned expression >= 0 is always true [-Werror=type-limits]
> drivers/scsi/lpfc/lpfc_attr.c: In function 'lpfc_log_verbose_init':
> drivers/scsi/lpfc/lpfc_attr.c:3064:1930: error: comparison of unsigned expression >= 0 is always true [-Werror=type-limits]
>
> The code works as intented, but it would be nice to shut up the
> warning so we don't clutter up build logs with this. Using a
> separate inline function for it makes it clear to the compiler
> that the comparison is necessary in the caller but still lets
> it do the constant-folding.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/scsi/lpfc/lpfc_attr.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index cfec2eca4dd3..3e1d2e669902 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -1620,6 +1620,11 @@ lpfc_sriov_hw_max_virtfn_show(struct device *dev,
>   	return snprintf(buf, PAGE_SIZE, "%d\n", max_nr_virtfn);
>   }
>   
> +static inline bool lpfc_rangecheck(uint val, uint min, uint max)
> +{
> +	return val >= min && val <= max;
> +}
> +
>   /**
>    * lpfc_param_show - Return a cfg attribute value in decimal
>    *
> @@ -1697,7 +1702,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
>   static int \
>   lpfc_##attr##_init(struct lpfc_hba *phba, uint val) \
>   { \
> -	if (val >= minval && val <= maxval) {\
> +	if (lpfc_rangecheck(val, minval, maxval)) {\
>   		phba->cfg_##attr = val;\
>   		return 0;\
>   	}\
> @@ -1732,7 +1737,7 @@ lpfc_##attr##_init(struct lpfc_hba *phba, uint val) \
>   static int \
>   lpfc_##attr##_set(struct lpfc_hba *phba, uint val) \
>   { \
> -	if (val >= minval && val <= maxval) {\
> +	if (lpfc_rangecheck(val, minval, maxval)) {\
>   		lpfc_printf_log(phba, KERN_ERR, LOG_INIT, \
>   			"3052 lpfc_" #attr " changed from %d to %d\n", \
>   			phba->cfg_##attr, val); \
> @@ -1856,7 +1861,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
>   static int \
>   lpfc_##attr##_init(struct lpfc_vport *vport, uint val) \
>   { \
> -	if (val >= minval && val <= maxval) {\
> +	if (lpfc_rangecheck(val, minval, maxval)) {\
>   		vport->cfg_##attr = val;\
>   		return 0;\
>   	}\
> @@ -1888,7 +1893,7 @@ lpfc_##attr##_init(struct lpfc_vport *vport, uint val) \
>   static int \
>   lpfc_##attr##_set(struct lpfc_vport *vport, uint val) \
>   { \
> -	if (val >= minval && val <= maxval) {\
> +	if (lpfc_rangecheck(val, minval, maxval)) {\
>   		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT, \
>   			"3053 lpfc_" #attr \
>   			" changed from %d (x%x) to %d (x%x)\n", \

