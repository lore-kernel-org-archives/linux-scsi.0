Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B84C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 20:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244596AbiESUGI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 16:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244597AbiESUGC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 16:06:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9364930F71
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 13:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652990759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GkgOXEHyMYuEPiFRBiZmgAMQEvG+Jg/37VBTbGhIxoU=;
        b=ZBClHGzZ8uz6GnUTtJC+vjDS7GGho8AWWjXLIE52K8uGUf9cJIjfQEuWbyzyl0s+FE9Fa5
        9evKDYGlCjduMD13WLdXWq60U+GfO48ahu0jlpMzDCz3Md6/ab6mRWHQH92Pm+tSUcPbB8
        lp2a10AHHswPrfIF8oBSP/9Q+hSj3gs=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-2exNsKrsN7aNtDjTf4aIaw-1; Thu, 19 May 2022 16:05:58 -0400
X-MC-Unique: 2exNsKrsN7aNtDjTf4aIaw-1
Received: by mail-lf1-f72.google.com with SMTP id e10-20020a05651236ca00b00474337bbe36so3137548lfs.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 13:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GkgOXEHyMYuEPiFRBiZmgAMQEvG+Jg/37VBTbGhIxoU=;
        b=oDip6+MFVLjtj/KRR/4sEVdfO2AN6KYtHoBMW6CV1O8HIlESjUA4LKXpCIrjEn42Xa
         rp1fMY67INvwSPCgL70gpJ0pN9TV15bVhXxxbAF9pLNVNLPOMU4pvpGT/GxfHntuzIXj
         LXQ4cWA4R4/oTgqc7dcnIa2nhalKD37SlwDtcDFGTIOGTwlezoVOEjGumS4bkUNJJMW6
         zJ7e663XHl9v2xD/gIi97kZUyYi8TJruKFPSkJ2R0rwZJa+xhNqMHFTzZUrs77y2n5r4
         eU5voNoB0wH0pR1kCTid0yTiTgSlVnNBgWnsLFyXxhslNzwUmsyjSydTdoYCuLcMpo+h
         cnEA==
X-Gm-Message-State: AOAM531BztHjBnGHCj4a4I9pcOqNO59NSCtZ/b3czehQZtl1FlESnQI9
        VP0gAp2xhovk3ktn+8INJi16FVcFt2spruDDasnG9FQ2YEi1eGYrRP+XBruzUSohn4BzmFO8tb5
        34cCyMTeOUoQP20wxTRk1Vpcu6wkzaPeY+f2JKg==
X-Received: by 2002:a2e:9b54:0:b0:250:c939:e782 with SMTP id o20-20020a2e9b54000000b00250c939e782mr3596842ljj.384.1652990756492;
        Thu, 19 May 2022 13:05:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFcDClxdXMoLlU60QdBB4KQF1oJVnP0NyHxHkLlSFQrEk783MxAUg5+ywR5AUyvudb93w+txOpVBLPX4oHE/0=
X-Received: by 2002:a2e:9b54:0:b0:250:c939:e782 with SMTP id
 o20-20020a2e9b54000000b00250c939e782mr3596837ljj.384.1652990756311; Thu, 19
 May 2022 13:05:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220512111236.109851-1-hare@suse.de> <20220512111236.109851-9-hare@suse.de>
In-Reply-To: <20220512111236.109851-9-hare@suse.de>
From:   Ewan Milne <emilne@redhat.com>
Date:   Thu, 19 May 2022 16:05:45 -0400
Message-ID: <CAGtn9rn=RZRYpjD68ug+j6+ogenH-DSYD3-023bc5basjvq-4g@mail.gmail.com>
Subject: Re: [PATCH 08/20] ibmvfc: open-code reset loop for target reset
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch looks like it will call ibmvfc_reset_device() w/IBMVFC_TARGET_RESET
before it has called ibmvfc_cancel_all() on all the devices, the
existing code calls
ibmvfc_reset_device() w/IBMVFC_TARGET_RESET after the iterator.

Since you have the starget, why change to use shost_for_each_device()
and check the
sdev->channel and sdev->id ?  That's what starget_for_each_device() does.

-Ewan

On Thu, May 12, 2022 at 7:13 AM Hannes Reinecke <hare@suse.de> wrote:
>
> From: Hannes Reinecke <hare@suse.com>
>
> For target reset we need a device to send the target reset to,
> so open-code the loop in target reset to send the target reset TMF
> to the correct device.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: Tyrel Datwyler <tyreld@linux.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 42 +++++++++++++++++++---------------
>  1 file changed, 23 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index d0eab5700dc5..721d965f4b0e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -2925,18 +2925,6 @@ static void ibmvfc_dev_cancel_all_noreset(struct scsi_device *sdev, void *data)
>         *rc |= ibmvfc_cancel_all(sdev, IBMVFC_TMF_SUPPRESS_ABTS);
>  }
>
> -/**
> - * ibmvfc_dev_cancel_all_reset - Device iterated cancel all function
> - * @sdev:      scsi device struct
> - * @data:      return code
> - *
> - **/
> -static void ibmvfc_dev_cancel_all_reset(struct scsi_device *sdev, void *data)
> -{
> -       unsigned long *rc = data;
> -       *rc |= ibmvfc_cancel_all(sdev, IBMVFC_TMF_TGT_RESET);
> -}
> -
>  /**
>   * ibmvfc_eh_target_reset_handler - Reset the target
>   * @cmd:       scsi command struct
> @@ -2946,22 +2934,38 @@ static void ibmvfc_dev_cancel_all_reset(struct scsi_device *sdev, void *data)
>   **/
>  static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
>  {
> -       struct scsi_device *sdev = cmd->device;
> -       struct ibmvfc_host *vhost = shost_priv(sdev->host);
> -       struct scsi_target *starget = scsi_target(sdev);
> +       struct scsi_target *starget = scsi_target(cmd->device);
> +       struct fc_rport *rport = starget_to_rport(starget);
> +       struct Scsi_Host *shost = rport_to_shost(rport);
> +       struct ibmvfc_host *vhost = shost_priv(shost);
>         int block_rc;
>         int reset_rc = 0;
>         int rc = FAILED;
>         unsigned long cancel_rc = 0;
> +       bool tgt_reset = false;
>
>         ENTER;
> -       block_rc = fc_block_scsi_eh(cmd);
> +       block_rc = fc_block_rport(rport);
>         ibmvfc_wait_while_resetting(vhost);
>         if (block_rc != FAST_IO_FAIL) {
> -               starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_reset);
> -               reset_rc = ibmvfc_reset_device(sdev, IBMVFC_TARGET_RESET, "target");
> +               struct scsi_device *sdev;
> +
> +               shost_for_each_device(sdev, shost) {
> +                       if ((sdev->channel != starget->channel) ||
> +                           (sdev->id != starget->id))
> +                               continue;
> +
> +                       cancel_rc |= ibmvfc_cancel_all(sdev,
> +                                                      IBMVFC_TMF_TGT_RESET);
> +                       if (!tgt_reset) {
> +                               reset_rc = ibmvfc_reset_device(sdev,
> +                                       IBMVFC_TARGET_RESET, "target");
> +                               tgt_reset = true;
> +                       }
> +               }
>         } else
> -               starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_noreset);
> +               starget_for_each_device(starget, &cancel_rc,
> +                                       ibmvfc_dev_cancel_all_noreset);
>
>         if (!cancel_rc && !reset_rc)
>                 rc = ibmvfc_wait_for_ops(vhost, starget, ibmvfc_match_target);
> --
> 2.29.2
>

