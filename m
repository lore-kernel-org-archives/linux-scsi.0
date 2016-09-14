From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/15] hisi_sas: fix HBA SAS addr endianness for v2 hw
Date: Wed, 14 Sep 2016 14:49:21 +0200
Message-ID: <7e086cb7-d0f4-0099-8f90-8e55e89ada46@suse.de>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
 <1473176185-217808-11-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473176185-217808-11-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 09/06/2016 05:36 PM, John Garry wrote:
> The endianness for the SAS address in the TX_ID_DWORD
> registers is set incorrectly.
> We see errors like this in the boot log:
> [    7.583284] sas: target proto 0x0 at 50000d1108e7923f:0x1f not handled
> 
> This is due to the host SAS addr not matching the PHY SAS
> addr in the expander host-attached phy discovery responses.
> 
> To fix, we byte swap the SAS addr from BE to LE (which is
> the endianness of the SAS controller).
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index ae44443..ce84211 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -562,13 +562,13 @@ static void config_id_frame_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
>  	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD0,
>  			__swab32(identify_buffer[0]));
>  	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD1,
> -			identify_buffer[2]);
> +			__swab32(identify_buffer[1]));
>  	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD2,
> -			identify_buffer[1]);
> +			__swab32(identify_buffer[2]));
>  	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD3,
> -			identify_buffer[4]);
> +			__swab32(identify_buffer[3]));
>  	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD4,
> -			identify_buffer[3]);
> +			__swab32(identify_buffer[4]));
>  	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD5,
>  			__swab32(identify_buffer[5]));
>  }
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
