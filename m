Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B640CC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A60B61422
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243585AbhDUUIe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 16:08:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:34440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242586AbhDUUId (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 16:08:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0FB69AFF3;
        Wed, 21 Apr 2021 20:07:59 +0000 (UTC)
Subject: Re: [PATCH 07/42] scsi: Kill DRIVER_SENSE
To:     dgilbert@interlog.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-8-hare@suse.de>
 <d3748963-a903-61f5-04fc-64a2f7f533b4@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9b88d147-e68c-2d40-365a-c930c03bb50e@suse.de>
Date:   Wed, 21 Apr 2021 22:07:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <d3748963-a903-61f5-04fc-64a2f7f533b4@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 9:46 PM, Douglas Gilbert wrote:
> On 2021-04-21 1:47 p.m., Hannes Reinecke wrote:
>> Replace the check for DRIVER_SENSE with a check for
>> SAM_STAT_CHECK_CONDITION and audit all callsites to
>> ensure the SAM status is set correctly.
>> For backwards compability move the DRIVER_SENSE definition
>> to sg.h, and update the sg driver to set the DRIVER_SENSE
>> driver_status whenever SAM_STAT_CHECK_CONDITION is present.
> 
> I may have missed it but you probably want to do the same
> backwards compatibility DRIVER_SENSE trick for the
> ioctl(SG_IO) implemented in block/scsi_ioctl.c . That way
> DRIVER_SENSE will appear in the sg_io_hdr::driver_status byte
> when check_condition_sense are set for both these cases:
>      ioctl(sd_fd, SG_IO, &a_sg_v3_obj)
>      ioctl(sg_fd, SG_IO, &a_sg_v3_obj)
> 
> And for bsg which uses sg_io_v4 for SCSI commands you set
> sg_io_v4::driver_status = 0
> in all cases. If check_condition and sense are active, why
> not set DRIVER_SENSE for consistency. block/scsi_ioctl.c
> includes scsi/sg.h so the DRIVER_SENSE define is visible.
> 
Oh, indeed; I've forgotten it. Will be including it with the
next round.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
