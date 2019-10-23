Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8D5CA9EB6
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 08:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C285205C9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 08:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390367AbfJWIwu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 04:52:50 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2050 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390034AbfJWIwu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Oct 2019 04:52:50 -0400
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 824ECBABE9C0E9A229A4;
        Wed, 23 Oct 2019 09:52:48 +0100 (IST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml709-cah.china.huawei.com (10.201.108.32) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 23 Oct 2019 09:52:48 +0100
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 23 Oct
 2019 09:52:47 +0100
Subject: Re: [PATCH V4 1/2] scsi: core: avoid host-wide host_busy counter for
 scsi_mq
To:     Ming Lei <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        "Laurence Oberman" <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20191009093241.21481-1-ming.lei@redhat.com>
 <20191009093241.21481-2-ming.lei@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <7d95de12-6114-c0d7-8b21-d36b2ea020fc@huawei.com>
Date:   Wed, 23 Oct 2019 09:52:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191009093241.21481-2-ming.lei@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/10/2019 10:32, Ming Lei wrote:
> It isn't necessary to check the host depth in scsi_queue_rq() any more
> since it has been respected by blk-mq before calling scsi_queue_rq() via
> getting driver tag.
> 
> Lots of LUNs may attach to same host and per-host IOPS may reach millions,
> so we should avoid expensive atomic operations on the host-wide counter in
> the IO path.
> 
> This patch implements scsi_host_busy() via blk_mq_tagset_busy_iter()
> with one scsi command state for reading the count of busy IOs for scsi_mq.
> 
> It is observed that IOPS is increased by 15% in IO test on scsi_debug (32
> LUNs, 32 submit queues, 1024 can_queue, libaio/dio) in a dual-socket
> system.
> 
> V2:
> 	- introduce SCMD_STATE_INFLIGHT for getting accurate host busy
> 	via blk_mq_tagset_busy_iter()
> 	- verified that original Jens's report[1] is fixed
> 	- verified that SCSI timeout/abort works fine
> 
> [1] https://www.spinics.net/lists/linux-scsi/msg122867.html
> [2] V1 & its revert:
> 
> d772a65d8a6c Revert "scsi: core: avoid host-wide host_busy counter for scsi_mq"
> 23aa8e69f2c6 Revert "scsi: core: fix scsi_host_queue_ready"
> 265d59aacbce scsi: core: fix scsi_host_queue_ready
> 328728630d9f scsi: core: avoid host-wide host_busy counter for scsi_mq
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Omar Sandoval <osandov@fb.com>,
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
> Cc: Christoph Hellwig <hch@lst.de>,
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Bart Van Assche <bart.vanassche@wdc.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/scsi/hosts.c     | 19 ++++++++++++++++++-
>   drivers/scsi/scsi.c      |  2 +-
>   drivers/scsi/scsi_lib.c  | 35 +++++++++++++++++------------------
>   drivers/scsi/scsi_priv.h |  2 +-
>   include/scsi/scsi_cmnd.h |  1 +
>   include/scsi/scsi_host.h |  1 -
>   6 files changed, 38 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 55522b7162d3..1d669e47b692 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -38,6 +38,7 @@
>   #include <scsi/scsi_device.h>
>   #include <scsi/scsi_host.h>
>   #include <scsi/scsi_transport.h>
> +#include <scsi/scsi_cmnd.h>

alphabetic ordering could be maintained

>   
>   #include "scsi_priv.h"
>   #include "scsi_logging.h"
> @@ -554,13 +555,29 @@ struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)
>   }
>   EXPORT_SYMBOL(scsi_host_get);
>   
> +static bool scsi_host_check_in_flight(struct request *rq, void *data,
> +				      bool reserved)
> +{
> +	int *count = data;
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
> +
> +	if (test_bit(SCMD_STATE_INFLIGHT, &cmd->state))
> +		(*count)++;
> +
> +	return true;
> +}
> +
>   /**
>    * scsi_host_busy - Return the host busy counter

is this comment accurate now?

>    * @shost:	Pointer to Scsi_Host to inc.
>    **/
>   int scsi_host_busy(struct Scsi_Host *shost)
>   {
> -	return atomic_read(&shost->host_busy);
> +	int cnt = 0;
> +
> +	blk_mq_tagset_busy_iter(&shost->tag_set,
> +				scsi_host_check_in_flight, &cnt);

When I check blk_mq_tagset_busy_iter(), it does not seem to lock the 
tags for all hw queues against preemption for the counting, so how can 
we guarantee that this count will be always accurate?

Or it never can be and you just don't care?

> +	return cnt;
>   }
>   EXPORT_SYMBOL(scsi_host_busy);
>   
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 1f5b5c8a7f72..ddc4ec6ea2a1 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -186,7 +186,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>   	struct scsi_driver *drv;
>   	unsigned int good_bytes;
>   
> -	scsi_device_unbusy(sdev);
> +	scsi_device_unbusy(sdev, cmd);
>   
>   	/*
>   	 * Clear the flags that say that the device/target/host is no longer
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index dc210b9d4896..b6f66dcb15a5 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -189,7 +189,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
>   	 * active on the host/device.
>   	 */
>   	if (unbusy)
> -		scsi_device_unbusy(device);
> +		scsi_device_unbusy(device, cmd);
>   
>   	/*
>   	 * Requeue this command.  It will go before all other commands > @@ -329,12 +329,12 @@ static void scsi_init_cmd_errh(struct scsi_cmnd 
*cmd)


The comment for scsi_dec_host_busy() is "Decrement the host_busy counter 
and ", so does this need to be fixed up?

I'm guessing that there's lots more places like this...

>    * host_failed counter or that it notices the shost state change made by
>    * scsi_eh_scmd_add().
>    */


> -static void scsi_dec_host_busy(struct Scsi_Host *shost)
> +static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>   {
>   	unsigned long flags;
>   
>   	rcu_read_lock();
> -	atomic_dec(&shost->host_busy);
> +	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>   	if (unlikely(scsi_host_in_recovery(shost))) {
>   		spin_lock_irqsave(shost->host_lock, flags);
>   		if (shost->host_failed || shost->host_eh_scheduled)
> @@ -344,12 +344,12 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost)
>   	rcu_read_unlock();
>   }
>   
> -void scsi_device_unbusy(struct scsi_device *sdev)
> +void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
>   {
>   	struct Scsi_Host *shost = sdev->host;
>   	struct scsi_target *starget = scsi_target(sdev);
>   
> -	scsi_dec_host_busy(shost);
> +	scsi_dec_host_busy(shost, cmd);
>   
>   	if (starget->can_queue > 0)
>   		atomic_dec(&starget->target_busy);
> @@ -430,9 +430,6 @@ static inline bool scsi_target_is_busy(struct scsi_target *starget)
>   
>   static inline bool scsi_host_is_busy(struct Scsi_Host *shost)
>   {
> -	if (shost->can_queue > 0 &&
> -	    atomic_read(&shost->host_busy) >= shost->can_queue)
> -		return true;

Do we still honour "do not send more than can_queue 
commands to the adapter", regardless of how many queues the LLDD exposes?

>   	if (atomic_read(&shost->host_blocked) > 0)
>   		return true;
>   	if (shost->host_self_blocked)
> @@ -1139,6 +1136,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
>   	unsigned int flags = cmd->flags & SCMD_PRESERVED_FLAGS;
>   	unsigned long jiffies_at_alloc;
>   	int retries;
> +	bool in_flight;
Thanks,
John
