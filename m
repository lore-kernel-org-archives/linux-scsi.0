Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9A3C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18DF22087C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:31:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jOVHY0Au"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbgIJCbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 22:31:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36185 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730870AbgIJC0D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 22:26:03 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200910022553epoutp04cc2e6f82dfdcc90807ae8f77191eee93~zSv9uGtBB2776027760epoutp04C
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2020 02:25:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200910022553epoutp04cc2e6f82dfdcc90807ae8f77191eee93~zSv9uGtBB2776027760epoutp04C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599704753;
        bh=Ud/VzAfX4crf3keXqhpq/GL9lD3v995f5NkpdOA5784=;
        h=From:To:Cc:Subject:Date:References:From;
        b=jOVHY0AusBHnHjQn54dNa1DwdmkNGTHe1jDih7Obou7bcHFv1Tu9GQ/OTS/l4BRcb
         l764GXtw1sM3kOINmA3cUlrCdhQPWz1PV3plPztQp9rz+L6mO+7/BofGSiNv1akXZs
         T8zLdJDq3MlS0qVyDQ38u5C5x2fIuc1c8nma6Lwo=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200910022552epcas5p41486f82589e10d4e6da0866160d1c29e~zSv83VYRN0668806688epcas5p4r;
        Thu, 10 Sep 2020 02:25:52 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D5.37.40333.0BE895F5; Thu, 10 Sep 2020 11:25:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200910022551epcas5p2f42a5d87a0e171d0d6ba9ab7f077af4b~zSv7tKag60641506415epcas5p2b;
        Thu, 10 Sep 2020 02:25:51 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200910022551epsmtrp2ef4ae7171b6b3317697404943b950b20~zSv7sijwK1619816198epsmtrp2Y;
        Thu, 10 Sep 2020 02:25:51 +0000 (GMT)
X-AuditID: b6c32a4a-991ff70000019d8d-48-5f598eb05a6a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DE.4B.08303.FAE895F5; Thu, 10 Sep 2020 11:25:51 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200910022550epsmtip21cfcbb638d06aed9b4abdf018191d9bb~zSv6daxrp2640026400epsmtip2O;
        Thu, 10 Sep 2020 02:25:49 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        avri.altman@wdc.com, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, rdunlap@infradead.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v2] scsi: ufs: Fix 'unmet direct dependencies' config
 warning
Date:   Thu, 10 Sep 2020 07:26:47 +0530
Message-Id: <20200910015647.52875-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsWy7bCmuu6Gvsh4g+c/FS0ezNvGZvHy51U2
        i0U3tjFZXN41h82i+/oONovlx/8xWby9M53FYuveq+wOHB6NN26weWxeoeUxYdEBRo+PT2+x
        ePRtWcXo8XmTnEf7gW6mAPYoLpuU1JzMstQifbsErozn7+6zFRzkqpjUsompgfEhRxcjJ4eE
        gInE5vbTLF2MXBxCArsZJR4vncYE4XxilGheOgcq85lR4tiRJSwwLTs/9DFDJHYxSvxa0wXl
        tDBJHF27jRmkik1AW+Lu9C1MILaIgJzE5uVfwbqZBfYySuy96ghiCwv4Szx+/hCshkVAVeJo
        Vw9YL6+AjcTHX3fYIbbJS6zecABsgYTAMXaJ91/6gRo4gBwXiVsvaiBqhCVeHd8CVS8l8fnd
        XjaIkmyJnl3GEOEaiaXzjkE9YC9x4ArIZxxA52hKrN+lD3EZn0Tv7ydQw3klOtqEIKpVJZrf
        XYXqlJaY2N3NCmF7SPx6vQ0sLiQQK/Gv9QX7BEaZWQhDFzAyrmKUTC0ozk1PLTYtMMpLLdcr
        TswtLs1L10vOz93ECI58La8djA8ffNA7xMjEwXiIUYKDWUmENyk/Ml6INyWxsiq1KD++qDQn
        tfgQozQHi5I4r9KPM3FCAumJJanZqakFqUUwWSYOTqkGJh+u+s8hmTsee4k9qXCZ9ngbw889
        DIe8pK65ic9TnmRmPjmvWEd48WyFI1VGwtoXQ72NfllH3p5dFvTxnNRFbmNF406payqh+TP0
        nj6W0D23smDbDjvW1QdT/p2qubu+7+NOmxy9l/fi1n8rMZ4k/eHyXKcYxcSX8u+e2/5IEQq1
        vL6vbE/hw7SO2Lt6V2N2H+MI132e8y6T+Uvp3Z2KYTP4b772tZSc6u140mx6H/uen6rpr4SW
        2+/ye1v59uWmjL37K3x6vl1/ZaV276DaceutWTEbWsoOHVm5fGbysXjVvMx+/0eip6fZRngc
        9FmUd0jS9sqJDydCRDv7dKwP1WW+Ma5fVRWk+lf4nN2+aiWW4oxEQy3mouJEAKe+3AdrAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42LZdlhJXnd9X2S8wZo/ghYP5m1js3j58yqb
        xaIb25gsLu+aw2bRfX0Hm8Xy4/+YLN7emc5isXXvVXYHDo/GGzfYPDav0PKYsOgAo8fHp7dY
        PPq2rGL0+LxJzqP9QDdTAHsUl01Kak5mWWqRvl0CV8bzd/fZCg5yVUxq2cTUwPiQo4uRk0NC
        wERi54c+5i5GLg4hgR2MEj9XHWODSEhLXN84gR3CFpZY+e85O0RRE5PE75u3mEASbALaEnen
        bwGzRQTkJDYv/8oCUsQscJRR4vb532CThAV8JRZ17WMBsVkEVCWOdvUwg9i8AjYSH3/dgdog
        L7F6wwHmCYw8CxgZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBAeZltYOxj2rPugd
        YmTiYDzEKMHBrCTCm5QfGS/Em5JYWZValB9fVJqTWnyIUZqDRUmc9+ushXFCAumJJanZqakF
        qUUwWSYOTqkGJl0uL59nuUc3etvnXd40/fW2Izv90pafap+/JTT6jL/xspZvF6pSHH926j/x
        XmLWtfWs8Ywvuw+xib6cdb292PzS+6U1BTdalSa2s0bONVpsmRL/e06zcgfHhs0G9mfezWNQ
        2G3GueHH5ne3up61ZszdYb1Da1rdMh7FmrNZFjJz858nnirsX9LMxaradHWRcOb7+kqrEw9b
        79Y+fWM8z+l55vUXyqvaJh84WX0tx/5Bg6lR8OYFHyaX7GPav145pq6vxPnIpp1qV3a6SVz5
        2/S0aF7FrKC/5c1v84KvPoidEbQuco5NIvvSwKbuKavWy8WvSuex3//P+LD/o7UVGa3dEjpa
        bZfYdJWf3fHft0mJpTgj0VCLuag4EQDF3P0goQIAAA==
X-CMS-MailID: 20200910022551epcas5p2f42a5d87a0e171d0d6ba9ab7f077af4b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200910022551epcas5p2f42a5d87a0e171d0d6ba9ab7f077af4b
References: <CGME20200910022551epcas5p2f42a5d87a0e171d0d6ba9ab7f077af4b@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With !CONFIG_OF and SCSI_UFS_EXYNOS selected, the below
warning is given:

WARNING: unmet direct dependencies detected for PHY_SAMSUNG_UFS
  Depends on [n]: OF [=n] && (ARCH_EXYNOS || COMPILE_TEST [=y])
  Selected by [y]:
  - SCSI_UFS_EXYNOS [=y] && SCSI_LOWLEVEL [=y] && SCSI [=y] && SCSI_UFSHCD_PLATFORM [=y] && (ARCH_EXYNOS || COMPILE_TEST [=y])

Fix it by removing PHY_SAMSUNG_UFS dependency.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
---
* Changes since v1
 - rebased on 5.10-scsi-queue 
 - Added Randy's Acked-by

 drivers/scsi/ufs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index f6394999b98c..dcdb4eb1f90b 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -165,7 +165,6 @@ config SCSI_UFS_BSG
 config SCSI_UFS_EXYNOS
 	tristate "EXYNOS specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS || COMPILE_TEST)
-	select PHY_SAMSUNG_UFS
 	help
 	  This selects the EXYNOS specific additions to UFSHCD platform driver.
 	  UFS host on EXYNOS includes HCI and UNIPRO layer, and associates with

base-commit: 32417d7844ab0bc154c39128d9ac026f4f8a7907
-- 
2.17.1

