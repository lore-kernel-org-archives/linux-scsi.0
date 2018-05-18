From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] scsi: dpt_i2o: Remove VLA usage
Date: Fri, 18 May 2018 08:12:29 -0700
Message-ID: <CAGXu5jJSQa8WNEOSX7qaPWnGwArx4=X01S+82DQakHP_VY23VA@mail.gmail.com>
References: <20180502222138.GA22088@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502222138.GA22088@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 2, 2018 at 3:21 PM, Kees Cook <keescook@chromium.org> wrote:
> On the quest to remove all VLAs from the kernel[1] this moves the sg_list
> variable off the stack, as already done for other allocated buffers in
> adpt_i2o_passthru(). Additionally consolidates the error path for kfree().
>
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Friendly ping! How does this look for v4.18?

Thanks!

-Kees

> ---
>  drivers/scsi/dpt_i2o.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index 5ceea8da7bb6..37de8fb186d7 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -1706,7 +1706,7 @@ static int adpt_i2o_passthru(adpt_hba* pHba, u32 __user *arg)
>         u32 reply_size = 0;
>         u32 __user *user_msg = arg;
>         u32 __user * user_reply = NULL;
> -       void *sg_list[pHba->sg_tablesize];
> +       void **sg_list = NULL;
>         u32 sg_offset = 0;
>         u32 sg_count = 0;
>         int sg_index = 0;
> @@ -1748,19 +1748,23 @@ static int adpt_i2o_passthru(adpt_hba* pHba, u32 __user *arg)
>         msg[2] = 0x40000000; // IOCTL context
>         msg[3] = adpt_ioctl_to_context(pHba, reply);
>         if (msg[3] == (u32)-1) {
> -               kfree(reply);
> -               return -EBUSY;
> +               rcode = -EBUSY;
> +               goto free;
>         }
>
> -       memset(sg_list,0, sizeof(sg_list[0])*pHba->sg_tablesize);
> +       sg_list = kcalloc(pHba->sg_tablesize, sizeof(*sg_list), GFP_KERNEL);
> +       if (!sg_list) {
> +               rcode = -ENOMEM;
> +               goto free;
> +       }
>         if(sg_offset) {
>                 // TODO add 64 bit API
>                 struct sg_simple_element *sg =  (struct sg_simple_element*) (msg+sg_offset);
>                 sg_count = (size - sg_offset*4) / sizeof(struct sg_simple_element);
>                 if (sg_count > pHba->sg_tablesize){
>                         printk(KERN_DEBUG"%s:IOCTL SG List too large (%u)\n", pHba->name,sg_count);
> -                       kfree (reply);
> -                       return -EINVAL;
> +                       rcode = -EINVAL;
> +                       goto free;
>                 }
>
>                 for(i = 0; i < sg_count; i++) {
> @@ -1879,7 +1883,6 @@ static int adpt_i2o_passthru(adpt_hba* pHba, u32 __user *arg)
>         if (rcode != -ETIME && rcode != -EINTR) {
>                 struct sg_simple_element *sg =
>                                 (struct sg_simple_element*) (msg +sg_offset);
> -               kfree (reply);
>                 while(sg_index) {
>                         if(sg_list[--sg_index]) {
>                                 dma_free_coherent(&pHba->pDev->dev,
> @@ -1889,6 +1892,10 @@ static int adpt_i2o_passthru(adpt_hba* pHba, u32 __user *arg)
>                         }
>                 }
>         }
> +
> +free:
> +       kfree(sg_list);
> +       kfree(reply);
>         return rcode;
>  }
>
> --
> 2.17.0
>
>
> --
> Kees Cook
> Pixel Security



-- 
Kees Cook
Pixel Security
