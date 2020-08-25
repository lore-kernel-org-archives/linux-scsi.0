Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C2DC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 02:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6C75204FD
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 02:00:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Alm5Ul59"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgHYCAI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 22:00:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50446 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgHYCAG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 22:00:06 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200825020003epoutp0227b53f4c835bf06cd2a4a81c7dd53e7c~uYE1j8fwj1522415224epoutp02g
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2020 02:00:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200825020003epoutp0227b53f4c835bf06cd2a4a81c7dd53e7c~uYE1j8fwj1522415224epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598320803;
        bh=NvIs8KONDNzfSsODfP1uigBsCg9u3FProIPut97+zbM=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=Alm5Ul59e26WEoElNxJ/zED6VrsA6AChNwNVPZVy19RVgvNLkmITTwn9Qo0tKZAQP
         qVaoc4eS58McK+t3qYKl2/vrf2kWzP7LuGUnyN3sP5hJ5oJfcNJibNksudbMf1Ff0B
         XbZYahX2EScetcAK0Lfs4OdKoaJQLna1L7uNwjIg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200825020002epcas2p1acd62406e53e1d67bd1ac77ce225d633~uYE012PP30893908939epcas2p12;
        Tue, 25 Aug 2020 02:00:02 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.187]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BbByS3yNtzMqYkp; Tue, 25 Aug
        2020 02:00:00 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.29.18874.D90744F5; Tue, 25 Aug 2020 10:59:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200825015956epcas2p3ff8035138b42aacd67a32c0eab6cecb6~uYEvV25Vr1882818828epcas2p3V;
        Tue, 25 Aug 2020 01:59:56 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200825015956epsmtrp14cd30aaa089c0f0c106b217bb586d6ce~uYEvUzcho0041100411epsmtrp1L;
        Tue, 25 Aug 2020 01:59:56 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-de-5f44709db2c7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        44.79.08303.C90744F5; Tue, 25 Aug 2020 10:59:56 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200825015956epsmtip1669ce32e97c95a227ef0fac323a9e5ea~uYEvGPGpu2235722357epsmtip1c;
        Tue, 25 Aug 2020 01:59:56 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <BY5PR04MB6705C3DCE1EC1BE863D7406DFC560@BY5PR04MB6705.namprd04.prod.outlook.com>
Subject: RE: [PATCH v2 0/2] skipping manual flush for write booster
Date:   Tue, 25 Aug 2020 10:59:55 +0900
Message-ID: <000401d67a83$6e52e880$4af8b980$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKhCLs6ykCWrfrZwe1Kp133aoJ8HQGSK/NMAqPgObWnkUSw0A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJsWRmVeSWpSXmKPExsWy7bCmue7cApd4g+MXuSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mi667Nxgt
        lv57y+LA63H5irfH5b5eJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5LzaD/QzRTAEZVjk5Ga
        mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0spJCWWJOKVAo
        ILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwNCwQK84Mbe4NC9dLzk/18rQwMDIFKgyISfj/KzD
        rAUP2Sq27j/J1MB4gLWLkZNDQsBEYtrdk0xdjFwcQgI7GCV29n1ghnA+MUps+3+DEcL5zCgx
        /fptFpiWSwtOQiV2MUq8vvkGqv8Fo8TEc1cYQarYBLQlpj3czQqSEBG4zyRxZOcDsHZOgViJ
        I693sYPYwgLOErMf3AW7hEVAVWL5tntsIDavgKVEX8tCVghbUOLkzCdgvcwC8hLb385hhjhD
        QeLn02VgNSICThKrTx5jhKgRkZjd2Qb2hITACQ6Je093Q93tIjHn8SqoZmGJV8e3sEPYUhIv
        +9ug7HqJfVMbWCGaexglnu77xwiRMJaY9awdyOYA2qApsX6XPogpIaAsceQW1G18Eh2H/7JD
        hHklOtqEIBqVJX5Nmgw1RFJi5s07UJs8JD72NbJPYFScheTLWUi+nIXkm1kIexcwsqxiFEst
        KM5NTy02KjBCju5NjOAEreW2g3HK2w96hxiZOBgPMUpwMCuJ8ApedI4X4k1JrKxKLcqPLyrN
        SS0+xGgKDPeJzFKiyfnAHJFXEm9oamRmZmBpamFqZmShJM5br3ghTkggPbEkNTs1tSC1CKaP
        iYNTqoGJ3f/zgu9fQys50/ybOdrO8H9+vCJQsyPzXm/t0W8LDz5I0dHXfNEg+qgs7lDnyV1f
        4mbcbQv+s/OmRsXCct//j8oYM07Li8UqVTuydshKmJ7VzV0gxvGsfV846yKntC2XquVynjNG
        x6sWvndfpjD71M2AwKRwa9eKqL+33x7KL+B9vsfvU4CinUUmq2Ff2/GXnO1Byt4yz0NXrVX6
        0MX+XOlj6tpTu04z5p6uZZTZPm2upOjTA++cAuY4uaodszzWEWtxQ/RbqJwFk8hWJpcl711/
        FwmqrNpzxC7s02xWwwix64/tH/AoFM7oSxc6alsc/fi/4elYWfuv29PcZjbOrHr0jXXhWufv
        kVxclkosxRmJhlrMRcWJADRgJ29ZBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWy7bCSnO6cApd4g/e9chYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKOD/rMGvBQ7aKrftPMjUwHmDtYuTkkBAwkbi04CQjiC0ksINRon1hLERcUuLE
        zueMELawxP2WI0D1XEA1zxglNm/tZgJJsAloS0x7uBssISLwlknizu3LTBBVtxklHq0/wgJS
        xSkQK3Hk9S52EFtYwFli9oO7YKtZBFQllm+7xwZi8wpYSvS1LGSFsAUlTs58AtbLDLSh92Er
        I4QtL7H97RxmiJMUJH4+XQZWLyLgJLH65DGoGhGJ2Z1tzBMYhWYhGTULyahZSEbNQtKygJFl
        FaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcERqae1g3LPqg94hRiYOxkOMEhzMSiK8
        ghed44V4UxIrq1KL8uOLSnNSiw8xSnOwKInzfp21ME5IID2xJDU7NbUgtQgmy8TBKdXANDnW
        TDrVUe7ZJGbeJBmnP31Ldes0CifztR/cHnT/lkxSTF2F25HYVwZmci7lvy/X1y+6HV47R2ld
        2y0Dpz3PpNeUvMkpLJL/fObkxoqlAUqT10wWcrj1MH6XnrFHRF8h66EtX2Y/XXRl2bqoJ5a8
        tQ9vrF+sNtlzR1+26MmTNr7z76w6fmfjicP/L9h1rzuX9ihuc76/26TsQxyfjXefFd+zvSnA
        jV2r5nvmpqytk01sJrgLG26fw+O3xJnhi7DqUUF3ro3nnn+Y8fabG8+ew71fa+Mevvm05Doj
        Z1a4TBfb/uhyDmmO4NnplvtXnixfPtmN3Tc+1E1Htvse83XZV/3Z/TdsHE+La/+Jc+Q5qsRS
        nJFoqMVcVJwIAHSaZHc3AwAA
X-CMS-MailID: 20200825015956epcas2p3ff8035138b42aacd67a32c0eab6cecb6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200824023811epcas2p4915326d30728acff0a721043706e1f3b
References: <CGME20200824023811epcas2p4915326d30728acff0a721043706e1f3b@epcas2p4.samsung.com>
        <cover.1598236010.git.kwmad.kim@samsung.com>
        <BY5PR04MB6705C3DCE1EC1BE863D7406DFC560@BY5PR04MB6705.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > v2 -> v1: enable the quirk in exynos
> >
> > We have two knobs to flush for write booster, i.e.
> > fWriteBoosterEn, fWriteBoosterBufferFlushEn.
> fWriteBoosterBufferFlushDuringHibernate and fWriteBoosterBufferFlushEn.
> 
> > However, many product makers uses only fWriteBoosterBufferFlushEn,
> Uses only fWriteBoosterBufferFlushDuringHibernate
> > because this can reportedly cover most scenarios and there have been
> > some reports that flush by fWriteBoosterEn could
> flush by fWriteBoosterBufferFlushEn could
> 
> > lead raise power consumption thanks to unexpected internal
> lead to a raise
> 
> > operations. So we need a way to enable or disable fWriteBoosterEn.
> operations. For those case, this quirk will allow to avoid manual flush. 

It was my mistake and I'll be more careful when writing messages.

Thanks.
Kiwoong Kim

