From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 3/4] drivers/scsi/snic/snic_trc: Use vzalloc instead of vmalloc+memset
Date: Wed, 1 Aug 2018 18:33:17 +0300
Message-ID: <CAHp75Vd1=Tw+=JMSe3XTGx0jsXCW7qi+dMCo1i6RTWc-kMYH2A@mail.gmail.com>
References: <1533129976-51930-1-git-send-email-zhongjiang@huawei.com> <1533129976-51930-4-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533129976-51930-4-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Cc: John Garry <john.garry@huawei.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, aacraid@microsemi.com, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 1, 2018 at 4:26 PM, zhong jiang <zhongjiang@huawei.com> wrote:
> The vzmalloc is better than vmalloc+memset, so replace them.
>

FWIW,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/scsi/snic/snic_trc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/snic/snic_trc.c b/drivers/scsi/snic/snic_trc.c
> index fc60c93..876c490 100644
> --- a/drivers/scsi/snic/snic_trc.c
> +++ b/drivers/scsi/snic/snic_trc.c
> @@ -126,7 +126,7 @@ struct snic_trc_data *
>         int tbuf_sz = 0, ret;
>
>         tbuf_sz = (snic_trace_max_pages * PAGE_SIZE);
> -       tbuf = vmalloc(tbuf_sz);
> +       tbuf = vzmalloc(tbuf_sz);
>         if (!tbuf) {
>                 SNIC_ERR("Failed to Allocate Trace Buffer Size. %d\n", tbuf_sz);
>                 SNIC_ERR("Trace Facility not enabled.\n");
> @@ -135,7 +135,6 @@ struct snic_trc_data *
>                 return ret;
>         }
>
> -       memset(tbuf, 0, tbuf_sz);
>         trc->buf = (struct snic_trc_data *) tbuf;
>         spin_lock_init(&trc->lock);
>
> --
> 1.7.12.4
>



-- 
With Best Regards,
Andy Shevchenko
