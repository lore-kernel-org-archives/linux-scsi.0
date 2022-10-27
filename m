Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A5DC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 01:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbiJ0Bg5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 21:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJ0Bg4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 21:36:56 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849B3A3BA8
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 18:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666834615; x=1698370615;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sq4g7qBu0DoY8hGu57diZ9l3dIgGjNUmrelClq2zu+8=;
  b=GBwTyZC92eloGYGdT5dYQjPh1ATcCrok0fb9MCEomhHDQYy/poALLake
   Rn3IpFNllJ6W/PCxUGsOLQ2sTRqMCB897JMFccBUCXRoQhEAqNnC/TQwc
   x7SpTC8mWKmsYSfI4h+vb0CCfJ7YrdB9V2CD/1OnUzKojO6mJgAqCT26j
   yriCRiS+JhkuNgzYGdH/oiT4dpoHP3ziTFR9a4hGK0WkFdGEcGWbkxwuT
   uAy9WH/SLcX7tF7Cl3Qr/X576O47qUvm21+5UX4e3QHR1Ygy9iVvLi6fn
   AAHS/p3pIvhAOo8Yq9QLE567clbYpxKaGRuz7tcbigGiwXMmsG3iw9ytr
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="215192575"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 09:36:53 +0800
IronPort-SDR: BcYJWnSGQ2kaVnGEfzkjXFuWJLC/9GuWrrg3qMS2VdWOmALd/jYnkvUv6NmaoR1MGDhZy+HlIW
 ED8xOP4ZGzefeKfkRm7YUhXl1qsKzNQ6NGmAbTytou3JATJDhMCiVlZ4leV2VmYJJbRejLZgri
 sWD/u3nXgcnWHj33DdHgS8bJZ1DEBziQ9TajezBp6CihGganPG+vktKheu1fjJ50WRDFoJ3Rw4
 3mmL2yCOznes/tm2fA+Y/1swuxzktsbUo0X/Yfp3gSbYY3JE6SohEiKKVEJddA5VD4g302XajX
 F3FMB+bBAUIG1C8XgjGM9BbP
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 17:50:32 -0700
IronPort-SDR: 8OJsfw3ZJgNaQUMXCbtO+jgixit7NViojK2IMps1woFyunSgLIXL3Z/lCC6vffLYWZ2eBsNKf/
 Xed/FIq5SFnKJ/M20SFl37o1rLHA3K94Ej1R3OY4Ex2eNv5M+3zCi5bbCCuM79tInZg6DOwUpK
 XZlvS4T2UOWsxm3ZoKGOgsg8Lf8Z52gWXxapt4cnnYxrqQk0pO6rHAiH0CGWBsABuq3ibHSKsq
 gDge9o0IslDQG1r84sn+CUGs8w5DsD7axS4FAcb3gDzH7kJS1OUqjYku76EhfiuA/cGXhOIlxO
 /L0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 18:36:54 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MySvn2J9Pz1RwvT
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 18:36:53 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1666834612; x=1669426613; bh=sq4g7qBu0DoY8hGu57diZ9l3dIgGjNUmrel
        Clq2zu+8=; b=hHKByuN7jJ3kJ8VarRuRDOg8E30rEAoQmPqOyi/qfPI0YdsXvfZ
        Xs6QdmqKsqkKJkfJoPF2pUMVshHllaUIoujaTPemQ8rgNZYdQdgmyB9bM0VWI1/X
        VXt4gX3vBSlghWq1yadaNLNh1h9Oz8esd40KVt0/xVaDB8CVTVfy54rpmCzmZ7Mc
        v6tDddnwGxlFNclWR7mxIBoVvpF3dZbwR0v6PWKGT8KqKukFThOn1Jn99576NLJN
        T1uVvWd9g2GUimRTAi+qsOI66tt4J+BtA9xEmjEclLpC2CXzDqyM+jLadx3WzUCP
        l+UOdH/LtPDyzm7v8fGuGnpYZ200JKEAazg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id R11OFBA-8IYT for <linux-scsi@vger.kernel.org>;
        Wed, 26 Oct 2022 18:36:52 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MySvj2yczz1RvLy;
        Wed, 26 Oct 2022 18:36:49 -0700 (PDT)
Message-ID: <9376e947-ba53-2fb9-a0af-8435d58347c1@opensource.wdc.com>
Date:   Thu, 27 Oct 2022 10:36:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH RFC v3 18/22] scsi: libsas: Queue SMP commands as requests
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        jinpu.wang@cloud.ionos.com, hare@suse.de, bvanassche@acm.org,
        hch@lst.de, ming.lei@redhat.com, niklas.cassel@wdc.com
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com
References: <1666693096-180008-1-git-send-email-john.garry@huawei.com>
 <1666693096-180008-19-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1666693096-180008-19-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/22 19:18, John Garry wrote:
> Send SMP commands through the block layer so that each command gets a
> unique tag associated.
> 
> Function sas_task_complete_internal() is what the LLDD calls to signal
> that the CQ is complete and this calls into the SCSI midlayer. And then
> sas_blk_end_sync_rq() is called when the request completes.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/libsas/sas_expander.c  | 23 ++++++++---------------
>  drivers/scsi/libsas/sas_init.c      |  3 +++
>  drivers/scsi/libsas/sas_internal.h  |  3 +++
>  drivers/scsi/libsas/sas_scsi_host.c | 16 ++++++++++++++++
>  4 files changed, 30 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index e7cb95683522..cc41127ea5cc 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -43,34 +43,27 @@ static int smp_execute_task_sg(struct domain_device *dev,
>  	pm_runtime_get_sync(ha->dev);
>  	mutex_lock(&dev->ex_dev.cmd_mutex);
>  	for (retry = 0; retry < 3; retry++) {
> +		struct request *rq;
> +
>  		if (test_bit(SAS_DEV_GONE, &dev->state)) {
>  			res = -ECOMM;
>  			break;
>  		}
>  
> -		task = sas_alloc_slow_task(GFP_KERNEL);
> +		task = sas_alloc_slow_task_rq(dev, GFP_KERNEL);
>  		if (!task) {
>  			res = -ENOMEM;
>  			break;
>  		}
> -		task->dev = dev;
> +
> +		rq = scsi_cmd_to_rq(task->uldd_task);
> +		rq->timeout = SMP_TIMEOUT*HZ;

Missing spaces around "*"

> +
>  		task->task_proto = dev->tproto;
>  		task->smp_task.smp_req = *req;
>  		task->smp_task.smp_resp = *resp;
>  
> -		task->task_done = sas_task_internal_done;
> -
> -		task->slow_task->timer.function = sas_task_internal_timedout;
> -		task->slow_task->timer.expires = jiffies + SMP_TIMEOUT*HZ;
> -		add_timer(&task->slow_task->timer);
> -
> -		res = i->dft->lldd_execute_task(task, GFP_KERNEL);
> -
> -		if (res) {
> -			del_timer_sync(&task->slow_task->timer);
> -			pr_notice("executing SMP task failed:%d\n", res);
> -			break;
> -		}
> +		blk_execute_rq_nowait(rq, true);
>  
>  		wait_for_completion(&task->slow_task->completion);
>  		res = -ECOMM;
> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
> index 90e63ff5e966..5f9e71a54799 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
> @@ -84,6 +84,7 @@ struct sas_task *sas_alloc_slow_task_rq(struct domain_device *device, gfp_t flag
>  		return NULL;
>  
>  	task->dev = device;
> +	task->task_done = sas_task_complete_internal;
>  
>  	rq = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
>  				BLK_MQ_REQ_RESERVED | BLK_MQ_REQ_NOWAIT);
> @@ -95,6 +96,8 @@ struct sas_task *sas_alloc_slow_task_rq(struct domain_device *device, gfp_t flag
>  	scmd = blk_mq_rq_to_pdu(rq);
>  
>  	task->uldd_task = scmd;
> +
> +	rq->end_io = sas_blk_end_sync_rq;
>  	rq->end_io_data = task;
>  
>  	return task;
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index f5ae4de382f7..9b58948c57c2 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -104,6 +104,9 @@ int sas_execute_tmf(struct domain_device *device, void *parameter,
>  		    int para_len, int force_phy_id,
>  		    struct sas_tmf_task *tmf);
>  
> +void sas_task_complete_internal(struct sas_task *task);
> +enum rq_end_io_ret sas_blk_end_sync_rq(struct request *rq, blk_status_t error);
> +
>  #ifdef CONFIG_SCSI_SAS_HOST_SMP
>  extern void sas_smp_host_handler(struct bsg_job *job, struct Scsi_Host *shost);
>  #else
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index b7d1994a8f1b..2c734a87bb7c 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -913,6 +913,13 @@ void sas_task_internal_done(struct sas_task *task)
>  	complete(&task->slow_task->completion);
>  }
>  
> +void sas_task_complete_internal(struct sas_task *task)
> +{
> +	struct scsi_cmnd *scmd = task->uldd_task;
> +
> +	scsi_done(scmd);
> +}
> +
>  void sas_task_internal_timedout(struct timer_list *t)
>  {
>  	struct sas_task_slow *slow = from_timer(slow, t, timer);
> @@ -952,6 +959,15 @@ EXPORT_SYMBOL_GPL(sas_internal_timeout);
>  #define TASK_TIMEOUT			(20 * HZ)
>  #define TASK_RETRY			3
>  
> +enum rq_end_io_ret sas_blk_end_sync_rq(struct request *rq, blk_status_t error)
> +{
> +	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
> +	struct sas_task *task = TO_SAS_TASK(scmd);
> +	complete(&task->slow_task->completion);
> +
> +	return RQ_END_IO_NONE;
> +}
> +
>  static int sas_execute_internal_abort(struct domain_device *device,
>  				      enum sas_internal_abort type, u16 tag,
>  				      unsigned int qid, void *data)

-- 
Damien Le Moal
Western Digital Research

