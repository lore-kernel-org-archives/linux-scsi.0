Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A96C07E99
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 13:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E81686141C
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 13:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhGENX0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 09:23:26 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:45228 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhGENXZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 09:23:25 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0EA7322A26;
        Mon,  5 Jul 2021 13:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625491248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mIVly2Qrkd/pklMXlBaJB7oFJ0jfhqeSXbqUG9Aen4c=;
        b=UeYCDtdU9AS+n1az1+oqhhff6kvy+gC8Tr3y3ZHqnrq1wgQiW8l21+DhO+OnD5TG6H8rll
        LOsjC3rlJ4qpZtU8UpLaYgH97UZzlcZmNexLOLWng5r+uqS2RBsvzQPmoA3I5ukd9gSqqK
        eTZbb5dWzErbctXzWkY1sAAvwC1Ox1A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625491248;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mIVly2Qrkd/pklMXlBaJB7oFJ0jfhqeSXbqUG9Aen4c=;
        b=K2Uap0+6dI/xjlR2Zk0KEwGqK66SkWRqIVgJY+LFyP5fQG6m6FIXIrLJAHz+vKPGEpC/h9
        YNgana9TW/DZu8CQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id C5E9113838;
        Mon,  5 Jul 2021 13:20:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id SNS/Li8H42DSLQAAGKfGzw
        (envelope-from <hare@suse.de>); Mon, 05 Jul 2021 13:20:47 +0000
Subject: Re: SCSI layer RPM deadlock debug suggestion
To:     Alan Stern <stern@rowland.harvard.edu>,
        John Garry <john.garry@huawei.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        Xiejianqin <xiejianqin@hisilicon.com>
References: <9e90d035-fac1-432a-1d34-de5805d8f799@huawei.com>
 <20210702203142.GA49307@rowland.harvard.edu>
 <ec4a3038-34b0-084f-a1bd-039827465dd1@acm.org>
 <1081c3ed-0762-58c7-8b99-8b3721c710bd@huawei.com>
 <20210705131712.GB116379@rowland.harvard.edu>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a5b9109c-cad6-0057-29c9-8974fda3347c@suse.de>
Date:   Mon, 5 Jul 2021 15:20:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210705131712.GB116379@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/5/21 3:17 PM, Alan Stern wrote:
> On Mon, Jul 05, 2021 at 01:00:39PM +0100, John Garry wrote:
>> On 05/07/2021 00:45, Bart Van Assche wrote:
>>
>> Hi Alan and Bart,
>>
>> Thanks for the suggestions.
>>
>>>>> Removing commit e27829dc92e5 ("scsi: serialize ->rescan against ->remove")
>>>>> solves this issue for me, but that is there for a reason.
>>>>>
>>>>> Any suggestion on how to fix this deadlock?
>>>> This is indeed a tricky question.  It seems like we should allow a
>>>> runtime resume to succeed if the only reason it failed was that the
>>>> device has been removed.
>>>>
>>>> More generally, perhaps we should always consider that a runtime
>>>> resume succeeds.  Any remaining problems will be dealt with by the
>>>> device's driver and subsystem once the device is marked as
>>>> runtime-active again.
>>>>
>>>> Suppose you try changing blk_post_runtime_resume() so that it always
>>>> calls blk_set_runtime_active() regardless of the value of err.  Does
>>>> that fix the problem?
>>>>
>>>> And more importantly, will it cause any other problems...?
>>> That would cause trouble for the UFS driver and other drivers for which
>>> runtime resume can fail due to e.g. the link between host and device
>>> being in a bad state.
> 
> I don't understand how that could work.  If a device fails to resume
> from runtime suspend, no matter whether the reason is temporary or
> permanent, how can the system use it again?
> 
> And if the system can't use it again, what harm is there in pretending
> that the runtime resume succeeded?
> 
'xactly.
Especially as we _do_ have error recovery on SCSI, so we should be 
treating a failure to resume just like any other SCSI error; in the end, 
we need to equip SCSI EH to deal with these kind of states anyway.
And we already do, as we're sending 'START STOP UNIT' already to spin up 
drives which are found to be spun down.

So I'm all for always returning 'success' from the 'resume' callback and 
let SCSI EH deal with any eventual fallout.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
