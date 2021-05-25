Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0B3C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 16:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F27A66140A
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 16:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbhEYQEu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 12:04:50 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:41346 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbhEYQEt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 12:04:49 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 281812EA1D1;
        Tue, 25 May 2021 12:03:18 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id SgckRW0CEjvH; Tue, 25 May 2021 11:41:16 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 3D11F2EA188;
        Tue, 25 May 2021 12:03:16 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: REQ_HIPRI and SCSI mid-level
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi <linux-scsi@vger.kernel.org>
Cc:     Hannes Reinecke <hare@suse.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
References: <8c490b4a-aac0-7451-8755-e05bb3ee3d32@interlog.com>
Message-ID: <7cd246bd-646c-6833-b3a6-a25222bed647@interlog.com>
Date:   Tue, 25 May 2021 12:03:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8c490b4a-aac0-7451-8755-e05bb3ee3d32@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-05-21 5:56 p.m., Douglas Gilbert wrote:
> The REQ_HIPRI flag on requests is associated with blk_poll() (aka iopoll)
> and assumes the user space (or some higher level) will be calling
> blk_poll() on requests marked with REQ_HIPRI and that will lead to their
> completion.
> 
> In lk 5.13-rc1 the megaraid and scsi_debug LLDs support blk_poll() [seen
> by searching for 'mq_poll'] with more to follow, I assume. I have tested
> blk_poll() on the scsi_debug driver using both fio and the new sg driver.
> It works well with one caveat: as long as there isn't an error.
> After fighting with that error processing from the ULD side (i.e. the
> new sg driver) and the LLD side I am concluding that the glue that
> holds them together, that is, the mid-level is not as REQ_HIPRI aware
> as it should be.
> 
> Yes REQ_HIPRI is there in scsi_lib.c but it is missing from scsi_error.c
> How can scsi_error.c re-issue requests _without_ taking into account
> that the original was issued with REQ_HIPRI ? Well I don't know but I'm
> pretty sure that is close to the area that I see causing problems
> (mainly lockups).
> 
> As an example the scsi_debug driver has an in-use bitmap that when a new
> request arrives the code looks for an empty slot. Due to (incorrect)
> parameter setup that may fail. If the driver returns:
>      device_qfull_result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
> then I see lock-ups if the request in question has REQ_HIPRI set.
> 
> If that is changed to:
>      device_qfull_result = (DID_ABORT << 16) | SAM_STAT_TASK_SET_FULL;
> then my user space test program sees that error and aborts showing the
> TASK SET FULL SCSI status. That is much better than a lockup ...
> 
> Having played around with variants of the above for a few weeks, I'd
> like to throw this problem into the open :-)
> 
> 
> Suggestion: perhaps the eh could give up immediately on any request
> with REQ_HIPRI set (i.e. make it a higher level layer's problem).

Hmmm, no response. Any LLD that decides to support blk_poll() and
relies on the mid-level eh handling will get burnt by this. And those
LLDs that do their own eh handling needs to take care not to replicate
the mid-level's eh handling in this case.

An even simpler approach for the mid-level eh handling to address
(at least partially) this problem, is to do:
    rqq->cmd_flags &= ~REQ_HIPRI;

on retried requests. Clearing the REQ_HIPRI flag, if present, should
make the LLD behave the way the mid-level eh processing expects.

Doug Gilbert


