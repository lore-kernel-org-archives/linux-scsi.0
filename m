From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH -next] scsi: megaraid_sas: remove set but not used
 variables 'host' and 'wait_time'
Date: Mon, 27 May 2019 13:30:59 +0530
Message-ID: <CAL2rwxrmVuTsR=JY4h5agyTPMdsZA1xgvdC09O9XV3gDMTm2BQ@mail.gmail.com>
References: <20190525124202.8120-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190525124202.8120-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, jejb@linux.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, May 25, 2019 at 6:14 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fixes gcc '-Wunused-but-set-variable' warnings:
>
> drivers/scsi/megaraid/megaraid_sas_base.c: In function megasas_suspend:
> drivers/scsi/megaraid/megaraid_sas_base.c:7269:20: warning: variable host set but not used [-Wunused-but-set-variable]
> drivers/scsi/megaraid/megaraid_sas_base.c: In function megasas_aen_polling:
> drivers/scsi/megaraid/megaraid_sas_base.c:8397:15: warning: variable wait_time set but not used [-Wunused-but-set-variable]
>
> 'host' is never used since introduction in
> commit 31ea7088974c ("[SCSI] megaraid_sas: add hibernation support")
>
> 'wait_time' is not used since commit
> 11c71cb4ab7c ("megaraid_sas: Do not allow PCI access during OCR")
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 92e576228d5f..ed0f6ca578e5 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -7239,11 +7239,9 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
>  static int
>  megasas_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
> -       struct Scsi_Host *host;
>         struct megasas_instance *instance;
>
>         instance = pci_get_drvdata(pdev);
> -       host = instance->host;
>         instance->unload = 1;
>
>         dev_info(&pdev->dev, "%s is called\n", __func__);
> @@ -8367,7 +8365,7 @@ megasas_aen_polling(struct work_struct *work)
>         struct megasas_instance *instance = ev->instance;
>         union megasas_evt_class_locale class_locale;
>         int event_type = 0;
> -       u32 seq_num, wait_time = MEGASAS_RESET_WAIT_TIME;
> +       u32 seq_num;
>         int error;
>         u8  dcmd_ret = DCMD_SUCCESS;
>
> @@ -8377,10 +8375,6 @@ megasas_aen_polling(struct work_struct *work)
>                 return;
>         }
>
> -       /* Adjust event workqueue thread wait time for VF mode */
> -       if (instance->requestorId)
> -               wait_time = MEGASAS_ROUTINE_WAIT_TIME_VF;
> -
>         /* Don't run the event workqueue thread if OCR is running */
>         mutex_lock(&instance->reset_mutex);
>
> --
> 2.17.1
>
>
