Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1EBC4707F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 15:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF74661008
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 15:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhE0Pon (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 11:44:43 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57018 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbhE0Pom (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 11:44:42 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9FD5F2190B;
        Thu, 27 May 2021 15:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622130188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qlZUb+MNha7cILwfhEpB7Shyht0UjhxAnu57xkehAmk=;
        b=RhIrb/Gy5USO+nph72z8cbnHHyRA3fIeiUmRjVOeh2AQqIxyzvaG//6hB/q/NM/rqtdhDa
        GXXy5BkMPJgseMYy5BYqZQ1roUd0kMJfmQ8obkkpfyolHdkpn5dun6cJZWBioVeWXQPNr/
        DpeYxZQSwwyFt7JDZCwv0CF9t2lClF4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622130188;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qlZUb+MNha7cILwfhEpB7Shyht0UjhxAnu57xkehAmk=;
        b=HCsMN2MwYBIPFohnWD/VntiCDUHl0KuVLVB1bbZD5mX6Sufff5Je7oxEbQVJFKO+exe8Nv
        rFPJzk0X0KdF6bBw==
Received: from director2.suse.de (director2.suse-dmz.suse.de [192.168.254.72])
        by imap.suse.de (Postfix) with ESMTPSA id 80D4711A98;
        Thu, 27 May 2021 15:43:08 +0000 (UTC)
Subject: Re: REQ_HIPRI and SCSI mid-level
To:     dgilbert@interlog.com, linux-scsi <linux-scsi@vger.kernel.org>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
References: <8c490b4a-aac0-7451-8755-e05bb3ee3d32@interlog.com>
 <7cd246bd-646c-6833-b3a6-a25222bed647@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f27b9759-571a-d9d1-ef88-c76fe45dcce4@suse.de>
Date:   Thu, 27 May 2021 17:43:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <7cd246bd-646c-6833-b3a6-a25222bed647@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/25/21 6:03 PM, Douglas Gilbert wrote:
> On 2021-05-21 5:56 p.m., Douglas Gilbert wrote:
>> The REQ_HIPRI flag on requests is associated with blk_poll() (aka iopoll)
>> and assumes the user space (or some higher level) will be calling
>> blk_poll() on requests marked with REQ_HIPRI and that will lead to their
>> completion.
>>
>> In lk 5.13-rc1 the megaraid and scsi_debug LLDs support blk_poll() [seen
>> by searching for 'mq_poll'] with more to follow, I assume. I have tested
>> blk_poll() on the scsi_debug driver using both fio and the new sg driver.
>> It works well with one caveat: as long as there isn't an error.
>> After fighting with that error processing from the ULD side (i.e. the
>> new sg driver) and the LLD side I am concluding that the glue that
>> holds them together, that is, the mid-level is not as REQ_HIPRI aware
>> as it should be.
>>
>> Yes REQ_HIPRI is there in scsi_lib.c but it is missing from scsi_error.c
>> How can scsi_error.c re-issue requests _without_ taking into account
>> that the original was issued with REQ_HIPRI ? Well I don't know but I'm
>> pretty sure that is close to the area that I see causing problems
>> (mainly lockups).
>>
>> As an example the scsi_debug driver has an in-use bitmap that when a new
>> request arrives the code looks for an empty slot. Due to (incorrect)
>> parameter setup that may fail. If the driver returns:
>>      device_qfull_result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
>> then I see lock-ups if the request in question has REQ_HIPRI set.
>>
>> If that is changed to:
>>      device_qfull_result = (DID_ABORT << 16) | SAM_STAT_TASK_SET_FULL;
>> then my user space test program sees that error and aborts showing the
>> TASK SET FULL SCSI status. That is much better than a lockup ...
>>
That's because with the first result the command is requeued (due to 
DID_OK), whereas in the latter result the command is aborted (due to 
DID_ABORT).

So the question really is whether we should retry the commands which 
have REQ_HIPRI set, or whether we shouldn't rather complete them with 
appropriate error code.
A bit like enhanced BLOCK_PC requests, if you will.

>> Having played around with variants of the above for a few weeks, I'd
>> like to throw this problem into the open :-)
>>
>>
>> Suggestion: perhaps the eh could give up immediately on any request
>> with REQ_HIPRI set (i.e. make it a higher level layer's problem).

Like I said above: it's not only scsi EH which would need to be 
modified, but possibly also the result evaluation in 
scsi_decide_disposition(); it's questionable whether a HIPRI command 
should be requeued at all.

But this might even affect the NVMe folks; they do return commands with 
BLK_STS_RESOURCE, too.

Maybe we should open a larger discussion on the block list.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
