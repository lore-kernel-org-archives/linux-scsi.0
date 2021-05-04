Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6C3C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 13:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 281FD611AE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 13:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhEDNLh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 09:11:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:50254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230414AbhEDNLg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 09:11:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0FDD2AE00;
        Tue,  4 May 2021 13:10:41 +0000 (UTC)
Subject: Re: [PATCH 07/18] scsi: revamp host device handling
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-8-hare@suse.de> <20210504095920.GE25986@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <55918d68-7385-0153-0bd9-d822d3ce4c21@suse.de>
Date:   Tue, 4 May 2021 15:10:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210504095920.GE25986@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/21 11:59 AM, Christoph Hellwig wrote:
> So right now scsi_get_host_dev/scsi_free_host_dev is entirely unused.
> 
> І'd rather just kill them off rather than giving them a new life and
> hacking all over the core code for them.
> 
> What do you need the scsi_device for instead of just having a
> request_queue for comands to the controller?  If we need a scsi_device
> can we somehow make sure it doesn't hit the scanning and sysfs code
> from a much higher level?
> 
That is what I did in v2, and got the response:

 > That was just a question on why virtio uses the per-device tags, which
 > didn't look like it made any sense.  What I'm worried about here is
 > mixing up the concept of reserved tags in the tagset, and queues to
 > use them.  Note that we already have the scsi_get_host_dev to allocate
 > a scsi_device and thus a request_queue for the host itself.  That
 > seems like the better interface to use a tag for a host wide command
 > vs introducing a parallel path.

(To be found at 
https://lore.kernel.org/linux-scsi/20200311062228.GA13522@infradead.org/ 
if you are curious.)

So do you retract on that statement?
Or did I misinterpret something there?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
