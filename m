Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD78C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 06:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F9356113D
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 06:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhI0Grx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 02:47:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16774 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbhI0Grw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 02:47:52 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210927064612epoutp034b29bf7414993aef6e8668c0637b6343~omuS-upDb1189011890epoutp03w
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 06:46:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210927064612epoutp034b29bf7414993aef6e8668c0637b6343~omuS-upDb1189011890epoutp03w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632725172;
        bh=ZmFvWkCk5PO+Ps5Z2y54RKRTY7nRjLNqwkjp11SlKKk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Di+KDVgwCdkmrXBJcXgjfTMS8WDWETKQq0okim2PXjz7XwaKJYsusJFUF+dqIb15u
         yQi/0xwfYe/fngWzFjK8lhVmHB5IVL7rbZJ+0C2w/gxvBWwcbOap08guvCMwPKlcfm
         fMn2zUuMmKjjLDb7VnzA5LNKmnxPDGgIhZbUzybM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210927064611epcas2p1169fbca0e40baa033eefc1682cbcfdbb~omuScuKDB2852728527epcas2p1W;
        Mon, 27 Sep 2021 06:46:11 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.187]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HHtSy1mycz4x9QM; Mon, 27 Sep
        2021 06:46:10 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        98.E7.09472.2B861516; Mon, 27 Sep 2021 15:46:10 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210927064609epcas2p3ca3d0cab330feb3b32b1909a5bcc7ea5~omuQb4c3_2612526125epcas2p3h;
        Mon, 27 Sep 2021 06:46:09 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210927064609epsmtrp1ade3da2fcce41981f2b3710c41a8dee4~omuQa18c91835418354epsmtrp1g;
        Mon, 27 Sep 2021 06:46:09 +0000 (GMT)
X-AuditID: b6c32a48-d5fff70000002500-c7-615168b22af0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.D6.08750.1B861516; Mon, 27 Sep 2021 15:46:09 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210927064609epsmtip1444bac6fe633e7700a072f23a98f0633~omuQKvblM1316913169epsmtip1V;
        Mon, 27 Sep 2021 06:46:09 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Inki Dae'" <inki.dae@samsung.com>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>
Cc:     "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <cpgs@samsung.com>
In-Reply-To: <878274034.81632720182984.JavaMail.epsvc@epcpadp4>
Subject: RE: [PATCH v3 03/17] scsi: ufs: ufs-exynos: change pclk available
 max value
Date:   Mon, 27 Sep 2021 15:46:09 +0900
Message-ID: <000001d7b36b$5a8817e0$0f9847a0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQFpqUVjAcLaBWECfhBmbKnh2naQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJsWRmVeSWpSXmKPExsWy7bCmhe6mjMBEg9VL2CxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWrw8pGnRs9PZ4vSERUwWk+5PYLF4sn4Ws8WiG9uYLDa+
        /cFkMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBOVY5ORmpiSWqSQmpecn5KZl26r5B0c7xxv
        amZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9JKSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYp
        tSAlp8DQsECvODG3uDQvXS85P9fK0MDAyBSoMiEnY8r10ILTLBV9v4+zNjBeZe5i5OSQEDCR
        6J65jr2LkYtDSGAHo8SH9lNQzidGiTePTjJDOJ8ZJRZfnMsI0/Lz3TSoxC5GifsvX7FBOC8Y
        Jd73zGIDqWIT0Jd42bGNFSQhIrCMSWJl7zcwh1mggVni3ZK1LCBVnAL2Ej+397KC2MICYRJr
        pi9kArFZBFQlTu16ATaJV8BSYtnem1C2oMTJmU/AepkFtCWWLXwN9YaCxM+ny8DmiAi4SXS9
        amWEqBGRmN3ZBnarhEAzp8SbnuVQT7hI9P6ZwgRhC0u8Or6FHcKWknjZ38YO0dDNKNH66D9U
        YjWjRGejD4RtL/Fr+hagbRxAGzQl1u/SBzElBJQljtxigajglWjY+Jsd4gY+iY7Df9khSngl
        OtqEIErUJQ5sn84ygVF5FpLPZiH5bBaSD2Yh7FrAyLKKUSy1oDg3PbXYqMAEObo3MYITvJbH
        DsbZbz/oHWJk4mA8xCjBwawkwhvM4p8oxJuSWFmVWpQfX1Sak1p8iNEUGNYTmaVEk/OBOSav
        JN7Q1MjMzMDS1MLUzMhCSZx37j+nRCGB9MSS1OzU1ILUIpg+Jg5OqQamOP4A93P1v/dzz76b
        UufSJGfkG9mpVP+Bc9fmf1L/F+7pjjBXuJqtsnaLjqXb7r9tnjWTL1yYdmi92qvN7/1PyU0O
        ub1aILjpjWc0Y9WbsCiXctNPIsGP5jI5px4+wyK801rhQgfnix0eErq7Ga5U6AomG33m+lm3
        pYc/pfqwkPzJK3LfOGd+282jlZR2Kkh98p0JEXYf3mvuq7xZbDpjfbTG9ZToacpbGLKuvjVc
        r77+VeE93g1rvjjcXyLOZKg27cedXf/t4+c3sQQ5d7xbdtLx9rUJ8znmf2leZv1id1bAl6vP
        I/b8Z8m8+iN8mnv4fQfdsMQn0mW5Iqd17fdO+jrn7EzHvcVt548FTGRzUGIpzkg01GIuKk4E
        APo+6JF5BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWy7bCSnO7GjMBEgylfhSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWrw8pGnRs9PZ4vSERUwWk+5PYLF4sn4Ws8WiG9uYLDa+
        /cFkMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlXF5Ux9rwVGWiu+z
        ohoYzzN3MXJySAiYSPx8Nw3I5uIQEtjBKHHh1moWiISsxLN3O9ghbGGJ+y1HWCGKnjFKNP/o
        ZQJJsAnoS7zs2AaWEBFYwSRxavJmFhCHWaCDWeL0hzNsEC0/GCV2r/zDBtLCKWAv8XN7LyuI
        LSwQInFm+RmwHSwCqhKndr0Aq+EVsJRYtvcmlC0ocXLmE7CbmAW0JZ7efApnL1v4GuoJBYmf
        T5eBzRQRcJPoetXKCFEjIjG7s415AqPwLCSjZiEZNQvJqFlIWhYwsqxilEwtKM5Nzy02LDDK
        Sy3XK07MLS7NS9dLzs/dxAiOdS2tHYx7Vn3QO8TIxMF4iFGCg1lJhDeYxT9RiDclsbIqtSg/
        vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBiazfezWOonfPOpvd2y7WPRU
        McrIbqn8giCF/llr/E1YHYRey5vc0i7iMZU7UHX2JufylH+9p7k2P7vjXy/uajPr9ty/E2rD
        JhpKsct7/bUrnrbQ+2V1kK3Ai7lLUg28+IyOPD/FecNeQqt2w4dvTX/bvsx/WvFRt9PQ7+KH
        7g9rK+fsijLb8Jw3QXrNr8rd6W+PyXA9Db+5a/ndezezHZd+3uh1YE+SSM1JRpMFDLNLdjcy
        FG3l/+h4idnQPDkv4/xZ/o77rpNPTNU9vNdXY/vn0xyqelfOuRWINFQe/Owswy89967Q6eAJ
        38xDbKesdP0V1ho6J9TSQX/X3doGwW9ZbBnWi9quPC+JYHyxKFuJpTgj0VCLuag4EQCaS+qe
        ZAMAAA==
X-CMS-MailID: 20210927064609epcas2p3ca3d0cab330feb3b32b1909a5bcc7ea5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065522epcas2p26f56b37c3f7505b9d0e34bc2162fdbbd
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065522epcas2p26f56b37c3f7505b9d0e34bc2162fdbbd@epcas2p2.samsung.com>
        <20210917065436.145629-4-chanho61.park@samsung.com>
        <878274034.81632720182984.JavaMail.epsvc@epcpadp4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >  =23define PCLK_AVAIL_MIN	70000000
> > -=23define PCLK_AVAIL_MAX	133000000
> > +=23define PCLK_AVAIL_MAX	167000000
> >
>=20
> I'm not sure but doesn't the maximum clock frequency depend on a given
> machine? Is it true for all machines using different SoC?

Regarding pclk(sclk_unipro)of the ufs, it can be defined by mux(MUX_CLK_FSY=
S2_UFS_EMBD).
It can be either 167MHz or 160MHz. And it can be defined by OSCCLK(26MHz) a=
s well. The value was up to 133Mhz in case of exynos7 but can be extended u=
p to 167MHz for later SoCs, AFAIK.

Best Regards,
Chanho Park

