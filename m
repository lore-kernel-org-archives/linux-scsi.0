Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F462C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 14:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DEEA2086A
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 14:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgHTOZA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 10:25:00 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2678 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbgHTOY7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Aug 2020 10:24:59 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id CB946FD11442678A37BF;
        Thu, 20 Aug 2020 15:24:56 +0100 (IST)
Received: from [127.0.0.1] (10.47.0.147) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 20 Aug
 2020 15:24:55 +0100
Subject: Re: [PATCH V4] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Long Li <longli@microsoft.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20200817100840.2496976-1-ming.lei@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <5805af73-c3ec-8393-0dc2-18fe797d781b@huawei.com>
Date:   Thu, 20 Aug 2020 15:22:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200817100840.2496976-1-ming.lei@redhat.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.0.147]
X-ClientProxiedBy: lhreml745-chm.china.huawei.com (10.201.108.195) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/08/2020 11:08, Ming Lei wrote:
> Now the request queue is run in scsi_end_request() unconditionally if both
> target queue and host queue is ready. We should have re-run request queue
> only after this device queue becomes busy for restarting this LUN only.
> 
> Recently Long Li reported that cost of run queue may be very heavy in
> case of high queue depth. So improve this situation by only running
> the request queue when this LUN is busy.
> 
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Long Li <longli@microsoft.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: linux-block@vger.kernel.org
> Reported-by: Long Li <longli@microsoft.com>
> Tested-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

FWIW, this looks ok to me, and tested on scsi_debug showed less time in 
blk_mq_run_hw_queues() [for reduced queue depth]:

Reviewed-by: John Garry <john.garry@huawei.com>

thanks
