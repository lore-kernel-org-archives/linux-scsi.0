Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD8BC41513
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 14:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351657AbjHQO0N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 10:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351867AbjHQO0I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 10:26:08 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197C32D76;
        Thu, 17 Aug 2023 07:26:07 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-689e8115f8dso693429b3a.3;
        Thu, 17 Aug 2023 07:26:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692282366; x=1692887166;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=inzFrZAWYbsGG5Ju0NSsgCLRNDF4WnectbY5DeYbiaQ=;
        b=Iu6QvEmzoeUOs99OoGSak7fKOnHhkbZ7pauKrQIpXCG3rZKCW1N1TjjH4AKmTasDQe
         EJa7y48/kTC1qy3KDXsTADwtjoTzwH9fzNlBqFKjpSLYAPDLBCJ7BzMz32zTW7rA1sCR
         Xfe4UCG6KqtXjw4J1cCet0go9OE0g5of1h6yECSses4yRH5u4TUQGsP3Y43p2BbAN1q/
         XEE/eUjIZhGPX1RUZI17jNkErHYTL3z7IxUG7C/L8kAVT2UMNTH3p8NsDTbvFV7HmU2G
         qc181RXqp+/vuzi6lwmeWzN06PtBCBh1L+Ke+in9xMZ0gLK7zYGuX0deTGU6/a9PcHfo
         6A4w==
X-Gm-Message-State: AOJu0Yxz7/Bg1Llg4L3j+q0RfgPbOnT74kbfVSJO+TL92EQ/kZry0Th7
        jmmOFwwGirfJKVUJ20ZKRYw=
X-Google-Smtp-Source: AGHT+IFx/kHNhhe6pavhwxAJcRtJcPpwZRSvusx0Po0EpvyQa6KOiRhRstyECe/botXB+9xPFxslGQ==
X-Received: by 2002:a05:6a20:7349:b0:133:71e4:c172 with SMTP id v9-20020a056a20734900b0013371e4c172mr7338930pzc.15.1692282366431;
        Thu, 17 Aug 2023 07:26:06 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:dfd:6f25:f7be:a9ca? ([2620:15c:211:201:dfd:6f25:f7be:a9ca])
        by smtp.gmail.com with ESMTPSA id x6-20020a63b346000000b00553b9e0510esm12543484pgt.60.2023.08.17.07.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Aug 2023 07:26:06 -0700 (PDT)
Message-ID: <49bdae64-6162-5802-2dfb-c433ab48b5f9@acm.org>
Date:   Thu, 17 Aug 2023 07:26:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v9 04/17] scsi: core: Call .eh_prepare_resubmit() before
 resubmitting
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-5-bvanassche@acm.org>
 <201ae2be-3829-97ad-caa5-6f6f3a41e6db@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <201ae2be-3829-97ad-caa5-6f6f3a41e6db@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 04:10, Damien Le Moal wrote:
> On 8/17/23 04:53, Bart Van Assche wrote:
>> +/*
>> + * Returns true if the commands in @done_q should be sorted in LBA order
>> + * before being resubmitted.
>> + */
>> +static bool scsi_needs_sorting(struct list_head *done_q)
>> +{
>> +	struct scsi_cmnd *scmd;
>> +
>> +	list_for_each_entry(scmd, done_q, eh_entry) {
>> +		struct request *rq = scsi_cmd_to_rq(scmd);
>> +
>> +		if (!rq->q->limits.use_zone_write_lock &&
>> +		    blk_rq_is_seq_zoned_write(rq))
>> +			return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> +/*
>> + * Comparison function that allows to sort SCSI commands by ULD driver.
>> + */
>> +static int scsi_cmp_uld(void *priv, const struct list_head *_a,
>> +			const struct list_head *_b)
>> +{
>> +	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
>> +	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
>> +
>> +	/* See also the comment above the list_sort() definition. */
>> +	return scsi_cmd_to_driver(a) > scsi_cmd_to_driver(b);
>> +}
>> +
>> +void scsi_call_prepare_resubmit(struct list_head *done_q)
>> +{
>> +	struct scsi_cmnd *scmd, *next;
>> +
>> +	if (!scsi_needs_sorting(done_q))
>> +		return;
> 
> This is strange. The eh_prepare_resubmit callback is generic and its name does
> not indicate anything related to sorting by LBAs. So this check would prevent
> other actions not related to sorting by LBA. This should go away.
> 
> In patch 6, based on the device characteristics, the sd driver should decides
> if it needs to set .eh_prepare_resubmit or not.
> 
> And ideally, if all ULDs have eh_prepare_resubmit == NULL, this function should
> return here before going through the list of commands to resubmit. Given that
> this list should generally be small, going through it and doing nothing should
> be OK though...

I can add a eh_prepare_resubmit == NULL check early in 
scsi_call_prepare_resubmit(). Regarding the code inside 
scsi_needs_sorting(), how about moving that code into an additional 
callback function, e.g. eh_needs_prepare_resubmit? Setting 
.eh_prepare_resubmit depending on the zone model would prevent 
constification of struct scsi_driver.

Thanks,

Bart.
