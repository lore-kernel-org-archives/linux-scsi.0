Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0500EC33C8C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 16:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6FD6208C4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 16:35:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="CR9720X+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgAFQfh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 11:35:37 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:34799 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAFQfg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 11:35:36 -0500
Received: by mail-il1-f193.google.com with SMTP id s15so43128696iln.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jan 2020 08:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=23L59uPjIob12yoE9aXa3Hb7YdifyI3v50m7E1OIDKg=;
        b=CR9720X+DNScoccl6xxCmi3TCLGs9XN3yxyGcq/oRzLnZhm1Rac+n3xebCYdvFxIDs
         if80HpzRe4ZN3LKelAlEoFiYDzeQ4Mu3KJIYOR77uVkswfiZUGi432vFH+RWQryFMYzu
         IkiFGyxf5v0ek0+C/HmWc77rD0A/o6MGyVbJd99j1A4cpCn2xqL2aJUFVLOyu6JJ+02z
         Bx4ognDerv9rUqBCHG3ap33bro0e+q1isXmr0T3s4pi0QcGbjJppp1G68MiRiMdCL1o0
         p7RDiUgwGmT1B3+Y3nIh7Z0ZIifH/YzFoTTsGNAHOmm/LU3xaC6B2bFf6b5B/qQANKUT
         PnbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=23L59uPjIob12yoE9aXa3Hb7YdifyI3v50m7E1OIDKg=;
        b=A9XQjdbBu2tgivmMqdRRe4wHOK+Y5K8Es0mHI05DIyzRkMS9G97ZndEh/oUVJsrUvl
         pshi3FPB/0YX4K15RP5UtT7a+oXyBY/Wvfj6o07Vrfb9I8hbWKxom3a6q8RWp7aUBXs8
         lnkN9LIuNr0j8M0zBnb51LSVCugfadCvXCNs0lHU0a5TnjgSFOBhUu6tjqca20Y4F4aS
         JN51VT6Cbcl2Y2wGFRheuXboRnmchuPVgiMWyM76jYaEJbrkNxBx0zrUj1kdidZGdAP9
         NG82v/TxC9g1ewyiZ/RDiVwg8PIb3r5qEVKq9+rBdjV5mJCroW6x8gF+Ito022a+ikol
         a8aA==
X-Gm-Message-State: APjAAAV+IMnm5Qtzr2OTkJkNbjYR1xh+MWdiEgXXR17D628Jhmsqu2RA
        cz5zFYg48UBLWOkXAsm3Y5hOzw1Bv37+20QtLxmWxQ==
X-Google-Smtp-Source: APXvYqzmgeHgwt3YEylFJY36I7WpA4i4vuTm1NrnyytpMz5T1I3f2RYH9Vff0Eat+08NjNR/5B6eaT5gUkDS7pYOeWk=
X-Received: by 2002:a92:8d88:: with SMTP id w8mr88455777ill.71.1578328535959;
 Mon, 06 Jan 2020 08:35:35 -0800 (PST)
MIME-Version: 1.0
References: <20191224044143.8178-1-deepak.ukey@microchip.com> <20191224044143.8178-12-deepak.ukey@microchip.com>
In-Reply-To: <20191224044143.8178-12-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 6 Jan 2020 17:35:25 +0100
Message-ID: <CAMGffE=VgZ1RfnZcGJjgYRNJmhRWoifavo-jJZF=BMOyWP5CCw@mail.gmail.com>
Subject: Re: [PATCH 11/12] pm80xx : Introduce read and write length for IOCTL
 payload structure.
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
> From: Viswas G <Viswas.G@microchip.com>
>
> Removed the common length and introduce read and write length for
> IOCTL payload structure.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: Akshat Jain <akshatzen@google.com>
> Signed-off-by: Yu Zheng <yuuzheng@google.com>
Looks fine to me.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c  |  6 +++---
>  drivers/scsi/pm8001/pm8001_hwi.c  | 22 +++++++++++-----------
>  drivers/scsi/pm8001/pm8001_init.c | 12 ++++++------
>  drivers/scsi/pm8001/pm8001_sas.h  |  3 ++-
>  4 files changed, 22 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 669c60a8d123..63bd2a384d2e 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -486,7 +486,7 @@ static ssize_t pm8001_ctl_bios_version_show(struct device *cdev,
>         pm8001_ha->nvmd_completion = &completion;
>         payload.minor_function = 7;
>         payload.offset = 0;
> -       payload.length = 4096;
> +       payload.rd_length = 4096;
>         payload.func_specific = kzalloc(4096, GFP_KERNEL);
>         if (!payload.func_specific)
>                 return -ENOMEM;
> @@ -697,7 +697,7 @@ static int pm8001_set_nvmd(struct pm8001_hba_info *pm8001_ha)
>         payload = (struct pm8001_ioctl_payload *)ioctlbuffer;
>         memcpy((u8 *)&payload->func_specific, (u8 *)pm8001_ha->fw_image->data,
>                                 pm8001_ha->fw_image->size);
> -       payload->length = pm8001_ha->fw_image->size;
> +       payload->wr_length = pm8001_ha->fw_image->size;
>         payload->id = 0;
>         payload->minor_function = 0x1;
>         pm8001_ha->nvmd_completion = &completion;
> @@ -743,7 +743,7 @@ static int pm8001_update_flash(struct pm8001_hba_info *pm8001_ha)
>                                         IOCTL_BUF_SIZE);
>                 for (loopNumber = 0; loopNumber < loopcount; loopNumber++) {
>                         payload = (struct pm8001_ioctl_payload *)ioctlbuffer;
> -                       payload->length = 1024*16;
> +                       payload->wr_length = 1024*16;
>                         payload->id = 0;
>                         fwControl =
>                               (struct fw_control_info *)&payload->func_specific;
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index f9395d9fd530..16dc7a92ad68 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -4841,7 +4841,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>         if (!fw_control_context)
>                 return -ENOMEM;
>         fw_control_context->usrAddr = (u8 *)ioctl_payload->func_specific;
> -       fw_control_context->len = ioctl_payload->length;
> +       fw_control_context->len = ioctl_payload->rd_length;
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>         memset(&nvmd_req, 0, sizeof(nvmd_req));
>         rc = pm8001_tag_alloc(pm8001_ha, &tag);
> @@ -4862,7 +4862,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>
>                 nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | twi_addr << 16 |
>                         twi_page_size << 8 | TWI_DEVICE);
> -               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
> +               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->rd_length);
>                 nvmd_req.resp_addr_hi =
>                     cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
>                 nvmd_req.resp_addr_lo =
> @@ -4871,7 +4871,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>         }
>         case C_SEEPROM: {
>                 nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | C_SEEPROM);
> -               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
> +               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->rd_length);
>                 nvmd_req.resp_addr_hi =
>                     cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
>                 nvmd_req.resp_addr_lo =
> @@ -4880,7 +4880,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>         }
>         case VPD_FLASH: {
>                 nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | VPD_FLASH);
> -               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
> +               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->rd_length);
>                 nvmd_req.resp_addr_hi =
>                     cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
>                 nvmd_req.resp_addr_lo =
> @@ -4889,7 +4889,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>         }
>         case EXPAN_ROM: {
>                 nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | EXPAN_ROM);
> -               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
> +               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->rd_length);
>                 nvmd_req.resp_addr_hi =
>                     cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
>                 nvmd_req.resp_addr_lo =
> @@ -4898,7 +4898,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>         }
>         case IOP_RDUMP: {
>                 nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | IOP_RDUMP);
> -               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
> +               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->rd_length);
>                 nvmd_req.vpd_offset = cpu_to_le32(ioctl_payload->offset);
>                 nvmd_req.resp_addr_hi =
>                 cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
> @@ -4938,7 +4938,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>         memcpy(pm8001_ha->memoryMap.region[NVMD].virt_ptr,
>                 &ioctl_payload->func_specific,
> -               ioctl_payload->length);
> +               ioctl_payload->wr_length);
>         memset(&nvmd_req, 0, sizeof(nvmd_req));
>         rc = pm8001_tag_alloc(pm8001_ha, &tag);
>         if (rc) {
> @@ -4957,7 +4957,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>                 nvmd_req.reserved[0] = cpu_to_le32(0xFEDCBA98);
>                 nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | twi_addr << 16 |
>                         twi_page_size << 8 | TWI_DEVICE);
> -               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
> +               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->wr_length);
>                 nvmd_req.resp_addr_hi =
>                     cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
>                 nvmd_req.resp_addr_lo =
> @@ -4966,7 +4966,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>         }
>         case C_SEEPROM:
>                 nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | C_SEEPROM);
> -               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
> +               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->wr_length);
>                 nvmd_req.reserved[0] = cpu_to_le32(0xFEDCBA98);
>                 nvmd_req.resp_addr_hi =
>                     cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
> @@ -4975,7 +4975,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>                 break;
>         case VPD_FLASH:
>                 nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | VPD_FLASH);
> -               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
> +               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->wr_length);
>                 nvmd_req.reserved[0] = cpu_to_le32(0xFEDCBA98);
>                 nvmd_req.resp_addr_hi =
>                     cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
> @@ -4984,7 +4984,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>                 break;
>         case EXPAN_ROM:
>                 nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | EXPAN_ROM);
> -               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
> +               nvmd_req.resp_len = cpu_to_le32(ioctl_payload->wr_length);
>                 nvmd_req.reserved[0] = cpu_to_le32(0xFEDCBA98);
>                 nvmd_req.resp_addr_hi =
>                     cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index b74282bc1ed0..6e037638656d 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -643,22 +643,22 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
>         if (pm8001_ha->chip_id == chip_8001) {
>                 if (deviceid == 0x8081 || deviceid == 0x0042) {
>                         payload.minor_function = 4;
> -                       payload.length = 4096;
> +                       payload.rd_length = 4096;
>                 } else {
>                         payload.minor_function = 0;
> -                       payload.length = 128;
> +                       payload.rd_length = 128;
>                 }
>         } else if ((pm8001_ha->chip_id == chip_8070 ||
>                         pm8001_ha->chip_id == chip_8072) &&
>                         pm8001_ha->pdev->subsystem_vendor == PCI_VENDOR_ID_ATTO) {
>                 payload.minor_function = 4;
> -               payload.length = 4096;
> +               payload.rd_length = 4096;
>         } else {
>                 payload.minor_function = 1;
> -               payload.length = 4096;
> +               payload.rd_length = 4096;
>         }
>         payload.offset = 0;
> -       payload.func_specific = kzalloc(payload.length, GFP_KERNEL);
> +       payload.func_specific = kzalloc(payload.rd_length, GFP_KERNEL);
>         if (!payload.func_specific) {
>                 PM8001_INIT_DBG(pm8001_ha, pm8001_printk("mem alloc fail\n"));
>                 return;
> @@ -728,7 +728,7 @@ static int pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
>         /* SAS ADDRESS read from flash / EEPROM */
>         payload.minor_function = 6;
>         payload.offset = 0;
> -       payload.length = 4096;
> +       payload.rd_length = 4096;
>         payload.func_specific = kzalloc(4096, GFP_KERNEL);
>         if (!payload.func_specific)
>                 return -ENOMEM;
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 47607a25f819..917a17f4d595 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -164,10 +164,11 @@ struct pm8001_ioctl_payload {
>         u32     signature;
>         u16     major_function;
>         u16     minor_function;
> -       u16     length;
>         u16     status;
>         u16     offset;
>         u16     id;
> +       u32     wr_length;
> +       u32     rd_length;
>         u8      *func_specific;
>  };
>
> --
> 2.16.3
>
