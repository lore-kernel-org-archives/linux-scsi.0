Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B16C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 05:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DE8E64E2B
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 05:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhBAFRF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 00:17:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40154 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhBAFPq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 00:15:46 -0500
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210201051502epoutp01a5899bfad029d01ba3b411c5bf5d5dcb~fh8w49dI31683616836epoutp01p
        for <linux-scsi@vger.kernel.org>; Mon,  1 Feb 2021 05:15:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210201051502epoutp01a5899bfad029d01ba3b411c5bf5d5dcb~fh8w49dI31683616836epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612156502;
        bh=DQsAohp7eSFa2KD1KUeAEOSSbc/e06VHkggTf3NAU3c=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=LCrb868gfycrzdm5y9dQSrT/iN1ftEoQkbtL4Y8zsEg6NTu5BqhVKUaIKW89iom7o
         pyZTkzulh9dm9g4nsoNKApTq9qNGH5IEfcXXAgyTbxpWkku+/oC2/O4/dBMHaHfyGV
         bXqG/pf2VKx1+H1sERpV2NGthxU6LoGCBTjGWRXQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210201051502epcas3p3f5b41ab506a3ac3b3a0274622d3d815e~fh8wWQmde3126231262epcas3p3b;
        Mon,  1 Feb 2021 05:15:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4DTbjf1QD7z4x9Pt; Mon,  1 Feb 2021 05:15:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH 6/8] scsi: ufshpb: Add hpb dev reset response
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210127151217.24760-7-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01612156502170.JavaMail.epsvc@epcpadp3>
Date:   Mon, 01 Feb 2021 14:10:38 +0900
X-CMS-MailID: 20210201051038epcms2p4125b764fa0caee066060b402a7e02904
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210127151338epcas2p2c323a148587e311f7f5e19b4edbe43ec
References: <20210127151217.24760-7-avri.altman@wdc.com>
        <20210127151217.24760-1-avri.altman@wdc.com>
        <CGME20210127151338epcas2p2c323a148587e311f7f5e19b4edbe43ec@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> +	list_for_each_entry_safe(rgn, next_rgn, &lru_info->lh_lru_rgn,
> +				 list_lru_rgn)
How about replace list_for_each_entry_safe to list_for_each_entry?

Thanks,
Daejun
