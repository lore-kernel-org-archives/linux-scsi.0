Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DAD8EEAA4E
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 14:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240206AbjINOjv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Sep 2023 10:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240180AbjINOju (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Sep 2023 10:39:50 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D38CC7;
        Thu, 14 Sep 2023 07:39:46 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-68fac346f6aso899861b3a.3;
        Thu, 14 Sep 2023 07:39:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694702386; x=1695307186;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bRoKtsiFAz/RMqwXABsGqDBkTSHzyKsRHQZwuhxYtn8=;
        b=rlU7z48Wi7gubkowFviIKU5RMPq1J+ehlZYSEXqc4ceXTQiN+pfWgPEqHkmEOzj36J
         4jb5rTTVvbHvn7fo54hl4KrJeZuLfu+utxgEhVJc2N1VPoNdU/MLDQyuL/WOm6t8hpnU
         W9PBrIonJex+OS2GSKGyWhhKRCseXhIY7F8WECs7eU4vFIZoEgWFKP0kXLTqwax5Zha1
         G49c2ETX+6JZdBIzHvo+O523Rj5uKD3+eh4iwh1AVOkQ2kCBZYmvams4BNoqyZlFFbTm
         EQYLOBC7bnzHCIlcu7Tok6E+EFplQkidGU1ferYzKpak4lXLZ9ruqzpoccOXLbAbh5mu
         rC6Q==
X-Gm-Message-State: AOJu0Yy0X0IKup29lofe6e7HkA+Z/g6J9sXNI7ov06ku8xQox0gF/yo1
        OvROD0rvxbh8iqlr6Txcy2U=
X-Google-Smtp-Source: AGHT+IHSffktFu5d7/9xYkPcrFaRgCjhC9+0LWv5uXUshmnt1VeMITaWSMWJU1jIHVMsLsifkVqHLQ==
X-Received: by 2002:a17:902:d4c8:b0:1bb:9c45:130f with SMTP id o8-20020a170902d4c800b001bb9c45130fmr6375747plg.69.1694702385550;
        Thu, 14 Sep 2023 07:39:45 -0700 (PDT)
Received: from ?IPV6:2601:647:5f00:5f5:4a46:e57b:bee0:6bc6? ([2601:647:5f00:5f5:4a46:e57b:bee0:6bc6])
        by smtp.gmail.com with ESMTPSA id jn18-20020a170903051200b001a98f844e60sm1663848plb.263.2023.09.14.07.39.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 07:39:45 -0700 (PDT)
Message-ID: <b1ae5e2f-458f-4675-80df-9871cad05dfc@acm.org>
Date:   Thu, 14 Sep 2023 07:39:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/19] scsi: sd: Do not issue commands to suspended disks
 on remove
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
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
 <7471ad70-e72c-473c-3c50-7e52b6bad69b@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7471ad70-e72c-473c-3c50-7e52b6bad69b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/23 17:29, Damien Le Moal wrote:
> On 9/14/23 05:50, Bart Van Assche wrote:
>> On 9/10/23 21:02, Damien Le Moal wrote:
>>> If an error occurs when resuming a host adapter before the devices
>>> attached to the adapter are resumed, the adapter low level driver may
>>> remove the scsi host, resulting in a call to sd_remove() for the
>>> disks of the host. However, since this function calls sd_shutdown(),
>>> a synchronize cache command and a start stop unit may be issued with the
>>> drive still sleeping and the HBA non-functional. This causes PM resume
>>> to hang, forcing a reset of the machine to recover.
>>>
>>> Fix this by checking a device host state in sd_shutdown() and by
>>> returning early doing nothing if the host state is not SHOST_RUNNING.
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>>> ---
>>>    drivers/scsi/sd.c | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>>> index c92a317ba547..a415abb721d3 100644
>>> --- a/drivers/scsi/sd.c
>>> +++ b/drivers/scsi/sd.c
>>> @@ -3763,7 +3763,8 @@ static void sd_shutdown(struct device *dev)
>>>    	if (!sdkp)
>>>    		return;         /* this can happen */
>>>    
>>> -	if (pm_runtime_suspended(dev))
>>> +	if (pm_runtime_suspended(dev) ||
>>> +	    sdkp->device->host->shost_state != SHOST_RUNNING)
>>>    		return;
>>>    
>>>    	if (sdkp->WCE && sdkp->media_present) {
>>
>> Why to test the host state instead of dev->power.runtime_status? I don't
>> think that it is safe to skip shutdown if the error handler is active.
>> If the error handler can recover the device a SYNCHRONIZE CACHE command
>> should be submitted.
> 
> But there is no synchronization with EH that I can see anyway. At least for
> sd_remove(), I would assume that this is called only once the device references
> were all dropped, so presumably EH is not doing anything with the drive when
> that happen, no ?
> 
> In any case, looking at dev->power.runtime_status is not correct as this is set
> to RPM_ACTIVE when the device is suspended through system suspend. We could
> replace the test "sdkp->device->host->shost_state != SHOST_RUNNING" with
> "dev->power.is_suspended", as that indicates true (1) for a suspended device.
> However, I really do not like that as that is a PM internal field and should not
> be accessing it directly. The PM code comments say as much. Any better idea ?

I will reply to the above question on v2 of this patch.

Bart.

