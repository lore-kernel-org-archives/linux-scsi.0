From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] pm8001: enhance firmware event log retrieval
Date: Sat, 18 Feb 2012 09:20:12 -0600
Message-ID: <1329578412.2862.24.camel@dabdike>
References: <97204CD5-5C4D-4E62-ADD4-CE51AB11C460@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49478 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab2BRPUO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Feb 2012 10:20:14 -0500
In-Reply-To: <97204CD5-5C4D-4E62-ADD4-CE51AB11C460@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jack Wang <jack_wang@usish.com>, crystal_yu <crystal_yu@usish.com>, lindar_liu <lindar_liu@usish.com>

On Wed, 2012-01-18 at 10:48 -0500, Mark Salyzyn wrote:
> -static ssize_t pm8001_ctl_aap_log_show(struct device *cdev,
> -	struct device_attribute *attr, char *buf)
> +static ssize_t pm8001_ctl_log_show(struct device *cdev, char *buf, int ind)
>  {
>  	struct Scsi_Host *shost = class_to_shost(cdev);
>  	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
>  	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +	struct eventlog_entry entry;
> +	char *str = buf;
>  	int i;
> -#define AAP1_MEMMAP(r, c) \
> -	(*(u32 *)((u8*)pm8001_ha->memoryMap.region[AAP1].virt_ptr + (r) * 32 \
> -	+ (c)))
>  
> -	char *str = buf;
> -	int max = 2;
> -	for (i = 0; i < max; i++) {
> -		str += sprintf(str, "0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x"
> -			       "0x%08x 0x%08x\n",
> -			       AAP1_MEMMAP(i, 0),
> -			       AAP1_MEMMAP(i, 4),
> -			       AAP1_MEMMAP(i, 8),
> -			       AAP1_MEMMAP(i, 12),
> -			       AAP1_MEMMAP(i, 16),
> -			       AAP1_MEMMAP(i, 20),
> -			       AAP1_MEMMAP(i, 24),
> -			       AAP1_MEMMAP(i, 28));
> +	memset(&entry, 0, sizeof(entry));
> +	do {
> +		i = pm8001_readlog(
> +			(struct eventlog_header *)(
> +				pm8001_ha->memoryMap.region[ind].virt_ptr),
> +			&entry,
> +			(ind == AAP1) ?
> +				&pm8001_ha->aap1_consumer :
> +				&pm8001_ha->iop_consumer);
> +	} while ((i == 0) && !pm8001_validlog(&entry));
> +	if ((i >= 0) && pm8001_validlog(&entry)) {
> +		u32 *lp;
> +		unsigned long long timestamp =
> +			(((unsigned long long)entry.timestamp_upper) << 32) |
> +			entry.timestamp_lower;
> +		str += snprintf(str, PAGE_SIZE - (str - buf),
> +			"%u %llu.%09llu %u",
> +			entry.severity,
> +			timestamp / (1000000000 / 8),
> +			(timestamp % (1000000000 / 8)) * 8,
> +			entry.sequence);

You can't do this.  It produces this error on a 32 bit compile:

  MODPOST 1540 modules
ERROR: "__udivdi3" [drivers/scsi/pm8001/pm8001.ko] undefined!
ERROR: "__umoddi3" [drivers/scsi/pm8001/pm8001.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [drivers/scsi/pm8001/pm8001.ko] Error 2

because the compiler can't natively do 64 bit division.

The fix is something like this (compile tested only)

James

---

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 3fe3d93..0edfe86 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -335,12 +335,13 @@ static ssize_t pm8001_ctl_log_show(struct device *cdev, char *buf, int ind)
 		u32 *lp;
 		unsigned long long timestamp =
 			(((unsigned long long)entry.timestamp_upper) << 32) |
-			entry.timestamp_lower;
+			entry.timestamp_lower, remainder;
+		remainder = do_div(timestamp, 1000000000 / 8) * 8;
 		str += snprintf(str, PAGE_SIZE - (str - buf),
 			"%u %llu.%09llu %u",
 			entry.severity,
-			timestamp / (1000000000 / 8),
-			(timestamp % (1000000000 / 8)) * 8,
+			timestamp,
+			remainder,
 			entry.sequence);
 		for (lp = entry.log, i = entry.size; i > 0; --i)
 			str += snprintf(str, PAGE_SIZE - (str - buf),


