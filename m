Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750BCC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 17:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3167561456
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 17:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhD2R3o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 13:29:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:47760 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232991AbhD2R3n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Apr 2021 13:29:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 685F0B01E;
        Thu, 29 Apr 2021 17:28:55 +0000 (UTC)
Subject: Re: [PATCH 3/3] fnic: check for started requests in
 fnic_wq_copy_cleanup_handler()
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210429122517.39659-1-hare@suse.de>
 <20210429122517.39659-4-hare@suse.de> <YIrD87Ekh3xBqE6u@T590>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8c971d37-e1ae-246f-9b9a-8170c76276b1@suse.de>
Date:   Thu, 29 Apr 2021 19:28:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YIrD87Ekh3xBqE6u@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/29/21 4:34 PM, Ming Lei wrote:
> On Thu, Apr 29, 2021 at 02:25:17PM +0200, Hannes Reinecke wrote:
>> fnic_wq_copy_cleanup_handler() is using scsi_host_find_tag() to
>> map id to a scsi command. However, as per discussion on the mailinglist
>> scsi_host_find_tag() might return a non-started request, so we need
>> to check the returned command with blk_mq_request_started() to avoid
>> the function tripping over a non-initialized command.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/fnic/fnic_scsi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
>> index 762cc8bd2653..b9fd3d87416b 100644
>> --- a/drivers/scsi/fnic/fnic_scsi.c
>> +++ b/drivers/scsi/fnic/fnic_scsi.c
>> @@ -1466,7 +1466,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
>>   		return;
>>   
>>   	sc = scsi_host_find_tag(fnic->lport->host, id);
>> -	if (!sc)
>> +	if (!sc || !blk_mq_request_started(sc->request))
>>   		return;
> 
> scsi_host_find_tag() has covered blk_mq_request_started check already, so
> this patch isn't necessary.
> 
Right. So drop it, then.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
