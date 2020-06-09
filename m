Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE144C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 00:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C30A020760
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 00:58:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tKQGVlOs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730427AbgFIA6L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:58:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25243 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732992AbgFIA6G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 20:58:06 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200609005804epoutp048b9a113f7b19906bac99ad96bbcaf04f~WujvLLH8V2264822648epoutp04Z
        for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2020 00:58:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200609005804epoutp048b9a113f7b19906bac99ad96bbcaf04f~WujvLLH8V2264822648epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591664284;
        bh=EO/Fm0G63JOSK4LfY2ZRNq1/w1KrmQFpGKU7em5qlVA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=tKQGVlOsoXtBkyyLu6A1gK6yIoOp3mbVlC6SYXeizJuD23cn5H2iBk2RUJbCx8Kbf
         QFbvpJ5ogZDLCI6UAhuxHksz1XRegzO+PJYc78DFWG0sKNbUza9KDA+q4uRe9f1VHW
         l/asICSr0lGWuba0d737f3AzQBX8LJqilT5UjuTw=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200609005803epcas1p362b3776cefe3f1f54bde1cccdb7081e9~Wujurjld11119911199epcas1p3j;
        Tue,  9 Jun 2020 00:58:03 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [RFC PATCH 3/5] scsi: ufs: Introduce HPB module
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
In-Reply-To: <BYAPR04MB46297B7D1CDD6CA00E87F640FC840@BYAPR04MB4629.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1932274274.141591664283763.JavaMail.epsvc@epcpadp2>
Date:   Tue, 09 Jun 2020 09:53:48 +0900
X-CMS-MailID: 20200609005348epcms2p8daabb4503ed03de4b109c97f3a7641ce
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882
References: <BYAPR04MB46297B7D1CDD6CA00E87F640FC840@BYAPR04MB4629.namprd04.prod.outlook.com>
        <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p8>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +static int ufshpb_get_dev_info(struct ufs_hba *hba,
> > +                              struct ufshpb_dev_info *hpb_dev_info,
> > +                              u8 *desc_buf)
> > +{
> > +       int ret;
> How about here, before doing anything, check that the descriptors are in proper size?
OK, I will add a size check for the descriptor.

Thanks,
Daejun
