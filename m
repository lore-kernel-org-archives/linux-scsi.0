Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9837C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 05:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239105AbhK0Fi2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 00:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237213AbhK0Fg2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 00:36:28 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E068AC061746;
        Fri, 26 Nov 2021 21:31:36 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id h24so8465818pjq.2;
        Fri, 26 Nov 2021 21:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=skjuFpTUAa0yIS681Azg1k5aE0n9qFIeHJ6lXgBfHbo=;
        b=pZ+FA72CprpYlBZ9EXAqOujbhMilCm3DRNywXAvqfgbIEeQHMyR4V73G1Jh89PrfPX
         +c0GFHrzXlatC3dy7g0O2Sh9uSQuDVSJwoxvqmoVcO/3sEHhCMEuOidIBJpD0qjQN+1j
         K4D3wsPijxQiH0V1GsHvbnL83voKA6k6bYCK+hJWd1pn80g6+fYe/Uu93qlpRV90bOjB
         1FbPuHvU8QOF80pInEXqh0lO6ZamHEAjSI5DC/ad99EILTX2DsHP+/5x+ZxdBShlgk18
         xfg5r2zM+oE5ql9OSj+IAVjpH2z7Zdnb1UAuLzUmrtIoZ3gCgRWz+ZSKOvX7gxdmGL0V
         oTXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=skjuFpTUAa0yIS681Azg1k5aE0n9qFIeHJ6lXgBfHbo=;
        b=B/2feuLCR1/fF+8yTtVJoBOLwKaLZiu9sQnTgEkWuv3soT00OZe/Gc+njtJ4S5bKvr
         9c84Ondhh0VN8Xx4IjVzvoH9yWIxNPtoHQeHvr1fpRzTTSPvpdFJLTSUa6k9a5cOBE1W
         21k5Q4Lz+LFGRn0sA3TzVbrjq2ichpX9hjWW9y+ygUuE4cLH3eJbI48uTnni7C9zreiu
         eTlin978eoLH8Zlq0Ow1ge9+TsnXoSkqoXc4HxzZ4f7HJaty3p3S/elq4nrvS6ohnvGD
         yUZo2LJdti7Kn/Tn2Yh9pXAueJ5J2WlbDN+DwQk/45PtqF5C0rvGWFJ6kGSC3wTG3euk
         ehIg==
X-Gm-Message-State: AOAM5313FBO1FZocss0Ccz6ebEZXl99Cu7cmQUIA4nALkfJ7mqPRlyVc
        FtlzT4+cWOhxEsyE3vjQPQc=
X-Google-Smtp-Source: ABdhPJy72jutcrLCyoKCpNxbIX+bw0pOAV/hDgunjk7MzD0u9Xe1DBNv/Gx51Gc2UNR6/Q/nct1SWQ==
X-Received: by 2002:a17:90b:30e:: with SMTP id ay14mr20799525pjb.60.1637991096390;
        Fri, 26 Nov 2021 21:31:36 -0800 (PST)
Received: from [192.168.1.5] (70-36-60-214.dyn.novuscom.net. [70.36.60.214])
        by smtp.gmail.com with ESMTPSA id d17sm8990050pfj.215.2021.11.26.21.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 21:31:35 -0800 (PST)
Message-ID: <5b5ec5df-962a-e0f5-c88c-ecc26249c659@gmail.com>
Date:   Fri, 26 Nov 2021 21:31:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [EXT] [PATCH 2/2] scsi: qedi: Fix SYSFS_FLAG_FW_SEL_BOOT
 formatting
Content-Language: en-US
To:     Manish Rangankar <mrangankar@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:QLOGIC QL41xxx ISCSI DRIVER" <linux-scsi@vger.kernel.org>
References: <20211126051529.5380-1-f.fainelli@gmail.com>
 <20211126051529.5380-3-f.fainelli@gmail.com>
 <CO6PR18MB4419E1ADDB4D336E83C624FBD8639@CO6PR18MB4419.namprd18.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CO6PR18MB4419E1ADDB4D336E83C624FBD8639@CO6PR18MB4419.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 11/26/2021 12:43 AM, Manish Rangankar wrote:
> 
> 
>> -----Original Message-----
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Sent: Friday, November 26, 2021 10:45 AM
>> To: linux-kernel@vger.kernel.org
>> Cc: Florian Fainelli <f.fainelli@gmail.com>; Nilesh Javali <njavali@marvell.com>;
>> Manish Rangankar <mrangankar@marvell.com>; GR-QLogic-Storage-Upstream
>> <GR-QLogic-Storage-Upstream@marvell.com>; James E.J. Bottomley
>> <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>;
>> open list:QLOGIC QL41xxx ISCSI DRIVER <linux-scsi@vger.kernel.org>
>> Subject: [EXT] [PATCH 2/2] scsi: qedi: Fix SYSFS_FLAG_FW_SEL_BOOT formatting
>>
>> External Email
>>
>> ----------------------------------------------------------------------
>> The format used for formatting SYSFS_FLAG_FW_SEL_BOOT creates the
>> following warning:
>>
>> drivers/scsi/qedi/qedi_main.c:2259:35: warning: format specifies type 'char' but
>> the argument has type 'int' [-Wformat]
>>                     rc = snprintf(buf, 3, "%hhd\n", SYSFS_FLAG_FW_SEL_BOOT);
>>
>> Fix this to use %d since this is a plain integer.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>   drivers/scsi/qedi/qedi_main.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c index
>> f1c933070884..367a0337b53e 100644
>> --- a/drivers/scsi/qedi/qedi_main.c
>> +++ b/drivers/scsi/qedi/qedi_main.c
>> @@ -2254,7 +2254,7 @@ qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int
>> type,
>>   			     mchap_secret);
>>   		break;
>>   	case ISCSI_BOOT_TGT_FLAGS:
>> -		rc = snprintf(buf, 3, "%hhd\n", SYSFS_FLAG_FW_SEL_BOOT);
>> +		rc = snprintf(buf, 3, "%d\n", SYSFS_FLAG_FW_SEL_BOOT);
>>   		break;
>>   	case ISCSI_BOOT_TGT_NIC_ASSOC:
>>   		rc = snprintf(buf, 3, "0\n");
>> --
>> 2.25.1
> 
> SYSFS_FLAG_FW_SEL_BOOT is always going to have value 2, that's why it is given %hhd to limit the size to 1 byte.
> Is there other way to suppress this warning, such as typecasting or any other ?

Yes typecasting would work, if you are fine with that.
-- 
Florian
