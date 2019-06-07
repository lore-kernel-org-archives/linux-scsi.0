From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH -next] scsi: megaraid_sas: remove set but not used
 variables 'buff_addr' and 'ci_h'
Date: Fri, 7 Jun 2019 12:09:55 +0530
Message-ID: <CAL2rwxpg7b8H1+xxNgw4tw2yOnNhxRfsnwfxUPA5b93ajvX9Hw@mail.gmail.com>
References: <20190525124006.21284-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190525124006.21284-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, May 25, 2019 at 6:10 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fixes gcc '-Wunused-but-set-variable' warnings:
>
> drivers/scsi/megaraid/megaraid_sas_base.c: In function megasas_fw_crash_buffer_show:
> drivers/scsi/megaraid/megaraid_sas_base.c:3138:16: warning: variable buff_addr set but not used [-Wunused-but-set-variable]
> drivers/scsi/megaraid/megaraid_sas_base.c: In function megasas_get_pd_list:
> drivers/scsi/megaraid/megaraid_sas_base.c:4426:13: warning: variable ci_h set but not used [-Wunused-but-set-variable]
>
> 'buff_addr' is never used since inroduction in
> commit fc62b3fc9021 ("megaraid_sas : Firmware crash dump feature support")
>
> 'ci_h' is not used since commit 9b3d028f3468 ("scsi: megaraid_sas:
> Pre-allocate frequently used DMA buffers")
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 39d173ed5b69..92e576228d5f 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -3135,7 +3135,6 @@ megasas_fw_crash_buffer_show(struct device *cdev,
>         struct megasas_instance *instance =
>                 (struct megasas_instance *) shost->hostdata;
>         u32 size;
> -       unsigned long buff_addr;
>         unsigned long dmachunk = CRASH_DMA_BUF_SIZE;
>         unsigned long src_addr;
>         unsigned long flags;
> @@ -3152,8 +3151,6 @@ megasas_fw_crash_buffer_show(struct device *cdev,
>                 return -EINVAL;
>         }
>
> -       buff_addr = (unsigned long) buf;
> -
>         if (buff_offset > (instance->fw_crash_buffer_size * dmachunk)) {
>                 dev_err(&instance->pdev->dev,
>                         "Firmware crash dump offset is out of range\n");
> @@ -4401,7 +4398,6 @@ megasas_get_pd_list(struct megasas_instance *instance)
>         struct megasas_dcmd_frame *dcmd;
>         struct MR_PD_LIST *ci;
>         struct MR_PD_ADDRESS *pd_addr;
> -       dma_addr_t ci_h = 0;
>
>         if (instance->pd_list_not_supported) {
>                 dev_info(&instance->pdev->dev, "MR_DCMD_PD_LIST_QUERY "
> @@ -4410,7 +4406,6 @@ megasas_get_pd_list(struct megasas_instance *instance)
>         }
>
>         ci = instance->pd_list_buf;
> -       ci_h = instance->pd_list_buf_h;
>
>         cmd = megasas_get_cmd(instance);
>
> --
> 2.17.1
>
>
