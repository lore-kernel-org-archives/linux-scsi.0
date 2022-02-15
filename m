Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7AAC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 08:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiBOI5p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 03:57:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiBOI5o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 03:57:44 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCC689CCA
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 00:57:34 -0800 (PST)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JyZcM5Vvwz67x8s;
        Tue, 15 Feb 2022 16:53:07 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Tue, 15 Feb 2022 09:57:31 +0100
Received: from [10.47.81.62] (10.47.81.62) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Tue, 15 Feb
 2022 08:57:30 +0000
Message-ID: <9bfe3d2e-ae47-c114-9fb4-ed48ba116c11@huawei.com>
Date:   Tue, 15 Feb 2022 08:57:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 30/31] scsi: pm8001: Simplify pm8001_task_exec()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>,
        Ajish Koshy <Ajish.Koshy@microchip.com>,
        Viswas G <Viswas.G@microchip.com>, <jinpu.wang@ionos.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-31-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220214021747.4976-31-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.81.62]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/02/2022 02:17, Damien Le Moal wrote:
> The main part of the pm8001_task_exec() function uses a do {} while(0)
> loop that is useless and only makes the code harder to read. Remove this
> loop. Also, the unnecessary local variable t is removed.
> Additionnally, handling of the running_req counter is fixed to avoid
> decrementing it without a corresponding incrementation in the case of an
> invalid task protocol.
> 

Hi Damien,

I think that this is much improved, but there are still issues with the 
code but they are outside the scope of your change.

Just some minor comments below.

Regardless,

Reviewed-by: John Garry <john.garry@huawei.com>

> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>   drivers/scsi/pm8001/pm8001_sas.c | 160 ++++++++++++++-----------------
>   1 file changed, 73 insertions(+), 87 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 6c4aa04c9144..980afde2a0ab 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -373,32 +373,32 @@ static int sas_find_local_port_id(struct domain_device *dev)
>     * @is_tmf: if it is task management task.
>     * @tmf: the task management IU
>     */
> -static int pm8001_task_exec(struct sas_task *task,
> -	gfp_t gfp_flags, int is_tmf, struct pm8001_tmf_task *tmf)
> +static int pm8001_task_exec(struct sas_task *task, gfp_t gfp_flags, int is_tmf,
> +			    struct pm8001_tmf_task *tmf)
>   {
>   	struct domain_device *dev = task->dev;
> +	struct pm8001_device *pm8001_dev = dev->lldd_dev;
>   	struct pm8001_hba_info *pm8001_ha;
> -	struct pm8001_device *pm8001_dev;
>   	struct pm8001_port *port = NULL;
> -	struct sas_task *t = task;
> -	struct task_status_struct *ts = &t->task_status;
> +	struct task_status_struct *ts = &task->task_status;
> +	enum sas_protocol task_proto = task->task_proto;

nit: I think that these can be better arranged in reverse fir-tree 
style, but no big deal

>   	struct pm8001_ccb_info *ccb;
> -	u32 rc = 0, n_elem = 0;
> -	unsigned long flags = 0;
> -	enum sas_protocol task_proto = t->task_proto;
> +	unsigned long flags;
> +	u32 n_elem = 0;
> +	int rc = 0;
>   
>   	if (!dev->port) {
>   		ts->resp = SAS_TASK_UNDELIVERED;
>   		ts->stat = SAS_PHY_DOWN;
>   		if (dev->dev_type != SAS_SATA_DEV)
> -			t->task_done(t);
> +			task->task_done(task);
>   		return 0;
>   	}
>   
> -	pm8001_ha = pm8001_find_ha_by_dev(task->dev);
> +	pm8001_ha = pm8001_find_ha_by_dev(dev);
>   	if (pm8001_ha->controller_fatal_error) {
>   		ts->resp = SAS_TASK_UNDELIVERED;
> -		t->task_done(t);
> +		task->task_done(task);
>   		return 0;
>   	}
>   
> @@ -406,92 +406,78 @@ static int pm8001_task_exec(struct sas_task *task,
>   
>   	spin_lock_irqsave(&pm8001_ha->lock, flags);
>   
> -	do {
> -		dev = t->dev;
> -		pm8001_dev = dev->lldd_dev;
> -		port = &pm8001_ha->port[sas_find_local_port_id(dev)];
> +	pm8001_dev = dev->lldd_dev;
> +	port = &pm8001_ha->port[sas_find_local_port_id(dev)];
>   
> -		if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
> -			ts->resp = SAS_TASK_UNDELIVERED;
> -			ts->stat = SAS_PHY_DOWN;
> -			if (sas_protocol_ata(task_proto)) {
> -				spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> -				t->task_done(t);
> -				spin_lock_irqsave(&pm8001_ha->lock, flags);
> -			} else {
> -				t->task_done(t);
> -			}
> -			continue;
> +	if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
> +		ts->resp = SAS_TASK_UNDELIVERED;
> +		ts->stat = SAS_PHY_DOWN;
> +		if (sas_protocol_ata(task_proto)) {
> +			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +			task->task_done(task);
> +			spin_lock_irqsave(&pm8001_ha->lock, flags);
> +		} else {
> +			task->task_done(task);
>   		}
> +		goto unlock;
> +	}
>   
> -		ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_dev, t);
> -		if (!ccb) {
> -			rc = -SAS_QUEUE_FULL;
> -			goto err_out;
> -		}
> +	ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_dev, task);
> +	if (!ccb) {
> +		rc = -SAS_QUEUE_FULL;
> +		goto unlock;
> +	}
>   
> -		if (!sas_protocol_ata(task_proto)) {
> -			if (t->num_scatter) {
> -				n_elem = dma_map_sg(pm8001_ha->dev,
> -					t->scatter,
> -					t->num_scatter,
> -					t->data_dir);
> -				if (!n_elem) {
> -					rc = -ENOMEM;
> -					goto err_out_ccb;
> -				}
> +	if (!sas_protocol_ata(task_proto)) {
> +		if (task->num_scatter) {
> +			n_elem = dma_map_sg(pm8001_ha->dev, task->scatter,
> +					    task->num_scatter, task->data_dir);
> +			if (!n_elem) {
> +				rc = -ENOMEM;
> +				goto ccb_free;
>   			}
> -		} else {
> -			n_elem = t->num_scatter;
>   		}
> +	} else {
> +		n_elem = task->num_scatter;
> +	}
>   
> -		t->lldd_task = ccb;
> -		ccb->n_elem = n_elem;
> +	task->lldd_task = ccb;
> +	ccb->n_elem = n_elem;
>   
> -		switch (task_proto) {
> -		case SAS_PROTOCOL_SMP:
> -			atomic_inc(&pm8001_dev->running_req);
> -			rc = pm8001_task_prep_smp(pm8001_ha, ccb);
> -			break;
> -		case SAS_PROTOCOL_SSP:
> -			atomic_inc(&pm8001_dev->running_req);
> -			if (is_tmf)
> -				rc = pm8001_task_prep_ssp_tm(pm8001_ha,
> -					ccb, tmf);
> -			else
> -				rc = pm8001_task_prep_ssp(pm8001_ha, ccb);
> -			break;
> -		case SAS_PROTOCOL_SATA:
> -		case SAS_PROTOCOL_STP:
> -			atomic_inc(&pm8001_dev->running_req);
> -			rc = pm8001_task_prep_ata(pm8001_ha, ccb);
> -			break;
> -		default:
> -			dev_printk(KERN_ERR, pm8001_ha->dev,
> -				"unknown sas_task proto: 0x%x\n", task_proto);
> -			rc = -EINVAL;
> -			break;
> -		}
> +	atomic_inc(&pm8001_dev->running_req);
>   
> -		if (rc) {
> -			pm8001_dbg(pm8001_ha, IO, "rc is %x\n", rc);
> -			atomic_dec(&pm8001_dev->running_req);
> -			goto err_out_ccb;
> -		}
> -		/* TODO: select normal or high priority */
> -	} while (0);
> -	rc = 0;
> -	goto out_done;
> +	switch (task_proto) {
> +	case SAS_PROTOCOL_SMP:
> +		rc = pm8001_task_prep_smp(pm8001_ha, ccb);
> +		break;
> +	case SAS_PROTOCOL_SSP:
> +		if (is_tmf)
> +			rc = pm8001_task_prep_ssp_tm(pm8001_ha, ccb, tmf);
> +		else
> +			rc = pm8001_task_prep_ssp(pm8001_ha, ccb);
> +		break;
> +	case SAS_PROTOCOL_SATA:
> +	case SAS_PROTOCOL_STP:
> +		rc = pm8001_task_prep_ata(pm8001_ha, ccb);
> +		break;
> +	default:
> +		dev_printk(KERN_ERR, pm8001_ha->dev,
> +			   "unknown sas_task proto: 0x%x\n", task_proto);
> +		rc = -EINVAL;
> +		break;
> +	}
>   
> -err_out_ccb:
> -	pm8001_ccb_free(pm8001_ha, ccb);
> -err_out:
> -	dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
> -	if (!sas_protocol_ata(task_proto))
> -		if (n_elem)
> -			dma_unmap_sg(pm8001_ha->dev, t->scatter, t->num_scatter,
> -				t->data_dir);
> -out_done:

I know it's a personal preference, but I preferred the old labels; 
however I did not like the goto out_done. I think that the old code 
should just have had 2x spin_unlock_irqrestore + return statements.

> +	if (rc) {
> +		atomic_dec(&pm8001_dev->running_req);
> +		if (!sas_protocol_ata(task_proto) && n_elem)
> +			dma_unmap_sg(pm8001_ha->dev, task->scatter,
> +				     task->num_scatter, task->data_dir);
> +ccb_free:
> +		pm8001_ccb_free(pm8001_ha, ccb);
> +		dev_err(pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);

Comment on current code, so feel free to ignore: pm8001_dbg should be 
used always (and improved to be able to do so)

> +	}
> +
> +unlock:
>   	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>   	return rc;
>   }

