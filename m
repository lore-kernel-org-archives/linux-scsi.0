Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51A9C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 07:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349346AbiBCHYL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 02:24:11 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:51876 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242617AbiBCHYK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 02:24:10 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 64EFE1F398;
        Thu,  3 Feb 2022 07:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643873049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ecQR/6aAMwtMDthZauct3a/aqrtum3wIe4VMlRDCxg=;
        b=rAr2OpWlXNUsjOoOk7wmSL6gY++xPhDCXoBO6XIA0/gquYDKFpDr2XqO+Yo19xjmkDLj1q
        IvfKfVWiGn3K28q6d3rz2yCvgsgEWfAWFnnqhEPeFrt9PZsaGlYT+CMYerYbksJhM+K+O2
        2n7lZSj7ZxkBxTruC058UOHuwiHUFcU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643873049;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ecQR/6aAMwtMDthZauct3a/aqrtum3wIe4VMlRDCxg=;
        b=b5ssMQxcJ2HS9aRSvt4A/ptRf45WpUkj8m2L2aN9vZFh5UIm5Sb9X/xGDfBm3hAfOhuYob
        hCWMrpDcT94PfPAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 406F11344A;
        Thu,  3 Feb 2022 07:24:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Nrv8DhmD+2GFcwAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 03 Feb 2022 07:24:09 +0000
Message-ID: <f7489746-b8fb-bc9a-a706-e5926fa9e325@suse.de>
Date:   Thu, 3 Feb 2022 08:24:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/2] block: introduce BLK_STS_OFFLINE
Content-Language: en-US
To:     Song Liu <song@kernel.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Kernel Team <kernel-team@fb.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
References: <20220203064009.1795344-1-song@kernel.org>
 <20220203064009.1795344-2-song@kernel.org>
 <CAPhsuW6PNaYUb5xDxPX_gX=2fZdiRURRos5sT_Tsbngon1+eKw@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAPhsuW6PNaYUb5xDxPX_gX=2fZdiRURRos5sT_Tsbngon1+eKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/3/22 07:52, Song Liu wrote:
> CC linux-block (it was a typo in the original email)
> 
> On Wed, Feb 2, 2022 at 10:40 PM Song Liu <song@kernel.org> wrote:
>>
>> Currently, drivers reports BLK_STS_IOERR for devices that are not full
>> online or being removed. This behavior could cause confusion for users,
>> as they are not really I/O errors from the device.
>>
>> Solve this issue with a new state BLK_STS_OFFLINE, which reports "device
>> offline error" in dmesg instead of "I/O error".
>>
>> Signed-off-by: Song Liu <song@kernel.org>
>> ---
>>   block/blk-core.c          | 1 +
>>   include/linux/blk_types.h | 7 +++++++
>>   2 files changed, 8 insertions(+)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 61f6a0dc4511..24035dd2eef1 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -164,6 +164,7 @@ static const struct {
>>          [BLK_STS_RESOURCE]      = { -ENOMEM,    "kernel resource" },
>>          [BLK_STS_DEV_RESOURCE]  = { -EBUSY,     "device resource" },
>>          [BLK_STS_AGAIN]         = { -EAGAIN,    "nonblocking retry" },
>> +       [BLK_STS_OFFLINE]       = { -EIO,       "device offline" },
>>
>>          /* device mapper special case, should not leak out: */
>>          [BLK_STS_DM_REQUEUE]    = { -EREMCHG, "dm internal retry" },
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index fe065c394fff..5561e58d158a 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -153,6 +153,13 @@ typedef u8 __bitwise blk_status_t;
>>    */
>>   #define BLK_STS_ZONE_ACTIVE_RESOURCE   ((__force blk_status_t)16)
>>
>> +/*
>> + * BLK_STS_OFFLINE is returned from the driver when the target device is offline
>> + * or is being taken offline. This could help differentiate the case where a
>> + * device is intentionally being shut down from a real I/O error.
>> + */
>> +#define BLK_STS_OFFLINE                ((__force blk_status_t)17)
>> +
>>   /**
>>    * blk_path_error - returns true if error may be path related
>>    * @error: status the request was completed with
>> --
>> 2.30.2
>>
Please do not overload EIO here.
EIO already is a catch-all error if we don't know any better, but for 
the 'device offline' case we do (or rather should).
Please map it onto 'ENODEV' or 'ENXIO'.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
