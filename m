Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9AD8C43381
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6F3064F37
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237578AbhCDJaH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237607AbhCDJ3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 04:29:49 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AFFC061756
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 01:29:08 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b7so20338281edz.8
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 01:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UrUsmWGhK4JOAMP64Y5r1A+7vainQFyyLGUprGMCFHY=;
        b=dsOVMv2RfijGqsced5x2CQ0X0v45hApygHVTpNfGLfFf18V/QBbt9QXs6Vj9iBtsWa
         6q2wWAZhVUCvZQWjH6bukgeG0karJm9/51qa3RKEGfUnjIVu11/6+ghbF4d1T9XNV3gD
         ZzyyGxZyIVX44cCqkVt8diwtj9DeCE67sE+bJsJOIp/sPuGv259Prp1SD798WK4svfLs
         xhr6qAarBz0MuhWPnTvQTlTbufNa431/JrjmuP+ZizPnO1fHPt+sei2PyEd1f52Y9rf3
         L9Jer4NzzwwIO0MfevfLDhf7KjoUdmIqZbdd0weLDGImz+v7pdP1+oLEsctzqqrxsudu
         mETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UrUsmWGhK4JOAMP64Y5r1A+7vainQFyyLGUprGMCFHY=;
        b=uBoQKG43BrcUhm7y/L8PEyZU/6qa7yfj02SO9O6i0xTHQc9ScIkrbryZ5fARpSeK6A
         4jFFRePHAGOMAuxRKKGra2uONLnRsIKxNvChesPtgdZK44oGtK8eWElQZk1B0wUFZ0WA
         qzmQkprZGVnptSiGHoNZQXcdqsSA0/b5Has7EWyR1U/J9tLaxjt2EwlWupffinhZEtSh
         aQ0ysKu2BwN9XXheg+VKfNYRnWHUaIupJR0bLKP4Ctu08gLSLsdaXsO/yk11VAVaoG/c
         KN/mlG1tlsmbdNmsVfrPZClHJFIORIH2+7kzn+KSbksRm2f/bdEfofZXtXnJ3ngOkagY
         g89A==
X-Gm-Message-State: AOAM531eJHa7dMSggvMW9Y7OAkrFRHFHb+TIcmfdd2mlihZCSnuNbB2R
        ug6halV4vME+6uo63jU42mkiG2GxCprcYN+LejvMmg==
X-Google-Smtp-Source: ABdhPJzKOWhEepTaiV8KNfh7Tpbz9FRjUDQqXJSc1DwBbqCXDgFOsn6SVeRSJOx9SYBibZk3Gm//ufbH/loKVhjERz0=
X-Received: by 2002:a05:6402:ce:: with SMTP id i14mr3349566edu.42.1614850147580;
 Thu, 04 Mar 2021 01:29:07 -0800 (PST)
MIME-Version: 1.0
References: <20210224155802.13292-1-Viswas.G@microchip.com> <20210224155802.13292-3-Viswas.G@microchip.com>
In-Reply-To: <20210224155802.13292-3-Viswas.G@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 10:28:56 +0100
Message-ID: <CAMGffE=xJJ2ej79LRish2h7MftzCs3nPJWiYVNgFJb=n6-pFNQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] pm80xx: Add sysfs attribute to track RAAE count
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
> A new sysfs variable 'ctl_raae_count' is being introduced that tells if
> the controller is alive by indicating controller ticks. If on subsequent
> run we see the ticks changing in RAAE count that indicates that
> controller
> is not dead.
>
> Tested: Using 'ctl_raae_count' sysfs variable we can see ticks
> incrementing
> mvae14:~# cat  /sys/class/scsi_host/host*/ctl_raae_count
> MSGUTCNT=0x00002245
> MSGUTCNT=0x00002253
> MSGUTCNT=0x0000225e
>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 035969ed1c2e..d415bb12718c 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -919,6 +919,30 @@ static ssize_t ctl_mpi_state_show(struct device *cdev,
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
> +       unsigned int raaecnt = 0;
> +       int c;
> +
> +       pm8001_dbg(pm8001_ha, IOCTL, "%s\n", __func__);
> +       raaecnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 12);
> +       c = sprintf(buf, "MSGUTCNT=0x%08x\n", raaecnt);
> +       return c;
> +}
> +static DEVICE_ATTR_RO(ctl_raae_count);
New file should use  sysfs_emit instead of sprintf.
> +
>  struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_interface_rev,
>         &dev_attr_controller_fatal_error,
> @@ -943,6 +967,7 @@ struct device_attribute *pm8001_host_attrs[] = {
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
