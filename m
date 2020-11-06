Return-Path: <SRS0=4aQo=EM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE29C2D0A3
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 07:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC603208FE
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 07:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgKFHXM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Nov 2020 02:23:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:46916 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgKFHXM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Nov 2020 02:23:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 99A77ABAE;
        Fri,  6 Nov 2020 07:23:10 +0000 (UTC)
Subject: Re: [PATCH v6 3/4] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
To:     Mike Christie <michael.christie@oracle.com>,
        Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1604556596-27228-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604556596-27228-4-git-send-email-muneendra.kumar@broadcom.com>
 <e575da88-8b40-3062-9835-419456b46989@oracle.com>
 <08d150e63f2b79cd0199fb49355ce601@mail.gmail.com>
 <eed1c6b0-1b9c-572c-a9f6-8468a6996491@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e1e877f3-78d1-3038-32a5-d08af5ec7dde@suse.de>
Date:   Fri, 6 Nov 2020 08:23:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <eed1c6b0-1b9c-572c-a9f6-8468a6996491@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/20 8:15 PM, Mike Christie wrote:
> On 11/5/20 11:27 AM, Muneendra Kumar M wrote:
>> Hi Mike,
>> Thanks for the input.
>> Below are my replies.
>>
>>
>>> Hey sorry for the late reply. I was trying to test some things out but am
>>> not sure if all drivers work the same.
>>
>>> For the code above, what will happen if we have passed that check in the
>>> driver, then the driver does the report del and add sequence? Let's say
>>> it's initially calling the abort callout, and we passed that check, we then
>>> do the >del/add seqeuence, what will happen next? Do the fc drivers return
>>> success or failure for the abort call. What happens for the other callouts
>>> too?
>>
>>> If failure, then the eh escalates and when we call the next callout, and we
>>> hit the check above and will clear it, so we are ok.
>>
>> If success then we would not get a chance to clear it right?
>> [Muneendra]Agreed. So what about clearing the flags in fc_remote_port_del. I
>> think this should address all the concerns?
>>
>>> If this is the case, then I think you need to instead go the route where
>>> you add the eh cmd completion/decide_disposition callout. You would call
>>> it in scmd_eh_abort_handler, scsi_eh_bus_device_reset, etc when we are
>>> deciding if we want to retry/fail the command.
>> [Muneendra]Sorry I didn't get what you are saying could you please elaborate
>> on the same.
>>
>> In this approach you do not need the eh_timed_out changes, since we only
>> seem to care about the port state after the eh callout has completed.
>> [Muneendra]what about setting the SCMD_NORETRIES_ABORT bit?
>>
> 
> I don't think you need it. It sounds like we only care about the port state
> when the cmd is completing. For example we have:
> 
> 1. the case where the cmd times out, we do aborts/resets, then the
> port state goes into marginal, then the aborts/resets complete. We want to
> fail the cmds without retries.
> 
> 2. If the port state is in marginal, the cmd times out, we do the aborts/resets
> and when we are done if the port state is still marginal we want to fail the
> cmd without retries.
> 
> 3. If the port state is marginal (or any value), before or after the cmd
> initially times out, but the port state goes back to online, then when the
> aborts/resets complete we want to retry the cmd.
> 
Actually, I don't think the third case can (or should) happen.
A transition from marginal to online should always include a link bounce 
(ie a rport_del/rport_add sequence), which would cancel all outstanding 
commands anyway.
And if we have the above provision we could clear the flag in 
rport_del() and everything would be dandy.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
