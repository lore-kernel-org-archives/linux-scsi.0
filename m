Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C33C3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 06:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15CF520735
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 06:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgEDGN7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 02:13:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:42518 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgEDGN7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 May 2020 02:13:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 189DAACC3;
        Mon,  4 May 2020 06:14:00 +0000 (UTC)
Subject: Re: [PATCH RFC v3 01/41] scsi: add 'nr_reserved_cmds' field to the
 SCSI host template
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-2-hare@suse.de> <20200501174804.GE23795@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <337339b7-6f4a-a25c-f11c-7f701b42d6a8@suse.de>
Date:   Mon, 4 May 2020 08:13:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501174804.GE23795@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 7:48 PM, Christoph Hellwig wrote:
> On Thu, Apr 30, 2020 at 03:18:24PM +0200, Hannes Reinecke wrote:
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 47835c4b4ee0..5358f553f526 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1885,6 +1885,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>>   		shost->tag_set.ops = &scsi_mq_ops_no_commit;
>>   	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
>>   	shost->tag_set.queue_depth = shost->can_queue;
>> +	shost->tag_set.reserved_tags = shost->nr_reserved_cmds;
> 
> Insteda of just passing through the value I think we should remove
> them from can_queue here - as seen in the few patches the current
> behavior of summing both up seems to cause a fair amount of
> confusion.
> 
Yes, I would very much prefer that.

> Also I'd merge this with the patch to actually allocate reserved
> command, as that is one actual unit of useful functionality.
> 
Right, will do.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
