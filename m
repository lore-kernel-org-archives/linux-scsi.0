From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] scsi: qla4xxx: Don't call dma_free_coherent without dma_alloc_coherent
Date: Thu, 7 Mar 2019 10:49:17 -0800
Message-ID: <CAKwvOdmFduT6bd7=xAsC0YcaJZL6MUUoMzmb2dW9YMGD0x4eqg@mail.gmail.com>
References: <20190307184125.21419-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190307184125.21419-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, clang-built-linux@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 7, 2019 at 10:41 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> When building with -Wsometimes-uninitialized, Clang warns:
>
> drivers/scsi/qla4xxx/ql4_os.c:5915:7: warning: variable 'buf_dma' is
> used uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
>
> buf_dma is initialized by dma_alloc_coherent, which is only called in
> the middle conditional statement. Use that same conditional to call
> dma_free_coherent so that buf_dma is always initialized when used.
>
> Fixes: 2a991c215978 ("[SCSI] qla4xxx: Boot from SAN support for open-iscsi")
> Link: https://github.com/ClangBuiltLinux/linux/issues/391
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 16a18d5d856f..88bb52456efd 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -5982,7 +5982,8 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
>                           ddb_index[1]));
>
>  exit_boot_info_free:
> -       dma_free_coherent(&ha->pdev->dev, size, buf, buf_dma);
> +       if (is_qla80XX(ha))
> +               dma_free_coherent(&ha->pdev->dev, size, buf, buf_dma);

Very tricky code flow to follow in this function, but this patch makes
sense upon closer inspection.  Thanks for the patch Nathan
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

-- 
Thanks,
~Nick Desaulniers
