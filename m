Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E64C30627
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 14:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351953AbjHQOez (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 10:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351951AbjHQOe3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 10:34:29 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25642D73;
        Thu, 17 Aug 2023 07:34:28 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-689e6fce70dso725677b3a.1;
        Thu, 17 Aug 2023 07:34:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692282868; x=1692887668;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sck532JHOhwONeGuqlkX/xK2hnHFlj/D2G05yWki0Ug=;
        b=KP/YzTVffLWh3y4xaGA55SmDIjfFafMDwN+RBasWHnjvUyhTMoD3B/LhxCNgHeU9PM
         2yauiAkpVRBoYIJbpY2ECzEsutEqYUEPagQ4jiJq22h6E+xdvSrK43ZTicVAvyQ1baz9
         ZKNA/HdTmV2KY9jGzQQluEuRmhxsyhi5FqYuI+vZvrtFfCKUxDEckadRNmGvu3mNr1Mi
         HgRgkNKCTtfZ1IqeI1m3htpwiHwzag2JyImhJ3Y6P+ciygZ+2LKdoneCR6OFpR5o436A
         DTdqlrDnWUtWA1gfdqmHmMe22KNFpfGDRpL0wv5Ftubz7+Zx3my2scGenh4ShKlWtKwt
         FpCA==
X-Gm-Message-State: AOJu0YxElQyW/VRWIj/A2breIk6XAIz9vDbN57Vyd+qzrU0FyMHU5t0r
        dsqYS5gsSnolW/YL6egGaBc=
X-Google-Smtp-Source: AGHT+IETvd0V3XBOGAxM0NAQOoOTKyEFFckrjhLzr+o7XPIlvpabU4bEknoYkVXwDIouiyu1gYTLiQ==
X-Received: by 2002:a05:6a00:3a20:b0:67e:6269:6ea8 with SMTP id fj32-20020a056a003a2000b0067e62696ea8mr6864063pfb.22.1692282867988;
        Thu, 17 Aug 2023 07:34:27 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:dfd:6f25:f7be:a9ca? ([2620:15c:211:201:dfd:6f25:f7be:a9ca])
        by smtp.gmail.com with ESMTPSA id s11-20020a62e70b000000b006888029fd63sm3164072pfh.9.2023.08.17.07.34.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Aug 2023 07:34:27 -0700 (PDT)
Message-ID: <9a05f686-6755-b544-619f-1ed8fdabb542@acm.org>
Date:   Thu, 17 Aug 2023 07:34:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v9 06/17] scsi: sd: Sort commands by LBA before
 resubmitting
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-7-bvanassche@acm.org>
 <84e5531b-f6ae-8454-9079-39aeec09c6ed@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <84e5531b-f6ae-8454-9079-39aeec09c6ed@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 04:13, Damien Le Moal wrote:
> On 8/17/23 04:53, Bart Van Assche wrote:
>> +static int sd_cmp_sector(void *priv, const struct list_head *_a,
>> +			 const struct list_head *_b)
>> +{
>> +	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
>> +	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
>> +	struct request *rq_a = scsi_cmd_to_rq(a);
>> +	struct request *rq_b = scsi_cmd_to_rq(b);
>> +	bool use_zwl_a = rq_a->q->limits.use_zone_write_lock;
>> +	bool use_zwl_b = rq_b->q->limits.use_zone_write_lock;
>> +
>> +	/*
>> +	 * Order the commands that need zone write locking after the commands
>> +	 * that do not need zone write locking. Order the commands that do not
>> +	 * need zone write locking by LBA. Do not reorder the commands that
>> +	 * need zone write locking. See also the comment above the list_sort()
>> +	 * definition.
>> +	 */
>> +	if (use_zwl_a || use_zwl_b)
>> +		return use_zwl_a > use_zwl_b;
>> +	return blk_rq_pos(rq_a) > blk_rq_pos(rq_b);
>> +}
>> +
>> +static void sd_prepare_resubmit(struct list_head *cmd_list)
>> +{
>> +	/*
>> +	 * Sort pending SCSI commands in starting sector order. This is
>> +	 * important if one of the SCSI devices associated with @shost is a
>> +	 * zoned block device for which zone write locking is disabled.
>> +	 */
>> +	list_sort(NULL, cmd_list, sd_cmp_sector);
> 
> We should not need to do this for regular devices or zoned devices using zone
> write locking. So returning doing nothing would be better but the callback
> lacks a pointer to the scsi_device to test that.

@cmd_list may include SCSI commands for multiple SCSI devices so I'm not 
sure which SCSI device pointer you are referring to in the above comment?

Thanks,

Bart.

