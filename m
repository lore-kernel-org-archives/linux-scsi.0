Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8226C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 13:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 761F522AAB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 13:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbhAENf4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 08:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbhAENf4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 08:35:56 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72777C061574
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jan 2021 05:35:15 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id q22so41264069eja.2
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jan 2021 05:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YD2742TSVKiiYvW97DifzpV5YysGe+uwtt2M1aP/QnU=;
        b=EqXosLkYt2gKz6CwW8mSHlAOz3HvdAkNmcX725PCxUNeTy/sGOFBVSZgnxIbAVM8U+
         UZ9MKMGPxrddZ+VzXjHpPCkJaflXtt1hLli+I2bw24EtbR5TaYO0kBiIwKBr7HJ2xFFi
         BpAVKJjawv4lhZUGy/Or/tlvd3EZ88ic/XSIFrEyhqL5zHT637kaZvftZk/wljZGKM8X
         P9Hc/0KfJk5AZATDHYArvnskox1CeDrIOQJreHaO3ywLam5JHidUsEIN/DJbXNbe27z9
         wuH6JyFnfwEXpH+uCMY8cyQoxDK3/RwXLo87ebhp/LNv6KivRV+/aUXCXelapdAqFqaC
         jqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YD2742TSVKiiYvW97DifzpV5YysGe+uwtt2M1aP/QnU=;
        b=UNyTLPWgCR+/yaPhksQX2qhvrA+Zc8kfLDuJko+r4QNQoEe2VO3Hi4uX+pEQtw8qja
         Qg3RQIO6/P66WHdTL6Dj3uDymWhRslwnMmbIGklrmTdmgyQwciEKgOUCdO5BdmedeWlV
         LSyTsTR48lxYLQBwyYf13AqCx6y7Rglmi6huFk5rlMhAUBWKbC/uV66BlWWWS/cVqiij
         0Up0SgkKzUf3KViTA1UQiEwgJ35r8oL3yYbK+XhuRFaL28XBUP1yx2frkAsLa7wIvfSP
         Qgbvkkv0HCfaXLp7BWaDBGkQPv0RmwgaNd7QoAt87sF6g+YZnDYXL/PBJHrKuDU3GEI3
         zofA==
X-Gm-Message-State: AOAM531AndxatSguKvJ/s6iNtHLuqVTUelmn4fQnYbHhbesGL+TQLxfc
        MM3YHnZpHPrGdBto1JuRBFYguOBHWkrJzF8hriW5aw==
X-Google-Smtp-Source: ABdhPJyPbz0q2h0xYS9sWMoVOIe32V1X4afpnjIO4Z4dI7QlfugIQhrc1fqJYjsx+qJaSJSagFHQGsT0HpVnhUH7MLk=
X-Received: by 2002:a17:906:3101:: with SMTP id 1mr59088388ejx.115.1609853714227;
 Tue, 05 Jan 2021 05:35:14 -0800 (PST)
MIME-Version: 1.0
References: <20201230045743.14694-1-Viswas.G@microchip.com.com> <20201230045743.14694-9-Viswas.G@microchip.com.com>
In-Reply-To: <20201230045743.14694-9-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 5 Jan 2021 14:35:03 +0100
Message-ID: <CAMGffEkqt++GavWyyxDHdvJjU5A4Tr+H2GZLOabga7e6kmsGQg@mail.gmail.com>
Subject: Re: [PATCH 8/8] pm80xx: Add sysfs attribute for ioc health
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>, Ruksar.devadi@microchip.com,
        yuuzheng@google.com, vishakhavc@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com,
        bjashnani@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 30, 2020 at 5:48 AM Viswas G <Viswas.G@microchip.com.com> wrote:
>
> From: Vishakha Channapattan <vishakhavc@google.com>
>
> A new sysfs variable 'health' is being introduced that tells if the
> controller is alive by indicating controller ticks. If on subsequent
> run we see the ticks changing that indicates that controller is not
> dead.
>
> Tested: Using 'health' sysfs variable we can see ticks incrementing
> mvae14:~# cat  /sys/class/scsi_host/host*/health
> MPI-S= MPI is successfully initialized   HMI_ERR=0
> MSGUTCNT = 0x00000169 IOPTCNT=0x0000016a IOP1TCNT=0x0000016a
> MPI-S= MPI is successfully initialized   HMI_ERR=0
> MSGUTCNT = 0x0000014d IOPTCNT=0x0000014d IOP1TCNT=0x0000014d
> MPI-S= MPI is successfully initialized   HMI_ERR=0
> MSGUTCNT = 0x00000149 IOPTCNT=0x00000149 IOP1TCNT=0x00000149
> mvae14:~#
> mvae14:~#
> mvae14:~#
> mvae14:~# cat  /sys/class/scsi_host/host*/health
> MPI-S= MPI is successfully initialized   HMI_ERR=0
> MSGUTCNT = 0x0000016c IOPTCNT=0x0000016c IOP1TCNT=0x0000016c
> MPI-S= MPI is successfully initialized   HMI_ERR=0
> MSGUTCNT = 0x0000014f IOPTCNT=0x0000014f IOP1TCNT=0x0000014f
> MPI-S= MPI is successfully initialized   HMI_ERR=0
> MSGUTCNT = 0x0000014b IOPTCNT=0x0000014b IOP1TCNT=0x0000014b
>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thx
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 42 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 12035baf0997..f46f341132fb 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -41,6 +41,7 @@
>  #include <linux/slab.h>
>  #include "pm8001_sas.h"
>  #include "pm8001_ctl.h"
> +#include "pm8001_chips.h"
>
>  /* scsi host attributes */
>
> @@ -886,6 +887,46 @@ static ssize_t pm8001_show_update_fw(struct device *cdev,
>
>  static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
>         pm8001_show_update_fw, pm8001_store_update_fw);
> +
> +/**
> + * pm8001_ctl_health_show - controller health check
> + * @cdev: pointer to embedded class device
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' shost attribute.
> + */
> +
> +char mpiStateText[][80] = {
> +       "MPI is not initialized",
> +       "MPI is successfully initialized",
> +       "MPI termination is in progress",
> +       "MPI initialization failed with error in [31:16]"
> +};
> +
> +static ssize_t ctl_health_show(struct device *cdev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +       unsigned int mpiDW0 = 0;
> +       unsigned int raaeCnt = 0;
> +       unsigned int iop0Cnt = 0;
> +       unsigned int iop1Cnt = 0;
> +       int c;
> +
> +       pm8001_dbg(pm8001_ha, IOCTL, "%s\n", __func__);
> +       mpiDW0 = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 0);
> +       raaeCnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 12);
> +       iop0Cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 16);
> +       iop1Cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 20);
> +       c = sprintf(buf, "MPI-S=%s\t HMI_ERR=%x\nMSGUTCNT=0x%08x IOPTCNT=0x%08x IOP1TCNT=0x%08x\n",
> +                       mpiStateText[mpiDW0 & 0x0003], ((mpiDW0 & 0xff00) >> 16),
> +                       raaeCnt, iop0Cnt, iop1Cnt);
> +       return c;
> +}
> +static DEVICE_ATTR_RO(ctl_health);
> +
>  struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_interface_rev,
>         &dev_attr_controller_fatal_error,
> @@ -909,6 +950,7 @@ struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_ob_log,
>         &dev_attr_ila_version,
>         &dev_attr_inc_fw_ver,
> +       &dev_attr_ctl_health,
>         NULL,
>  };
>
> --
> 2.16.3
>
