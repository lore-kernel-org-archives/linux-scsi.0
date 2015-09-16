From: Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 08/17] Update the mmc driver to use idr helper functions.
Date: Wed, 16 Sep 2015 08:48:38 +0200
Message-ID: <CAPDyKFrkNTrufr1rQduN2o+25JF9wYp2TfPLExnvudv3VTSRbg@mail.gmail.com>
References: <cover.1442263512.git.lduncan@suse.com>
	<5e015e43f03ba302ded85e71db48a8ed6fdc1ac6.1442263512.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5e015e43f03ba302ded85e71db48a8ed6fdc1ac6.1442263512.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 15 September 2015 at 18:46, Lee Duncan <lduncan@suse.com> wrote:
> Signed-off-by: Lee Duncan <lduncan@suse.com>

Please change the prefix of the commit message header to "mmc: core"
and resend to linux-mmc.

Kind regards
Uffe

> ---
>  drivers/mmc/core/host.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 99a9c9011c50..5aa2330f074c 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -40,9 +40,8 @@ static DEFINE_SPINLOCK(mmc_host_lock);
>  static void mmc_host_classdev_release(struct device *dev)
>  {
>         struct mmc_host *host = cls_dev_to_mmc_host(dev);
> -       spin_lock(&mmc_host_lock);
> -       idr_remove(&mmc_host_idr, host->index);
> -       spin_unlock(&mmc_host_lock);
> +
> +       idr_put_index(&mmc_host_idr, &mmc_host_lock, host->index);
>         kfree(host);
>  }
>
> @@ -559,17 +558,12 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
>
>         /* scanning will be enabled when we're ready */
>         host->rescan_disable = 1;
> -       idr_preload(GFP_KERNEL);
> -       spin_lock(&mmc_host_lock);
> -       err = idr_alloc(&mmc_host_idr, host, 0, 0, GFP_NOWAIT);
> -       if (err >= 0)
> -               host->index = err;
> -       spin_unlock(&mmc_host_lock);
> -       idr_preload_end();
> +       err = idr_get_index(&mmc_host_idr, &mmc_host_lock, host);
>         if (err < 0) {
>                 kfree(host);
>                 return NULL;
>         }
> +       host->index = err;
>
>         dev_set_name(&host->class_dev, "mmc%d", host->index);
>
> --
> 2.1.4
>
