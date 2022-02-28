Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F20C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 22:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiB1WqK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 17:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiB1WqI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 17:46:08 -0500
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EC0136EF0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 14:45:28 -0800 (PST)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 529E761649;
        Mon, 28 Feb 2022 22:45:28 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id 399C4630E6;
        Mon, 28 Feb 2022 22:45:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
        with ESMTP id IxQ4PECvOjLV; Mon, 28 Feb 2022 22:45:27 +0000 (UTC)
Received: from [192.168.48.23] (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 61A6C630DB;
        Mon, 28 Feb 2022 22:45:27 +0000 (UTC)
Message-ID: <fc8487e6-5ae4-01d6-e7c6-bf503b4de757@interlog.com>
Date:   Mon, 28 Feb 2022 17:45:26 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 1/2] scsi: scsi_debug: silence sparse unexpected unlock
 warnings
Content-Language: en-CA
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220225084527.523038-1-damien.lemoal@opensource.wdc.com>
 <20220225084527.523038-2-damien.lemoal@opensource.wdc.com>
 <86e4fafa-f834-6fb5-2337-314a6078a480@interlog.com>
 <146bfd4a-a863-cfd4-6054-1c44439caea9@opensource.wdc.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <146bfd4a-a863-cfd4-6054-1c44439caea9@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-02-28 01:58, Damien Le Moal wrote:
> On 2022/02/28 3:39, Douglas Gilbert wrote:
>> On 2022-02-25 03:45, Damien Le Moal wrote:
>>> The return statement inside the sdeb_read_lock(), sdeb_read_unlock(),
>>> sdeb_write_lock() and sdeb_write_unlock() confuse sparse, leading to
>>> many warnings about unexpected unlocks in the resp_xxx() functions.
>>>
>>> Modify the lock/unlock functions using the __acquire() and __release()
>>> inline annotations for the sdebug_no_rwlock == true case to avoid these
>>> warnings.
>>
>> I'm confused. The idea with sdebug_no_rwlock was that the application
>> may know that the protection afforded by the driver's rwlock is not
>> needed because locking is performed at a higher level (e.g. in the
>> user space). Hence there is no need to use a read-write lock (or a
>> full lock) in this driver to protect a read (say) against a co-incident
>> write to the same memory region. So this was a performance enhancement.
>>
>> The proposed patch seems to be replacing a read-write lock with a full
>> lock. That would be going in the opposite direction to what I intended.
> 
> Not at all. The __acquire() and __release() calls are not locking functions.
> They are annotations for sparse so that we get a correct +/-1 counting of the
> lock/unlock calls. So there is no functional change here and no overhead added
> when compiling without C=1 since these macros disappear without sparse.

Grrr. If those functions are dummies then I think it would be
reasonable if their names had a word like "fake" or "dummy" in
them.

That being the case:
Acked-by: Douglas Gilbert <dgilbert@interlog.com>


Note: these patches should probably be against Martin's 5.18/scsi-staging
       tree as he has taken 5 or 6 of my scsi_debug patches in this cycle.

> 
>>
>> If this is the only solution, a better idea might be to drop the
>> patch (in staging I think) that introduced the sdebug_no_rwlock option.
>>
>> The sdebug_no_rwlock option has been pretty thoroughly tested (for over
>> a year) with memory to memory transfers (together with sgl to sgl
>> additions to lib/scatterlist.h). Haven't seen any unexplained crashes
>> that I could trace to this lack of locking. OTOH I haven't measured
>> any improvement of the copy speed either, that may be because my tests
>> are approaching the copy bandwidth of the ram.
>>
>>
>> Does sparse understand guard variables (e.g. like 'bool lock_taken')?
>>   From what I've seen with sg3_utils Coverity doesn't, leading to many false
>> reports.
>>
>> Doug Gilbert
>>
>>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>> ---
>>>    drivers/scsi/scsi_debug.c | 68 +++++++++++++++++++++++++--------------
>>>    1 file changed, 44 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>>> index 0d25b30922ef..f4e97f2224b2 100644
>>> --- a/drivers/scsi/scsi_debug.c
>>> +++ b/drivers/scsi/scsi_debug.c
>>> @@ -3167,45 +3167,65 @@ static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
>>>    static inline void
>>>    sdeb_read_lock(struct sdeb_store_info *sip)
>>>    {
>>> -	if (sdebug_no_rwlock)
>>> -		return;
>>> -	if (sip)
>>> -		read_lock(&sip->macc_lck);
>>> -	else
>>> -		read_lock(&sdeb_fake_rw_lck);
>>> +	if (sdebug_no_rwlock) {
>>> +		if (sip)
>>> +			__acquire(&sip->macc_lck);
>>> +		else
>>> +			__acquire(&sdeb_fake_rw_lck);
>>> +	} else {
>>> +		if (sip)
>>> +			read_lock(&sip->macc_lck);
>>> +		else
>>> +			read_lock(&sdeb_fake_rw_lck);
>>> +	}
>>>    }
>>>    
>>>    static inline void
>>>    sdeb_read_unlock(struct sdeb_store_info *sip)
>>>    {
>>> -	if (sdebug_no_rwlock)
>>> -		return;
>>> -	if (sip)
>>> -		read_unlock(&sip->macc_lck);
>>> -	else
>>> -		read_unlock(&sdeb_fake_rw_lck);
>>> +	if (sdebug_no_rwlock) {
>>> +		if (sip)
>>> +			__release(&sip->macc_lck);
>>> +		else
>>> +			__release(&sdeb_fake_rw_lck);
>>> +	} else {
>>> +		if (sip)
>>> +			read_unlock(&sip->macc_lck);
>>> +		else
>>> +			read_unlock(&sdeb_fake_rw_lck);
>>> +	}
>>>    }
>>>    
>>>    static inline void
>>>    sdeb_write_lock(struct sdeb_store_info *sip)
>>>    {
>>> -	if (sdebug_no_rwlock)
>>> -		return;
>>> -	if (sip)
>>> -		write_lock(&sip->macc_lck);
>>> -	else
>>> -		write_lock(&sdeb_fake_rw_lck);
>>> +	if (sdebug_no_rwlock) {
>>> +		if (sip)
>>> +			__acquire(&sip->macc_lck);
>>> +		else
>>> +			__acquire(&sdeb_fake_rw_lck);
>>> +	} else {
>>> +		if (sip)
>>> +			write_lock(&sip->macc_lck);
>>> +		else
>>> +			write_lock(&sdeb_fake_rw_lck);
>>> +	}
>>>    }
>>>    
>>>    static inline void
>>>    sdeb_write_unlock(struct sdeb_store_info *sip)
>>>    {
>>> -	if (sdebug_no_rwlock)
>>> -		return;
>>> -	if (sip)
>>> -		write_unlock(&sip->macc_lck);
>>> -	else
>>> -		write_unlock(&sdeb_fake_rw_lck);
>>> +	if (sdebug_no_rwlock) {
>>> +		if (sip)
>>> +			__release(&sip->macc_lck);
>>> +		else
>>> +			__release(&sdeb_fake_rw_lck);
>>> +	} else {
>>> +		if (sip)
>>> +			write_unlock(&sip->macc_lck);
>>> +		else
>>> +			write_unlock(&sdeb_fake_rw_lck);
>>> +	}
>>>    }
>>>    
>>>    static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>>
> 
> 

