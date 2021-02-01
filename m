Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E0FC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 04:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ACD964E2A
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 04:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhBAEdp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jan 2021 23:33:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:19635 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhBAE3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2021 23:29:34 -0500
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210201042803epoutp03d43d4fa96b79391eea265d57b598f843~fhTvCkula2072120721epoutp03_
        for <linux-scsi@vger.kernel.org>; Mon,  1 Feb 2021 04:28:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210201042803epoutp03d43d4fa96b79391eea265d57b598f843~fhTvCkula2072120721epoutp03_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612153683;
        bh=dw0dZpbp7++/1JRtnsngSTgQrJqru0N6BGIt535XPHk=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=GLqu0eVfuPjPDza1e+uzh18WNpHOnw/FnwD1agmgeXDH47O9SH2MpYK/gRlx3w2we
         LfuJlpeG1xP3v2P9KZyTJyJ3sDVzwCPARZ+VCcOLP1rJMHpbu5s2IEmHBikTc35p2B
         B41Af26HTQD7/gI3gt5WsfXgTtf5LYC9XR5WgSlg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210201042801epcas3p1d4384e01e28f82b54809c5dc47fa98aa~fhTtlRHl30194001940epcas3p1f;
        Mon,  1 Feb 2021 04:28:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4DTZgP5Bnyz4x9Pr; Mon,  1 Feb 2021 04:28:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH 4/8] scsi: ufshpb: Make eviction depends on region's
 reads
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
In-Reply-To: <20210127151217.24760-5-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01612153681714.JavaMail.epsvc@epcpadp4>
Date:   Mon, 01 Feb 2021 12:59:33 +0900
X-CMS-MailID: 20210201035933epcms2p4213209edf14280e1b1603335328da7f4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210127151318epcas2p1cdad0118807907e55b8d8277daec6f1a
References: <20210127151217.24760-5-avri.altman@wdc.com>
        <20210127151217.24760-1-avri.altman@wdc.com>
        <CGME20210127151318epcas2p1cdad0118807907e55b8d8277daec6f1a@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> +		/*
> +		 * in host control mode, verify that the exiting region
> +		 * has less reads
> +		 */
> +		if (ufshpb_mode == HPB_HOST_CONTROL &&
> +		    atomic64_read(&rgn->reads) > (EVICTION_THRSHLD >> 1))
Why we use shifted value to verify less read? I think we should use another
value to verify.

Thanks,
Daejun
