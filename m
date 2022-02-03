Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0ACCC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 07:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347537AbiBCHYm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 02:24:42 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:51898 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbiBCHYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 02:24:40 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9DFE61F3A5;
        Thu,  3 Feb 2022 07:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643873079; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JD8B5j8oQIXRjUzj5jBBRCBqywjDhdE1cYhu2C2Cvd0=;
        b=ygLG+YQf3EF4Uxq+IXFmFbjnofBR0aPmdw5iNB2eyC1a2y5dnZsTIXo0v2knoz9HJt/PsF
        T9QcYv69QTbmTCl/yMscKOuDAna49LekksZMKtlGNDi4f9BPsj83LiNRKZB8oSoREO3WpT
        wcVjhb1NyzqlBkvlgrxXupvL/chGdv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643873079;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JD8B5j8oQIXRjUzj5jBBRCBqywjDhdE1cYhu2C2Cvd0=;
        b=fY+nyVrLJKTYTDzPB3YgSTAicSss8xxv/r/Hlan/Kuoz8wBhJlXRE4wrVH3iAbnDk7DujD
        P01uHEzc/VkNhKDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7DE431344A;
        Thu,  3 Feb 2022 07:24:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CbNAGzeD+2GpcwAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 03 Feb 2022 07:24:39 +0000
Message-ID: <a393bff0-f2f4-9749-df90-d961a6406659@suse.de>
Date:   Thu, 3 Feb 2022 08:24:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] scsi: use BLK_STS_OFFLINE for not fully online
 devices
Content-Language: en-US
To:     Song Liu <song@kernel.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Kernel Team <kernel-team@fb.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
References: <20220203064009.1795344-1-song@kernel.org>
 <20220203064009.1795344-3-song@kernel.org>
 <CAPhsuW5DitVaUG-z35Si0bMERQdGAF60Tj3nD7DwmKhZVxs9AA@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAPhsuW5DitVaUG-z35Si0bMERQdGAF60Tj3nD7DwmKhZVxs9AA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/3/22 07:53, Song Liu wrote:
> CC linux-block (it was a typo in the original email)
> 
> On Wed, Feb 2, 2022 at 10:40 PM Song Liu <song@kernel.org> wrote:
>>
>> The new error message for such case looks like
>>
>> [  172.809565] device offline error, dev sda, sector 3138208 ...
>>
>> which will not be confused with regular I/O error (BLK_STS_IOERR).
>>
>> Signed-off-by: Song Liu <song@kernel.org>
>> ---
>>   drivers/scsi/scsi_lib.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 0a70aa763a96..e30bc51578e9 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1276,7 +1276,7 @@ scsi_device_state_check(struct scsi_device *sdev, struct request *req)
>>                   * power management commands.
>>                   */
>>                  if (req && !(req->rq_flags & RQF_PM))
>> -                       return BLK_STS_IOERR;
>> +                       return BLK_STS_OFFLINE;
>>                  return BLK_STS_OK;
>>          }
>>   }
>> --
>> 2.30.2
>>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
