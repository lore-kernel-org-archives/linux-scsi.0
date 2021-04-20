Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDAC9C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 06:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC028613B0
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 06:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhDTGF1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 02:05:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:45560 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhDTGF1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 02:05:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 731A0AD80;
        Tue, 20 Apr 2021 06:04:55 +0000 (UTC)
Subject: Re: [PATCH 000/117] Make better use of static type checking
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210420000845.25873-1-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7eaf77e8-ca4f-c0db-e94a-5fa3e16e3b51@suse.de>
Date:   Tue, 20 Apr 2021 08:04:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/21 2:06 AM, Bart Van Assche wrote:
> 
> Hi Martin,
> 
> This patch series improves static checking inside the SCSI subsystem as
> follows:
> - Introduce enumeration types for the SCSI status, message, host and driver
>    bytes.
> - Change 'int' into 'union scsi_status' in case of SCSI results. This helps
>    the compiler and humans to tell the difference between a scalar and a SCSI
>    result.
> 
> This patch series is long because it touches all SCSI drivers and because it
> has been split into one patch per SCSI driver.
> 
> This patch series introduces a backwards-incompatible change in the API
> between SCSI core and drivers. A possible strategy is to postpone the patch
> that removes backwards compatibility to a later kernel version.
> 
> Please consider this patch series for kernel version v5.14.
> 
I'd rather not go this way.
We should not try to preserve the split SCSI result value with its four 
distinct fields.

I'd rather have the message byte handling moved into the SCSI parallel 
drivers (where really it should've been in the first place).
The driver byte can go entirely as the DRIVER_SENSE flag can be replaced
with a check for valid sense code, DRIVER_TIMEOUT is pretty much 
identical to DID_TIMEOUT (with the semantic difference _who_ set the 
timeout), and DRIVER_ERROR can be folded back into the caller.
All other values are unused, allowing us to drop driver error completely.

With that we're only having two fields (host byte and status byte) left,
which should be treated as two distinct values.

As it so happens I do have a patchset for this; guess I'll be posting it 
to demonstrate the idea.

Bart, I would very much prefer if we could work on this together so as 
to avoid duplicate work.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
