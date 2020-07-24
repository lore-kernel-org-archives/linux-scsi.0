Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46EF0C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 15:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBCBE20714
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 15:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VZgwM8m9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgGXPHk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 11:07:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60288 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGXPHj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 11:07:39 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200724150736epoutp04fb8385a06e20136ce7be61a58f82cf46~kuLUdDr9_1741717417epoutp04W
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2020 15:07:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200724150736epoutp04fb8385a06e20136ce7be61a58f82cf46~kuLUdDr9_1741717417epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595603256;
        bh=Z7FqLb5JFyxfxbp/Hxal9fNVJmmYiBZ4bqgmC5eyhbI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=VZgwM8m9omh7yoz12zRTp6mvIEIl2NeqqaE5rbAeIztdL2P6TBtkphs4vaboA32UU
         dxQYoZ6afLO3G4fHrAJ3t7/FtcbHwn9D3fJzklg1byz8bG1OxQqn/iUNLll35eyUWQ
         3Jae10y14BzZHKxDc2cura9r3ql8OBRMqzVEGk8k=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200724150734epcas2p4955ea4dc4c9d5f5e0ea68f755255eeac~kuLTGFu1c1846118461epcas2p4s;
        Fri, 24 Jul 2020 15:07:34 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BCsxw45GdzMqYkZ; Fri, 24 Jul
        2020 15:07:32 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        92.DE.27441.439FA1F5; Sat, 25 Jul 2020 00:07:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200724150731epcas2p3dabaca859355cb02100f5addcd5eb7df~kuLQob01c3188531885epcas2p3S;
        Fri, 24 Jul 2020 15:07:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200724150731epsmtrp2432bce4cea81a002800cc2e690c0ac3b~kuLQnnyC20978309783epsmtrp2c;
        Fri, 24 Jul 2020 15:07:31 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-13-5f1af9341d13
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        34.E0.08382.339FA1F5; Sat, 25 Jul 2020 00:07:31 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200724150731epsmtip23a2393021b92efbd70330dddf5b07a2d~kuLQZq6rA1765517655epsmtip2S;
        Fri, 24 Jul 2020 15:07:31 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1] ufs: fix warnings for module build
Date:   Fri, 24 Jul 2020 23:59:21 +0900
Message-Id: <1595602761-189235-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42LZdljTQtfkp1S8wakWOYsH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi19/17NbrF78gMVi0Y1tTBY3txxlsei+voPNYvnxf0wW
        XXdvMFos/feWxYHP4/IVb4/Lfb1MHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAj
        KscmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+huJYWy
        xJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVC
        Tsb8LxfYC6ZwVzR33mBrYPzK2cXIySEhYCIx49sMNhBbSGAHo8ThR94Q9idGiVetYV2MXED2
        N0aJcyceM3cxcoA1XPvrBxHfyyjxbP86RgjnB6PE7ssTGUG62QQ0JZ7enMoEkhAR2Mwk8WrB
        fWaQBLOAusSuCSeYQGxhATOJnqUvwRpYBFQlfh7vZQWxeQXcJPrbT7NAnCcncfNcJzPIIAmB
        n+wSd5a8YINIuEjMmNjKBGELS7w6voUdwpaS+PxuL1RNvcS+qQ2sEM09jBJP9/1jhEgYS8x6
        1s4I8g8z0Knrd+lDvKYsceQWC8SdfBIdh/+yQ4R5JTrahCAalSV+TZoMNURSYubNO1BbPSQ+
        n3vGCAm5WIk79/4yTWCUnYUwfwEj4ypGsdSC4tz01GKjAmPkONrECE6KWu47GGe8/aB3iJGJ
        g/EQowQHs5II74pvUvFCvCmJlVWpRfnxRaU5qcWHGE2B4TWRWUo0OR+YlvNK4g1NjczMDCxN
        LUzNjCyUxHmLrS7ECQmkJ5akZqemFqQWwfQxcXBKNTC1bpgnlP2mSVto2fuFnUlW6pmWUruV
        Nq+6uU5L4sqpirZGdlG9skYJlnn5ps8kAu9/2W7UsaI6d/e2lPVHxX9O0X0SYfJU9rTtHfV9
        8UcYL16rXnPztv2nybJt0zWDZx+6q5AnH/7/tlBYQuU6YdPlV7dPKipjkH2oteR/kOXK8rjZ
        b+dx/dRVEW3ZcXah6I314apzJKfK8L+R19z+V//uoqgbwilC7xQWXe/Y0Tb3UHTIY48/r8zD
        Wk78v5JXWzL987G0OrOk5jg1uX9Rck/3uebfLZ/zc7lQivy9o1enz9GYF8dTVyk+vyXhwebe
        bce9v9bL1Wa77rqb8nTJTWljnfcL8rOTrVonyhg8i09RYinOSDTUYi4qTgQAviXXwRMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSvK7xT6l4g4fNhhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfG/C8X2AumcFc0d95ga2D8ytnFyMEhIWAice2vXxcjF4eQwG5GiV9r
        G5i6GDmB4pISJ3Y+Z4SwhSXutxxhhSj6xiixddJMsCI2AU2JpzenMoEkRAQOM0n83/qcHSTB
        LKAusWvCCbAiYQEziZ6lL8EmsQioSvw83ssKYvMKuEn0t59mgdggJ3HzXCfzBEaeBYwMqxgl
        UwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxggNVS3MH4/ZVH/QOMTJxMB5ilOBgVhLhXfFN
        Kl6INyWxsiq1KD++qDQntfgQozQHi5I4743ChXFCAumJJanZqakFqUUwWSYOTqkGJlMWNXPv
        9EbTd2vPOPD8/RV45rr7iffBW5ZfXj5n6ToZoX+Cuz1/s7/eNHdWdqLLuyPr7sXu0ii9e+Nl
        k3ndvK6bPinsPWfsdt0wvyeQweS27dKtiuoD/k4PPss96N+gOumiS+XnNT28l11F+tfIyjq9
        52rb1ay/YRVLwTxLN9U1S//m1Ytd9Hx0uleBpcZQ/bF8fs6iSQ8Whv5QXJc0l/H82luL907s
        cakWTu/8+jZjD0vA/VmRO0WrLn6+xzB/r9PrhHkW/ce1Dt0Ibd4dsPiqyqlrAfecKjr5rWtl
        Tp++rrvrYMUG5dTETh/D3GPvCt02yheVZqXUBrTmO217J79UVE2k5XXzx/wJ13MDwpVYijMS
        DbWYi4oTAZ6CrJPDAgAA
X-CMS-MailID: 20200724150731epcas2p3dabaca859355cb02100f5addcd5eb7df
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200724150731epcas2p3dabaca859355cb02100f5addcd5eb7df
References: <CGME20200724150731epcas2p3dabaca859355cb02100f5addcd5eb7df@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufs-exynos.ko didn't see the symbols in ufs-exynos-dbg.o.
I merged two object into one symbol.

>> ERROR: modpost: "exynos_ufs_dump_info" [drivers/scsi/ufs/ufs-exynos.ko] undefined!
>> ERROR: modpost: "exynos_ufs_init_dbg" [drivers/scsi/ufs/ufs-exynos.ko] undefined!
>> ERROR: modpost: "exynos_ufs_cmd_log_start" [drivers/scsi/ufs/ufs-exynos.ko] undefined!

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/scsi/ufs/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index ee09961..535d027 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -4,8 +4,9 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
-obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
-obj-$(CONFIG_SCSI_UFS_EXYNOS_DBG) += ufs-exynos-dbg.o
+obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos-core.o
+ufs-exynos-core-y += ufs-exynos.o
+ufs-exynos-core-$(CONFIG_SCSI_UFS_EXYNOS_DBG) += ufs-exynos-dbg.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
-- 
2.7.4

