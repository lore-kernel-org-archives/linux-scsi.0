Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34975C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Oct 2022 05:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiJJFSu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Oct 2022 01:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiJJFSs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Oct 2022 01:18:48 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EE74D4D6
        for <linux-scsi@vger.kernel.org>; Sun,  9 Oct 2022 22:18:47 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id f9so11969881ljk.12
        for <linux-scsi@vger.kernel.org>; Sun, 09 Oct 2022 22:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+nkMeCXxzGXlGJQhh7qRiw4sZOCAzXw3zore0ZN0OEM=;
        b=M2VK7WpB0IDREsuOBEY5tqwAeITfFrku/zOZdtDqNjn4GVgLR0noVKFat/HxiBLuDl
         FDfeJzhTFIWjoTrZDcnA+kYe139eF4jiHAnw1HBUsceZzLO19+g04uq+cXti8aqFXU4r
         0rc04mpJgrAiuTs7o5TLpoEyHfPeztz0m/9XsTYm5xLMSt0TF912yTipdwM+8pEckmRL
         gR3eyQSSlPTvyg9RQbFc4B2D4eDifZ9J0rx1cgcacFJMKVlFEzU3n1A5IWz5wBE8HxBR
         +ccaVAbHxNLsKG+fMQ8Yw7u1nGbZKZYqlh0Z7Bf1+SUAz5rzk5csSuVceXpBUk+3kstD
         hSiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+nkMeCXxzGXlGJQhh7qRiw4sZOCAzXw3zore0ZN0OEM=;
        b=rarqquot63iN0odzXH4MMMcPG8qc6UqumYxfyf+Uq9EYlhFsh1i3RSHuVtke+mwkGl
         76JgpfFckGUjCxraUY6uZ+y5K6ZTVCUPI0rcKMsOB5n3t/r+R1jh02Jg7q/FbWhhG2/y
         T6r6vnCK+sSylwq4WlZXl/3p7pif2w2PAGgyMIrO68nrB+FWKtzEyUfOTHkEQRJAcJKi
         2q9zahXgetCBTl+o5jabCApjPeg03JA709cEkhEINXM7W912dLvuS597JmfRMKi85hdV
         obiYVI+O/Zp15hiyf8o9G5xHeamlAmBvww8azs7Bv4J/SE5+XOjzeTmK7urzLDrQGQcF
         5AJA==
X-Gm-Message-State: ACrzQf2KN7P5eUs37hUJQA/fewsZ9wnFgdD5CjrJd940B1v8CKkO6HZf
        jud95fJv4f/+g2Hh6mYvx7fEjXp+9yWuFtcxQjd8SQ==
X-Google-Smtp-Source: AMsMyM7sXjXMf9kGFqVwzix9Ad5+isYgkHy4t18JK+34KDlMagyDCiuUx81234NcYxNqBVTMJoVoW4x6wuQTDHwvKOk=
X-Received: by 2002:a2e:9e50:0:b0:261:e3fd:cdc5 with SMTP id
 g16-20020a2e9e50000000b00261e3fdcdc5mr6086659ljk.56.1665379125880; Sun, 09
 Oct 2022 22:18:45 -0700 (PDT)
MIME-Version: 1.0
References: <20221007230751.309363-1-ipylypiv@google.com>
In-Reply-To: <20221007230751.309363-1-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 10 Oct 2022 07:18:34 +0200
Message-ID: <CAMGffEkLNMUH1_KSPP=WJBy0GTuWXvyiD6dOsK7phU=+cBCQgw@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Remove unused reset_in_progress flag logic
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

On Sat, Oct 8, 2022 at 1:08 AM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> The reset_in_progress flag was never set.
>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> Reviewed-by: Andrew Konecki <awkonecki@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.h | 1 -
>  drivers/scsi/pm8001/pm80xx_hwi.c | 4 ----
>  2 files changed, 5 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index b08f52673889..2bbec5083106 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -535,7 +535,6 @@ struct pm8001_hba_info {
>         bool                    controller_fatal_error;
>         const struct firmware   *fw_image;
>         struct isr_param irq_vector[PM8001_MAX_MSIX_VEC];
> -       u32                     reset_in_progress;
>         u32                     non_fatal_count;
>         u32                     non_fatal_read_length;
>         u32 max_q_num;
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index f8b8624458f7..51c9541f6f4d 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3550,10 +3550,6 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         case HW_EVENT_PHY_DOWN:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_DOWN\n");
>                 hw_event_phy_down(pm8001_ha, piomb);
> -               if (pm8001_ha->reset_in_progress) {
> -                       pm8001_dbg(pm8001_ha, MSG, "Reset in progress\n");
> -                       return 0;
> -               }
>                 phy->phy_attached = 0;
>                 phy->phy_state = PHY_LINK_DISABLE;
>                 break;
> --
> 2.38.0.rc1.362.ged0d419d3c-goog
>
