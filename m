Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 770E1C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 06:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 531FF613B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 06:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhEDGTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 02:19:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:43606 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229825AbhEDGTg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 02:19:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 407A4AE95;
        Tue,  4 May 2021 06:18:41 +0000 (UTC)
Subject: Re: [PATCH 16/18] aacraid: store target id in host_scribble
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-17-hare@suse.de>
 <28955e68-9fbe-72bd-090b-85e0ecebda84@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9475d305-3519-5ce5-c67c-25670a52cb87@suse.de>
Date:   Tue, 4 May 2021 08:18:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <28955e68-9fbe-72bd-090b-85e0ecebda84@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/21 5:22 AM, Bart Van Assche wrote:
> On 5/3/21 8:03 AM, Hannes Reinecke wrote:
>> The probe_container mechanism requires a target id to be present,
>> even if the device itself isn't present (yet).
>> As we're now allocating internal commands the target id of the
>> device is immutable, so store the requested target id in the
>> host_scribble field.
> 
> A more elegant solution is probably to introduce private data per SCSI
> command and to set the .cmd_size member in the SCSI host template. I'd
> like to get rid of the host_scribble field because it makes the SCSI
> command data structure larger than necessary for SCSI LLDs that don't
> use 'host_scribble'.
> 
Ah. Good idea, both with using the .cmd_size and removing the 
host_scribble field.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
