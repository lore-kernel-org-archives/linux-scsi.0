Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78E0C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAAC764F1E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237550AbhCDJ3C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237502AbhCDJ2a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 04:28:30 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1372EC061756
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 01:27:50 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id do6so48067590ejc.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 01:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tPzgvcfuQI2TTIkS6HPusvjeYhr+bcNBY0z/OD4coVM=;
        b=R6JYpfsOiR9nidZUjJjrRlFwbAZJP8DQqu6lc8kJVeLDfw5Lb/R3P5kgFnPoexIuQO
         BiFIAxgme2g5L5WB56v+i03nrrIHEyVD3uNhSFCKzOuy8gbaiWJpmh/Sou9qsYeg+tVP
         UoUcl7dFdszgl8cONA7yf/1rcOZTUCDHQ3yGAr/YU0Tg6ll5VMUxvqrqZipnzIRS2Qpl
         QB070coqG7pQF+//0zxuVg9A7T7Av+BDPS2PPWze2h1jxMpLUfspDEtXC5qnS5F1iSdX
         pnMIh/qCcu9HlHPo5Q51nOhXc4pcLob1YC+f7yWRe4840Q7gfFO6Nx380U2E02g4gb2P
         wRvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tPzgvcfuQI2TTIkS6HPusvjeYhr+bcNBY0z/OD4coVM=;
        b=lEhq3HTZG1OghWhcMQjihnyvr1b44o1phlc98AUsSvjV59P+U/SazU7yLpwTm4FqW3
         sHZRj+mMW82Mp8e0b1+j8FqVS6jjjbSf5H+ravQ+Cbj0RFp1ST68vVqebpuueLxICW8o
         4bv060FgHoWyCnNadr6aDaQOA3+I9pWmhP+fypZ7WwCi/n6fsOuHDrg5Dp6cxVxvsd3Z
         dlYAdgMMDiCFYVFV6d62egGnWdY47j0Tz8aaS11pnp7umQKvjMd2F/AN2FvbcileBTfS
         3IUKZjJE5wPgmkUUap+4QKQpCaBNAd48zsAcyTsrpKcf/WsXEywbM6Jz31AfbeslfR+b
         IAlA==
X-Gm-Message-State: AOAM533yEM/wGPWMQ7/OLV6eeUsKHXAk+xlHJk9gYQQFcSUukORmUBQv
        wmtervqpox5rYYHDTTJSXBqvhTOll6pzMKn6xGQ4bg==
X-Google-Smtp-Source: ABdhPJzExbZOBdmDX8PiD5oVV+cXTqVhSeHsbXtirlc8si3GPxmdF3nCoZAvhxNQqkauMCPUTGqAkYKds7JNlNKpu8g=
X-Received: by 2002:a17:906:d18e:: with SMTP id c14mr3107344ejz.62.1614850068851;
 Thu, 04 Mar 2021 01:27:48 -0800 (PST)
MIME-Version: 1.0
References: <20210224155802.13292-1-Viswas.G@microchip.com> <20210224155802.13292-2-Viswas.G@microchip.com>
In-Reply-To: <20210224155802.13292-2-Viswas.G@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 10:27:38 +0100
Message-ID: <CAMGffEk2cDmnyusWRmABpCLrBAe3if0U8FKz-9M3mMvE_rEGJA@mail.gmail.com>
Subject: Re: [PATCH 1/7] pm80xx: Add sysfs attribute to check mpi state
To:     Viswas G <Viswas.G@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Ruksar.devadi@microchip.com,
        Vishakha Channapattan <vishakhavc@google.com>,
        Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 24, 2021 at 4:48 PM Viswas G <Viswas.G@microchip.com> wrote:
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
>  drivers/scsi/pm8001/pm8001_ctl.c | 36 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 12035baf0997..035969ed1c2e 100644
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
> @@ -883,9 +884,41 @@ static ssize_t pm8001_show_update_fw(struct device *cdev,
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
> +
> +static ssize_t ctl_mpi_state_show(struct device *cdev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +       unsigned int mpidw0 = 0;
> +       int c;
> +
> +       pm8001_dbg(pm8001_ha, IOCTL, "%s\n", __func__);
> +       mpidw0 = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 0);
> +       c = sprintf(buf, "MPI-S=%s\t HMI_ERR=%x\n", mpiStateText[mpidw0 & 0x0003],
> +                       ((mpidw0 & 0xff00) >> 16));
> +       return c;
> +}
> +static DEVICE_ATTR_RO(ctl_mpi_state);
> +
New file should use  sysfs_emit instead of sprintf.

Thanks!
