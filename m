Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FB5C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 17:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 316DB222B8
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 17:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbgJSRQY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 13:16:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:45910 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730498AbgJSRQY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 13:16:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0AAC6AD76;
        Mon, 19 Oct 2020 17:16:23 +0000 (UTC)
Subject: Re: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
To:     Michael Christie <michael.christie@oracle.com>,
        Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-6-git-send-email-muneendra.kumar@broadcom.com>
 <5ca752c2-94e1-444a-7755-f48b09b38577@oracle.com>
 <c3d65f732be0b73e4d4ebb742bc754cd@mail.gmail.com>
 <3803E6D0-68D6-407F-80AB-A17E7E0E69E3@oracle.com>
 <CE70AE32-4318-4FB2-AEED-3606DEF59B79@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a9b958fb-3c06-c385-f7ce-ce0fc863e64b@suse.de>
Date:   Mon, 19 Oct 2020 19:16:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CE70AE32-4318-4FB2-AEED-3606DEF59B79@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/20 6:19 PM, Michael Christie wrote:
> 
> 
>> On Oct 19, 2020, at 11:10 AM, Michael Christie <michael.christie@oracle.com> wrote:
>>
>>
>> So it’s not clear to me if you know the path is not optimal and might hit
>> a timeout, and you are not going to use it once the existing IO completes why
>> even try to send it? I mean in this setup, new commands that are entering
>> the dm-multipath layer will not be sent to these marginal paths right?
> 
> 
> Oh yeah, to be clear I meant why try to send it on the marginal path when you are
> setting up the path groups so they are not used and only the optimal paths are used.
> When the driver/scsi layer fails the IO then the multipath layer will make sure it
> goes on a optimal path right so you do not have to worry about hitting a cmd timeout
> and firing off the scsi eh.
> 
> However, one other question I had though, is are you setting up multipathd so the
> marginal paths are used if the optimal ones were to fail (like the optimal paths hit a
> link down, dev_loss_tmo or fast_io_fail fires, etc) or will they be treated
> like failed paths?
> 
> So could you end up with 3 groups:
> 
> 1. Active optimal paths
> 2. Marginal
> 3. failed
> 
> If the paths in 1 move to 3, then does multipathd handle it like a all paths down
> or does multipathd switch to #2?
> 
Actually, marginal path work similar to the ALUA non-optimized state.
Yes, the system can sent I/O to it, but it'd be preferable for the I/O 
to be moved somewhere else.
If there is no other path (or no better path), yeah, tough.

Hence the answer would be 2)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
