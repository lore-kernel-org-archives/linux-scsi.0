Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3F1C4741F
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 18:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BB91221E7
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 18:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uT3fprST"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgI2SPX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 14:15:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54121 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgI2SPW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 14:15:22 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200929181519epoutp0434a37e97b0b37b2c08b70bab8271dd3f~5U9WnoQLW2002720027epoutp049
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 18:15:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200929181519epoutp0434a37e97b0b37b2c08b70bab8271dd3f~5U9WnoQLW2002720027epoutp049
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601403319;
        bh=10/3mZvnT6czyDROBY36NFnpEJ7qJhK8MMPG5Yn9VQs=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=uT3fprSTyByRvA/WVZ/T/mnnZycao+gweF4OOnxaZ/RH3tsaiaEi4rlZdG5AwgHwq
         Pyg9OZCqUq7nXSwNcksvwJvfhmRlG5j2sk8KgfPVqx/fefCFCef3YX4ioIdsfpKL6B
         E469X7wuRDc1FAOXYufke9pxmtM2tgS11jTA6Cck=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200929181518epcas5p433e8f0a1dbbd105df6dae6a3ae20ae3f~5U9VcJFZc2633926339epcas5p4O;
        Tue, 29 Sep 2020 18:15:18 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        97.4A.09573.6B9737F5; Wed, 30 Sep 2020 03:15:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200929181517epcas5p2f87d7cd32fda98c1e85622350b9a438b~5U9UPTFbm1492014920epcas5p2B;
        Tue, 29 Sep 2020 18:15:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200929181517epsmtrp27bcf45382c6199086444fc38253abdcc~5U9UN6Lih1019110191epsmtrp2o;
        Tue, 29 Sep 2020 18:15:17 +0000 (GMT)
X-AuditID: b6c32a49-a67ff70000002565-bb-5f7379b60c41
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        01.EB.08745.4B9737F5; Wed, 30 Sep 2020 03:15:16 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200929181515epsmtip179251a9da5e38195affe0eb1c8996627~5U9SWDQ0Y0423504235epsmtip1m;
        Tue, 29 Sep 2020 18:15:14 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Bean Huo'" <huobean@gmail.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <bvanassche@acm.org>,
        <tomas.winkler@intel.com>, <cang@codeaurora.org>
Cc:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>
In-Reply-To: <20200916084017.14086-1-huobean@gmail.com>
Subject: RE: [PATCH v2] scsi: ufs-exynos: use
 devm_platform_ioremap_resource_byname()
Date:   Tue, 29 Sep 2020 23:45:13 +0530
Message-ID: <000b01d6968c$7ba0ec60$72e2c520$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLMFSyO1kZ5iiZoqB9dkEqiP/xkqwJk+P5vp4HGHPA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsWy7bCmhu62yuJ4g4cNvBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFnPONjBZLLqxjcni8q45bBbd13ewWSw//o/JYunWm4wW
        H3rqHHg9Ll/x9rjc18vksXPWXXaPxXteMnlMWHSA0aPl5H4Wj+/rO9g8Pj69xeLRt2UVo8fn
        TXIe7Qe6mQK4o7hsUlJzMstSi/TtErgylp67wVqwiK3izfTfjA2Ma1m7GDk5JARMJP5fWsHe
        xcjFISSwm1Fi78mvUM4nRomWjZNYIJzPjBL7z8xnh2l59OAKM0RiF6PEvO1rmEESQgIvGSVW
        7jcCsdkEdCV2LG5jAykSEehhktj44wALSIJZIFfi9u57QAkODk4Bc4l3V0tBwsIC4RK7Hzxm
        A7FZBFQlNl+Zxwhi8wpYSjxv/M8GYQtKnJz5BGqMvMT2t3OYIQ5SkPj5dBnYPyICVhJ/lz9h
        g6gRlzj6swfsUAmBNxwSF5ZdgPrAReLijF/QABCWeHV8C1RcSuLzu71gt0kIZEv07DKGCNdI
        LJ13jAXCtpc4cGUOC0gJs4CmxPpd+hCr+CR6fz9hgujklehoE4KoVpVofncVqlNaYmJ3N9RS
        D4m7DztZJzAqzkLy2Cwkj81C8sAshGULGFlWMUqmFhTnpqcWmxYY5qWW6xUn5haX5qXrJefn
        bmIEJz4tzx2Mdx980DvEyMTBeIhRgoNZSYTXN6cgXog3JbGyKrUoP76oNCe1+BCjNAeLkjiv
        0o8zcUIC6YklqdmpqQWpRTBZJg5OqQam/ArBd7s+3OeNW2o7OzMrKuOHrV13t+7OqKn+F/xv
        rP/0SGL3fXnz+uLP3v6inMmHjjhd3blW9Xc5s6sZ8289l7xVpqcfHCq6u+iq5x/H30ynzm03
        3mTWpbPv71JeNkbrRSdmPtLa16985qDaJbvdEyt5Kzjqbkiv5l6k9ugqz9sDh54+2c/QVWfN
        zbC9y2qGcE2AebXNPtHaJXPm2Lgcn7pMLk294ZDklq6tJWxsglk5KpuT/81vFvtUdtnkpuV0
        n+nG8ZOOhP09NvfJzO8Stcc1PnIblHBY31zo+U44dOGb0sxpL0LlDty9wpPg+m9v27SQmww3
        +0Js9PhDjq18XVvM1RDP6B4V+W9ykkKMEktxRqKhFnNRcSIA4t3QqesDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWy7bCSnO6WyuJ4g5aF5hYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFnPONjBZLLqxjcni8q45bBbd13ewWSw//o/JYunWm4wW
        H3rqHHg9Ll/x9rjc18vksXPWXXaPxXteMnlMWHSA0aPl5H4Wj+/rO9g8Pj69xeLRt2UVo8fn
        TXIe7Qe6mQK4o7hsUlJzMstSi/TtErgylp67wVqwiK3izfTfjA2Ma1m7GDk5JARMJB49uMLc
        xcjFISSwg1Fi299XUAlpiesbJ7BD2MISK/89Z4coes4oseTAc0aQBJuArsSOxW1sIAkRgWlM
        EnuWHWEGSTAL5Etc3fWGBaKjg1Fiy/7DQB0cHJwC5hLvrpaC1AgLhEr0Hd4Gto1FQFVi85V5
        YEN5BSwlnjf+Z4OwBSVOznzCAtLKLKAn0baREWK8vMT2t3OYIY5TkPj5dBnYGBEBK4m/y5+w
        QdSISxz92cM8gVF4FpJJsxAmzUIyaRaSjgWMLKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS
        83M3MYIjWEtrB+OeVR/0DjEycTAeYpTgYFYS4fXNKYgX4k1JrKxKLcqPLyrNSS0+xCjNwaIk
        zvt11sI4IYH0xJLU7NTUgtQimCwTB6dUA5O4bAqLUHqmxsKvxukL/+6pcNt24oXxFpdnfyUO
        i8vpTbLtvMj7yVCJ7dzLtrfT1xd72mca+hXOf5na8GiJ7gsZ+S2ZKmc5ru9wvp4w9fD2LJGO
        +1+csk0DPfbqaERzM75jC/wmlq4XqsE3w5K/uJu3zUrPt+P5lh6JUPW/jwob317i9Dha9etE
        ZdB/lTO/3d0fMuW3LZh79MryS9safx/4/ars7unas/OZKzo1fij+L+k8/+uxIjvTtwMVBlM7
        7jbn2+2cVuhSpB5XKRnOkLJeNyW0YOn/JGm+R3oNNsE7c5yutnEJP5mWIO9gffzn6ai1W7RO
        iGo9s9vpcP6o6e9Ds90/xTReklyzznSxtBJLcUaioRZzUXEiAKwbvOpPAwAA
X-CMS-MailID: 20200929181517epcas5p2f87d7cd32fda98c1e85622350b9a438b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200916084036epcas5p3420a185827331c7dd4494f2adb115ead
References: <CGME20200916084036epcas5p3420a185827331c7dd4494f2adb115ead@epcas5p3.samsung.com>
        <20200916084017.14086-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

> -----Original Message-----
> From: Bean Huo <huobean@gmail.com>
> Sent: 16 September 2020 14:10
> To: alim.akhtar@samsung.com; avri.altman@wdc.com;
> asutoshd@codeaurora.org; jejb@linux.ibm.com;
> martin.petersen@oracle.com; stanley.chu@mediatek.com;
> beanhuo@micron.com; bvanassche@acm.org; tomas.winkler@intel.com;
> cang@codeaurora.org
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH v2] scsi: ufs-exynos: use
> devm_platform_ioremap_resource_byname()
> 
> From: Bean Huo <beanhuo@micron.com>
> 
> Use devm_platform_ioremap_resource_byname() to simplify the code.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
Thanks! 
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>

> 
> v1-v2: change the patch commit subject
> 

