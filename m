Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB76C2BA2B
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 14:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E1FE20747
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 14:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgDGOpJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 10:45:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:34472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728943AbgDGOpI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Apr 2020 10:45:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8583BAB64;
        Tue,  7 Apr 2020 14:45:05 +0000 (UTC)
Subject: Re: [PATCH RFC v2 02/24] scsi: allocate separate queue for reserved
 commands
To:     John Garry <john.garry@huawei.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        ming.lei@redhat.com, bvanassche@acm.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        Hannes Reinecke <hare@suse.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
 <1583857550-12049-3-git-send-email-john.garry@huawei.com>
 <20200310183243.GA14549@infradead.org>
 <79cf4341-f2a2-dcc9-be0d-2efc6e83028a@huawei.com>
 <20200311062228.GA13522@infradead.org>
 <b5a63725-722b-8ccd-3867-6db192a248a4@suse.de>
 <9c6ced82-b3f1-9724-b85e-d58827f1a4a4@huawei.com>
 <39bc2d82-2676-e329-5d32-8acb99b0a204@suse.de>
 <20ebe296-9e57-b3e3-21b3-63a09ce86036@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <dcfba0ea-4ba5-4e4f-150d-24bd4fe11cdd@suse.de>
Date:   Tue, 7 Apr 2020 16:45:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20ebe296-9e57-b3e3-21b3-63a09ce86036@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/20 4:35 PM, John Garry wrote:
> On 07/04/2020 15:00, Hannes Reinecke wrote:
>> On 4/7/20 1:54 PM, John Garry wrote:
>>> On 06/04/2020 10:05, Hannes Reinecke wrote:
[ .. ]
>>>> This would be okay if 'this_id' would have been defined by the driver;
>>>> sadly, most drivers which are affected here do set 'this_id' to -1.
>>>> So we wouldn't have a nice target ID to allocate the device from, let
>>>> alone the problem that we would have to emulate a complete scsi device
>>>> with all required minimal command support etc.
>>>> And I'm not quite sure how well that would play with the exising SCSI
>>>> host template; the device we'll be allocating would have basically
>>>> nothing in common with the 'normal' SCSI devices.
>>>>
>>>> What we could do, though, is to try it the other way round:
>>>> Lift the request queue from scsi_get_host_dev() into the scsi host
>>>> itself, so that scsi_get_host_dev() can use that queue, but we also
>>>> would be able to use it without a SCSI device attached.
>>>
>>> wouldn't that limit 1x scsi device per host, not that I know if any 
>>> more would ever be required? But it does still seem better to use the 
>>> request queue in the scsi device.
>>>
>> My concern is this:
>>
>> struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
>> {
>>      [ .. ]
>>      starget = scsi_alloc_target(&shost->shost_gendev, 0, 
>> shost->this_id);
>>      [ .. ]
>>
>> and we have typically:
>>
>> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: .this_id                = -1,
>>
>> It's _very_ uncommon to have a negative number as the SCSI target 
>> device; in fact, it _is_ an unsigned int already.
>>
> 
> FWIW, the only other driver (gdth) which I see uses this API has this_id 
> = -1 in the scsi host template.
> 
>> But alright, I'll give it a go; let's see what I'll end up with.
> 
> note: If we want a fixed scsi_device per host, calling 
> scsi_mq_setup_tags() -> scsi_get_host_dev() will fail as shost state is 
> not running. Maybe we need to juggle some things there to provide a 
> generic solution.
> 
It might even get worse, as during device setup things like 
'slave_alloc' etc is getting called, which has a fair chance of getting 
confused for non-existing devices.
Cf qla2xxx:qla2xx_slave_alloc() is calling starget_to_rport(), which 
will get us a nice oops when accessing a target which is _not_ the child 
of a fc remote port.
And this is why I'm not utterly keen on this approach; auditing all 
these callbacks is _not_ fun.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
