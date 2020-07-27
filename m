Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AAB3C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 06:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 101DE20714
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 06:23:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uGtwyHZK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgG0GXE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 02:23:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61143 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgG0GXE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 02:23:04 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200727062302epoutp01c5a2f65e0dc76a6f98da47d3de079aaa~lh9K_4v0P1113811138epoutp01j
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2020 06:23:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200727062302epoutp01c5a2f65e0dc76a6f98da47d3de079aaa~lh9K_4v0P1113811138epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595830982;
        bh=JpORZJFQpljj7zbq7Uq5L0uuPoUohXTIkVippavmwNo=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=uGtwyHZKQj25OBa47nm1KPKAWS/DQNA1+E4kYmLoKictdMrWmAgjA7wIt0algacsO
         /LRPH+uDxtoIfI4fFvo5cY3EGvL6Z7Xdtokrqi4to73VWp1Ie/vitbfROZXDLFhvSf
         B7wYrtgu8ZmRIw9w/EZkgRUOQgcc6ElIv8bIdtTY=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p2.samsung.com
        (KnoxPortal) with ESMTP id
        20200727062301epcas1p2c53b02094f8dd1da5fe76e202aaa895d~lh9Kj5iV33172031720epcas1p2e;
        Mon, 27 Jul 2020 06:23:01 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [PATCH v6 2/5] scsi: ufs: Add UFS-feature layer
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>
CC:     Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <7bcf45da-233b-0c38-b93a-99d205603e63@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <963815509.21595830981720.JavaMail.epsvc@epcpadp2>
Date:   Mon, 27 Jul 2020 15:18:15 +0900
X-CMS-MailID: 20200727061815epcms2p3c85befcefda3bd5f292a32c29d29e000
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8
References: <7bcf45da-233b-0c38-b93a-99d205603e63@acm.org>
        <231786897.01594636801601.JavaMail.epsvc@epcpadp1>
        <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
        <231786897.01594637401708.JavaMail.epsvc@epcpadp1>
        <20200722064112.GB21117@infradead.org>
        <yq1h7tzg1lb.fsf@ca-mkp.ca.oracle.com>
        <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p3>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > I am also not sold on the whole "bus" thing.
> 
> How about implementing HPB as a kernel module that calls the functions
> in the UFS core directly, or in other words, get rid completely of the
> new ufsf_bus introduced by this patch?

OK, I will remove the ufsf_bus and indirect calling functions.

Thanks,
Daejun
