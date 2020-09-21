Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C3AC43463
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 08:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E88ED20EDD
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 08:05:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Qlmr38hT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgIUIFG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:05:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11828 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgIUIFG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 04:05:06 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200921080503epoutp045b10eb3b80a50b1619aa8022622a1587~2vePclpBr0566805668epoutp041
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2020 08:05:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200921080503epoutp045b10eb3b80a50b1619aa8022622a1587~2vePclpBr0566805668epoutp041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1600675503;
        bh=jPMF6ttwhjh6Gz0Gb/xu2AZVqN/bOzkzOlaHhccbTdI=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Qlmr38hTllM1bsiMyG8uIlWCXyfOvq3YWIKCfLcSrE2JTF/IYMjiAaTa5u/f4dsz8
         gGx6AbQuhzFfTd7fsvBDu+4uM7EbFGvpg9oJ97ZjrfOJg4/+SL98hH6qCe0ZTeTSCt
         DQBrBQXIaOyKXq7d7kZXVM+9BR5Cw1u1zNWBOyH4=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200921080503epcas1p15266b69b4a59405cdcc7685635c6cc43~2veO9sQck2448624486epcas1p1p;
        Mon, 21 Sep 2020 08:05:03 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v11 0/4] scsi: ufs: Add Host Performance Booster Support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@infradead.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
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
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <2aecb02b-f845-b860-facd-e31bd964ac64@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1087081975.11600675503396.JavaMail.epsvc@epcpadp1>
Date:   Mon, 21 Sep 2020 17:03:36 +0900
X-CMS-MailID: 20200921080336epcms2p109f08924c333c8d7d87ef6f3f64d9b18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200902031713epcms2p664cebf386ba19d3d05895fec89aaf4fe
References: <2aecb02b-f845-b860-facd-e31bd964ac64@acm.org>
        <231786897.01599016802080.JavaMail.epsvc@epcpadp1>
        <231786897.01600211401846.JavaMail.epsvc@epcpadp1>
        <20200916052208.GB12923@infradead.org>
        <CGME20200902031713epcms2p664cebf386ba19d3d05895fec89aaf4fe@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> On Wed, Sep 16, 2020 at 08:05:17AM +0900, Daejun Park wrote:
>>> Hi All,
>>>
>>> I want to know how to improve this patch.
>> 
>> Drop it and fix the actual UFS feature to not be so horrible?
> 
> A new UFS specification could be defined and could be implemented for future UFS
> devices. I think this patch series is intended to support the millions of UFS
> devices that are already in use, e.g. in Android smartphones.

It is important point. 

I am not suggesting a strange feature, but want to make mainline the HPB
feature that is already widely used in Android smartphones.

Thanks,

Daejun.
