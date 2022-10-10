Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86415C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Oct 2022 05:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiJJFPt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Oct 2022 01:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiJJFPs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Oct 2022 01:15:48 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996594D4C4
        for <linux-scsi@vger.kernel.org>; Sun,  9 Oct 2022 22:15:47 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id bu25so15020280lfb.3
        for <linux-scsi@vger.kernel.org>; Sun, 09 Oct 2022 22:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C0cRKsDBJEjgfO2uO0DRlSkhYtWzbxdKd0a927CGiSM=;
        b=afQJiT7Qw+GBxOL3YUVXRTzhZ0PJe8U9iF5O2gHMeSSbUxoLE821QkR4QanU68/CGY
         fBn3xYy+ETI9Pdz6CnYpcOTVkbeKswM+cUbZQRWIAyEtsRh5L2gvXH31PIj83LGo20OY
         jtzOr7rsFGaZ1vo6/4xpDw/sTUWGVrInL+0Y0kOYhNGBO3fTA2BdXWwCnqDmVN5UnTAO
         0q79oDPrMhFOV2EabU7Gqy7FBBVwok0LyY713ZfRLTHSqNsREJ7vEuVLLpQdEh/7lzjT
         3zjE6BUKI26EANp1MmwoxBHEOXOvfweMEJoPG/aO9623EouegAyL4cU6WTagjEY1ph4Y
         K3BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C0cRKsDBJEjgfO2uO0DRlSkhYtWzbxdKd0a927CGiSM=;
        b=A/UK9wqeCijenQJY+H9kVI1UL1Sbw5GaE7Fm3QmcCRoOBcDnhiZbCDTTq6KdF6y02i
         1/6QP6EP20ehyGjB4XFaeH4B8Zn15N7w4T3fjD+NmL/JP/ySbs2JCRSxxCQDwDge4KIo
         HcPdQdesMir5IoaavQAxFTDgEfIjgkL9Oxl1md7hQqrwKVYdF21DJgdeWxRpqIHaVWdq
         xbzLspttahIx7DxFbE9r2VFd48dmYsl0+mm/2h7+dsvTOp2Fkh7F2xoBWnvdDVstxsO1
         DodSOIU9A0sGw45WdKx23nE7BM71tshQII1tDmjjE73KBDT3rfWY5wfqjeJRoNEz686y
         Ta2g==
X-Gm-Message-State: ACrzQf2uvQ4ohFfcomqUmdkhBoFAmrYs3cZaxyfDf683wwVkmDABH7cW
        rlkxDt9XnFcX5mCIgOKxonVQ8Vi8Y0ZUWFlu+DUpdg==
X-Google-Smtp-Source: AMsMyM4gLvOCl9wsS/rGbku2Twx9arRfNBf95EUgqFrqWEjO6t8noi/yByt/BaFix4vJcDJHQk19QxI6fKR/wZ6LWaI=
X-Received: by 2002:a05:6512:31c4:b0:4a2:696e:4302 with SMTP id
 j4-20020a05651231c400b004a2696e4302mr6584529lfe.478.1665378945852; Sun, 09
 Oct 2022 22:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20221007230651.308969-1-ipylypiv@google.com>
In-Reply-To: <20221007230651.308969-1-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 10 Oct 2022 07:15:34 +0200
Message-ID: <CAMGffEk0Xzr9vZ97d4Gd=Awf-yYT2VEXVr5WRYoKuuoGwSQcbQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Display proc_name in sysfs
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jolly Shah <jollys@google.com>,
        Andrew Konecki <awkonecki@google.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Oct 8, 2022 at 1:07 AM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> The proc_name entry in sysfs for pm80xx is "(null)" because it is
> not initialized in scsi_host_template:
>
> Before:
> host:~# cat /sys/class/scsi_host/host6/proc_name
> (null)
>
> After:
> host:~# cat /sys/class/scsi_host/host6/proc_name
> pm80xx
>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> Reviewed-by: Jolly Shah <jollys@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 2ff2fac1e403..7a7d63aa90e2 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -99,6 +99,7 @@ static void pm8001_map_queues(struct Scsi_Host *shost)
>  static struct scsi_host_template pm8001_sht = {
>         .module                 = THIS_MODULE,
>         .name                   = DRV_NAME,
> +       .proc_name              = DRV_NAME,
>         .queuecommand           = sas_queuecommand,
>         .dma_need_drain         = ata_scsi_dma_need_drain,
>         .target_alloc           = sas_target_alloc,
> --
> 2.38.0.rc1.362.ged0d419d3c-goog
>
