From: Kyuho Choi <chlrbgh0@gmail.com>
Subject: Re: [PATCH] scsi: ufs: ufshcd: Enable no_write_same for scsi host
Date: Mon, 4 Dec 2017 10:26:59 +0900
Message-ID: <CAP2JTQLuBvUOCNoT-KgcfSiBLGqJV3ZangzSnbjJGgH=hfQMFA@mail.gmail.com>
References: <20171130041907.4417-1-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171130041907.4417-1-bjorn.andersson@linaro.org>
Sender: stable-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Anderson,

Could you please check about below thread?

https://patchwork.kernel.org/patch/6357751/

Your patch is same as my old one.

On 11/30/17, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> Occasionally the following error message can be seen in the logs of
> Qualcomm devices using UFS:
>
> EXT4-fs (sda9): Delayed block allocation failed for inode 685600 at logical
> offset 1086 with max blocks 3 with error 121
> EXT4-fs (sda9): This should not happen!! Data will be lost
>
> This is caused by a failing WRITE_SAME command, which per the JEDEC UFS
> specification is not a supported. Set the no_write_same flag on the
> ufshcd SCSI host to let the SCSI layer know this.
>
> Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 88c086f5c4e3..e5b1efd1dafd 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6515,6 +6515,7 @@ static struct scsi_host_template
> ufshcd_driver_template = {
>  	.can_queue		= UFSHCD_CAN_QUEUE,
>  	.max_host_blocked	= 1,
>  	.track_queue_depth	= 1,
> +	.no_write_same		= 1,
>  };
>
>  static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg
> *vreg,
> --
> 2.15.0
>
>

WBR,
Kyuho Choi
