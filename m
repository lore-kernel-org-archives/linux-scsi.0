Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE6EC2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 11:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D4E920863
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 11:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="JCYXCTTw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgABL6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 06:58:23 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:40936 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgABL6X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 06:58:23 -0500
Received: by mail-il1-f195.google.com with SMTP id c4so33916474ilo.7
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jan 2020 03:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G1LQRjGOBEGWq+OCen5ep4478vQYBB205MJqW76EEUw=;
        b=JCYXCTTwa4jgl82vsL0aeHnR5VztTwetUir+nsKm+XXvjz7gYTqz4eHlwhY7umFA7N
         yKD7rI+xdet3+B8lJezXFShwTK7MQvFXTr8xdi9HjgS6GLb73BqgBO4FD3JDqYd1a04Z
         G1wrIK56mCoWXIKf55uLkcDiYvDqiNS5m/iv514E6nLucIwXmbb4fZvKspOUGuFvoelg
         NVi93ucwAPcUVmaP+0bGti0cc6us6rpVUtdPtENRmTmt+l42lgOJW4uo0AWth+cSpIGh
         hhGEfYMJxHGYj9b6RDAgf1AEXvi1SRWIfHYUtiCUoy9GYjqux0PQBZVVZvvy393bvrM6
         H8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G1LQRjGOBEGWq+OCen5ep4478vQYBB205MJqW76EEUw=;
        b=ZOIeoeKOPyf9Ab22Xg43KJqCQP6D2we9sZQVPCuedtu2pV/An4iaZY2WCMlLLZE5gp
         twLnb9beKBWJuQKHmgOq2+IvVz0zXgW9z3RlAQr90O9kcdtObogxfTrCg1L/Wa2JModB
         UcME69LV00cUowaoK+UW8Ns1476Y7jpolmu2w3HkhKnoVibmPZhdW+wKTMNOJYO2ukmq
         BCYF/lg0L8mVBhBZktpbmueAJX8zaUqZDbXwhwaKg93QVpXgMHBLYpMbXhLhuZt8i+9L
         kKvtpBGahimvJ/AmDglngrZIEmF3ihK6ou67mlUMh7hN3XfFBeRlqc1wP0rJm3srDdxO
         tj8g==
X-Gm-Message-State: APjAAAXo9FbZ89Bc7kccYv7RXsowBZSvZec7bm9Bpub+Ga6yTHSWSpXu
        o6R9NnsN9rXGUGESaAP2KaGQxNSrl7Qg6GP8WZz/Aw==
X-Google-Smtp-Source: APXvYqzhsYKzxGCe+WYoZaZXTkfdN8kAKHpKV6EsHHuhA61Tdbw//1+Lc/6iY8edfU75Y9kiZ64DW4oSQAr1dIYFndE=
X-Received: by 2002:a92:af08:: with SMTP id n8mr67925797ili.217.1577966302649;
 Thu, 02 Jan 2020 03:58:22 -0800 (PST)
MIME-Version: 1.0
References: <20191224044143.8178-1-deepak.ukey@microchip.com> <20191224044143.8178-5-deepak.ukey@microchip.com>
In-Reply-To: <20191224044143.8178-5-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 2 Jan 2020 12:58:11 +0100
Message-ID: <CAMGffEkKBj4dX+KDCUtAemo0PtVLMBqVz-W+iojfAaSACNp+eg@mail.gmail.com>
Subject: Re: [PATCH 04/12] pm80xx : Cleanup initialization loading fail path.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 24, 2019 at 5:41 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Peter Chang <dpf@google.com>
>
> 1)Move the instance tracking down after we think the instance is
> good to go. avoids having a use-after free.
> 2)There are goto targets for trying to cleanup if the hw fails to
> initialize, but there's some overlap depending on who thinks they
> own the sub-structures.
>
> Signed-off-by: Peter Chang <dpf@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: Akshat Jain <akshatzen@google.com>
> Signed-off-by: Yu Zheng <yuuzheng@google.com>
The patch looks fine,
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index a002eb5a3fe4..775517f9b39d 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1016,6 +1016,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>         struct pm8001_hba_info *pm8001_ha;
>         struct Scsi_Host *shost = NULL;
>         const struct pm8001_chip_info *chip;
> +       struct sas_ha_struct *sha;
>
>         dev_printk(KERN_INFO, &pdev->dev,
>                 "pm80xx: driver version %s\n", DRV_VERSION);
> @@ -1044,12 +1045,12 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>                 goto err_out_regions;
>         }
>         chip = &pm8001_chips[ent->driver_data];
> -       SHOST_TO_SAS_HA(shost) =
> -               kzalloc(sizeof(struct sas_ha_struct), GFP_KERNEL);
> -       if (!SHOST_TO_SAS_HA(shost)) {
> +       sha = kzalloc(sizeof(struct sas_ha_struct), GFP_KERNEL);
> +       if (!sha) {
>                 rc = -ENOMEM;
>                 goto err_out_free_host;
>         }
> +       SHOST_TO_SAS_HA(shost) = sha;
>
>         rc = pm8001_prep_sas_ha_init(shost, chip);
>         if (rc) {
> @@ -1070,7 +1071,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>                         "pm8001_setup_irq failed [ret: %d]\n", rc));
>                 goto err_out_shost;
>         }
> -       list_add_tail(&pm8001_ha->list, &hba_list);
> +
>         PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
>         rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
>         if (rc) {
> @@ -1105,8 +1106,12 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>
>         pm8001_post_sas_ha_init(shost, chip);
>         rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
> -       if (rc)
> +       if (rc) {
> +               PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
> +                       "sas_register_ha failed [ret: %d]\n", rc));
>                 goto err_out_shost;
> +       }
> +       list_add_tail(&pm8001_ha->list, &hba_list);
>         scsi_scan_host(pm8001_ha->shost);
>         pm8001_ha->flags = PM8001F_RUN_TIME;
>         return 0;
> @@ -1116,7 +1121,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>  err_out_ha_free:
>         pm8001_free(pm8001_ha);
>  err_out_free:
> -       kfree(SHOST_TO_SAS_HA(shost));
> +       kfree(sha);
>  err_out_free_host:
>         scsi_host_put(shost);
>  err_out_regions:
> --
> 2.16.3
>
