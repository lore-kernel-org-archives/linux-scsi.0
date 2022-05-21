Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1728AC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 21 May 2022 10:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242223AbiEUKRI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 May 2022 06:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbiEUKRH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 May 2022 06:17:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AE84B878
        for <linux-scsi@vger.kernel.org>; Sat, 21 May 2022 03:17:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5047F1F898;
        Sat, 21 May 2022 10:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653128224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=04XIXZI5q7ysJ4UPG1jEsvk/LppViCfZDFwxPmaOt98=;
        b=bs2wJbkYiEntJnZQk+G9NPr8zy4qQXRrlc8qHgLItG0ITP9+mCeswHKx1EHinHPEYQSiPY
        q71akEeWMrrxlPhJkIO3+27MGYFPsPagCT2KxKSoEMLAIF2TbY+g+Cx89HEu6yZ9MubGQJ
        m1YhXhIwHHype22KXV78txzHcF6iHuc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653128224;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=04XIXZI5q7ysJ4UPG1jEsvk/LppViCfZDFwxPmaOt98=;
        b=gtZv2hhVPav8QT2autJXKEMLyDuXw0dvTVzIK8hewfAnJQtf1pQ9Tlugc2tjR7Z1oh1/u1
        8cwoHarvykjVaWBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D48BB13AE3;
        Sat, 21 May 2022 10:17:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VdLXMh+8iGINXgAAMHmgww
        (envelope-from <hare@suse.de>); Sat, 21 May 2022 10:17:03 +0000
Message-ID: <a9567ba6-d4ec-70d5-26a8-d6e055fd79e5@suse.de>
Date:   Sat, 21 May 2022 12:17:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian Bunker <brian@purestorage.com>,
        linux-scsi@vger.kernel.org
Cc:     Benjamin Marzinski <bmarzins@redhat.com>
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
 <165153834205.24012.9775963085982195213.b4-ty@oracle.com>
 <c8e9451c521573b1774bd47f7a4dfe911fd80f8d.camel@suse.com>
 <32404e1c-bbd3-d3fb-c83f-394bc3765e7b@suse.de>
 <2f6d93fd90c3e78166a1803a989b4dc6064fcada.camel@suse.com>
 <7d0140a6-9ab7-9b88-9601-4204ab8a88ca@oracle.com>
 <234ccf5fc9f36fd837b3959057691a716685da3b.camel@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <234ccf5fc9f36fd837b3959057691a716685da3b.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/20/22 13:03, Martin Wilck wrote:
> On Fri, 2022-05-20 at 14:08 -0500, Mike Christie wrote:
>> On 5/20/22 9:03 AM, Martin Wilck wrote:
>>> On Fri, 2022-05-20 at 14:06 +0200, Hannes Reinecke wrote:
>>>> On 5/20/22 12:57, Martin Wilck wrote:
>>>>> Brian, Martin,
>>>>>
>>>>> sorry, I've overlooked this patch previously. I have to say I
>>>>> think
>>>>> it's wrong and shouldn't have been applied. At least I need
>>>>> more
>>>>> in-
>>>>> depth explanation.
>>>>>
>>>>> On Mon, 2022-05-02 at 20:50 -0400, Martin K. Petersen wrote:
>>>>>> On Mon, 2 May 2022 08:09:17 -0700, Brian Bunker wrote:
>>>>>>
>>>>>>> The handling of the ALUA transitioning state is currently
>>>>>>> broken.
>>>>>>> When
>>>>>>> a target goes into this state, it is expected that the
>>>>>>> target
>>>>>>> is
>>>>>>> allowed to stay in this state for the implicit transition
>>>>>>> timeout
>>>>>>> without a path failure.
>>>>>
>>>>> Can you please show me a quote from the specs on which this
>>>>> expectation
>>>>> ("without a path failure") is based? AFAIK the SCSI specs don't
>>>>> say
>>>>> anything about device-mapper multipath semantics.
>>>>>
>>>>>>> The handler has this logic, but it gets
>>>>>>> skipped currently.
>>>>>>>
>>>>>>> When the target transitions, there is in-flight I/O from
>>>>>>> the
>>>>>>> initiator. The first of these responses from the target
>>>>>>> will be
>>>>>>> a
>>>>>>> unit
>>>>>>> attention letting the initiator know that the ALUA state
>>>>>>> has
>>>>>>> changed.
>>>>>>> The remaining in-flight I/Os, before the initiator finds
>>>>>>> out
>>>>>>> that
>>>>>>> the
>>>>>>> portal state has changed, will return not ready, ALUA state
>>>>>>> is
>>>>>>> transitioning. The portal state will change to
>>>>>>> SCSI_ACCESS_STATE_TRANSITIONING. This will lead to all new
>>>>>>> I/O
>>>>>>> immediately failing the path unexpectedly. The path failure
>>>>>>> happens
>>>>>>> in
>>>>>>> less than a second instead of the expected successes until
>>>>>>> the
>>>>>>> transition timer is exceeded.
>>>>>
>>>>> dm multipath has no concept of "transitioning" state. Path
>>>>> state
>>>>> can be
>>>>> either active or inactive. As Brian wrote, commands sent to the
>>>>> transitioning device will return NOT READY, TRANSITIONING, and
>>>>> require
>>>>> retries on the SCSI layer. If we know this in advance, why
>>>>> should
>>>>> we
>>>>> continue sending I/O down this semi-broken path? If other,
>>>>> healthy
>>>>> paths are available, why it would it not be the right thing to
>>>>> switch
>>>>> I/O to them ASAP?
>>>>>
>>>> But we do, don't we?
>>>> Commands are being returned with the appropriate status, and
>>>> dm-multipath should make the corresponding decisions here.
>>>> This patch just modifies the check when _sending_ commands; ie
>>>> multipath
>>>> had decided that the path is still usable.
>>>> Question rather would be why multipath did that;
>>>
>>> If alua_prep_fn() got called, the path was considered usable at the
>>> given point in time by dm-multipath. Most probably the reason was
>>> simply that no error condition had occured on this path before ALUA
>>> state switched to transitioning. I suppose this can happen
>>> if storage
>>> switches a PG consisting of multiple paths to TRANSITIONING. We get
>>> an
>>> error on one path (sda, say), issue an RTPG, and receive the new
>>> ALUA
>>> state for all paths of the PG. For all paths except sda, we'd just
>>> see
>>> a switch to TRANSITIONING without a previous SCSI error.
>>>
>>> With this patch, we'll dispatch I/O (usually an entire bunch) to
>>> these
>>> paths despite seeing them in TRANSITIONING state. Eventually, when
>>> the
>>> SCSI responses are received, this leads to path failures. If I/O
>>> latencies are small, this happens after a few ms. In that case, the
>>> goal of Brian's patch is not reached, because the time until path
>>> failure would still be on the order of milliseconds. OTOH, if
>>> latencies
>>> are high, it takes substantially longer for the kernel to realize
>>> that
>>> the path is non-functional, while other, good paths may be idle. I
>>> fail
>>> to see the benefit.
>>>
>>
>> I'm not sure everyone agrees with you on the meaning of
>> transitioning.
>>
>> If we go from non-optimized to optimized or standby to non-
>> opt/optimized
>> we don't want to try other paths because it can cause thrashing.
> 
> But only with explicit ALUA, or am I missing something? I agree that
> the host shouldn't initiate a PG switch if it encounters transitioning
> state. I also agree that for transitioning towards a "better" state,
> e.g. standby to (non)-optimized, failing the path would be
> questionable. Unfortunately we don't know in which "direction" the path
> is transitioning - it could be for 'better' or 'worse'. I suppose that
> in the case of a PG switch, it can happen that we dispatch I/O to a
> device that used to be in Standby and is now transitioning. Would it
> make sense to remember the previous state and "guess" what we're going
> to transition to? I.e. if the previous state was "Standby", it's
> probably going to be (non)optimized after the transition, and vice-
> versa?
> 
>>   We just
>> need to transition resources before we can fully use the path. It
>> could
>> be a local cache operation or for distributed targets it could be a
>> really
>> expensive operation.
>>
>> For both though, it can take longer than the retries we get from
>> scsi-ml.
> 
> So if we want to do "the right thing", we'd continue dispatching to the
> device until either the state changes or the device-reported transition
> timeout has expired?
> 
Not quite.
I think multipath should make the decision, and we shouldn't try to 
out-guess multipathing from the device driver.
We should only make the information available (to wit: the path state) 
for multipath to make the decision.
But if multipath decides to send I/O via a path which we _think_ it's in 
transitioning we shouldn't be arguing with that (ie we shouldn't preempt 
is from prep_fn) but rather let it rip; who knows, maybe there was a 
reason for that.

The only thing this patch changes (for any current setup) is that we'll 
incur additional round-trip times for I/O being sent in between the 
first I/O returning with 'transitioning' and multipath picking up the 
new path state. This I/O will be returned more-or-less immediately by 
the target, so really we're only having an additional round-trip latency 
for each I/O during that time. This is at most in the milliseconds 
range, so I guess we can live with that.

If, however, multipath fails to pick up the 'transitioning' state then 
this won't work, and we indeed will incur a regression. But that 
arguably is an issue with multipath ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
