Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2E1C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 07:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D8E565011
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 07:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhCEH3L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 02:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhCEH3K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 02:29:10 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E88C061574
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 23:29:09 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id w1so1474378ejf.11
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 23:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B5YnQt80SJA4hbDYhli6JeLLUft1vGxTt1Zmn1QPTzU=;
        b=FM90UW6dNcXt8Y0yoBuQexqPzCv42CGYgSFbRDxPq4HE1ouC0QU80r3IP7tjyROVeQ
         hibFECfDK9vbdKPzDQ+E3s8XZWNLR5VdPf/fNFnFtDFsqozQpuSXHys8F77joenp4X4O
         nR8qhOjwEjwOB7VTdH22m5ydsebEQt6/iPDMHa6ocFkLDe1m4B74KqsD9o4pDoXzyHZ6
         p8N4kQyLGJpTvjePtzTDzn8r8v60lKrfOs6oXQDlsxqZAnqbxj9dR5s4Zve8IVH9gHz3
         3YghlvpT3iHLDXmeLobtz8lzU7wMIrT4XgAIUXqhlITIqFkVLo2Kqo+D+QJdlgTIXgJ8
         jrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B5YnQt80SJA4hbDYhli6JeLLUft1vGxTt1Zmn1QPTzU=;
        b=h4ncwshn1tRsQ0yyf+/y8cXQNHmfYFl4vCMCQWGYx9hXgkEPwghygegIn0KERXU8fY
         W99GIoCrXuqYGJS4X+QaKx1fDQ7I8zR0UObWuRQyprnvO7gyo5dwLJr7XlAMdg2AkRBd
         nnQFnJvgKINmn77NosFSj+1hlvhfT3Gl6rPIJ3zXEkhh7SynIpZkYAhDFTSBZoTx/AhI
         a8ATmNXhtyDjebqYh8UpSI5KR4v8mo1SfW5uRTX/GTJeiEC4BqDDNR5ETsFRlJhkG873
         ZjHfWUMUtUKbAn0UAI2zss9QCRdoedRk82IlD0ck0LCgEhnxQl+A+cSBem9PxikGmnPM
         zo5A==
X-Gm-Message-State: AOAM531dLu3MyCCO8vp6pkK9CdjwAJGhWCHfSNzpuuzu8Q1DJNNs6jU5
        jZwmi5pHQa7zpU56fnZ6ihnVJ+kK8QeqKlowr8EYWw==
X-Google-Smtp-Source: ABdhPJxjTHbv+8e8oMldOoAfvrygemuNALStg/TZBC81rLLCPPqxblsXu2UJ7ruUWuNEnVm0ziokKPxBxizIymZQwGI=
X-Received: by 2002:a17:906:cf90:: with SMTP id um16mr1143616ejb.389.1614929348136;
 Thu, 04 Mar 2021 23:29:08 -0800 (PST)
MIME-Version: 1.0
References: <20210305060908.2476850-1-ipylypiv@google.com>
In-Reply-To: <20210305060908.2476850-1-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 5 Mar 2021 08:28:57 +0100
Message-ID: <CAMGffE=VouHcN8ryFN-AaVs0aFzCDao=vu++v1PXH_TLhEEeKA@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Replace magic numbers with device state defines
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 5, 2021 at 7:11 AM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> This improves the code readability.
>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks!

> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index a98d4496ff8b..0cbd25a2ee9f 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -738,7 +738,7 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
>                 if (pm8001_ha->chip_id != chip_8001) {
>                         pm8001_dev->setds_completion = &completion_setstate;
>                         PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
> -                               pm8001_dev, 0x01);
> +                               pm8001_dev, DS_OPERATIONAL);
>                         wait_for_completion(&completion_setstate);
>                 }
>                 res = -TMF_RESP_FUNC_FAILED;
> @@ -1110,7 +1110,7 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
>                 sas_put_local_phy(phy);
>                 pm8001_dev->setds_completion = &completion_setstate;
>                 rc = PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
> -                       pm8001_dev, 0x01);
> +                       pm8001_dev, DS_OPERATIONAL);
>                 wait_for_completion(&completion_setstate);
>         } else {
>                 tmf_task.tmf = TMF_LU_RESET;
> @@ -1229,7 +1229,7 @@ int pm8001_abort_task(struct sas_task *task)
>                         /* 1. Set Device state as Recovery */
>                         pm8001_dev->setds_completion = &completion;
>                         PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
> -                               pm8001_dev, 0x03);
> +                               pm8001_dev, DS_IN_RECOVERY);
>                         wait_for_completion(&completion);
>
>                         /* 2. Send Phy Control Hard Reset */
> @@ -1300,7 +1300,7 @@ int pm8001_abort_task(struct sas_task *task)
>                         reinit_completion(&completion);
>                         pm8001_dev->setds_completion = &completion;
>                         PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
> -                               pm8001_dev, 0x01);
> +                               pm8001_dev, DS_OPERATIONAL);
>                         wait_for_completion(&completion);
>                 } else {
>                         rc = pm8001_exec_internal_task_abort(pm8001_ha,
> --
> 2.30.1.766.gb4fecdf3b7-goog
>
