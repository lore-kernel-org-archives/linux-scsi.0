Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B388BC47247
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 14:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F1282074A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 14:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgD3OsT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 10:48:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:57840 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgD3OsT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 10:48:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3EF96AC69;
        Thu, 30 Apr 2020 14:48:17 +0000 (UTC)
Subject: Re: [PATCH RFC v3 01/41] scsi: add 'nr_reserved_cmds' field to the
 SCSI host template
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-2-hare@suse.de>
 <9655eb3f-b2e3-7c9e-f2ee-1587c13df875@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c748afd2-e2d9-f53d-b733-5cc010ef8d74@suse.de>
Date:   Thu, 30 Apr 2020 16:48:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <9655eb3f-b2e3-7c9e-f2ee-1587c13df875@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/30/20 4:15 PM, John Garry wrote:
> On 30/04/2020 14:18, Hannes Reinecke wrote:
>> From: Hannes Reinecke <hare@suse.com>
>>
>> Quite a lot of drivers are using management commands internally, which
>> typically use the same hardware tag pool (ie they are being allocated
>> from the same hardware resources) as the 'normal' I/O commands.
>> These commands are set aside before allocating the block-mq tag bitmap,
>> so they'll never show up as busy in the tag map.
>> The block-layer, OTOH, already has 'reserved_tags' to handle precisely
>> this situation.
>> So this patch adds a new field 'nr_reserved_cmds' to the SCSI host
>> template to instruct the block layer to set aside a tag space for these
>> management commands by using reserved_tags.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
> 
> It may be worth adding this field to scsi_host_template. And we should 
> also prob mention this in Documentation/scsi/scsi_mid_low_api.txt
> 
Right, indeed, will be doing so.
Haven't done it as long as this is still an RFC; guess when we'll get 
the SAS bits sorted (hint, hint :-) and no further objections are coming 
wrt the overall design I'll be sending out a 'real' patchset with the
documentation bits sorted, too.

> Apart from that, thanks:
> 
> Reviewed-by: John Garry <john.garry@huawei.com>
> Thanks for the review!

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
