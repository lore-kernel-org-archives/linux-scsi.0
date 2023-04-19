Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E56D8C6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 07:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbjDSHVN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 03:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjDSHVM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 03:21:12 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845C86A66
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 00:21:08 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-94ef0a8546fso292604766b.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 00:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1681888867; x=1684480867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjTbhACbGlqLOGJe8zhnxXVfb1D2+8xDV6pHc1d4gkk=;
        b=Be0iN/cXzsadqwCFCMu+3qQ35WGQWqYF+Z+kH48YjLOdMfVtHewDrqzEc94+TrpG+p
         H4dpNITRv3BML0rgmjiya8w8GGDynn85cbT8uw8wkIvWGE/dnKSVYv61BWgBIR8f3eCF
         jL8Oy4fQj2/l3IYJdTmKs29AEIPv1FoVMNIz3aMkF/Q3LdE2YHYOSCwR6gXD2ewJuPQs
         ynoa4Lkmzpby36o3S/URJ7h8YWs5T/0HOufgl50RpD6OA8B/9Er65KNbkMz+TlhF4glG
         wew+B2DhhNtwq3j8RhT/cordx2eoM0qulWfFKOYzrSwiNcLIhZh1J7BloHfUzcjO9j3W
         NM6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681888867; x=1684480867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjTbhACbGlqLOGJe8zhnxXVfb1D2+8xDV6pHc1d4gkk=;
        b=dmY/F6tGKoDg+KYsXEdQPBk32X+vJmeb8XxVoZuldE14YzONjV+f2sNSAdEBr3I2fu
         QTLtdRUCwph2HQ57uU4Qz/uChsoplSsH1cDyHDhB2/mrvw/UN09gvX2T0hP6FSzqg5jD
         WvW/XU6i7S+S5jJSnMC9IwtSv1fyiFtxOkc0+tqlAIST3Z46Rxb+qEhO8aEwzgFJR19K
         RSJF3px/n/3MfTW6dIQM+tQGxDOUAtDLWYHEni52biFmAV6zNuW1G0Z/KYfjMWY6IQf8
         FCXNcgPXOI6Opb1spOZv9R8VZ8CdJ18rfEMBHjb126CnSC89NWvCzpf2Q1zhN0GinYsE
         U+rQ==
X-Gm-Message-State: AAQBX9cEr4GRwXrcMPEZ/U99aAwufwxKSrMEoK1lJ6UfBC51zT2FAYWc
        qTDCC9ou1m7YaskmDHrEEeMd5Woy2ldd228sUk46ag==
X-Google-Smtp-Source: AKy350aGpYXev9uUy94N5sxa2rYQ1wBIP+aXOx8CWgfE5++c2w3OBNmiH3x+55Mlp0rXYfQlKvVafIadMZr83L/0lWA=
X-Received: by 2002:a50:ab4f:0:b0:4fb:9f5:b994 with SMTP id
 t15-20020a50ab4f000000b004fb09f5b994mr2420197edc.0.1681888866838; Wed, 19 Apr
 2023 00:21:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230418190101.696345-1-pranavpp@google.com> <20230418190101.696345-5-pranavpp@google.com>
In-Reply-To: <20230418190101.696345-5-pranavpp@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 19 Apr 2023 09:20:56 +0200
Message-ID: <CAMGffEny-k6Wvukza7xpZaTDp4otsfiHNAUkAuro0W4_nn06ww@mail.gmail.com>
Subject: Re: [PATCH 4/6] scsi: pm80xx: Log phy_id and port_id in the device
 registration request
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
> Print phy_id and port_id sent as part of device registration
> request.
>
> Signed-off-by: Akshat Jain <akshatzen@google.com>
> Signed-off-by: Pranav Prasad <pranavpp@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index c5bf65d0ad14..8571f6222eb8 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4756,6 +4756,9 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
>         memcpy(payload.sas_addr, pm8001_dev->sas_device->sas_addr,
>                 SAS_ADDR_SIZE);
>
> +       pm8001_dbg(pm8001_ha, INIT,
> +                  "register device req phy_id 0x%x port_id 0x%x\n", phy_=
id,
> +                  (port->port_id & 0xFF));
>         rc =3D pm8001_mpi_build_cmd(pm8001_ha, 0, opc, &payload,
>                         sizeof(payload), 0);
>         if (rc)
> --
> 2.40.0.634.g4ca3ef3211-goog
>
