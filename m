Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38EFC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACFF4610C8
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237096AbhIQG5N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41979 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhIQG4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:54 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210917065527epoutp03940b90ee20d4f009a9c5f1d4998344e3~liZheCCHG0421304213epoutp03N
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210917065527epoutp03940b90ee20d4f009a9c5f1d4998344e3~liZheCCHG0421304213epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861727;
        bh=bMi1iTXc8FrS/kapkX5EHrKcnwoVV1Puibh6oHUmS9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNqNTBr4lZVP7FgCuH9k46MNLvkrQ3vt+FaAHN1CrFv0Y9LSmpJvF9Ru8gONvKayx
         Gf/uFnEhijFq//7xDSjHmmGg8pEkDurHy9FfWE+MgMcoIokJECV/LqLEWBjWx6wtth
         O8NC0tueLZbm9R/tE/jo/0kSSwsZXAxk0EE05S+k=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210917065526epcas2p3995fb2ef939fcd2b50c561a90f04a7c8~liZgqLXCV1851718517epcas2p3k;
        Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4H9l8F003bz4x9Q6; Fri, 17 Sep
        2021 06:55:24 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.DF.09472.CDB34416; Fri, 17 Sep 2021 15:55:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epcas2p4fc1be41c739361dd6ae9d167cfc631dc~liZeJx6pm2819628196epcas2p4T;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210917065523epsmtrp25f6ac0864d4eb03acb130c19f145f7a7~liZeIbne11373513735epsmtrp2F;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
X-AuditID: b6c32a48-d75ff70000002500-4e-61443bdc8e39
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        22.20.09091.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epsmtip21934ac324ca70ff0d8b72ef8386aac13~liZd22ZVA2196221962epsmtip2c;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 13/17] scsi: ufs: ufs-exynos: add pre/post_hce_enable drv
 callbacks
Date:   Fri, 17 Sep 2021 15:54:32 +0900
Message-Id: <20210917065436.145629-14-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUxbVRzNfa88HgjzUYbeEYSmSraxwFqkcIcroIB7BtQmM2qmsbzACxBK
        W/qKjsUtKBkf69g6RhiUjyg4x9AUBh0wvoYFRZhhE1hkhKHbqoQaJl8bAxVs+1jkv3N/v3Pu
        ued37yVx4RThT2aq9axOzajEhKegfWCvLHT6lQRGUtEI0bDtWwL9VtdOoLm12wT67l6JAFUs
        rOFoqflrNzR+fR86fS0e3TDWY8jWbMJR/WQ7hq7MP8HQHcv3AlR5sw9Dhl86CXRpaAOLo+jx
        iSTalF9K0ONnSjG6rTGEbuiZw+jWphKCNtb3A3q1uZigF3+fEtBnLE2AXm4NpIv6DZjC64jq
        YAbLpLE6EatO1aRlqtPl4qTDynilLFIiDZUeQFFikZrJZuXihGRF6OuZKkcksehjRpXrKCkY
        jhPvjzmo0+TqWVGGhtPLxaw2TaWVSrVhHJPN5arTw1I12dFSiSRc5mCmqDJMlUWYtnvH0Y6O
        Krd8YPI6BTxISEXA7plV/BTwJIVUJ4ClVa0Ev1gC0GgecXOyhNRjADueBD1VzNz6050n9QJ4
        s7FsS7EIYJl5zN3JIqhQaJm1A2djJ/UXgLYH5S4JTplwOPToPOZk+VLvw5/+rnRhARUMSwpO
        uvy8qThYWz+C835BcHC9xIU9HPWprk3Ac3zgcJVN4MS4g1NwtdqVAlKTJLQVlgNenADNbRe3
        NvKF9iGLO4/94fLDXoIXGAA8eX9zq/ENgCWfJfM4Fq5fsDhORDoc9sLmrv1OCKkX4eDUlu8O
        WDzwrztf9obFhUJeuBv2d1wQ8PgFaKhZduMpNCzs0/PDOg/gwqQdMwKRaVsa07Y0pv99vwB4
        E3iO1XLZ6SwXro3YfsWtwPXIQ+hOUD2/EGYFGAmsAJK4eKf3rU9fZYTeaUzeMVanUepyVSxn
        BTLHrM/h/n6pGscvUeuVUll4ZKTkgAzJIsOR+Hnv2o3XGCGVzujZLJbVsrqnOoz08M/HJIT9
        Wtd0gXxlj8Z2NTS2rKdvsy2CJIQfzX35+a4c/FKiZ1DZ2GIMEV40/Dh+s/pDxbrXldjgwpgj
        yXl1Ve0K358vn2hKCJ7F3q5NVNNLgSlRZWqzz/gPvkXznE9O3lvl6L2gyYa715VZFYaJQNya
        c9cr6dBx0+DG4ar8+w2WN2ufjX7mV3PLPwR1rAPzk1+8bFaePaqxgQfjnSf0LWcje2bVWLe8
        xvOr3aOH4qiol0bXBkT5L1vs+JheufLGTE3LaP/Q7QB7ZvLxsIf3alL2LCjq2npbY62ryPjO
        B0Nkw6Mbu7rYfdkBP/oFD4zgpz+ZSAywvlseuDKdJTHc+UMRfU4s4DIYaQiu45j/AIcCQ/Nt
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvO5ta5dEg7k7dS1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLG5u
        OcpiMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlTFrRjtTwW6+iu3b
        Z7I2MM7i6WLk5JAQMJG4d+E1O4gtJLCbUeLfHUaIuKzEs3c72CFsYYn7LUdYuxi5gGreM0ps
        WtHNBJJgE9CV2PL8FViDiMBHRok537RAipgFljBLNB6YB1YkLBAmMfPkLWYQm0VAVaKzuZUV
        xOYVcJCYu+gUM8QGeYkjvzrBbE6g+K1d/xkhLrKXmDh5ESNEvaDEyZlPWEBsZqD65q2zmScw
        CsxCkpqFJLWAkWkVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpecn7uJkZwvGlp7mDcvuqD3iFG
        Jg7GQ4wSHMxKIrwXahwThXhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBa
        BJNl4uCUamDampu0cpvPqadNwccX+NuseVK+dElvQ3rPYRX76mwNv8pvbyed4VSaO9GbwZt3
        ms+E5vI5n1OnMLpe3XA1W6smnvd2xQ7FD+LsFinTWILPFDh+nnonWd7stvHTaedYp0ndjUvk
        7linM0Hkneoy2UuGD/NDz21lePs9oPPl0uq46IWaD1akxB+5K/XhJP/bB3832e2r803jYXXJ
        X7VYQn5H+8XZO4WrOT981H9+ltVt2d/jzdNvr8ndWMeU0/VZYUqZg03SzNpHjRMPaMiFvbo4
        M+GQ0voN7X8upOg/OLP4x3/pT/9+/9Y1Oc+1Uu9K0MdsQau/F72lV7ErCpkmzHlao7qrmuNX
        g4/ikfhvH/67KbEUZyQaajEXFScCAAsHulQmAwAA
X-CMS-MailID: 20210917065523epcas2p4fc1be41c739361dd6ae9d167cfc631dc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p4fc1be41c739361dd6ae9d167cfc631dc
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p4fc1be41c739361dd6ae9d167cfc631dc@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds driver-specific pre/post_hce_enable callbacks to execute
extra initializations before and after hce_enable_notify callback.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 10 ++++++++++
 drivers/scsi/ufs/ufs-exynos.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 753b22358186..7fb4514f700d 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1141,6 +1141,12 @@ static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
 
 	switch (status) {
 	case PRE_CHANGE:
+		if (ufs->drv_data->pre_hce_enable) {
+			ret = ufs->drv_data->pre_hce_enable(ufs);
+			if (ret)
+				return ret;
+		}
+
 		ret = exynos_ufs_host_reset(hba);
 		if (ret)
 			return ret;
@@ -1150,6 +1156,10 @@ static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
 		exynos_ufs_calc_pwm_clk_div(ufs);
 		if (!(ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL))
 			exynos_ufs_enable_auto_ctrl_hcc(ufs);
+
+		if (ufs->drv_data->post_hce_enable)
+			ret = ufs->drv_data->post_hce_enable(ufs);
+
 		break;
 	}
 
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index a0899aaa902e..c291ae51dd41 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -154,6 +154,8 @@ struct exynos_ufs_drv_data {
 				struct ufs_pa_layer_attr *pwr);
 	int (*post_pwr_change)(struct exynos_ufs *ufs,
 				struct ufs_pa_layer_attr *pwr);
+	int (*pre_hce_enable)(struct exynos_ufs *ufs);
+	int (*post_hce_enable)(struct exynos_ufs *ufs);
 };
 
 struct ufs_phy_time_cfg {
-- 
2.33.0

