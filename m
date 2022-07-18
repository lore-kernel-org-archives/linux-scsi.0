Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85A5C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 13:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbiGRNLB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 09:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbiGRNK6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 09:10:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932631D30A
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 06:10:57 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id s21so11666978pjq.4
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 06:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ph3uhCHYF3MS80ng/XwPYbh3jLpt+WFtffo9ialWLL0=;
        b=qZdO0gx1Vx4/26BGyrlGwdB1mGleX8HFGCkBPMmqflqyVphiIZQCDX735lMm5k+DGq
         UBpSVaHc5ZF8C09JU0V/chW7EXHYMf2BXcSY9YpIhEdNRVm8jd9scq00e/MDsFhMQuUt
         PnliKU3/94L1zW/TgWOcg44PaHpFe7j8QisR672OiVtYk8jT0aBI+T7SNSm9WwUIDhyj
         FmY/93qdinqcY0xvLMIIDAeJf6cxb2UIIJsA+qxPzrl4Z2U6HaPz6hu6WfpskW5AJyrG
         GM+hmGlKXYTbLSKt/dmcTlmBYeD6lJ2wYb08FctwSjJIYAAvf7AMcb2eISE9IBsvL78w
         SZnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=ph3uhCHYF3MS80ng/XwPYbh3jLpt+WFtffo9ialWLL0=;
        b=mTsot32L1Wyv4NNzjDh8hkGggQnPVNf3PCTHGy37fjw8CUfXwOYyEchvM2eIF5G0D1
         HsS3pbvyGXTll+lL/SXc09PzkVFbQCKIzmTfn3BO4I88fIL3EEMSrMLZGBEEm2AhEv4/
         XT4DuIiTstAl14lgMsS5zDSE8kyEeWcHVpFvTlae+lH3Owbarp0plV+GlXYjrr81vuTU
         JmBL36HIAZgjQlqARfiULMTIF4LbGZFa8sxTqGsurZkwoDkVrGlz9KCRIfYg06xO4azm
         ujNdB3lVeKWJ548X49bw8VdAnKL6DekDKp9g/zgR5dck7acB4z1B/pYHQW4iNqVq8FeV
         zKBQ==
X-Gm-Message-State: AJIora8z48Ko2HDp3dyDYXkAHs1xE8NUDt8EOAyNcZm7S6WdjaY5Fcr4
        ZhLfxWJW1ZFjMUMpI+3kt3A=
X-Google-Smtp-Source: AGRyM1s5a4Qqi1Yoe0lhAI+axwBnizM/Nmi4Q0w0jNJ+3b3TxdWXbKYPLv6WyU0Hlunocc2NutmOmg==
X-Received: by 2002:a17:90b:384b:b0:1f0:6ef2:183f with SMTP id nl11-20020a17090b384b00b001f06ef2183fmr31598886pjb.100.1658149857036;
        Mon, 18 Jul 2022 06:10:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z3-20020aa79e43000000b005284d10d8f6sm9190975pfq.215.2022.07.18.06.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 06:10:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 18 Jul 2022 06:09:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v2 1/1] mpi3mr: Fix compilation errors observed on i386
 arch
Message-ID: <20220718130956.GA3767867@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 18, 2022 at 03:23:51PM +0530, Sreekanth Reddy wrote:
> Fix below compilation errors observed on i386 ARCH,
> 
> cast from pointer to integer of different size
> [-Werror=pointer-to-int-cast]
> 
> Fixes: c196bc4dce ("scsi: mpi3mr: Reduce VD queue depth on detecting throttling")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

Tested-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 0901bc932d5c..4102636df4fc 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -386,7 +386,7 @@ static void mpi3mr_queue_qd_reduction_event(struct mpi3mr_ioc *mrioc,
>  		ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
>  		return;
>  	}
> -	*(__le64 *)fwevt->event_data = (__le64)tg;
> +	*(struct mpi3mr_throttle_group_info **)fwevt->event_data = tg;
>  	fwevt->mrioc = mrioc;
>  	fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
>  	fwevt->send_ack = 0;
> @@ -1660,8 +1660,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
>  	{
>  		struct mpi3mr_throttle_group_info *tg;
>  
> -		tg = (struct mpi3mr_throttle_group_info *)
> -		    (*(__le64 *)fwevt->event_data);
> +		tg = *(struct mpi3mr_throttle_group_info **)fwevt->event_data;
>  		dprint_event_bh(mrioc,
>  		    "qd reduction event processed for tg_id(%d) reduction_needed(%d)\n",
>  		    tg->id, tg->need_qd_reduction);
> -- 
> 2.27.0
> 
> 
> 
