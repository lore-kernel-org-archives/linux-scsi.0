Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE65C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 07:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbiLNHzt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 02:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiLNHzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 02:55:46 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C519D1145B
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 23:55:45 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id z26so9098818lfu.8
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 23:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q8DguwJlQXt+sclNoUEBAFdJ6I1Msi0ZVT/GBWu36uc=;
        b=D5Ai6/XGMmYt6o8Bi4J+4iynS5g1pPPqx1C6diKUHlHwFfOnk9UXnbyv9ymMPpdQ58
         yaUgnA9urOpLfGibbUdrnkiDkRmNsTamySK8e/annNS/kWfaz3e3rb7TyTdOV66ZUQeq
         xQdktsLYx+FaU2zd7JXp27rL3yHaww1Ytr/n5cmhZ0j9AC0pcJXpKA+wjT8SY8bFtHX9
         KDODpVyql6e1mgHjWpu2sJe90d5ZvDjoDApgrygPxntwasqv9fmtJoMQ5Ly7RYWecU8f
         bEjOTyii220aOmoQ2+O5ftBEZ2mhQ17qoImBpwiqfE7VdraB8+M0Rz8guTqvgQC6pMqV
         PH1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q8DguwJlQXt+sclNoUEBAFdJ6I1Msi0ZVT/GBWu36uc=;
        b=bm6PYl0NcDrtgMCwMsb65mYHhfrMZRA5iz1J9DjaPAvps82yUav6OFWeF5EeO48Clq
         LYNxOQPMIVDixbSmgQW/lI3St3T7qjhs2/3sM1AVjJr8vL2+vmxzhrsEAZM8vJR1/PJq
         yKj8oOl2fjKBUvYgQlof9grG36XgVItrcN/tJVrHvfje7uSYDVG7si+mXM0QsAPHC43r
         dizN4z37LGr36oMyoa3l8lGdRfC58WLZ1ICMsyHdaVFtngRtXEO/8rKOvhZbkZQVtuyl
         /ewII6246NMw16pNCiKVjno9sQNkZ3JwbcecZEf7/VCYI8RaOK15d0OL+htHVXD6ZhQD
         TXJQ==
X-Gm-Message-State: ANoB5pk+P886u/sQ+h3SsYR4PLGu9W+R2CvyTmHWE4135YHqD6xc+piM
        +dzqpD1H536Us6WqjHxmGaVJExmFPdd9hXa1RgJMtw==
X-Google-Smtp-Source: AA0mqf45kYcCQSxKTdiJedFwOH8bmZ94wvl4I806erZRCyof3uP71nE2RuPu9/bYTd8UEaPi2diQzzfP1c7GnBreknY=
X-Received: by 2002:ac2:546a:0:b0:4b5:7d6e:5fe7 with SMTP id
 e10-20020ac2546a000000b004b57d6e5fe7mr5360419lfn.469.1671004544061; Tue, 13
 Dec 2022 23:55:44 -0800 (PST)
MIME-Version: 1.0
References: <20221214070608.4128546-1-yanaijie@huawei.com> <20221214070608.4128546-2-yanaijie@huawei.com>
In-Reply-To: <20221214070608.4128546-2-yanaijie@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 14 Dec 2022 08:55:33 +0100
Message-ID: <CAMGffE=SgebDPTAhi7zVhC7r3C7pSk5z8cbJPhDL76v9Onayfw@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] scsi: libsas: move sas_get_ata_command_set() up to
 save the declaration
To:     Jason Yan <yanaijie@huawei.com>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com, john.g.garry@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 14, 2022 at 7:45 AM Jason Yan <yanaijie@huawei.com> wrote:
>
> There is a sas_get_ata_command_set() declaration above sas_get_ata_info()
> to make it compile ok. However this function is defined in the same file
> below. So move it up to save the forward declaration.
>
> Also remove the variable 'fis' which is not needed in this function.
>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/libsas/sas_ata.c | 26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index f7439bf9cdc6..de3439ae358d 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -239,7 +239,17 @@ static struct sas_internal *dev_to_sas_internal(struct domain_device *dev)
>         return to_sas_internal(dev->port->ha->core.shost->transportt);
>  }
>
> -static int sas_get_ata_command_set(struct domain_device *dev);
> +static int sas_get_ata_command_set(struct domain_device *dev)
> +{
> +       struct ata_taskfile tf;
> +
> +       if (dev->dev_type == SAS_SATA_PENDING)
> +               return ATA_DEV_UNKNOWN;
> +
> +       ata_tf_from_fis(dev->frame_rcvd, &tf);
> +
> +       return ata_dev_classify(&tf);
> +}
>
>  int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy)
>  {
> @@ -637,20 +647,6 @@ void sas_ata_task_abort(struct sas_task *task)
>         complete(waiting);
>  }
>
> -static int sas_get_ata_command_set(struct domain_device *dev)
> -{
> -       struct dev_to_host_fis *fis =
> -               (struct dev_to_host_fis *) dev->frame_rcvd;
> -       struct ata_taskfile tf;
> -
> -       if (dev->dev_type == SAS_SATA_PENDING)
> -               return ATA_DEV_UNKNOWN;
> -
> -       ata_tf_from_fis((const u8 *)fis, &tf);
> -
> -       return ata_dev_classify(&tf);
> -}
> -
>  void sas_probe_sata(struct asd_sas_port *port)
>  {
>         struct domain_device *dev, *n;
> --
> 2.31.1
>
