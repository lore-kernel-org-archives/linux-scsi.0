Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E8CC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 02:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 998DA2074D
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 02:50:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="U4e6codZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgFPCuF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 22:50:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36934 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgFPCuF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 22:50:05 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200616025002epoutp03a81cab11b9e425b4a369e76eed96e72b~Y5mgLYvK20973509735epoutp03f
        for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2020 02:50:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200616025002epoutp03a81cab11b9e425b4a369e76eed96e72b~Y5mgLYvK20973509735epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592275802;
        bh=spjKI7Hru4Soqaq2x2p1K2V9p9tJZfIMpDHOwwXNFcA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=U4e6codZVmWZ22i7/tu3fli/Uh/Q9Erp9DVyY7/11FWR7tTliaLmyw4A8BOf6krCK
         zJ4MElA551XoAjOgGAAsGLoqtgKJguRhatyjQ5ht3MDA80f0G3xGhZwA4sMWrZNGRQ
         mlEImivGZJYQtb9sW4kKolnIvOOCcXP/OZxtCTH0=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200616025002epcas1p316c0cf1052a1a6976a1405c3b6eb54ce~Y5mf0vEjn1669816698epcas1p38;
        Tue, 16 Jun 2020 02:50:02 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [RFC PATCH v2 2/5] scsi: ufs: Add UFS-feature layer
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
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
In-Reply-To: <47dcc56312229fc8f25f39c2beeb3a8ba811f3e9.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1210830415.21592275802431.JavaMail.epsvc@epcpadp1>
Date:   Tue, 16 Jun 2020 10:18:42 +0900
X-CMS-MailID: 20200616011842epcms2p627921d294e8fea0348036e1d9eb5f2c1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210
References: <47dcc56312229fc8f25f39c2beeb3a8ba811f3e9.camel@gmail.com>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p6>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Bean
> 
> On Mon, 2020-06-15 at 16:23 +0900, Daejun Park wrote:
> > +void ufsf_scan_features(struct ufs_hba *hba)
> > +{
> > +       int ret;
> > +
> > +       init_waitqueue_head(&hba->ufsf.sdev_wait);
> > +       atomic_set(&hba->ufsf.slave_conf_cnt, 0);
> > +
> > +       if (hba->dev_info.wspecversion >= HPB_SUPPORTED_VERSION &&
> > +           (hba->dev_info.b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT)) 
> 
> How about removing this check "(hba->dev_info.wspecversion >=
> HPB_SUPPORTED_VERSION" since ufs with lower version than v3.1 can add
> HPB feature by FFU, 
> if (hba->dev_info.b_ufs_feature_sup  &UFS_FEATURE_SUPPORT_HPB_BIT) is
> enough.
OK, changing it seems no problem. But I want to know what other people think
about this version checking code.

Thanks,
Daejun
