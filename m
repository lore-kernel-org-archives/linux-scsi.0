From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: RE: [PATCH 3/4] scsi: pm8001: fix a memory leak in flash_update
Date: Thu, 10 Jul 2014 10:26:02 +0000
Message-ID: <CE2C58F938F4C44EA74FFF880BAA7E5E49DC3A69@BBYEXM02.pmc-sierra.internal>
References: <1404746401-25229-3-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:60426 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989AbaGJK0E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2014 06:26:04 -0400
In-Reply-To: <1404746401-25229-3-git-send-email-thenzl@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "xjtuwjp@gmail.com" <xjtuwjp@gmail.com>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, Viswas G <Viswas.G@pmcs.com>



On Mon, Jul 7, 2014 at 8:50 PM, Tomas Henzl <thenzl@redhat.com> wrote:
> ccb->fw_control_context is copied to local fw_control_context and
> the local variable is never used later
>
> Free ccb->fw_control_context.
> The task is forgotten thus also the reference to fw_control_context
> and the completion thread takes the info from virt_ptr again.

Looks good. Thanks Tomas.
Acked-by: Suresh Thiagarajan<Suresh.Thiagarajan@pmcs.com>

>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index dc70791..05beb69 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3617,15 +3617,11 @@ int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
>                 void *piomb)
>  {
>         u32 status;
> -       struct fw_control_ex    fw_control_context;
>         struct fw_flash_Update_resp *ppayload =
>                 (struct fw_flash_Update_resp *)(piomb + 4);
>         u32 tag = le32_to_cpu(ppayload->tag);
>         struct pm8001_ccb_info *ccb = &pm8001_ha->ccb_info[tag];
>         status = le32_to_cpu(ppayload->status);
> -       memcpy(&fw_control_context,
> -               ccb->fw_control_context,
> -               sizeof(fw_control_context));
>         switch (status) {
>         case FLASH_UPDATE_COMPLETE_PENDING_REBOOT:
>                 PM8001_MSG_DBG(pm8001_ha,
> @@ -3668,11 +3664,11 @@ int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
>                         pm8001_printk("No matched status = %d\n", status));
>                 break;
>         }
> -       ccb->fw_control_context->fw_control->retcode = status;
> -       complete(pm8001_ha->nvmd_completion);
> +       kfree(ccb->fw_control_context);
>         ccb->task = NULL;
>         ccb->ccb_tag = 0xFFFFFFFF;
>         pm8001_tag_free(pm8001_ha, tag);
> +       complete(pm8001_ha->nvmd_completion);
>         return 0;
>  }
>
> @@ -4876,6 +4872,10 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>                 break;
>         }
>         rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req, 0);
> +       if (rc) {
> +               kfree(fw_control_context);
> +               pm8001_tag_free(pm8001_ha, tag);
> +       }
>         return rc;
>  }
>
> --
> 1.8.3.1
