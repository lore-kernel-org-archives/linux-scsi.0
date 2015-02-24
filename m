From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v3 2/4] scsi: ufs: add debugfs for ufs
Date: Wed, 25 Feb 2015 00:10:12 +0900
Message-ID: <CAC5umygAXRyJmLPEFSTKKneicPZD4m=_RbkDfwQKoX3fvCP1Dw@mail.gmail.com>
References: <1424678898-3723-1-git-send-email-gbroner@codeaurora.org>
	<1424678898-3723-3-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1424678898-3723-3-git-send-email-gbroner@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Lee Susman <lsusman@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

2015-02-23 17:08 GMT+09:00 Gilad Broner <gbroner@codeaurora.org>:
> From: Lee Susman <lsusman@codeaurora.org>
>
> Adding debugfs capability for ufshcd.
>
> debugfs attributes introduced in this patch:
>  - View driver/controller runtime data
>  - Command tag statistics for performance analisis
>  - Dump device descriptor info
>  - Track recoverable errors statistics during runtime
>  - Change UFS power mode during runtime
>      entry a string in the format 'GGLLMM' where:
>          G - selected gear
>          L - number of lanes
>          M - power mode
>              (1=fast mode, 2=slow mode, 4=fast-auto mode,
>               5=slow-auto mode)
>      First letter is for RX, second is for TX.
>  - Get/set DME attributes

I have a few nitpick comments on this patch.

> +#ifdef CONFIG_DEBUG_FS
> +
> +#define UFSHCD_UPDATE_ERROR_STATS(hba, type)   \
> +       do {                                    \
> +               if (type < UFS_ERR_MAX) \
> +                       hba->ufs_stats.err_stats[type]++;       \
> +       } while (0)
> +
> +#define UFSHCD_UPDATE_TAG_STATS(hba, tag)                      \
> +       do {                                                    \
> +               struct request *rq = hba->lrb[task_tag].cmd ?   \
> +                       hba->lrb[task_tag].cmd->request : NULL; \
> +               u64 **tag_stats = hba->ufs_stats.tag_stats;     \
> +               int rq_type = -1;                               \
> +               if (!hba->ufs_stats.enabled)                    \
> +                       break;                                  \
> +               tag_stats[tag][TS_TAG]++;                       \
> +               if (!rq)                                        \
> +                       break;                                  \
> +               WARN_ON(hba->ufs_stats.q_depth > hba->nutrs);   \
> +               if (rq_data_dir(rq) == READ)                    \
> +                       rq_type = TS_READ;                      \
> +               else if (rq_data_dir(rq) == WRITE)              \
> +                       rq_type = TS_WRITE;                     \
> +               else if (rq->cmd_flags & REQ_FLUSH)             \
> +                       rq_type = TS_FLUSH;                     \
> +               else                                            \
> +                       break;                                  \
> +               tag_stats[hba->ufs_stats.q_depth++][rq_type]++; \
> +       } while (0)
> +
> +#define UFSHCD_UPDATE_TAG_STATS_COMPLETION(hba, cmd)           \
> +       do {                                                    \
> +               struct request *rq = cmd ? cmd->request : NULL; \
> +               if (cmd->request &&                             \
> +                               ((rq_data_dir(rq) == READ) ||   \
> +                               (rq_data_dir(rq) == WRITE) ||   \
> +                               (rq->cmd_flags & REQ_FLUSH)))   \
> +                       hba->ufs_stats.q_depth--;               \
> +       } while (0)
> +
> +#else
> +#define UFSHCD_UPDATE_TAG_STATS(hba, tag)
> +#define UFSHCD_UPDATE_TAG_STATS_COMPLETION(hba, cmd)
> +#define UFSHCD_UPDATE_ERROR_STATS(hba, type)
> +
> +#endif

Is there any reason that these are defined as macros instead of
static functions?

> @@ -5760,6 +5958,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>
>         async_schedule(ufshcd_async_scan, hba);
>
> +       ufsdbg_add_debugfs(hba);
> +
>         return 0;
>
>  out_remove_scsi_host:
> @@ -5769,6 +5969,7 @@ exit_gating:
>  out_disable:
>         hba->is_irq_enabled = false;
>         scsi_host_put(host);
> +       ufsdbg_remove_debugfs(hba);
>         ufshcd_hba_exit(hba);
>  out_error:
>         return err;

This ufsdbg_remove_debugfs() call on error path of ufshcd_init() is
unnecessary.  Because ufsdbg_add_debugfs() is called at the last of
ufshcd_init() and can't fail.
