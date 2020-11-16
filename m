Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD763C4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 12:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E070207BC
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 12:16:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="JexUH3oN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgKPKpH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 05:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729479AbgKPKpG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 05:45:06 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA77C0613CF
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2020 02:45:04 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id i19so23693386ejx.9
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2020 02:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sek/i1BZU5tFdGfXS3etK+U+9o77+wuSOUC6uxbxR3s=;
        b=JexUH3oNg/+O/1MGzCxGE6JpTmJeLdN9MxcPPb/eCCszylnA3C8UW1kT2RwVMnHsWN
         +fCa3M0SaL6oAL/PQJaS4qDOQTaBuziPrk1sZIueT1WrWCv+PeLyLVnCA+Q8gaomZhIe
         dgyNAeoOBX/cD8hbZ1AJC8VdE2qegCPRqQDH3VfB27aw5w533mzl7wc5ABf3phTU02HH
         VZCSAhgLGHyzOR5WIFisZ1oh9dC/n4VsBfQjV+iLU3AbvVYpPY4gdw3qJ9SI+Lx2r3Vo
         PgQkj/Ol0v89APBJbzt6qglQYOZbDxdbUy6ZDUMefFtsPJGrcewIC4pQHSRGOLw74IBd
         rlEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sek/i1BZU5tFdGfXS3etK+U+9o77+wuSOUC6uxbxR3s=;
        b=tE1fv9jyQpPsOi9HWAkMOTmDjXgt3HahlfO+6QbS+2btS55HDzZNC2RDiZRphTCcJ0
         yvfjbVMiKou8rzfzGicRF6rtfa3Hn9CleL8l1WgksTmB+ik/72SzJ16JUk3s9/D4gc0I
         yKc4Snkf8lZhazEibqN95OExVVs8fwakpiBs4X+jd1Me+9eQXDDLihWc3B9aO2Oj1vT3
         gcFZVAFk6BG+UPRBKjB1I9KctgF6Y37B4zhORaHEM9xWIb/+rH1xcqF6HDYKm8NlMHJF
         KZOKE9Jw6m8oRvgB40X6Mr/Ar14wH3PgWzfwQY0EVHyWuC7ORxO3uQ4Z7qcBMpwQOJ7s
         E1bA==
X-Gm-Message-State: AOAM530o6QCiL1IQj0JFiO3I71I9w8I7R/1Veu7DqpxMyRWILJ7Co9q6
        uo7ihF2r55tUFV4cvvRgX+nNX2aBcuRRUpnYsp3EVXDcj5dtnw==
X-Google-Smtp-Source: ABdhPJzsRBZs0RABLzY6Tdu0t6T6Yqz40F1mjZK54r4nhUt/s/Nkw1o860lZqOvGKf1UJRSsE2+NxE2Vb9hxREZS5qU=
X-Received: by 2002:a17:906:ad8c:: with SMTP id la12mr13607890ejb.521.1605523503286;
 Mon, 16 Nov 2020 02:45:03 -0800 (PST)
MIME-Version: 1.0
References: <20201116104119.816527-1-lee.jones@linaro.org>
In-Reply-To: <20201116104119.816527-1-lee.jones@linaro.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 16 Nov 2020 11:44:52 +0100
Message-ID: <CAMGffEkMahL5Fw6w6izwOu2wh3RqAebm9-N3KCadS2N177rLKg@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: pm8001: pm8001_hwi: Remove unused variable 'value'
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 16, 2020 at 11:41 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> Hasn't been used since 2009.
>
> Fixes the following W=3D1 kernel build warning(s):
>
>  drivers/scsi/pm8001/pm8001_hwi.c: In function =E2=80=98mpi_set_phys_g3_w=
ith_ssc=E2=80=99:
>  drivers/scsi/pm8001/pm8001_hwi.c:415:6: warning: variable =E2=80=98value=
=E2=80=99 set but not used [-Wunused-but-set-variable]
>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks Lee.
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
> index 2054c2b03d928..0a1e09b1cd580 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -416,7 +416,7 @@ int pm8001_bar4_shift(struct pm8001_hba_info *pm8001_=
ha, u32 shiftValue)
>  static void mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha,
>                                      u32 SSCbit)
>  {
> -       u32 value, offset, i;
> +       u32 offset, i;
>         unsigned long flags;
>
>  #define SAS2_SETTINGS_LOCAL_PHY_0_3_SHIFT_ADDR 0x00030000
> @@ -467,7 +467,7 @@ static void mpi_set_phys_g3_with_ssc(struct pm8001_hb=
a_info *pm8001_ha,
>         so that the written value will be 0x8090c016.
>         This will ensure only down-spreading SSC is enabled on the SPC.
>         *************************************************************/
> -       value =3D pm8001_cr32(pm8001_ha, 2, 0xd8);
> +       pm8001_cr32(pm8001_ha, 2, 0xd8);
>         pm8001_cw32(pm8001_ha, 2, 0xd8, 0x8000C016);
>
>         /*set the shifted destination address to 0x0 to avoid error opera=
tion */
> --
> 2.25.1
>
