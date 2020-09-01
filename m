Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FACC433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 06:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6AE520FC3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 06:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgIAGym (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 02:54:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:60748 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgIAGyl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Sep 2020 02:54:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7F7CEB5EB;
        Tue,  1 Sep 2020 06:54:39 +0000 (UTC)
Subject: Re: [PATCH V4] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>, linux-block@vger.kernel.org
References: <20200817100840.2496976-1-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d6f37b50-decd-f0c9-2b72-7a00e7ead774@suse.de>
Date:   Tue, 1 Sep 2020 08:54:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200817100840.2496976-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/20 12:08 PM, Ming Lei wrote:
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
> ---
> V4:
> 	- fix one race reported by Kashyap, and simplify the implementation
> 	a bit; also pass Kashyap's both function and performance test
> V3:
> 	- add one smp_mb() in scsi_mq_get_budget() and comment
> 
> V2:
> 	- commit log change, no any code change
> 	- add reported-by tag
> 
>   drivers/scsi/scsi_lib.c    | 51 +++++++++++++++++++++++++++++++++++---
>   include/scsi/scsi_device.h |  1 +
>   2 files changed, 49 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
