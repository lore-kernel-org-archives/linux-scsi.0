Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4923CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 06:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A5F56113D
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 06:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhI0G6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 02:58:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28122 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbhI0G6h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 02:58:37 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210927065658epoutp0218c55bf9b17ff694f50edf0d84fd71ad~om3smmqr50938809388epoutp02K
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 06:56:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210927065658epoutp0218c55bf9b17ff694f50edf0d84fd71ad~om3smmqr50938809388epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632725818;
        bh=nJ1yRga9rmuxr1zqsEw3rhf17tKIs0mB6ObqXQ/Js+A=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=uroBy12MgCN/ffKmO5tZLA+W+cV5OkNuvlx0+0Bs8yz72lJT48Ehf3tS7zQSVSN7e
         bEFrI0GESfo6m4lH2hCuEDmFCtu5cA8P9h7x+FlctsJztNLuRxzuHoC3cNPYzTcSe6
         Pu4bmIEPn0gJhghRj4HYf6AJSemHJjHIoXUKmAE0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210927065657epcas2p483b9a195799865500a9941d049c7f16f~om3rrKeN41336013360epcas2p4y;
        Mon, 27 Sep 2021 06:56:57 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.190]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HHtjM6HnFz4x9QX; Mon, 27 Sep
        2021 06:56:55 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        78.4B.09816.63B61516; Mon, 27 Sep 2021 15:56:54 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210927065653epcas2p3f771a9d586cc79d58fe74a2270c98718~om3ojzamN2900529005epcas2p3V;
        Mon, 27 Sep 2021 06:56:53 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210927065653epsmtrp2a4d7d62290ddc8e0de11d7e445578f9b~om3oi4EtU1257212572epsmtrp2S;
        Mon, 27 Sep 2021 06:56:53 +0000 (GMT)
X-AuditID: b6c32a46-63bff70000002658-e6-61516b364a0b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2D.85.09091.53B61516; Mon, 27 Sep 2021 15:56:53 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210927065653epsmtip1c6f054e45edfd0b695bc7b787066d898~om3oT0s4a2029320293epsmtip1K;
        Mon, 27 Sep 2021 06:56:53 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Inki Dae'" <inki.dae@samsung.com>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>,
        <cpgs@samsung.com>
Cc:     "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>
In-Reply-To: <1891546521.01632720301546.JavaMail.epsvc@epcpadp3>
Subject: RE: [PATCH v3 15/17] scsi: ufs: ufs-exynos: multi-host
 configuration for exynosauto
Date:   Mon, 27 Sep 2021 15:56:53 +0900
Message-ID: <000a01d7b36c$da9fe1f0$8fdfa5d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQFQSmJ1AsClfEwByx7UBKngUf3Q
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTVxjeufdyKcTOS2HbSYna1SjQSaGMlouDzSnp7qgO0CVbDKG7KTd8
        WNqut102tmQlRlYGuPqxFUpxgktBJlYY6ZgOVmAERSNjaFRm2HTgKKwLFpygEdbSmvHved/n
        ec77cc7hoDwPzueUaAyMXkOrhXgk5hpISEuUHcijk8frt5GXJs/g5B8nXDjpWbqOk313qjDy
        q7kllPQ5HWGkpz+BrPlhF3nZ0oyQR3+3YOSk04aSzTddCNnhXUTIW12DGFk30ouQ1Te6cbJl
        aBnZEUWNXVNQNlMtTo0drkWo71pF1KkfPQjV2VaFU5ZmN6AeOs04dX9qHKMOd7UBar5zI/WZ
        uxrJXbdfnVHM0IWMXsBoVNrCEk1RplCxT7lLKZUlSxIl6WSaUKChy5hMYdbu3ER5ido/l1Dw
        Aa02+lO5NMsKk17N0GuNBkZQrGUNmUJGV6jWSSQ6MUuXsUZNkVilLdsuSU5OkfqV76mLracK
        dBb8w3PVIhNYxD4HERxIpMLGEbMfR3J4RDeAK6ZaEAx8AH4z/UWI+RfAsxMHkaeWrtn2ENED
        oLtvMDwYTANot/eGB1Q4kQQ9ZldYgIghziOwd25xNUCJL1Foa69DA6oIYgdsGHevnhtNFEBf
        4x0QwBixBf46UeHPczhcIh3eO6EPpLlEFLxUP7naOUq8BB1Ns2iwJQFcmnKEBXAMIYejD0aR
        oCYGNlRVooG6kKiOgNPdp8ODhixYd643ZI6GM0NdoTwfzv/Tg4cMAB66uxIivgWwqmJ3EL8G
        H1m7wgLNoUQCdJ5PCkBIbIY/j4e2yoWmjsfhwR6eheaBJ+FBCReaK3lBSRx0f2/FLGCzbc1k
        tjWT2dZMYPu/1kmAtYHnGR1bVsSwKbqUtZfdCVbfvEjeDY5758T9AOGAfgA5qDCGuw/LoXnc
        QvqjckavVeqNaobtB1L/qo+g/OdUWv+n0RiUEmmKTJacLiWlshRS+AK3cXknzSOKaANzgGF0
        jP6pD+FE8E3I2DpYKFfI/6qZuv/MtfxZ6qhd9cuFXLe4CXv5ED9LvkXtjW/gyG+7HjiudiwM
        T7zvXTh9o3xg8kzTu5dvt79iH5KNzF9oy//trexS1af1Fe7e2JlHpk1vNkf7TLfAdUWsY6id
        GhUp2ey+ZQ+eFr+8/sW7o5Zjb1+cmM7ZdLJb8PWVg1zFttczNc6ajCM5U8OtW+uNBYMq69m8
        HkeUfk/fG7HKT0Rb91Rf5DGpbEfeHH9DapqY2fAkLtqVKpisVJuvdCjtyJ85H6fSO70/7TXG
        M8bS0pnI4fXRCS1pK/r2bBCj3l6+/+rCO/H5G1sSH7da48TNe2+uHLtX38g89FX9XSrE2GJa
        IkL1LP0fEspq33wEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsWy7bCSnK5pdmCiQcdWLYuTT9awWTyYt43N
        4uXPq2wWBx92slhM+/CT2eLT+mWsFi8PaVr07HS2OD1hEZPFpPsTWCyerJ/FbLHoxjYmi41v
        fzBZ3NxylMVixvl9TBbd13ewWSw//o/JQdDj8hVvj1kNvWwel/t6mTw2r9DyWLznJZPHplWd
        bB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAJ4rLJiU1J7MstUjfLoEro+nYfbaC
        fraKp+tOMTUwfmXpYuTkkBAwkdjyei2QzcUhJLCbUeL+mR5WiISsxLN3O9ghbGGJ+y1HWCGK
        njFKXJrRB5ZgE9CXeNmxDaxBRGAfk8Shl04gRcwCc5klVs7dzw7R8YtRov3XdCaQKk4BB4nZ
        tw6A2cICMRJb7+1gA7FZBFQlLt1rBIpzcPAKWEo8m1cEEuYVEJQ4OfMJ2KnMAtoST28+hbOX
        LXzNDHGdgsTPp8ugjnCTuPj1IhNEjYjE7M425gmMwrOQjJqFZNQsJKNmIWlZwMiyilEytaA4
        Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOOa1NHcwbl/1Qe8QIxMH4yFGCQ5mJRHeYBb/RCHe
        lMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYPG9vnLjm3/wk
        FxGpO5/bZ2xJkVEqrc1KjVRjeBuSqvvGqv/+kwe114prW83U3814nLTWxXjJdKNzBYu+f/ZN
        cX21teFqtv1hT1VPpV6TqkNhWaGHH1rNq7ikf6hS96be1cVFBjOnBnXmVHV/vbosoXzW0tQn
        79Zu6HAXKpkWs6nz3Lz0zpBfjpY8/2fycvJ8i0w9/+RCwNqFZofNPs1heZXmxyP56/rlvN8H
        DD8nJW9w/jbr9mbO5EW/V66a7WXz/reK+Mo/BvK3UrIjFkRFLtzv+1DVXUz8W+Jv4YiIyYeD
        9i/h8A43XfUtJrVxSdW2bXt6r+5SXbRswZt63k+2wlN8irlXT/ZRDZTqzvMTUWIpzkg01GIu
        Kk4EAOXgD5loAwAA
X-CMS-MailID: 20210927065653epcas2p3f771a9d586cc79d58fe74a2270c98718
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065524epcas2p18a720757ef3c4fc08d4bc8d16f9fe7fe
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065524epcas2p18a720757ef3c4fc08d4bc8d16f9fe7fe@epcas2p1.samsung.com>
        <20210917065436.145629-16-chanho61.park@samsung.com>
        <1891546521.01632720301546.JavaMail.epsvc@epcpadp3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +static int exynosauto_ufs_post_hce_enable(struct exynos_ufs *ufs) =7B
> > +	struct ufs_hba *hba =3D ufs->hba;
> > +
> > +	/* Enable Virtual Host =231 */
> > +	ufshcd_rmwl(hba, MHCTRL_EN_VH_MASK, MHCTRL_EN_VH(1), MHCTRL);
> > +	/* Default VH Transfer permissions */
> > +	hci_writel(ufs, 0x03FFE1FE, HCI_MH_ALLOWABLE_TRAN_OF_VH);
>=20
> How about using a defined macro instead of constant value, 0x03FFE1FE for
> code readability? And maybe 0x03FFE1FE to 0x3FFE1FE.

When I saw the value first time, I also thought it should be defined as mac=
ro but there are too many bits(26) to be described and I felt no one contro=
ls it from the default value. I'll try to use macro or at least documentati=
on by comment next patch.
Thanks.

Best Regards,
Chanho Park

