From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 5/8] scsi: ufs: creates wrapper functions for vops
Date: Wed, 19 Aug 2015 21:19:04 +0900
Message-ID: <CAC5umyitsmWFddSzGiHHvPH7Jyer3CeMfbE1QJbwRTugN2VcEQ@mail.gmail.com>
References: <1439720057-9186-1-git-send-email-ygardi@codeaurora.org>
	<1439720057-9186-6-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1439720057-9186-6-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-08-16 19:14 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> In order to simplify the code a set of wrapper functions is created
> to test and call each of the variant operations.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufs-qcom.c |   3 +-
>  drivers/scsi/ufs/ufshcd.c   | 104 +++++++++++++++++---------------------------
>  drivers/scsi/ufs/ufshcd.h   |  98 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 138 insertions(+), 67 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 64c54b7..a6b7e10 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1036,7 +1036,7 @@ void ufs_qcom_clk_scale_notify(struct ufs_hba *hba)
>   * The variant operations configure the necessary controller and PHY
>   * handshake during initialization.
>   */
> -static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
> +static struct ufs_hba_variant_ops ufs_hba_qcom_vops = {

Why do we need to drop 'const'?

>         .name                   = "qcom",
>         .init                   = ufs_qcom_init,
>         .exit                   = ufs_qcom_exit,
> @@ -1049,6 +1049,5 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
>         .suspend                = ufs_qcom_suspend,
>         .resume                 = ufs_qcom_resume,
>  };
> -EXPORT_SYMBOL(ufs_hba_qcom_vops);

In patch 8, ufs_hba_qcom_vops is exported again...
