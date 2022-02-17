Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AEDC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242994AbiBQTJ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:09:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239751AbiBQTJZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:09:25 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB4C2B254
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:09:10 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id f17so11452630edd.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MN1Mj9YbMjB2lFdZHuFrb9Y9T4Ihfxx+Un1sXw0cH/g=;
        b=Cv2nZC/XTHY8+vmpb4JWHNhzqPfeBWiRMpRg9RkLuW13ttUON6jC7uXnHYFSip9LaU
         SM4V83KVIFPO1Uw9UZtHEIrDSbceed9/1bGbhXWrO0Rj+v+SJ8jKDkSr1kDT/dm+7V8D
         oFCRd1NErfniR2RCBCG7LrNp6VWetxBTPrHDybvWS0MbkYzyh4nRiOIjqMPsc+PxRzRM
         Ww5iZj3d+Yel5czgqe7NVS8gQJf6v+15wczz3nEkyGRdqroAWLiF04fClP/kGaNA0adQ
         p/hS6w14Rhesfk5HNc6w6SgFXvmp0Xochs9KcDOtt4A0Bem1f6JAGcUB+9tevhM/pkwL
         Twkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MN1Mj9YbMjB2lFdZHuFrb9Y9T4Ihfxx+Un1sXw0cH/g=;
        b=tBq4ffd2FzqPf05TxOISinlB1PWqsn9lKo2PM8YDO/2kGtAsKITY7443vXHhP1g39e
         RTHbFLSyJaJSMVAJ766nLA2mlLNrNzzaXUKnI0Pe436gREDcDEHgStYoW+O5MunSlTTa
         OPGBrTIxIcjA1fGgs+sOfqGhTqRbGZC1PQ4HeojhoDnCaq4fp/oqRr1qfU8AFmJg7xlR
         iYZcRl9M1nUgj1jztucWIIoeLZ/3xoEaFnt8Tbv9u70gSLW3ifdw6tn7bdlMMFRumqeF
         NUlNNZ6iIoBitXA+/0iLUDVz7kXqxJ/hSQcKjN/v0mV2ZYpEYnaYearNGJCmk6p//Q7h
         qzoQ==
X-Gm-Message-State: AOAM5303H7HIbcWNHuBPGU5CquHhG+knOh3+60UVeTILkrxruQ5/64pt
        OtkB1XVRq9O1TdVN0uVVp1jEzba4Lm/8GrFn4mCS6g==
X-Google-Smtp-Source: ABdhPJypCtHin4j5uzAr/pBxrG8ncSTdgB13mrG7xpUNT5CI3KPn0E6xOtDKVxEQzCfssCk8gmjuZnsGcHM6d4TqzWw=
X-Received: by 2002:a50:a6c2:0:b0:410:a328:3c86 with SMTP id
 f2-20020a50a6c2000000b00410a3283c86mr4181672edc.55.1645124949342; Thu, 17 Feb
 2022 11:09:09 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-10-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-10-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:08:58 +0100
Message-ID: <CAMGffEmdj=URbWw-OGo0yq3P-NtF3ctm89u8UfJUj+kGwNtFdw@mail.gmail.com>
Subject: Re: [PATCH v4 09/31] scsi: pm8001: Fix payload initialization in pm80xx_encrypt_update()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 17, 2022 at 2:30 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> All fields of the kek_mgmt_req structure have the type __le32. So make
> sure to use cpu_to_le32() to initialize them. This suppresses the sparse
> warning:
>
> warning: incorrect type in assignment (different base types)
>    expected restricted __le32 [addressable] [assigned] [usertype] new_curidx_ksop
>    got int
>
> Fixes: 5860992db55c ("[SCSI] pm80xx: Added SPCv/ve specific hardware functionalities and relevant changes in common files")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx!
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index e6fb89138030..b06d5ded45ca 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1405,12 +1405,13 @@ static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
>         /* Currently only one key is used. New KEK index is 1.
>          * Current KEK index is 1. Store KEK to NVRAM is 1.
>          */
> -       payload.new_curidx_ksop = ((1 << 24) | (1 << 16) | (1 << 8) |
> -                                       KEK_MGMT_SUBOP_KEYCARDUPDATE);
> +       payload.new_curidx_ksop =
> +               cpu_to_le32(((1 << 24) | (1 << 16) | (1 << 8) |
> +                            KEK_MGMT_SUBOP_KEYCARDUPDATE));
>
>         pm8001_dbg(pm8001_ha, DEV,
>                    "Saving Encryption info to flash. payload 0x%x\n",
> -                  payload.new_curidx_ksop);
> +                  le32_to_cpu(payload.new_curidx_ksop));
>
>         rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
>                         sizeof(payload), 0);
> --
> 2.34.1
>
