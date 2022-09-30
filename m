Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 892D1C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 09:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiI3JQO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Sep 2022 05:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbiI3JQK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2022 05:16:10 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA6B9F1B6
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 02:16:08 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id a2so5956115lfb.6
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 02:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=L4qqFOCpaCQVZ7/RWnNGM12gMeTU7gAvoltBB1el1vs=;
        b=Qnpt1LZsarX4zeglmcRefK8Kw6kDNgNJcv83vbfpaO3pwqS5Z8TLk1SCJjPmwaRhdR
         ZzG/FeQodQ9auTPtEv8y4CDC9MlNQ7E6kyrI+FKK5q8ir74CZnLkmRVID3i+DitG3Ddc
         +9NWUD6+snMJQa3Me1vw4LlD+Y47zfBooctBqaLwYU7Tm1A53sFImwtlfvz0nIY2nZG4
         oPldrbvupt4+kZD1JZbWMSyZsoLlOLgoTJY5z94lSt+9UexX1Y4n5oyLZPW4QUmRrbXZ
         FkV+Pv9CZyx6gwvDUAy2dTdg/bAbJeXnW9SsZgQqHV/Snt6eQCVKpY66/Qv6pxsJFo6+
         03LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=L4qqFOCpaCQVZ7/RWnNGM12gMeTU7gAvoltBB1el1vs=;
        b=OcAODBdvtvEAMzCpmXJgAdnV5v/PKSYpsM0mG2u1G7B9lvYVYJAc5fTS+VXY5NbceR
         o2TRHCHu6PQTBJG5aPF+Ox5gfNpkz/nwSEEcup4OHxVGrbUUqtRiF+wcg/6/Nbq2zVQr
         XgHHbCHxPGt18QAHtFMczth3tNDC69wOmU4v1hKGMGpDXEQphcTxYDhYNXlzgER5XPSQ
         LKvqooItrtB9alutEhw/syzVv2hTXT8mDSkbC/rcQ1IRrGu2HCUmI2AD0ROQEbsLGBQ6
         czfPyTV83xpuk4YU9/qDfzJh4owTzh9IhoWV3luMHFW8dGjfhmtFjD40vgEtv8I5IxHV
         SdeA==
X-Gm-Message-State: ACrzQf2uEPsfv2dqLuAuKsORHZ1LM2GpQyrhINBk5ygavpXZ7SI5FwMm
        RQJYwNj70KG2dQ9AXmTaKaWPo8vmkp+W8KIZvFBUhw==
X-Google-Smtp-Source: AMsMyM4pwfp8xwzsg+aGdqve2IDpDuZZKAQGnbgUzhfCyTeZTlznoz/99BE2Wgtzhj3yF6KRi0TCwcv62OsUZ2eX+4k=
X-Received: by 2002:a05:6512:2345:b0:49e:359f:5579 with SMTP id
 p5-20020a056512234500b0049e359f5579mr3251818lfu.478.1664529365857; Fri, 30
 Sep 2022 02:16:05 -0700 (PDT)
MIME-Version: 1.0
References: <1664528184-162714-1-git-send-email-john.garry@huawei.com> <1664528184-162714-4-git-send-email-john.garry@huawei.com>
In-Reply-To: <1664528184-162714-4-git-send-email-john.garry@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 30 Sep 2022 11:15:54 +0200
Message-ID: <CAMGffEmK6j0EzDfa4QNQOSVYkCx-m8Q_eHOLFOesu8VNhtiRPQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] scsi: pm8001: Remove pm8001_tag_init()
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        jinpu.wang@ionos.com, damien.lemoal@wdc.com, hare@suse.de,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, ipylypiv@google.com, changyuanl@google.com,
        hch@lst.de, yanaijie@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 30, 2022 at 11:03 AM John Garry <john.garry@huawei.com> wrote:
>
> From: Igor Pylypiv <ipylypiv@google.com>
>
> In commit 5a141315ed7c ("scsi: pm80xx: Increase the number of outstanding
> I/O supported to 1024") the pm8001_ha->tags allocation was moved into
> pm8001_init_ccb_tag(). This changed the execution order of allocation.
> pm8001_tag_init() used to be called after the pm8001_ha->tags allocation
> and now it is called before the allocation.
>
> Before:
>
> pm8001_pci_probe()
> `--> pm8001_pci_alloc()
>      `--> pm8001_alloc()
>           `--> pm8001_ha->tags = kzalloc(...)
>           `--> pm8001_tag_init(pm8001_ha); // OK: tags are allocated
>
> After:
>
> pm8001_pci_probe()
> `--> pm8001_pci_alloc()
> |    `--> pm8001_alloc()
> |         `--> pm8001_tag_init(pm8001_ha); // NOK: tags are not allocated
> |
> `--> pm8001_init_ccb_tag()
>      `-->  pm8001_ha->tags = kzalloc(...) // today it is bitmap_zalloc()
>
> Since pm8001_ha->tags_num is zero when pm8001_tag_init() is called it does
> nothing. Tags memory is allocated with bitmap_zalloc() so there is no need
> to manually clear each bit with pm8001_tag_free().
>
> Reviewed-by: Changyuan Lyu <changyuanl@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 2 --
>  drivers/scsi/pm8001/pm8001_sas.c  | 7 -------
>  drivers/scsi/pm8001/pm8001_sas.h  | 1 -
>  3 files changed, 10 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index a0028e130a7e..0edc9857a8bd 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -436,8 +436,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
>                 atomic_set(&pm8001_ha->devices[i].running_req, 0);
>         }
>         pm8001_ha->flags = PM8001F_INIT_TIME;
> -       /* Initialize tags */
> -       pm8001_tag_init(pm8001_ha);
>         return 0;
>
>  err_out_nodev:
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index d5ec29f69be3..066dfa9f4683 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -96,13 +96,6 @@ int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out)
>         return 0;
>  }
>
> -void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha)
> -{
> -       int i;
> -       for (i = 0; i < pm8001_ha->tags_num; ++i)
> -               pm8001_tag_free(pm8001_ha, i);
> -}
> -
>  /**
>   * pm8001_mem_alloc - allocate memory for pm8001.
>   * @pdev: pci device.
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 8ab0654327f9..9acaadf02150 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -632,7 +632,6 @@ extern struct workqueue_struct *pm8001_wq;
>
>  /******************** function prototype *********************/
>  int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out);
> -void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha);
>  u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag);
>  void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
>                           struct pm8001_ccb_info *ccb);
> --
> 2.35.3
>
