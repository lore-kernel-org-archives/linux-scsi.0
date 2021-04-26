Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790D6C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 08:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 345AB6112F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 08:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhDZIqr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 04:46:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:60924 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232068AbhDZIqq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 04:46:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1AE0EAEAA;
        Mon, 26 Apr 2021 08:45:59 +0000 (UTC)
To:     dgilbert@interlog.com, Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-15-hare@suse.de>
 <b510135a-3dca-e6e4-bdbb-f1ff3817cc29@acm.org>
 <51b16b13-d4e3-f0e4-718e-357d04ed958f@interlog.com>
 <d74a6a9a-6187-8847-7364-0bf7999b3379@suse.de>
 <db827915-84e0-1aea-7b30-a01a22059817@interlog.com>
 <62237423-f4f9-a426-43b5-3ff56a5dca1a@acm.org>
 <b00aab9c-9cb9-06a9-94b9-57e164777b26@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: Re: [PATCH 14/42] scsi: add scsi_result_is_good()
Message-ID: <fe2012c8-3421-dbef-9d79-78eabdcc870d@suse.de>
Date:   Mon, 26 Apr 2021 10:45:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <b00aab9c-9cb9-06a9-94b9-57e164777b26@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/21 7:33 PM, Douglas Gilbert wrote:
> On 2021-04-22 12:52 p.m., Bart Van Assche wrote:
>> On 4/22/21 8:56 AM, Douglas Gilbert wrote:
>>> In driver manuals Seagate often list the PRE-FETCH command as
>>> optional. As
>>> in: pay us some extra money and we will put it in. That suggests to
>>> me some
>>> big OEM likes PRE-FETCH. Where I found it supported in WDC manuals, they
>>> didn't support the IMMED bit which sort of defeats the purpose of it
>>> IMO.
>>
>> Since the sd driver does not submit the PRE-FETCH command, how about
>> moving support for CONDITION MET into the sg code and treating CONDITION
>> MET as an error inside the sd, sr and st drivers? I think that would
>> allow to simplify scsi_status_is_good(). The current definition of that
>> function is as follows:
>>
>> static inline int scsi_status_is_good(int status)
>> {
>>     /*
>>      * FIXME: bit0 is listed as reserved in SCSI-2, but is
>>      * significant in SCSI-3.  For now, we follow the SCSI-2
>>      * behaviour and ignore reserved bits.
>>      */
>>     status &= 0xfe;
>>     return ((status == SAM_STAT_GOOD) ||
>>         (status == SAM_STAT_CONDITION_MET) ||
>>         /* Next two "intermediate" statuses are obsolete in*/
>>         /* SAM-4 */
>>         (status == SAM_STAT_INTERMEDIATE) ||
>>         (status == SAM_STAT_INTERMEDIATE_CONDITION_MET) ||
>>         /* FIXME: this is obsolete in SAM-3 */
>>         (status == SAM_STAT_COMMAND_TERMINATED));
>> }
> 
> The whole stack needs to treat SAM_STAT_CONDITION_MET as a non-error.
> However the complex multi-layer return values are represented,
> reducing them to a comparison with zero, spread all over the
> stack just seems bad software engineering. IMO a predicate function
> (i.e. returning bool) is needed.
> 
> I would argue that in the right circumstances, the sd driver should
> indeed by using PRE-FETCH. It would need help from the upper layers.
> It is essentially "read-ahead" in the case where the next LBA
> does not follow the last read LBA. A smarter read-ahead ...
> 
Might, but again not something we should attempt in this patchset.

Using PRE-FETCH might be worthwhile for larger I/O, which we could
easily prepend with a PRE-FETCH command for the entire range.
But then error handling for PRE-FETCH is decidedly tricky, and we might
end up incurring quite some regressions just because we didn't get the
error handling right in the first go.

Worth a shot, but please in another patchset.

The other use-case for using PRE-FETCH after cryptographic erase
definitely is required, but as that's triggered by userspace I would
expect userspace to do it properly, too.

The only valid use-case I see would be for issuing PRE-FETCH after
UNMAP, but that would need to be plugged into the 'discard' machinery,
which is already fragile as hell; I'd rather not attempt that one.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
