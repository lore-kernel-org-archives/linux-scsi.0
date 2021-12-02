Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87510C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Dec 2021 08:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345470AbhLBIV0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Dec 2021 03:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240800AbhLBIVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2021 03:21:25 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF998C061574
        for <linux-scsi@vger.kernel.org>; Thu,  2 Dec 2021 00:18:02 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id r25so46688106edq.7
        for <linux-scsi@vger.kernel.org>; Thu, 02 Dec 2021 00:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8EMefng5erdf0jDsY/Rk+qQrk7z/fTIuyGvC3fX9B4A=;
        b=KqpVPmtXi4VibzCGZkpMlgh0Kv2CPnslvbt9Ft4SjeKb7HxfGk16aCgULtr26hvjzO
         ulLufdTRr3HwimECQqduTBH5GBvLZG7T3yMxQCT1USItv+UyoqxiU9GP1v3Z/NSN9w5U
         FBGJnGyfWhDQAsoDhWc71frVCtc48APr8MRAhXA7TqlgcaAPaMOz2ptYBWJO2opJArET
         4YuFLySNzSagzd/1YEbs9MhzpeeLw4IF1hYpZuEN/Fd/3dlV170MK8zY3VXJ4ZBQ+D4y
         /q++dRgy9mmLGgsuxQKtHT6Xo0Erv/mhRRVhmBoN/vMWflZyo9kIVIuNFRv2ps0r+YSm
         ZA/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8EMefng5erdf0jDsY/Rk+qQrk7z/fTIuyGvC3fX9B4A=;
        b=qt9dMPaFzEcMAEJ0CvvNCsuIqbYLqvcTCSFajNAgDU7wDCJiU7FiOs2L5QwEmeUCcC
         Rv4pgKgcdsUB+VUIbgxDA95oMhtF6BRST1O1sHklRhPhJqx7pDiPoaIHmlz5Xkowqe0b
         6C9C1lpI2w1yyQNrkufQDusgcspIqif4LLxjM9Aup8QFxIXaXw5/euqAt+bGlx3swh86
         vz2CtdbkpLdckJ6/BmCDk76zofDo/JP5CnGgtvmrcbuA7KmN0qsZ2AnsYw4ygXfIHFq2
         sH3OpKaiRl6SnRaRGss+PCcjUxeNBGWmET6rb4zPaYuFin7zbapOMZXQuDIDX3teOS7X
         4A5A==
X-Gm-Message-State: AOAM531aTOYTCJ+Wy+sdZa/WyeWNDa1QxsS6Wp+zknvf7+Ta6t8CmBvI
        ZUR1olHkXriVUY4kNJ9K9dCkjJNm0Cg19BWq04Xz2Q==
X-Google-Smtp-Source: ABdhPJzlTCsmeT9iYNsKVmcveymS1MrvaGPW5ALaVFT+izVCdIH7yGa7cr/14mQPALaLKVcmCiL0vYBXMOdzZmLGeBs=
X-Received: by 2002:a17:907:7d8b:: with SMTP id oz11mr13777617ejc.507.1638433080959;
 Thu, 02 Dec 2021 00:18:00 -0800 (PST)
MIME-Version: 1.0
References: <20211201041627.1592487-1-ipylypiv@google.com>
In-Reply-To: <20211201041627.1592487-1-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 2 Dec 2021 09:17:50 +0100
Message-ID: <CAMGffEnXaD8s93hd09Dv92G=kPbv3CzAx-gbtXfR6ukmNdFjTQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Do not call scsi_remove_host() in pm8001_alloc()
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org, Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 1, 2021 at 5:16 AM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> Calling scsi_remove_host() before scsi_add_host() results in a crash:
>
>  BUG: kernel NULL pointer dereference, address: 0000000000000108
>  RIP: 0010:device_del+0x63/0x440
>  Call Trace:
>   device_unregister+0x17/0x60
>   scsi_remove_host+0xee/0x2a0
>   pm8001_pci_probe+0x6ef/0x1b90 [pm80xx]
>   local_pci_probe+0x3f/0x90
>
> We cannot call scsi_remove_host() in pm8001_alloc() because
> scsi_add_host() have not been called yet at that point of time.
>
> Function call tree:
>
>   pm8001_pci_probe()
>   |
>   `- pm8001_pci_alloc()
>   |  |
>   |  `- pm8001_alloc()
>   |     |
>   |     `- scsi_remove_host()
>   |
>   `- scsi_add_host()
>
> Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
> Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Thanks!
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index bed8cc125544..fbfeb0b046dd 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -282,12 +282,12 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>         if (rc) {
>                 pm8001_dbg(pm8001_ha, FAIL,
>                            "pm8001_setup_irq failed [ret: %d]\n", rc);
> -               goto err_out_shost;
> +               goto err_out;
>         }
>         /* Request Interrupt */
>         rc = pm8001_request_irq(pm8001_ha);
>         if (rc)
> -               goto err_out_shost;
> +               goto err_out;
>
>         count = pm8001_ha->max_q_num;
>         /* Queues are chosen based on the number of cores/msix availability */
> @@ -423,8 +423,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>         pm8001_tag_init(pm8001_ha);
>         return 0;
>
> -err_out_shost:
> -       scsi_remove_host(pm8001_ha->shost);
>  err_out_nodev:
>         for (i = 0; i < pm8001_ha->max_memcnt; i++) {
>                 if (pm8001_ha->memoryMap.region[i].virt_ptr != NULL) {
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
