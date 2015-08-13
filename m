From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH V2 2/8] pm80xx: Corrected device state changes in I_T_Nexus_Reset.
Date: Thu, 13 Aug 2015 14:43:49 +0200
Message-ID: <CAMGffEmt82v3jw0mY8bg+ikmjCJYpROQ7KMPMtBOASMX2OePpA@mail.gmail.com>
References: <1439285792-12030-1-git-send-email-Viswas.G@pmcs.com> <1439285792-12030-3-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35057 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbbHMMoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2015 08:44:10 -0400
Received: by wicne3 with SMTP id ne3so138022759wic.0
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 05:44:08 -0700 (PDT)
In-Reply-To: <1439285792-12030-3-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@pmcs.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, Hannes Reinecke <hare@suse.com>

Hi

On Tue, Aug 11, 2015 at 11:36 AM,  <Viswas.G@pmcs.com> wrote:
> From: Viswas G <Viswas.G@pmcs.com>
>
> In Nexus reset the device state request are not needed.
>
> Changes from V1:
> Device state change request has been removed as the firmware
> will handle it during internal cleanup. Also updated the
> proper return value in case of failures.

If above is true, should we remove the device state change command
support at all?

Other than that, please feel free to add:
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>

Thanks
Jack


>
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
>
> Reviewed-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c |   18 +++++++++++++-----
>  drivers/scsi/pm8001/pm8001_sas.h |    8 ++++++++
>  2 files changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/p=
m8001_sas.c
> index b93f289..48f4627 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -975,19 +975,27 @@ int pm8001_I_T_nexus_reset(struct domain_device=
 *dev)
>         phy =3D sas_get_local_phy(dev);
>
>         if (dev_is_sata(dev)) {
> -               DECLARE_COMPLETION_ONSTACK(completion_setstate);
>                 if (scsi_is_sas_phy_local(phy)) {
>                         rc =3D 0;
>                         goto out;
>                 }
>                 rc =3D sas_phy_reset(phy, 1);
> +               if (rc) {
> +                       PM8001_EH_DBG(pm8001_ha,
> +                       pm8001_printk("phy reset failed for device %x=
\n"
> +                       "with rc %d\n", pm8001_dev->device_id, rc));
> +                       rc =3D TMF_RESP_FUNC_FAILED;
> +                       goto out;
> +               }
>                 msleep(2000);
>                 rc =3D pm8001_exec_internal_task_abort(pm8001_ha, pm8=
001_dev ,
>                         dev, 1, 0);
> -               pm8001_dev->setds_completion =3D &completion_setstate=
;
> -               rc =3D PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
> -                       pm8001_dev, 0x01);
> -               wait_for_completion(&completion_setstate);
> +               if (rc) {
> +                       PM8001_EH_DBG(pm8001_ha,
> +                       pm8001_printk("task abort failed %x\n"
> +                       "with rc %d\n", pm8001_dev->device_id, rc));
> +                       rc =3D TMF_RESP_FUNC_FAILED;
> +               }
>         } else {
>                 rc =3D sas_phy_reset(phy, 1);
>                 msleep(2000);
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/p=
m8001_sas.h
> index 8dd8b78..c9736cc 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -569,6 +569,14 @@ struct pm8001_fw_image_header {
>  #define        NCQ_READ_LOG_FLAG                       0x80000000
>  #define        NCQ_ABORT_ALL_FLAG                      0x40000000
>  #define        NCQ_2ND_RLE_FLAG                        0x20000000
> +
> +/* Device states */
> +#define DS_OPERATIONAL                         0x01
> +#define DS_PORT_IN_RESET                       0x02
> +#define DS_IN_RECOVERY                         0x03
> +#define DS_IN_ERROR                            0x04
> +#define DS_NON_OPERATIONAL                     0x07
> +
>  /**
>   * brief param structure for firmware flash update.
>   */
> --
> 1.7.1
>



--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 5770083-42
=46ax: +49 30 5770085-98
Email: jinpu.wang@profitbricks.com
URL: http://www.profitbricks.de

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Gesch=C3=A4ftsf=C3=BChrer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
