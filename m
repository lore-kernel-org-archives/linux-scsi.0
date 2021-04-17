Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBDAC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Apr 2021 06:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 489A9611AB
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Apr 2021 06:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhDQGfd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Apr 2021 02:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhDQGfd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Apr 2021 02:35:33 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F98CC061574;
        Fri, 16 Apr 2021 23:35:07 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id c1so25138578ljd.7;
        Fri, 16 Apr 2021 23:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p+TZ8j0+H5es+BHvK/OjBPld0E8cxCO9gniyDTsW9R8=;
        b=hiVtECvw25e8t9YjzDtZabomrYjhXia1cP1fj+94F4tIdnlCdYIP45+DPRVcs55qDU
         Xm8YdyHPD++PwpeQ8IMk5ZgtsoglSOyjXx0/mqVwTMaKctp0OCc4i2g8P5vy1jHiTT3A
         F2CpgJXLc7hJhDMTIywL+D3bGRxeuBvutU9XFAJsKHGJw2Y18xLVpksmfoFtYIfmfr26
         2e8aNF1cpHhj8khuxFYAVkmsYbV7PSgHvHYouR6qIdBZaBN14pHlM/SiwBMnP81/ZOzG
         Vw/tp6Yo3yV87ZMjnccF6keD1Afl5MFL3Y0QY0DcnhNsYst9tJa+eyU2uf6/zjWJkUjq
         UalQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p+TZ8j0+H5es+BHvK/OjBPld0E8cxCO9gniyDTsW9R8=;
        b=jRumZsREWANLsCwl5edLaYl5zJs226vuLSGZxYfsy96wTjqEsQGkDj4qINwbTUu0XN
         DgED3iPwrp7pdzCuB1XkH8pXvlX73wuyrxdODARe1zIXESalMQYZQ0M/YtQrkIlEvtwL
         1gjH63UR1xFdAF2eS3L0LRERBIKakkQcdR83tOSjRYIWwlQR7KjwYNUSSRjLMso/GJKb
         pLKLKmB2Jly6EnHkLdCfXWHA2B/R5pa7xdlHIZMW5+vIW9Y4X1ZbmhSQMjbERCHJqd8j
         YvM6pPHEoiKoOGfoGua/V6rpsXo3v8iJlizxcXqRG7OnvGBAemvqlVkt65o99myinFo8
         UK1Q==
X-Gm-Message-State: AOAM531jyH7x4+PuNsqc3S+H/P1k9VC2yQqG13BcF4Pd3FOUr9STwuno
        cDdpBpD3/1BeoP5FNIxWV2h9MdrpVmUuBCKLZoz5+/GkQys=
X-Google-Smtp-Source: ABdhPJzkNrQJ5fEYR93BzLNQHyKWYr9IDXgS8crzj/TovLA91Qqreqc2Th9w81FfmRITCNRPvKzwOtmzz/BcIO1Gm6s=
X-Received: by 2002:a2e:90d2:: with SMTP id o18mr4652065ljg.391.1618641305499;
 Fri, 16 Apr 2021 23:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <1618197759-128087-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1618197759-128087-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Sat, 17 Apr 2021 16:34:54 +1000
Message-ID: <CAGRGNgVucQWcGiUnWtsC=oRDXrWkQ13CFojOcM7xU+4TukUoOA@mail.gmail.com>
Subject: Re: [PATCH] scsi: a100u2w: remove useless variable
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jiapeng,

On Mon, Apr 12, 2021 at 1:23 PM Jiapeng Chong
<jiapeng.chong@linux.alibaba.com> wrote:
>
> Fix the following gcc warning:
>
> drivers/scsi/a100u2w.c:1092:8: warning: variable =E2=80=98bios_phys=E2=80=
=99 set but not
> used [-Wunused-but-set-variable].
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/scsi/a100u2w.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
> index 66c5143..855a3fe 100644
> --- a/drivers/scsi/a100u2w.c
> +++ b/drivers/scsi/a100u2w.c
> @@ -1089,7 +1089,6 @@ static int inia100_probe_one(struct pci_dev *pdev,
>         int error =3D -ENODEV;
>         u32 sz;
>         unsigned long biosaddr;
> -       char *bios_phys;
>
>         if (pci_enable_device(pdev))
>                 goto out;
> @@ -1141,7 +1140,7 @@ static int inia100_probe_one(struct pci_dev *pdev,
>
>         biosaddr =3D host->BIOScfg;
>         biosaddr =3D (biosaddr << 4);
> -       bios_phys =3D phys_to_virt(biosaddr);
> +       phys_to_virt(biosaddr);

Does phys_to_virt() have side effects? If it doesn't, there's a lot
more stuff that can get deleted here.

Thanks,

--=20
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
