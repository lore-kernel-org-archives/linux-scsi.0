From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] pm8001: panics/lockups from asynchronous device removal.
Date: Wed, 18 Jan 2012 09:37:45 +0800
Message-ID: <76FDDB1AAADD45AC9478B974333A04D7@usish.com.cn>
References: <09A902B5-56B8-46CB-82B7-0DF81E7BBC12@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:56480 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab2ARBjb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2012 20:39:31 -0500
In-Reply-To: <09A902B5-56B8-46CB-82B7-0DF81E7BBC12@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mark Salyzyn' <mark_salyzyn@xyratex.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>
Cc: 'crystal_yu' <crystal_yu@usish.com>, 'lindar_liu' <lindar_liu@usish.com>, 'James Bottomley' <JBottomley@parallels.com>

RE [PATCH] pm8001: panics/lockups from asynchronous device removal.
> 
> pm8001_query_task() and pm8001_abort_task() panic kernel when devices
> asynchronously disappear, a possible scenario since these functions are
> generally called when errors are mounting. Some of the panics are a direct
> result of a failure to NULL check some of the structure variables that are
in
> certain states of teardown. One of the lockups was a direct result of
returning
> an unexpected code to libsas' sas_scsi_find_task() function (creating a
tight
> loop of an unexpected code 138 upstream to the scsi layer queue function).
> 
> Signed-off-by: mark_salyzyn@xyratex.com
> Cc: jack_wang@usish.com
> Cc: JBottomley@parallels.com
> Cc: crystal_yu@usish.com
> Cc: john_gong@usish.com
> Cc: lindar_liu <lindar_liu@usish.com>
> 
>  drivers/scsi/pm8001/pm8001_sas.c |   22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c
> b/drivers/scsi/pm8001/pm8001_sas.c
> index fb3dc99..1cac756 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -940,6 +940,8 @@ int pm8001_query_task(struct sas_task *task)
>  		struct pm8001_hba_info *pm8001_ha =
>  			pm8001_find_ha_by_dev(dev);
> 
> +		if (unlikely(!cmnd || !cmnd->device))
> +			return rc;
>  		int_to_scsilun(cmnd->device->lun, &lun);
>  		rc = pm8001_find_tag(task, &tag);
>  		if (rc == 0) {
> @@ -947,9 +949,11 @@ int pm8001_query_task(struct sas_task *task)
>  			return rc;
>  		}
>  		PM8001_EH_DBG(pm8001_ha, pm8001_printk("Query:["));
> -		for (i = 0; i < 16; i++)
> -			printk(KERN_INFO "%02x ", cmnd->cmnd[i]);
> -		printk(KERN_INFO "]\n");
> +		if (pm8001_ha->logging_level & PM8001_EH_LOGGING) {
> +			for (i = 0; i < 16; i++)
> +				printk(KERN_LEVEL "%02x ", cmnd->cmnd[i]);
> +			printk(KERN_LEVEL "]\n");
[Jack Wang] 

Here KERN_LEVEL is wrong, maybe you means KERN_INFO, others is good, thanks
for fix this.


