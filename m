Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E871EC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 17:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B65B561026
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 17:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbhCaRcD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 13:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhCaRbc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 13:31:32 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D642C061574
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 10:31:31 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id e14so31220905ejz.11
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 10:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QpifQQEpvkV/06N3VyEOksnviAFVtmLBYUDM+GpQil4=;
        b=ez34K6WQryCmaKEgyxBL7DxKZgcz6JMIr8RbSw7xnlaAVDt0MoA0qkAD6DHfOyVaS9
         mCMIb2EylbXkERqoFZriqiyoO5HHe3DRkwcQ0YM6/I+za6zWexhBI7qm2dRCIlS919LF
         m/OJwLa2a0VufE4XoHxPUxaLWZXXTKrdrAPmqYJyx2l3AFoHhhxPmsxvFyl9DKtPqswF
         1Z3X+tw/4CCH4sAXRbEAMHEyxOWUjRE+vbKoepDdMFpXxeRQGFUqc3oTpNY2vmkAm8lw
         JGmY7XumLqgWwPUX7Trj2UibRJzfQ9r2zMAEk+e2163KF5qK6DvXxpWJakq17MGPb1cB
         4k5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QpifQQEpvkV/06N3VyEOksnviAFVtmLBYUDM+GpQil4=;
        b=hXLFc0iTnAUqFnKyAKVRayImTHqI2J3PdFg3OfPMG5aLoWS/pn9gr62BdSsK2ASVHt
         wN/YU4UMr8zDeiqmPdKeWSdACKXBd9T8re+mNHNmZsHkduIrFQ206NHiZJ+aSE0uYXct
         10+lCzq1zGTLckdC20d1+uZh6UxvLYz4VJ4Ya1q5+l2Btt0/BUCSWxEMDdsT1yZE6aIC
         3ko5TXdB+cZ58onNq39mLs2kjZryowhoorcoMyabFR9d9sjB+M91zrNKElKavAS4WifE
         4AS6FkMysxm9MKHkThY+N/VbIgK3fAucT4uzUPlUuXis3TjQzx9hNR5dG+l+e18VHvFN
         Ij8w==
X-Gm-Message-State: AOAM533r9HCL6NcrN1v1x48XQ3LJDO6AWj6/sDj5oeKWIOevxZWMxujW
        DPrTmCWEglILQJlkZXmbab1SMOQto2tCKRJ6glmtlA==
X-Google-Smtp-Source: ABdhPJzx+nknyxSv5Tzr3/4cwhsII1AkDayx9I+jvp0Dy9nXKdHJ4sizysxKMZjInsHXi77InoNXKZX8r4+4ihFOSfE=
X-Received: by 2002:a17:906:18a1:: with SMTP id c1mr4626941ejf.62.1617211890239;
 Wed, 31 Mar 2021 10:31:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210330064008.9666-1-Viswas.G@microchip.com> <20210330064008.9666-2-Viswas.G@microchip.com>
In-Reply-To: <20210330064008.9666-2-Viswas.G@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 31 Mar 2021 19:31:19 +0200
Message-ID: <CAMGffE=kZFHPWwwqjkUSZM0hRqiHpJY7NssKePHCsGUKAbABbA@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] pm80xx: Add sysfs attribute to check mpi state
To:     Viswas G <Viswas.G@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Radha Ramachandran <radha@google.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        John Garry <john.garry@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 30, 2021 at 8:30 AM Viswas G <Viswas.G@microchip.com> wrote:
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
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: kernel test robot <lkp@intel.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 12035baf0997..6b6b774c455e 100644
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
> +static char mpiStateText[][80] = {
> +       "MPI is not initialized",
> +       "MPI is successfully initialized",
> +       "MPI termination is in progress",
> +       "MPI initialization failed with error in [31:16]"
> +};
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
> +                       (mpidw0 >> 16));
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
