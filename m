From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] scsi: gdth: Only call dma_free_coherent when buf is not
 NULL in ioc_general
Date: Fri, 8 Mar 2019 13:14:25 -0800
Message-ID: <CAKwvOd=PZUW1U0KiBgn8z8ReHeRX=s8xEtS7Gebf9-AXxguNNQ@mail.gmail.com>
References: <20190307231839.3330-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190307231839.3330-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Achim Leubner <achim_leubner@adaptec.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, clang-built-linux@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 7, 2019 at 3:19 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> When building with -Wsometimes-uninitialized, Clang warns:
>
> drivers/scsi/gdth.c:3662:6: warning: variable 'paddr' is used
> uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
>
> Don't attempt to call dma_free_coherent when buf is NULL (meaning that
> we never called dma_alloc_coherent and initialized paddr), which avoids
> this warning.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/402
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/scsi/gdth.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index e7f1dd4f3b66..0ca9b4393770 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -3697,8 +3697,9 @@ static int ioc_general(void __user *arg, char *cmnd)
>
>         rval = 0;
>  out_free_buf:
> -       dma_free_coherent(&ha->pdev->dev, gen.data_len + gen.sense_len, buf,
> -                       paddr);
> +       if (buf)
> +               dma_free_coherent(&ha->pdev->dev, gen.data_len + gen.sense_len,
> +                                 buf, paddr);
>         return rval;
>  }
>
> --
> 2.21.0
>

Alternatively, paddr is a dma_addr_t defined in include/linux/types.h:

#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
typedef u64 dma_addr_t;
#else
typedef u32 dma_addr_t;
#endif

Just initializing it to zero might be simpler than complicating the
control flow of this function further. Thoughts?

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index e7f1dd4f3b66..5a3f849ebf64 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3643,7 +3643,7 @@ static int ioc_general(void __user *arg, char *cmnd)
        gdth_ioctl_general gen;
        gdth_ha_str *ha;
        char *buf = NULL;
-       dma_addr_t paddr;
+       dma_addr_t paddr = 0U;
        int rval;

        if (copy_from_user(&gen, arg, sizeof(gdth_ioctl_general)))
-- 
Thanks,
~Nick Desaulniers
