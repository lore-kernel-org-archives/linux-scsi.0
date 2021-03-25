Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD050C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 04:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A02361A28
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 04:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhCYEt7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 00:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCYEt1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 00:49:27 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1432C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 21:49:25 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w18so997896edc.0
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 21:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=casbXARY3CF+wIj4mP9Z3m2kIVpMRIeJ53T+mFOl1sY=;
        b=KDaOJvzLNDCq4pi2mrmU3vfgIrpCYGLWqn3LEARAwAfPshDb17u+Q7ayfaOxlxw/Pd
         nd7gwKdXF2BNbLli5ZPRuBqrOO9VLVfn8cjinYmFYn1WxTeKEmEx5NT4FZDBN1tmgR+y
         wNWLyFX0jGqP1KQ23PvW5b8DdI5RC6snQjhT6W4NhYQbgqnj2oLbY4lJ7fs0CXv3nUdd
         5+KCTwR2U7SgHTX2Ca3U5k0ZI+c7L7hO4qznibQEXv3KaTsseZM/3yZu3GJeS1HhS00F
         MIYrAPHEx0uxbDyOVdc3I7jO0FxWsmQr9PEMna2KcUVH5xtJeN3GSmPqRDM/7Zd0ybAC
         /mEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=casbXARY3CF+wIj4mP9Z3m2kIVpMRIeJ53T+mFOl1sY=;
        b=fDy9KZLOjctzKpUbWvD5ktkfwePLTHoA8oRlDz+VlsfRRiwHQT7jSNSZLRnsqKMfTc
         dcQPtnOQo7RdIaqRHfzElIPtHMx95YC0a4D9AwJ7/FtZ9nT3XzFBhnt2bSWaXX+jX5Zk
         woKmC3WLT9muVpWdsT3oBR6ENoOMbSNgMlYvEcbuQb4IR/OkP63Xrh+stYSoZ0Qximke
         ueTQQQMjJl06GbxvGmub2LWLn1wNS0fjLATpQdp3ybmjKW9d5jSxBHvJVvvomgpe++6e
         G+bZOcDLaF3Mn6vVvEkge5OP8iQcmsc3g1cNc9W6SyYrwM9yi16WYVqfy19KJmHbVV/R
         A+Hw==
X-Gm-Message-State: AOAM530xGsVhYhNRDjRBoezaPSOuu0hVw8/mqA0ZzwanzpmLvImFGbPT
        94DrbXs/PyRbCd/4qIkeqsCCDYBuW1LWOc9Mk+7btw==
X-Google-Smtp-Source: ABdhPJwQyW4B5m9W05hegO9Yfjy17YR5mMPY+b8DGKuY/wKowvasUBU0WOqILKbJXl4bOSmF3v0LdGdARLUwNGL9yU0=
X-Received: by 2002:a05:6402:1051:: with SMTP id e17mr7030146edu.42.1616647764759;
 Wed, 24 Mar 2021 21:49:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210324170357.9765-1-Viswas.G@microchip.com> <20210324170357.9765-3-Viswas.G@microchip.com>
In-Reply-To: <20210324170357.9765-3-Viswas.G@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 25 Mar 2021 05:49:14 +0100
Message-ID: <CAMGffEnN5nzG3_uMNjJF6BJGCaKUF1Ze4TMgaGFvO8aTjnzAMA@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] pm80xx: Add sysfs attribute to track RAAE count
To:     Viswas G <Viswas.G@microchip.com>
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
> A new sysfs variable 'ctl_raae_count' is being introduced that tells if
> the controller is alive by indicating controller ticks. If on subsequent
> run we see the ticks changing in RAAE count that indicates that
> controller is not dead.
>
> Tested: Using 'ctl_raae_count' sysfs variable we can see ticks
> incrementing
> mvae14:~# cat  /sys/class/scsi_host/host*/ctl_raae_count
> 0x00002245
> 0x00002253
> 0x0000225e
>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index ce4846b1377c..98e5b47b9bb7 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -918,6 +918,29 @@ static ssize_t ctl_mpi_state_show(struct device *cdev,
>  }
>  static DEVICE_ATTR_RO(ctl_mpi_state);
>
> +/**
> + * ctl_raae_count_show - controller raae count check
> + * @cdev: pointer to embedded class device
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' shost attribute.
> + */
> +
> +static ssize_t ctl_raae_count_show(struct device *cdev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +       unsigned int raaecnt;
> +       int c;
> +
> +       raaecnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 12);
> +       c = sysfs_emit(buf, "0x%08x\n", raaecnt);
> +       return c;
> +}
> +static DEVICE_ATTR_RO(ctl_raae_count);
> +
>  struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_interface_rev,
>         &dev_attr_controller_fatal_error,
> @@ -942,6 +965,7 @@ struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_ila_version,
>         &dev_attr_inc_fw_ver,
>         &dev_attr_ctl_mpi_state,
> +       &dev_attr_ctl_raae_count,
>         NULL,
>  };
>
> --
> 2.16.3
>
