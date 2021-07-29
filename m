Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B70C43216
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCB8860FD7
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhG2A6K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 20:58:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63134 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbhG2A6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 20:58:08 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210729005804epoutp024c3938393c38b4e625dfffb8570a43f8~WHRNvFqFX3252532525epoutp02Y
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 00:58:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210729005804epoutp024c3938393c38b4e625dfffb8570a43f8~WHRNvFqFX3252532525epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627520284;
        bh=0EVBSdNRcpHjmzjtLfJgPZmkfKC2IZoDUvT7MpXl/KE=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=tyrgXkqePuq7GybEKzfMeJ+4zmLA5yokTBVUckjdPGmrwxAyBX2+yjjsYyb8fEJth
         l5ah3pNjReNbg9menJfK0FCpYJYuTto1iVL0yYM8cldI+OcxraAZoPfwz5xdf3IwY9
         qC7QMu6h28hvFK6MpoGvdBFW5GX1hcOpY/0r4bnA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210729005804epcas3p32947a6046a34f100cf72fb5e2e7b13e9~WHRNJZLBe2556725567epcas3p3q;
        Thu, 29 Jul 2021 00:58:04 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4GZsZz6vQCz4x9QC; Thu, 29 Jul 2021 00:58:03 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v3 02/18] scsi: ufs: Reduce power management code
 duplication
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Yue Hu <huyue2@yulong.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Phillip Potter <phil@philpotter.co.uk>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Keoseong Park <keosung.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210722033439.26550-3-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2145970759.101627520283941.JavaMail.epsvc@epcpadp4>
Date:   Thu, 29 Jul 2021 09:56:46 +0900
X-CMS-MailID: 20210729005646epcms2p29e8015169199c3a08b53802269343fe6
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210722033510epcas2p410be4f2f387e98babeefc754a9fc1414
References: <20210722033439.26550-3-bvanassche@acm.org>
        <20210722033439.26550-1-bvanassche@acm.org>
        <CGME20210722033510epcas2p410be4f2f387e98babeefc754a9fc1414@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>Move the dev_get_drvdata() calls into the ufshcd_{system,runtime}_*()
>functions. Remove ufshcd_runtime_idle() since it is empty. This patch
>does not change any functionality.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
