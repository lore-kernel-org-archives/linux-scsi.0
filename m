Return-Path: <SRS0=78fV=5C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D92C10F29
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 09:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 789A520719
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 09:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgCQJsw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Mar 2020 05:48:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:55052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgCQJsw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Mar 2020 05:48:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7006AAC23;
        Tue, 17 Mar 2020 09:48:49 +0000 (UTC)
Subject: Re: [PATCH RFC v2 12/24] hpsa: use reserved commands
To:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        bvanassche@acm.org, hch@infradead.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        Hannes Reinecke <hare@suse.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
 <1583857550-12049-13-git-send-email-john.garry@huawei.com>
 <20200311081059.GC31504@ming.t460p>
 <a76ab13a-85a3-0d88-595f-af13ef1b3fe3@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <881b6a9b-2137-946f-a900-5c4e6cf1fe37@suse.de>
Date:   Tue, 17 Mar 2020 10:48:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a76ab13a-85a3-0d88-595f-af13ef1b3fe3@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/17/20 10:38 AM, John Garry wrote:
> On 11/03/2020 08:10, Ming Lei wrote:
>>> ands(struct ctlr_info *h)
>>> @@ -5803,6 +5803,7 @@ static int hpsa_scsi_host_alloc(struct 
>>> ctlr_info *h)
>>>       sh->max_lun = HPSA_MAX_LUN;
>>>       sh->max_id = HPSA_MAX_LUN;
>>>       sh->can_queue = h->nr_cmds - HPSA_NRESERVED_CMDS;
>>> +    sh->nr_reserved_cmds = HPSA_NRESERVED_CMDS;
>> Now .nr_reserved_cmds has been passed to blk-mq, you need to increase
>> sh->can_queue to h->nr_cmds, because .can_queue is the whole queue depth
>> (include the part of reserved tags), otherwise, IO tags will be
>> decreased.
>>
> 
> Sounds correct.
> 
I will have having a look at the patchset; I thought I did a patch to 
modify .can_queue so that it would cover only the usable tags, not the 
reserved ones.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
