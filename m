Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5ACC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 15:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEEA0610A5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 15:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245009AbhIMP1g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 11:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245118AbhIMP13 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 11:27:29 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803B1C0F976B;
        Mon, 13 Sep 2021 07:24:32 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id a20-20020a0568300b9400b0051b8ca82dfcso13524078otv.3;
        Mon, 13 Sep 2021 07:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cc3rfqH5qwQXfY+9743ExBqMLbOukLsqMfSk7T1TjH8=;
        b=ctacHN8t8zTfoxyXUZTopSmEK0Jayf7mBV/9AielDiwbwEv+8uoLJOsK1D6E5P/R8y
         LwItjjhdJ/cLEF3jYMzxsTKo9BwSYs23FV+bDh8egrKd8RIKFj153I/m0tIa0qvwWwbS
         4AMc0+yr2y/qSVXrwWcCJED7v7U/ICrFzOPK99OpJEc9dCMKO6g6zmJhRHIwRvL/c/Nh
         6CKJL4H553g6s5f/UW4LutcrgJc9KJRPKMqR+p4jntw9tV9QJPVOfaHQH30ztfPPQjw7
         dGGEBxCUZIWFZg9AZ4JGF7eDdsESzEn1mnSjnXP5n9sO4J1Eytb8fCm68Hly2k9pDjwf
         N96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cc3rfqH5qwQXfY+9743ExBqMLbOukLsqMfSk7T1TjH8=;
        b=So6BYJTiUlHlbQ6pdsfdfkq6zBsEQ/2ZPalgb1etXkFxdYwskx0sysXWCog5z8VvZz
         SDnVj7Y0g++OnMUPcevZaJEW7FACtCmNRi4MOGiUmOhUuYfTYE3jWpNpR0YtaIgTi0D+
         5nLEOzcqoTAtSxy44FcR7j0iWyR940Jq8oZQCyQsX7KLiQRX4K1Ipt9DCzT/jwgwBaRT
         2j22RiISiTlStY1YauHydqma7E7ClXoM96wK68X/vzIZ3vuVoANC0fwDvGTQ00p6O3+U
         1+lJIPYs2cY98GEasOALz+iGWdXXRdesztgIrNHGcairXl51KXdzcCPu71UCevmQQ/YJ
         rt0g==
X-Gm-Message-State: AOAM532ms7Sa5ZCRyOzGy0hOoRRpCEf7A/hU8ocbMgrROIlV5j1QDolT
        PIjjcjz6/thgrO1jT/tsfqU=
X-Google-Smtp-Source: ABdhPJwb69CpSnJYBsHnp6aF1xDUvHRgwn45BpM3beAg0GbsMNcq0qqyENIqW8Ea8BXRSR5zE8/Qtw==
X-Received: by 2002:a9d:63cf:: with SMTP id e15mr9946401otl.172.1631543071900;
        Mon, 13 Sep 2021 07:24:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v5sm1869559oos.17.2021.09.13.07.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 07:24:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH v3 1/2] scsi: ufs: Probe for temperature notification
 support
To:     Avri Altman <Avri.Altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210912131919.12962-1-avri.altman@wdc.com>
 <20210912131919.12962-2-avri.altman@wdc.com>
 <8abe6364-9240-bcaf-c17f-1703243170cb@roeck-us.net>
 <DM6PR04MB65754D1CF6B4769E6CECDB5DFCD99@DM6PR04MB6575.namprd04.prod.outlook.com>
 <d28e37db-44bb-75f8-d479-dcb106fe146d@roeck-us.net>
 <DM6PR04MB657565612A342272B2160A72FCD99@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <bbe45ecf-853f-77f7-9094-ded8c59075f4@roeck-us.net>
Date:   Mon, 13 Sep 2021 07:24:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB657565612A342272B2160A72FCD99@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 12:49 AM, Avri Altman wrote:
>>>> The "enable" attribute only makes sense if it can be used to actually
>>>> enable or disable a specific sensor, and is not tied to limit
>>>> attributes but to the actual sensor values.
>>> See explanation above.
>>>    Will make it writable as well.
>>>
>>
>> That only makes sense if the information is passed to the chip. What is going to
>> happen if the user writes 0 into the attribute ?
> Will turn off the temperature exception bits, so that Tcase is no longer valid,
> and the device will always return Tcase = 0.
> 

Ok. Then attempts to read the temperature should return -ENODATA, not -EINVAL,
if Tcase == 0.

Guenter
