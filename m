Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC15C2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 11:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E5E920863
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 11:55:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="OEYempfn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgABLzc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 06:55:32 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:43364 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgABLzc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 06:55:32 -0500
Received: by mail-io1-f67.google.com with SMTP id n21so36477127ioo.10
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jan 2020 03:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c321WwyRPejVX4cpMKglyHDjEDuVRzVNS1Qdt8C5M2E=;
        b=OEYempfn89grkhFKnQAtCA1f0n+cHAc8dRtrlI5gak65Xn1Uuc16pamnJKnCsQQr8f
         fW7PlXFEH1B92cTEkg+z3I1Yr7APNs7NiBF6jrUnGodWwvDrF8E8S9dum6lHY9d6d8Ml
         seUFdOVigELWgORXjKeqtR6JEo3RWJjYE0a9fTEGNeSBLLMF5OFfKd8tfrz386GkpuDt
         gxqjtP38TkUbpaC6o8syYdUTEZYxLcsUL8NZywGMN5C+G/RxRiFf3XhFwnZY3DzWXxc4
         TilXGNBYVjUPVyiayWtD7rXCDbyJaEdrd9YR8tOT1NmVEXfC2qHbc+wI9pDwxMSt+sOs
         2F1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c321WwyRPejVX4cpMKglyHDjEDuVRzVNS1Qdt8C5M2E=;
        b=EFawxB3yoGLcqQwO4z64PBnCt4WEUqTQ0YDwJRTuH/jo6U0suTVRJpDHV58+McsImw
         NKvSZ5Ea9QosQcZqaAKSUivoywHq2N++t+zihr6MuA0o3rxXhYLHfQ6YLzXiI2X0rn/C
         1KFBYiQwWm1/ds5NwbdVmHA6aGUxiB2LCaCeDPmN4qE8VPY0rFcJmKEaJ63VyL57xELk
         aGdpK0Hw0S1IBe19DMaBemfi0GBG5UdanMZKgx7hb+Q5SpVo0TVMowEQLIP59EFqVjP0
         THbMTktbYsHbIXumqYvKrPDejhnlElW12WNEGGMdQRWVTotLvZe5tkb3QmNyZH44lhBt
         p+jA==
X-Gm-Message-State: APjAAAVBHSCZo+7mq/YtA9TkM3scNJPOrxawg2dQFJxqy8JWpADJIM5h
        /MELFKDwiZ+aMHbCSTjbv08tM6BcSVG0lgbJoKTRcw==
X-Google-Smtp-Source: APXvYqxqQbvJ5de7BjyryBeagK+ex707Jn3Tt0AIDbDUaVzJOIXF0pukebuYkYNmn0dyekqk+LY+cdEmODuiVb1QViU=
X-Received: by 2002:a02:a610:: with SMTP id c16mr63410726jam.13.1577966131397;
 Thu, 02 Jan 2020 03:55:31 -0800 (PST)
MIME-Version: 1.0
References: <20191224044143.8178-1-deepak.ukey@microchip.com> <20191224044143.8178-4-deepak.ukey@microchip.com>
In-Reply-To: <20191224044143.8178-4-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 2 Jan 2020 12:55:20 +0100
Message-ID: <CAMGffEkL4T-tGRxB+EhanNDnW4PNZuucUiFXbMGSwe2Ui7tfLQ@mail.gmail.com>
Subject: Re: [PATCH 03/12] pm80xx : Free the tag when mpi_set_phy_profile_resp
 is received.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 24, 2019 at 5:41 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: yuuzheng <yuuzheng@google.com>
>
> In pm80xx driver, the command mpi_set_phy_profile_req is sent by host
> during boot to configure the phy profile such as analog setting page,
> rate control page. However, the tag is not freed when its response is
> received. As a result, 16 tags are missing for each HBA after boot.
> When NCQ is enabled with queue depth 16, it needs at least, 15 * 16 =
> 240 tags for each HBA to achieve the best performance. In current
> pm80xx driver with setting CCB_MAX = 256, the total number of tags in
> each HBA is 255 for data IO. Hence, without returning those tags to the
> pool after boot, some device will finally be forced to non-ncq mode by
> ATA layer due to excessive errors (i.e. LLDD cannot allocate tag for
> queued task).
>
> Signed-off-by: yuuzheng <yuuzheng@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: Akshat Jain <akshatzen@google.com>
The patch looks fine.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index d805fd036ddf..37b82d7aa3d7 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3715,28 +3715,32 @@ static int mpi_flash_op_ext_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  static int mpi_set_phy_profile_resp(struct pm8001_hba_info *pm8001_ha,
>                         void *piomb)
>  {
> +       u32 tag;
>         u8 page_code;
> +       int rc = 0;
>         struct set_phy_profile_resp *pPayload =
>                 (struct set_phy_profile_resp *)(piomb + 4);
>         u32 ppc_phyid = le32_to_cpu(pPayload->ppc_phyid);
>         u32 status = le32_to_cpu(pPayload->status);
>
> +       tag = le32_to_cpu(pPayload->tag);
>         page_code = (u8)((ppc_phyid & 0xFF00) >> 8);
>         if (status) {
>                 /* status is FAILED */
>                 PM8001_FAIL_DBG(pm8001_ha,
>                         pm8001_printk("PhyProfile command failed  with status "
>                         "0x%08X \n", status));
> -               return -1;
> +               rc = -1;
>         } else {
>                 if (page_code != SAS_PHY_ANALOG_SETTINGS_PAGE) {
>                         PM8001_FAIL_DBG(pm8001_ha,
>                                 pm8001_printk("Invalid page code 0x%X\n",
>                                         page_code));
> -                       return -1;
> +                       rc = -1;
>                 }
>         }
> -       return 0;
> +       pm8001_tag_free(pm8001_ha, tag);
> +       return rc;
>  }
>
>  /**
> --
> 2.16.3
>
