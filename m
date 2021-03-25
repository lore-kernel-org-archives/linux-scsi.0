Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CA9C433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 04:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3FCF61A29
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 04:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhCYE4A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 00:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhCYEz6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 00:55:58 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D400C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 21:55:57 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z1so931543edb.8
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 21:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=90rTKOAl7blvuomogGnk7wgPyyfRZSfOHtIfsvjvCLs=;
        b=KmpvlV6vO6YNjsxlsKYlcJvZfBokR8ZffWbwtKt52+13Dygj3RYg9GN6E4bajHwjcZ
         X4UQeMK7mhscjyiU1cKVT8gzQd4bAXyFDPrFy18zKcKu0q8WJPmDP7gyDgA2UZjUTTdZ
         07roqmyFuNRN/XGKGTkD3LPwYNpnJq4pf8mLdWOdmf3946bb/YTLrSU+J5Sl3AtNNAD5
         NkCeTHlv2imxVJM7ZsPMGlLOxkfJToL07QONtxtXbAr/i/mwbNs/8Q10LXi97NdO1KfU
         Hm+YCR5aJHZwaQZ3B7BeCIFV67vDedf9WfxGQmk1Jzr0x3B41hP3qkvvkNZhe0bV0wrD
         XfJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=90rTKOAl7blvuomogGnk7wgPyyfRZSfOHtIfsvjvCLs=;
        b=t8hft7Peaen2hVfTptnNoFmXDeykvLgYL1nfxVrNUMz66hGzYZoC5QUAeYDrhtQxit
         8beVRD1ALvgrXJxBICUtWZ2hIcJef1XIlJ/MUqBMaE5Gjo3JSmKKDXFAWEMv9OYtn5Yc
         kdGBIeHZWkEPeIH+gWK4x0Koc5jKMV4+9q5NwdT6O9u/2BJ8yT1mSniIUjcGonGN98ne
         S4R//TF9NtcMKm1Qnvm0A3Da+p3dkjDT0snuv2TYEt42YB5rai9bKDkasLC+EjK4E+lo
         AwgZmcv0FRUSQTzapjGyzkYiAAa9cJdPvldU7wKfKxmvVISQU5YnTzRV6bUxyX1dSB4e
         Beyw==
X-Gm-Message-State: AOAM532TNcbE2xdsx4T9O3k+36g+T4Jx0CdtQ8EZj6pmTXPIgl02BtG7
        lqjybFBT4dmy/eR+H/COdEqBqpq9n7GKlD9fFj+3tVt3LXI=
X-Google-Smtp-Source: ABdhPJxYb/wV+4h0KoMMxcq7BU3OujurQORSTLkeh2xce93Awz53SH6GMwk3UB8WG5nBBMVhTg2KKTFaMFL16b6j/Wk=
X-Received: by 2002:a05:6402:3049:: with SMTP id bu9mr7122027edb.104.1616648156127;
 Wed, 24 Mar 2021 21:55:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210324170357.9765-1-Viswas.G@microchip.com> <20210324170357.9765-2-Viswas.G@microchip.com>
In-Reply-To: <20210324170357.9765-2-Viswas.G@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 25 Mar 2021 05:55:45 +0100
Message-ID: <CAMGffEnwpHJF2Hz+PWj5FbDmLgU-MysvW+5HOAV7SU1+m-X2PQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] pm80xx: Add sysfs attribute to check mpi state
To:     Viswas G <Viswas.G@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Radha Ramachandran <radha@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        John Garry <john.garry@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 24, 2021 at 5:54 PM Viswas G <Viswas.G@microchip.com> wrote:
>
> From: Vishakha Channapattan <vishakhavc@google.com>
>
> A new sysfs variable 'ctl_mpi_state' is being introduced to
> check the state of mpi.
>
> Tested: Using 'ctl_mpi_state' sysfs variable we check the mpi state
> mvae14:~# cat /sys/class/scsi_host/host*/ctl_mpi_state
> MPI-S=MPI is successfully initialized   HMI_ERR=0
> MPI-S=MPI is successfully initialized   HMI_ERR=0
>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>

> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 12035baf0997..ce4846b1377c 100644
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
> @@ -883,9 +884,40 @@ static ssize_t pm8001_show_update_fw(struct device *cdev,
>                         flash_error_table[i].err_code,
>                         flash_error_table[i].reason);
>  }
> -
>  static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
>         pm8001_show_update_fw, pm8001_store_update_fw);
> +
> +/**
> + * ctl_mpi_state_show - controller MPI state check
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
As reported by buildbot, mpiStateText should be static.
other than this it looks fine.
I see buildbot already sent a RFC fix for it.
Martin, do you prefer to have v3 for this one, or you can merge this
and the RFC fix from buildbot altogether?
Both are fine from my side.

Thanks!

> +
> +static ssize_t ctl_mpi_state_show(struct device *cdev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +       unsigned int mpidw0;
> +       int c;
> +
> +       mpidw0 = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 0);
> +       c = sysfs_emit(buf, "MPI-S=%s\t HMI_ERR=%x\n", mpiStateText[mpidw0 & 0x0003],
> +                       ((mpidw0 & 0xff00) >> 16));
> +       return c;
> +}
> +static DEVICE_ATTR_RO(ctl_mpi_state);
> +
>  struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_interface_rev,
>         &dev_attr_controller_fatal_error,
> @@ -909,6 +941,7 @@ struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_ob_log,
>         &dev_attr_ila_version,
>         &dev_attr_inc_fw_ver,
> +       &dev_attr_ctl_mpi_state,
>         NULL,
>  };
>
> --
> 2.16.3
>
