Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B8FFC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 16:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 338DE2311A
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 16:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Fi2vJDR0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgHFQjL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:39:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34931 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbgHFQhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 12:37:08 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200806163703epoutp01f623b07505fb1b158a3338045399e7fa~ouyIejw0u0358803588epoutp01p
        for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2020 16:37:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200806163703epoutp01f623b07505fb1b158a3338045399e7fa~ouyIejw0u0358803588epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1596731823;
        bh=VH6Uk9hXy1i54YJbLiVkYrPKRALnqeliBx0oNQ7Voag=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Fi2vJDR0gTQT63/cxUCBieYoozV4V2CcQZPmxBlfsY5tG6Wj7+IWCOQtNo1FjXFbb
         tTavDQVxvzd2weVORyEAjWrI3vtnRs3AoYa+dW6TBEmYNtWGFVMWaFBkv24w1MUOXd
         IbFX7eOBsVagpN0/Ayo2ptQQ0e9vwXs083KRNM0o=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200806163701epcas5p1db131f7d2920ff4a16efe4516091f17b~ouyG2jB_u1936119361epcas5p1u;
        Thu,  6 Aug 2020 16:37:01 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.A6.40333.DA13C2F5; Fri,  7 Aug 2020 01:37:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200806163700epcas5p2f15235fc7fa635bd1c585a8805c0e82f~ouyGCmQI02779327793epcas5p2T;
        Thu,  6 Aug 2020 16:37:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200806163700epsmtrp12f79450068a6fb97a6145b24f76e108f~ouyGBtJpD1924019240epsmtrp1f;
        Thu,  6 Aug 2020 16:37:00 +0000 (GMT)
X-AuditID: b6c32a4a-991ff70000019d8d-50-5f2c31adccd3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        29.81.08382.CA13C2F5; Fri,  7 Aug 2020 01:37:00 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200806163656epsmtip132442238b883b277caec9fd30a45b942~ouyCCuleF1971319713epsmtip1J;
        Thu,  6 Aug 2020 16:36:56 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        "'Bean Huo'" <huobean@gmail.com>, <daejun7.park@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <asutoshd@codeaurora.org>, <beanhuo@micron.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>
Cc:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Sang-yoon Oh'" <sangyoon.oh@samsung.com>,
        "'Sung-Jun Park'" <sungjun07.park@samsung.com>,
        "'yongmyung lee'" <ymhungry.lee@samsung.com>,
        "'Jinyoung CHOI'" <j-young.choi@samsung.com>,
        "'Adel Choi'" <adel.choi@samsung.com>,
        "'BoRam Shin'" <boram.shin@samsung.com>
In-Reply-To: <SN6PR04MB464069DD70022FC3C55265B6FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [PATCH v8 0/4] scsi: ufs: Add Host Performance Booster Support
Date:   Thu, 6 Aug 2020 22:06:54 +0530
Message-ID: <000001d66c0f$ce9615a0$6bc240e0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHovAFSoGP6ZRyR0Aq0xZECqCS8dQHRLDtFAaVJrv8ByaQP4gJtbFJ8AarogNsB85vfPQF8QABUqKBgc9A=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmlu5aQ514g+sTeS023n3FarG37QS7
        xcufV9ksDj7sZLE4fPsdu8W0Dz+ZLT6tX8ZqsepBuMWcsw1MFr39W9ksFt3YxmRxedccNovu
        6zvYLJYf/8dkMeHlEhaLpVtvMlp0Tl/DYvGhp85i0cLdLA7CHpeveHtc7utl8tg56y67x+I9
        L5k8Jiw6wOjRcnI/i8f39R1sHh+f3mLx6NuyitHj8yY5j/YD3UwB3FFcNimpOZllqUX6dglc
        GV+fzGcsOCZV8f7IKcYGxvuiXYycHBICJhJnlxxn6WLk4hAS2M0oserXPyjnE6PE/7Xv2UGq
        hAS+MUpMmMgG03Hv0HU2iKK9jBLbf69nhHDeMErsnXCOEaSKTUBXYsfiNrAqEYEdTBKrFzQz
        gTjMAheYJO59v80KUsUpECtxZPERJhBbWMBb4semJSwgNouAisScvXfBbF4BS4lpfQ3MELag
        xMmZT8DizALaEssWvmaGuElB4ufTZWAzRQSSJKZ+WcQEUSMucfRnDzPIYgmB6ZwSx//MZoJo
        cJH4fuE1lC0s8er4FnYIW0riZX8bkM0BZGdL9OwyhgjXSCydd4wFwraXOHBlDgtICbOApsT6
        XfoQq/gken8/YYLo5JXoaBOCqFaVaH53FapTWmJidzcrhO0h8f7MVZYJjIqzkDw2C8ljs5A8
        MAth2QJGllWMkqkFxbnpqcWmBUZ5qeV6xYm5xaV56XrJ+bmbGMFpU8trB+PDBx/0DjEycTAe
        YpTgYFYS4c16oR0vxJuSWFmVWpQfX1Sak1p8iFGag0VJnFfpx5k4IYH0xJLU7NTUgtQimCwT
        B6dUA1OSjjLjfYmzJqJTjj25JXf05o6u2feSTx6cu0UyXF4oyzrXken8qaufNX/oCQv8n82w
        s3BXjOqVzMLIOFv+XX27NmwTs195pfje9lsXJkT17d96iitMMGNZWqdNr9KsWtvLDus3nvor
        ePDaSrOtQgmRuwOC73i/aFfccZ/VnaOt4mnrz0edmc6yUzlunZu5/7lbvJ9Hy/m7Au4aZz6x
        z19hKi/FbvnQL1ZoC98b6X6WzMCknwkM/14XHzS8lCJwvP4zd9q+ijiZSq0Z/Hy3HrXcU51a
        8rKmJN+mYNN27knz6pS2CE4x+fxi88SE1pJvQVoaPPucd5U33p6o8Hf9jH+JjVrKUn/28zyV
        CnRev0yJpTgj0VCLuag4EQDodLKoCgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsWy7bCSnO4aQ514g469EhYb775itdjbdoLd
        4uXPq2wWBx92slgcvv2O3WLah5/MFp/WL2O1WPUg3GLO2QYmi97+rWwWi25sY7K4vGsOm0X3
        9R1sFsuP/2OymPByCYvF0q03GS06p69hsfjQU2exaOFuFgdhj8tXvD0u9/UyeeycdZfdY/Ge
        l0weExYdYPRoObmfxeP7+g42j49Pb7F49G1ZxejxeZOcR/uBbqYA7igum5TUnMyy1CJ9uwSu
        jINvrjIWzJGq+PJkAmMD40bRLkZODgkBE4l7h66zdTFycQgJ7GaUWLp7FhNEQlri+sYJ7BC2
        sMTKf8/ZIYpeMUrM2fyfGSTBJqArsWNxGxuILSJwhEmieUIFSBGzwDUmiT8fP0ONXcEisf3m
        ERaQKk6BWIkji4+ArRAW8Jb4sWkJWJxFQEVizt67YDavgKXEtL4GZghbUOLkzCdgcWYBbYmn
        N5/C2csWvmaGOE9B4ufTZawQVyRJTP2yiAmiRlzi6M8e5gmMwrOQjJqFZNQsJKNmIWlZwMiy
        ilEytaA4Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOAFoae5g3L7qg94hRiYOxkOMEhzMSiK8
        WS+044V4UxIrq1KL8uOLSnNSiw8xSnOwKInz3ihcGCckkJ5YkpqdmlqQWgSTZeLglGpgsl8W
        auuTe+MvR/+9g9+XM3/2XndL2vn/zYN/3tineiRfid/9SePDgmWNX8SWBvxoeGUUujxm7855
        a7467ntr6TprWsD293xCF4L4Fbqn7J4RFnXZL47nkLhQY/Xes50JW+8m/tm68taza0afmlcm
        te/eGc2jXODYrBrm9W6vZOdhFyF1s9tOjnmLg0uZ/t6s09rv86Xlw0LvTSu+ba3I3JqXtW/K
        m69KNZN3NaVsn2Dx2mLmlK0C1o5xtxvnaM54c/5TyYQzx2pmLjHuMvxXut93gjhf/P1tEyTn
        WVfZfvp9zOjEoaL4zN/vVX5nyE3NN5388ZCmy+qMDSGTV2z6kV/y/Mpn5n18Rc1GbOdNRc2U
        WIozEg21mIuKEwF2nffQbwMAAA==
X-CMS-MailID: 20200806163700epcas5p2f15235fc7fa635bd1c585a8805c0e82f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d
References: <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p6>
        <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
        <7c59c7abf7b00c368228b3096e1bea8c9e2b2e80.camel@gmail.com>
        <SN6PR04MB4640CE297AAB3CF4D37EE002FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
        <39c546268abead68f4c00f17dc47c1597f3e0273.camel@gmail.com>
        <SN6PR04MB4640210D586CBA053F56DCF0FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
        <e3aba7fba7c208ac58c638139bd615c871d2e52e.camel@gmail.com>
        <SN6PR04MB464069DD70022FC3C55265B6FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Avri Altman <Avri.Altman=40wdc.com>
> Sent: 06 August 2020 19:27
> To: Bean Huo <huobean=40gmail.com>; daejun7.park=40samsung.com;
> jejb=40linux.ibm.com; martin.petersen=40oracle.com; asutoshd=40codeaurora=
.org;
> beanhuo=40micron.com; stanley.chu=40mediatek.com; cang=40codeaurora.org;
> bvanassche=40acm.org; tomas.winkler=40intel.com; ALIM AKHTAR
> <alim.akhtar=40samsung.com>
> Cc: linux-scsi=40vger.kernel.org; linux-kernel=40vger.kernel.org; Sang-yo=
on Oh
> <sangyoon.oh=40samsung.com>; Sung-Jun Park
> <sungjun07.park=40samsung.com>; yongmyung lee
> <ymhungry.lee=40samsung.com>; Jinyoung CHOI <j-young.choi=40samsung.com>;
> Adel Choi <adel.choi=40samsung.com>; BoRam Shin
> <boram.shin=40samsung.com>
> Subject: RE: =5BPATCH v8 0/4=5D scsi: ufs: Add Host Performance Booster S=
upport
>=20
>=20
> >
> > On Thu, 2020-08-06 at 10:12 +0000, Avri Altman wrote:
> > > > >
> > > >
> > > > we didn't see you Acked-by in the pathwork, would you like to add
> > > > them?
> > > > Just for reminding us that you have agreed to mainline this series
> > > > patchset.
> > >
> > > I acked it -
> > > https://protect2.fireeye.com/url?k=3D039c5a1c-5e48e674-039dd153-0cc47=
a
> > > 3356b2-
> 66867eb5b9700b6a&q=3D1&u=3Dhttps%3A%2F%2Fwww.spinics.net%2Flists%
> > > 2Flinux-scsi%2Fmsg144660.html
> > > And asked Martin to move forward -
> > > https://protect2.fireeye.com/url?k=3D94dceb38-c9085750-94dd6077-0cc47=
a
> > > 3356b2-
> 19ab1f41f48ff179&q=3D1&u=3Dhttps%3A%2F%2Fwww.spinics.net%2Flists%
> > > 2Flinux-scsi%2Fmsg144738.html Which he did, and got some sparse
> > > errors:
> > > https://protect2.fireeye.com/url?k=3Da40e2dd1-f9da91b9-a40fa69e-0cc47=
a
> > > 3356b2-
> 81fae05297aebb0e&q=3D1&u=3Dhttps%3A%2F%2Fwww.spinics.net%2Flists%
> > > 2Flinux-scsi%2Fmsg144977.html
> > > Which I asked Daejun to fix -
> > > https://protect2.fireeye.com/url?k=3D6badf100-36794d68-6bac7a4f-0cc47=
a
> > > 3356b2-
> f84580e236611583&q=3D1&u=3Dhttps%3A%2F%2Fwww.spinics.net%2Flists%
> > > 2Flinux-scsi%2Fmsg144987.html
> > >
> > > For the next chain of events I guess you can follow by yourself.
> > >
> > > Thanks,
> > > Avri
> >
> > Avri
> > Sorry for making you confusing. yes, I knew that, and following.
> > I mean Acked-by tag in the patchset, then we see your acked in the
> > patchwork, and let others know that you acked it, rather than going
> > backtrack history email.
> >
> > Hi Daejun
> > I think you can add Avri's Acked-by tag in your patchset, just for
> > quickly moving forward and reminding.
> Ahhh - One moment please -
> While rebasing the v8 on my platform, I noticed some substantial changes =
since
> v6.
> e.g. the hpb lun ref counting isn't there anymore, as well as some more s=
tuff.
> While those changes might be only for the best,  I think any tested-by ta=
g should
> be re-assign.
>=20
> Anyway, as for myself, I am not planning to put any more time in this, un=
til there
> is a clear decision where this series is going to.
>=20
> Martin - Are you considering to merge the HPB feature eventually to mainl=
ine
> kernel?
>=20
V8 has removed the =22UFS feature layer=22 which was  the main topic of dis=
cussion. What else we thing is blocking this to be in mainline?
Bart / Martin, any thought?


> Thanks,
> Avri
> >
> > thanks,
> > Bean


