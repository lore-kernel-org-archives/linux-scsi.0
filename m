Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D521EEAA7A
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 22:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjINWHF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Sep 2023 18:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjINWHE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Sep 2023 18:07:04 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB742120;
        Thu, 14 Sep 2023 15:07:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B91C433C7;
        Thu, 14 Sep 2023 22:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694729219;
        bh=peC8G2St7SrUI4w1+U7VoNyq9rLia7awpVJcZMXy0iw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=LycfGHMNLTqDieHV3ajrY7z/BbHk+cX6hshm7GkxT/8QeQj8o5Rift/7B884n+vPj
         nB/09b+Cf9BxJive14/ZD/0rOJCPv17VDoc8k/qFIjox5ons0alMxAjsbliwfPkbKD
         UayxDu+E0An2frRIIehsa+Kr2JX0KIiNApN3QqRUyG7je7reBQbWmzUwR246st491q
         OwmCpAWVlXadONJrFItOLBxdv7KsFw6JEHjAKBSjTqGiMWTa6PiSvOX9i8cBqHgB/5
         1nhhSE+xhUMSf9fLouu8hEDr0r2jK1mHfSGsxWHj4MeCVZQ4DpyRh2mQO954I8muDt
         lv7HeYyz0prDA==
Message-ID: <38745ab7-eb24-aec3-acaa-184b780fc314@kernel.org>
Date:   Fri, 15 Sep 2023 07:06:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 07/21] scsi: sd: Do not issue commands to suspended
 disks on remove
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230912005655.368075-1-dlemoal@kernel.org>
 <20230912005655.368075-8-dlemoal@kernel.org>
 <b706672c-5f43-4a78-a976-0a47093ec612@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <b706672c-5f43-4a78-a976-0a47093ec612@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/14/23 23:48, Bart Van Assche wrote:
> On 9/11/23 17:56, Damien Le Moal wrote:
>> If an error occurs when resuming a host adapter before the devices
>> attached to the adapter are resumed, the adapter low level driver may
>> remove the scsi host, resulting in a call to sd_remove() for the
>> disks of the host. However, since this function calls sd_shutdown(),
>> a synchronize cache command and a start stop unit may be issued with the
>> drive still sleeping and the HBA non-functional. This causes PM resume
>> to hang, forcing a reset of the machine to recover.
>>
>> Fix this by checking a device host state in sd_shutdown() and by
>> returning early doing nothing if the host state is not SHOST_RUNNING.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/sd.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index c92a317ba547..a415abb721d3 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -3763,7 +3763,8 @@ static void sd_shutdown(struct device *dev)
>>   	if (!sdkp)
>>   		return;         /* this can happen */
>>   
>> -	if (pm_runtime_suspended(dev))
>> +	if (pm_runtime_suspended(dev) ||
>> +	    sdkp->device->host->shost_state != SHOST_RUNNING)
>>   		return;
>>   
>>   	if (sdkp->WCE && sdkp->media_present) {
> 
> The above seems wrong to me because no SYNCHRONIZE CACHE command will be
> sent even if the device is still present, if the SCSI error handler is
> active and if it will succeed at a later time. How about replacing the
> above patch with something like the untested patch below?
> 
> Thanks,
> 
> Bart.
> 
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4cd281368826..c0e069d9d58e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3689,12 +3689,14 @@ static int sd_probe(struct device *dev)
>   static int sd_remove(struct device *dev)
>   {
>   	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +	int rpm_get_res;
> 
> -	scsi_autopm_get_device(sdkp->device);
> +	rpm_get_res = scsi_autopm_get_device(sdkp->device);
> 
>   	device_del(&sdkp->disk_dev);
>   	del_gendisk(sdkp->disk);
> -	sd_shutdown(dev);
> +	if (rpm_get_res >= 0)
> +		sd_shutdown(dev);
> 
>   	put_disk(sdkp->disk);
>   	return 0;

OK. Let me try this.

-- 
Damien Le Moal
Western Digital Research

