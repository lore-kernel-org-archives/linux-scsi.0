Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBA9C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Apr 2022 21:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiDWVlt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Apr 2022 17:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiDWVls (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Apr 2022 17:41:48 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F751D5660;
        Sat, 23 Apr 2022 14:38:49 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id i24so11287294pfa.7;
        Sat, 23 Apr 2022 14:38:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BzqWH2IzgALcoDHHVu1SSmrK7vebYFiu676jJ6lQ4us=;
        b=ITRrI434LwGfXkPKj4SrA3C1JXDUVQeqGeGXN7X1mJjQm0TwxQt5G+FtrQyzssjNw3
         4GYs3i9/z5FsnuMaEmREwBJVh17StIzib/hi9MfCHlTOdfQQJjhaJpJw4WzinjMuNFwQ
         HNStg1ySrrL2DjHp/33yRqJnrRWaxEMjlCQYCylZjSwql1htDGodae3mFqCdu0eufz8N
         1he9wyIQI0w5FmlOTQTQWAebq0hUQf3X+9JJMk7QcetbBzRQv7XyPVyfP35XUMfIfya8
         9FtnYoxZ52gvm8wB0V2LUVtJ8oKS9oO6ejOm2U9qLelBCbXQCp6NbC3M8HtFq/Bpaawp
         /zkA==
X-Gm-Message-State: AOAM533s//zTreG5mB+XFAylPU8PXQmAFNnpBD3iBex8zAhdC3ShBaYg
        9+jELdetdLDkZSHMtBAzatI=
X-Google-Smtp-Source: ABdhPJx337gZtgIghf3LEwQbDgP5EWy3UJhIGYn5MfEWZP19IscHesE3rIdmF91xklhaW6eTy0IXdQ==
X-Received: by 2002:a63:8a41:0:b0:3aa:a7c9:23b8 with SMTP id y62-20020a638a41000000b003aaa7c923b8mr9059061pgd.137.1650749928940;
        Sat, 23 Apr 2022 14:38:48 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 128-20020a630686000000b003ab01991fe5sm2091610pgg.77.2022.04.23.14.38.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 14:38:48 -0700 (PDT)
Message-ID: <0f061fc0-d7ee-aa48-278b-4ca7dc3ce53f@acm.org>
Date:   Sat, 23 Apr 2022 14:38:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] scsi: ufs: wb: Add Manual Flush sysfs and cleanup toggle
 functions
Content-Language: en-US
To:     jin young choi <ychoijy@gmail.com>,
        Avri Altman <Avri.Altman@wdc.com>
Cc:     "j-young.choi@samsung.com" <j-young.choi@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CGME20220422120240epcms2p24bdcb416becf76b417f7c39006aa40f2@epcms2p1>
 <1891546521.01650629881201.JavaMail.epsvc@epcpadp4>
 <DM6PR04MB6575EB87D425CE431CC4A8F8FCF79@DM6PR04MB6575.namprd04.prod.outlook.com>
 <CAM36TBtsU0k1e+8-_Ew4ve3SJ0yExUFwPAYnmQy_-AXUHGoeZw@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAM36TBtsU0k1e+8-_Ew4ve3SJ0yExUFwPAYnmQy_-AXUHGoeZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/22 07:24, jin young choi wrote:

>>> +static DEVICE_ATTR_RW(wb_flush_on);
>> Maybe wb_flush_enable ?
>>
> 'wb_on' sysfs already existed. So I named it in the same format (_on)
> I'll change both. (_on -> _enable)

sysfs attributes constitute an ABI. Breaking the user space ABI is not 
allowed. Hence, renaming existing sysfs attributes is not an option.

Thanks,

Bart.
