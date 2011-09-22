From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 4/5] mvsas: remove mvs_slave_{alloc|configure}
Date: Wed, 21 Sep 2011 22:31:40 -0400
Message-ID: <4E7A9E0C.3090509@pobox.com>
References: <20110920220819.1094.12265.stgit@localhost6.localdomain6> <20110920221051.1094.39578.stgit@localhost6.localdomain6> <F766E4F80769BD478052FB6533FA745D1A1150A607@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f42.google.com ([209.85.212.42]:40643 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1IVCbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Sep 2011 22:31:45 -0400
In-Reply-To: <F766E4F80769BD478052FB6533FA745D1A1150A607@SC-VEXCH4.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>

On 09/21/2011 10:26 PM, Xiangliang Yu wrote:
>
>> Subject: [PATCH 4/5] mvsas: remove mvs_slave_{alloc|configure}
>>
>> libsas now handles:
>> 1/ limiting ata scanning to lun0
>> 2/ maximizing the queue_depth of sas devices (up to 256, mvsas only
>>     supports 64)
>> 3/ changes to /sys/block/<sdX>/device/queue_depth for ata devices
>>
>> Cc: Xiangliang Yu<yuxiangl@marvell.com>
>> Signed-off-by: Dan Williams<dan.j.williams@intel.com>
>> ---
>>   drivers/scsi/mvsas/mv_init.c |    4 ++--
>>   drivers/scsi/mvsas/mv_sas.c  |   30 ------------------------------
>>   drivers/scsi/mvsas/mv_sas.h  |    2 --
>>   3 files changed, 2 insertions(+), 34 deletions(-)
>>
>> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
>> index 4e9af66..052861b 100644
>> --- a/drivers/scsi/mvsas/mv_init.c
>> +++ b/drivers/scsi/mvsas/mv_init.c
>> @@ -59,7 +59,7 @@ static struct scsi_host_template mvs_sht = {
>>   	.name			= DRV_NAME,
>>   	.queuecommand		= sas_queuecommand,
>>   	.target_alloc		= sas_target_alloc,
>> -	.slave_configure	= mvs_slave_configure,
>> +	.slave_configure	= sas_slave_configure,
>>   	.slave_destroy		= sas_slave_destroy,
>>   	.scan_finished		= mvs_scan_finished,
>>   	.scan_start		= mvs_scan_start,
>> @@ -74,7 +74,7 @@ static struct scsi_host_template mvs_sht = {
>>   	.use_clustering		= ENABLE_CLUSTERING,
>>   	.eh_device_reset_handler = sas_eh_device_reset_handler,
>>   	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
>> -	.slave_alloc		= mvs_slave_alloc,
>> +	.slave_alloc		= sas_slave_alloc,
>>   	.target_destroy		= sas_target_destroy,
>> -int mvs_slave_configure(struct scsi_device *sdev)
>> -{
>> -	struct domain_device *dev = sdev_to_domain_dev(sdev);
>> -	int ret = sas_slave_configure(sdev);
>> -
>> -	if (ret)
>> -		return ret;
>> -	if (!dev_is_sata(dev)) {
>> -		sas_change_queue_depth(sdev,
>> -			MVS_QUEUE_SIZE,
>> -			SCSI_QDEPTH_DEFAULT);
>> -	}
>> -	return 0;
> Can you don't remove mvs_slave_configure function? Someday it will be useful, such as fixing some issue.
> Thanks!

There is no reason to keep a no-op function there.

	Jeff





