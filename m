Return-Path: <SRS0=fH6r=XM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24881C4CEC9
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Sep 2019 09:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF32421881
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Sep 2019 09:06:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="NQI/irYO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfIQJGV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Sep 2019 05:06:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35203 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfIQJGV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Sep 2019 05:06:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id y21so2174599wmi.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Sep 2019 02:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nFF/4XckwgtJQC2Enr9cy65XMeRaKHCD6+b4rJzMQBQ=;
        b=NQI/irYOEC0oW/wTvSbDnELKuUZeOpofWBHyAhmiMiiCEhNSbh4NplUrKqmII7kbWC
         Q4G0P/l5i1MupUFwmcu5DFteIib7wU9MgNHMUaJNFixmlxPAuWXylmdDQaCiOe+sUrE5
         3QiGm0Cb9e3q9ReqXGQfHfbfieGrxLaGWXul+xuyxl3/GHazE3oNK4MuKLHF/yl7sIRb
         cNmsdVTLAKDGWytATZvP9VG1BS/7B2/RW4Kpxf0PJlzq/qask3x/4+rfYwpeNktmfig9
         7vGPKDGgIRohp3hTtYv4y31AnvclEPpAmC3ZSAP+4t7z7IMHQl3Ddb8iyh9/KTiaJSpR
         OXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nFF/4XckwgtJQC2Enr9cy65XMeRaKHCD6+b4rJzMQBQ=;
        b=VdGGaqno3OYCnjahUVs++02/gj15KHEZ6Xhzmj0LTnrw5zGiv1o5Ys3yOB5neOpR0X
         nummWLgUA6xIIVbEIF3vDyMqJTfaxzdFFPpvti89dI8iwtsIIErtcJEbXRYcs+oC8D6R
         24pC/dGGqsqWlrCT0Pi3ytLmV7VAQ9CpE5Spy6flApDf2ixUVOV0xQUUaR4UTCOmivYH
         Qy6E9aoxN9UVnMeoFWyPw5W3ssR699AgjzALH74/SJ7Nhw1/Hrc2q4eFl8hYlaRP8/B2
         KfKF/QNlsMbAzz+cXFlUJIK0X4o+veawOqMYpHMNtPLT5c2Nfx7/IgotUGAKJn9RD5Yy
         OGTQ==
X-Gm-Message-State: APjAAAVb4FL/oEFKKKmW9iTDW1yUHxrNtesAbm8tcE36BkhRPY5h9sVP
        ySv417Y9G60cdadJHbhF8zIUMhbPiGXlAxe/vvCvRA==
X-Google-Smtp-Source: APXvYqy2Qpxco8CrOgIuQYRcL2hUkHM8zw0gIl2jvM254AOtptuMeubrSXnRgxqPY7xMUBI6qgrs+ImepthxQ7sZ4Us=
X-Received: by 2002:a1c:4384:: with SMTP id q126mr2837215wma.153.1568711177926;
 Tue, 17 Sep 2019 02:06:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190916204158.6889-1-efremov@linux.com> <20190916204158.6889-19-efremov@linux.com>
In-Reply-To: <20190916204158.6889-19-efremov@linux.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 17 Sep 2019 11:06:06 +0200
Message-ID: <CAMGffEk6=EoJTHKgsJzNs27mUdSj2zin5N8MsdtOK5rZh17JeQ@mail.gmail.com>
Subject: Re: [PATCH v3 18/26] scsi: pm80xx: Use PCI_STD_NUM_BARS
To:     Denis Efremov <efremov@linux.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Andrew Murray <andrew.murray@arm.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 16, 2019 at 10:47 PM Denis Efremov <efremov@linux.com> wrote:
>
> Replace the magic constant (6) with define PCI_STD_NUM_BARS representing
> the number of PCI BARs.
>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Signed-off-by: Denis Efremov <efremov@linux.com>
Looks fine, thanks!
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c  | 2 +-
>  drivers/scsi/pm8001/pm8001_init.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 68a8217032d0..1a3661d6be06 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1186,7 +1186,7 @@ static void pm8001_hw_chip_rst(struct pm8001_hba_info *pm8001_ha)
>  void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha)
>  {
>         s8 bar, logical = 0;
> -       for (bar = 0; bar < 6; bar++) {
> +       for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
>                 /*
>                 ** logical BARs for SPC:
>                 ** bar 0 and 1 - logical BAR0
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 3374f553c617..aca913490eb5 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -401,7 +401,7 @@ static int pm8001_ioremap(struct pm8001_hba_info *pm8001_ha)
>
>         pdev = pm8001_ha->pdev;
>         /* map pci mem (PMC pci base 0-3)*/
> -       for (bar = 0; bar < 6; bar++) {
> +       for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
>                 /*
>                 ** logical BARs for SPC:
>                 ** bar 0 and 1 - logical BAR0
> --
> 2.21.0
>


-- 
Jack Wang
Linux Kernel Developer
Platform Engineering Compute (IONOS Cloud)
