From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [PATCH] pm8001: enhance firmware event log retrieval
Date: Mon, 20 Feb 2012 11:31:54 -0500
Message-ID: <95CA7344-D026-40CC-9A1E-176C632FC7E0@xyratex.com>
References: <97204CD5-5C4D-4E62-ADD4-CE51AB11C460@xyratex.com>,  <1329578412.2862.24.camel@dabdike> <201202191454024304010@usish.com> <8BB4E44E-AD13-48E8-BA20-A5AAF068E8C6@xyratex.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex197.xyratex.com ([194.131.166.197]:32879 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753400Ab2BTQcA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2012 11:32:00 -0500
In-Reply-To: <8BB4E44E-AD13-48E8-BA20-A5AAF068E8C6@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack_wang <jack_wang@usish.com>
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, crystal_yu <crystal_yu@usish.com>, lindar_liu <lindar_liu@usish.com>

No testing, I agreed on the appearance, make excellent sense and can see no problem with it. I have NOT tested it (Xyratex has no interest in 32-bit systems, this turns into a one-of with no Q/A backing). I will put it in my own queue for testing and submit a fix if I feel it is necessary (my WAG on risk of that is 0.000234% ;-/ )

Sincerely -- Mark Salyzyn

On Feb 20, 2012, at 11:04 AM, Mark Salyzyn wrote:

> Thanks James!
> 
> Sincerely -- Mark Salyzyn
> 
> On Feb 19, 2012, at 1:55 AM, jack_wang wrote:
> 
>> James,
>> 
>> Thanks for fix, looks OK for me.
>> 
>> 
>> 
>> --------------
>> jack_wang
>>> On Wed, 2012-01-18 at 10:48 -0500, Mark Salyzyn wrote:
>>>> -static ssize_t pm8001_ctl_aap_log_show(struct device *cdev,
>>>> -	struct device_attribute *attr, char *buf)
>>>> +static ssize_t pm8001_ctl_log_show(struct device *cdev, char *buf, int ind)
>>>> {
>>>> 	struct Scsi_Host *shost = class_to_shost(cdev);
>>>> 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
>>>> 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
>>>> +	struct eventlog_entry entry;
>>>> +	char *str = buf;
>>>> 	int i;
>>>> -#define AAP1_MEMMAP(r, c) \
>>>> -	(*(u32 *)((u8*)pm8001_ha->memoryMap.region[AAP1].virt_ptr + (r) * 32 \
>>>> -	+ (c)))
>>>> 
>>>> -	char *str = buf;
>>>> -	int max = 2;
>>>> -	for (i = 0; i < max; i++) {
>>>> -		str += sprintf(str, "0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x"
>>>> -			       "0x%08x 0x%08x\n",
>>>> -			       AAP1_MEMMAP(i, 0),
>>>> -			       AAP1_MEMMAP(i, 4),
>>>> -			       AAP1_MEMMAP(i, 8),
>>>> -			       AAP1_MEMMAP(i, 12),
>>>> -			       AAP1_MEMMAP(i, 16),
>>>> -			       AAP1_MEMMAP(i, 20),
>>>> -			       AAP1_MEMMAP(i, 24),
>>>> -			       AAP1_MEMMAP(i, 28));
>>>> +	memset(&entry, 0, sizeof(entry));
>>>> +	do {
>>>> +		i = pm8001_readlog(
>>>> +			(struct eventlog_header *)(
>>>> +				pm8001_ha->memoryMap.region[ind].virt_ptr),
>>>> +			&entry,
>>>> +			(ind == AAP1) ?
>>>> +				&pm8001_ha->aap1_consumer :
>>>> +				&pm8001_ha->iop_consumer);
>>>> +	} while ((i == 0) && !pm8001_validlog(&entry));
>>>> +	if ((i >= 0) && pm8001_validlog(&entry)) {
>>>> +		u32 *lp;
>>>> +		unsigned long long timestamp =
>>>> +			(((unsigned long long)entry.timestamp_upper) << 32) |
>>>> +			entry.timestamp_lower;
>>>> +		str += snprintf(str, PAGE_SIZE - (str - buf),
>>>> +			"%u %llu.%09llu %u",
>>>> +			entry.severity,
>>>> +			timestamp / (1000000000 / 8),
>>>> +			(timestamp % (1000000000 / 8)) * 8,
>>>> +			entry.sequence);
>>> 
>>> You can't do this.  It produces this error on a 32 bit compile:
>>> 
>>> MODPOST 1540 modules
>>> ERROR: "__udivdi3" [drivers/scsi/pm8001/pm8001.ko] undefined!
>>> ERROR: "__umoddi3" [drivers/scsi/pm8001/pm8001.ko] undefined!
>>> make[1]: *** [__modpost] Error 1
>>> make: *** [drivers/scsi/pm8001/pm8001.ko] Error 2
>>> 
>>> because the compiler can't natively do 64 bit division.
>>> 
>>> The fix is something like this (compile tested only)
>>> 
>>> James
>>> 
>>> ---
>>> 
>>> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
>>> index 3fe3d93..0edfe86 100644
>>> --- a/drivers/scsi/pm8001/pm8001_ctl.c
>>> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
>>> @@ -335,12 +335,13 @@ static ssize_t pm8001_ctl_log_show(struct device *cdev, char *buf, int ind)
>>> 		u32 *lp;
>>> 		unsigned long long timestamp =
>>> 			(((unsigned long long)entry.timestamp_upper) << 32) |
>>> -			entry.timestamp_lower;
>>> +			entry.timestamp_lower, remainder;
>>> +		remainder = do_div(timestamp, 1000000000 / 8) * 8;
>>> 		str += snprintf(str, PAGE_SIZE - (str - buf),
>>> 			"%u %llu.%09llu %u",
>>> 			entry.severity,
>>> -			timestamp / (1000000000 / 8),
>>> -			(timestamp % (1000000000 / 8)) * 8,
>>> +			timestamp,
>>> +			remainder,
>>> 			entry.sequence);
>>> 		for (lp = entry.log, i = entry.size; i > 0; --i)
>>> 			str += snprintf(str, PAGE_SIZE - (str - buf),
>>> 
>>> 
>>> __________ Information from ESET NOD32 Antivirus, version of virus signature database 5659 (20101129) __________
>>> 
>>> The message was checked by ESET NOD32 Antivirus.
>>> 
>>> http://www.eset.com
>>> 
>>> 
> 

