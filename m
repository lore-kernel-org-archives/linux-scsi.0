Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86ECC433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 16:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF4EF2333F
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 16:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgLFQGO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 11:06:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:36110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbgLFQGN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 6 Dec 2020 11:06:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E3631ACD5;
        Sun,  6 Dec 2020 16:05:31 +0000 (UTC)
Subject: Re: [PATCH 3/3] block: set REQ_PREFLUSH to the final bio from
 __blkdev_issue_zero_pages()
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20201206055332.3144-1-tom.ty89@gmail.com>
 <20201206055332.3144-3-tom.ty89@gmail.com>
 <2eb8f838-0ec6-3e70-356b-8c04baba2fc4@suse.de>
 <CAGnHSEk0C6VNQysGiysPS1yEXwu4U8PVCaVB2RR7oEgnr4Xz=w@mail.gmail.com>
 <4304d959-9155-3126-a858-28b338968916@suse.de>
 <CAGnHSEmMB5bfkCqyk=USHnmFr+Z1HA9UQ8whBD08K1hwvM2Scw@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b18fa5df-2a18-e29c-911b-483dcb451f06@suse.de>
Date:   Sun, 6 Dec 2020 17:05:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAGnHSEmMB5bfkCqyk=USHnmFr+Z1HA9UQ8whBD08K1hwvM2Scw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/6/20 3:14 PM, Tom Yan wrote:
> On Sun, 6 Dec 2020 at 22:05, Hannes Reinecke <hare@suse.de> wrote:
>>
>> On 12/6/20 2:32 PM, Tom Yan wrote:
>>> Why? Did you miss that it is in the condition where
>>> __blkdev_issue_zero_pages() is called (i.e. it's not WRITE SAME but
>>> WRITE). From what I gathered REQ_PREFLUSH triggers a write back cache
>>> (that is on the device; not sure about dirty pages) flush, wouldn't it
>>> be a right thing to do after we performed a series of WRITE (which is
>>> more or less purposed to get a drive wiped clean).
>>>
>>
>> But what makes 'zero_pages' special as compared to, say, WRITE_SAME?
>> One could use WRITE SAME with '0' content, arriving at pretty much the
>> same content than usine zeroout without unmapping. And neither of them
>> worries about cache flushing.
>> Nor should they, IMO.
> 
> Because we are writing actual pages (just that they are zero and
> "shared memory" in the system) to the device, instead of triggering a
> special command (with a specific parameter)?
> 

But these pages are ephemeral, and never visible to the user.

>>
>> These are 'native' block layer calls, providing abstract accesses to
>> hardware functionality. If an application wants to use them, it would be
>> the task of the application to insert a 'flush' if it deems neccessary.
>> (There _is_ blkdev_issue_flush(), after all).
> 
> Well my argument would be the call has the purpose of "wiping" so it
> should try to "atomically" guarantee that the wiping is synced. It's
> like a complement to REQ_SYNC in the final submit_bio_wait().
> 
That's an assumption.

It would be valid if blkdev_issue_zeroout() would only allow to wipe the 
entire disk. As it stands, it doesn't, and so we shouldn't presume what 
users might want to do with it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
