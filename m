Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADAAEC433E8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 12:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D2F2206E7
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 12:17:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OWAb9CXh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgG0MRR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 08:17:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56872 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbgG0MRQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 08:17:16 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200727121712epoutp03586d3c1169fabf4d299e2490c75438e8~lmyZ6l7jl1611216112epoutp03m
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2020 12:17:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200727121712epoutp03586d3c1169fabf4d299e2490c75438e8~lmyZ6l7jl1611216112epoutp03m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595852232;
        bh=A+ps69oTsD76BJ11rNerZzTCxj1og2vVy1Wf+OTBNHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWAb9CXhqA/6DSy+uTw0BG7myyJn+Z27FPogbGgNMO9uTKWHAC0EvoYOfi+cjAKjp
         hYDFsp5ZqTYMwllR9thYyTiR/bvd3Ij+l6zu1ZA+hZkKhenu9tZK7LXKLZRxkv5trl
         XhoDgmt8mdX92YFzgAXKD+j+Pit/GavLRYx6oCd0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200727121712epcas2p398e0fd088cb9f0a37e30682ac73101c4~lmyZc0NJX0841008410epcas2p3g;
        Mon, 27 Jul 2020 12:17:12 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4BFf1x1VfMzMqYlh; Mon, 27 Jul
        2020 12:17:09 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.72.18874.5C5CE1F5; Mon, 27 Jul 2020 21:17:09 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200727121708epcas2p17a1fc75b9737ee32d1de64f2fdfcdf9b~lmyWWknKA0425804258epcas2p10;
        Mon, 27 Jul 2020 12:17:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200727121708epsmtrp15d62cba25e558f164f090ef33124843c~lmyWV4EOD1270612706epsmtrp1j;
        Mon, 27 Jul 2020 12:17:08 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-aa-5f1ec5c52999
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        28.93.08303.4C5CE1F5; Mon, 27 Jul 2020 21:17:08 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [12.36.155.109]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200727121708epsmtip2c5d885d05960655ad2f088bfe75eaead~lmyWKYXXJ2278722787epsmtip2r;
        Mon, 27 Jul 2020 12:17:08 +0000 (GMT)
From:   SEO HOYOUNG <hy50.seo@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, junwoo80.lee@samsung.com
Cc:     SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [RFC PATCH v4 2/2] scsi: ufs: add vendor specific write booster
Date:   Mon, 27 Jul 2020 21:17:24 +0900
Message-Id: <8fd7173a76d3508a9470fa49c736a3326bbe59fd.1595850338.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595850338.git.hy50.seo@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEJsWRmVeSWpSXmKPExsWy7bCmme7Ro3LxBm03mC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVns+tvMZNF9fQebxfLj/5gc
        eDwuX/H2uNzXy+QxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkCOKJybDJSE1NSixRS
        85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOArlVSKEvMKQUKBSQWFyvp
        29kU5ZeWpCpk5BeX2CqlFqTkFBgaFugVJ+YWl+al6yXn51oZGhgYmQJVJuRkzNpxgq3gTnrF
        i7XLmBoYV4d2MXJySAiYSLxd9IWxi5GLQ0hgB6PE009PoJxPjBLXrsxmB6kSEvjMKLF6lmoX
        IwdYx/3ZwRA1uxglbq7YxwpR84NRYusjcRCbTUBDYs2xQ0wgRSICXUwSD3d+YwJJMAuoSXy+
        u4wFxBYW8JA4MbuZGcRmEVCV2Lx4PpjNKxAlceDpckaI8+QlFjX8BuvlFLCQ2PNuAVSNoMTJ
        mU9YIGbKSzRvnc0MskxCYCGHRNe1n2wQzS4Su2f8Z4awhSVeHd/CDmFLSbzsb4Oy6yWm3FvF
        AtHcwyixZ8UJJoiEscSsZ+2MIC8zC2hKrN+lD/G9ssSRW1B7+SQ6Dv9lhwjzSnS0CUE0Kkmc
        mXsbKiwhcXB2DkTYQ6Jz9XJWSLh1M0qcnf+SfQKjwiwk38xC8s0shL0LGJlXMYqlFhTnpqcW
        GxUYIcfvJkZw4tVy28E45e0HvUOMTByMhxglOJiVRHi5RWXihXhTEiurUovy44tKc1KLDzGa
        AsN6IrOUaHI+MPXnlcQbmhqZmRlYmlqYmhlZKInz1iteiBMSSE8sSc1OTS1ILYLpY+LglGpg
        4v+2ec+a4GXLv9zfmPpBeMWv6vP+kmwKBpNYsyaul9bvSwkRODq3561I0YxnoRLrSjIcjxlf
        U+ju1XHamBFaH3QnbdGm5+t92Betfvjic/vzJZILhIMc/zB+vNQvxXX0Z7HspAy9PZPvvbix
        NqDolNZHW+nFMzOMP2/kX7wt4V0UK2//cY3oVxe9b118P8HD54Jb5N6aG1skF6Y/LE2YL/Ov
        csV95g/nzZe9OCX0XO/I14UhG8yLst7fk5As2Lkh0WZWdU5O8EGLVV/CX31Ns3jh7LniyxS7
        R9+es4mplAvWdi2WyRf8+Mb3nkPQX6YWNh9GlWcPmo4z+RUs33liQ/XTiBLtFROKXa8VdH/Y
        G6fEUpyRaKjFXFScCABt8HLKRQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSvO6Ro3LxBlfnqFk8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7LY9beZyaL7+g42i+XH/zE5
        8HhcvuLtcbmvl8ljwqIDjB7f13eweXx8eovFo2/LKkaPz5vkPNoPdDMFcERx2aSk5mSWpRbp
        2yVwZczacYKt4E56xYu1y5gaGFeHdjFycEgImEjcnx3cxcjFISSwg1Gi5/sWli5GTqC4hMT/
        xU1MELawxP2WI6wQRd8YJf6fOg+WYBPQkFhz7BATSEJEYAaTxI0tv5hBEswCahKf7y4DmyQs
        4CFxYnYzWJxFQFVi8+L5YDavQJTEgafLGSE2yEssavgNNpRTwEJiz7sFzCDXCQmYS6z7JwhR
        LihxcuYTFojx8hLNW2czT2AUmIUkNQtJagEj0ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k
        /NxNjOAY0dLawbhn1Qe9Q4xMHIyHGCU4mJVEeLlFZeKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ
        836dtTBOSCA9sSQ1OzW1ILUIJsvEwSnVwLTlbrT3mrQJ67Zsmzt32565566drmr2KjJoP1Yn
        tPv3v+5FN9cq7eE4LnzKRfBDqYW7lc62j68fpdp8Wd+xLq7WrufytW7plX/sv9RLnAlzeLW8
        t7hr6Rul6CJf1Rpd5jvFWz3UowSnf9T45Pd6ctacLKeMCQzNj1NVtnRy+bzaXxVj3S19ct26
        KwHl+rO3z7DOv+lb+6ny974lpxzC1SbP0zwqGGAUGH7kT37ziU/+sf3McbcOc34J2nvSWy3k
        adHrx+K8S55qf4nWEnNzW9bcuKxmW3t6jEX9gQk6cguZbP/w7vv+9XZUzZHpbBoRd1+XpkRn
        KeVxKyRvfTilsY1VsctByfzE67s/dNOVk5RYijMSDbWYi4oTAUpOLv0AAwAA
X-CMS-MailID: 20200727121708epcas2p17a1fc75b9737ee32d1de64f2fdfcdf9b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200727121708epcas2p17a1fc75b9737ee32d1de64f2fdfcdf9b
References: <cover.1595850338.git.hy50.seo@samsung.com>
        <CGME20200727121708epcas2p17a1fc75b9737ee32d1de64f2fdfcdf9b@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To support the fuction of writebooster by vendor.
The WB behavior that the vendor wants is slightly different.
But we have to support it

Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
---
 drivers/scsi/ufs/Kconfig      |   8 +
 drivers/scsi/ufs/Makefile     |   1 +
 drivers/scsi/ufs/ufs-exynos.c |   6 +
 drivers/scsi/ufs/ufs_ctmwb.c  | 270 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs_ctmwb.h  |  26 ++++
 drivers/scsi/ufs/ufshcd.c     |   3 +-
 drivers/scsi/ufs/ufshcd.h     |   4 -
 7 files changed, 312 insertions(+), 6 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs_ctmwb.c
 create mode 100644 drivers/scsi/ufs/ufs_ctmwb.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 46a4542f37eb..b7db2367d3bc 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -173,6 +173,14 @@ config SCSI_UFS_EXYNOS
 	  Select this if you have UFS host controller on EXYNOS chipset.
 	  If unsure, say N.
 
+config CONFIG_SCSI_UFS_VENDOR_WB
+	tristate "Write Booster Vendor specific feature support"
+	depends on SCSI_UFSHCD
+	help
+	  Enable Write Booster vendor specific.
+	  Enable this operation disables WB on the probe.
+	  Will check the WB buffer and flush operation before entering the suspend.
+
 config SCSI_UFS_CRYPTO
 	bool "UFS Crypto Engine Support"
 	depends on SCSI_UFSHCD && BLK_INLINE_ENCRYPTION
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 9810963bc049..b1ba36c7d66f 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-d
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
+obj-$(CONFIG_SCSI_UFS_VENDOR_WB) += ufs_ctmwb.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 32b61ba77241..f127f5f2bf36 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -22,6 +22,9 @@
 
 #include "ufs-exynos.h"
 
+#ifdef CONFIG_SCSI_UFS_VENDOR_WB
+#include "ufs_ctmwb.h"
+#endif
 /*
  * Exynos's Vendor specific registers for UFSHCI
  */
@@ -989,6 +992,9 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto phy_off;
 
 	ufs->hba = hba;
+#ifdef CONFIG_SCSI_UFS_VENDOR_WB
+	ufs->hba->wb_ops = ufshcd_ctmwb_init();
+#endif
 	ufs->opts = ufs->drv_data->opts;
 	ufs->rx_sel_idx = PA_MAXDATALANES;
 	if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX)
diff --git a/drivers/scsi/ufs/ufs_ctmwb.c b/drivers/scsi/ufs/ufs_ctmwb.c
new file mode 100644
index 000000000000..e1cad936ebb3
--- /dev/null
+++ b/drivers/scsi/ufs/ufs_ctmwb.c
@@ -0,0 +1,270 @@
+#include "ufshcd.h"
+#include "ufshci.h"
+#include "ufs_ctmwb.h"
+
+static struct ufshba_ctmwb hba_ctmwb;
+
+/* Query request retries */
+#define QUERY_REQ_RETRIES 3
+
+static int ufshcd_query_attr_retry(struct ufs_hba *hba,
+	enum query_opcode opcode, enum attr_idn idn, u8 index, u8 selector,
+	u32 *attr_val)
+{
+	int ret = 0;
+	u32 retries;
+
+	 for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
+		ret = ufshcd_query_attr(hba, opcode, idn, index,
+						selector, attr_val);
+		if (ret)
+			dev_dbg(hba->dev, "%s: failed with error %d, retries %d\n",
+				__func__, ret, retries);
+		else
+			break;
+	}
+
+	if (ret)
+		dev_err(hba->dev,
+			"%s: query attribute, idn %d, failed with error %d after %d retires\n",
+			__func__, idn, ret, QUERY_REQ_RETRIES);
+	return ret;
+}
+
+static int ufshcd_query_flag_retry(struct ufs_hba *hba,
+	enum query_opcode opcode, enum flag_idn idn, bool *flag_res)
+{
+	int ret;
+	int retries;
+
+	for (retries = 0; retries < QUERY_REQ_RETRIES; retries++) {
+		ret = ufshcd_query_flag(hba, opcode, idn, flag_res);
+		if (ret)
+			dev_dbg(hba->dev,
+				"%s: failed with error %d, retries %d\n",
+				__func__, ret, retries);
+		else
+			break;
+	}
+
+	if (ret)
+		dev_err(hba->dev,
+			"%s: query attribute, opcode %d, idn %d, failed with error %d after %d retries\n",
+			__func__, (int)opcode, (int)idn, ret, retries);
+	return ret;
+}
+
+static int ufshcd_reset_ctmwb(struct ufs_hba *hba, bool force)
+{
+	int err = 0;
+
+	if (!ufshcd_is_wb_allowed(hba))
+		return 0;
+
+	if (ufshcd_is_ctmwb_off(hba_ctmwb)) {
+		dev_info(hba->dev, "%s: write booster already disabled. ctmwb_state = %d\n",
+			__func__, hba_ctmwb.ufs_ctmwb_state);
+		return 0;
+	}
+
+	if (ufshcd_is_ctmwb_err(hba_ctmwb))
+		dev_err(hba->dev, "%s: previous write booster control was failed.\n",
+			__func__);
+
+	if (force)
+		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
+				QUERY_FLAG_IDN_WB_EN, NULL);
+
+	if (err) {
+		ufshcd_set_ctmwb_err(hba_ctmwb);
+		dev_err(hba->dev, "%s: disable write booster failed. err = %d\n",
+			__func__, err);
+	} else {
+		ufshcd_set_ctmwb_off(hba_ctmwb);
+		dev_info(hba->dev, "%s: ufs write booster disabled \n", __func__);
+	}
+
+	return 0;
+}
+
+static int ufshcd_get_ctmwb_buf_status(struct ufs_hba *hba, u32 *status)
+{
+	return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE, 0, 0, status);
+}
+
+static int ufshcd_ctmwb_manual_flush_ctrl(struct ufs_hba *hba, int en)
+{
+	int err = 0;
+
+	dev_info(hba->dev, "%s: %sable write booster manual flush\n",
+				__func__, en ? "en" : "dis");
+	if (en) {
+		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
+					QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, NULL);
+		if (err)
+			dev_err(hba->dev, "%s: enable write booster failed. err = %d\n",
+				__func__, err);
+	} else {
+		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
+					QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, NULL);
+		if (err)
+			dev_err(hba->dev, "%s: disable write booster failed. err = %d\n",
+				__func__, err);
+	}
+
+	return err;
+}
+
+static int ufshcd_ctmwb_flush_ctrl(struct ufs_hba *hba)
+{
+	int err = 0;
+	u32 curr_status = 0;
+
+	err = ufshcd_get_ctmwb_buf_status(hba, &curr_status);
+
+	if (!err && (curr_status <= UFS_WB_MANUAL_FLUSH_THRESHOLD)) {
+		dev_info(hba->dev, "%s: enable ctmwb manual flush, buf status : %d\n",
+				__func__, curr_status);
+		scsi_block_requests(hba->host);
+		err = ufshcd_ctmwb_manual_flush_ctrl(hba, 1);
+		if (!err) {
+			mdelay(100);
+			err = ufshcd_ctmwb_manual_flush_ctrl(hba, 0);
+			if (err)
+				dev_err(hba->dev, "%s: disable ctmwb manual flush failed. err = %d\n",
+						__func__, err);
+		} else
+			dev_err(hba->dev, "%s: enable ctmwb manual flush failed. err = %d\n",
+					__func__, err);
+		scsi_unblock_requests(hba->host);
+	}
+	return err;
+}
+
+static int ufshcd_ctmwb_ctrl(struct ufs_hba *hba, bool enable)
+{
+	int err;
+
+	if (!ufshcd_is_wb_allowed(hba))
+		return 0;
+
+	if (hba->pm_op_in_progress) {
+		dev_err(hba->dev, "%s: ctmwb ctrl during pm operation is not allowed.\n",
+			__func__);
+		return 0;
+	}
+
+	if (ufshcd_is_ctmwb_err(hba_ctmwb))
+		dev_err(hba->dev, "%s: previous write booster control was failed.\n",
+			__func__);
+	if (enable) {
+		if (ufshcd_is_ctmwb_on(hba_ctmwb)) {
+			dev_err(hba->dev, "%s: write booster already enabled. ctmwb_state = %d\n",
+				__func__, hba_ctmwb.ufs_ctmwb_state);
+			return 0;
+		}
+		pm_runtime_get_sync(hba->dev);
+		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
+					QUERY_FLAG_IDN_WB_EN, NULL);
+		if (err) {
+			ufshcd_set_ctmwb_err(hba_ctmwb);
+			dev_err(hba->dev, "%s: enable write booster failed. err = %d\n",
+				__func__, err);
+		} else {
+			ufshcd_set_ctmwb_on(hba_ctmwb);
+			dev_info(hba->dev, "%s: ufs write booster enabled \n", __func__);
+		}
+	} else {
+		if (ufshcd_is_ctmwb_off(hba_ctmwb)) {
+			dev_err(hba->dev, "%s: write booster already disabled. ctmwb_state = %d\n",
+				__func__, hba_ctmwb.ufs_ctmwb_state);
+			return 0;
+		}
+		pm_runtime_get_sync(hba->dev);
+		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
+					QUERY_FLAG_IDN_WB_EN, NULL);
+		if (err) {
+			ufshcd_set_ctmwb_err(hba_ctmwb);
+			dev_err(hba->dev, "%s: disable write booster failed. err = %d\n",
+				__func__, err);
+		} else {
+			ufshcd_set_ctmwb_off(hba_ctmwb);
+			dev_info(hba->dev, "%s: ufs write booster disabled \n", __func__);
+		}
+	}
+
+	pm_runtime_put_sync(hba->dev);
+
+	return 0;
+}
+
+/**
+ * ufshcd_get_ctmwbbuf_unit - get ctmwb buffer alloc units
+ * @sdev: pointer to SCSI device
+ *
+ * Read dLUNumTurboWriteBufferAllocUnits in UNIT Descriptor
+ * to check if LU supports write booster feature
+ */
+static int ufshcd_get_ctmwbbuf_unit(struct ufs_hba *hba)
+{
+	struct scsi_device *sdev = hba->sdev_ufs_device;
+	struct ufshba_ctmwb *hba_ctmwb = (struct ufshba_ctmwb *)hba->wb_ops;
+	int ret = 0;
+
+	u32 dLUNumTurboWriteBufferAllocUnits = 0;
+	u8 desc_buf[4];
+
+	if (!ufshcd_is_wb_allowed(hba))
+		return 0;
+
+	ret = ufshcd_read_unit_desc_param(hba,
+			ufshcd_scsi_to_upiu_lun(sdev->lun),
+			UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS,
+			desc_buf,
+			sizeof(dLUNumTurboWriteBufferAllocUnits));
+
+	/* Some WLUN doesn't support unit descriptor */
+	if ((ret == -EOPNOTSUPP) || scsi_is_wlun(sdev->lun)){
+		hba_ctmwb->support_ctmwb_lu = false;
+		dev_info(hba->dev,"%s: do not support WB\n", __func__);
+		return 0;
+	}
+
+	dLUNumTurboWriteBufferAllocUnits = ((desc_buf[0] << 24)|
+			(desc_buf[1] << 16) |
+			(desc_buf[2] << 8) |
+			desc_buf[3]);
+
+	if (dLUNumTurboWriteBufferAllocUnits) {
+		hba_ctmwb->support_ctmwb_lu = true;
+		dev_info(hba->dev, "%s: LU %d supports ctmwb, ctmwbbuf unit : 0x%x\n",
+				__func__, (int)sdev->lun, dLUNumTurboWriteBufferAllocUnits);
+	} else
+		hba_ctmwb->support_ctmwb_lu = false;
+
+	return 0;
+}
+
+static inline int ufshcd_ctmwb_toggle_flush(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	ufshcd_ctmwb_flush_ctrl(hba);
+
+	if (ufshcd_is_system_pm(pm_op))
+		ufshcd_reset_ctmwb(hba, true);
+
+	return 0;
+}
+
+static struct ufs_wb_ops exynos_ctmwb_ops = {
+	.wb_toggle_flush_vendor = ufshcd_ctmwb_toggle_flush,
+	.wb_alloc_units_vendor = ufshcd_get_ctmwbbuf_unit,
+	.wb_ctrl_vendor = ufshcd_ctmwb_ctrl,
+	.wb_reset_vendor = ufshcd_reset_ctmwb,
+};
+
+struct ufs_wb_ops *ufshcd_ctmwb_init(void)
+{
+	return &exynos_ctmwb_ops;
+}
+EXPORT_SYMBOL_GPL(ufshcd_ctmwb_init);
diff --git a/drivers/scsi/ufs/ufs_ctmwb.h b/drivers/scsi/ufs/ufs_ctmwb.h
new file mode 100644
index 000000000000..e88b71824a2f
--- /dev/null
+++ b/drivers/scsi/ufs/ufs_ctmwb.h
@@ -0,0 +1,26 @@
+#ifndef _UFS_CTMWB_H_
+#define _UFS_CTMWB_H_
+
+enum ufs_ctmwb_state {
+       UFS_WB_OFF_STATE	= 0,    /* turbo write disabled state */
+       UFS_WB_ON_STATE	= 1,            /* turbo write enabled state */
+       UFS_WB_ERR_STATE	= 2,            /* turbo write error state */
+};
+
+#define ufshcd_is_ctmwb_off(hba) ((hba).ufs_ctmwb_state == UFS_WB_OFF_STATE)
+#define ufshcd_is_ctmwb_on(hba) ((hba).ufs_ctmwb_state == UFS_WB_ON_STATE)
+#define ufshcd_is_ctmwb_err(hba) ((hba).ufs_ctmwb_state == UFS_WB_ERR_STATE)
+#define ufshcd_set_ctmwb_off(hba) ((hba).ufs_ctmwb_state = UFS_WB_OFF_STATE)
+#define ufshcd_set_ctmwb_on(hba) ((hba).ufs_ctmwb_state = UFS_WB_ON_STATE)
+#define ufshcd_set_ctmwb_err(hba) ((hba).ufs_ctmwb_state = UFS_WB_ERR_STATE)
+
+#define UFS_WB_MANUAL_FLUSH_THRESHOLD	5
+
+struct ufshba_ctmwb {
+	enum ufs_ctmwb_state ufs_ctmwb_state;
+
+	bool support_ctmwb_lu;
+};
+
+struct ufs_wb_ops *ufshcd_ctmwb_init(void);
+#endif
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3eb139406a7c..78c4cfc4b635 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3306,7 +3306,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
  *
  * Return 0 in case of success, non-zero otherwise
  */
-int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
+static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 				int lun,
 				enum unit_desc_param param_offset,
 				u8 *param_read_buf,
@@ -3322,7 +3322,6 @@ int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
 				      param_offset, param_read_buf, param_size);
 }
-EXPORT_SYMBOL_GPL(ufshcd_read_unit_desc_param);
 
 static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
 {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 61ae5259c62a..366f3b4634a7 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1012,10 +1012,6 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op);
 
-int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
-				int lun, enum unit_desc_param param_offset,
-				u8 *param_read_buf, u32 param_size);
-
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 {
-- 
2.26.0

