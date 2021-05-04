Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07BCAC433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 06:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB52260FEB
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 06:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhEDGP6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 02:15:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:42578 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229770AbhEDGP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 02:15:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2ADB6AE95;
        Tue,  4 May 2021 06:15:01 +0000 (UTC)
Subject: Re: [PATCH 07/18] scsi: revamp host device handling
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-8-hare@suse.de>
 <6bfedbcf-8698-f00c-838e-78a1c4a0059a@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8c7aa0b1-84a5-182b-9a87-2b830fc55ba0@suse.de>
Date:   Tue, 4 May 2021 08:15:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <6bfedbcf-8698-f00c-838e-78a1c4a0059a@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/21 5:06 AM, Bart Van Assche wrote:
> On 5/3/21 8:03 AM, Hannes Reinecke wrote:
>> + *	Attach a single scsi_device to the Scsi_Host. The primary aim
>> + *	for this device is to serve as a container from which valid
>> + *	scsi commands can be allocated from. Each scsi command will carry
>> + *	an unused/free command tag,
> 
> Shouldn't introducing this comment be deferred to the patch that
> actually reserves a tag for internal commands (this does not mean that
> I'm convinced that this is the right approach)?
> 
Will do.

>> + *   which then can be used by the LLDD to
>> + *	send internal or passthrough commands without having to find a
>> + *	valid command tag internally.
> 
> Please change "valid SCSI commands" into "internal SCSI commands".
> 
Okay.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
