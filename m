Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C29C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347495AbhK2Tm6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:42:58 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:42781 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236353AbhK2Tk6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:40:58 -0500
Received: by mail-pf1-f173.google.com with SMTP id u80so18000160pfc.9
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:37:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NnLeH0E0ZqQEtAOGklL+F8iiiloQ3zWE4fg1AwWqc1E=;
        b=UlJwi/dhfXcc5c/xjf3qlFGqHTmvxmadp+AiKxbNUQurSgouwjFJjov9zftewYMkMz
         omkyhAufCU9R2qQ/ObjckS4IlhAS2TeSKyQoScFfeTGxzgqb50qzESYIqCVD6bfhttCb
         6ZzAcjdi/YHfhAEvZP6BlOiMGs+1yniN4nckzsqllUgg98FKykeypZkbFiy1Wxg6g5XW
         dGJwQ4Fb4Pbdv/R5wq2iAranu5x6n2NJflqQshvdZirNbXIkxMzIwndvwxwoiYau/cvY
         46y7G6X8jYi4rc/t8qRlswOJibB7D2pXu9oBjulHOYb0lwqFuERD3k/WXdH99Fr4w6HV
         NiIQ==
X-Gm-Message-State: AOAM531BdUX80bBkMagfVZMoQjq90O2EYBcCqjPyitueIZidxpxHTd1W
        uoYtlDfVIYLJ38aN984Uwoo=
X-Google-Smtp-Source: ABdhPJybMDk4R42QNRDRjSOA1xe/y4cXhTyChHdntePFEVtH+34KmaEJvRP1GQR6dsNY9BjIXVEj0Q==
X-Received: by 2002:a63:d142:: with SMTP id c2mr8405973pgj.215.1638214660377;
        Mon, 29 Nov 2021 11:37:40 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id w142sm17869842pfc.115.2021.11.29.11.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 11:37:39 -0800 (PST)
Subject: Re: [PATCH 05/13] scsi: ata: Declare 'ata_ncq_sdev_attrs' static
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        kernel test robot <lkp@intel.com>
References: <20211124005217.2300458-1-bvanassche@acm.org>
 <20211124005217.2300458-6-bvanassche@acm.org>
 <26e883cd-3337-5875-47e1-d94f96be1ec5@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b7d2bdd9-21db-8cc8-1c7c-5a900c06aef6@acm.org>
Date:   Mon, 29 Nov 2021 11:37:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <26e883cd-3337-5875-47e1-d94f96be1ec5@opensource.wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/24/21 12:54 AM, Damien Le Moal wrote:
> On 2021/11/24 9:52, Bart Van Assche wrote:
>> Fix the following kernel-doc warning:
>>
>> 'ata_ncq_sdev_attrs' is only used in one source file. Hence declare this
>> array static.
>>
>> Fixes: c3f69c7f629f ("scsi: ata: Switch to attribute groups")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/ata/libata-sata.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
>> index 4e88597aa9df..5b78e86e3459 100644
>> --- a/drivers/ata/libata-sata.c
>> +++ b/drivers/ata/libata-sata.c
>> @@ -922,7 +922,7 @@ DEVICE_ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
>>   	    ata_ncq_prio_enable_show, ata_ncq_prio_enable_store);
>>   EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_enable);
>>   
>> -struct attribute *ata_ncq_sdev_attrs[] = {
>> +static struct attribute *ata_ncq_sdev_attrs[] = {
>>   	&dev_attr_unload_heads.attr,
>>   	&dev_attr_ncq_prio_enable.attr,
>>   	&dev_attr_ncq_prio_supported.attr,
>>
> 
> Already fixed in rc2.
> See commit cac7e8b5f5fa94e28d581fbb9e76cb1c0c7fd56a.

Hi Damien,

Thanks for the feedback. I remembered that I had seen an ATA fix but couldn't
find it while I was preparing this series ...

Bart.
