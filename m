Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7660C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8D1A2071B
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:42:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="h8hEqfVh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfKRJmj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 04:42:39 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:44401 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfKRJmj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 04:42:39 -0500
Received: by mail-il1-f196.google.com with SMTP id i6so5973829ilr.11
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 01:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JacBkWWiUjErq7xEAGgP0P2OZF8auwGoYTNfrEB98EE=;
        b=h8hEqfVhSEZk3107GZdm5khP/VNTxImwCmkce4ADjPMUlxclTEBxrL8w6c86YM/MDW
         KGiH1BDDeHmXJ0rTrMj5sTHC5vvRtre0chSEDirEkI8yTZ34veanA4nHDogwgq7tC8G+
         WT0FDxBsP+XLN3RuFhvABVvknUgq1M+1KppyNa0ylVim8kOza8uPgUieQ7BVAwF5Oz/9
         5CRScVbPsqpjmLUXE46B9GT7f5Vauu8Cz9zstfQB0GfOZPLStDuEGz5SBYkE25CLBq4h
         xM/txYv2MUVnWO7xSAiumQstG4UpbcyjkhfK5kUFo0WOlhgFeTjxkbNO/RgSKEZyr3cD
         SuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JacBkWWiUjErq7xEAGgP0P2OZF8auwGoYTNfrEB98EE=;
        b=iRlzPbIdKC10xk1USUEA/K0W92uBRKLM449xrAvpN6K58kOamTfG959k5fNlwT7qHw
         V+RRPhv7mR9zRtab8prT3Ps5o0iHn65FHXtXlsJUFr2LB0vTaK8/CNZ9i8E+xX4BLGNr
         lS+FXB+OaKaRXeSuHoyRJ5MTripUQpISktxaSORKX35ur0CoYHn4G3I0oKxbjJAwRGiV
         bbRuGUgeFHl5qbHo7o5+2FbSwlb16pidtdWHLohFOmMPLRgFJ681oBBzhAyUB636NN6I
         jeJhPiHaOFSaVR7LfT8ZATjeKaGWBLQ471xmFX3lMZyU1oBu0oBuqAzm+jZYW3qtlaZX
         bs7g==
X-Gm-Message-State: APjAAAXj4LtaUNSGSp4cb8sFVI1VYX9A86jGHkto3oiQE5r4afdzu5pF
        rCsNLXcAIbkY6GRc1QxLKsmgp9ZZTtn4NoV1VO5tqqmD
X-Google-Smtp-Source: APXvYqx4Vpqv/YousC1S0gyVWRZf9Lj/Rm2kCqd6EclxV3F7XbAAvEbYaX2WG4Bwyx5rsoBythhDJXsIXpHb1skunII=
X-Received: by 2002:a92:d7c6:: with SMTP id g6mr10234265ilq.298.1574070158369;
 Mon, 18 Nov 2019 01:42:38 -0800 (PST)
MIME-Version: 1.0
References: <20191114100910.6153-1-deepak.ukey@microchip.com> <20191114100910.6153-12-deepak.ukey@microchip.com>
In-Reply-To: <20191114100910.6153-12-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 18 Nov 2019 10:42:26 +0100
Message-ID: <CAMGffEno4_SmtryBYtp4fvrrXRpGk7t5Yz68zyuvCg8ozg=TnA@mail.gmail.com>
Subject: Re: [PATCH V2 11/13] pm80xx : Controller fatal error through sysfs.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        jsperbeck@google.com, Vikram Auradkar <auradkar@google.com>,
        ianyar@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 14, 2019 at 11:08 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Deepak Ukey <Deepak.Ukey@microchip.com>
>
> Added support to check controller fatal error through sysfs.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 6b85016b4db3..7c6be2ec110d 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -69,6 +69,25 @@ static ssize_t pm8001_ctl_mpi_interface_rev_show(struct device *cdev,
>  static
>  DEVICE_ATTR(interface_rev, S_IRUGO, pm8001_ctl_mpi_interface_rev_show, NULL);
>
> +/**
> + * controller_fatal_error_show - check controller is under fatal err
> + * @cdev: pointer to embedded class device
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read only' shost attribute.
> + */
> +static ssize_t controller_fatal_error_show(struct device *cdev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +
> +       return snprintf(buf, PAGE_SIZE, "%d\n",
> +                       pm8001_ha->controller_fatal_error);
> +}
> +static DEVICE_ATTR_RO(controller_fatal_error);
> +
>  /**
>   * pm8001_ctl_fw_version_show - firmware version
>   * @cdev: pointer to embedded class device
> @@ -804,6 +823,7 @@ static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
>         pm8001_show_update_fw, pm8001_store_update_fw);
>  struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_interface_rev,
> +       &dev_attr_controller_fatal_error,
>         &dev_attr_fw_version,
>         &dev_attr_update_fw,
>         &dev_attr_aap_log,
> --
> 2.16.3
>
