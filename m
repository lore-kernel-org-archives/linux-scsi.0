Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1610C5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 10:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8566020869
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 10:43:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="LOybWJJy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfKFKn7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 05:43:59 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:36597 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfKFKn6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 05:43:58 -0500
Received: by mail-io1-f67.google.com with SMTP id s3so22634898ioe.3
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2019 02:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NhM3M0Q7j5MerpxlYqEZRJVEanGtWIGAaOpLV2zwLng=;
        b=LOybWJJy2lhyenPipHxFjhPbD5O60bzlGSM6ef3S6Wd5Ep7LKqs401uDVoXo84yTEf
         5EBHoruXTbw3va72VdDUVekfXB8nbEXqO+y64P+SqxZjxrtSbL84IMgSPp+bb/qvPW84
         v01CuboDcsXIBaBFasCBTOMpVaI/Vx5uz00EcVNrifPihFqy2vNG+0gq72NtrzQwg1Gc
         5dTDVwA7gqYEzZIMYMQ4YXrZPFfpS9WbPoJv1prx8K8tzEqkR28+AvEmFivwN1EEYtjW
         H768JT3sK+S9ohvdR6yMfvaBKKfcVVSWbtjLkVe1G4iXd0FAy47B5vRMjk9WK/ZoDM9D
         6MNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NhM3M0Q7j5MerpxlYqEZRJVEanGtWIGAaOpLV2zwLng=;
        b=NZq1dzY61ZPHbrMNJCZjk3DSpjcYU3PILfc/YSepKZEusXlb2wOD6S80uaoCp5iSdJ
         pDlofmLAvTZPP6SfbiBDRr7KtlQaj16HWhozhczggDMBSuXxBVYgMyixrSOvhihHiHu+
         PU6bGocqIkTmrhYBne7l0OzgWT8dEnZP0i2Ti1E9rdpGPT9qUnczbvMtZMTyE3BDVM16
         zm7nEAwhyPiI84NZohb61iG5kk7AsU/zhC2zP2KhgS0Av0TvCYT9gOY2HUZv4xazhUnP
         jHjVXn0i4pHgEoFrw4G9IrjAktzP9wRzZ0I4Xu6CKDt5x4HcNFS4PJGNJOCwouujGuRY
         Y8uw==
X-Gm-Message-State: APjAAAUcw5tx9Mgj1PqFH/+IHSmki/BVjBQOpnE0cnlkeyRssyJZ8HrR
        s3S6ztaekjxC7AQBtGyTlyKPAibbVCb2fRpdvO5y71wy
X-Google-Smtp-Source: APXvYqyjxZ/wQjnOIM1E/DMoLN3Xe1uXv3BL8NkEfqEp49OzwVstbQIOLYt9z5G3L3kQ6duqgsIrvtlswaECiOYe80M=
X-Received: by 2002:a6b:b4ca:: with SMTP id d193mr19830729iof.71.1573037036443;
 Wed, 06 Nov 2019 02:43:56 -0800 (PST)
MIME-Version: 1.0
References: <20191031051241.6762-1-deepak.ukey@microchip.com> <20191031051241.6762-10-deepak.ukey@microchip.com>
In-Reply-To: <20191031051241.6762-10-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 6 Nov 2019 11:43:45 +0100
Message-ID: <CAMGffEn_2zojD5T4acLyv+OyJf7Zoyuwcj5WKvrE5CZgrfYNOA@mail.gmail.com>
Subject: Re: [PATCH 09/12] pm80xx : Do not request 12G sas speeds.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        jsperbeck@google.com, Vikram Auradkar <auradkar@google.com>,
        ianyar@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 31, 2019 at 6:12 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: peter chang <dpf@google.com>
>
> occasionally, 6G capable drives fail to train at 6G on links that look
> good from a signal-integrity perspective. PMC suggests configuring the
> port to not even expect 12G.
>
> Signed-off-by: peter chang <dpf@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
Looks fine.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 17 +++++++++++++++++
>  drivers/scsi/pm8001/pm8001_sas.h  |  1 +
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 21 ++++-----------------
>  3 files changed, 22 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index b7cc3d05a3e0..86b619d10392 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -41,11 +41,20 @@
>  #include <linux/slab.h>
>  #include "pm8001_sas.h"
>  #include "pm8001_chips.h"
> +#include "pm80xx_hwi.h"
>
>  static ulong logging_level = PM8001_FAIL_LOGGING | PM8001_IOERR_LOGGING;
>  module_param(logging_level, ulong, 0644);
>  MODULE_PARM_DESC(logging_level, " bits for enabling logging info.");
>
> +static ulong link_rate = LINKRATE_15 | LINKRATE_30 | LINKRATE_60 | LINKRATE_120;
> +module_param(link_rate, ulong, 0644);
> +MODULE_PARM_DESC(link_rate, "Enable link rate.\n"
> +               " 1: Link rate 1.5G\n"
> +               " 2: Link rate 3.0G\n"
> +               " 4: Link rate 6.0G\n"
> +               " 8: Link rate 12.0G\n");
> +
>  static struct scsi_transport_template *pm8001_stt;
>
>  /**
> @@ -471,6 +480,14 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
>         pm8001_ha->shost = shost;
>         pm8001_ha->id = pm8001_id++;
>         pm8001_ha->logging_level = logging_level;
> +       if (link_rate >= 1 && link_rate <= 15)
> +               pm8001_ha->link_rate = (link_rate << 8);
> +       else {
> +               pm8001_ha->link_rate = LINKRATE_15 | LINKRATE_30 |
> +                       LINKRATE_60 | LINKRATE_120;
> +               PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
> +                       "Setting link rate to default value\n"));
> +       }
>         sprintf(pm8001_ha->name, "%s%d", DRV_NAME, pm8001_ha->id);
>         /* IOMB size is 128 for 8088/89 controllers */
>         if (pm8001_ha->chip_id != chip_8001)
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index d64883b80da9..f7be7b85624e 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -546,6 +546,7 @@ struct pm8001_hba_info {
>         struct tasklet_struct   tasklet[PM8001_MAX_MSIX_VEC];
>  #endif
>         u32                     logging_level;
> +       u32                     link_rate;
>         u32                     fw_status;
>         u32                     smp_exp_mode;
>         bool                    controller_fatal_error;
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 09008db2efdc..5ca9732f4704 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -37,6 +37,7 @@
>   * POSSIBILITY OF SUCH DAMAGES.
>   *
>   */
> + #include <linux/version.h>
>   #include <linux/slab.h>
>   #include "pm8001_sas.h"
>   #include "pm80xx_hwi.h"
> @@ -4565,23 +4566,9 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
>
>         PM8001_INIT_DBG(pm8001_ha,
>                 pm8001_printk("PHY START REQ for phy_id %d\n", phy_id));
> -       /*
> -        ** [0:7]       PHY Identifier
> -        ** [8:11]      link rate 1.5G, 3G, 6G
> -        ** [12:13] link mode 01b SAS mode; 10b SATA mode; 11b Auto mode
> -        ** [14]        0b disable spin up hold; 1b enable spin up hold
> -        ** [15] ob no change in current PHY analig setup 1b enable using SPAST
> -        */
> -       if (!IS_SPCV_12G(pm8001_ha->pdev))
> -               payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
> -                               LINKMODE_AUTO | LINKRATE_15 |
> -                               LINKRATE_30 | LINKRATE_60 | phy_id);
> -       else
> -               payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
> -                               LINKMODE_AUTO | LINKRATE_15 |
> -                               LINKRATE_30 | LINKRATE_60 | LINKRATE_120 |
> -                               phy_id);
>
> +       payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
> +                       LINKMODE_AUTO | pm8001_ha->link_rate | phy_id);
>         /* SSC Disable and SAS Analog ST configuration */
>         /**
>         payload.ase_sh_lm_slr_phyid =
> @@ -4594,7 +4581,7 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
>         payload.sas_identify.dev_type = SAS_END_DEVICE;
>         payload.sas_identify.initiator_bits = SAS_PROTOCOL_ALL;
>         memcpy(payload.sas_identify.sas_addr,
> -         &pm8001_ha->phy[phy_id].dev_sas_addr, SAS_ADDR_SIZE);
> +         &pm8001_ha->sas_addr, SAS_ADDR_SIZE);
>         payload.sas_identify.phy_id = phy_id;
>         ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload,
>                         sizeof(payload), 0);
> --
> 2.16.3
>
