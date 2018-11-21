From: Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH 3/4] scsi: hisi_sas: Make sg_tablesize consistent value
Date: Wed, 21 Nov 2018 12:02:25 +0100
Message-ID: <146f7c38-0cd7-a664-31d6-30a27b7a182b@linux.ibm.com>
References: <1542725944-244183-1-git-send-email-john.garry@huawei.com>
 <1542725944-244183-4-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542725944-244183-4-git-send-email-john.garry@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 11/20/2018 03:59 PM, John Garry wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> Sht->sg_tablesize is set in the driver, and it will be assigned to
> shost->sg_tablesize in SCSI mid-layer. So it is not necessary to
> assign shost->sg_table one more time in the driver.
> 
> In addition to the change, change each scsi_host_template.sg_tablesize
> to HISI_SAS_SGE_PAGE_CNT instead of SG_ALL.

Might be completely irrelevant, so just as information: I once had 
problems due to changing (reducing) SHT.sg_tablesize because block queue 
limits of BSG devices of Scsi_Host and fc_host (not sure if you have an 
equivalent bsg device for your transport(s)) inherit from SHT, but don't 
update (automatically) on later updates of shost->sg_tablesize, which in 
turn affect scsi_devices allocated after the shost update.
Cf. 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/s390/scsi?id=5fea4291deacd80188b996d2f555fc6a1940e5d4
("[SCSI] zfcp: block queue limits with data router")
if you need more details.

> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/scsi/hisi_sas/hisi_sas_main.c  | 1 -
>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 2 +-
>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 +-
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 +--
>   4 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index d13a662..cbda48e 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -2410,7 +2410,6 @@ int hisi_sas_probe(struct platform_device *pdev,
>   	shost->max_lun = ~0;
>   	shost->max_channel = 1;
>   	shost->max_cmd_len = 16;
> -	shost->sg_tablesize = min_t(u16, SG_ALL, HISI_SAS_SGE_PAGE_CNT);
>   	if (hisi_hba->hw->slot_index_alloc) {
>   		shost->can_queue = hisi_hba->hw->max_command_entries;
>   		shost->cmd_per_lun = hisi_hba->hw->max_command_entries;
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> index d24342b..2d035cc 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> @@ -1815,7 +1815,7 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
>   	.change_queue_depth	= sas_change_queue_depth,
>   	.bios_param		= sas_bios_param,
>   	.this_id		= -1,
> -	.sg_tablesize		= SG_ALL,
> +	.sg_tablesize		= HISI_SAS_SGE_PAGE_CNT,
>   	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
>   	.use_clustering		= ENABLE_CLUSTERING,
>   	.eh_device_reset_handler = sas_eh_device_reset_handler,
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index e78a97e..79e58a7 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -3570,7 +3570,7 @@ struct device_attribute *host_attrs_v2_hw[] = {
>   	.change_queue_depth	= sas_change_queue_depth,
>   	.bios_param		= sas_bios_param,
>   	.this_id		= -1,
> -	.sg_tablesize		= SG_ALL,
> +	.sg_tablesize		= HISI_SAS_SGE_PAGE_CNT,
>   	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
>   	.use_clustering		= ENABLE_CLUSTERING,
>   	.eh_device_reset_handler = sas_eh_device_reset_handler,
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 7e2b020..8a08078 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -2224,7 +2224,7 @@ struct device_attribute *host_attrs_v3_hw[] = {
>   	.change_queue_depth	= sas_change_queue_depth,
>   	.bios_param		= sas_bios_param,
>   	.this_id		= -1,
> -	.sg_tablesize		= SG_ALL,
> +	.sg_tablesize		= HISI_SAS_SGE_PAGE_CNT,
>   	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
>   	.use_clustering		= ENABLE_CLUSTERING,
>   	.eh_device_reset_handler = sas_eh_device_reset_handler,
> @@ -2366,7 +2366,6 @@ struct device_attribute *host_attrs_v3_hw[] = {
>   	shost->max_lun = ~0;
>   	shost->max_channel = 1;
>   	shost->max_cmd_len = 16;
> -	shost->sg_tablesize = min_t(u16, SG_ALL, HISI_SAS_SGE_PAGE_CNT);
>   	shost->can_queue = hisi_hba->hw->max_command_entries -
>   		HISI_SAS_RESERVED_IPTT_CNT;
>   	shost->cmd_per_lun = hisi_hba->hw->max_command_entries -
> 


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
