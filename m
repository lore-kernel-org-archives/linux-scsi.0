Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B07EC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 08:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CDF460F9D
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 08:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhG1IAU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 04:00:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26971 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235070AbhG1IAM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 04:00:12 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210728080004epoutp019f31355a4bd0f07089cb3ef54fcb3cea~V5YYjyU6D3014530145epoutp01h
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2021 08:00:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210728080004epoutp019f31355a4bd0f07089cb3ef54fcb3cea~V5YYjyU6D3014530145epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627459204;
        bh=kl81qUf/UdWkjC9q0vY1xdRX4Gy81tCMzhMd22Qkv3M=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=AP9L9pKDxMtfaq6gSboPVCTVQXsPm7FvV4UmZJNOgz4bk4fdmyDKn1K/EGa8tJHUR
         c0cr89I18sAztyIRUU5u3N9quN8PSKV3cQmRr0sOirSk2DqZ+mw7q7podN7Z77tBCm
         r/hGKPSuWWp5Yq2P/ou1GBj/q2FDpLN97SDf+T5Y=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210728080002epcas3p3f3f932dbecf1bb148a3b7c5a582eb5fb~V5YW0TL791094910949epcas3p3s;
        Wed, 28 Jul 2021 08:00:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4GZR0L5819z4x9QS; Wed, 28 Jul 2021 08:00:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v3 08/18] scsi: ufs: Improve static type checking for
 the host controller state
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210722033439.26550-9-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1381713434.61627459202706.JavaMail.epsvc@epcpadp3>
Date:   Wed, 28 Jul 2021 16:56:39 +0900
X-CMS-MailID: 20210728075639epcms2p1f4f7c454f4dae193422838cf687ce878
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210722033530epcas2p4c76293e5fc5163fed3995acdd02678ce
References: <20210722033439.26550-9-bvanassche@acm.org>
        <20210722033439.26550-1-bvanassche@acm.org>
        <CGME20210722033530epcas2p4c76293e5fc5163fed3995acdd02678ce@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>Assign a name to the enumeration type for UFS host controller states and
>remove the default clause from switch statements on this enumeration type
>to make the compiler warn about unhandled enumeration labels.
>
>Reviewed-by: Avri Altman <avri.altman@wdc.com>
>Cc: Can Guo <cang@codeaurora.org>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good to me.

Reviewed-by: Keoseong Park <keosung.park@samsung.com>
