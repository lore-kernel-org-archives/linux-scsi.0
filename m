Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B3AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 01:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC95F611BF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 01:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbhKJBzu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 20:55:50 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50200 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhKJBzu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 20:55:50 -0500
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211110015301epoutp028edd6428b332da8e29fedf71fd2944c1~2DG4fSafP1535515355epoutp02c
        for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2021 01:53:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211110015301epoutp028edd6428b332da8e29fedf71fd2944c1~2DG4fSafP1535515355epoutp02c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1636509181;
        bh=lvZsKN2VXM+DetM3+EhURhhk1fgBFNLPww3YigJckr4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=g55/7bInwBUxEfuolTwduy8IerdypmFQ2yPaN1JxHrOPK3bEd21p+xNjJkhRxfAgB
         VwSikLYTnuB20BJgAEc+6/Vwk1pfiCIDBZqqeH/sFVx3N8aZmVOnkqyV1Z2Ytfoexq
         4tS6Etdk79adip8OBAi4I+PFWYrvaebvpGTvxvLI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20211110015301epcas3p1573d1aed9a599f2da8f86c2ba5a33c17~2DG4CJ_Ve1738317383epcas3p1y;
        Wed, 10 Nov 2021 01:53:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4HpntP1HG5z4x9QL; Wed, 10 Nov 2021 01:53:01 +0000
        (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211110012815epcas2p3b4f8d4e1cea2cb2cc13f0fcdefc39c9a~2CxQyeXXb1559315593epcas2p3R;
        Wed, 10 Nov 2021 01:28:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211110012815epsmtrp1f2e192fa1f888fc59837fd5c3801dc4b~2CxQwkuhD0577505775epsmtrp1I;
        Wed, 10 Nov 2021 01:28:15 +0000 (GMT)
X-AuditID: b6c32a29-409ff700000074af-da-618b202f5b4d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8D.47.29871.F202B816; Wed, 10 Nov 2021 10:28:15 +0900 (KST)
Received: from KORCO082417 (unknown [10.229.8.121]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20211110012815epsmtip1d674c38c0bbde95030df0599fce64d13~2CxQmBWi70790607906epsmtip1G;
        Wed, 10 Nov 2021 01:28:15 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     <linux-scsi@vger.kernel.org>, "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Yue Hu'" <huyue2@yulong.com>,
        "'Peter Wang'" <peter.wang@mediatek.com>,
        "'Stanley Chu'" <stanley.chu@mediatek.com>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Asutosh Das'" <asutoshd@codeaurora.org>,
        "'Keoseong Park'" <keosung.park@samsung.com>
In-Reply-To: <20211110004440.3389311-2-bvanassche@acm.org>
Subject: RE: [PATCH 01/11] scsi: ufs: Rename a function argument
Date:   Wed, 10 Nov 2021 10:28:15 +0900
Message-ID: <2038148563.21636509181613.JavaMail.epsvc@epcpadp4>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGNlQ1VLD3900m/KRSp2q44GuuT/wHYmWGEAh9o+aascLln4A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRzGe885OztbrE7baG+WFovCCW1JF18jSyrikARiEFiMOuphM52u
        zS5WH6zEyyzTrjq7WJLmMsU53SJvTS1XKIbdjNSyKUlZapCti9Wmkd9+8Dz/H8+HP4WL+wk/
        Kj4phTMksYlyUkjUtcgDVqiW5LArHQ0K5HJXkOjN1ToSNWS089Gw5xmJ7r/NJtDFUQ+OxqtK
        eWjYqUD1Rb04cleZcXTjZR2GHro+AVQ98g1DPbY2AuW8cJCo7OEkhmrHf/DQzdoeEC5mup9G
        MOa00yTTnXsaY0rqhzHGaskmmbwbzYBJdzURzERVFsmMDb4imFybBTBfrAFMZnMOxtRWlOCR
        ol3C9XFcYvxBzqDasFeofZ35k68/JTjceH6Slwbe801AQEF6NawcKyNNQEiJ6XsAtjvP4VOB
        Pxz65JguSWB/eitvqjQEYOlAmS8gaRUczqrjeVlKx8GC4jG+t4TTOTz4vPYa8AZi+i6AFTVC
        LwvoddBkn8C8LKHDoeVJv09E0MtgycdeH4voUNh82YZN8TzoKnQTJkD9lSphRrVPidOLoX3k
        8vTQJdAzWDq9YRO02ruxqY4UFmVn4HlAYp5hMv83mWeYzDMuigFhAQs4vVGn0RmD9cFJ3CGl
        kdUZDyRplLHJOivw/UCQwgHsllGlE2AUcAJI4XKpqK8tixWL4tjUI5wheY/hQCJndIKFFCGX
        ibpMrj1iWsOmcAkcp+cM/1KMEvilYaW9zR+iWYvt0glFj62IOVKesOnU6sqCgi2a/A51387P
        qQ3+Fz3alBQXJdUoHi3XRgC6rH1o3KOdLAgs94s5udGubNPtuHbUf+m7vqh0v0tf84+tGZWp
        F65QB/5muJr83XyVxP2uemuXiY6KFNyh6lvnBAJ8bTm17sWq+R1RXfOKuX2pnWmfCyOsndmL
        XgcJvn6PfixTOxI6ZOwA1VgIVJ3h+kPXbSGzo0OC1ANhufSDX22TjuiwWW9HmlpVyfW3s64c
        l4rwynuyAE6g21YcYpm7edUa+ZnMbtudC3vzYt9s7r31eHvTxAPe7bDB2MgYR/xg6P4Wydnr
        ee5Q/13v5YRRywYH4QYj+wdI9/BDcgMAAA==
X-CMS-MailID: 20211110012815epcas2p3b4f8d4e1cea2cb2cc13f0fcdefc39c9a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20211110004503epcas2p1fb75c50cd82cba2217b917d85cc939fb
References: <20211110004440.3389311-1-bvanassche@acm.org>
        <CGME20211110004503epcas2p1fb75c50cd82cba2217b917d85cc939fb@epcas2p1.samsung.com>
        <20211110004440.3389311-2-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Wednesday, November 10, 2021 9:45 AM
> To: Martin K . Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org; Jaegeuk Kim <jaegeuk@kernel.org>; Adrian
> Hunter <adrian.hunter@intel.com>; Bart Van Assche <bvanassche@acm.org>;
> James E.J. Bottomley <jejb@linux.ibm.com>; Krzysztof Kozlowski
> <krzysztof.kozlowski@canonical.com>; Alim Akhtar
<alim.akhtar@samsung.com>;
> Bean Huo <beanhuo@micron.com>; Avri Altman <avri.altman@wdc.com>; Kiwoong
> Kim <kwmad.kim@samsung.com>; Yue Hu <huyue2@yulong.com>; Peter Wang
> <peter.wang@mediatek.com>; Chanho Park <chanho61.park@samsung.com>;
> Stanley Chu <stanley.chu@mediatek.com>; Can Guo <cang@codeaurora.org>;
> Asutosh Das <asutoshd@codeaurora.org>; Keoseong Park
> <keosung.park@samsung.com>
> Subject: [PATCH 01/11] scsi: ufs: Rename a function argument
> 
> The new name makes it clear what the meaning of the function argument is.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Great.
Reviewed-by: Chanho Park <chanho61.park@samsung.com>

Best Regards,
Chanho Park


