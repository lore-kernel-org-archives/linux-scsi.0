Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08AFFC636CB
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 03:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8FFE60C3F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 03:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhGSDF2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Jul 2021 23:05:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57969 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbhGSDF0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jul 2021 23:05:26 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210719030226epoutp043d7277a8b66169b858cf89f6a49d908f~TEg8QHGi72151621516epoutp04T
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jul 2021 03:02:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210719030226epoutp043d7277a8b66169b858cf89f6a49d908f~TEg8QHGi72151621516epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626663746;
        bh=s/m1HwqS3slEK2Mv0h5w19UqOm7RZFcMMyC+F3XPOf8=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=A+DhJJcrYBLWvlLcgpg1Uqxmf/4ulLSG35N5a0GLgTUyy3E0aBuJ5dpAQV8vz5uI1
         4FDCNJHMtxS7ZGAJT155WhBXRR1c2Q+HaETE3BJqORNz88tDH3HYgWxpmS0/qeQEVR
         mldYHm90kmNN5NpQpJj3qpVhPHDVLVqWSFtnj2pU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210719030225epcas2p3a9f4e3acfb2fea005c47f4c02eff9c79~TEg7rcorv3072930729epcas2p32;
        Mon, 19 Jul 2021 03:02:25 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.191]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GSmq414Ryz4x9QD; Mon, 19 Jul
        2021 03:02:24 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.E2.09921.04BE4F06; Mon, 19 Jul 2021 12:02:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210719030223epcas2p3694f96730773d9a8864bf3d0de8b36e0~TEg5lE1G73072530725epcas2p3x;
        Mon, 19 Jul 2021 03:02:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210719030223epsmtrp1b0e159058bd0019d9ffca2b8887d0e87~TEg5kOh6e0951509515epsmtrp1_;
        Mon, 19 Jul 2021 03:02:23 +0000 (GMT)
X-AuditID: b6c32a45-f9dff700000026c1-ca-60f4eb40e9f6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.2D.08394.F3BE4F06; Mon, 19 Jul 2021 12:02:23 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210719030223epsmtip281564cf9bea1d78704a1b0e0faf97915~TEg5YgzNJ0045600456epsmtip2B;
        Mon, 19 Jul 2021 03:02:23 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>
Cc:     "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Alim Akhtar'" <alim.akhtar@gmail.com>, <robh@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <avri.altman@wdc.com>, <kwmad.kim@samsung.com>,
        <cang@codeaurora.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>
In-Reply-To: <yq1y2a3ysix.fsf@ca-mkp.ca.oracle.com>
Subject: RE: [RESEND PATCH v10 08/10] dt-bindings: ufs: Add bindings for
 Samsung ufs host
Date:   Mon, 19 Jul 2021 12:02:23 +0900
Message-ID: <003601d77c4a$7f219390$7d64bab0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLSJHm6eNEbPiUjxcYKuzqoT35S6wG4t7PjAWYpiDECouhoZQFFh/mAAgSS0dcCXaHtfKj4/wbA
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJsWRmVeSWpSXmKPExsWy7bCmua7D6y8JBjOusVgsvVVt8WDeNjaL
        lz+vsll8Wr+M1WL+kXOsFhee9rBZnD+/gd3i5pajLBabHl9jtbi8aw6bxYzz+5gsuq/vYLNY
        fvwfk8X/PTvYHfg8Lvf1MnnsnHWX3WPTqk42j81L6j0+Pr3F4tG3ZRWjx/Eb25k8Pm+S82g/
        0M0UwBmVY5ORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD
        dLuSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8DQsECvODG3uDQvXS85P9fK0MDA
        yBSoMiEn4+qcLcwF35grPm//zt7A2MjcxcjJISFgIjFx7iy2LkYuDiGBHYwS7+YfgnI+MUq8
        7mkFqxIS+MYo8euuJkzHj6NH2SGK9jJKHF53hwnCecEocfbuPVaQKjYBfYmXHdvAbBGBFInj
        D76AdTALfGGS+N2+ngUkwSlgLLHiyFuwImGBaIlV798ygdgsAqoS7WtawFbzClhKbJyzgQ3C
        FpQ4OfMJWC+zgLzE9rdzoJ5QkPj5dBnUsiiJf78PQtWISMzubGMGWSwh8IRD4sTLn4wQDS4S
        HSu3sUDYwhKvjm9hh7ClJF72t7FDNHQzSrQ++g+VWM0o0dnoA2HbS/yavgVoGwfQBk2J9bv0
        QUwJAWWJI7eg9vJJdBz+yw4R5pXoaBOCaFSXOLB9OtRWWYnuOZ9ZJzAqzULy2Swkn81C8sEs
        hF0LGFlWMYqlFhTnpqcWGxUYIsf2JkZwwtZy3cE4+e0HvUOMTByMhxglOJiVRHi/1XxMEOJN
        SaysSi3Kjy8qzUktPsRoCgzricxSosn5wJyRVxJvaGpkZmZgaWphamZkoSTOy8F+KEFIID2x
        JDU7NbUgtQimj4mDU6qBSU2pd63pzeq0hG41yTWrXPjezA85zOa/S33T0tc3xQJXCzIvrPhn
        KWWVcevJzxs+z2M+XT+xxOdZ1P/A6RNiNE22vJr4g9VxB/OCu89tnT/+vX5/YsikjTb64jWK
        tze0sHlEHu647V+4S/Tywf4oB31HxvKWXZ2zj0b87bv0cEpnSM2Fo34n3ry88NP715pHSwxE
        65fcT/H8erJwpf3PW5K320V0rh7cUj/h/6WT6k6Gf4Xr5S27eQ468/hrZfCH1TJ9+/ju8Ot5
        kckHwk3TDvzcZ3fCIfK+5xu2X5cWa0Uxiv71MdivHsV+7i/77/DImKWGEZnrty9gvpdRcDSJ
        R+Pur94TTpp8UzW+2vw0zlBiKc5INNRiLipOBAADBoW1YQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWy7bCSvK796y8JBqsW8FgsvVVt8WDeNjaL
        lz+vsll8Wr+M1WL+kXOsFhee9rBZnD+/gd3i5pajLBabHl9jtbi8aw6bxYzz+5gsuq/vYLNY
        fvwfk8X/PTvYHfg8Lvf1MnnsnHWX3WPTqk42j81L6j0+Pr3F4tG3ZRWjx/Eb25k8Pm+S82g/
        0M0UwBnFZZOSmpNZllqkb5fAlXF1zhbmgm/MFZ+3f2dvYGxk7mLk5JAQMJH4cfQoexcjF4eQ
        wG5GibnTPjNBJGQlnr3bwQ5hC0vcbznCCmILCTxjlFi6SQfEZhPQl3jZsQ0sLiKQIrFj/R+w
        emaBBmaJr990IYbOY5bY8O4YG0iCU8BYYsWRt2ANwgKREt8+7QaLswioSrSvaQG7iFfAUmLj
        nA1sELagxMmZT1i6GDmAhupJtG1khJgvL7H97RyoBxQkfj5dBnVDlMS/3wdZIGpEJGZ3tjFP
        YBSehWTSLIRJs5BMmoWkYwEjyypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOCo1dLc
        wbh91Qe9Q4xMHIyHGCU4mJVEeL/VfEwQ4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6
        YklqdmpqQWoRTJaJg1OqgYnBPmDahzfMp/tyDt1Q6pNbbGG1QmPZr72BSxoeqP47uUR2wWv9
        GaksbY9PSj+/9ThS1PGr7VfeGS+u3nQLNPyqbeh7p+Xvc8kNnRPflt73nbhniei0nY5WYSY6
        R3XMVcq+/hCuXfW3RtA2q/rEpBk3jIQz9fu7NevL5k+c86pi+4Enc4/smGfySzfM197653Qd
        GWf2aUxxdm+vNHFWM85/1bFeoWh9lavBjQUpjtxPegQNqrY73ZFcfbDe//61NQbpvrGt9fec
        by2xV3u98n56bvCtaZP3Ttw77d5kCZulC7qcs36E/Baami79Kvql4vUvzz/uXdAbUNvjUjkn
        +ODuV3su8tW4PrqqO2XV1A9JSizFGYmGWsxFxYkAN78KlUkDAAA=
X-CMS-MailID: 20210719030223epcas2p3694f96730773d9a8864bf3d0de8b36e0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200613030454epcas5p400f76485ddb34ce6293f0c8fa94332b8
References: <CGME20200613030454epcas5p400f76485ddb34ce6293f0c8fa94332b8@epcas5p4.samsung.com>
        <20200613024706.27975-1-alim.akhtar@samsung.com>
        <20200613024706.27975-9-alim.akhtar@samsung.com>
        <CAGOxZ500JD5xNWb0xFyEgaUH0qwQKm+kn1Ng71_1SM1wmJFxKg@mail.gmail.com>
        <CAJKOXPd6VMBaW7zBDXb7tXDHr3xwV2yZXxZtLJqNe3T69oUqsw@mail.gmail.com>
        <000001d7783f$ae446670$0acd3350$@samsung.com>
        <yq1y2a3ysix.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >> It has Rob's ack, so it can be taken directly via SCSI tree.
> 
> > Anyway, who will take this patch?
> 
> I can't remember the rationale behind only taking a subset of the exynos
> series through SCSI. However, it's been over a year. A resend is a
> prerequisite.

Okay.

Alim, please resend the patch without Rob's review tag.

> The binding should have been applied with the driver. If you want me
> to apply, resend it without my Reviewed-by tag.

Best Regards,
Chanho Park

