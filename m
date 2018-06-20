From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 2/5] nbd: use __blk_mq_complete_request in timeout path
Date: Wed, 20 Jun 2018 10:13:44 -0400
Message-ID: <CAEzrpqdFZ+HkBx6YG9Y+406dBssUsikbR7yaj9BAEJsWLFL48g@mail.gmail.com>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com> <1529500964-28429-3-git-send-email-jianchao.w.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529500964-28429-3-git-send-email-jianchao.w.wang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jianchao Wang <jianchao.w.wang@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Keith Busch <keith.busch@intel.com>, ulf.hansson@linaro.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

You can add

Acked-by: Josef Bacik <josef@toxicpanda.com>

for the NBD patch.  Thanks,

Josef

On Wed, Jun 20, 2018 at 9:22 AM, Jianchao Wang
<jianchao.w.wang@oracle.com> wrote:
> To regain the capability to prevent normal completion path from
> entering a timeout request, blk_mq_mark_rq_complete is introduced
> in blk_mq_complete_request. Have to use __blk_mq_complete_request
> in timeout path to complete a timeout request.
>
> Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
> ---
>  drivers/block/nbd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index 3b7083b..d7e533a 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -354,7 +354,7 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
>         sock_shutdown(nbd);
>         nbd_config_put(nbd);
>  done:
> -       blk_mq_complete_request(req);
> +       __blk_mq_complete_request(req);
>         return BLK_EH_DONE;
>  }
>
> --
> 2.7.4
>
