Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBDBC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 05:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81D68613C8
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 05:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243941AbhI2FTk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 01:19:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57120 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbhI2FTj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 01:19:39 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210929051757epoutp04e913b2f9f3bd0339cc28e0da28950835~pMz0emJfk2971929719epoutp04Y
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 05:17:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210929051757epoutp04e913b2f9f3bd0339cc28e0da28950835~pMz0emJfk2971929719epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632892677;
        bh=4J6maIoHhSgInBDX5Iw2H2ms+rUVIKptXejnrjbWbjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJezOXqgf+cAqXHBEfX6Kma0JcFKGBnrGwD2vfIAyPOyDTsosXkwLdDdWlcJO0dAB
         tcoLwtYxqMbYUIk91oKyelKbmB+IUjQUTuzDXc8IZJhVMUDkCKUByOl9CxxfdZEO9W
         TbfRICLbHUNx7UEfvtI2BPO7CDOa1y8Z2s3QP6YE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210929051756epcas2p1645dbd76df531ea28e147ad756ef2598~pMzzuhDpn1055610556epcas2p1I;
        Wed, 29 Sep 2021 05:17:56 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.99]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HK4Q36Cs2z4x9Q9; Wed, 29 Sep
        2021 05:17:47 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9E.81.09816.AF6F3516; Wed, 29 Sep 2021 14:17:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210929051745epcas2p1024eb171d57dca361d2d3d522683770d~pMzpRrQrZ1396313963epcas2p1K;
        Wed, 29 Sep 2021 05:17:45 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210929051745epsmtrp1847c0626de20926b05028373bde1d352~pMzpQ4QJA0664106641epsmtrp1-;
        Wed, 29 Sep 2021 05:17:45 +0000 (GMT)
X-AuditID: b6c32a46-63bff70000002658-5f-6153f6fa7689
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        81.C3.08750.9F6F3516; Wed, 29 Sep 2021 14:17:45 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210929051745epsmtip1dfc3930287091ea25abd396dec9e8bfd~pMzpD43_w2476124761epsmtip1G;
        Wed, 29 Sep 2021 05:17:45 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     adrian.hunter@intel.com
Cc:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        avri.altman@wdc.com, bvanassche@acm.org, cang@codeaurora.org,
        huobean@gmail.com, jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        liwei213@huawei.com, manivannan.sadhasivam@linaro.org,
        martin.petersen@oracle.com, Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [PATCH V5 1/3] scsi: ufs: Fix error handler clear ua deadlock
Date:   Wed, 29 Sep 2021 14:01:31 +0900
Message-Id: <1632891691-17109-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20210922093842.18025-2-adrian.hunter@intel.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKJsWRmVeSWpSXmKPExsWy7bCmqe6vb8GJBlO/yVqcfLKGzeLBvG1s
        FnvbTrBbvPx5lc1i2oefzBaf1i9jtZhztoHJYtGNbUwWN7ccZbHovr6DzeLvnCOMFndbOlkt
        lh//x+TA63H5irfH5b5eJo+ds+6ye7QcecvqsXjPSyaPO9f2sHlMWHSA0ePj01ssHn1bVjF6
        fN4k59F+oJspgDsq2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
        J0DXLTMH6AMlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToF5gV5xYm5xaV66Xl5q
        iZWhgYGRKVBhQnbGy3WrmQuus1SsujifpYHxNnMXIyeHhICJxKszJ5lAbCGBHYwS7W0lXYxc
        QPYnRolzM88zQzifGSU6Py1khel4OnEtVGIXo8TZGUeZIJwfjBLXZ3SxgVSxCWhKPL05FWyu
        iIC0RNvth+wgNrPAViaJ4zcquxg5OIQFvCQO7+YECbMIqErc2PQC7CReAVeJB9NuskMsk5O4
        ea4TLM4pYCtx++8NNpBdEgILOSSOnJjBBFHkInF9zTo2CFtY4tXxLVDNUhIv+9ug7HqJfVMb
        WCGaexglnu77xwiRMJaY9aydEeQgZqCj1+/SBzElBJQljtxigTiZT6Lj8F92iDCvREebEESj
        ssSvSZOhhkhKzLx5B6rEQ6L/vzAkRCYwSqz+8oZ9AqPcLIT5CxgZVzGKpRYU56anFhsVGMHj
        Kzk/dxMjOH1que1gnPL2g94hRiYOxkOMEhzMSiK8P8SDE4V4UxIrq1KL8uOLSnNSiw8xmgLD
        biKzlGhyPjCB55XEG5pYGpiYmRmaG5kamCuJ887955QoJJCeWJKanZpakFoE08fEwSnVwMR2
        Z1+mmF250WMlrXvzyzI6VLf4pwQ/mWyQXRu7PseOa4JvxuanLGf6U04qPU1ceiWUoeTVVY1N
        L3XeG+04vznn2r7Va//8/v/w9w1t98fOy65mP/Nz2cwstfianM2PPzbXD4XK/DtZuOpZXVtN
        t8Wv+TcXzv2woIb/zMpNYvkZrYLb/+7Zp7hnf/Z9q1+RbvdkZive9JT/a7C/qEC77+5it9m9
        jp+MPK/V7ns6afXZb6GrnzlNiW6bu2e3F0OH6saLDrwpDnNZpW+YpAXE672P/jZRjmNjff3i
        k12/K57uuXT39SIFJov/WYVzKhO5dlx4yD+9RnTbltuafm3f1Tq+reXnU5+Xd+nqpCXPjqaq
        KLEUZyQaajEXFScCAJ1vl64oBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSnO7Pb8GJBssWiFucfLKGzeLBvG1s
        FnvbTrBbvPx5lc1i2oefzBaf1i9jtZhztoHJYtGNbUwWN7ccZbHovr6DzeLvnCOMFndbOlkt
        lh//x+TA63H5irfH5b5eJo+ds+6ye7QcecvqsXjPSyaPO9f2sHlMWHSA0ePj01ssHn1bVjF6
        fN4k59F+oJspgDuKyyYlNSezLLVI3y6BK+PlutXMBddZKlZdnM/SwHibuYuRk0NCwETi6cS1
        YLaQwA5GiaOPlCDikhIndj5nhLCFJe63HGHtYuQCqvnGKDH53UIWkASbgKbE05tTmUBsEQFp
        ibbbD9lBipgFDjNJvFrxDGgqB4ewgJfE4d2cIDUsAqoSNza9AFvGK+Aq8WDaTXaIBXISN891
        gsU5BWwlbv+9wQZxkI3E9SsvmCcw8i1gZFjFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7
        iREc6lpaOxj3rPqgd4iRiYPxEKMEB7OSCO8P8eBEId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwX
        uk7GCwmkJ5akZqemFqQWwWSZODilGpiMr9opHBCXl8+clCeW0X7v1H3NvIZ1XCcPFrm/U1HM
        zpJ05Tu7TvNFxf5432/TuWUs9rxJPlvR8crsybUrDDM3m2/c/UmgaOPT2rn7zZl5Nptcb4/4
        dLTnnbv4DY2X05o39rxcfeZg7Lxuhn/hW//sPhw4O/nHlOtil/5vSQj7/uhV/I/KTIVHqvNl
        57f773nL9JvL8HfCfQ3PQIPD7XNP3O5IMCwL35Jl98ux+ne1utfGssPaSf37RHh3G5isKxez
        /m0nctXngPT7SjmuEmH9lzM3uE+XWmbRpeQfv/2hiUHG8fWxHMmWkUcd9qsoyBsJcXVH2coZ
        6X0v2mH7feue9ROZzZkya9yNN774I6HEUpyRaKjFXFScCAAhA+0u5AIAAA==
X-CMS-MailID: 20210929051745epcas2p1024eb171d57dca361d2d3d522683770d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210929051745epcas2p1024eb171d57dca361d2d3d522683770d
References: <20210922093842.18025-2-adrian.hunter@intel.com>
        <CGME20210929051745epcas2p1024eb171d57dca361d2d3d522683770d@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

(I post this again because this isn't attached to the mail thread)

UFSHCI specifies Data Byte Count (DBC) like this:
A '0' based value that indicates the length, in bytes, of the data
block. A maximum of length of 256KB may exist for any entry. Bits 1:0 of this
field shall be 11b to indicate Dword granularity.
A value of '3' indicates 4 bytes, '7' indicates 8 bytes, etc.

That means the size value should be aligned with 4. And as I know it's 18.
Yes, its buffer is enough but if a host doesn't access memory with four-byte
alignment, it could cause problems.

Thanks.
Kiwoong Kim
