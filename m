Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED9CC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 04:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87E7161A26
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 04:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhCYEuB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 00:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCYEt7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 00:49:59 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCC2C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 21:49:59 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id hq27so768189ejc.9
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 21:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8F8jXD7qIRaNkqaAtA7OCznblyIidKGGOLO19sdlVBI=;
        b=OV2U9/C+slD0nCMrxhESxpyA5bfEV6+ylD9Z5wyt3HqHEf338uz5Ch8Yz5zFlU9W4E
         +6mRxhSInCcf2ZLxP78QmDHaXkrnpMlFiHlTF1vDxVyL9r07TuK0+PHisTNLx20NfNVQ
         XKvG065MY/YniE4bnxihO5JSskuFFUyD9+pfdTMpjhjP/4Le0UKnnNA/YwgTnq+PkHSA
         SYcrU6fcMA4/6xH4/xVBQFRKPl3OaB66bTW6ldF34G8tKTHC/6JBbwNz+CKyZRZKCn95
         ooGt0k5IU5HBfqai46D0zcDjRtvjUALzm35SYBIn651ygfkT4hHPfMUlIBhHyREEQOEF
         07Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8F8jXD7qIRaNkqaAtA7OCznblyIidKGGOLO19sdlVBI=;
        b=TcM8ux4gEfxew85PfMOsTVA0eM3xbee1nQaJqwIfcHtAtesHgc60YBol0JsMCt1ZzL
         9Z2LpjilGNEUZjPhWjPner+K4GMH/l0wrbG/5rJ3ODhjea+FNOXJPcPe8VKzh7yJYVnP
         R9Tt/uoLqk+kWd+hNkX28KVwGVUkESLFWVfSk5Z4gwdUcjE0oPVpkZj4oE39iQD6LF3I
         MWr2T7symuF/UmMtpmTjrhGAnq4O6JSjGK55QpI8a2k+vG8ljapT9k+57Cdp9t1Sd3jZ
         H7IlMU/BVf9u+RgtbsQ2WnhqhpUbAPH9MKmTkhvS/DbsoKRJO8r391FcsEH7dnhbY5S+
         SPTg==
X-Gm-Message-State: AOAM533j8rNdrizolQwTRszxuHIGor2kQZVqhn74HTQxfIMKMmSZIMX1
        CEOx6/z8AAHp50T/NjKVceDhGDGDxQhiTqjliZcYng==
X-Google-Smtp-Source: ABdhPJzfH2IchWdmX716t//aIV34SwB0zcWh0qBu3ZNrK7+WCsFkz5Q4KVH7U77U5mITDRWK4Y7t9wDkH3lYg25oF48=
X-Received: by 2002:a17:906:1113:: with SMTP id h19mr7147226eja.478.1616647797768;
 Wed, 24 Mar 2021 21:49:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210324170357.9765-1-Viswas.G@microchip.com> <20210324170357.9765-5-Viswas.G@microchip.com>
In-Reply-To: <20210324170357.9765-5-Viswas.G@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 25 Mar 2021 05:49:47 +0100
Message-ID: <CAMGffEmE2MpXLVWNbX-GEJqrsmrHtQjO+1m_PkcnNofM3uDo_Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] pm80xx: Add sysfs attribute to track iop1 count
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
> A new sysfs variable 'ctl_iop1_count' is being introduced that tells if
> the controller is alive by indicating controller ticks. If on subsequent
> run we see the ticks changing that indicates that controller is not
> dead.
>
> Tested: Using 'ctl_iop1_count' sysfs variable we can see ticks
> incrementing
> mvae14:~# cat  /sys/class/scsi_host/host*/ctl_iop1_count
> 0x00000069
> 0x0000006b
> 0x0000006d
> 0x00000072
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
> index b8170da49112..78d5f573eac8 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -964,6 +964,29 @@ static ssize_t ctl_iop0_count_show(struct device *cdev,
>  }
>  static DEVICE_ATTR_RO(ctl_iop0_count);
>
> +/**
> + * ctl_iop1_count_show - controller iop1 count check
> + * @cdev: pointer to embedded class device
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' shost attribute.
> + */
> +
> +static ssize_t ctl_iop1_count_show(struct device *cdev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +       unsigned int iop1cnt;
> +       int c;
> +
> +       iop1cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 20);
> +       c = sysfs_emit(buf, "0x%08x\n", iop1cnt);
> +       return c;
> +}
> +static DEVICE_ATTR_RO(ctl_iop1_count);
> +
>  struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_interface_rev,
>         &dev_attr_controller_fatal_error,
> @@ -990,6 +1013,7 @@ struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_ctl_mpi_state,
>         &dev_attr_ctl_raae_count,
>         &dev_attr_ctl_iop0_count,
> +       &dev_attr_ctl_iop1_count,
>         NULL,
>  };
>
> --
> 2.16.3
>
