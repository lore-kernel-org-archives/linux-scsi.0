Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1491C3404C
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 23:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 952F62068F
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 23:55:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qj26EhvJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgBRXzD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 18:55:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63448 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728091AbgBRXzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 18:55:02 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200218235459epoutp04a7cad7087a11831e1a13392d8c05abc0~0pF9-XaLW1247512475epoutp04T
        for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2020 23:54:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200218235459epoutp04a7cad7087a11831e1a13392d8c05abc0~0pF9-XaLW1247512475epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1582070099;
        bh=Xts5rQTqnsEBsvCjp+VC9YaGMfjVORCXjVaxhQthszk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=qj26EhvJ46G4yzU5rQwLveG9Qtl/UiYJ5tVtOOPeaK0++ikY7ndP8h3qZtW8625pY
         MEQFQ7kbibWWODZ1HkrC1I4VTwNfTVYhMqiJ8Z7yDsnkCAwAztjiY7/Uc1SlNrqZdh
         ySeKA4B4c5zfQgy8SoIh2IszWIiXCflSe8aqxlMM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200218235458epcas2p11d2b271ed1ea7913f1aaae1f133eb651~0pF9e6x8l1077910779epcas2p1N;
        Tue, 18 Feb 2020 23:54:58 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 48Md4w4jjXzMqYkh; Tue, 18 Feb
        2020 23:54:56 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.45.17960.F497C4E5; Wed, 19 Feb 2020 08:54:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200218235454epcas2p4f3d3753d64015ef5647c47bb022bbdd2~0pF5_Uw031481514815epcas2p4R;
        Tue, 18 Feb 2020 23:54:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200218235454epsmtrp1cd0fa726d44799cad4b3a0792aef6c55~0pF59jYqP1058010580epsmtrp1Z;
        Tue, 18 Feb 2020 23:54:54 +0000 (GMT)
X-AuditID: b6c32a48-10dff70000014628-4d-5e4c794fd59d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D3.E3.10238.E497C4E5; Wed, 19 Feb 2020 08:54:54 +0900 (KST)
Received: from KORCO002087 (unknown [180.236.228.110]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200218235453epsmtip132134006a3f2075469e0add84e10ca3a~0pF46Iuvv2845228452epsmtip1b;
        Tue, 18 Feb 2020 23:54:53 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Christoph Hellwig'" <hch@infradead.org>
Cc:     <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
In-Reply-To: <20200218233812.GB6827@infradead.org>
Subject: RE: [PATCH] ufs: fix a bug on printing PRDT
Date:   Wed, 19 Feb 2020 08:55:03 +0900
Message-ID: <0afb01d5e6b6$d81d8fb0$8858af10$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFIpCVqWN5WIUlOmd8TtLZF6NEvEAGeRXUrAhMGQnOpHpr1MA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmha5/pU+cwdyXyhanJyxislh0YxuT
        Rff1HWwWy4//Y3Jg8di8QstjwqIDjB4fn95i8fi8SS6AJSrHJiM1MSW1SCE1Lzk/JTMv3VbJ
        OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfzqYov7QkVSEj
        v7jEVim1ICWnwNCwQK84Mbe4NC9dLzk/18rQwMDIFKgyISfjxP1FjAUNLBWfr/YyNjBOZO5i
        5OSQEDCROPj/JZDNxSEksINR4vD/iWwQzidGiVOLrzFCON8YJc63TWaBaXk1/wwTRGIvo8T9
        hyugnNdALVsamUCq2AS0JaY93M0KYosI6EqcXfiCEcRmFgiTWHj9J9gkTgEjiVcvHrOD2MJA
        U/denQd2FIuAqsTWdVfYQGxeAUuJjsYWZghbUOLkzCcsEHPkJba/nQP1hILEz6fLoHY5Sfye
        tYAZokZEYnZnG9hzEgIn2CQ+tl4FOoIDyHGRuN3lBNErLPHq+BZ2CFtK4mV/G5RdL7FvagMr
        RG8Po8TTff8YIRLGErOetYPNYRbQlFi/Sx9ipLLEkVtQp/FJdBz+yw4R5pXoaBOCaFSW+DVp
        MtQQSYmZN++wT2BUmoXksVlIHpuF5IFZCLsWMLKsYhRLLSjOTU8tNiowQY7sTYzg1KjlsYPx
        wDmfQ4wCHIxKPLwHLnrHCbEmlhVX5h5ilOBgVhLh9Rb3ihPiTUmsrEotyo8vKs1JLT7EaAoM
        94nMUqLJ+cC0nVcSb2hqZGZmYGlqYWpmZKEkzruJ+2aMkEB6YklqdmpqQWoRTB8TB6dUA6Nz
        1LmwH2FFBhs1MgpsIm63hATe7XlapxQuP4Pl36mMpr2nGecd/h7yRlm2O+lk066oDpu980/r
        zFt6oC9/AfvGP9csytVmPoy/82OCmfp6rdSPHcHvHc+enWj9Y6/eyTxW5WU/0/fW/Zu44+VT
        w5rvmXvkebg0mUV5N5fz95i+er+s9JZ61A0lluKMREMt5qLiRAAs9XwyowMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWy7bCSnK5fpU+cwZOp+hanJyxislh0YxuT
        Rff1HWwWy4//Y3Jg8di8QstjwqIDjB4fn95i8fi8SS6AJYrLJiU1J7MstUjfLoEr48T9RYwF
        DSwVn6/2MjYwTmTuYuTkkBAwkXg1/wxTFyMXh5DAbkaJPX+3s0AkJCVO7HzOCGELS9xvOcIK
        UfSSUeLdjftMIAk2AW2JaQ93s4LYIgK6EmcXvgBrYBaIkLjVfZgFomEjo8TKhmdgRZwCRhKv
        XjxmB7GFgVbvvToP7AwWAVWJreuusIHYvAKWEh2NLcwQtqDEyZlPgAZxAA3Vk2jbCDVfXmL7
        2zlQHyhI/Hy6DOoGJ4nfsxYwQ9SISMzubGOewCg8C8mkWQiTZiGZNAtJxwJGllWMkqkFxbnp
        ucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMExoqW5g/HykvhDjAIcjEo8vBnnveOEWBPLiitzDzFK
        cDArifB6i3vFCfGmJFZWpRblxxeV5qQWH2KU5mBREud9mncsUkggPbEkNTs1tSC1CCbLxMEp
        1cBYenDiG4HJIns9Yy5F78j5FqZ8xKJYYI7eLrH951/bRfkuLcrc0+dUf/hc+eOswGXfWIX2
        NWV+tWYsYb6zZ01+uN1qeWuVwL/azGIB83pqHwrrbin5dnFj75S3AixqW6bNO7w9b8Y26cVz
        1B43JS22zdy/O2D+pZXLZMILHiyZVKpY47zs86U/SizFGYmGWsxFxYkAQfSsao0CAAA=
X-CMS-MailID: 20200218235454epcas2p4f3d3753d64015ef5647c47bb022bbdd2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200218233124epcas2p3888d2788d42af542cde915df4c4baf23
References: <CGME20200218233124epcas2p3888d2788d42af542cde915df4c4baf23@epcas2p3.samsung.com>
        <20200218233115.8185-1-kwmad.kim@samsung.com>
        <20200218233812.GB6827@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On Wed, Feb 19, 2020 at 08:31:15AM +0900, Kiwoong Kim wrote:
> > In some architectures, an unit of PRDTO and PRDTL in UFSHCI spec
> > assume bytes, not double word specified in the spec. W/o this patch,
> > when the driver executes this, kernel panic occurres because of
> > abnormal accesses.
> 
> This quirk doesn't have any driver actually setting it, so we need to
> remove it.

Exynos specific driver sets and is using it but the driver is not updated
yet. I'll do upstream it in the future.

