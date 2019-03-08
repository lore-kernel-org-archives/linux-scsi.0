From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v2] scsi: qla4xxx: Don't call dma_free_coherent when buf
 is NULL
Date: Fri, 8 Mar 2019 13:16:49 -0800
Message-ID: <CAKwvOdmFnnGOnbQ-0fAeOpAMDjnYnN1mkiNjbcW8uNss9cSrVg@mail.gmail.com>
References: <20190307184125.21419-1-natechancellor@gmail.com> <20190307231534.2640-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190307231534.2640-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, clang-built-linux@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 7, 2019 at 3:17 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> When building with -Wsometimes-uninitialized, Clang warns:
>
> drivers/scsi/qla4xxx/ql4_os.c:5915:7: warning: variable 'buf_dma' is
> used uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
>
> Don't call dma_free_coherent when buf is NULL, meaning that we never
> called dma_alloc_coherent and initialized buf_dma.
>
> Fixes: 2a991c215978 ("[SCSI] qla4xxx: Boot from SAN support for open-iscsi")
> Link: https://github.com/ClangBuiltLinux/linux/issues/391
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>
> v1 -> v2:
>
> * Check that buf is not NULL, which matches how dma_free_coherent is
>   called in the rest of the tree. This still fixes the warning.
>
>  drivers/scsi/qla4xxx/ql4_os.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 16a18d5d856f..9f56dafc3cda 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -5982,7 +5982,8 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
>                           ddb_index[1]));
>
>  exit_boot_info_free:
> -       dma_free_coherent(&ha->pdev->dev, size, buf, buf_dma);
> +       if (buf)
> +               dma_free_coherent(&ha->pdev->dev, size, buf, buf_dma);

Same thoughts as: https://lkml.org/lkml/2019/3/8/786
WDYT?

-- 
Thanks,
~Nick Desaulniers
