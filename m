Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3AACC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 03:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EE4F20734
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 03:51:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QG+nulfu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgFJDvo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 23:51:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43751 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgFJDvn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 23:51:43 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200610035140epoutp02ab99eca30790783519c42e276a03432a~XEkl428or1190411904epoutp02Z
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2020 03:51:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200610035140epoutp02ab99eca30790783519c42e276a03432a~XEkl428or1190411904epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591761100;
        bh=nt+O43pd0omdjJDq6Rok1zOLjNeYSCdHg3A0AnyLkJk=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=QG+nulfuBX3GtuZWZdDI8wYIhZ/hbIdYSmFZF0WLkQuO6fPWAyCTq7BLgVMn4aiVQ
         WD6SwnBjLQRiSNIBq3RVjj2jJfrpGOcqNeNENgiAqGbc/Pc2P74qIlhU5ZKDgflz5c
         vHROLnQQuh7nFbA2flMvOCElzhN4EGbcmuriN/Mo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200610035139epcas2p3f5b63403ac0c2c6461803db579107c53~XEklBOnEQ3084530845epcas2p3P;
        Wed, 10 Jun 2020 03:51:39 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.186]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49hY2L0XqszMqYlv; Wed, 10 Jun
        2020 03:51:38 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-02-5ee058c9a361
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        01.C7.27441.9C850EE5; Wed, 10 Jun 2020 12:51:37 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [RFC PATCH 4/5] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <SN6PR04MB464062D306BA6D635F274CD4FC820@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20200610035137epcms2p21380c5851ef675851b5122c3001df4ed@epcms2p2>
Date:   Wed, 10 Jun 2020 12:51:37 +0900
X-CMS-MailID: 20200610035137epcms2p21380c5851ef675851b5122c3001df4ed
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJsWRmVeSWpSXmKPExsWy7bCmhe6piAdxBoeCLTbefcVq8WDeNjaL
        vW0n2C1e/rzKZnHwYSeLxeHb79gtpn34yWzxaf0yVouXhzQtVj0It+jt38pmsejGNiaLy7vm
        sFl0X9/BZrH8+D8miwkvl7BYLN16k9Gic/oaFosPPXUWixbuZnEQ8bh8xdvjcl8vk8fiPS+Z
        PCYsOsDo0XJyP4vH9/UdbB4fn95i8ejbsorR4/MmOY/2A91MAVxROTYZqYkpqUUKqXnJ+SmZ
        eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QL8pKZQl5pQChQISi4uV9O1sivJL
        S1IVMvKLS2yVUgtScgoMDQv0ihNzi0vz0vWS83OtDA0MjEyBKhNyMnqetrMV/GWsOL77ImMD
        42nGLkZODgkBE4kDu/pZQGwhgR2MEp9XcnQxcnDwCghK/N0hDBIWFvCWaJ6+mRGiREli/cVZ
        7BBxPYlbD9eAxdkEdCSmn7gPFOfiEBHoYZFYP3k3M4jDLPCNSWLzxSNsEMt4JWa0P2WBsKUl
        ti/fygiyjFMgVuLBHVmIsIbEj2W9zBC2qMTN1W/ZYez3x+ZD3Swi0XrvLFSNoMSDn7uh4pIS
        x3Z/YIKw6yW23vnFCHKDhEAPo8ThnbdYIRL6Etc6NoLdwCvgK9F97AbYIBYBVYlF92Yygdwj
        IeAiMeG5EUiYWUBeYvvbOcwgYWYBTYn1u/QhKpQljtxigXmqYeNvdnQ2swCfRMfhv3DxHfOe
        QF2mJrHu53qmCYzKsxABPQvJrlkIuxYwMq9iFEstKM5NTy02KjBGjtpNjOBUruW+g3HG2w96
        hxiZOBgPMUpwMCuJ8FY/uBMnxJuSWFmVWpQfX1Sak1p8iNEU6MmJzFKiyfnAbJJXEm9oamRm
        ZmBpamFqZmShJM5bbHUhTkggPbEkNTs1tSC1CKaPiYNTqoFpwW9dWU15LkEVhUN/a0X2HRLw
        LAhh6/ENeTdhixrT26mi93o1XC22iaYFvE+0DD5rrLGFe6Lz40UbBPKizItPnywPuyE2h++3
        u9OEK3kVWe9O3Ne4YMr/iNuI4z7z4kw7a6NbnjGX72yJ63V1vb6pNqTe56s+XxZfa6iZyIbl
        /0Qrita13S3/ujNgUxLHt8PpqtU7l06rlV8cuFBoc3byrbWvtA4F93r7BEs7cq2YtC24monb
        KtspvkxQ13Gv3llhG4YL7FfcrkTc/OjV/ft6gM2PzDtyNc1fbMqviV+W27mSSehh5Iwb6427
        Avv+xc6dHen9bN2BX7m7u0ouyE4y+31j1tq2/9EL37dxX1ZiKc5INNRiLipOBACNOwgxbgQA
        AA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882
References: <SN6PR04MB464062D306BA6D635F274CD4FC820@SN6PR04MB4640.namprd04.prod.outlook.com>
        <SN6PR04MB46409E16CCF95A0AA9FFE944FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
        <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
        <1776409896.101591664283293.JavaMail.epsvc@epcpadp2>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p2>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> This is not a concern, just a question.
> If a map request started while runtime/system suspend, can you share its flow?
When suspended, the worker is cancled. And it can just 
process pending active/inactive list after resume.

Thanks,
Daejun
