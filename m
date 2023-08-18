Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FD0C71134
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 02:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357272AbjHRCip (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 22:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357332AbjHRCij (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 22:38:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B128D3A99;
        Thu, 17 Aug 2023 19:38:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 475B7631F3;
        Fri, 18 Aug 2023 02:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E63C433C8;
        Fri, 18 Aug 2023 02:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692326310;
        bh=KCuT3kze6nhX34nu2DFz2uiX0/3DY6wurYuLDxoFexc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=p5/DTVkgFYAdybu+HwDy4kXXvnEG6gxGINlGYDipIqZrMJQVTauQr2w43sqLN432a
         W3C3LCnT1/PzG2POWT23hUe80+5CMmMU5ereIhOf0RBNkoDj3M9zjln8Nz9i3EHlhb
         yIXPV6O5sJmkYq0CrX8AIp0YPkXrpVVxLRz3Pn49nhlMNbml1p2T0OU4tcRLkyNXcs
         AgypH1VkbaG5FJY7y4mS/5pm9KCMhs3/BxkSA9NyQw/Gc354pLfWK5SUqlb6QE23vF
         4MBMXULEl8WnX3dH0yuESE5BZkU6iAS+Gi4QObj9xzjfQNYRYV6Ur98ivVgkrowZg4
         Uliw29brzeW5g==
Message-ID: <033a9b3f-c1d8-46b5-e4e4-350308648679@kernel.org>
Date:   Fri, 18 Aug 2023 11:38:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v9 04/17] scsi: core: Call .eh_prepare_resubmit() before
 resubmitting
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-5-bvanassche@acm.org>
 <201ae2be-3829-97ad-caa5-6f6f3a41e6db@kernel.org>
 <49bdae64-6162-5802-2dfb-c433ab48b5f9@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <49bdae64-6162-5802-2dfb-c433ab48b5f9@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/08/17 23:26, Bart Van Assche wrote:
> On 8/17/23 04:10, Damien Le Moal wrote:
>> On 8/17/23 04:53, Bart Van Assche wrote:
>>> +/*
>>> + * Returns true if the commands in @done_q should be sorted in LBA order
>>> + * before being resubmitted.
>>> + */
>>> +static bool scsi_needs_sorting(struct list_head *done_q)
>>> +{
>>> +	struct scsi_cmnd *scmd;
>>> +
>>> +	list_for_each_entry(scmd, done_q, eh_entry) {
>>> +		struct request *rq = scsi_cmd_to_rq(scmd);
>>> +
>>> +		if (!rq->q->limits.use_zone_write_lock &&
>>> +		    blk_rq_is_seq_zoned_write(rq))
>>> +			return true;
>>> +	}
>>> +
>>> +	return false;
>>> +}
>>> +
>>> +/*
>>> + * Comparison function that allows to sort SCSI commands by ULD driver.
>>> + */
>>> +static int scsi_cmp_uld(void *priv, const struct list_head *_a,
>>> +			const struct list_head *_b)
>>> +{
>>> +	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
>>> +	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
>>> +
>>> +	/* See also the comment above the list_sort() definition. */
>>> +	return scsi_cmd_to_driver(a) > scsi_cmd_to_driver(b);
>>> +}
>>> +
>>> +void scsi_call_prepare_resubmit(struct list_head *done_q)
>>> +{
>>> +	struct scsi_cmnd *scmd, *next;
>>> +
>>> +	if (!scsi_needs_sorting(done_q))
>>> +		return;
>>
>> This is strange. The eh_prepare_resubmit callback is generic and its name does
>> not indicate anything related to sorting by LBAs. So this check would prevent
>> other actions not related to sorting by LBA. This should go away.
>>
>> In patch 6, based on the device characteristics, the sd driver should decides
>> if it needs to set .eh_prepare_resubmit or not.
>>
>> And ideally, if all ULDs have eh_prepare_resubmit == NULL, this function should
>> return here before going through the list of commands to resubmit. Given that
>> this list should generally be small, going through it and doing nothing should
>> be OK though...
> 
> I can add a eh_prepare_resubmit == NULL check early in 
> scsi_call_prepare_resubmit(). Regarding the code inside 
> scsi_needs_sorting(), how about moving that code into an additional 
> callback function, e.g. eh_needs_prepare_resubmit? Setting 
> .eh_prepare_resubmit depending on the zone model would prevent 
> constification of struct scsi_driver.

Sounds OK.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

