Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5DCC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 09:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B381E61267
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 09:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236010AbhG0JFt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 05:05:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26212 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbhG0JFt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 05:05:49 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210727090547epoutp021f957f6369c515b073c4b0ef4e853a44~VmoezSXjM0132501325epoutp021
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 09:05:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210727090547epoutp021f957f6369c515b073c4b0ef4e853a44~VmoezSXjM0132501325epoutp021
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627376748;
        bh=/WuErNYG8RX/vIdSPh/L49U9Uu6vOZvO5xzwJUZ9fHg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=bgvIWnldxLNzuX8ZBnBJqH1AtQ9gEVS/Lf0Y/prqZn1f+hvgZtRjO2AbXYcvsC+jG
         K7raXOBtPmyvF/ga3fr7dfghUMmbZUh07IS1CBqjiw0WWcS61tkcQjaWiSo5CBFL/R
         Kg2QRsN2UpBcqqwuEnysrwfGdvMu1e0MATcgu7Ac=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210727090545epcas2p413d5f13b35e7f771e5e6665a3cfbb122~Vmocj9sBN1819418194epcas2p4d;
        Tue, 27 Jul 2021 09:05:45 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.191]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GYrVc0j0vz4x9Q7; Tue, 27 Jul
        2021 09:05:44 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        D0.07.09921.76CCFF06; Tue, 27 Jul 2021 18:05:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210727090542epcas2p4f3287aa373f4438d3a5338123b565838~VmoZqXWZd1822618226epcas2p4a;
        Tue, 27 Jul 2021 09:05:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210727090542epsmtrp2f3a3154330fd85a79e48630e44020440~VmoZgZhSF1527215272epsmtrp2p;
        Tue, 27 Jul 2021 09:05:42 +0000 (GMT)
X-AuditID: b6c32a45-fb3ff700000026c1-9b-60ffcc678a0a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C0.FF.08394.56CCFF06; Tue, 27 Jul 2021 18:05:42 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210727090542epsmtip113d6dff106aec4d5940b4445f71380f1~VmoZSSCl60073000730epsmtip1T;
        Tue, 27 Jul 2021 09:05:42 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Bean Huo'" <huobean@gmail.com>,
        "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'jongmin jeong'" <jjmin.jeong@samsung.com>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>
In-Reply-To: <74e1269acaee8ddd97e9035543753ddbb9645579.camel@gmail.com>
Subject: RE: [PATCH v2 14/15] scsi: ufs: ufs-exynos: multi-host
 configuration for exynosauto
Date:   Tue, 27 Jul 2021 18:05:41 +0900
Message-ID: <002901d782c6$937ac0f0$ba7042d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJIF3zu3g+/Awptn47LJA2vs45sGwKSU/P/Ail7aZYCYLM/dKo8d64Q
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmqW76mf8JBvNeiFicfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC16djpbnJ6wiMliztkGJosn62cxWyy6sY3JYuU1C4vz5zewW9zc
        cpTFYsb5fUwW3dd3sFksP/6PyUHA4/IVb4/Lfb1MHjtn3WX32LxCy2PxnpdMHptWdbJ5TFh0
        gNHj49NbLB59W1YxenzeJOfRfqCbKYA7KscmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
        0NLCXEkhLzE31VbJxSdA1y0zB+gbJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6B
        oWGBXnFibnFpXrpecn6ulaGBgZEpUGVCTsa+fU9ZC7YyVyw7doC5gfESUxcjJ4eEgIlEb+8s
        xi5GLg4hgR2MEv2NfewQzidGiSn777CBVAkJfGOU2PZSAqZj4rxJUEV7GSXutdxmgXBeMEpM
        Ov8RbC6bgL7Ey45trCC2CEiif7EoiM0scIJZYvIpZhCbU8Bd4tbiu2AbhAXiJC4v38YIYrMI
        qEps+90DVsMrYCmxqr2RBcIWlDg58wkLxBxtiWULXzNDXKQg8fPpMqhdbhIH2nvZIWpEJGZ3
        tjGDHCch0Mwp0TT3DitEg4vEhMa50AAQlnh1fAs7hC0l8fndXjaIhm5GidZH/6ESqxklOht9
        IGx7iV/TtwAN4gDaoCmxfpc+iCkhoCxx5BbUbXwSHYf/skOEeSU62oQgGtUlDmyfzgJhy0p0
        z/nMOoFRaRaSz2Yh+WwWkg9mIexawMiyilEstaA4Nz212KjAEDmyNzGCU7qW6w7GyW8/6B1i
        ZOJgPMQowcGsJMLrsOJ3ghBvSmJlVWpRfnxRaU5q8SFGU2BYT2SWEk3OB2aVvJJ4Q1MjMzMD
        S1MLUzMjCyVxXo24rwlCAumJJanZqakFqUUwfUwcnFINTHNPqThuf5G9TeGCVEvWXvszFWon
        c27JCHFYPdRn57iU5/TxZ/6XP273Z3Gui5zvnlb36Zb5zkk3nOc+UFqlMrVLPX1umW7HA/6L
        j/808h5lrXZk7F/CxZr3Xr1Ter5Ec1lFaiLbWv+fbAvn5ns752qyX3lxfKGqbBGPjGmEu6qD
        USXfhFdnbipdb9HxX1fL3/sgOD6pcuFtP2/P92WJHadj/+de0c5/e+T3wjVe3u/q/TNsqrY9
        2bZs7sIi27u1JZ1fdNZ2RuZNvx4nL1ax2kHL4BF/xsXDXuduBrTKOtTErlSsl922uzT7WppL
        9QJXHY0tZ5Y0ui9sKC7c/Xe59Ym2G76xz06uZTN9U5KqxFKckWioxVxUnAgAJV3i+nIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHe885ns2FcHKj3qymzWZmqQl+eMUosduBvgSFkQnuZMdLXlqb
        6yaGhba8NouiVo5aeWlaydQ1K5Z3XVazzFJLs9pMi6ZdKJeYsQ3Bb7+H//P788DDxb2fET7c
        lIxMVpbBpIlIHmFoFQmDE5/OStaP23BkttaQaERjING4o49ElyYdOPpxr8IDFTVuRt0qLYau
        PcvBkPWeGkfafgOGbr9GyGKp5aCB+nYCXbaYMFT4xkiiys5/WBRF977aQfeWFGN0o3qIQ9dV
        BdE3H41jtF6XT9IqbROgv9sGCbqkXgfon3ohrWwqxHYujOVtOMCmpRxhZaEbJbzkqdJcQqrD
        jzWX1GA5wIwVAE8upMJhqeY8pwDwuN7UQwBfD+cQ7mAFHLUbOW7mw/e5bR7upVEAJz7+c9kk
        FQrHzxpcgYD6AmBXn5J0DjjVg8Oeh1bSrZzCoG30rYdT8aS2w8GbQ6ST+VQc7KitBU4mKDE0
        TBfhTvaiIqBOeYpw8yJovmJ1MU6thcUf8sAcV9z4irvv84MOW4WrX0Btg03KYo57RwCv5p/B
        VYCvnlelnlelnlelnqdcB4QOLGWl8vSkdHmYNCyDPRoiZ9LlioykkIRD6Xrg+njQGiO4r5sM
        aQEYF7QAyMVFAq+oqmmJt9cB5vgJVnYoXqZIY+UtYBmXEC3x6ikwx3tTSUwmm8qyUlY2l2Jc
        T58crO2TVviYjNZOiT97TsB10oG8oL3Ty383/G1uLM/z/3Oyq9L/sC8tLgv4sWygWBE6y9z1
        3TS15e7YguPPn+RO7VnaMVRq4JSVZ66qs38EqVsNxt6nQzGR12PtTNmEI/sDKcFM/OzFLwyM
        v7IHP7yCr1fOSFbf4oizAm3Vkl/D1rXdfiMbQiSZeCtxUNzQ+WI9E27/fFqr6tqXF5Nwwajg
        ozjmPQ0YpluVdS2lzb4zWqg32ft2tY/MjClKVoqrzV+3frPU8MyyrKxKi2nw1VlhpPTdS05+
        tWZ58JPZAE3M1eQ7Pj93J5gS+xNvjZ5rCYYPJgJn6y7+tW/ZH7GmQUTIk5mwIFwmZ/4DWZ2Q
        LmADAAA=
X-CMS-MailID: 20210727090542epcas2p4f3287aa373f4438d3a5338123b565838
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab@epcas2p3.samsung.com>
        <20210714071131.101204-15-chanho61.park@samsung.com>
        <74e1269acaee8ddd97e9035543753ddbb9645579.camel@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +       hci_writel(ufs, 0x1, HCI_MH_IID_IN_TASK_TAG);
>=20
> Here you meant the IID in the UPIU header will be set according to the
> Task_tag=5B7:5=5D value? and this will be done by your HW controller or S=
W
> driver?
>=20

You're right. We can manually set the value of TASK_TAG=5B7:5=5D by S/W but=
 when the bit is set, a VHID value will be automatically written by H/W con=
troller.

Best Regards,
Chanho Park

