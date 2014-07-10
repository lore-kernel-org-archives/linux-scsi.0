From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: RE: [PATCH 1/4] scsi: pm8001: fix a memory leak in nvmd_resp
Date: Thu, 10 Jul 2014 10:25:33 +0000
Message-ID: <CE2C58F938F4C44EA74FFF880BAA7E5E49DC3A45@BBYEXM02.pmc-sierra.internal>
References: <1404746401-25229-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:60353 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbaGJKZf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2014 06:25:35 -0400
In-Reply-To: <1404746401-25229-1-git-send-email-thenzl@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "xjtuwjp@gmail.com" <xjtuwjp@gmail.com>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, Viswas G <Viswas.G@pmcs.com>



On Mon, Jul 7, 2014 at 8:49 PM, Tomas Henzl <thenzl@redhat.com> wrote:
> Instead of copying information to fw_control_context free it.
>
> The task is forgotten thus also the reference to fw_control_context
> and the completion thread takes the info from virt_ptr again.

Looks good. Thanks Tomas.
Acked-by: Suresh Thiagarajan<Suresh.Thiagarajan@pmcs.com>

>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index cacb429..dc70791 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3129,7 +3129,6 @@ void pm8001_mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  void
>  pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  {
> -       struct fw_control_ex    *fw_control_context;
>         struct get_nvm_data_resp *pPayload =
>                 (struct get_nvm_data_resp *)(piomb + 4);
>         u32 tag = le32_to_cpu(pPayload->tag);
> @@ -3138,7 +3137,6 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         u32 ir_tds_bn_dps_das_nvm =
>                 le32_to_cpu(pPayload->ir_tda_bn_dps_das_nvm);
>         void *virt_addr = pm8001_ha->memoryMap.region[NVMD].virt_ptr;
> -       fw_control_context = ccb->fw_control_context;
>
>         PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Get nvm data complete!\n"));
>         if ((dlen_status & NVMD_STAT) != 0) {
> @@ -3179,13 +3177,11 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                         pm8001_printk("Get NVMD success, IR=0, dataLen=%d\n",
>                         (dlen_status & NVMD_LEN) >> 24));
>         }
> -       memcpy(fw_control_context->usrAddr,
> -               pm8001_ha->memoryMap.region[NVMD].virt_ptr,
> -               fw_control_context->len);
> -       complete(pm8001_ha->nvmd_completion);
> +       kfree(ccb->fw_control_context);
>         ccb->task = NULL;
>         ccb->ccb_tag = 0xFFFFFFFF;
>         pm8001_tag_free(pm8001_ha, tag);
> +       complete(pm8001_ha->nvmd_completion);
>  }
>
>  int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
> --
> 1.8.3.1
>
