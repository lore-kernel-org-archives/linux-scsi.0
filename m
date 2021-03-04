Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F77C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C7F164F11
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbhCDJ3e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237580AbhCDJ30 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 04:29:26 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE79C061574
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 01:28:45 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b7so20336639edz.8
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 01:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nqP9p4jHLEVi5/r+9y8R9iz9TsL8F0zfJsiTTi5zXbY=;
        b=DWeDPhaVfrbDq2ATs0vw4/scxan4QDai51tVIrZmr+1D3AypcM+PDtnGkHPc0VbFnw
         29QnlyTZ7js9gaOU+fsgwIOUehKgYkZnRDK8tcVAzZExZgWcYptKSOk12NIH0Qs3U886
         uR/quQMYxxBpxY0RPSoUpRqZEJr/lsVz+Nhx5xuYoK+5VdEBNLZRQE9ewClwfRiyeRJR
         9Jycvev28xAcoXQ/hoZFYaas4xx1mPRTBgyn1EblLwfyNYgBijXTe78cfpCtso036e8V
         HhZ0B7pES8cSb4Thlh6peXxODhAZ3HiQYGSUm7g9W/6DjxdsSplfz0zYrEm5qsZ1cgSZ
         AnZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nqP9p4jHLEVi5/r+9y8R9iz9TsL8F0zfJsiTTi5zXbY=;
        b=LUYkrQNYQE56VBhyllzijBkzN22Dx25opztmgsptEGVHXC9XMQx7FcHILAt2WSOTFZ
         wPl/MA4Dq0Ez92jBfDbdtyxsTpyfjhgMFRGsmX0KDhWDTyZww4YHjAHSG0Rqukm+N0L7
         sFXyhtB/YfPesT+DZPVNgYE9TnsCqFVm8v4K7/TtwHICRm0SIe4YP49GD6zhwcNjUIgv
         V8pxJZI9dvnAzNYZuUYy6922nKwXMyZKQk4eY+JjZh9n2FQxKRFsQBdU/b1qaOeH+JSR
         Vk6N4BVbUvz8mHKvbicHiE/cn1Nm1uuhvEcvKGjfaKR3yOt3Lku4jz3vr6d8E5oRDDSg
         fE6g==
X-Gm-Message-State: AOAM532Wtb+vDpwhhuoiU2PjSTyKdXBJ8/PoUsnU4tQ0udj7bLW2R+hX
        JsHFcD0uJOx7FckNhORIdxGaEU0g6jlSPzbIt6bd3g==
X-Google-Smtp-Source: ABdhPJwG0qnS/YvY4eODebxD+lQ6OcLbhn6e/Yds6u6aSyAIVAxk26QwOUpuGNTIxf4uRDApj1Jaio6YSeVHz6jOt78=
X-Received: by 2002:a05:6402:3049:: with SMTP id bu9mr3382325edb.104.1614850124421;
 Thu, 04 Mar 2021 01:28:44 -0800 (PST)
MIME-Version: 1.0
References: <20210224155802.13292-1-Viswas.G@microchip.com> <20210224155802.13292-4-Viswas.G@microchip.com>
In-Reply-To: <20210224155802.13292-4-Viswas.G@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 10:28:33 +0100
Message-ID: <CAMGffEmfiAaXPi3B+8SrLHEhByCMrdO-EwUp=e87y==+rmL=Jw@mail.gmail.com>
Subject: Re: [PATCH 3/7] pm80xx: Add sysfs attribute to track iop0 count
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
> A new sysfs variable 'ctl_iop0_count' is being introduced that tells if
> the controller is alive by indicating controller ticks. If on subsequent
> run we see the ticks changing that indicates that controller is not
> dead.
>
> Tested: Using 'ctl_iop0_count' sysfs variable we can see ticks
> incrementing
> mvae14:~# cat  /sys/class/scsi_host/host*/ctl_iop0_count
> IOP0TCNT=0x000000a3
> IOP0TCNT=0x000001db
> IOP0TCNT=0x000001e4
> IOP0TCNT=0x000001e7
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
> index d415bb12718c..8470bce2cee1 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -943,6 +943,30 @@ static ssize_t ctl_raae_count_show(struct device *cdev,
>  }
>  static DEVICE_ATTR_RO(ctl_raae_count);
>
> +/**
> + * ctl_iop0_count_show - controller iop0 count check
> + * @cdev: pointer to embedded class device
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' shost attribute.
> + */
> +
> +static ssize_t ctl_iop0_count_show(struct device *cdev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +       unsigned int iop0cnt = 0;
> +       int c;
> +
> +       pm8001_dbg(pm8001_ha, IOCTL, "%s\n", __func__);
> +       iop0cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 16);
> +       c = sprintf(buf, "IOP0TCNT=0x%08x\n", iop0cnt);
> +       return c;
> +}
New file should use  sysfs_emit instead of sprintf.
> +static DEVICE_ATTR_RO(ctl_iop0_count);
> +
>  struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_interface_rev,
>         &dev_attr_controller_fatal_error,
> @@ -968,6 +992,7 @@ struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_inc_fw_ver,
>         &dev_attr_ctl_mpi_state,
>         &dev_attr_ctl_raae_count,
> +       &dev_attr_ctl_iop0_count,
>         NULL,
>  };
>
> --
> 2.16.3
>
