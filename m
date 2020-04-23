Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354EFC54FD0
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 14:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA6920857
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 14:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgDWON4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 10:13:56 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2088 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726450AbgDWONz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 10:13:55 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id A235B288AFABC7CBEA83;
        Thu, 23 Apr 2020 15:13:53 +0100 (IST)
Received: from [127.0.0.1] (10.47.5.255) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 23 Apr
 2020 15:13:51 +0100
Subject: Re: [PATCH RFC v2 02/24] scsi: allocate separate queue for reserved
 commands
To:     Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.de>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
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
From:   John Garry <john.garry@huawei.com>
Message-ID: <ae3b498b-aea8-dc09-53b8-9e160effc681@huawei.com>
Date:   Thu, 23 Apr 2020 15:13:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200407163033.GA26568@infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.5.255]
X-ClientProxiedBy: lhreml722-chm.china.huawei.com (10.201.108.73) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/04/2020 17:30, Christoph Hellwig wrote:
> On Tue, Apr 07, 2020 at 04:00:10PM +0200, Hannes Reinecke wrote:
>> My concern is this:
>>
>> struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
>> {
>> 	[ .. ]
>> 	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
>> 	[ .. ]
>>
>> and we have typically:
>>
>> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: .this_id                = -1,
>>
>> It's _very_ uncommon to have a negative number as the SCSI target device; in
>> fact, it _is_ an unsigned int already.
>>
>> But alright, I'll give it a go; let's see what I'll end up with.
> 
> But this shouldn't be exposed anywhere.  And I prefer that over having
> magic requests/scsi_cmnd that do not have a valid ->device pointer.
> .
> 

(just looking at this again)

Hi Christoph,

So how would this look added in scsi_lib.c:

struct scsi_cmnd *scsi_get_reserved_cmd(struct Scsi_Host *shost)
{
	struct scsi_cmnd *scmd;
	struct request *rq;
	struct scsi_device *sdev = scsi_get_host_dev(shost);

	if (!sdev)
		return NULL;

	rq = blk_mq_alloc_request(sdev->request_queue,
				  REQ_OP_DRV_OUT | REQ_NOWAIT,
				  BLK_MQ_REQ_RESERVED);
	if (IS_ERR(rq)) // fix tidy-up
		return NULL;
	WARN_ON(rq->tag == -1);
	scmd = blk_mq_rq_to_pdu(rq);
	scmd->request = rq;
	scmd->device = sdev;

	return scmd;
}
EXPORT_SYMBOL_GPL(scsi_get_reserved_cmd);

void scsi_put_reserved_cmd(struct scsi_cmnd *scmd)
{
	struct request *rq = blk_mq_rq_from_pdu(scmd);

	if (blk_mq_rq_is_reserved(rq)) {
		struct scsi_device *sdev = scmd->device;
		blk_mq_free_request(rq);
		scsi_free_host_dev(sdev);
	}
}
EXPORT_SYMBOL_GPL(scsi_put_reserved_cmd);

Not sure if we want a static scsi_device per host, or alloc and free 
dynamically.

(@Hannes, I also have some proper patches for libsas if you want to add it)

Cheers,
John
