Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F2BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 02:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C684E20720
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 02:26:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="giS6wire"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbgGHC0V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 22:26:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12760 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbgGHC0U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 22:26:20 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200708022618epoutp03eac105114d417c75a8d4f967bfd4a66b~fpeDae5wR0625006250epoutp03G
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 02:26:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200708022618epoutp03eac105114d417c75a8d4f967bfd4a66b~fpeDae5wR0625006250epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594175178;
        bh=B4YVKoc3vrnkn0vTO7wfPtHKAjD8XuIg/of+q6XDvvo=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=giS6wire6I9gAg/d79+9krT8Gbh8TNPIhGXDsjzp/R3gzgmYjfL/uAeMEyZ5U2TNb
         tcPimQc0HEW3fD8T4p1yHhKbKrHII3JXsFp7J2RTE/M98AIPb/2PEvkv+k1a1l0UMR
         UxT8OaUBIChRaIQilU5c0DNXMwi5fofAwCLq2eYk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200708022617epcas2p47b28d69359667a4cc6cd0ad1c77c6045~fpeCvGEnM0382003820epcas2p4X;
        Wed,  8 Jul 2020 02:26:17 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4B1jpv3wCNzMqYkk; Wed,  8 Jul
        2020 02:26:15 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        DB.FF.27013.6CE250F5; Wed,  8 Jul 2020 11:26:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200708022613epcas2p2c4a6e5c5bb63b71d35a99b47bbbbadc9~fpd-O04LT2041220412epcas2p2X;
        Wed,  8 Jul 2020 02:26:13 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200708022613epsmtrp13dadb7684c8f7e28bd44944add38b585~fpd-N_dsb0865408654epsmtrp14;
        Wed,  8 Jul 2020 02:26:13 +0000 (GMT)
X-AuditID: b6c32a48-d1fff70000006985-de-5f052ec65553
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        97.A1.08303.5CE250F5; Wed,  8 Jul 2020 11:26:13 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200708022613epsmtip26c5fca020af34f769f236fe2088f5d35~fpd-BklHT0096300963epsmtip2c;
        Wed,  8 Jul 2020 02:26:13 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>
Cc:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <1594173709.10600.3.camel@mtkswgap22>
Subject: RE: [RFC PATCH v4 2/3] ufs: exynos: introduce command history
Date:   Wed, 8 Jul 2020 11:26:13 +0900
Message-ID: <000701d654cf$269d6120$73d82360$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMZv//Rw0wsbuEqyeQX+rDWIvjdtQFeKClqAepwVRsC1qdyTqZFJCcQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta0xbZRj2a0/b00nNWUH9BobVMxY7DNDiCgdCh46NVfEHcT+MC1qP9KSt
        9LaeUp0uiIKlUO5kTDqykakssGWdG0KtQKAUEOMMoYxbWEIz64YZwsaCYabM0tNF/j3v+zzP
        e/kuKFvo48ajWoOFMhtIHc7dhfSOHMhMGUvlKCWrGwnE0vleLjFg+4VHLG/e4hLDgWqEaF3b
        ZBMPXZ0c4nHIxSMuf7uEEBfnelmEY9bNJS6Nb7GImttzgPh+awV5XaDwTxco/PV1LEXjxSGg
        +Mdl5yoeBBcQRX1PN1CsX09UVA05WIXoCV2OhiJVlFlEGYqNKq1BLccLjivzlLIMiTRFmkVk
        4iIDqafk+JG3C1PytbrwyLjISupKw6lCkqbxtEM5ZmOphRJpjLRFjlMmlc4klZpSaVJPlxrU
        qcVGfbZUIkmXhZUf6jRd967yTNfQT+/3ny4HU9wawEchdhDON81xasAuVIi5AfT1fwWY4CGA
        Yz/9GGXWAXROD7GeWm5uXEMYwgPgTMgTVd0DsNkZ4myruNirsDXwcwTHYSIYsnnZ2yI25mLB
        mopW3jbBx9LhZK8ngmOxfPio90KkBYIlQceEL5IXYFlwYqQdMHg3nGj7A9nGbGwv7FtpZzMj
        ieBmsDPaLB9u9LkBo4mD56ptkcYQm0ZhS9OZMIGGgyNwetjEeGPhX+M9PAbHw+UGWxR/AQfP
        lHMYby2AwcEtwBCvQeefVZE6bOwAdHnSmJL7oG8hOtpz0D4S4jFpAbTbhIxxH3zc3BItsge2
        zS/yGgHu3LGYc8dizh0LOP/v1QGQbvACZaL1aopONx3cednXQeQ5Jyvc4NzKWqoXsFDgBRBl
        43ECycscpVCgIk99RpmNSnOpjqK9QBY+6iZ2/PPFxvB/MFiUUll6RoYkS0bIMtIJ/EXB39mT
        HwgxNWmhSijKRJmf+lgoP76c9XUgZn9jsPVYduXNdweoiuEyy8kHHYeNtxoaPl8YfIX/KDnX
        HntKm8AXZyfMll8ZtJ62tnyndud+hPzbWflkIfO8KpHvp1i8xdqyZ7qoT6onq+Qm/zcyO3nj
        tsZRZ37WLLY2fhnMC+Q+mTluPeaPee/oW5b8evXyhivxbo9KYpW/6Ti5enlR3FVdJEaSSt7v
        ESUl/zC22r5RYpRfbS7ps4/XLpS9dFdyxZUzX3FJ22rL4N6Y+vW+bx2+k0aMCmZ+6z9bl1JA
        GpbWxi/sIQrf0M9O7Q96xY4JT/cqLY7JGzWPHvq46M7egUotaUoUdnbspn4vvZNbdPjsFieQ
        1LZ5AkdoDSlNZptp8j8qmxcYVwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWy7bCSvO5RPdZ4g9P/NC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mi667Nxgt
        lv57y+LA63H5irfH5b5eJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5LzaD/QzRTAEcVlk5Ka
        k1mWWqRvl8CVsfLFOvaCDRwVb/bUNDBeYuti5OSQEDCROPttA0sXIxeHkMAORonttydBJSQl
        Tux8zghhC0vcbznCCmILCTxjlHizNQ7EZhPQlpj2cDdYXERAQeJv2yFmkEHMAnuZJC4/2MsE
        0dDAJHFojSCIzSlgJHFh2y52EFtYwE3iy7b5YDUsAioS3SePgMV5BSwlTh6ewwhhC0qcnPmE
        BcRmBlrW+7CVEcKWl9j+dg4zxHEKEj+fLoM6wk3i2/YdUDUiErM725gnMArPQjJqFpJRs5CM
        moWkZQEjyypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOAo1dLawbhn1Qe9Q4xMHIyH
        GCU4mJVEeA0UWeOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ836dtTBOSCA9sSQ1OzW1ILUIJsvE
        wSnVwDTDic1qX9Befc1oxVUbWkV0b/kt2yX+9POz+S8vHdu57s3V+c9kuGIXGLhJTkw57cXZ
        aMLsd+fblU1nw35aBb2cEV9dZia5yraO588U9mudLAJxJ0/d/79EviLxnZ7SwzaJqR68X698
        uP9MWH/ppcr3l9ZFz43YXZDem/Ut928L15lJLYdNTwteebolPlnmwPmFh0M+qtefFRBmNo48
        IhFpc+WPkNtum4J7Rz4euGqSfGH+Wd9ak1nnb3ve/z3LTqxs9a8K6xjjXPO61lhjS4uGsy+3
        /r0Y9Fdh5xJWtbUPina+nLGttPrOj0t/d09J4OVPLkwLlj82ffZ185Vm3yblSL1zu7E8qv81
        4yQG67KFSizFGYmGWsxFxYkAzXaoDEEDAAA=
X-CMS-MailID: 20200708022613epcas2p2c4a6e5c5bb63b71d35a99b47bbbbadc9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200708015244epcas2p44358cef6bc03288c723ef77549aaaca2
References: <cover.1594097045.git.kwmad.kim@samsung.com>
        <CGME20200708015244epcas2p44358cef6bc03288c723ef77549aaaca2@epcas2p4.samsung.com>
        <40302a83cf4fd1f9e636a029db8ba579dbbda230.1594097045.git.kwmad.kim@samsung.com>
        <1594173709.10600.3.camel@mtkswgap22>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hi Kiwoong,
> 
> On Wed, 2020-07-08 at 10:44 +0900, Kiwoong Kim wrote:
> > This includes functions to record contexts of incoming commands in a
> > circular queue. ufshcd.c has already some function tracer calls to get
> > command history but ftrace would be gone when system dies before you
> > get the information, such as panic cases.
> >
> > This patch also implements callbacks compl_xfer_req to store IO
> > contexts at completion times.
> >
> > When you turn on CONFIG_SCSI_UFS_EXYNOS_CMD_LOG, the driver collects
> > the information from incoming commands in the circular queue.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > Acked-By: Stanley Chu <stanley.chu@mediatek.com>
> 
> I am sorry, I did not ack this patch.
> Could you please fix the tag?
> 
> Actually I acked another patch : )
> "ufs: introduce a callback to get info of command completion"
> 
> Please see
> https://patchwork.kernel.org/patch/11640901/
> 
> Thanks,
> Stanley Chu

Sure and I'm really sorry for bothering you.

Thanks.
Kiwoong Kim

