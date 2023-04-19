Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D03C77B73
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 07:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbjDSHTl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 03:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjDSHTk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 03:19:40 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE3E46B4
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 00:19:39 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id c9so40321878ejz.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 00:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1681888778; x=1684480778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YmiDYKhnrGjE/iF5nCOixO+clc1Eq1u8ptfYIu/KICs=;
        b=FXhTvMr4107+hdjyt0ToXeLPTOb1YahvG2e0E3ikdac2kVMt/N/DlkfsO5eGIgS0wu
         9D2g1KHaciwUtbz1qjbfl4BNU9Vv5RWDPdWFMdu3PcJGlWQQoReRyWfjTOJB7Jf/fdLC
         H25gSffdJY0zuuyr2edOD9NrdBQJzsOinBRx6+7loRrWQlcjrJiva9f+YVhg7iQ8Auxa
         fhtYSPrliv8U4mAE5UvRy59C5TS9+L4lcgtuw/aZeq7/4pevhI7Yc8eS5tNBvhNxrzR2
         zlVDjXFMy7ZOlKRC4cZ9HjeYTBX/O/moTdb5GKM5ZfnIDCFBcEHYh8OQzE0OGIAijewf
         VtNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681888778; x=1684480778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YmiDYKhnrGjE/iF5nCOixO+clc1Eq1u8ptfYIu/KICs=;
        b=jC8Btapy88g7s7+L84j4ftjxCJFY3ehKbe224Cs7lhQEnUfaOlStcF/CJeiq6xOpp6
         e6LCAQuuJT+U0IpJH2Hr+PxpohVPIJ7ywi3sGDAIwaJttX9hLAidBkPbBqg5PAgu+Vd/
         yz9XZHrjGLXR8PLihG6TFwsGLcSj8TU43SieWUtA5d3V/1Z+t4mk7FOK6zdq52HWXiMH
         ZCxWbYcv6W5KvOEQIMk4y0PmxO3bhWdHXmoheEWlJ3HpfW8um7sEiE3d7U9AhVZWUNPv
         R1czUqesAmVorELhnkn6RxPhDwRPyWnMt2tMUBF4dGtdlj6+oDoq+DIXopi6ODRCqLCX
         tK2g==
X-Gm-Message-State: AAQBX9c5uFm86x4LxrtT2hFj87HIQn+CD1SDuDwaJVWI9Rbgz3cWhVel
        DaDV3SbWiGy1RfOHrxXIZ02/fzr+W7uccSpjMrkoiQ==
X-Google-Smtp-Source: AKy350aeS8MlXw3mwInKS7I8rAM3DRXtOBDggcnQYsJa42CBmO7gh7SSzIT0lzlGEgXcGwh7qDFvWQwDa0h45Do5AR4=
X-Received: by 2002:a17:906:57c6:b0:87f:e5af:416e with SMTP id
 u6-20020a17090657c600b0087fe5af416emr6733144ejr.7.1681888778038; Wed, 19 Apr
 2023 00:19:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230418190101.696345-1-pranavpp@google.com> <20230418190101.696345-3-pranavpp@google.com>
In-Reply-To: <20230418190101.696345-3-pranavpp@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 19 Apr 2023 09:19:27 +0200
Message-ID: <CAMGffE=UcmXeXb9DY5ApgCoE0tBtT=XaSB4n276FBwFYzrRYZQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] scsi: pm80xx: Enable init logging
To:     Pranav Prasad <pranavpp@google.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Akshat Jain <akshatzen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 18, 2023 at 9:01=E2=80=AFPM Pranav Prasad <pranavpp@google.com>=
 wrote:
>
> From: Akshat Jain <akshatzen@google.com>
>
> Enable init logging to debug drive discovery issues.
>
> Signed-off-by: Akshat Jain <akshatzen@google.com>
> Signed-off-by: Pranav Prasad <pranavpp@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 2 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index d8dc629c0efb..041cdc41af80 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -44,7 +44,7 @@
>  #include "pm80xx_hwi.h"
>
>  static ulong logging_level =3D PM8001_FAIL_LOGGING | PM8001_IOERR_LOGGIN=
G |
> -                                                        PM8001_EVENT_LOG=
GING;
> +                               PM8001_EVENT_LOGGING | PM8001_INIT_LOGGIN=
G;
>  module_param(logging_level, ulong, 0644);
>  MODULE_PARM_DESC(logging_level, " bits for enabling logging info.");
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index ce6a442d2418..61c1bf3d98a0 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4837,7 +4837,7 @@ static void mpi_set_phy_profile_req(struct pm8001_h=
ba_info *pm8001_ha,
>         payload.tag =3D cpu_to_le32(tag);
>         payload.ppc_phyid =3D
>                 cpu_to_le32(((operation & 0xF) << 8) | (phyid  & 0xFF));
> -       pm8001_dbg(pm8001_ha, INIT,
> +       pm8001_dbg(pm8001_ha, DISC,
>                    " phy profile command for phy %x ,length is %d\n",
>                    le32_to_cpu(payload.ppc_phyid), length);
>         for (i =3D length; i < (length + PHY_DWORD_LENGTH - 1); i++) {
> --
> 2.40.0.634.g4ca3ef3211-goog
>
