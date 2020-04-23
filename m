Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54BCAC55186
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 14:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DA94214AF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 14:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgDWOtH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 10:49:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:58852 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbgDWOtG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 10:49:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3A8A9ABB2;
        Thu, 23 Apr 2020 14:49:03 +0000 (UTC)
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
 <20200407163033.GA26568@infradead.org>
 <ae3b498b-aea8-dc09-53b8-9e160effc681@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a0316b0b-a24c-7d0c-df17-0573593e2a11@suse.de>
Date:   Thu, 23 Apr 2020 16:49:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ae3b498b-aea8-dc09-53b8-9e160effc681@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/20 4:13 PM, John Garry wrote:
> On 07/04/2020 17:30, Christoph Hellwig wrote:
>> On Tue, Apr 07, 2020 at 04:00:10PM +0200, Hannes Reinecke wrote:
>>> My concern is this:
>>>
>>> struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
>>> {
>>>     [ .. ]
>>>     starget = scsi_alloc_target(&shost->shost_gendev, 0, 
>>> shost->this_id);
>>>     [ .. ]
>>>
>>> and we have typically:
>>>
>>> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: .this_id                = -1,
>>>
>>> It's _very_ uncommon to have a negative number as the SCSI target 
>>> device; in
>>> fact, it _is_ an unsigned int already.
>>>
>>> But alright, I'll give it a go; let's see what I'll end up with.
>>
>> But this shouldn't be exposed anywhere.  And I prefer that over having
>> magic requests/scsi_cmnd that do not have a valid ->device pointer.
>> .
>>
> 
> (just looking at this again)
> 
> Hi Christoph,
> 
> So how would this look added in scsi_lib.c:
> 
> struct scsi_cmnd *scsi_get_reserved_cmd(struct Scsi_Host *shost)
> {
>      struct scsi_cmnd *scmd;
>      struct request *rq;
>      struct scsi_device *sdev = scsi_get_host_dev(shost);
> 
>      if (!sdev)
>          return NULL;
> 
>      rq = blk_mq_alloc_request(sdev->request_queue,
>                    REQ_OP_DRV_OUT | REQ_NOWAIT,
>                    BLK_MQ_REQ_RESERVED);
>      if (IS_ERR(rq)) // fix tidy-up
>          return NULL;
>      WARN_ON(rq->tag == -1);
>      scmd = blk_mq_rq_to_pdu(rq);
>      scmd->request = rq;
>      scmd->device = sdev;
> 
>      return scmd;
> }
> EXPORT_SYMBOL_GPL(scsi_get_reserved_cmd);
> 
> void scsi_put_reserved_cmd(struct scsi_cmnd *scmd)
> {
>      struct request *rq = blk_mq_rq_from_pdu(scmd);
> 
>      if (blk_mq_rq_is_reserved(rq)) {
>          struct scsi_device *sdev = scmd->device;
>          blk_mq_free_request(rq);
>          scsi_free_host_dev(sdev);
>      }
> }
> EXPORT_SYMBOL_GPL(scsi_put_reserved_cmd);
> 
> Not sure if we want a static scsi_device per host, or alloc and free 
> dynamically.
> 
> (@Hannes, I also have some proper patches for libsas if you want to add it)
> 
Hold your horses.
I'm currently preparing a patchset implementing things by improving the 
current scsi_get_host_dev() etc.

RFC should be ready by the end of the week.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
