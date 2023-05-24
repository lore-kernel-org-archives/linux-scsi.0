Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9595C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 06:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239552AbjEXGfH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 02:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239443AbjEXGfG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 02:35:06 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0336A184
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 23:35:05 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-96fbc74fbf1so82388766b.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 23:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1684910103; x=1687502103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1wUIJMfAo0/AosKYM4CFvgerfUFkbb5h7skbboxjNk=;
        b=bYgXzpU/awJ0+ETrxbiLpTzWHBhjQqTGv8/32UVjV48zHtUevfBFi6SMmToo/vpamV
         GznXbYsUrHbqI+m5fVEli++e5vwnW0Zpb6teIHTh/r1UcImdfq97TsG7JvJVpGARTDpA
         qC1kCZ3/WzTdfqoUEUh8rLCspfY25g8luc8B6eG0lSyo8AeiarRssa7jlPCEfbM02o6y
         qjSNX9qi1qkoAGcn4Omywm/i3Zdr8xsRNAiG8TfeUqvg0epmymaVkaFrqskllY7Y59j4
         /YAvjfhh4Q9kgTHHLpbBssnW2A7MrISl73zhTrLwa2E63hyYvTHRdLzZf46PIPgkJWlJ
         3zzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684910103; x=1687502103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h1wUIJMfAo0/AosKYM4CFvgerfUFkbb5h7skbboxjNk=;
        b=OJYFASb6EETEpYjX4rozRqEclbayPiJYlerKN0MXtBF2jGzBoIihoFfbLF6UBZhJfS
         E4VacWZ+waZ0oEhbJ59A3E4gm0TX1FRpd4kvdXQAUtlZN3lSsxS1FpEs0Xp8CE3m93Cr
         8EZObmV+znQAYCEj0nFIWLHlZQnF1RU9x6Q8NCuKf733oJstLhCP8IkCi4ctdwGT1y+K
         S4k5I0VFBUi6WE3bHB8PTTZ3TM1qkCrBZb5eoCWyhmHN0+ILf5Fxg0tmT3Niyl4vnYVO
         4JbXeJX438CIcGnQclxDEqyMVHe2olVHfnGq3TzWKxOSTN5CJI5npO2s1qXx9CGTCGBb
         7wsA==
X-Gm-Message-State: AC+VfDwSNp6t17Nlz9fNHKxM5FiMCyYmJ11bDXKJ//lpqw2PIJXWbzrf
        65ukI/zpqwE6cDPIa3hNE5CBaEDHoJ+UbfVOE3GxtL62wO/Pq4gP
X-Google-Smtp-Source: ACHHUZ5Vt7DbqCG5icK+LBKYsRYQ7t53nm7nT80Zqm+kcEebiw5nDR0OjvWoVsnbVufGuAdQuciNJ9K2GX4dBEPqwA4=
X-Received: by 2002:a17:907:6d9d:b0:96f:cb23:daf6 with SMTP id
 sb29-20020a1709076d9d00b0096fcb23daf6mr11031279ejc.40.1684910103457; Tue, 23
 May 2023 23:35:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230523214127.4006891-1-pranavpp@google.com> <20230523214127.4006891-2-pranavpp@google.com>
In-Reply-To: <20230523214127.4006891-2-pranavpp@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 24 May 2023 08:34:52 +0200
Message-ID: <CAMGffE=mf_9ik6Sc19rQu_cC6rTacF6-Bd1xFYbgumoXnZsgVQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: pm80xx: Add fatal error check for pm8001_phy_control()
To:     Pranav Prasad <pranavpp@google.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changyuan Lyu <changyuanl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 23, 2023 at 11:41=E2=80=AFPM Pranav Prasad <pranavpp@google.com=
> wrote:
>
> From: Changyuan Lyu <changyuanl@google.com>
>
> This patch adds a fatal error check for the pm8001_phy_control() function=
.
>
> Signed-off-by: Changyuan Lyu <changyuanl@google.com>
> Signed-off-by: Pranav Prasad <pranavpp@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
> index e5673c774f66..b153f0966e5d 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -167,6 +167,16 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, =
enum phy_func func,
>         pm8001_ha =3D sas_phy->ha->lldd_ha;
>         phy =3D &pm8001_ha->phy[phy_id];
>         pm8001_ha->phy[phy_id].enable_completion =3D &completion;
> +
> +       if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
> +               /* If the controller is in fatal error state,
> +                *  we will not get a response from the controller
> +                */
> +               pm8001_dbg(pm8001_ha, FAIL,
> +                               "Phy control failed due to fatal errors\n=
");
> +               return -EFAULT;
> +       }
> +
>         switch (func) {
>         case PHY_FUNC_SET_LINK_RATE:
>                 rates =3D funcdata;
> --
> 2.40.1.698.g37aff9b760-goog
>
