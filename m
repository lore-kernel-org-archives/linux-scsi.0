Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86620C2D0E4
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 03:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 510FE2343F
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 03:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgLSDId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 22:08:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27934 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgLSDId (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 22:08:33 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201219030749epoutp04670e4f7ef4b76f6ddda3c8a545605644~R-1H16fV52765927659epoutp04j
        for <linux-scsi@vger.kernel.org>; Sat, 19 Dec 2020 03:07:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201219030749epoutp04670e4f7ef4b76f6ddda3c8a545605644~R-1H16fV52765927659epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608347269;
        bh=xI0GoKgkBmtVCZ0kRLuGOz52aCRkrRLdI3vyzN2hAEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=DS0q+b8Ia8Y9K+noO1LqlQs2t/SdCZTXGTLyaZMfgWdFnMA2r61qWjmKo7VQBZM99
         vtXAtd0DV6hEpclxn9u3zZdkNGRpKmcYflxG2YTEqF7mzTmKoqHZOvAnWAbteyuXLn
         jz5+3Y/ol//JPh2UxEgI4DnwIcBGAerbgjGQWL5w=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201219030748epcas2p39c6e633f02d0e1ed09ccc1cb39cadc71~R-1HO7GBA1741717417epcas2p3K;
        Sat, 19 Dec 2020 03:07:48 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4CyVz66vGbz4x9Ps; Sat, 19 Dec
        2020 03:07:46 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F8.4C.56312.28E6DDF5; Sat, 19 Dec 2020 12:07:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20201219030745epcas2p20989804ebd913d14a0d2536933248674~R-1EXm7rk0424404244epcas2p2t;
        Sat, 19 Dec 2020 03:07:45 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201219030745epsmtrp1ba007391459f08c45af7d54040062ca5~R-1EUBjgC0919109191epsmtrp1T;
        Sat, 19 Dec 2020 03:07:45 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-4d-5fdd6e82a074
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        61.45.13470.18E6DDF5; Sat, 19 Dec 2020 12:07:45 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201219030745epsmtip2a247178e5776452ee30e99449daf0f98~R-1EFqbmL0895008950epsmtip21;
        Sat, 19 Dec 2020 03:07:45 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 2/2] ufs: ufs-exynos: apply vendor specifics for three
 timeouts
Date:   Sat, 19 Dec 2020 11:56:54 +0900
Message-Id: <1cd204ae82a356bf3cb5f86a2055e34456537bf7.1608346381.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608346381.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608346381.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsWy7bCmqW5T3t14g+61RhYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZEzplC/o5644N/UdSwPjYs4uRk4OCQETiUsH7jJ1MXJxCAnsYJQ4uOwVlPOJUeL5
        2+OsIFVCAt8YJXp3qMJ0zP1zhw0ivpdR4tmpXIiGH4wSs+8/AUuwCWhKPL05FWySiMAZJolr
        rWfBJjELqEvsmnCCCcQWFgiRWHZ8IwuIzSKgKrFg+XywZl6BaIktd7tZIbbJSdw818kMYnMK
        WEqc6f3JiMrmAqqZySFxZcUUqAYXibbOOUwQtrDEq+Nb2CFsKYmX/W1Qdr3EvqkNrBDNPYwS
        T/f9Y4RIGEvMetYOZHMAXaopsX6XPogpIaAsceQWC8T9fBIdh/+yQ4R5JTrahCAalSV+TZoM
        NURSYubNO1CbPCTuXr7JBgkgoE2/umayTGCUn4WwYAEj4ypGsdSC4tz01GKjAiPkyNvECE6o
        Wm47GKe8/aB3iJGJg/EQowQHs5IIb+iD2/FCvCmJlVWpRfnxRaU5qcWHGE2BATmRWUo0OR+Y
        0vNK4g1NjczMDCxNLUzNjCyUxHlDV/bFCwmkJ5akZqemFqQWwfQxcXBKNTBdlOcofrWoNTh/
        k5rKNmWLG86eM2593RjNV/u2okW3e4d7xmx+J8evAvxHtd9u9/PfWnXWcCdnfmzF77pm3v1e
        Ucs67il7f9/w/fT/s+vDRL4eOHRjy2znJ7yx9rrtwn7FZouO25+vCFz6kOvB5xndcUJfVfhP
        WrIWzNK6w217bmpgePrjKdxLLvJOWJhjpatS4JCw3zaRwbQ1gevgsfCqnC//luxL1no64fnf
        1w8Knn21324pNKMjky2w9XG1BXv/hkl1GrtmV+3VXMx7LEDVQbP8dteqkzl2DSGcjTZ3939s
        5SycODf9w4WVPAkfYu//6A9d8W/l2f/3PxT9ndcdFRmUUbLxTbGNksyrGclKLMUZiYZazEXF
        iQArLqeAMQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWy7bCSvG5j3t14g5Wn5S0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGVM6ZQv6OeuODf1HUsD42LOLkZODgkBE4m5f+6wdTFycQgJ
        7GaUeLunlQUiISlxYudzRghbWOJ+yxFWiKJvjBIbdpwCK2IT0JR4enMqE0hCROAek8SlCXOZ
        QRLMAuoSuyacYAKxhQWCJA62dLKC2CwCqhILls9nA7F5BaIlttztZoXYICdx81wnWC+ngKXE
        md6fQJs5gLZZSLQ8C8AhPIFRYAEjwypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOB4
        0NLcwbh91Qe9Q4xMHIyHGCU4mJVEeEMf3I4X4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8
        kEB6YklqdmpqQWoRTJaJg1OqgSnZJSgz54ZV0iHzDI0Jc4JE33cI7rb3Ev5tlZg9MU5O4Ok/
        Nx/hz5Om/i+t27UvLU7ixbGD37Xya9V+xic+rwnUbMjhF5Fsc1vq/87l3KfY1uNKMazS2ucr
        XSv3zPGVmDH3WF+QtGW6rKHVnYIMy/VOjAnLpzxq9j1/8Uhvx+rrjeenvkqS6Z3+fvUbZY/E
        BS1b3fOCd4myLjDI/Gy2an18lBzzg6Pnp73Ku836wmfzkaWOwbza9ZVVVz3SpkQeqd6s/CxD
        0WTdm6JX89nKdwt6fPyrOcm9gvuk1ovT+qwXKusEVp65VGPl287d9aRjmsr797wn9ml4+1Rm
        PGGaFayjs3rO/WDdhI7+1K29SizFGYmGWsxFxYkA/r0A7/YCAAA=
X-CMS-MailID: 20201219030745epcas2p20989804ebd913d14a0d2536933248674
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219030745epcas2p20989804ebd913d14a0d2536933248674
References: <cover.1608346381.git.kwmad.kim@samsung.com>
        <CGME20201219030745epcas2p20989804ebd913d14a0d2536933248674@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set optimized values for those timeouts
- FC0_PROTECTION_TIMER
- TC0_REPLAY_TIMER
- AFC0_REQUEST_TIMER

Exynos doesn't yet use traffic class #1.

Change-Id: Ib672b554ea109159cd75ff67a111f46ebff4a7dc
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a8770ff..5ca21d1 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -640,6 +640,11 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
 		}
 	}
 
+	/* setting for three timeout values for traffic class #0 */
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 8064);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 28224);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 20160);
+
 	return 0;
 out:
 	return ret;
@@ -1236,7 +1241,8 @@ struct exynos_ufs_drv_data exynos_ufs_drvs = {
 				  UFSHCI_QUIRK_BROKEN_HCE |
 				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
 				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
-				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL,
+				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
+				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
 	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
-- 
2.7.4

