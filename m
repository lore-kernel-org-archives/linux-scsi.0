Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9B5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 06:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB75A61159
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 06:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239074AbhI1G0L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 02:26:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28085 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239050AbhI1GZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 02:25:49 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210928062408epoutp049669b185dfdb97a363fcea61d7c0d7cc~o6EU6qjsE1228812288epoutp04z
        for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2021 06:24:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210928062408epoutp049669b185dfdb97a363fcea61d7c0d7cc~o6EU6qjsE1228812288epoutp04z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632810248;
        bh=xeRq6f7aZZm1jUyxPNSRDZLM8XpZhSnU5SSvumzsHTA=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=MYZPm/ezVLuqENk9oYlkNApdMHDsVjqRRctg7BayB4OZpVQZvE/4jn1joRvmCS9x8
         TJi2rOI1acW/BtbP7XYAAQkiNydvhkp6Gmmi6VXBZpWBMTUCvneFL2bNxDP8LOVK0W
         0fkiS4Fxn35hkv2bAdTfEC7aY7O8Ml2rZor+g4Jw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210928062408epcas5p3f95c3471bc20de5cc86c0a37b3448395~o6EUC3pda0623806238epcas5p3D;
        Tue, 28 Sep 2021 06:24:08 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HJTwj5y6Mz4x9Pv; Tue, 28 Sep
        2021 06:23:49 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C1.E4.59762.FE4B2516; Tue, 28 Sep 2021 15:23:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20210928061619epcas5p1c6dbb21eed928b95c31ba27d0940e049~o59fv6Bh00284802848epcas5p1H;
        Tue, 28 Sep 2021 06:16:19 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210928061619epsmtrp17c2a21e8adbbe72c1fc28468b4f60007~o59fx08Nh2204022040epsmtrp1t;
        Tue, 28 Sep 2021 06:16:19 +0000 (GMT)
X-AuditID: b6c32a49-10fff7000000e972-88-6152b4ef4896
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.B1.09091.333B2516; Tue, 28 Sep 2021 15:16:19 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210928061617epsmtip1e42469523fccafecd39d509ec12de6c9~o59dewFYc2832328323epsmtip1p;
        Tue, 28 Sep 2021 06:16:16 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Vinod Koul'" <vkoul@kernel.org>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        <linux-phy@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        "'Chanho Park'" <chanho61.park@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>
In-Reply-To: <20210924132658.109814-2-krzysztof.kozlowski@canonical.com>
Subject: RE: [PATCH 2/2] scsi: ufs: exynos: unify naming
Date:   Tue, 28 Sep 2021 11:46:15 +0530
Message-ID: <001a01d7b430$5a0cd7e0$0e2687a0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFtLCv5cHlar/5GPmzeVUgTJn39qgHxE3ZwAhOAiEusbeOaEA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJsWRmVeSWpSXmKPExsWy7bCmpu77LUGJBt1btC1e/rzKZnF5v7bF
        ohvbmCxu/GpjtbjwtIfNYuPbH0wWmx5fY7W4vGsOm8WEVd9YLGac38dk0X19B5vF2iN32S2W
        H//HZLHzzglmBz6PWQ29bB6bVnWyeUxYdIDRY/OSeo+PT2+xePRtWcXocfzGdiaPz5vkPNoP
        dDMFcEZl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA
        3a6kUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAy
        BSpMyM6Yu3Y2S8EqwYp5t7tZGhhv8XUxcnJICJhIbO7Yzt7FyMUhJLCbUWL5ni2MEM4nRokD
        964zQTjfGCVmTGhmgmnpP3WVFSKxl1Hi4oQbbCAJIYGXjBKnbwuA2GwCuhI7FreBxUUE7rNI
        XL0mDWJzCnhIdLR8ZO5i5OAQFrCQOPqdFSTMIqAqcXbxX2YQm1fAUuL9owusELagxMmZT1hA
        bGYBeYntb+cwQ9ygIPHz6TJWiPFOEuennmeCqBGXeHn0CNg7EgI3OCSm3ZjPCNHgInH563Q2
        CFtY4tXxLewQtpTEy/42dpB7JASyJXp2GUOEaySWzjvGAmHbSxy4MocFpIRZQFNi/S59iLCs
        xNRT66DW8kn0/n4CDR5eiR3zYGxVieZ3V6HGSEtM7O5mhbA9JDZv62WewKg4C8mXs5B8OQvJ
        N7MQNi9gZFnFKJlaUJybnlpsWmCYl1oOj+7k/NxNjOCEreW5g/Hugw96hxiZOBgPMUpwMCuJ
        8Aaz+CcK8aYkVlalFuXHF5XmpBYfYjQFBv1EZinR5HxgzsgriTc0sTQwMTMzM7E0NjNUEuf9
        +NoyUUggPbEkNTs1tSC1CKaPiYNTqoGpkf9ejf4rxQliH4NbZOb91S1uzWY51lPQ1WCvpXRy
        qWBq0suVJStu/Hvp8/1l3erfdh1ZTpNOdbcsdz054a3TIo2t3xmdoh7/Vdh58dTHqWsnyNmI
        vVBaz2HlLn/bPnydAYfB8a2OVpNYb9rHbQrwue683vLoBeUZxxyrqk7/uVudc9euwkO0dR2z
        wKczh9Ummszv6TJ55/mUTeaCYEn73eM20156S3LfntgzX4GBTzfgd2dExFXXw2f+zTaNuih4
        s6P1lNX0D5KyX/5NX/o4aH/p+Ro+4QMGdmH3nmfs2xQYdWWNzPb7Ogbtk/50CNYn3g7559gw
        yejw+0S7nuuPqx6W7b608/apBdaXuGc0KrEUZyQaajEXFScCAH+Emp5hBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWy7bCSnK7x5qBEgz93ZSxe/rzKZnF5v7bF
        ohvbmCxu/GpjtbjwtIfNYuPbH0wWmx5fY7W4vGsOm8WEVd9YLGac38dk0X19B5vF2iN32S2W
        H//HZLHzzglmBz6PWQ29bB6bVnWyeUxYdIDRY/OSeo+PT2+xePRtWcXocfzGdiaPz5vkPNoP
        dDMFcEZx2aSk5mSWpRbp2yVwZcxdO5ulYJVgxbzb3SwNjLf4uhg5OSQETCT6T11l7WLk4hAS
        2M0o0b/1GSNEQlri+sYJ7BC2sMTKf8/ZIYqeM0r0LmxmBUmwCehK7FjcxgZiiwi8ZJGY+0oB
        ougqo8SEjl9gkzgFPCQ6Wj4ydzFycAgLWEgc/Q7WyyKgKnF28V9mEJtXwFLi/aMLrBC2oMTJ
        mU9YQMqZBfQk2jaCTWEWkJfY/nYOM8Q9ChI/ny5jhVjrJHF+6nkmiBpxiZdHj7BPYBSahWTS
        LIRJs5BMmoWkYwEjyypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjODo1NLcwbh91Qe9
        Q4xMHIyHGCU4mJVEeINZ/BOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpa
        kFoEk2Xi4JRqYLIx9e5+8L+NXytrhXBklfuF1BIJ1av2C6VvlyxLnRy6zz9JuCZXfeZNju/7
        UkwPKllJs7ktqutK9BeVj/PQ0+G5+FhnNXvesouzmKceS3zlYd53z/eJmsS6Wf7BfpPv2va/
        rOB92jJlfiIH1+fXlf+P9HxR38hQlpaZqm12b+nmfKXGvS73eBOjj0Twbi5TON/bHPQxtP/2
        eycrt0VWbTmB+X+zJe79VrynuHXDT6sn7Huj1T7dtVH3/TXfK2x5q9CyLTP2dto0W8XOWcO5
        yp6x9p98DU9e4fE+Ud3ZLHZymyPfF2u97Y7zZ467sc7IXyjPMf+jneplnXdRLzmN10880jlx
        a8kHQ+6aw7pKLMUZiYZazEXFiQC5+gWBPQMAAA==
X-CMS-MailID: 20210928061619epcas5p1c6dbb21eed928b95c31ba27d0940e049
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210924132744epcas5p4d08879e6109c6c036510a3bf0b6ff06b
References: <20210924132658.109814-1-krzysztof.kozlowski@canonical.com>
        <CGME20210924132744epcas5p4d08879e6109c6c036510a3bf0b6ff06b@epcas5p4.samsung.com>
        <20210924132658.109814-2-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Krzysztof,

>-----Original Message-----
>From: Krzysztof Kozlowski [mailto:krzysztof.kozlowski@canonical.com]
>Sent: Friday, September 24, 2021 6:57 PM
>To: Kishon Vijay Abraham I <kishon@ti.com>; Vinod Koul <vkoul@kernel.org>;
>Alim Akhtar <alim.akhtar@samsung.com>; Avri Altman <avri.altman@wdc.com>;
>James E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen
><martin.petersen@oracle.com>; Krzysztof Kozlowski
><krzysztof.kozlowski@canonical.com>; Marek Szyprowski
><m.szyprowski@samsung.com>; Jaehoon Chung <jh80.chung@samsung.com>;
>linux-phy@lists.infradead.org; linux-kernel@vger.kernel.org; linux-
>scsi@vger.kernel.org; Chanho Park <chanho61.park@samsung.com>; linux-arm-
>kernel@lists.infradead.org; linux-samsung-soc@vger.kernel.org
>Subject: [PATCH 2/2] scsi: ufs: exynos: unify naming
>
>We use everywhere "Samsung" and "Exynos", not the uppercase versions.
>
>Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

> drivers/scsi/ufs/Kconfig | 10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig index
>565e8aa6319d..af66cb3634a8 100644
>--- a/drivers/scsi/ufs/Kconfig
>+++ b/drivers/scsi/ufs/Kconfig
>@@ -165,14 +165,14 @@ config SCSI_UFS_BSG
> 	  If unsure, say N.
>
> config SCSI_UFS_EXYNOS
>-	tristate "EXYNOS specific hooks to UFS controller platform driver"
>+	tristate "Exynos specific hooks to UFS controller platform driver"
> 	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS ||
>COMPILE_TEST)
> 	help
>-	  This selects the EXYNOS specific additions to UFSHCD platform
driver.
>-	  UFS host on EXYNOS includes HCI and UNIPRO layer, and associates
>with
>-	  UFS-PHY driver.
>+	  This selects the Samsung Exynos SoC specific additions to UFSHCD
>+	  platform driver.  UFS host on Samsung Exynos SoC includes HCI and
>+	  UNIPRO layer, and associates with UFS-PHY driver.
>
>-	  Select this if you have UFS host controller on EXYNOS chipset.
>+	  Select this if you have UFS host controller on Samsung Exynos SoC.
> 	  If unsure, say N.
>
> config SCSI_UFS_CRYPTO
>--
>2.30.2


