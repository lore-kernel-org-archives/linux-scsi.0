Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DFEC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Apr 2022 20:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348441AbiD1URJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Apr 2022 16:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244261AbiD1URI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Apr 2022 16:17:08 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446A7BF963
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2022 13:13:53 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id j17so5153264pfi.9
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2022 13:13:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Gzv1ZHmdBPcvnpLgj/HMlh9J1MKXykKH/wz36EyZ9jc=;
        b=WTqChB4IVYuI9zgUv4mK7FAkqTmxQrGq5YN9gfJQll4wJ1dH5AjlQ+Y2BRci1ebOGa
         WnfVJSUEYu5HuJ497EiEFzldGGguZoeiKbtZXCDWjfi4vdcQNRGZIpuxFUn3x7JCSvbP
         m8AR0E3PKfJpESXIl7vmc30YVfT481hgBvMR8aZCYe9mIyxvW7Qqx/7q82Z3en/3yppu
         3gV5QsNfJazKehc9s1w21RMPhgZLQP3eF6qoS0mLuF5AKPK0t7OA12n3IwnEFfoktel0
         2PDGMliA5sIMOpukj9cWgDIkqV+owd9ms8paoq6nWa6f0gx7nRJ/y82X3M6W+k7CUtvE
         o8bQ==
X-Gm-Message-State: AOAM530weCX6eQQKzQ3HdeDSHkv7JQLGu5/ASYU9rJ1tk8Gi55+73qKG
        0AbsLTHP9j21CeDFPy3dVrk=
X-Google-Smtp-Source: ABdhPJyfAzTijhFSj4gyELB4k4HexoobJtSCHp+8koRFIpd1B4VKnWrMDiQ07RtBFlX0efeHfgFjwQ==
X-Received: by 2002:a63:5219:0:b0:39d:7212:4b3f with SMTP id g25-20020a635219000000b0039d72124b3fmr29437237pgb.255.1651176832592;
        Thu, 28 Apr 2022 13:13:52 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:6f14:f527:3ca8:ecbf? ([2620:15c:211:201:6f14:f527:3ca8:ecbf])
        by smtp.gmail.com with ESMTPSA id t1-20020a62d141000000b0050d3772b9b0sm659997pfl.94.2022.04.28.13.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 13:13:51 -0700 (PDT)
Message-ID: <f3c2d9a1-f36e-1da3-4568-67214ed43886@acm.org>
Date:   Thu, 28 Apr 2022 13:13:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/4] scsi: ufs: Reduce the clock scaling latency
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20220427233855.2685505-1-bvanassche@acm.org>
 <20220427233855.2685505-2-bvanassche@acm.org>
 <DM6PR04MB6575F913911C61D7853F5A25FCFD9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575F913911C61D7853F5A25FCFD9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/28/22 00:09, Avri Altman wrote:
> Maybe we should create some linkage to DOORBELL_CLR_TOUT_US?

Hi Avri,

Do you perhaps want me to change

	io_schedule_timeout(msecs_to_jiffies(20));

into something like the following?

	io_schedule_timeout(msecs_to_jiffies(min(20, remaining_time)));

Documenting that wait_timeout_us may be exceeded by 20 ms seems like the 
easier solution to me :-)

Thanks,

Bart.
