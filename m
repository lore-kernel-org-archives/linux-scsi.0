Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32749C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 15:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F16C1613D1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 15:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbhDVP4y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 11:56:54 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:37773 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236333AbhDVP4x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 11:56:53 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 93D322EA484;
        Thu, 22 Apr 2021 11:56:13 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id gTy+9PG7ksCw; Thu, 22 Apr 2021 11:36:23 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 1538C2EA47B;
        Thu, 22 Apr 2021 11:56:13 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 14/42] scsi: add scsi_result_is_good()
To:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-15-hare@suse.de>
 <b510135a-3dca-e6e4-bdbb-f1ff3817cc29@acm.org>
 <51b16b13-d4e3-f0e4-718e-357d04ed958f@interlog.com>
 <d74a6a9a-6187-8847-7364-0bf7999b3379@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <db827915-84e0-1aea-7b30-a01a22059817@interlog.com>
Date:   Thu, 22 Apr 2021 11:56:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d74a6a9a-6187-8847-7364-0bf7999b3379@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-22 4:42 a.m., Hannes Reinecke wrote:
> On 4/21/21 11:58 PM, Douglas Gilbert wrote:
>> On 2021-04-21 5:10 p.m., Bart Van Assche wrote:
>>> On 4/21/21 10:47 AM, Hannes Reinecke wrote:
>>>> +static inline bool scsi_result_is_good(struct scsi_cmnd *cmd)
>>>> +{
>>>> +    return (cmd->result == 0);
>>>> +}
>>>
>>> Do we really need an inline function to compare an integer with zero? How 
>>> about open-coding this comparison in the callers of this function?
>>>
>>
>> Please don't open code it. Please fix it!
>> Spot the difference:
>>
>> static inline int scsi_status_is_good(int status)
>> {
>>          /*
>>           * FIXME: bit0 is listed as reserved in SCSI-2, but is
>>           * significant in SCSI-3.  For now, we follow the SCSI-2
>>           * behaviour and ignore reserved bits.
>>           */
>>          status &= 0xfe;
>>          return ((status == SAM_STAT_GOOD) ||
>>                  (status == SAM_STAT_CONDITION_MET) ||
>> /*   >>>                   ^^^^^^^^^^^^^^^^^^^^^^ <<<        */
>>                  /* Next two "intermediate" statuses are obsolete in SAM-4 */
>>                  (status == SAM_STAT_INTERMEDIATE) ||
>>                  (status == SAM_STAT_INTERMEDIATE_CONDITION_MET) ||
>>                  /* FIXME: this is obsolete in SAM-3 */
>>                  (status == SAM_STAT_COMMAND_TERMINATED));
>> }
>>
>> In sg3_utils' library I ignore the last three SAM_STATs. Not sure if ignoring
>> bit 0 is still required.
>>
>> Without considering SAM_STAT_CONDITION_MET a good status, someone will be
>> scratching their head wondering why so many PRE-FETCH commands fail.
>>
>> That command can be used when a sequence of READs to consecutive LBAs is
>> followed by a different (i.e. non-consecutive) READ. That last READ could
>> be preceded by PRE-FETCH(new_LBA, IMMED). Assuming there is processing
>> of the data from the consecutive LBAs to be done, when the time comes
>> for READ(new_LBA) the probability of its data being in the disk's cache is
>> increased.
>>
> That would be a change in behaviour.
> Current code doesn't check for CONDITION_MET, so this change shouldn't do it, 
> neither. Idea was that this patchset shouldn't change the current behaviour.
> 
> While your argument might be valid, it definitely is a different story and would 
> need to be address with a different patchset.

Okay. May I suggest a "FIX_ME" comment? And again, please don't open code it.

In driver manuals Seagate often list the PRE-FETCH command as optional. As
in: pay us some extra money and we will put it in. That suggests to me some
big OEM likes PRE-FETCH. Where I found it supported in WDC manuals, they
didn't support the IMMED bit which sort of defeats the purpose of it IMO.

Doug Gilbert


