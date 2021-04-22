Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42444C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 08:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B77C6142F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 08:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbhDVIt4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 04:49:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:45372 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235686AbhDVIt4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Apr 2021 04:49:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E5156B04F;
        Thu, 22 Apr 2021 08:49:20 +0000 (UTC)
Subject: Re: [RFC PATCH 00/42] SCSI result cleanup, part 2
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <d1f52383-8435-276c-b69a-39edca853ee2@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6e79ed8c-f8bc-8f59-f1e1-82a9d734bcb4@suse.de>
Date:   Thu, 22 Apr 2021 10:49:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <d1f52383-8435-276c-b69a-39edca853ee2@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/21 12:26 AM, Bart Van Assche wrote:
> On 4/21/21 10:47 AM, Hannes Reinecke wrote:
>> My plan here is move every driver to use accessors for the
>> remaining bytes in the SCSI result, and with that move the
>> SCSI result over into two separate values.
> 
> This patch series modifies scsi_execute() such that it either returns a 
> negative Unix error code or a positive SCSI status value that includes 
> the host byte and status byte. I think that a union is a good way to 
> model such return values. I'd like to use something similar to the 
> scsi_status union from my patch series to model such return values. I 
> think that union is also appropriate as a replacement for the 'result' 
> member of struct scsi_cmnd.
> 
And that was precisely the point of my patchset: do _not_ use driver 
byte nor message byte in the SCSI midlayer.
So the midlayer can be reduced to handling just the host byte and the 
status byte. Whether this is by means of a union or something else 
doesn't really matter; this patchset doesn't prevent any of this from 
happening.

I'm open to discussion on whether we need to expose the original driver 
byte to userspace; I've already attempted to do this for DRIVER_SENSE, 
and if needs be DRIVER_ERROR can be fudged in, too.
But I do think that message byte handling should be killed from the 
midlayer, as it really is SCSI parallel specific and shouldn't be 
exposed to the midlayer at all.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
