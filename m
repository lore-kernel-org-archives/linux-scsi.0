Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FB7C63798
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 14:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 464C8221F7
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 14:02:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Va5VHao1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390011AbgKZOCD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 09:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389867AbgKZOCD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 09:02:03 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9B0C0613D4
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 06:02:01 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id 7so3137777ejm.0
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 06:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C//B80UKsPK42OnJkphrjgs/wi9PrOEUKSvu4T2pPCo=;
        b=Va5VHao16C8ylNksfKF3uVxr4ASphzaBEyKfiBAMrb8Ph1Gkj9FOJwyvAgYhnTeixp
         WMj8PhmtD/eu7d8rBAxk2ijMYb25zeWj/L5MKrMWwU3nKUEDEG57WaHHj+QozeKiA7CK
         3lZF82bhvFbi+abXHhsyNh/x0HWoB9Fcu32UCl4a6xci/2jJHMmmoVhCjNezmhTPxwPY
         8u9m7EcE0T3BHVcjlH2t+gViqwuNjCs9E+cmO9s2Ami3nXzsHjEKu3M/vprHSrjKGxa7
         khr2UPD2IHKBZ5m9Q1uRMNQYREfOeutaD7oDPg53ldESp6mXV6i3SqVHK73gF7ih5vZK
         reeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C//B80UKsPK42OnJkphrjgs/wi9PrOEUKSvu4T2pPCo=;
        b=CttyisavY79DmLNanwFBiGOm65RAeIcPQDYq1skwG86k7mLE9T1fE/arjoAXwuMFDz
         cimIOChJAmNghByGgYGYdQdAnONWwLJcmRsPNl4EcRkZ3pqZYs2/tg1scnkkdvcC9+y5
         pW8ddc9/0b94G8tyBs168Nr4gMScSyo5LG1ufJBWpEj+jE7GPV6UA00PjQfS8mpGVV6U
         1RzvvrVGPR+0tWkb9HsTLmDsbdlBjxtvk4vDZE15UgngpPg3ghq7OfRcv3zZ5N1lreV/
         w+9wuHx4jJsUi7gVwT/v2r8mJ0qbhVBbx8rOSaHxO+Af5DWN0O+qUc0ToEngYq0g/+NI
         fBTA==
X-Gm-Message-State: AOAM531mDtwVgc1gjDdETJrJiR9+foAVU2BjwPceZh6FqmuH0LAt66ll
        XNRzairfALZ9+q2I4VbPv9q3T36OizBrzjgRXqNRHA==
X-Google-Smtp-Source: ABdhPJw137LyNOPuU8evpHIqYGUXPc4VybKBndRUo+PEoVMXB3gSi+WS6uuhYdkyaB2U2vIOPc0TKnzAu2kmaKXGO4Q=
X-Received: by 2002:a17:906:1e0c:: with SMTP id g12mr2872384ejj.115.1606399319938;
 Thu, 26 Nov 2020 06:01:59 -0800 (PST)
MIME-Version: 1.0
References: <20201124093828.307709-1-colin.king@canonical.com>
In-Reply-To: <20201124093828.307709-1-colin.king@canonical.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 26 Nov 2020 15:01:49 +0100
Message-ID: <CAMGffEnNkj4GkM-Er-MDuUQiFdZCBD-Bzb1_pGGXazfH=NkCtQ@mail.gmail.com>
Subject: Re: [PATCH][next] scsi: pm8001: remove space in a debug message
To:     Colin King <colin.king@canonical.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 24, 2020 at 10:38 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> There are two words that need separating with a space in a
> pm8001_dbg message. Fix it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 08d6cc9b50db..c8d4d87c5473 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1031,7 +1031,7 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
>         regVal = pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK);
>         pm8001_cw32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK, regVal3);
>         pm8001_dbg(pm8001_ha, INIT,
> -                  "GSM 0x700048 - Write Data Parity Check Enableis set to = 0x%x\n",
> +                  "GSM 0x700048 - Write Data Parity Check Enable is set to = 0x%x\n",
>                    pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK));
>
>         /* step 13: bring the IOP and AAP1 out of reset */
> --
> 2.29.2
>
