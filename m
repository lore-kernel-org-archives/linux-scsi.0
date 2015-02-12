From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 2/4] scsi: ufs: add debugfs for ufs
Date: Thu, 12 Feb 2015 22:53:44 +0900
Message-ID: <CAC5umyhX0peGYyh49rb9TPHK4=+s_UT6WFSTVv0cXpycAuu4kw@mail.gmail.com>
References: <1423576735-26267-1-git-send-email-gbroner@codeaurora.org>
	<1423576735-26267-3-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1423576735-26267-3-git-send-email-gbroner@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Lee Susman <lsusman@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

2015-02-10 22:58 GMT+09:00 Gilad Broner <gbroner@codeaurora.org>:
> @@ -5760,6 +5963,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>
>         async_schedule(ufshcd_async_scan, hba);
>
> +       UFSDBG_ADD_DEBUGFS(hba);
> +
>         return 0;
>
>  out_remove_scsi_host:
> @@ -5769,6 +5974,7 @@ exit_gating:
>  out_disable:
>         hba->is_irq_enabled = false;
>         scsi_host_put(host);
> +       UFSDBG_REMOVE_DEBUGFS(hba);
>         ufshcd_hba_exit(hba);
>  out_error:
>         return err;

UFSDBG_REMOVE_DEBUGFS() is not called in the driver unloading path.
So ufs debugfs directory is not removed when unloading driver.  It
should be called in ufshcd_remove().

BTW, do we really need UFSDBG_ADD_DEBUGFS() and UFSDBG_REMOVE_DEBUGFS()
macros?
We can use static inline functions in ufs-debugfs.h when !CONFIG_DEBUG_FS.

#ifdef CONFIG_DEBUG_FS
void ufsdbg_add_debugfs(struct ufs_hba *hba);

void ufsdbg_remove_debugfs(struct ufs_hba *hba);
#else
static inline void ufsdbg_add_debugfs(struct ufs_hba *hba)
{
}

static inline void ufsdbg_remove_debugfs(struct ufs_hba *hba)
{
}
#endif
