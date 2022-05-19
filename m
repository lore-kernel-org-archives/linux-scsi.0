Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBEBFC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 17:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241532AbiESR3f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 13:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242965AbiESR30 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 13:29:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A66693E0C9
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 10:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652981270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R/Lkot5/4sKgRcDNp5q/Y5i98b+jBfFEKA3DLT++vAA=;
        b=e1MDxxUr/ELBixHoj5UICZ8VvU53MI/59YbwngMxwXuk4vzMPayjHxlKbiu3IaW2kzrB0g
        jSkp/AUVVa6aXwOW5ZNFjzAKiuq3xbSBblryYAAsb8wrkNKCLyzVkQ6bhxuJuOkWr4HpaN
        SjDAvNSrnZcp/pOk9xcZIIvFB+xlcjQ=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-DC8ZiRdLObWtN1k65kbloA-1; Thu, 19 May 2022 13:27:49 -0400
X-MC-Unique: DC8ZiRdLObWtN1k65kbloA-1
Received: by mail-lj1-f197.google.com with SMTP id x16-20020a2e9c90000000b002509c7b56ebso1310635lji.14
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 10:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=R/Lkot5/4sKgRcDNp5q/Y5i98b+jBfFEKA3DLT++vAA=;
        b=fRTuLS8fJ69ZA3lw9x1baloPs2cLQW8sU2Ek9wLlSiJyWemoU4967XLHvxO6pmPmCn
         53iuhK6xom0A+1chrv+OXfP8J3nmwuTcAZlIL7TVMQpL3G1pJ02A+L0Vr6yS6fTLbIFp
         41XPcOYmlBNWbKWI37aMqh8qG58pQXqDRPFqid8+kLJy/QRegK0dfQ9dJVh4XFasmiWG
         GEiQcpPnQFL4dk7x4Ya0SOJFl7i/i8Dueit5OgdBJOX5OQSnmW8QS2zVc6CTrYDjAvLO
         9jJ7y7nbUo7xXkvo3AaOU1wTtTm9nB0GLX3+ajwpUiXaYvh1iyvR2Hyg1LhOS8FjKZw8
         A96w==
X-Gm-Message-State: AOAM530UzIhFJWZN7oNnWej8FaAEBFfRhGlc2MrfhUL0y2YbuUsOmebB
        w3GCFSyZ59s7g322AT/KpsrHDiY23B06pG1nAk4EWOyNurqvtsPM3mCOPFcdMKwsl6FW1pWWJFE
        ZBivr7iUCjcLGvVg0vN7fMR4nD8wrMge+00WkAQ==
X-Google-Smtp-Source: ABdhPJwyOWRu0DHFXx8YNA4U8uYYQdg1vhWpzdRjN/stUE+77XY/Nog9VNB050CdnWX7ESEPVl0jEZPChBRGt42N5/g=
X-Received: by 2002:a05:6512:23a6:b0:477:943a:818d with SMTP id c38-20020a05651223a600b00477943a818dmr4000037lfv.644.1652981267759;
        Thu, 19 May 2022 10:27:47 -0700 (PDT)
X-Received: by 2002:a05:6512:23a6:b0:477:943a:818d with SMTP id
 c38-20020a05651223a600b00477943a818dmt1555170lfv.644.1652981267554; Thu, 19
 May 2022 10:27:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220512111236.109851-1-hare@suse.de> <20220512111236.109851-5-hare@suse.de>
In-Reply-To: <20220512111236.109851-5-hare@suse.de>
From:   Ewan Milne <emilne@redhat.com>
Date:   Thu, 19 May 2022 13:27:36 -0400
Message-ID: <CAGtn9rnkZ1Y6-H7N_VkgmsDfWURiRBm1-kjnhLYxSk7un08CyQ@mail.gmail.com>
Subject: Re: [PATCH 04/20] mptfusion: correct definitions for mptscsih_dev_reset()
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch appears to change the EH activity from issuing a target
reset to a LUN reset only
(since it does not add an entry in the host templates for
.eh_target_reset_handler to invoke
the new mptscsih_target_reset() function, nor does any other patch in
the series).

Is this going to work properly, and without escalating to a host reset
which might not have happened before?

-Ewan

On Thu, May 12, 2022 at 7:13 AM Hannes Reinecke <hare@suse.de> wrote:
>
> From: Hannes Reinecke <hare@suse.com>
>
> mptscsih_dev_reset() is _not_ a device reset, but rather a
> target reset. Nevertheless it's being used for either purpose.
> This patch adds a correct implementation for mptscsih_dev_reset(),
> and renames the original function to mptscsih_target_reset().
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  drivers/message/fusion/mptscsih.c | 55 ++++++++++++++++++++++++++++++-
>  drivers/message/fusion/mptscsih.h |  1 +
>  2 files changed, 55 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 276084ed04a6..ed21cc4d2c77 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1794,7 +1794,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
>
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /**
> - *     mptscsih_dev_reset - Perform a SCSI TARGET_RESET!  new_eh variant
> + *     mptscsih_dev_reset - Perform a SCSI LOGICAL_UNIT_RESET!
>   *     @SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
>   *
>   *     (linux scsi_host_template.eh_dev_reset_handler routine)
> @@ -1809,6 +1809,58 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
>         VirtDevice       *vdevice;
>         MPT_ADAPTER     *ioc;
>
> +       /* If we can't locate our host adapter structure, return FAILED status.
> +        */
> +       if ((hd = shost_priv(SCpnt->device->host)) == NULL){
> +               printk(KERN_ERR MYNAM ": lun reset: "
> +                  "Can't locate host! (sc=%p)\n", SCpnt);
> +               return FAILED;
> +       }
> +
> +       ioc = hd->ioc;
> +       printk(MYIOC_s_INFO_FMT "attempting lun reset! (sc=%p)\n",
> +              ioc->name, SCpnt);
> +       scsi_print_command(SCpnt);
> +
> +       vdevice = SCpnt->device->hostdata;
> +       if (!vdevice || !vdevice->vtarget) {
> +               retval = 0;
> +               goto out;
> +       }
> +
> +       retval = mptscsih_IssueTaskMgmt(hd,
> +                               MPI_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET,
> +                               vdevice->vtarget->channel,
> +                               vdevice->vtarget->id, vdevice->lun, 0,
> +                               mptscsih_get_tm_timeout(ioc));
> +
> + out:
> +       printk (MYIOC_s_INFO_FMT "lun reset: %s (sc=%p)\n",
> +           ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
> +
> +       if (retval == 0)
> +               return SUCCESS;
> +       else
> +               return FAILED;
> +}
> +
> +/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> +/**
> + *     mptscsih_target_reset - Perform a SCSI TARGET_RESET!
> + *     @SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
> + *
> + *     (linux scsi_host_template.eh_target_reset_handler routine)
> + *
> + *     Returns SUCCESS or FAILED.
> + **/
> +int
> +mptscsih_target_reset(struct scsi_cmnd * SCpnt)
> +{
> +       MPT_SCSI_HOST   *hd;
> +       int              retval;
> +       VirtDevice       *vdevice;
> +       MPT_ADAPTER     *ioc;
> +
>         /* If we can't locate our host adapter structure, return FAILED status.
>          */
>         if ((hd = shost_priv(SCpnt->device->host)) == NULL){
> @@ -3257,6 +3309,7 @@ EXPORT_SYMBOL(mptscsih_slave_destroy);
>  EXPORT_SYMBOL(mptscsih_slave_configure);
>  EXPORT_SYMBOL(mptscsih_abort);
>  EXPORT_SYMBOL(mptscsih_dev_reset);
> +EXPORT_SYMBOL(mptscsih_target_reset);
>  EXPORT_SYMBOL(mptscsih_bus_reset);
>  EXPORT_SYMBOL(mptscsih_host_reset);
>  EXPORT_SYMBOL(mptscsih_bios_param);
> diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
> index a22c5eaf703c..e3d92c392673 100644
> --- a/drivers/message/fusion/mptscsih.h
> +++ b/drivers/message/fusion/mptscsih.h
> @@ -120,6 +120,7 @@ extern void mptscsih_slave_destroy(struct scsi_device *device);
>  extern int mptscsih_slave_configure(struct scsi_device *device);
>  extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
>  extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
> +extern int mptscsih_target_reset(struct scsi_cmnd * SCpnt);
>  extern int mptscsih_bus_reset(struct scsi_cmnd * SCpnt);
>  extern int mptscsih_host_reset(struct scsi_cmnd *SCpnt);
>  extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
> --
> 2.29.2
>

