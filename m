From: "chenxiang (M)" <chenxiang66@hisilicon.com>
Subject: Re: [PATCH plinth/topic-sas-4.18] {topost} scsi: hisi_sas: send HARD
 RESET to clear the previous affiliation of STP target port when init device
Date: Thu, 23 Aug 2018 17:18:27 +0800
Message-ID: <985900b4-535c-2bb3-65db-033d3b623cbe@hisilicon.com>
References: <1535011127-110586-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535011127-110586-1-git-send-email-chenxiang66@hisilicon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com
List-Id: linux-scsi@vger.kernel.org

Sorry, sent the wrong mail list and  please ignore the patch.

在 2018/8/23 15:58, c00284940 写道:
> If exchange SAS expander from one SAS controller to other SAS controller
> without power down, the STP target port will maintain previous affiliation and
> reject all subsequent connection requests from other STP initiator ports
> with OPEN_REJECT (STP RESOURCES BUSY).
>
> To solve this issue, send HARD RESET to clear the previous affiliation of
> STP target port according to SPL(chapter 6.19.4).
>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> ---
>   drivers/scsi/hisi_sas/hisi_sas_main.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index bb0fa24..9225138 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -612,6 +612,7 @@ static int hisi_sas_init_device(struct domain_device *device)
>   	struct hisi_sas_tmf_task tmf_task;
>   	int retry = HISI_SAS_SRST_ATA_DISK_CNT;
>   	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
> +	struct sas_phy *local_phy;
>   
>   	switch (device->dev_type) {
>   	case SAS_END_DEVICE:
> @@ -627,6 +628,14 @@ static int hisi_sas_init_device(struct domain_device *device)
>   	case SAS_SATA_PM:
>   	case SAS_SATA_PM_PORT:
>   	case SAS_SATA_PENDING:
> +		/*
> +		 * send HARD RESET to clear previous affiliation of
> +		 * STP target port
> +		 */
> +		local_phy = sas_get_local_phy(device);
> +		if (!scsi_is_sas_phy_local(local_phy))
> +			sas_phy_reset(local_phy, 1);
> +		sas_put_local_phy(local_phy);
>   		while (retry-- > 0) {
>   			rc = hisi_sas_softreset_ata_disk(device);
>   			if (!rc)
