Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED871EE0212
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 00:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbjINA33 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 20:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjINA32 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 20:29:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D73C1720;
        Wed, 13 Sep 2023 17:29:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DBFC433C8;
        Thu, 14 Sep 2023 00:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694651364;
        bh=u75AjhzI2I2y64qVe0s0JRA14+U1Zh/SSzRPBRMoxkE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ru7wNoyMU+gUN8+MNpfgqzeLwwBQWG5zJ/jRhAG/Tejq+ypoHXrFVFN7MkIkkE5JP
         d+wyXQZo2TR1szLBvu59jdN2t9tQzPTRYi/PYwS08ewyJq6YXlw413QPuB0plgh0MY
         eGhNd3Jfhf7J5fvx6JAd+bUkXuPk4vdVFAUtTu76VsJl+1lDE3bUDvILcsN6WEU9t2
         1AnphfEuIeGoEOk6dFHydJofY8euGuTdyixGc+3BekBGOr+W3PQ2DfS+lgaz2vqbTf
         xrQV9dWl4ty3+vQrY1OyJMooNnFzHwUBpjG09ejiAzafeH76/BA2AI7WsOlAok3QLc
         EBfMhmSHZBICw==
Message-ID: <7471ad70-e72c-473c-3c50-7e52b6bad69b@kernel.org>
Date:   Thu, 14 Sep 2023 09:29:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 07/19] scsi: sd: Do not issue commands to suspended disks
 on remove
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-8-dlemoal@kernel.org>
 <c3a4ccb9-2e4d-906c-3c8f-1985a2d444a8@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <c3a4ccb9-2e4d-906c-3c8f-1985a2d444a8@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/14/23 05:50, Bart Van Assche wrote:
> On 9/10/23 21:02, Damien Le Moal wrote:
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
> Why to test the host state instead of dev->power.runtime_status? I don't
> think that it is safe to skip shutdown if the error handler is active.
> If the error handler can recover the device a SYNCHRONIZE CACHE command
> should be submitted.

But there is no synchronization with EH that I can see anyway. At least for
sd_remove(), I would assume that this is called only once the device references
were all dropped, so presumably EH is not doing anything with the drive when
that happen, no ?

In any case, looking at dev->power.runtime_status is not correct as this is set
to RPM_ACTIVE when the device is suspended through system suspend. We could
replace the test "sdkp->device->host->shost_state != SHOST_RUNNING" with
"dev->power.is_suspended", as that indicates true (1) for a suspended device.
However, I really do not like that as that is a PM internal field and should not
be accessing it directly. The PM code comments say as much. Any better idea ?


-- 
Damien Le Moal
Western Digital Research

