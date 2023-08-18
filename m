Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E809C71134
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 02:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357288AbjHRCl5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 22:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355001AbjHRClg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 22:41:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B23B273C;
        Thu, 17 Aug 2023 19:41:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDD4C6225B;
        Fri, 18 Aug 2023 02:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C10C433C7;
        Fri, 18 Aug 2023 02:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692326494;
        bh=69NFg+xLy6Grj5bAEumG3/r1gy5SzMRhgyeG1V+3eW8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FPGRiuWzSGm629KltXMBlq30IeGzgPD+9bbMgWyLJmL0fB3muPtgwiEVyFRlVgbRp
         JsQ3PKXW/eedW6HF1vkEAPnRnuewDRcJ96nu9scBCoLEFaG/LkDBoNFiQUxcjTPcRB
         +MVnnBztkAPxBr0gEuODRDdbThPtar3qxvDu7vAPVCvpgL6DTs32zRs8NDBZ655axz
         QvUUxZQyhlPd+yZKXofyFoKfqduWX6XLZfjWv1G4Vo5lfhkFLXKb+bDAuhjI/Qd13v
         juEbPTVRUk+VbWpFate5x8beXKurH5gET0LZp1bsO26+NN5hVTuYsvTb5BybhA4ONP
         nvraF0R/c9cCA==
Message-ID: <2e06646f-d72d-6321-08a3-a41e70c7e36e@kernel.org>
Date:   Fri, 18 Aug 2023 11:41:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v9 06/17] scsi: sd: Sort commands by LBA before
 resubmitting
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-7-bvanassche@acm.org>
 <84e5531b-f6ae-8454-9079-39aeec09c6ed@kernel.org>
 <9a05f686-6755-b544-619f-1ed8fdabb542@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <9a05f686-6755-b544-619f-1ed8fdabb542@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/08/17 23:34, Bart Van Assche wrote:
> On 8/17/23 04:13, Damien Le Moal wrote:
>> On 8/17/23 04:53, Bart Van Assche wrote:
>>> +static int sd_cmp_sector(void *priv, const struct list_head *_a,
>>> +			 const struct list_head *_b)
>>> +{
>>> +	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
>>> +	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
>>> +	struct request *rq_a = scsi_cmd_to_rq(a);
>>> +	struct request *rq_b = scsi_cmd_to_rq(b);
>>> +	bool use_zwl_a = rq_a->q->limits.use_zone_write_lock;
>>> +	bool use_zwl_b = rq_b->q->limits.use_zone_write_lock;
>>> +
>>> +	/*
>>> +	 * Order the commands that need zone write locking after the commands
>>> +	 * that do not need zone write locking. Order the commands that do not
>>> +	 * need zone write locking by LBA. Do not reorder the commands that
>>> +	 * need zone write locking. See also the comment above the list_sort()
>>> +	 * definition.
>>> +	 */
>>> +	if (use_zwl_a || use_zwl_b)
>>> +		return use_zwl_a > use_zwl_b;
>>> +	return blk_rq_pos(rq_a) > blk_rq_pos(rq_b);
>>> +}
>>> +
>>> +static void sd_prepare_resubmit(struct list_head *cmd_list)
>>> +{
>>> +	/*
>>> +	 * Sort pending SCSI commands in starting sector order. This is
>>> +	 * important if one of the SCSI devices associated with @shost is a
>>> +	 * zoned block device for which zone write locking is disabled.
>>> +	 */
>>> +	list_sort(NULL, cmd_list, sd_cmp_sector);
>>
>> We should not need to do this for regular devices or zoned devices using zone
>> write locking. So returning doing nothing would be better but the callback
>> lacks a pointer to the scsi_device to test that.
> 
> @cmd_list may include SCSI commands for multiple SCSI devices so I'm not 
> sure which SCSI device pointer you are referring to in the above comment?

This is called from scsi_eh_flush_done_q() which also does not have the scsi
device pointer. And places where this is called have the scsi host pointer, not
the device. OK. So let's no do that.

> 
> Thanks,
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

