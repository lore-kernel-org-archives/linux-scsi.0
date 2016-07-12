From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] ipr: Add scsi multi-queue support
Date: Tue, 12 Jul 2016 16:59:04 -0500
Message-ID: <57856828.3020107@linux.vnet.ibm.com>
References: <1468357329-3790-1-git-send-email-wenxiong@linux.vnet.ibm.com>
 <1468357329-3790-3-git-send-email-wenxiong@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44316 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbcGLV7j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2016 17:59:39 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6CLwf6C117757
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:59:09 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
	by mx0a-001b2d01.pphosted.com with ESMTP id 2452xr3wm2-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:59:09 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 12 Jul 2016 17:59:08 -0400
In-Reply-To: <1468357329-3790-3-git-send-email-wenxiong@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com, linux-scsi@vger.kernel.org
Cc: JBottomley@Odin.com, martin.petersen@oracle.com, krisman@linux.vnet.ibm.com

On 07/12/2016 04:02 PM, wenxiong@linux.vnet.ibm.com wrote:
> From: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> 
> Add scsi multi-queue support in ipr driver. This feature
> is enabled by setting ipr_use_blk_mq=1 when loading ipr
> module and scsi blk-mq is enabled in the kernel.
> 
> Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c |   16 ++++++++++++++--
>  drivers/scsi/ipr.h |    1 +
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 1f539c2..21b6da6 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -100,6 +100,7 @@ static unsigned int ipr_max_devs = IPR_DEFAULT_SIS64_DEVS;
>  static unsigned int ipr_dual_ioa_raid = 1;
>  static unsigned int ipr_number_of_msix = 16;
>  static unsigned int ipr_fast_reboot;
> +static unsigned int ipr_use_blk_mq = 0;

No need to initialize a static to 0. Can you be sure to run scripts/checkpatch.pl
in future? 


> @@ -6329,7 +6333,12 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
>  		return rc;
>  	}
> 
> -	hrrq_id = ipr_get_hrrq_index(ioa_cfg);
> +	if (ioa_cfg->use_blk_mq && shost_use_blk_mq(scsi_cmd->device->host)) {
> +		tag = blk_mq_unique_tag(scsi_cmd->request);
> +		hrrq_id = blk_mq_unique_tag_to_hwq(tag);
> +	} else
> +		hrrq_id = ipr_get_hrrq_index(ioa_cfg);
> +
>  	hrrq = &ioa_cfg->hrrq[hrrq_id];
> 
>  	spin_lock_irqsave(hrrq->lock, hrrq_flags);
> @@ -10144,6 +10153,8 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
>  				(unsigned int)num_online_cpus(),
>  				(unsigned int)IPR_MAX_HRRQ_NUM);
> 
> +	host->nr_hw_queues = ioa_cfg->hrrq_num;

Prior to this patch we reserved HRRQ 0 for error interrupts. This changes that
to use it also for normal I/O interrupts. One side effect of this is that we
can now no longer use iopoll for HRRQ 0. It would be nice to not change this
behavior and keep using HRRQ 0 for errors only, since we have an MMIO read
in that path we wanted to avoid in the normal I/O path.

I think if we just change the line above to:

host->nr_hw_queues = ioa_cfg->hrrq_num - 1;

Then this should resolve this. Can you verify this doesn't break anything?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

