From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 14/17] scsi: ufs: tune UniPro parameters to optimize
 hibern8 exit time
Date: Thu, 22 Oct 2015 01:10:36 +0900
Message-ID: <CAC5umyhz0NHw+Q1gpLmf-O6Ub7WkQjVaNhJZzNf7kVqJS5tJ5g@mail.gmail.com>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
	<1442155977-7686-15-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442155977-7686-15-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-09-13 23:52 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> Optimal values of local UniPro parameters like PA_Hibern8Time &
> PA_TActivate can help reduce the hibern8 exit latency. If both host and
> device supports UniPro ver1.6 or later, these parameters will be
> automatically tuned during link startup itself. But if either host or
> device doesn't support UniPro ver 1.6 or later, we have to manually
> tune them. But to keep manual tuning logic simple, we will only do
> manual tuning if local unipro version doesn't support ver1.6 or later.
>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h |   1 +
>  drivers/scsi/ufs/ufshci.h |   2 +
>  drivers/scsi/ufs/unipro.h |  21 ++++++++
>  4 files changed, 145 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a8659a9..0938d6c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -596,6 +596,34 @@ static inline int ufshcd_is_hba_active(struct ufs_hba *hba)
>         return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
>  }
>
> +u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba)
> +{
> +       /* HCI version 1.0 and 1.1 supports UniPro 1.41 */
> +       if ((hba->ufs_version == UFSHCI_VERSION_10) ||
> +           (hba->ufs_version == UFSHCI_VERSION_11))
> +               return UFS_UNIPRO_VER_1_41;
> +       else
> +               return UFS_UNIPRO_VER_1_6;
> +}
> +EXPORT_SYMBOL(ufshcd_get_local_unipro_ver);
> +
> +static bool ufshcd_is_unipro_pa_params_tuning_req(struct ufs_hba *hba)
> +{
> +       /*
> +        * If both host and device support UniPro ver1.6 or later, PA layer
> +        * parameters tuning happens during link startup itself.
> +        *
> +        * We can manually tune PA layer parameters if either host or device
> +        * doesn't support UniPro ver 1.6 or later. But to keep manual tuning
> +        * logic simple, we will only do manual tuning if local unipro version
> +        * doesn't support ver1.6 or later.
> +        */
> +       if (ufshcd_get_local_unipro_ver(hba) < UFS_UNIPRO_VER_1_6)
> +               return true;
> +       else
> +               return false;
> +}
> +
>  static void ufshcd_ungate_work(struct work_struct *work)
>  {
>         int ret;
> @@ -4826,6 +4854,98 @@ out:
>  }
>
>  /**
> + * ufshcd_tune_pa_tactivate - Tunes PA_TActivate of local UniPro
> + * @hba: per-adapter instance
> + *
> + * PA_TActivate parameter can be tuned manually if UniPro version is less than
> + * 1.61. PA_TActivate needs to be greater than or equal to peerM-PHY's
> + * RX_MIN_ACTIVATETIME_CAPABILITY attribute. This optimal value can help reduce
> + * the hibern8 exit latency.
> + *
> + * Returns zero on success, non-zero error value on failure.
> + */
> +static int ufshcd_tune_pa_tactivate(struct ufs_hba *hba)
> +{
> +       int ret = 0;
> +       u32 peer_rx_min_activatetime = 0, tuned_pa_tactivate;
> +
> +       if (!ufshcd_is_unipro_pa_params_tuning_req(hba))
> +               return 0;

This ufshcd_tune_pa_tactivate() is called only when
ufshcd_is_unipro_pa_params_tuning_req() returns true.  Is this
second check needed?
