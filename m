From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/7] scsi: hisi_sas: modify some values of ITCT table
Date: Thu, 19 Jan 2017 09:44:27 +0100
Message-ID: <20170119084337.GF5054@linux-x5ow.site>
References: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
 <1484757173-235951-3-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484757173-235951-3-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 19, 2017 at 12:32:48AM +0800, John Garry wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> Set SMP connection timeout and continue AWT timer;
> Clear ITCT table when dev gone.
> 
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index 6c787eb..452e329 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -334,6 +334,8 @@
>  #define ITCT_HDR_MCR_MSK		(0xf << ITCT_HDR_MCR_OFF)
>  #define ITCT_HDR_VLN_OFF		9
>  #define ITCT_HDR_VLN_MSK		(0xf << ITCT_HDR_VLN_OFF)
> +#define ITCT_HDR_SMP_TIMEOUT_OFF	16
> +#define ITCT_HDR_AWT_CONTINUE_OFF	25
>  #define ITCT_HDR_PORT_ID_OFF		28
>  #define ITCT_HDR_PORT_ID_MSK		(0xf << ITCT_HDR_PORT_ID_OFF)
>  /* qw2 */
> @@ -696,6 +698,8 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
>  	qw0 |= ((1 << ITCT_HDR_VALID_OFF) |
>  		(device->linkrate << ITCT_HDR_MCR_OFF) |
>  		(1 << ITCT_HDR_VLN_OFF) |
> +		(0xfa << ITCT_HDR_SMP_TIMEOUT_OFF) |
                 ^~ You may want to give that magic value a name.

Other than that,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
