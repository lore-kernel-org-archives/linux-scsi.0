Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52062CDB482
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Oct 2023 01:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbjJLBCN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Oct 2023 21:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233969AbjJLBCM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Oct 2023 21:02:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E23A9;
        Wed, 11 Oct 2023 18:02:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1D2C433C9;
        Thu, 12 Oct 2023 01:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697072531;
        bh=yiANFDzQ62tB7ZkTAR1ls+F1QryoZ0mK2oO/chRVDKc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=LzaS5dJ7h/XH5ZlVAyfzW8tJV0oac+mUEfgPA4MglhzYbSXfl6RTXqW+3/J00LLWT
         23KhwKXyC1Y3PB6aed2SZlawoNnVe+mS5pUdD42qbP4Tl93F4uZeA9LipGne+MIawl
         U3FLobkG5w62P+lEB/hJcrfgOuM4d2Qjm518lGkVV7SR3lUYm6m1i2RynsP38EdkXt
         tqi1GYh4/ijxvaS+t+0/zKR9TMqnFt48zhco/vkFCJWfNdXU86dAcuqXmHokeT3xyX
         ZEs3RaMSYFXByh7aW2oDA1xSDe7ANv9q3C3T33jsgjjatuB5miyDF8r6uzKD2eYkgC
         V1ixt/Dc3xZZw==
Message-ID: <447f3095-66cb-417b-b48c-90005d37b5d3@kernel.org>
Date:   Thu, 12 Oct 2023 10:02:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/15] block: Support data lifetime in the I/O priority
 bitfield
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Hannes Reinecke <hare@suse.de>
References: <20231005194129.1882245-1-bvanassche@acm.org>
 <20231005194129.1882245-4-bvanassche@acm.org>
 <8aec03bb-4cef-9423-0ce4-c10d060afce4@kernel.org>
 <46c17c1b-29be-41a3-b799-79163851f972@acm.org>
 <b0b015bf-0a27-4e89-950a-597b9fed20fb@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <b0b015bf-0a27-4e89-950a-597b9fed20fb@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/12/23 05:51, Bart Van Assche wrote:
> On 10/6/23 11:07, Bart Van Assche wrote:
>> On 10/6/23 01:19, Damien Le Moal wrote:
>>> Your change seem to assume that it makes sense to be able to combine CDL with
>>> lifetime hints. But does it really ? CDL is of dubious value for solid state
>>> media and as far as I know, UFS world has not expressed interest. Conversely,
>>> data lifetime hints do not make much sense for spin rust media where CDL is
>>> important. So I would say that the combination of CDL and lifetime hints is of
>>> dubious value.
>>>
>>> Given this, why not simply define the 64 possible lifetime values as plain hint
>>> values (8 to 71, following 1 to 7 for CDL) ?
>>>
>>> The other question here if you really want to keep the bit separation approach
>>> is: do we really need up to 64 different lifetime hints ? While the scsi
>>> standard allows that much, does this many different lifetime make sense in
>>> practice ? Can we ever think of a usecase that needs more than say 8 different
>>> liftimes (3 bits) ? If you limit the number of possible lifetime hints to 8,
>>> then we can keep 4 bits unused in the hint field for future features.
>>
>> Hi Damien,
>>
>> Not supporting CDL for solid state media and supporting eight different
>> lifetime values sounds good to me. Is this perhaps what you had in mind?
>>
>> Thanks,
>>
>> Bart.
>>
>> --- a/include/uapi/linux/ioprio.h
>> +++ b/include/uapi/linux/ioprio.h
>> @@ -100,6 +100,14 @@ enum {
>>          IOPRIO_HINT_DEV_DURATION_LIMIT_5 = 5,
>>          IOPRIO_HINT_DEV_DURATION_LIMIT_6 = 6,
>>          IOPRIO_HINT_DEV_DURATION_LIMIT_7 = 7,
>> +       IOPRIO_HINT_DATA_LIFE_TIME_0 = 8,
>> +       IOPRIO_HINT_DATA_LIFE_TIME_1 = 9,
>> +       IOPRIO_HINT_DATA_LIFE_TIME_2 = 10,
>> +       IOPRIO_HINT_DATA_LIFE_TIME_3 = 11,
>> +       IOPRIO_HINT_DATA_LIFE_TIME_4 = 12,
>> +       IOPRIO_HINT_DATA_LIFE_TIME_5 = 13,
>> +       IOPRIO_HINT_DATA_LIFE_TIME_6 = 14,
>> +       IOPRIO_HINT_DATA_LIFE_TIME_7 = 15,
>>   };
> 
> (replying to my own e-mail)
> 
> Hi Damien,
> 
> Does the above look good to you?

Yes, it is what I was thinking of and I think it looks much better (and
simpler) than coding with different bits. However, I think this is acceptable
only if everyone agrees that combining CDL and lifetime (and potentially other
hints) is not a sensible thing to do. I stated that my thinking is that CDL is
more geared toward rotating media while lifetime is more suitable for solid
state media. But does everyone agree ?

Some have stated interest in CDL in NVMe-oF context, which could imply that
combining CDL and lifetime may be something useful to do in that space...

Getting more opinions about this would be nice. If we do not get any, I would
say that we should go with this.

-- 
Damien Le Moal
Western Digital Research

