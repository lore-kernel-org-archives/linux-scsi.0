From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v4 2/5] scsi: hisi_sas: Relocate some code to reduce
 complexity
Date: Thu, 6 Dec 2018 15:17:35 +0100
Message-ID: <c7ec9e23-6da8-35e0-1996-02db3d640f4b@suse.de>
References: <1544103284-100497-1-git-send-email-john.garry@huawei.com>
 <1544103284-100497-3-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1544103284-100497-3-git-send-email-john.garry@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 06/12/2018 14:34, John Garry wrote:
[...]
> +static void hisi_sas_dma_unmap(struct hisi_hba *hisi_hba,
> +			       struct sas_task *task, int n_elem,
> +			       int n_elem_req, int n_elem_resp)
> +{
> +	struct device *dev = hisi_hba->dev;
> +
> +	if (!sas_protocol_ata(task->task_proto)) {
> +		if (task->num_scatter) {
> +			if (n_elem)
> +				dma_unmap_sg(dev, task->scatter,
> +					     task->num_scatter,
> +					     task->data_dir);
> +		} else if (task->task_proto & SAS_PROTOCOL_SMP) {
> +			if (n_elem_req)
> +				dma_unmap_sg(dev, &task->smp_task.smp_req,
> +					     1, DMA_TO_DEVICE);
> +			if (n_elem_resp)
> +				dma_unmap_sg(dev, &task->smp_task.smp_resp,
> +					     1, DMA_FROM_DEVICE);
> +		}
> +	}

	if (sas_protocol_ata(task->task_proto))
		return;

Would save you a level of indentation and make the above more readable.


-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
