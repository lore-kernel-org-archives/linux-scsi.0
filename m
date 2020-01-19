Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBCCC33CAF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 04:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0B5C2072B
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 04:40:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NdPk8RHB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgASEkf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 23:40:35 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:42877 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgASEkf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 23:40:35 -0500
Received: by mail-vs1-f66.google.com with SMTP id b79so17148909vsd.9;
        Sat, 18 Jan 2020 20:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mrVtIGWJwkOZNC1CEGskb3pHdiV7yfBFUjPb/kxYDzk=;
        b=NdPk8RHBNqTIJz2G3f9QCNmuyqD7QMqkGUGd6k4djmDn9RcSf94G2IOEIM1A+4Rhwr
         lrzdEIe/XJVB0ro59n2RTKSCVEZSU2H//t1kO7O8Oy06mENrr/n+j+NKHgCVLjZOmdIQ
         bxmeClXscB2tu9vnCfbT4oU80X8mgRzRMoBGYjpyqgu3jMEaS5zPnT+hV2iOoZBClHMg
         wegialB5Y83zraw+pb17lbLTr+cUBe8kgMU092M+tLdUa186Z8YCZ/SJW7vuZGlY1fVb
         iWEnjtdwiV37+HvohjrsiopkQ0W0TDAczF/SG26jY00PTWHYIE5qKUAXQLP8DvK4HSmS
         40jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mrVtIGWJwkOZNC1CEGskb3pHdiV7yfBFUjPb/kxYDzk=;
        b=eXWFPLbA1Dw+9M5BDXQK482Y7gzizr7RZchrh8vZgeWZNSfZD66QdLGcj2Bgsxnu1N
         aiQVG6IV3epHVSJkAGcaI+O+NQGSrXx/vNcWsBmFzyQNm5u9GJo/n8kq+CoXeVpgp06+
         Ev8jf6CZ0UmRhZ4/zt1oI0n9OPqWQMf9hV6syYhBGuxo9sFiRW9hm1ecRWaQOKGumtxS
         YVmRGOrCdUhc7hNmpQoaVVXwUo5TPb6TAbm15j8JVWDBJPrXY5Hog7uE8vtDEwxvQ2k1
         AuBpIoaF4R2opXGRSJKkKSAIaN+TjzoxeZETdbFezHUt4oS6snSZcK6sarFDjBdxvzSB
         p3Gw==
X-Gm-Message-State: APjAAAX3eh4D3G3bsKcUF4CGF0PRejG2f4QXDzZJvy1Le7lR0nLmgtGB
        UUkme5nznyqdrP4SpJg10xFUVh3osfj141YzIXM=
X-Google-Smtp-Source: APXvYqxpHZ61IHsmfm/HMYog2PO4oNWk6PLIwkkyB1bpgV4hW+fnIiaPwEDy5ZEDTJMPkaz2RmGeLLPtn9tvd7n9EXA=
X-Received: by 2002:a67:1447:: with SMTP id 68mr9174794vsu.76.1579408833735;
 Sat, 18 Jan 2020 20:40:33 -0800 (PST)
MIME-Version: 1.0
References: <20200119001327.29155-1-huobean@gmail.com>
In-Reply-To: <20200119001327.29155-1-huobean@gmail.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 19 Jan 2020 10:09:56 +0530
Message-ID: <CAGOxZ52xHFedU+1DUgL02xjXzG2CtXUk3MRaq=uSUZKX=7AeDw@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] Use UFS device indicated maximum LU number
To:     Bean Huo <huobean@gmail.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, asutoshd@codeaurora.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean

Your patches based on which tree? At least on Jame's for-next, it give
compilation errors.
(git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git)
Looks like patch-2 introduces below error:
=3D=3D=3D=3D=3D=3D=3D=3D
drivers/scsi/ufs/ufs-qcom.c: In function =E2=80=98ufs_qcom_apply_dev_quirks=
=E2=80=99:
drivers/scsi/ufs/ufs-qcom.c:955:34: error: incompatible types when
initializing type =E2=80=98struct ufs_dev_info *=E2=80=99 using type =E2=80=
=98struct
ufs_dev_info=E2=80=99
  struct ufs_dev_info *dev_info =3D hba->dev_info;
                                  ^~~
drivers/scsi/ufs/ufs-qcom.c:957:14: error: =E2=80=98struct ufs_dev_info=E2=
=80=99 has
no member named =E2=80=98dev_quirks=E2=80=99
  if (dev_info->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME)
              ^~
scripts/Makefile.build:265: recipe for target
'drivers/scsi/ufs/ufs-qcom.o' failed
make[3]: *** [drivers/scsi/ufs/ufs-qcom.o] Error 1
=3D=3D=3D=3D=3D=3D=3D=3D=3D


On Sun, Jan 19, 2020 at 5:44 AM Bean Huo <huobean@gmail.com> wrote:
>
> This series of patches is to simplify UFS driver initialization flow
> and add a new parameter max_lu_supported used to specify how many LUs
> supported by the UFS device.
> This series of patches being tested on my two platforms, Qualcomm SOC
> based and Hisilicon SOC based platforms.
>
> v1-v2:
>     1. Split ufshcd_probe_hba() based on its called flow
>     2. Delete two unnecessary functions
>     3. Add a fixup patch
> v2-v3:
>     1. Combine patches 7/9 and 8/9 of v2 to patch 7/8 of v3
>     2. Change patches 1/8 and 5/8 subject
>     3. Change the name of two functions in patch 7/8
>
> Bean Huo (8):
>   scsi: ufs: Fix ufshcd_probe_hba() reture value in case
>     ufshcd_scsi_add_wlus() fails
>   scsi: ufs: Delete struct ufs_dev_desc
>   scsi: ufs: Split ufshcd_probe_hba() based on its called flow
>   scsi: ufs: move ufshcd_get_max_pwr_mode() to ufs_init_params()
>   scsi: ufs: Inline two functions into their callers
>   scsi: ufs: Delete is_init_prefetch from struct ufs_hba
>   scsi: ufs: Add max_lu_supported in struct ufs_dev_info
>   scsi: ufs: Use UFS device indicated maximum LU number
>
>  drivers/scsi/ufs/ufs-mediatek.c |   7 +-
>  drivers/scsi/ufs/ufs-qcom.c     |   6 +-
>  drivers/scsi/ufs/ufs-sysfs.c    |   2 +-
>  drivers/scsi/ufs/ufs.h          |  25 ++-
>  drivers/scsi/ufs/ufs_quirks.h   |   9 +-
>  drivers/scsi/ufs/ufshcd.c       | 276 +++++++++++++++++++-------------
>  drivers/scsi/ufs/ufshcd.h       |   9 +-
>  7 files changed, 196 insertions(+), 138 deletions(-)
>
> --
> 2.17.1
>


--=20
Regards,
Alim
