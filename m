Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB2EC43381
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 20:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F6E235F7
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 20:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbhATUik (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 15:38:40 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2388 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732673AbhATU2F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 15:28:05 -0500
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DLcR53f06z67bYt;
        Thu, 21 Jan 2021 04:23:13 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 20 Jan 2021 21:27:23 +0100
Received: from [10.47.7.185] (10.47.7.185) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 20 Jan
 2021 20:27:21 +0000
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
To:     <mwilck@suse.com>, Donald Buczek <buczek@molgen.mpg.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>
CC:     James Bottomley <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>,
        Don Brace <Don.Brace@microchip.com>,
        "Kevin Barnett" <Kevin.Barnett@microchip.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
References: <20210120184548.20219-1-mwilck@suse.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
Date:   Wed, 20 Jan 2021 20:26:05 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210120184548.20219-1-mwilck@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.7.185]
X-ClientProxiedBy: lhreml741-chm.china.huawei.com (10.201.108.191) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/01/2021 18:45, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Donald: please give this patch a try.
> 
> Commit 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
> contained this hunk:
> 
> -       busy = atomic_inc_return(&shost->host_busy) - 1;
>          if (atomic_read(&shost->host_blocked) > 0) {
> -               if (busy)
> +               if (scsi_host_busy(shost) > 0)
>                          goto starved;
> 
> The previous code would increase the busy count before checking host_blocked.
> With 6eb045e092ef, the busy count would be increased (by setting the
> SCMD_STATE_INFLIGHT bit) after the if clause for host_blocked above.
> 
> Users have reported a regression with the smartpqi driver [1] which has been
> shown to be caused by this commit [2].
> 

Please note these, where potential issue was discussed before:
https://lore.kernel.org/linux-scsi/8a3c8d37-8d15-4060-f461-8d400b19cb34@suse.de/
https://lore.kernel.org/linux-scsi/20200714104437.GB602708@T590/

> It seems that by moving the increase of the busy counter further down, it could
> happen that the can_queue limit of the controller could be exceeded if several
> CPUs were executing this code in parallel on different queues.
> 
> This patch attempts to fix it by moving setting the SCMD_STATE_INFLIGHT before
> the host_blocked test again. It also inserts barriers to make sure
> scsi_host_busy() on once CPU will notice the increase of the count from another.
> 
> [1]: https://marc.info/?l=linux-scsi&m=160271263114829&w=2
> [2]: https://marc.info/?l=linux-scsi&m=161116163722099&w=2
> 
> Fixes: 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")

For failing test, it would be good to know:
- host .can_queue
- host .nr_hw_queues
- number of LUNs in test and their queue depth

All can be got from lsscsi, apart from nr_hw_queues, which can be got 
from scsi_host sysfs for kernel >= 5.10

Cheers,
John

> 
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Don Brace <Don.Brace@microchip.com>
> Cc: Kevin Barnett <Kevin.Barnett@microchip.com>
> Cc: Donald Buczek <buczek@molgen.mpg.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>   drivers/scsi/hosts.c    | 2 ++
>   drivers/scsi/scsi_lib.c | 8 +++++---
>   2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 2f162603876f..1c452a1c18fd 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -564,6 +564,8 @@ static bool scsi_host_check_in_flight(struct request *rq, void *data,
>   	int *count = data;
>   	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
>   
> +	/* This pairs with set_bit() in scsi_host_queue_ready() */
> +	smp_mb__before_atomic();
>   	if (test_bit(SCMD_STATE_INFLIGHT, &cmd->state))
>   		(*count)++;
>   
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b3f14f05340a..0a9a36c349ee 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1353,8 +1353,12 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>   	if (scsi_host_in_recovery(shost))
>   		return 0;
>   
> +	set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> +	/* This pairs with test_bit() in scsi_host_check_in_flight() */
> +	smp_mb__after_atomic();
> +
>   	if (atomic_read(&shost->host_blocked) > 0) {
> -		if (scsi_host_busy(shost) > 0)
> +		if (scsi_host_busy(shost) > 1)
>   			goto starved;
>   
>   		/*
> @@ -1379,8 +1383,6 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>   		spin_unlock_irq(shost->host_lock);
>   	}
>   
> -	__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> -
>   	return 1;
>   
>   starved:
> 

