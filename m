Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E46C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 15:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A34A061409
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 15:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhD2Pwv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 11:52:51 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:53050 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbhD2Pwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Apr 2021 11:52:49 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 6F8B02EA7CB;
        Thu, 29 Apr 2021 11:52:02 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id VwPC7MtKpP8J; Thu, 29 Apr 2021 11:31:44 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 95C712EA7C7;
        Thu, 29 Apr 2021 11:52:01 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 40/40] scsi: drop obsolete linux-specific SCSI status
 codes
To:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <20210427083046.31620-1-hare@suse.de>
 <20210427083046.31620-41-hare@suse.de> <20210429064837.GA2882@lst.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <7dce03b0-0964-68c3-0c2f-b70449b1a98f@interlog.com>
Date:   Thu, 29 Apr 2021 11:52:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210429064837.GA2882@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-29 2:48 a.m., Christoph Hellwig wrote:
> On Tue, Apr 27, 2021 at 10:30:46AM +0200, Hannes Reinecke wrote:
>> +/*
>> + *  Original linux SCSI Status codes. They are shifted 1 bit right
>> + *  from those found in the SCSI standards.
>> + */
>> +
>> +#define GOOD                 0x00
>> +#define CHECK_CONDITION      0x01
>> +#define CONDITION_GOOD       0x02
>> +#define BUSY                 0x04
>> +#define INTERMEDIATE_GOOD    0x08
>> +#define INTERMEDIATE_C_GOOD  0x0a
>> +#define RESERVATION_CONFLICT 0x0c
>> +#define COMMAND_TERMINATED   0x11
>> +#define QUEUE_FULL           0x14
>> +#define ACA_ACTIVE           0x18
>> +#define TASK_ABORTED         0x20
> 
> I don't think there is any need to keep defining them, is there?

If you don't mind breaking existing, user space facing APIs, then
yes, they can be dropped ...

Banishing them to the sg header is correct IMO. Which is exactly
what this patch does.

One thought, they could be wrapped with:

#ifndef __KERNEL__
...
#endif

and repeated in a new header: scsi/sg_priv.h
Then the sg driver and any other files that need those old defines
could include sg_priv.h . The result would be parts of the kernel
not being polluted with commonly use names like GOOD and BUSY.


Anyway:

Reviewed-by: Douglas Gilbert <dgilbert@interlog.com>
