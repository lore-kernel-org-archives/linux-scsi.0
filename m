From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2] driver/scsi/pmcraid: Use pci_zalloc_consistent instead
 of pci_alloc_consistent+memset
Date: Wed, 1 Aug 2018 16:27:49 +0800
Message-ID: <eb0a5e82-a67d-4176-12e6-607fb17a4e5d@huawei.com>
References: <1533107805-7545-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533107805-7545-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ÔÚ 2018/8/1 15:16, zhong jiang Ð´µÀ:
> Pci_zalloc_consistent is better than pci_alloc_consistent+memset,
> and it make the code concise

Aren't these APIs deprecated:
https://lkml.org/lkml/2018/6/5/381

> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>   drivers/scsi/pmcraid.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 4e86994..8a6facc 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -4736,11 +4736,9 @@ static int pmcraid_allocate_host_rrqs(struct pmcraid_instance *pinstance)
>   	buffer_size = HRRQ_ENTRY_SIZE * PMCRAID_MAX_CMD;
>   
>   	for (i = 0; i < pinstance->num_hrrq; i++) {
> -		pinstance->hrrq_start[i] =
> -			pci_alloc_consistent(
> -					pinstance->pdev,
> -					buffer_size,
> -					&(pinstance->hrrq_start_bus_addr[i]));
> +		pinstance->hrrq_start[i] = pci_zalloc_consistent(pinstance->pdev,
> +								buffer_size,
> +								&(pinstance->hrrq_start_bus_addr[i]));
>   
>   		if (!pinstance->hrrq_start[i]) {
>   			pmcraid_err("pci_alloc failed for hrrq vector : %d\n",
> @@ -4749,7 +4747,6 @@ static int pmcraid_allocate_host_rrqs(struct pmcraid_instance *pinstance)
>   			return -ENOMEM;
>   		}
>   
> -		memset(pinstance->hrrq_start[i], 0, buffer_size);
>   		pinstance->hrrq_curr[i] = pinstance->hrrq_start[i];
>   		pinstance->hrrq_end[i] =
>   			pinstance->hrrq_start[i] + PMCRAID_MAX_CMD - 1;
> 
