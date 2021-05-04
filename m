Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA930C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 12:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8CC1613BA
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 12:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhEDMyp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 08:54:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:37734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230363AbhEDMyp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 08:54:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0D97DACFD;
        Tue,  4 May 2021 12:53:50 +0000 (UTC)
Subject: Re: [PATCH 02/18] fnic: use scsi_host_busy_iter() to traverse
 commands
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-3-hare@suse.de> <20210504095052.GB25986@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <124ba43b-e788-55df-a9b2-8250224c5305@suse.de>
Date:   Tue, 4 May 2021 14:53:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210504095052.GB25986@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/21 11:50 AM, Christoph Hellwig wrote:
> On Mon, May 03, 2021 at 05:03:17PM +0200, Hannes Reinecke wrote:
>> Use scsi_host_busy_iter() to traverse commands instead of
>> hand-crafted routines walking the command list.
> 
> While the replacement looks like the right thing to do at the micro level,
> can we take one step back?
> 
> Shouldn't completing commands be left entirely to the SCSI EH code
> instead of messing with it in the driver?
> 
Not sure if that'd be easily possible.

Most drivers operate under the assumption that upon return from
eh_device_reset_handler() all commands for that device (except for the 
reset command itself and the command inducing the reset) will have to be 
aborted or completed.
As the call is synchronous, the LLDDs have to _wait_ for completion to 
happen (which, incidentally, is the cause for most of the issues we're 
having with SCSI EH...), and only then can they return from the callback.

So I can't see how we could delegate this to SCSI EH, as this would mean 
a break with the current behaviour.

Mind you, I would _love_ to be able to do an asynchronous device reset, 
seeing that we had _really_ good experience with the asynchronous 
command abort, but that will be an incompatible change.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
