Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D7CC4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 13:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02C3B216FD
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 13:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbgEANBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 09:01:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:52778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbgEANBV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 May 2020 09:01:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DD29DADAB;
        Fri,  1 May 2020 13:01:19 +0000 (UTC)
Subject: Re: [PATCH RFC v3 04/41] csiostor: use reserved command for LUN reset
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-5-hare@suse.de> <20200430151546.GB1005453@T590>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <cd0f88db-96ec-d69f-f33e-b10a1cb3756d@suse.de>
Date:   Fri, 1 May 2020 15:01:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430151546.GB1005453@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/30/20 5:15 PM, Ming Lei wrote:
> On Thu, Apr 30, 2020 at 03:18:27PM +0200, Hannes Reinecke wrote:
>> When issuing a LUN reset we should be using a reserved command
>> to avoid overwriting the original command.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>   drivers/scsi/csiostor/csio_init.c |  1 +
>>   drivers/scsi/csiostor/csio_scsi.c | 48 +++++++++++++++++++++++----------------
>>   2 files changed, 30 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
>> index 8dea7d53788a..5e1b0a24caf6 100644
>> --- a/drivers/scsi/csiostor/csio_init.c
>> +++ b/drivers/scsi/csiostor/csio_init.c
>> @@ -622,6 +622,7 @@ csio_shost_init(struct csio_hw *hw, struct device *dev,
>>   	ln->dev_num = (shost->host_no << 16);
>>   
>>   	shost->can_queue = CSIO_MAX_QUEUE;
>> +	shost->nr_reserved_cmds = 1;
> 
> ->can_queue isn't increased by 1 given CSIO_MAX_QUEUE isn't changed, so
> setting shost->nr_reserved_cmds as 1 will cause io queue depth reduced by 1,
> that is supposed to not happen.
> 
We cannot increase MAX_QUEUE arbitrarily as this is a compile time 
variable, which seems to relate to a hardware setting.

But I can see to update the reserved command functionality for allowing 
to fetch commands from the normal I/O tag pool; in the case of LUN reset 
it shouldn't make much of a difference as the all I/O is quiesced anyway.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
