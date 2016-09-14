From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/15] hisi_sas: fix phy8 linkrate calculation in
 phy_up_v2_hw()
Date: Wed, 14 Sep 2016 14:47:24 +0200
Message-ID: <70901278-d9c9-fb66-d92a-22c8ba57fd08@suse.de>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
 <1473176185-217808-8-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473176185-217808-8-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 09/06/2016 05:36 PM, John Garry wrote:
> In function phy_up_v2_hw(), we needlessly recalculate the
> phy linkrate for all phys, and the calculation is incorrect
> for phy8, so remove this code.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index aca2b80..ae44443 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -1876,9 +1876,6 @@ static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
>  		frame_rcvd[i] = __swab32(idaf);
>  	}
>  
> -	/* Get the linkrates */
> -	link_rate = hisi_sas_read32(hisi_hba, PHY_CONN_RATE);
> -	link_rate = (link_rate >> (phy_no * 4)) & 0xf;
>  	sas_phy->linkrate = link_rate;
>  	hard_phy_linkrate = hisi_sas_phy_read32(hisi_hba, phy_no,
>  						HARD_PHY_LINKRATE);
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
