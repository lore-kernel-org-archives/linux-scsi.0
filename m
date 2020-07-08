Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30507C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 23:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04F712078A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 23:30:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NhNaaGx8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgGHXaF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 19:30:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47129 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgGHXaF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 19:30:05 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200708233002epoutp0165159ce41630ba0efe979ae14b5b2aba~f6tcJqknm0725007250epoutp01H
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 23:30:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200708233002epoutp0165159ce41630ba0efe979ae14b5b2aba~f6tcJqknm0725007250epoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594251002;
        bh=3sEDm6a3mlpNgUfvnx3OAi8GbORD56TJQSPE7RKN448=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=NhNaaGx8syjcYucsy82XvbA3bGoFfs7NTermeU10D1gFXsdNbq3IMS4L6U1HRCju7
         UH1WU27YxXSiMHodRL6aRewwhoUcJhLmCIacHreAcbIbMgvLIa3DCFDOtdep75i+MN
         omJ9wyJi23Kes+JNfxdsQ0WLd6O3uXDg89hr/94E=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200708233001epcas1p38ee6d7c1a6593a234607427a2a3e1768~f6tbm2qph1693216932epcas1p3k;
        Wed,  8 Jul 2020 23:30:01 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v5 0/5] scsi: ufs: Add Host Performance Booster Support
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
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
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <963815509.21593732182531.JavaMail.epsvc@epcpadp2>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01594251001808.JavaMail.epsvc@epcpadp1>
Date:   Thu, 09 Jul 2020 08:26:56 +0900
X-CMS-MailID: 20200708232656epcms2p4e04fb7d576cf56d47f4730c25a53a305
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4
References: <963815509.21593732182531.JavaMail.epsvc@epcpadp2>
        <CGME20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4@epcms2p4>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

Just a gentle reminder that I'd like some feedback.
Any suggestions here?

Thanks,
Daejun
