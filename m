Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65AB8C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 03:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34A4161407
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 03:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhENDCw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 23:02:52 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:40717 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbhENDCv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 23:02:51 -0400
Received: by mail-pj1-f41.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso917527pjp.5
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 20:01:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cYyWmYfYaxK+oSMEVcNtE/ojd2B5ml3bBs53CMcOmhk=;
        b=KHZidms3zeSWyLGK+dLd7ilDCBHBg1VULmVkoqbj9HUPkVQ9fNweS85ojKCj1Y2jrx
         rMnFD54fY8tjxx4iI9MYQtOjigD8+g1jXqTql6DF1d9dJw3nZw4F/YzFBH1gavETnmof
         IUG3RhuwDgzv0X0TZCzW4i7qMD40HpYEeZ5XXhaojvyp8wdQ5v5G5reYZYEUJKkhQOJp
         AQqPGoArlIvWGc32+9c9t1nLA2zexhWGj8GzlYFRbTymRQZUbd3q3rPxbSNjYQqL8RNW
         lGXAwsInOmJxsIWZujqL+9Dhy2/QrglnVNppe3CJrpFE4O+k+wtFWuCzYw5g9FD9optx
         ZSkA==
X-Gm-Message-State: AOAM530i4j1gnw6ex4lOkMkCvp/BttFq+N3xrwJLRfWwrDGBkMpnak37
        vcjYRCYiXjE6ABTjjZdNH8c=
X-Google-Smtp-Source: ABdhPJzkRH/guaCMIv4aTRMq3O/j6h9oxyBVegKRSKUys0ATWr1Lf/NRecTzcd9q9fYTEG6TiU1k8w==
X-Received: by 2002:a17:902:6a84:b029:ef:1342:20e7 with SMTP id n4-20020a1709026a84b02900ef134220e7mr34934193plk.36.1620961300080;
        Thu, 13 May 2021 20:01:40 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:53a7:2faa:e07b:6134? ([2601:647:4000:d7:53a7:2faa:e07b:6134])
        by smtp.gmail.com with ESMTPSA id y13sm3215640pgs.93.2021.05.13.20.01.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 20:01:39 -0700 (PDT)
Subject: Re: [PATCH v3 6/8] qla2xxx: Use scsi_get_sector() instead of
 scsi_get_lba()
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Nilesh Javali <njavali@marvell.com>
References: <20210513223757.3938-1-bvanassche@acm.org>
 <20210513223757.3938-7-bvanassche@acm.org>
 <DM6PR04MB70817364801262A63932A55EE7509@DM6PR04MB7081.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cee55aed-acd0-04da-5c31-95b6bcc20dd9@acm.org>
Date:   Thu, 13 May 2021 20:01:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB70817364801262A63932A55EE7509@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/21 7:02 PM, Damien Le Moal wrote:
> On 2021/05/14 7:38, Bart Van Assche wrote:
>> @@ -2677,7 +2677,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
>>  			if (k != blocks_done) {
>>  				ql_log(ql_log_warn, vha, 0x302f,
>>  				    "unexpected tag values tag:lba=%x:%llx)\n",
>> -				    e_ref_tag, (unsigned long long)lba_s);
>> +				    e_ref_tag, (u64)sector);
>>  				return 1;
>>  			}
>>  
>>
> 
> Not entirely convinced the casts are needed for the log calls...
> Apart from that, looks good.
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

Hi Damien,

I will remove the cast from the ql_log() call.

Thanks,

Bart.
