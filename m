Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF0DC77B60
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Mar 2023 09:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbjCaJFa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Mar 2023 05:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjCaJFE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2023 05:05:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8357520300
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 02:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680253430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Bo9IQsqMpMF99a0VutVWyOuOhvFVrCkMQvwrxzAdLo=;
        b=TrBcV4RtPcaXgD50dOLL2ZzA1md1dT0YpfJIoNr7lrYrG956ocT+SVT05jWZ0su5D6H1TJ
        NQjBW4wf0V+zFsGFHy44t9A4xwqADw39bwijO2Q+Ww4nNWNsKDcSIDDxbWd/RhSgPcRzaW
        FR65nAydvvWYN6rpZj+CdmS9XyXgnY4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-SO_bcYkaNdikthCdD4R6Yg-1; Fri, 31 Mar 2023 05:03:46 -0400
X-MC-Unique: SO_bcYkaNdikthCdD4R6Yg-1
Received: by mail-wm1-f71.google.com with SMTP id i4-20020a05600c354400b003ef649aa8c7so9450456wmq.6
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 02:03:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680253423;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Bo9IQsqMpMF99a0VutVWyOuOhvFVrCkMQvwrxzAdLo=;
        b=Dv2LV+BBgxm+tf3iOLXo+r2Db/MD5myMf6liDaUQ+m+3rUkVnJR5rXsuUbMmEiXqea
         JOZGet2bhLoTWDEZz1tBJZ9cmLwOBOdRUUiA+YzjYLw1ZmP3bv+6Ddt801Z2MyyaGneN
         x61Ycg1DM4l/CAFD6XZFv7iI/l5LZ4D8JL9Shu1bvMIu8W5PswIn/JfG34KsmNZFAu9e
         1Z63cVJp+Od/kJumcQiMHxbIHlf0quku5Djn30LfCVE0G0nY7pHYezmpNLVT6N0zbezN
         Zxdve7X8ni00/519FgrkBVQZ+Q55N63oXlk9/dmT1WNXd3jT0z6dQhdAdira+IUoRmEC
         MLoA==
X-Gm-Message-State: AAQBX9fFauHja5sAV/YWFD6CknATY3RszXC0XBOPNq/1nGYn98u//fZT
        fexs0My+FLcV42szmNdv44Bc0uk6Ve0+02lbCbbAAeoNmUjroXaysdwAMqGdCTUXquld6xf347/
        sZBTR35Q3WMAw3ZDHsLZcDAe4bxYjaw==
X-Received: by 2002:adf:e90b:0:b0:2d4:751d:675b with SMTP id f11-20020adfe90b000000b002d4751d675bmr19544297wrm.35.1680253423735;
        Fri, 31 Mar 2023 02:03:43 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZBEBqeTjz0AIGQOdT6PmL7HHKicWmC63MQtDwzHqz1vWGUbxf6yHHJFLX/K+EULlI5rsU5QA==
X-Received: by 2002:adf:e90b:0:b0:2d4:751d:675b with SMTP id f11-20020adfe90b000000b002d4751d675bmr19544287wrm.35.1680253423417;
        Fri, 31 Mar 2023 02:03:43 -0700 (PDT)
Received: from [192.168.0.107] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id b6-20020a5d5506000000b002e463bd49e3sm1618157wrv.66.2023.03.31.02.03.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 02:03:42 -0700 (PDT)
Message-ID: <3750da49-44b1-131d-9d27-2f77e84a2656@redhat.com>
Date:   Fri, 31 Mar 2023 11:03:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
References: <20230330164943.11607-1-thenzl@redhat.com>
 <f4ad668a-5b22-734d-0491-4ed6e065ade9@acm.org>
Content-Language: en-US
From:   Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <f4ad668a-5b22-734d-0491-4ed6e065ade9@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/30/23 19:08, Bart Van Assche wrote:
> On 3/30/23 09:49, Tomas Henzl wrote:
>> Set the state to deleted in sd_shutdown so that the attached LLD
>> doesn't receive new I/O (can happen when in kexec) later after
>> LLD's shutdown function has been called.
>>
>> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>> ---
>>   drivers/scsi/sd.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 4f28dd617eca..8095f0302e66 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -3694,10 +3694,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>>   static void sd_shutdown(struct device *dev)
>>   {
>>   	struct scsi_disk *sdkp = dev_get_drvdata(dev);
>> +	struct scsi_device *sdp;
>>   
>>   	if (!sdkp)
>>   		return;         /* this can happen */
>>   
>> +	sdp = sdkp->device;
>> +
>>   	if (pm_runtime_suspended(dev))
>>   		return;
>>   
>> @@ -3710,6 +3713,10 @@ static void sd_shutdown(struct device *dev)
>>   		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>>   		sd_start_stop_device(sdkp, 0);
>>   	}
>> +
>> +	mutex_lock(&sdp->state_mutex);
>> +	scsi_device_set_state(sdp, SDEV_DEL);
>> +	mutex_unlock(&sdp->state_mutex);
>>   }
> 
> Shouldn't new I/O to the SCSI disk be prevented whether or not the SCSI 
> disk has been runtime suspended?
Thanks, I'll fix that.
Tomas

> 
> Thanks,
> 
> Bart.
> 

