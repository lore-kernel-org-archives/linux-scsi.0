Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1F6C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 06:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77AC622283
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 06:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391888AbgJTGD6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 02:03:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:34958 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729721AbgJTGD5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 02:03:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D2376ACB5;
        Tue, 20 Oct 2020 06:03:55 +0000 (UTC)
Subject: Re: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
To:     Mike Christie <michael.christie@oracle.com>,
        Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-6-git-send-email-muneendra.kumar@broadcom.com>
 <5ca752c2-94e1-444a-7755-f48b09b38577@oracle.com>
 <c3d65f732be0b73e4d4ebb742bc754cd@mail.gmail.com>
 <3803E6D0-68D6-407F-80AB-A17E7E0E69E3@oracle.com>
 <CE70AE32-4318-4FB2-AEED-3606DEF59B79@oracle.com>
 <a9b958fb-3c06-c385-f7ce-ce0fc863e64b@suse.de>
 <bf347ae232d73c4a21af6514085a92f2@mail.gmail.com>
 <8c59834c-e46c-fde3-13d7-b60a82452148@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a0cd119c-010d-62a4-13cf-e405d8ae5e43@suse.de>
Date:   Tue, 20 Oct 2020 08:03:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <8c59834c-e46c-fde3-13d7-b60a82452148@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/20 8:55 PM, Mike Christie wrote:
> On 10/19/20 12:31 PM, Muneendra Kumar M wrote:
>> Hi Michael,
>>
>>
>>>
>>>
>>> Oh yeah, to be clear I meant why try to send it on the marginal path
>>> when you are setting up the path groups so they are not used and only 
>>> the
>>> optimal paths are used.
>>> When the driver/scsi layer fails the IO then the multipath layer will
>>> make sure it goes on a optimal path right so you do not have to worry
>>> about hitting a cmd timeout and firing off the scsi eh.
>>>
>>> However, one other question I had though, is are you setting up
>>> multipathd so the marginal paths are used if the optimal ones were to
>>> fail (like the optimal paths hit a link down, dev_loss_tmo or
>>> fast_io_fail fires, etc) or will they be treated like failed paths?
>>>
>>> So could you end up with 3 groups:
>>>
>>> 1. Active optimal paths
>>> 2. Marginal
>>> 3. failed
>>>
>>> If the paths in 1 move to 3, then does multipathd handle it like a all
>>> paths down or does multipathd switch to #2?
>>>
>>> Actually, marginal path work similar to the ALUA non-optimized state.
>>> Yes, the system can sent I/O to it, but it'd be preferable for the 
>>> I/O to
>>> be moved somewhere else.
>>> If there is no other path (or no better path), yeah, tough.
>>
>>> Hence the answer would be 2)
>>
>>
>> [Muneendra]As Hannes mentioned if there are no active paths, the marginal
>> paths will be moved to normal and the system will send the io.
> What do you mean by normal?
> 
> - You don't mean the the fc remote port state will change to online right?
> 
> - Do you just mean the the marginal path group will become the active 
> group in the dm-multipath layer?

Actually, the latter is what I had in mind.

The paths should stay in 'marginal' until some admin interaction did 
take place.
That would be either a link reset (ie the fabric has been rescanned due 
to an RSCN event), or an admin resetting the state to 'normal' manually.
The daemons should never be moving the port out of 'marginal'.

So it really just influences the path grouping in multipathd, and 
multipath should switch to the marginal path group if all running paths 
are gone.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
