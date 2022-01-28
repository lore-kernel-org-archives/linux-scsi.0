Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDF8C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 06:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346342AbiA1GSV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346338AbiA1GSU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 01:18:20 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D493C061714
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 22:18:20 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id o12so12446031eju.13
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 22:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lt8KNb/m46lTmKOmkwglDC4yqStdQ6NhHi7nDy+wPxg=;
        b=PFMaFWxOe0RtiFl0RKboCgHp519n7nd2AeO37R/2S18vF26/0w9igzJWpCbMjN4Hf/
         iKgVnutjzn+/u3GwXwJDMSbIll/DrnyyN319T1Njm5+fUiqzLZfAt3Q+sihKFyuvTHfg
         BVa9AplFZB9JouQ1cVYSRlxfno4Xa7vohAJCuc6gM2CvFAOBHRHr4sl8jTOr1wdSe3Rx
         RWEsHNIQpvvB1fScPF9URTxXPg9v6lbS8JZ+p91SZG9VZeva/jQsIep2VKXGWKMycZb6
         fIBO+QCQWw7MqBvG8rXwbIeAJzljT+x+BUynjC0shzVXmyRyYrBWlWVcK0Rj81hVDiTR
         /LLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lt8KNb/m46lTmKOmkwglDC4yqStdQ6NhHi7nDy+wPxg=;
        b=s/3BBozvbFTFLP4g8C3Q/wENwXAsjR5g9KuK9QkzZ9fHM0kQ6WVFDWtvFUVIZte8KU
         g1pjwhzqZnhRDwMvJgKrBPkISI0i8XPwXaFCtGQi1Arn4X7uXaJN6Rq4RmKJYlcl07mg
         7V7aa0+HeLDuGM0un9ateAz3kGY08GdfIxJIvo+2l71tsdbGPdE7VxnqD+6mu4vT8BZ1
         lrrrPPeX1hZQTo2AAwklLvYZQ5ZFBQrMZt57v3njWFCPIhM/UBczrotiRd2UCUszYre/
         GpS+zOXnMsrZ849/TdfHH4Ttib9Lwv1RpGZhOwc41KuBDnmoKMXBUGMLl7nPaZiLBF3b
         mWEQ==
X-Gm-Message-State: AOAM5321ry9yDckJNzXRWx4pnBbfLinbCp5R9823RedEHemstaeKz/Wy
        h/2J88hP37V7rdfC8HmkCe+TC0m+ZV6XR1NySgD3NA==
X-Google-Smtp-Source: ABdhPJwY1penhEMI+8/AGF8qPOmc8YqR6syjMoix33PxXWWna4oa8W24r9Tc1PDZLpfzyPb5gLlBBo34M3Vh+hvDmIw=
X-Received: by 2002:a17:907:1b1c:: with SMTP id mp28mr5704751ejc.624.1643350698470;
 Thu, 27 Jan 2022 22:18:18 -0800 (PST)
MIME-Version: 1.0
References: <1643289172-165636-1-git-send-email-john.garry@huawei.com> <1643289172-165636-3-git-send-email-john.garry@huawei.com>
In-Reply-To: <1643289172-165636-3-git-send-email-john.garry@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 28 Jan 2022 07:18:07 +0100
Message-ID: <CAMGffEkrKq7kZK=dEEXcm-nA9A2VfUUTTLiXDTTXP4Q3nPo02g@mail.gmail.com>
Subject: Re: [PATCH 2/3] scsi: pm8001: Fix use-after-free for aborted TMF sas_task
To:     John Garry <john.garry@huawei.com>
Cc:     jinpu.wang@ionos.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, damien.lemoal@opensource.wdc.com,
        Ajish.Koshy@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viswas.G@microchip.com,
        chenxiang66@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 27, 2022 at 2:18 PM John Garry <john.garry@huawei.com> wrote:
>
> Currently a use-after-free may occur if a TMF sas_task is aborted before
> we handle the IO completion in mpi_ssp_completion(). The abort occurs due
> to timeout.
>
> When the timeout occurs, the SAS_TASK_STATE_ABORTED flag is set and the
> sas_task is freed in pm8001_exec_internal_tmf_task().
>
> However, if the IO completion occurs later, the IO completion still thinks
> that the sas_task is available. Fix this by clearing the ccb->task if
> the TMF times out - the IO completion handler does nothing if this pointer
> is cleared.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>
> Note: For hisi_sas driver we already do something similar. However there
> we also flush the completion queue interrupt to ensure that there is no
> race in clearing the task pointer. Please advise if/how something similar
> can be done here.
Not I'm aware of, but microchip guys know better.
Thx John!
Acked-by: Jack Wang <jinpu.wang@ionos.com>
>
>  drivers/scsi/pm8001/pm8001_sas.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 160ee8b228c9..32edda3e55c6 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -769,8 +769,13 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
>                 res = -TMF_RESP_FUNC_FAILED;
>                 /* Even TMF timed out, return direct. */
>                 if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
> +                       struct pm8001_ccb_info *ccb = task->lldd_task;
> +
>                         pm8001_dbg(pm8001_ha, FAIL, "TMF task[%x]timeout.\n",
>                                    tmf->tmf);
> +
> +                       if (ccb)
> +                               ccb->task = NULL;
>                         goto ex_err;
>                 }
>
> --
> 2.26.2
>
