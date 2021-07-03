Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C795FC07E95
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Jul 2021 02:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ABD961424
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Jul 2021 02:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhGCCem (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 22:34:42 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:10240 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhGCCem (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 22:34:42 -0400
Received: from dggeml756-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GGwnJ0mdRz1BVMM;
        Sat,  3 Jul 2021 10:26:44 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 dggeml756-chm.china.huawei.com (10.1.199.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 3 Jul 2021 10:32:06 +0800
Subject: Re: [PATCH 02/21] libsas: Only abort commands from inside the error
 handler
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Yufen Yu <yuyufen@huawei.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-3-bvanassche@acm.org>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <779caa02-6c9f-183b-2f3d-2b7dc5c877ef@huawei.com>
Date:   Sat, 3 Jul 2021 10:32:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20210701211224.17070-3-bvanassche@acm.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeml756-chm.china.huawei.com (10.1.199.158)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

ÔÚ 2021/7/2 5:12, Bart Van Assche Ð´µÀ:
> According to the information I found in patch commit descriptions, for SATA
> devices commands must be aborted from inside the libsas error handler.
> Check host->ehandler to determine whether or not running inside the error
> handler since host->host_eh_scheduled != 0 indicates that the SCSI error
> handler has been scheduled but does not mean that is already running. This
> patch restores code that was removed by commit 909657615d9b ("scsi: libsas:
> allow async aborts").
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Yves-Alexis Perez <corsac@debian.org>
> Fixes: c9f926000fe3 ("scsi: libsas: Disable asynchronous aborts for SATA devices")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/libsas/sas_scsi_host.c | 5 ++++-
>   include/scsi/libsas.h               | 1 +
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index ee44a0d7730b..95e4d58ab9d4 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -462,6 +462,7 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
>   	int res = TMF_RESP_FUNC_FAILED;
>   	struct sas_task *task = TO_SAS_TASK(cmd);
>   	struct Scsi_Host *host = cmd->device->host;
> +	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(host);
>   	struct domain_device *dev = cmd_to_domain_dev(cmd);
>   	struct sas_internal *i = to_sas_internal(host->transportt);
>   	unsigned long flags;
> @@ -471,7 +472,7 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
>   
>   	spin_lock_irqsave(host->host_lock, flags);
>   	/* We cannot do async aborts for SATA devices */
> -	if (dev_is_sata(dev) && !host->host_eh_scheduled) {
> +	if (dev_is_sata(dev) && !ha->eh_running) {
>   		spin_unlock_irqrestore(host->host_lock, flags);
>   		return FAILED;
>   	}


No idea why sas_eh_abort_handler() is only used by isci. The other
libsas drivers just let the error handler do the aborting work. So my
question is can the isci driver delete this callback and let the error
handler do this? If so, then we cann remove this function directly.

Thanks,
Jason


> @@ -731,6 +732,7 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
>   	tries++;
>   	retry = true;
>   	spin_lock_irq(shost->host_lock);
> +	ha->eh_running = true;
>   	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
>   	spin_unlock_irq(shost->host_lock);
>   
> @@ -767,6 +769,7 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
>   
>   	/* check if any new eh work was scheduled during the last run */
>   	spin_lock_irq(&ha->lock);
> +	ha->eh_running = false;
>   	if (ha->eh_active == 0) {
>   		shost->host_eh_scheduled = 0;
>   		retry = false;
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 6fe125a71b60..4a8fb324140e 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -364,6 +364,7 @@ struct sas_ha_struct {
>   	struct mutex	  drain_mutex;
>   	unsigned long	  state;
>   	spinlock_t	  lock;
> +	bool		  eh_running;
>   	int		  eh_active;
>   	wait_queue_head_t eh_wait_q;
>   	struct list_head  eh_dev_q;
> .
> 
