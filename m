Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD003C32771
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 03:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79E7320678
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 03:26:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mywlhb4I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgATD0N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 22:26:13 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:33007 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbgATD0N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 22:26:13 -0500
Received: by mail-vk1-f193.google.com with SMTP id i78so8170685vke.0;
        Sun, 19 Jan 2020 19:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hI8W90n6MD+xGR60GW7O6kg6yOqBBrxpSDC+QSaeJXs=;
        b=mywlhb4IlXG/4jD8LdEeUeZMJAl5pht17hl1XhzOh+01LCDFRJueDB27Os2vsouLdP
         KmbNEfYdVccBgSYyggMXDoZ34Nagy2nW0wGb+H/CiXjhPk02C4e01FdpPQuizAfCEAzF
         g3HnQwvC2LiXQ/uEh/w16a5r2p8wwQPzpqK9IjdI/a0+ku3EFB1rPx4BKmFcJ8abyyU5
         EkBdg037SY2rxBvTemllmWYs49d57Rrh3wIZ3UgK+zG27/lzHnDbOcrx/OEfHE9AT3oQ
         UnaErYUgo4nrYDVLRn8lF/2ISUiuVJEr6CwKu6FXSpj417VIYmwxYht203b91sn6os1o
         /fvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hI8W90n6MD+xGR60GW7O6kg6yOqBBrxpSDC+QSaeJXs=;
        b=lhXbsVJXYPHL2BdYxGniUkreKaV80G7moDDEcTcbbukAoWlztJtb0QtMNS3SXQaqlf
         hFnUbnhTncwpfkm0mMyrR7JfsPp0dNCOZ8isFuuy9A9+OLPRHWq/BhKBClsscU5f6/XF
         iZvFsL/vOfKz5LYJL6lbFXaCOrviEh7Ux90oeyvEjcaFQ7oFWzd7lBPn5sYcwLih/ylP
         kyNSsjh5ZjZZfueGtFf040VaDSgwaFyJ1eLcuFjGy1qYaZ/j6ZnSQPbydnaPTMel2tBB
         Ani2tYzEucz3+Gddh40XgI5+4/+eACDq0g+rAeM8oSFG/b5sFHPT1QyrW18GKFEcfySZ
         LotQ==
X-Gm-Message-State: APjAAAXnlsn5dDSfF6OK0yApuoTwI4e7STlMxlDWkx0db+dkUrQjzRlR
        yEtCcR6FymNmPPgdFWOVVABGvzBxdKc9bczwAcY=
X-Google-Smtp-Source: APXvYqwZKixedgysJNkmuNw83lMmAjbyxc4jGJBjlDPLJbY+vGysFjl58XT5P0Jtedv73c2R8w1qmgjkhjyg6Zn8+cQ=
X-Received: by 2002:a1f:db81:: with SMTP id s123mr27775105vkg.45.1579490771859;
 Sun, 19 Jan 2020 19:26:11 -0800 (PST)
MIME-Version: 1.0
References: <20200119001327.29155-1-huobean@gmail.com> <CAGOxZ52xHFedU+1DUgL02xjXzG2CtXUk3MRaq=uSUZKX=7AeDw@mail.gmail.com>
 <BN7PR08MB568498ED5D86FAA8098EE1C9DB330@BN7PR08MB5684.namprd08.prod.outlook.com>
In-Reply-To: <BN7PR08MB568498ED5D86FAA8098EE1C9DB330@BN7PR08MB5684.namprd08.prod.outlook.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Mon, 20 Jan 2020 08:55:35 +0530
Message-ID: <CAGOxZ52qVH4M=dSa3ynhzToki-TPN5D5YevvvuuKyJtepp2zMg@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH v3 0/8] Use UFS device indicated maximum LU number
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc:     Bean Huo <huobean@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 20, 2020 at 3:29 AM Bean Huo (beanhuo) <beanhuo@micron.com> wro=
te:
>
> Hi, Alim
>
> >
> > Hi Bean
> >
> > Your patches based on which tree? At least on Jame's for-next, it give
> > compilation errors.
> > (git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git)
> > Looks like patch-2 introduces below error:
>
> My patches are based on the Martin's tree 5.6/scsi-queue. I tested my pat=
ches on James' tree.
> Didn't find the compilation error as you mentioned.  You can check your s=
ource code if it is pretty new,
> The last UFS driver updated commit id should be :
>
>
> commit ea92c32bd336efba89c5b09cf609e6e26e963796
> Author: Stanley Chu <stanley.chu@mediatek.com>
> Date:   Sat Jan 11 15:11:47 2020 +0800
>
>  scsi: ufs-mediatek: add apply_dev_quirks variant operation
>
>  Add vendor-specific variant callback "apply_dev_quirks" to MediaTek UFS =
driver.
>
Thanks Bean for letting me know about this.
Unfortunately, I still see the error (with enabled MKT and QCOM driver
in defconfig)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
drivers/scsi/ufs/ufs-mediatek.c: In function =E2=80=98ufs_mtk_apply_dev_qui=
rks=E2=80=99:
drivers/scsi/ufs/ufs-mediatek.c:411:34: error: incompatible types when
initializing type =E2=80=98struct ufs_dev_info *=E2=80=99 using type =E2=80=
=98struct
ufs_dev_info=E2=80=99
  struct ufs_dev_info *dev_info =3D hba->dev_info;
                                  ^~~
scripts/Makefile.build:265: recipe for target
'drivers/scsi/ufs/ufs-mediatek.o' failed
make[3]: *** [drivers/scsi/ufs/ufs-mediatek.o] Error 1
make[3]: *** Waiting for unfinished jobs....
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
=3D=3D=3D=3D=3D=3D
git log --oneline on the tree looks like below:

7b700f8ec213 (HEAD -> local-martin-5.6-scsi-queue) scsi: ufs: Use UFS
device indicated maximum LU number
be7a1644f3af scsi: ufs: Add max_lu_supported in struct ufs_dev_info
13cd5c519941 scsi: ufs: Delete is_init_prefetch from struct ufs_hba
27539cb1d81d scsi: ufs: Inline two functions into their callers
cbe20395fe01 scsi: ufs: move ufshcd_get_max_pwr_mode() to ufs_init_params()
9fb0c168ef38 scsi: ufs: Split ufshcd_probe_hba() based on its called flow
a5d0e0fbd4d0 scsi: ufs: Delete struct ufs_dev_desc
c2aa6b365857 scsi: ufs: Fix ufshcd_probe_hba() reture value in case
ufshcd_scsi_add_wlus() fails
824b72db5086 (tag: mkp-scsi-queue, scsi/misc, martin-scsi/queue,
martin-scsi/5.6/scsi-queue) scsi: megaraid_sas: Update driver version
to 07.713.01.00-rc1
4d1634b8d12e scsi: megaraid_sas: Use Block layer API to check SCSI
device in-flight IO requests
56ee0c585602 scsi: megaraid_sas: Limit the number of retries for the
IOCTLs causing firmware fault
6d7537270e32 scsi: megaraid_sas: Do not initiate OCR if controller is
not in ready state
=3D=3D=3D=3D=3D

~/work/linux (local-martin-5.6-scsi-queue) $ git log --oneline
drivers/scsi/ufs/ufs-mediatek.c
a5d0e0fbd4d0 scsi: ufs: Delete struct ufs_dev_desc
ea92c32bd336 scsi: ufs-mediatek: add apply_dev_quirks variant operation
5d74e18edd7b scsi: ufs-mediatek: configure and enable clk-gating

=3D=3D=3D=3D=3D=3D=3D=3D
~/work/linux (local-martin-5.6-scsi-queue) $ git log --oneline
drivers/scsi/ufs/ufs-mediatek.c
a5d0e0fbd4d0 scsi: ufs: Delete struct ufs_dev_desc
ea92c32bd336 scsi: ufs-mediatek: add apply_dev_quirks variant operation
5d74e18edd7b scsi: ufs-mediatek: configure and enable clk-gating

Which has the mentioned commit by you.
=3D=3D=3D=3D=3D=3D=3D

I am on gcc: aarch64-linux-gnu-gcc (Ubuntu/Linaro 7.4.0-1ubuntu1~18.04.1) 7=
.4.0

Am I missed any patches which is needed?

>
> Thanks,
>
> //Bean



--=20
Regards,
Alim
