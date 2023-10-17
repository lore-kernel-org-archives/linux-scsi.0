Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C35CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 08:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbjJQIQ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 04:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbjJQIQZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 04:16:25 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1763293
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 01:16:22 -0700 (PDT)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4S8msN2kFkzvPvd;
        Tue, 17 Oct 2023 16:11:36 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 17 Oct 2023 16:16:19 +0800
Message-ID: <0f7a0131-3f6a-1627-2bba-96dab1ad6d9d@huawei.com>
Date:   Tue, 17 Oct 2023 16:16:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Wenchao Hao <haowenchao2@huawei.com>
Subject: Re: [PATCH 1/9] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20231016121542.111501-1-hare@suse.de>
 <20231016121542.111501-2-hare@suse.de>
Content-Language: en-US
In-Reply-To: <20231016121542.111501-2-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/10/16 20:15, Hannes Reinecke wrote:
> Issuing a host reset should not rely on any commands.
> So use Scsi_Host as argument for eh_host_reset_handler.
> 

Some small points.

> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 9080a73b4ea6..caf045cfea0e 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1955,15 +1955,15 @@ mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
>   
>   /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>   /**
> - *	mptscsih_host_reset - Perform a SCSI host adapter RESET (new_eh variant)
> - *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
> + *	mptscsih_host_reset - Perform a SCSI host adapter RESET
> + *	@sh: Pointer to Scsi_Host structure, which is reset due to
>    *
>    *	(linux scsi_host_template.eh_host_reset_handler routine)
>    *
>    *	Returns SUCCESS or FAILED.
>    */
>   int
> -mptscsih_host_reset(struct scsi_cmnd *SCpnt)
> +mptscsih_host_reset(struct Scsi_Host *sh)
>   {
>   	MPT_SCSI_HOST *  hd;
>   	int              status = SUCCESS;
> @@ -1971,9 +1971,8 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
>   	int		retval;
>   
>   	/*  If we can't locate the host to reset, then we failed. */
> -	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
> -		printk(KERN_ERR MYNAM ": host reset: "
> -		    "Can't locate host! (sc=%p)\n", SCpnt);
> +	if ((hd = shost_priv(sh)) == NULL){
> +		printk(KERN_ERR MYNAM ": host reset: Can't locate host!\n");
>   		return FAILED;
>   	}

It looks better to use shost_printk(), same for following 2 printk.

>   
> @@ -1981,8 +1980,8 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
>   	mptscsih_flush_running_cmds(hd);
>   
>   	ioc = hd->ioc;
> -	printk(MYIOC_s_INFO_FMT "attempting host reset! (sc=%p)\n",
> -	    ioc->name, SCpnt);
> +	printk(MYIOC_s_INFO_FMT "attempting host reset!\n",
> +	    ioc->name);
>  
>   	/*  If our attempts to reset the host failed, then return a failed
>   	 *  status.  The host will be taken off line by the SCSI mid-layer.
> @@ -1993,8 +1992,8 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
>   	else
>   		status = SUCCESS;
>   
> -	printk(MYIOC_s_INFO_FMT "host reset: %s (sc=%p)\n",
> -	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
> +	printk(MYIOC_s_INFO_FMT "host reset: %s\n",
> +	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ));
>   
>   	return status;
>   }

> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 72ceaf650b0d..9be45b7a2571 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -2852,21 +2852,14 @@ static bool blogic_write_outbox(struct blogic_adapter *adapter,
>   
>   /* Error Handling (EH) support */
>   
> -static int blogic_hostreset(struct scsi_cmnd *SCpnt)
> +static int blogic_hostreset(struct Scsi_Host *shost)
>   {
> -	struct blogic_adapter *adapter =
> -		(struct blogic_adapter *) SCpnt->device->host->hostdata;
> -
> -	unsigned int id = SCpnt->device->id;
> -	struct blogic_tgt_stats *stats = &adapter->tgt_stats[id];
> +	struct blogic_adapter *adapter = shost_priv(shost);
>   	int rc;
>   
> -	spin_lock_irq(SCpnt->device->host->host_lock);
> -
> -	blogic_inc_count(&stats->adapter_reset_req);
> -
> +	spin_lock_irq(shost->host_lock);
>   	rc = blogic_resetadapter(adapter, false);
> -	spin_unlock_irq(SCpnt->device->host->host_lock);
> +	spin_unlock_irq(shost->host_lock);
>   	return rc;
>   }

Why remove line "blogic_inc_count(&stats->adapter_reset_req);" ?

> diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
> index f5334ccbf2ca..b9e241b9bb54 100644
> --- a/drivers/scsi/hptiop.c
> +++ b/drivers/scsi/hptiop.c
> @@ -1088,12 +1088,12 @@ static int hptiop_reset_hba(struct hptiop_hba *hba)
>   	return 0;
>   }
>   
> -static int hptiop_reset(struct scsi_cmnd *scp)
> +static int hptiop_reset(struct Scsi_Host *host)
>   {
> -	struct hptiop_hba * hba = (struct hptiop_hba *)scp->device->host->hostdata;
> +	struct hptiop_hba * hba = shost_priv(host);
>   
>   	printk(KERN_WARNING "hptiop_reset(%d/%d/%d)\n",
> -	       scp->device->host->host_no, -1, -1);
> +	       host->host_no, -1, -1);
>   

Also, it looks better to use shost_printk().

>   	return hptiop_reset_hba(hba)? FAILED : SUCCESS;
>   }

