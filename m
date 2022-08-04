Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B74C25B06
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 21:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiHDVHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 17:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiHDVHO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 17:07:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB5756580E
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 14:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659647232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yIosAhkjdjbdDCxflqN6vVYLdrFXgbNaWxJiqeyFPkc=;
        b=XQsKfJ4YH34OQvXGzzee7fR/PGU2qFdKGVtAYpYwZ49MOTRk9CSqRQYqPaQnRErGPYblLm
        s4dk3GnA3Uvl1FOP00WzurxpU8h9Z1pa1kHecsDB8TqUz7PRqtnytX3OkeIZdvAZhtTWlc
        JtCAwDbBMvtv+Hv1+3+8vkRYMfZxhos=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-tND5EKlEPFu0nkmGSr8Dag-1; Thu, 04 Aug 2022 17:07:11 -0400
X-MC-Unique: tND5EKlEPFu0nkmGSr8Dag-1
Received: by mail-ed1-f72.google.com with SMTP id b6-20020a056402278600b0043e686058feso530224ede.10
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2022 14:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=yIosAhkjdjbdDCxflqN6vVYLdrFXgbNaWxJiqeyFPkc=;
        b=Vr5cjzGs+La/NRoa7p8Vn+OW081W9/Ag+cJ+HiCZRtJc2MW4XSP8jHGD+auaZAkFk+
         nOImtNeABBoRaeAA8K+ut0uvI7mOX8fbGX60uXJrXaIT8Iw0izMSl5+phYhPlAJVUH7A
         ENNqST+S/oBfewthWvOkwOKmiPc52mnN/RnUz7U3fkGhhx1QZkNyWuuaHmIG3L0CR03q
         h4Om8TRJHRBAARTzS4BpsA6dzaA8e22HZQyZQamooUzsEfhuSxKLUkvd00K1jgOV5zel
         OJLVCAVWQRDVS4Kt7V3Uc+HUC6FqjFehl5XJMiFrFJpi4E3Jjl9u+FyeM+4nbTR+CW0G
         gREQ==
X-Gm-Message-State: ACgBeo2sRimMkt3VyvfD39/7ekQJTFXg5uheWIDW7mkSjdTsHnanBORv
        sxmSPgzBlZwVJPPb7EvYl72+ezjLXSpZiKj8vi1ZVMAt7wXCeId+t0tzXqBZeW5vY8ZgegaCmzj
        928YrVo1vPg3AxyEjhvWyzw==
X-Received: by 2002:a05:6402:288c:b0:43c:d371:48e4 with SMTP id eg12-20020a056402288c00b0043cd37148e4mr3742836edb.239.1659647230184;
        Thu, 04 Aug 2022 14:07:10 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4JHjrCB4gYEF8L3U0admA1ESyRSgcEfzBp36DL6uheG3RW3xgl2liWtU3x6VqEuq+fHlq+JA==
X-Received: by 2002:a05:6402:288c:b0:43c:d371:48e4 with SMTP id eg12-20020a056402288c00b0043cd37148e4mr3742817edb.239.1659647230022;
        Thu, 04 Aug 2022 14:07:10 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id ep11-20020a1709069b4b00b0073087f7dfe2sm718773ejc.125.2022.08.04.14.07.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 14:07:09 -0700 (PDT)
Message-ID: <f0dc4b4a-cc46-72b4-ca5a-7664080f02d3@redhat.com>
Date:   Thu, 4 Aug 2022 23:07:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 03/10] scsi: uas: Drop DID_TARGET_FAILURE use.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, jgross@suse.com,
        njavali@marvell.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, stefanha@redhat.com, oneukum@suse.com,
        manoj@linux.ibm.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, kraxel@redhat.com
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-4-michael.christie@oracle.com>
 <51baa06b-ed8a-5de8-93da-6de97077173d@oracle.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <51baa06b-ed8a-5de8-93da-6de97077173d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 8/4/22 20:59, Mike Christie wrote:
> Adding Hans and Gerd. Sorry, I messed up the cc originally.
> 
> On 8/3/22 10:40 PM, Mike Christie wrote:
>> DID_TARGET_FAILURE is internal to the SCSI layer. Drivers must not use it
>> because:
>>
>> 1. It's not propagated upwards, so SG IO/passthrough users will not see an
>> error and think a command was successful.
>>
>> 2. There is no handling for them in scsi_decide_disposition so it results
>> in the scsi eh running.
>>
>> It looks like the driver wanted a hard failure so this swaps it with
>> DID_BAD_TARGET which gives us that behavior and the error looks like it's
>> for a case where the target did not support a TMF we wanted to use (maybe
>> not a bad target but disappointing so close enough).
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>

The suggested change sounds reasonable to me. Note I never touched
the part of the driver being changed here and I'm not a SCSI expert,
so this is just my 2 cents on the change really.

Regards,

Hans




>> ---
>>  drivers/usb/storage/uas.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
>> index 84dc270f6f73..de3836412bf3 100644
>> --- a/drivers/usb/storage/uas.c
>> +++ b/drivers/usb/storage/uas.c
>> @@ -283,7 +283,7 @@ static bool uas_evaluate_response_iu(struct response_iu *riu, struct scsi_cmnd *
>>  		set_host_byte(cmnd, DID_OK);
>>  		break;
>>  	case RC_TMF_NOT_SUPPORTED:
>> -		set_host_byte(cmnd, DID_TARGET_FAILURE);
>> +		set_host_byte(cmnd, DID_BAD_TARGET);
>>  		break;
>>  	default:
>>  		uas_log_cmd_state(cmnd, "response iu", response_code);
> 

