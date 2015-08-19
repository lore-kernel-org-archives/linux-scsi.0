From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 8/8] scsi: ufs-qcom: add QUniPro hardware support and
 power optimizations
Date: Wed, 19 Aug 2015 21:19:47 +0900
Message-ID: <CAC5umyhquEQh8O=8cz8xKTEzUcD3wKAiLd5RNzAMzEL6C9GWUA@mail.gmail.com>
References: <1439720057-9186-1-git-send-email-ygardi@codeaurora.org>
	<1439720057-9186-9-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1439720057-9186-9-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-08-16 19:14 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> @@ -1208,6 +1510,7 @@ static struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
>         .resume                 = ufs_qcom_resume,
>         .dbg_register_dump      = ufs_qcom_dump_dbg_regs,
>  };
> +EXPORT_SYMBOL(ufs_hba_qcom_vops);

As I said in the view comment for the patch 5, this shouldn't be exported again.

> @@ -775,6 +781,12 @@ static inline int ufshcd_vops_resume(struct ufs_hba *hba, enum ufs_pm_op op)
>         return 0;
>  }
>
> +static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
> +{
> +       if (hba->vops && hba->vops->dbg_register_dump)
> +               hba->vops->dbg_register_dump(hba);
> +}
> +

This change should be done in the patch 7?
