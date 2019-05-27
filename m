From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH -next] scsi: megaraid_sas: remove set but not used
 variable 'cur_state'
Date: Mon, 27 May 2019 13:25:42 +0530
Message-ID: <CAL2rwxrnaOz-wNgK125XfO2CYhhsY43Vv1Az_QCp_wYhKmE-zA@mail.gmail.com>
References: <20190525123821.16528-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190525123821.16528-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, jejb@linux.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, May 25, 2019 at 6:08 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/scsi/megaraid/megaraid_sas_base.c: In function megasas_transition_to_ready:
> drivers/scsi/megaraid/megaraid_sas_base.c:3900:6: warning: variable cur_state set but not used [-Wunused-but-set-variable]
>
> It's not used any more since commit 7218df69e360 ("[SCSI]
> megaraid_sas: use the firmware boot timeout when waiting for commands")
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 25281a2eb424..39d173ed5b69 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -3897,7 +3897,6 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
>         int i;
>         u8 max_wait;
>         u32 fw_state;
> -       u32 cur_state;
>         u32 abs_state, curr_abs_state;
>
>         abs_state = instance->instancet->read_fw_status_reg(instance);
> @@ -3918,7 +3917,6 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
>                                    abs_state & MFI_STATE_FAULT_SUBCODE, __func__);
>                         if (ocr) {
>                                 max_wait = MEGASAS_RESET_WAIT_TIME;
> -                               cur_state = MFI_STATE_FAULT;
>                                 break;
>                         } else {
>                                 dev_printk(KERN_DEBUG, &instance->pdev->dev, "System Register set:\n");
> @@ -3944,7 +3942,6 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
>                                         &instance->reg_set->inbound_doorbell);
>
>                         max_wait = MEGASAS_RESET_WAIT_TIME;
> -                       cur_state = MFI_STATE_WAIT_HANDSHAKE;
>                         break;
>
>                 case MFI_STATE_BOOT_MESSAGE_PENDING:
> @@ -3960,7 +3957,6 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
>                                         &instance->reg_set->inbound_doorbell);
>
>                         max_wait = MEGASAS_RESET_WAIT_TIME;
> -                       cur_state = MFI_STATE_BOOT_MESSAGE_PENDING;
>                         break;
>
>                 case MFI_STATE_OPERATIONAL:
> @@ -3993,7 +3989,6 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
>                                         &instance->reg_set->inbound_doorbell);
>
>                         max_wait = MEGASAS_RESET_WAIT_TIME;
> -                       cur_state = MFI_STATE_OPERATIONAL;
>                         break;
>
>                 case MFI_STATE_UNDEFINED:
> @@ -4001,32 +3996,26 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
>                          * This state should not last for more than 2 seconds
>                          */
>                         max_wait = MEGASAS_RESET_WAIT_TIME;
> -                       cur_state = MFI_STATE_UNDEFINED;
>                         break;
>
>                 case MFI_STATE_BB_INIT:
>                         max_wait = MEGASAS_RESET_WAIT_TIME;
> -                       cur_state = MFI_STATE_BB_INIT;
>                         break;
>
>                 case MFI_STATE_FW_INIT:
>                         max_wait = MEGASAS_RESET_WAIT_TIME;
> -                       cur_state = MFI_STATE_FW_INIT;
>                         break;
>
>                 case MFI_STATE_FW_INIT_2:
>                         max_wait = MEGASAS_RESET_WAIT_TIME;
> -                       cur_state = MFI_STATE_FW_INIT_2;
>                         break;
>
>                 case MFI_STATE_DEVICE_SCAN:
>                         max_wait = MEGASAS_RESET_WAIT_TIME;
> -                       cur_state = MFI_STATE_DEVICE_SCAN;
>                         break;
>
>                 case MFI_STATE_FLUSH_CACHE:
>                         max_wait = MEGASAS_RESET_WAIT_TIME;
> -                       cur_state = MFI_STATE_FLUSH_CACHE;
>                         break;
>
>                 default:
> --
> 2.17.1
>
>
