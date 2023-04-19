Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B42C6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 07:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjDSHXU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 03:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbjDSHXN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 03:23:13 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8767C9EC8
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 00:23:05 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id dx24so35167740ejb.11
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 00:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1681888984; x=1684480984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2DAjbtYYTc4WefwKjkJwhrzaq30YT/W8cMV6x7MSUy0=;
        b=SHsHJeVr/gONcL6vk49ay5jDx4cgQghSciqKmbW/PATbeJ+J3D2/UgHETSEg51LVuz
         7/QKlMWhbW6kaHmsQBTBnHtrKxfgdQF3LeBczQitgj/+7Ye0FwLtvU+LLhd6gxJRmfb5
         tVUOHCRThyPMX6IsNmcwaVI3kt0lJYrs/ScVvVlgnOYB/DIIsAfLUBJm5P/RWIW8kC8g
         AgC70nz6OnksqFkWOoyZWilzOtQASWvB9BbCTYUf4dSBCXuvF9L1WT4GgSsJ17R3eJGK
         H0S0dowlJSY9vNbFHX1+W0NVbC472B6kJUWtM3He/U4jYEHFWfPvIhpYH9xrt4V5VdHu
         IYLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681888984; x=1684480984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2DAjbtYYTc4WefwKjkJwhrzaq30YT/W8cMV6x7MSUy0=;
        b=DYdFUSuKRsIR6w0VfoDF1V6koxOOpvp34IRi/YwMQY+jvNbMvnnel1T2j5Pog8BLGk
         ObIBDRUXNyRzWOfdVR+qd5DvIMeSV+0T2kAEMLi2y5tDLZyHtj4KFkFvtt5j8vfi1X1G
         Jf6R0SgdXhXGlg7bA0dIrHTQKOzZPjRBvZXlWmMaAtJrqfa8qTgJixFI572lTSLctmdw
         Q+1tUEkAeAtBh0d+aBj0499DCuIJaMv9+pWN1cdJFYxoont/AMaxsNqCKkILjErlPFbd
         5JR1ysQfpZWkdbOgqa1IFbpDnxzsgavlQRDC8WMCpoXnUmV1kHIhKf4WttRporfAlIcK
         PY/g==
X-Gm-Message-State: AAQBX9dmJwP8jmOjxRcpzBnvvbf4+UBSxLAGVMxioZDOum7PGO4MmYQJ
        DrOiLXWsSwjitPT2BBK7S4l34lSxiYsUhiTh2OSKm90Fdaezezy8beU=
X-Google-Smtp-Source: AKy350ZBTJeeXpZ9kEKguchJHurQyA6SIyR1bzrlhJA0SQKP0ByFQRePyvpquFF4DlDvkoaloDqqJ6+6Uyz2GtNZwas=
X-Received: by 2002:a17:906:8448:b0:94f:2d5e:1909 with SMTP id
 e8-20020a170906844800b0094f2d5e1909mr5073402ejy.7.1681888983866; Wed, 19 Apr
 2023 00:23:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230418190101.696345-1-pranavpp@google.com> <20230418190101.696345-6-pranavpp@google.com>
In-Reply-To: <20230418190101.696345-6-pranavpp@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 19 Apr 2023 09:22:53 +0200
Message-ID: <CAMGffEk06_PHQtH88na-jJyebSvrqgfvGE63qH8A86=piXLqFw@mail.gmail.com>
Subject: Re: [PATCH 5/6] scsi: pm80xx: Log port state during HW event
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
> Log port state during PHY_DOWN event to understand reasoning for PHY_DOWN=
s.
>
> Signed-off-by: Akshat Jain <akshatzen@google.com>
> Signed-off-by: Pranav Prasad <pranavpp@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 43 ++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index 8571f6222eb8..85908068b8d7 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3239,9 +3239,9 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001=
_ha, void *piomb)
>         struct pm8001_port *port =3D &pm8001_ha->port[port_id];
>         struct pm8001_phy *phy =3D &pm8001_ha->phy[phy_id];
>         unsigned long flags;
> -       pm8001_dbg(pm8001_ha, DEVIO,
> -                  "port id %d, phy id %d link_rate %d portstate 0x%x\n",
> -                  port_id, phy_id, link_rate, portstate);
> +       pm8001_dbg(pm8001_ha, EVENT,
> +                  "HW_EVENT_SATA_PHY_UP phyid:%#x port_id:%#x link_rate:=
%d portstate:%#x\n",
> +                  phy_id, port_id, link_rate, portstate);
>
>         phy->port =3D port;
>         port->port_id =3D port_id;
> @@ -3291,10 +3291,14 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_=
ha, void *piomb)
>         phy->phy_attached =3D 0;
>         switch (portstate) {
>         case PORT_VALID:
> +               pm8001_dbg(pm8001_ha, EVENT,
> +                       "HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x portstat=
e: PORT_VALID\n",
> +                       phy_id, port_id);
>                 break;
>         case PORT_INVALID:
> -               pm8001_dbg(pm8001_ha, MSG, " PortInvalid portID %d\n",
> -                          port_id);
> +               pm8001_dbg(pm8001_ha, EVENT,
> +                       "HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x portstat=
e: PORT_INVALID\n",
> +                       phy_id, port_id);
>                 pm8001_dbg(pm8001_ha, MSG,
>                            " Last phy Down and port invalid\n");
>                 if (port_sata) {
> @@ -3306,18 +3310,21 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_=
ha, void *piomb)
>                 sas_phy_disconnected(&phy->sas_phy);
>                 break;
>         case PORT_IN_RESET:
> -               pm8001_dbg(pm8001_ha, MSG, " Port In Reset portID %d\n",
> -                          port_id);
> +               pm8001_dbg(pm8001_ha, EVENT,
> +                       "HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x portstat=
e: PORT_IN_RESET\n",
> +                       phy_id, port_id);
>                 break;
>         case PORT_NOT_ESTABLISHED:
> -               pm8001_dbg(pm8001_ha, MSG,
> -                          " Phy Down and PORT_NOT_ESTABLISHED\n");
> +               pm8001_dbg(pm8001_ha, EVENT,
> +                       "HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x portstat=
e: PORT_NOT_ESTABLISHED\n",
> +                       phy_id, port_id);
>                 port->port_attached =3D 0;
>                 break;
>         case PORT_LOSTCOMM:
> -               pm8001_dbg(pm8001_ha, MSG, " Phy Down and PORT_LOSTCOMM\n=
");
> -               pm8001_dbg(pm8001_ha, MSG,
> -                          " Last phy Down and port invalid\n");
> +               pm8001_dbg(pm8001_ha, EVENT,
> +                       "HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x portstat=
e: PORT_LOSTCOMM\n",
> +                       phy_id, port_id);
> +               pm8001_dbg(pm8001_ha, MSG, " Last phy Down and port inval=
id\n");
>                 if (port_sata) {
>                         port->port_attached =3D 0;
>                         phy->phy_type =3D 0;
> @@ -3328,9 +3335,9 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha=
, void *piomb)
>                 break;
>         default:
>                 port->port_attached =3D 0;
> -               pm8001_dbg(pm8001_ha, DEVIO,
> -                          " Phy Down and(default) =3D 0x%x\n",
> -                          portstate);
> +               pm8001_dbg(pm8001_ha, EVENT,
> +                       "HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x portstat=
e:%#x\n",
> +                       phy_id, port_id, portstate);
>                 break;
>
>         }
> @@ -3431,9 +3438,6 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8=
001_ha, void *piomb)
>                 hw_event_sas_phy_up(pm8001_ha, piomb);
>                 break;
>         case HW_EVENT_SATA_PHY_UP:
> -               pm8001_dbg(pm8001_ha, EVENT,
> -                          "HW_EVENT_SATA_PHY_UP phyid:%#x port_id:%#x\n"=
,
> -                          phy_id, port_id);
>                 hw_event_sata_phy_up(pm8001_ha, piomb);
>                 break;
>         case HW_EVENT_SATA_SPINUP_HOLD:
> @@ -3444,9 +3448,6 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8=
001_ha, void *piomb)
>                         GFP_ATOMIC);
>                 break;
>         case HW_EVENT_PHY_DOWN:
> -               pm8001_dbg(pm8001_ha, EVENT,
> -                          "HW_EVENT_PHY_DOWN phyid:%#x port_id:%#x\n",
> -                          phy_id, port_id);
>                 hw_event_phy_down(pm8001_ha, piomb);
>                 phy->phy_attached =3D 0;
>                 phy->phy_state =3D PHY_LINK_DISABLE;
> --
> 2.40.0.634.g4ca3ef3211-goog
>
