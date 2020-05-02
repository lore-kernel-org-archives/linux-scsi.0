Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A416C3A5A9
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 12:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36A5F2137B
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 12:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgEBMWG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 08:22:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:40954 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgEBMWF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 May 2020 08:22:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0E510AA55;
        Sat,  2 May 2020 12:22:05 +0000 (UTC)
Subject: Re: [PATCH RFC v3 22/41] block: implement persistent commands
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-23-hare@suse.de> <20200501083337.GA1009055@T590>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2d297072-9ac7-b57a-bee2-2df651a32595@suse.de>
Date:   Sat, 2 May 2020 14:22:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501083337.GA1009055@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 10:33 AM, Ming Lei wrote:
> On Thu, Apr 30, 2020 at 03:18:45PM +0200, Hannes Reinecke wrote:
>> Some LLDDs implement event handling by sending a command to the
>> firmware, which then will be completed once the firmware wants
>> to register an event.
>> So worst case a command is being sent to the firmware then the
>> driver initializes, and will be returned once the driver unloads.
>> To avoid these commands to block the queues during freezing or
>> quiescing this patch implements support for 'persistent' commands,
>> which will be excluded from blk_queue_enter() and blk_queue_exit()
>> calls.
> 
> This way is quite dangerous from block layer viewpoint, and it should
> have been done in driver/device specific way instead of polluting block
> layer.
> 
As already outlined in the reply to Bart, I'll be rewriting that 
requiring the drivers to set aside a separate tag and decrease the 
tagspace by one.
That should work as well.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
