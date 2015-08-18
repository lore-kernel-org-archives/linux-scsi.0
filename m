From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 8/8] scsi: ufs-qcom: add QUniPro hardware support and
 power optimizations
Date: Tue, 18 Aug 2015 23:15:30 +0900
Message-ID: <CAC5umyh-V_95zy_d_Z3h_q-OxadHpAGBaKJrGAV+=EJ-w_T27w@mail.gmail.com>
References: <1439720057-9186-1-git-send-email-ygardi@codeaurora.org>
	<1439720057-9186-9-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1439720057-9186-9-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: robherring2@gmail.com, Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Hi Yaniv,

2015-08-16 19:14 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> @@ -708,17 +713,18 @@ static inline u32 ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba)
>         return ufshcd_readl(hba, REG_UFS_VERSION);
>  }
>
> -static inline void ufshcd_vops_clk_scale_notify(struct ufs_hba *hba)
> +static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
> +                                               bool up, bool status)
>  {
>         if (hba->vops && hba->vops->clk_scale_notify)
> -               return hba->vops->clk_scale_notify(hba);
> +               return hba->vops->clk_scale_notify(hba, up, status);
> +       return 0;
>  }

The third argument of clk_scale_notify() vops is PRE_CHANGE or
POST_CHANGE.  So should it also be converted from bool to enum
ufs_notify_change_status like other vops does?
