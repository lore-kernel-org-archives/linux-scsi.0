Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19F1C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8063121531
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388620AbgF2VXX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:23:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:44648 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729590AbgF2SvY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 14:51:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2BFCFADE0;
        Mon, 29 Jun 2020 06:32:29 +0000 (UTC)
Subject: Re: [PATCH 03/22] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microchip.de>, linux-scsi@vger.kernel.org
References: <20200625140124.17201-1-hare@suse.de>
 <20200625140124.17201-4-hare@suse.de>
 <863b7da2-bbfc-a32f-87ab-648f8561314c@acm.org>
 <7a52763c-eb51-7c63-8d06-b0cc2eab6630@suse.de>
 <e5964b6d-43c1-a14d-c791-4b5826eb2ee8@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9793e936-cf51-2d6a-fccd-4a4b9c8cae02@suse.de>
Date:   Mon, 29 Jun 2020 08:32:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e5964b6d-43c1-a14d-c791-4b5826eb2ee8@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/28/20 5:08 PM, Bart Van Assche wrote:
> On 2020-06-28 02:02, Hannes Reinecke wrote:
>> On 6/28/20 5:48 AM, Bart Van Assche wrote:
>>> On 2020-06-25 07:01, Hannes Reinecke wrote:
>>>> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>>>> +                    int data_direction, int op_flags)
>>>
>>> How about using enum dma_data_direction for data_direction and unsigned
>>> int, or even better, a new __bitwise type for op_flags?
>>>
>> Okay for data direction, but converting op_flags into __bitwise (or even
>> a new type) should be relegated to a different patchset.
> 
> OK.
> 
>>>> +/**
>>>> + * scsi_put_internal_cmd - free an internal SCSI command
>>>> + * @scmd: SCSI command to be freed
>>>> + */
>>>> +void scsi_put_internal_cmd(struct scsi_cmnd *scmd)
>>>> +{
>>>> +    struct request *rq = blk_mq_rq_from_pdu(scmd);
>>>> +
>>>> +    if (blk_rq_is_internal(rq))
>>>> +        blk_mq_free_request(rq);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(scsi_put_internal_cmd);
>>>
>>> How about triggering a warning for the !blk_rq_is_internal(rq) case
>>> instead of silently ignoring regular SCSI commands?
>>>
>> That's by design.
>> Some drivers have a common routine for freeing up commands, so it'd be
>> quite tricky to separate these two cases out at the driver level.
>> So it's far easier to call the common routine for all commands, and
>> let this function do the right thing for all commands.
> 
> That sounds fair to me, but is an example available in this patch series
> of a call to scsi_put_internal_cmd() from such a common routine? It
> seems to me that all calls to scsi_put_internal_cmd() introduced in this
> patch series happen from code paths that handle internal commands only?
> 
aacraid.
The function aac_fib_free() is called unconditionally for every fib, and 
doesn't have the means to differentiate between 'normal' and 'internal' 
commands.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
