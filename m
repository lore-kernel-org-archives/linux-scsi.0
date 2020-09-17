Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99442C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 00:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 362E0206CA
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 00:52:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LCUBOcKJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgIQAwN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 20:52:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36865 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgIQAwL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2020 20:52:11 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 20:52:09 EDT
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200917004302epoutp03e4f877d85a4445fa7745dce29d16a8ba~1a3J6vRDf0583605836epoutp03T
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2020 00:43:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200917004302epoutp03e4f877d85a4445fa7745dce29d16a8ba~1a3J6vRDf0583605836epoutp03T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1600303382;
        bh=iF01R0RXpU+eG69rlPV5Od9C+ssN22uuhWON4+DSNWY=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=LCUBOcKJm6KSsXIPiJQz8JOvW6JMijIvJ/3n/QU22bN7kaOdPeD5AND75hpnbbJpI
         XVKFZ9wNWV3W81XmsrAZxf7/htYSeDWLs7VqVq/NQJ//9Oh61jwuCz+omCaLGPJ/X7
         DfZ3hRBh5Q6ZTOT7QvxxgL7h9LvA93W3s5GOAgZc=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p2.samsung.com
        (KnoxPortal) with ESMTP id
        20200917004301epcas1p25b5958440691a33befafc83db482b36e~1a3JhP3uT1274212742epcas1p27;
        Thu, 17 Sep 2020 00:43:01 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [PATCH v11 0/4] scsi: ufs: Add Host Performance Booster Support
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20200916052208.GB12923@infradead.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01600303381578.JavaMail.epsvc@epcpadp2>
Date:   Thu, 17 Sep 2020 09:25:50 +0900
X-CMS-MailID: 20200917002550epcms2p168eb4c7e2fb77f7f31a5db2f3522e256
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200902031713epcms2p664cebf386ba19d3d05895fec89aaf4fe
References: <20200916052208.GB12923@infradead.org>
        <231786897.01599016802080.JavaMail.epsvc@epcpadp1>
        <231786897.01600211401846.JavaMail.epsvc@epcpadp1>
        <CGME20200902031713epcms2p664cebf386ba19d3d05895fec89aaf4fe@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Hi All,
> > 
> > I want to know how to improve this patch.
> 
> Drop it and fix the actual UFS feature to not be so horrible?
> 

Hello Christoph,

Thanks for the comment.

The HPB is essential feature for mobile devices.

NAND-based storage needs logical to physical mapping, which is cached in
the storage to minimize translation overhead. UFS is a NAND-based storage
device with limited resources, mainly used for mobile devices. Typically,
SSD has enough cache space for mapping information in SSD, but UFS has not
enough.
So, UFS stores L2P mapping in NAND and performs IO using demand loading 
for translation. Due to overhead of demand loading, it degrades random read
performance.

The HPB is a feature which uses host memory to relieve this problem. By 
using the HPB feature, UFS can provide improved random read performance
without mapping data thrashing problem. Therefore, the HPB is currently
already included in the Linux kernel code in android devices, however it 
is maintained as out-of-tree.

While upstreaming HPB feature to mainline kernel, we received various
comments from several reviewers (thanks!) and the HPB feature can be
improved. I think it would be good to make mainline the feature that are
mainly used.

Thanks,
Daejun

