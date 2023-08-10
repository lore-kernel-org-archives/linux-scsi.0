Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395ADC04A6A
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 14:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbjHJO1i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 10:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235066AbjHJO1h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 10:27:37 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E88BE4B
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 07:27:36 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-5230df1ce4fso1235625a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 07:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1691677654; x=1692282454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mBseE1wu1Bsd448nakRhJvat8Ap+p5gQbDjVQAFktlY=;
        b=RJJouPar3swIZgrXGnld5iJGpyqY28eSNB0tXevtHsCBTgKWyZSF6YSCyU8wpTsTq8
         VyKaFxJvryL0qcwIbQW3rTBS6sdo29IxesNLOpZwGqsT4fMMCgi0Uh0RDWkGVgL3euSt
         lSs7D6mwa2nyuXncq2Lc5T1IvOPasQdqm40OrqeEI/3wyHCLOSyTZ//0Hfr1YhpAgC3U
         TGrXDH+OWh9p6xATmCWsZ76pvxO0zSLGmQlJQD+8vtIwJqquO7AUxq4Ynz7d+jX6bM2X
         0J79viTQgWvmrFv1wA0SSV0o7avqZhI1fOZ77DurkFK2ybC8zzbm9ZP4G08oVnbsD+6I
         iJzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691677654; x=1692282454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mBseE1wu1Bsd448nakRhJvat8Ap+p5gQbDjVQAFktlY=;
        b=aTNZV/BfAlmMPicnp0so3zriPQ+Dpc39caPNT+JZhrZ0Uc8fHibGZtvn0sZnDSWH6C
         z9NjfQSMAiAb3KnG5fpUGu/XXKkPCUXbTFS2MU7+v8mAjst+LZ5mc94mOFb0Yijoh40W
         mfF7uN6E/WOyYg+6EHzgzGnEXt9sb2tg2pjlOUYzl3eD5nsU9vvfdYZpWWJBhgbX5m1m
         3dSknaCdXgt+D5mx6Pg2snI426xB24Mo8ZdbkOAP92QOFQmK/MpbkyTmlxpec0KTD9Hz
         WSiorqcqtCZ8FupSygJuCyWbEHwZi+sZA4MUAxFyPKZz4bCtEtdTyRgBuGembyn/5PDP
         ypDQ==
X-Gm-Message-State: AOJu0Yyb6A6bHYGlzsdSRpCHuWbPrTbt3SYMrqj66fOKE0xf8DmHELTe
        s0KaZ9GvE7F1LUp0Yzob5N4UoeH9wvH5GDufb+hxvQ==
X-Google-Smtp-Source: AGHT+IFWgXBeCEmWnrY4QmZeloDE7h4/FQZj3Gcue2VuhcLFulwXf+nZpJNmcR9GtKxBmLv+3k52zZV7lle6df+14Tk=
X-Received: by 2002:aa7:d44f:0:b0:522:30cc:a1f0 with SMTP id
 q15-20020aa7d44f000000b0052230cca1f0mr2198658edr.14.1691677654808; Thu, 10
 Aug 2023 07:27:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230810141947.1236730-1-arnd@kernel.org> <20230810141947.1236730-8-arnd@kernel.org>
In-Reply-To: <20230810141947.1236730-8-arnd@kernel.org>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 10 Aug 2023 16:27:24 +0200
Message-ID: <CAMGffE=3rboXRW+UF+p_SEdUmBUCZ86oBFD8iKJcX0FR5GNoHQ@mail.gmail.com>
Subject: Re: [PATCH 07/17] scsi: qlogicpti: mark qlogicpti_info() static
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 10, 2023 at 4:22=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> wro=
te:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The qlogicpti_info() function is only used in this file and should
> be static to avoid a warning:
>
> drivers/scsi/qlogicpti.c:846:13: error: no previous prototype for 'qlogic=
pti_info' [-Werror=3Dmissing-prototypes]
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
lgtm
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/qlogicpti.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
> index f88a5421c483f..3b95f7a6216fe 100644
> --- a/drivers/scsi/qlogicpti.c
> +++ b/drivers/scsi/qlogicpti.c
> @@ -843,7 +843,7 @@ static int qpti_map_queues(struct qlogicpti *qpti)
>         return 0;
>  }
>
> -const char *qlogicpti_info(struct Scsi_Host *host)
> +static const char *qlogicpti_info(struct Scsi_Host *host)
>  {
>         static char buf[80];
>         struct qlogicpti *qpti =3D (struct qlogicpti *) host->hostdata;
> --
> 2.39.2
>
