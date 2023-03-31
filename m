Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155B3C76196
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Mar 2023 09:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjCaJLi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Mar 2023 05:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCaJLh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2023 05:11:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8826D199
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 02:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680253847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5detSlxh+tob4EMduKXYNz8Q4TSTXhBrmBRPu0oNPqY=;
        b=F/uIKOZSGQ2cNFeY+iJ+ZAxGfKAl1Phi5s5unjldEzt2f4AdrUH10taLZZjSbjL3vYJjmb
        0m8n8MyKNyQ9cVM98De657q8pHwIqllC4s85Q7vQgslax58y7LzdxE/ylJGZsT5BG0aSHM
        z5MHR4SESxyeQjHID40lE7BzAi9Z5XE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-bZB9ABMgOWWXmQE5l2gVAQ-1; Fri, 31 Mar 2023 05:10:46 -0400
X-MC-Unique: bZB9ABMgOWWXmQE5l2gVAQ-1
Received: by mail-wm1-f72.google.com with SMTP id k25-20020a05600c1c9900b003ef79f2c207so5234300wms.5
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 02:10:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680253844;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5detSlxh+tob4EMduKXYNz8Q4TSTXhBrmBRPu0oNPqY=;
        b=EXE7cWGlDGzsqCWHlHzFO66s2r/j/C41c0jmaDrLtJin5N5HoND1MNaun8y2VEMNk+
         mJdP2EbgaCJg/LBU2/+ufdRTcUboDRaHI8aJQWm2D0NY8nM5WfA3lbvr1y9gghrvhbr7
         0nKlqzBlDpE9UF+DZ3Gyc8BRaVEtoT6GOoCM3rMPwJO5TBT0FcvENIZGmQj7pextxe4n
         QC86WYykbLP9hVsiAK5BpzFMNj9HrcwKNfsRAmn6HAJAcW0KAD77t4XyWLCDQcl5NKKS
         eoT6C7ifgS7ipQZij3685X6AGQEPW24cIndd3rdOufgm1EF2CDG1P3lKHVAcKPIAnTpc
         N1vQ==
X-Gm-Message-State: AAQBX9dopTGyIl3Dut8mjWAk/w3O34UZXua1jvo0ekFG9WpxPDvQHPzH
        7brUi7yOlneK6FOuPlfLSlJSyvAvxUfrMAsDlwa2eEsuVRMqnvHBghOiqQLisjxy/BjKPSnqPMt
        yyTcC82SGPqINv3fNdDJ03PQcvXJ4zQ==
X-Received: by 2002:adf:fe51:0:b0:2d9:457a:1069 with SMTP id m17-20020adffe51000000b002d9457a1069mr20392452wrs.37.1680253844156;
        Fri, 31 Mar 2023 02:10:44 -0700 (PDT)
X-Google-Smtp-Source: AKy350aOratNyTV0ZZWVq4nxaflgGDIl+Ngvd8vs2bQSRZG2WYZ/Xp1uRYW7r4T5jRnJVi3MscIDsQ==
X-Received: by 2002:adf:fe51:0:b0:2d9:457a:1069 with SMTP id m17-20020adffe51000000b002d9457a1069mr20392439wrs.37.1680253843835;
        Fri, 31 Mar 2023 02:10:43 -0700 (PDT)
Received: from [192.168.0.107] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id z15-20020adfec8f000000b002cf1c435afcsm1667003wrn.11.2023.03.31.02.10.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 02:10:43 -0700 (PDT)
Message-ID: <ca2628bb-e824-05fe-751e-a9b060561ff5@redhat.com>
Date:   Fri, 31 Mar 2023 11:10:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20230330164943.11607-1-thenzl@redhat.com>
 <af17886b-5b18-f71f-9fe7-ea929f30b5a6@oracle.com>
From:   Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <af17886b-5b18-f71f-9fe7-ea929f30b5a6@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/30/23 19:12, Mike Christie wrote:
> On 3/30/23 11:49 AM, Tomas Henzl wrote:
>> Set the state to deleted in sd_shutdown so that the attached LLD
>> doesn't receive new I/O (can happen when in kexec) later after
>> LLD's shutdown function has been called.
>>
>> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>> ---
>>  drivers/scsi/sd.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 4f28dd617eca..8095f0302e66 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -3694,10 +3694,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>>  static void sd_shutdown(struct device *dev)
>>  {
>>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
>> +	struct scsi_device *sdp;
>>  
>>  	if (!sdkp)
>>  		return;         /* this can happen */
>>  
>> +	sdp = sdkp->device;
>> +
>>  	if (pm_runtime_suspended(dev))
>>  		return;
>>  
>> @@ -3710,6 +3713,10 @@ static void sd_shutdown(struct device *dev)
>>  		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>>  		sd_start_stop_device(sdkp, 0);
>>  	}
>> +
>> +	mutex_lock(&sdp->state_mutex);
>> +	scsi_device_set_state(sdp, SDEV_DEL);
>> +	mutex_unlock(&sdp->state_mutex);
>>  }
> 
> If this is run for device removal what state will be in here?
> 
> Are we going to do:
> 1. __scsi_remove_device sets the state to SDEV_CANCEL at the beginning
> of the function
> 2. device_unregister causes sd_remove to be called and sd_shutdown sets
> the state to SDEV_DEL
> 3. then ide sets the state to SDEV_DEL at the bottom,
> so we get "Illegal state transition" errors printed.
> 
Thanks for looking.
A state change from SDEV_DEL to SDEV_DEL isn't illegal (state ==
oldstate) or am I wrong?

