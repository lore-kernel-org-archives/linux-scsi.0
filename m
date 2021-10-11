Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB61C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 04:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B679C60F0F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 04:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhJKE4z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 00:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhJKE4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2021 00:56:54 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF7FC061570
        for <linux-scsi@vger.kernel.org>; Sun, 10 Oct 2021 21:54:55 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y12so49696256eda.4
        for <linux-scsi@vger.kernel.org>; Sun, 10 Oct 2021 21:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jDsWHaN/WjGNEa1oTtmTaaSWLUHvJVPmnv0FLvEXDnA=;
        b=h9ayGvom5qDzrjmV8gXcKSPFs9sJ5e0txTQ5+vCEzRCjQKDDAoDkPTxBHb0ouC7ZU0
         sCjjnc723eiI+6CjGpkNj/oZgHlxhAfa8JQPMVOF7x7WacXOSZUSRyClSgMLI/14dANT
         nSEJ9uFMTbv+mc9Un/Q7YEXUIqL8XAiX4hpdDFMSaL1P/H8UMCbjQnbaUKaRshsqWgwf
         ZWFKJqVAstVpMsNEl5VzJLeu5W0HjvnklZOSqMPv/lmdEJRKjmq5201JLjcmy9peYvN/
         VNmv7OkTmE+OzNwWvcB7FbiN7hesgGN/YjydjYRmSN06DuzY3mz0UcEgL51bGDPCfvoP
         l1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jDsWHaN/WjGNEa1oTtmTaaSWLUHvJVPmnv0FLvEXDnA=;
        b=W8+1bG/rvqWKAMruKljwJ4gAfyVXBW1+FBYtjptfcuDTjCKW9SeZual0Lni5z8d0Ks
         Ej8yb8T97ZIXfgE5nb8kD/70bychwGtQ6kxhTVbE95ddps2N1Dow7v24j+sd8E2TZ/WZ
         hrYyrlr7NMsqupvdCPlcLGUBTDZPuFeByN9FSoWUvdU/BsMUJ3KQ6+ex8Csm1fUQXI4g
         lQCGkc555f+IXuZV3oq3J4vz1RfsItPH9iBSbatRrgMTC76PJ0vL0Y6xZdCaNx2zZIQH
         CE0ZPuPJLVdUBmLF4bb4UGWJAQoaxxjg3hg3Dc736M8WsSzB/Aj2qfVNdVA7hxF1Thfy
         ufUw==
X-Gm-Message-State: AOAM53201oZK9gMAH+F+/yd0cKW12qWbEd9WbFj+xAb3HMLtu4qOTPzV
        w8Ch7uTewP38jpg3b/s+uWGrLDFf2Qg3stLoiL9DhA==
X-Google-Smtp-Source: ABdhPJxBp3GUXaZ9W9hiqH1jVDfWNvaMYX0wrg6aBY6ZyOOfnkt+gCbicPMWB7TysdVHtPNrkt3jkkyZoacj04de7q8=
X-Received: by 2002:a05:6402:222b:: with SMTP id cr11mr39513896edb.392.1633928093622;
 Sun, 10 Oct 2021 21:54:53 -0700 (PDT)
MIME-Version: 1.0
References: <20211008202353.1448570-1-bvanassche@acm.org> <20211008202353.1448570-36-bvanassche@acm.org>
In-Reply-To: <20211008202353.1448570-36-bvanassche@acm.org>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 11 Oct 2021 06:54:43 +0200
Message-ID: <CAMGffEk7vbUPP0bQqR0on1qW2UPNO-CHR6e=m6vc4XQ9viDk8A@mail.gmail.com>
Subject: Re: [PATCH v3 35/46] scsi: pm8001: Switch to attribute groups
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 8, 2021 at 10:25 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> struct device supports attribute groups directly but does not support
> struct device_attribute directly. Hence switch to attribute groups.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
lgtm.
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Thanks!
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c  | 64 +++++++++++++++++--------------
>  drivers/scsi/pm8001/pm8001_init.c |  2 +-
>  drivers/scsi/pm8001/pm8001_sas.h  |  2 +-
>  3 files changed, 38 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index b25e447aa3bd..397eb9f6a1dd 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -1002,34 +1002,42 @@ static ssize_t ctl_iop1_count_show(struct device *cdev,
>  }
>  static DEVICE_ATTR_RO(ctl_iop1_count);
>
> -struct device_attribute *pm8001_host_attrs[] = {
> -       &dev_attr_interface_rev,
> -       &dev_attr_controller_fatal_error,
> -       &dev_attr_fw_version,
> -       &dev_attr_update_fw,
> -       &dev_attr_aap_log,
> -       &dev_attr_iop_log,
> -       &dev_attr_fatal_log,
> -       &dev_attr_non_fatal_log,
> -       &dev_attr_non_fatal_count,
> -       &dev_attr_gsm_log,
> -       &dev_attr_max_out_io,
> -       &dev_attr_max_devices,
> -       &dev_attr_max_sg_list,
> -       &dev_attr_sas_spec_support,
> -       &dev_attr_logging_level,
> -       &dev_attr_event_log_size,
> -       &dev_attr_host_sas_address,
> -       &dev_attr_bios_version,
> -       &dev_attr_ib_log,
> -       &dev_attr_ob_log,
> -       &dev_attr_ila_version,
> -       &dev_attr_inc_fw_ver,
> -       &dev_attr_ctl_mpi_state,
> -       &dev_attr_ctl_hmi_error,
> -       &dev_attr_ctl_raae_count,
> -       &dev_attr_ctl_iop0_count,
> -       &dev_attr_ctl_iop1_count,
> +static struct attribute *pm8001_host_attrs[] = {
> +       &dev_attr_interface_rev.attr,
> +       &dev_attr_controller_fatal_error.attr,
> +       &dev_attr_fw_version.attr,
> +       &dev_attr_update_fw.attr,
> +       &dev_attr_aap_log.attr,
> +       &dev_attr_iop_log.attr,
> +       &dev_attr_fatal_log.attr,
> +       &dev_attr_non_fatal_log.attr,
> +       &dev_attr_non_fatal_count.attr,
> +       &dev_attr_gsm_log.attr,
> +       &dev_attr_max_out_io.attr,
> +       &dev_attr_max_devices.attr,
> +       &dev_attr_max_sg_list.attr,
> +       &dev_attr_sas_spec_support.attr,
> +       &dev_attr_logging_level.attr,
> +       &dev_attr_event_log_size.attr,
> +       &dev_attr_host_sas_address.attr,
> +       &dev_attr_bios_version.attr,
> +       &dev_attr_ib_log.attr,
> +       &dev_attr_ob_log.attr,
> +       &dev_attr_ila_version.attr,
> +       &dev_attr_inc_fw_ver.attr,
> +       &dev_attr_ctl_mpi_state.attr,
> +       &dev_attr_ctl_hmi_error.attr,
> +       &dev_attr_ctl_raae_count.attr,
> +       &dev_attr_ctl_iop0_count.attr,
> +       &dev_attr_ctl_iop1_count.attr,
>         NULL,
>  };
>
> +static const struct attribute_group pm8001_host_attr_group = {
> +       .attrs = pm8001_host_attrs
> +};
> +
> +const struct attribute_group *pm8001_host_groups[] = {
> +       &pm8001_host_attr_group,
> +       NULL
> +};
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 7082fecf7ce8..bed8cc125544 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -107,7 +107,7 @@ static struct scsi_host_template pm8001_sht = {
>  #ifdef CONFIG_COMPAT
>         .compat_ioctl           = sas_ioctl,
>  #endif
> -       .shost_attrs            = pm8001_host_attrs,
> +       .shost_groups           = pm8001_host_groups,
>         .track_queue_depth      = 1,
>  };
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 7e999768bfd2..83eec16d021d 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -733,7 +733,7 @@ ssize_t pm8001_get_gsm_dump(struct device *cdev, u32, char *buf);
>  int pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha);
>  void pm8001_free_dev(struct pm8001_device *pm8001_dev);
>  /* ctl shared API */
> -extern struct device_attribute *pm8001_host_attrs[];
> +extern const struct attribute_group *pm8001_host_groups[];
>
>  static inline void
>  pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
