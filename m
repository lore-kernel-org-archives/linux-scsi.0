Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29059C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 18:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 003C62073A
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 18:15:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="A7AIoE75"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgGUSPy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 14:15:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25507 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgGUSPx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 14:15:53 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200721181549epoutp02a0ddc80ed975b38ba6f50a7bc39939a7~j1zzqW1fL1985819858epoutp02t
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 18:15:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200721181549epoutp02a0ddc80ed975b38ba6f50a7bc39939a7~j1zzqW1fL1985819858epoutp02t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595355349;
        bh=U5jquic9LwrfkMmVraEYVoI8yc4c392U5HFsrbKZFgU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=A7AIoE759uE61TNdHf0DUyw84TZc8uHlNXjiuEsW/eT0Eer3kWLUOLSjQ5lR5Kai7
         ZoBrYw9iHGJda4JmkfZIbsKjcjXv7xiayjzQxv8j5ZefvHZydmSbMubDqTEwdiejQO
         ymy/yAuvEMtZauX3gcqMb+vjKBS58t5wR7/oBPmo=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200721181548epcas5p4334786dda9ee3589e77d9f2c1381925e~j1zyj_GgB1133111331epcas5p4b;
        Tue, 21 Jul 2020 18:15:48 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.C0.09475.4D0371F5; Wed, 22 Jul 2020 03:15:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200721181547epcas5p34f1d1e748c9018600a530dd354d36767~j1zxe1HBd0129501295epcas5p33;
        Tue, 21 Jul 2020 18:15:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200721181547epsmtrp2f75ecdfa1f520db6f9bc92b4da497418~j1zxd65rW3150631506epsmtrp2O;
        Tue, 21 Jul 2020 18:15:47 +0000 (GMT)
X-AuditID: b6c32a4b-39fff70000002503-84-5f1730d4fcf0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        23.BF.08303.3D0371F5; Wed, 22 Jul 2020 03:15:47 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200721181542epsmtip134cfbb551597f1ec7d7d0154c8b9a856~j1zsp07Up3207732077epsmtip1L;
        Tue, 21 Jul 2020 18:15:41 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>, <daejun7.park@samsung.com>,
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
In-Reply-To: <SN6PR04MB4640A85E665E20D709885E16FC7A0@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Date:   Tue, 21 Jul 2020 23:45:39 +0530
Message-ID: <06b001d65f8a$f4a41d50$ddec57f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQNTAwbo7R95v2Jv+B+oDyvdEhuZkAJ3qsxbAnEXg30BU3sSHwDKp0vLpeDXqjA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsWy7bCmpu4VA/F4g/8vhCw23n3FarG37QS7
        xcufV9ksDj7sZLE4fPsdu8W0Dz+ZLT6tX8ZqsepBuEVv/1Y2i0U3tjFZXN41h82i+/oONovl
        x/8xWUx4uYTFYunWm4wWndPXsFh86KmzWLRwN4uDkMflK94el/t6mTwW73nJ5DFh0QFGj5aT
        +1k8vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCK4rJJSc3JLEst0rdL4Mo4cKSPpWA2d8W1
        O7NZGhincHYxcnJICJhIrPg7gb2LkYtDSGA3o8SP4+tYIJxPjBJn2w6wg1QJCXxmlLjapwTT
        sWnqbBaI+C5Giev7aiAa3jBKLF63kBkkwSagK7FjcRsbSEJEYAqTxL89y8F2MAtcYJKYfvsE
        I0gVp0CsxKdF68A6hAW8JX6/ncEGYrMIqEpcfPaPFcTmFbCUeNK2jQnCFpQ4OfMJ2GpmAW2J
        ZQtfM0OcpCDx8+kysHoRAT+JH5PuM0LUiEsc/dnDDLJYQqCdU+LL9aXsEA0uEst37GSDsIUl
        Xh3fAhWXkvj8bi9QnAPIzpbo2WUMEa6RWDrvGAuEbS9x4MocFpASZgFNifW79CFW8Un0/n7C
        BNHJK9HRJgRRrSrR/O4qVKe0xMTublYI20Ni8raZrBMYFWcheWwWksdmIXlgFsKyBYwsqxgl
        UwuKc9NTi00LjPNSy/WKE3OLS/PS9ZLzczcxghOklvcOxkcPPugdYmTiYDzEKMHBrCTCq8Mo
        Hi/Em5JYWZValB9fVJqTWnyIUZqDRUmcV+nHmTghgfTEktTs1NSC1CKYLBMHp1QD0zIpD3HD
        30zV0vVhbd9WGgTzL3K9c/HZIlW+H6e2H/NjfLpkRdpc1p0pj3y8l0Td/ehx867RlCvnLRtu
        fa/K2tYTdH8v75PIKP6sy325vvc1U55NNpuj8397yyXNVeq3nNdtyO9hPM3fVJbFMvdeVrpf
        QGf2/rhth/1cDgjsyjn3PM9z811lhfDVyieraqQ2zDvtEf8gfLvzI49NKU5X3Q6p92rUxlfM
        e7S7sn7ZK5sCXY97M9pyve+/DTjdq61p+Zztu+p0A6vk/3vfNZk0mCm3FiVZfDnsmDnfVcTl
        U7rW+xfBnzctWLN9+5G3CZsu6x3zDjQVv3z38Ky/x54+tDSaekvcNPv3sxcHwg+47FdiKc5I
        NNRiLipOBAAXZ/pd/wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWy7bCSnO5lA/F4g4VbuSw23n3FarG37QS7
        xcufV9ksDj7sZLE4fPsdu8W0Dz+ZLT6tX8ZqsepBuEVv/1Y2i0U3tjFZXN41h82i+/oONovl
        x/8xWUx4uYTFYunWm4wWndPXsFh86KmzWLRwN4uDkMflK94el/t6mTwW73nJ5DFh0QFGj5aT
        +1k8vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCK4rJJSc3JLEst0rdL4Mpo3NHOXvCeq2LH
        xT9sDYwvOLoYOTkkBEwkNk2dzdLFyMUhJLCDUWLluwfsEAlpiesbJ0DZwhIr/z1nhyh6xSjx
        vn8bG0iCTUBXYsfiNjaQhIjAAiaJt8eWgTnMAteYJD5P72eGaLnCJNF9/C9YC6dArMSnReuY
        QWxhAW+J329ngMVZBFQlLj77xwpi8wpYSjxp28YEYQtKnJz5hAXEZhbQlnh68ymcvWzha2aI
        +xQkfj5dBtYrIuAn8WPSfUaIGnGJoz97mCcwCs9CMmoWklGzkIyahaRlASPLKkbJ1ILi3PTc
        YsMCo7zUcr3ixNzi0rx0veT83E2M4HjX0trBuGfVB71DjEwcjIcYJTiYlUR4dRjF44V4UxIr
        q1KL8uOLSnNSiw8xSnOwKInzfp21ME5IID2xJDU7NbUgtQgmy8TBKdXAdPSRFLeqktFj4UPS
        ukruGr0ZCp37g0+kMr+fdMbI6rzcupCM75UH573R2mJx/OBkl9o1SfdORT6Z/md5gI4vu9oc
        26Uq2V/Dfvxojd4aYBHwsCL07H8jA7bMnszlwet/27ybc+bLAdkr/zas36r/+fw+ydkVmUJb
        bvQFO+014V606wv7qc03b3DHhncuZy+68LU3e+uFvPsPE6KbE579WlH41vbOyeUqVk808y7e
        yNj27AdXi/vZp3UiPS12Uecex3sa2aze6VZbPTvr0zxV5RIBJ/cQU62U+kdPYgp9hRdMs7tz
        +5Kvz4mdzmwRzJkhn+yKN+aZuO9YFJC95seUCw/Kzd4YnP+kM2cvr0L6YiWW4oxEQy3mouJE
        ANR+sPpmAwAA
X-CMS-MailID: 20200721181547epcas5p34f1d1e748c9018600a530dd354d36767
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
        <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
        <077301d65b0d$24d79920$6e86cb60$@samsung.com>
        <SN6PR04MB4640A5A8C71A51DB45968DAFFC7C0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <SN6PR04MB4640A85E665E20D709885E16FC7A0@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin

> -----Original Message-----
> From: Avri Altman <Avri.Altman=40wdc.com>
> Sent: 19 July 2020 12:05
> To: Alim Akhtar <alim.akhtar=40samsung.com>; daejun7.park=40samsung.com;
> jejb=40linux.ibm.com; martin.petersen=40oracle.com; asutoshd=40codeaurora=
.org;
> beanhuo=40micron.com; stanley.chu=40mediatek.com; cang=40codeaurora.org;
> bvanassche=40acm.org; tomas.winkler=40intel.com
> Cc: linux-scsi=40vger.kernel.org; linux-kernel=40vger.kernel.org; 'Sang-y=
oon Oh'
> <sangyoon.oh=40samsung.com>; 'Sung-Jun Park'
> <sungjun07.park=40samsung.com>; 'yongmyung lee'
> <ymhungry.lee=40samsung.com>; 'Jinyoung CHOI' <j-
> young.choi=40samsung.com>; 'Adel Choi' <adel.choi=40samsung.com>; 'BoRam
> Shin' <boram.shin=40samsung.com>
> Subject: RE: =5BPATCH v6 0/5=5D scsi: ufs: Add Host Performance Booster S=
upport
>=20
> Martin - Can we move forward with this one?
>=20
> Thanks,
> Avri
>=20
> >
> > > > v5 -> v6
> > > > Change base commit to b53293fa662e28ae0cdd40828dc641c09f133405
> > > >
> > > If no further comments, can this series have your Reviewed-by or
> > > Acked-by tag, so that this can be taken for 5.9?
> > > Thanks=21
> > Hey, yes.  So sorry for this delay, I was away for few days.
> > Yes - This series looks good to me.
> >
This series needs your attention.

Thanks,

> > Thanks,
> > Avri
> >
> > >
> > > > v4 -> v5
> > > > Delete unused macro define.
> > >


