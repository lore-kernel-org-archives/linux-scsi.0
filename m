Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DBFEC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D56922C9C
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:40:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fqKv0tD3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgGTKkB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 06:40:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41880 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728419AbgGTKkA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 06:40:00 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200720103955epoutp04b5195427fdc4f87e804df6add6fdb779~jb8d-u8N33188231882epoutp04j
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2020 10:39:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200720103955epoutp04b5195427fdc4f87e804df6add6fdb779~jb8d-u8N33188231882epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595241595;
        bh=EuJB1xrfeujR6eUit1EgR6dmpQuSU8qWpNo3MsQhUwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqKv0tD3s7ePTosXhEzFysNsEn9RcECLn9N4jugPY05W1o4HnkNzwh83grLwmwkok
         doQ4yCxFgSi99cCxNhV7psPs2GQMSGYsENYI255t5xCStaC8AypA5WM04kxiitduBm
         y7+tDwXAXsIwEb7xRY5J153JJFtR6N2dbov1gxq0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200720103955epcas2p4a9ae20756e5a1f5467365a962bdc297c~jb8dkiXnP1702317023epcas2p47;
        Mon, 20 Jul 2020 10:39:55 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B9JBw2XbXzMqYkd; Mon, 20 Jul
        2020 10:39:52 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        36.AD.27013.874751F5; Mon, 20 Jul 2020 19:39:52 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200720103951epcas2p246072985a70a459f0acb31d339298a47~jb8aPYfiv0180201802epcas2p2Q;
        Mon, 20 Jul 2020 10:39:51 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200720103951epsmtrp1edf80d2712371739ef98b93ed7c5d071~jb8aOqShr1624216242epsmtrp1g;
        Mon, 20 Jul 2020 10:39:51 +0000 (GMT)
X-AuditID: b6c32a48-d35ff70000006985-02-5f1574783146
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F4.3D.08303.774751F5; Mon, 20 Jul 2020 19:39:51 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [12.36.155.109]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200720103951epsmtip23343784f1a7bd140dbadf19da1478657~jb8Z-eVTF0943709437epsmtip2y;
        Mon, 20 Jul 2020 10:39:51 +0000 (GMT)
From:   SEO HOYOUNG <hy50.seo@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com
Cc:     SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [RFC PATCH v2 3/3] scsi: ufs: add vendor specific write booster To
 support the fuction of writebooster by vendor. The WB behavior that the
 vendor wants is slightly different. But we have to support it
Date:   Mon, 20 Jul 2020 19:40:13 +0900
Message-Id: <5be595eb83365ec97a8ee0ddafb748029ee8cdf9.1595240433.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595240433.git.hy50.seo@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAJsWRmVeSWpSXmKPExsWy7bCmhW5FiWi8wf8PfBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TA7fH5Sve
        Hpf7epk8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAEdUjk1GamJKapFCal5yfkpm
        XrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0KFKCmWJOaVAoYDE4mIlfTubovzS
        klSFjPziElul1IKUnAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjHW7brEV3A+t+HnyL0sD
        42a3LkZODgkBE4kr236xdjFycQgJ7GCUeDHjPxtIQkjgE6PE9G2hEInPjBI/Gr6zwnQc7p3J
        BpHYxSjRv/oQE4Tzg1Fi6u6NTCBVbAIaEmuOQSREBD4wShxdMRusnVlATeLz3WUsIAlhgatA
        7UufgnWwCKhKbHoNUcQrECWx5v1sdoh98hKLGn6D1XAKWEjM2fiIDaJGUOLkzCcsEEPlJZq3
        zmYGGSohMJdD4sS3PkaIZheJD62HmSFsYYlXx7dADZWSeNnfBmXXS0y5t4oFormHUWLPihNM
        EAljiVnP2oEGcQBt0JRYv0sfxJQQUJY4cgtqL59Ex+G/7BBhXomONiGIRiWJM3NvQ4UlJA7O
        zoEIe0h0fLjPCAmsbkaJWd/vMU1gVJiF5JtZSL6ZhbB3ASPzKkax1ILi3PTUYqMCE+Qo3sQI
        TrpaHjsYZ7/9oHeIkYmD8RCjBAezkgjvRB7heCHelMTKqtSi/Pii0pzU4kOMpsCwnsgsJZqc
        D0z7eSXxhqZGZmYGlqYWpmZGFkrivO+sLsQJCaQnlqRmp6YWpBbB9DFxcEo1MHVwH77+pW1H
        +duO22Ur3u7yP2Y97db+zRpvOT9fdntV8+O2+Wy2kC9rWx+UHlx6tsa+cnG7wk33wPLLhgnO
        By/np3JN59AxbY0UuSdxrPTrrpoTj/etXJa6IOOIWJ0T6/ekPernah88djpwetutx2uLBU55
        Hc+cVv10EofqjF+emo78BiV7O+TP9hdMWFY7ve5gs2PtgWpZNq7UKckc6ycXytYzOnzoclMx
        N7mybvc/VobsSvmbLeoCHon7Wc6UHj3MIfOUnVFwV3Fql2Rz4J9VVmzvVn9M7Fy883Gc35mD
        YpNniK/X/GZfOY3ntsjbYEHpmwr9roW7fGR/VWyKa1prb3FF6HqIf/aiKzfiHiqxFGckGmox
        FxUnAgAKagUBQwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWy7bCSvG55iWi8wfRzMhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TA7fH5Sve
        Hpf7epk8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAEcUl01Kak5mWWqRvl0CV8a6
        XbfYCu6HVvw8+ZelgXGzWxcjJ4eEgInE4d6ZbF2MXBxCAjsYJb6dO8EGkZCQ+L+4iQnCFpa4
        33KEFaLoG6PE2jUvwBJsAhoSa44dArNFBP4wSkw6HQdiMwuoSXy+u4wFpEFY4CKjxIO2V2BT
        WQRUJTa9ns0KYvMKREmseT+bHWKDvMSiht9ggzgFLCTmbHwEVi8kYC5xflcjM0S9oMTJmU9Y
        IBbISzRvnc08gVFgFpLULCSpBYxMqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgqND
        S2sH455VH/QOMTJxMB5ilOBgVhLhncgjHC/Em5JYWZValB9fVJqTWnyIUZqDRUmc9+ushXFC
        AumJJanZqakFqUUwWSYOTqkGpqlJF3n8Feb0xNirtk8MZbOLibg14SnrolMrJP/m/r5x0/SB
        +vQAxWNZTlv6ctZ9Tm2Zq2HS+UTu7Wu7wKCLh24vTCvrDZUrDFlznC9hU91fkVUS4u8+/G7y
        6Y1MZ7398PvczRe3lG6OVxDZ2T07xye7fdGjhbM65q0++//S//bf3lMWH+FeevWI5qxzzKeO
        HPJZlN56gzP5ovyB3/Hq5zm9NR/3cZjNXn09de+EC9ZPZiT/PB523pr1QNqNPTGCnlembzbi
        Dft08BXT+X1bFv/7WPbUTupMR8Cs5okF04/bFZ2NkPgqKp8gtuSs/PuVuv15T6zbbNPnff7U
        njF78bOGcxVJ91ZLbFQVY3OvuPNLiaU4I9FQi7moOBEA7bCPXP0CAAA=
X-CMS-MailID: 20200720103951epcas2p246072985a70a459f0acb31d339298a47
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200720103951epcas2p246072985a70a459f0acb31d339298a47
References: <cover.1595240433.git.hy50.seo@samsung.com>
        <CGME20200720103951epcas2p246072985a70a459f0acb31d339298a47@epcas2p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
---
 drivers/scsi/ufs/Makefile     |   1 +
 drivers/scsi/ufs/ufs-exynos.c |   6 +
 drivers/scsi/ufs/ufs_ctmwb.c  | 279 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs_ctmwb.h  |  27 ++++
 4 files changed, 313 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs_ctmwb.c
 create mode 100644 drivers/scsi/ufs/ufs_ctmwb.h

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
index 000000000000..ab39f40721ae
--- /dev/null
+++ b/drivers/scsi/ufs/ufs_ctmwb.c
@@ -0,0 +1,279 @@
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
+	if (!hba_ctmwb.support_ctmwb)
+		return 0;
+
+	if (ufshcd_is_ctmwb_off(hba_ctmwb)) {
+		dev_info(hba->dev, "%s: turbo write already disabled. ctmwb_state = %d\n",
+			__func__, hba_ctmwb.ufs_ctmwb_state);
+		return 0;
+	}
+
+	if (ufshcd_is_ctmwb_err(hba_ctmwb))
+		dev_err(hba->dev, "%s: previous turbo write control was failed.\n",
+			__func__);
+
+	if (force)
+		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
+				QUERY_FLAG_IDN_WB_EN, NULL);
+
+	if (err) {
+		ufshcd_set_ctmwb_err(hba_ctmwb);
+		dev_err(hba->dev, "%s: disable turbo write failed. err = %d\n",
+			__func__, err);
+	} else {
+		ufshcd_set_ctmwb_off(hba_ctmwb);
+		dev_info(hba->dev, "%s: ufs turbo write disabled \n", __func__);
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
+	dev_info(hba->dev, "%s: %sable turbo write manual flush\n",
+				__func__, en ? "en" : "dis");
+	if (en) {
+		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
+					QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, NULL);
+		if (err)
+			dev_err(hba->dev, "%s: enable turbo write failed. err = %d\n",
+				__func__, err);
+	} else {
+		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
+					QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, NULL);
+		if (err)
+			dev_err(hba->dev, "%s: disable turbo write failed. err = %d\n",
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
+#if 0
+	if (!hba->support_ctmwb)
+		return;
+
+	if (hba->pm_op_in_progress) {
+		dev_err(hba->dev, "%s: ctmwb ctrl during pm operation is not allowed.\n",
+			__func__);
+		return;
+	}
+
+	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
+		dev_err(hba->dev, "%s: ufs host is not available.\n",
+			__func__);
+		return;
+	}
+	if (ufshcd_is_ctmwb_err(hba_ctmwb))
+		dev_err(hba->dev, "%s: previous turbo write control was failed.\n",
+			__func__);
+#endif
+	if (enable) {
+		if (ufshcd_is_ctmwb_on(hba_ctmwb)) {
+			dev_err(hba->dev, "%s: turbo write already enabled. ctmwb_state = %d\n",
+				__func__, hba_ctmwb.ufs_ctmwb_state);
+			return 0;
+		}
+		pm_runtime_get_sync(hba->dev);
+		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
+					QUERY_FLAG_IDN_WB_EN, NULL);
+		if (err) {
+			ufshcd_set_ctmwb_err(hba_ctmwb);
+			dev_err(hba->dev, "%s: enable turbo write failed. err = %d\n",
+				__func__, err);
+		} else {
+			ufshcd_set_ctmwb_on(hba_ctmwb);
+			dev_info(hba->dev, "%s: ufs turbo write enabled \n", __func__);
+		}
+	} else {
+		if (ufshcd_is_ctmwb_off(hba_ctmwb)) {
+			dev_err(hba->dev, "%s: turbo write already disabled. ctmwb_state = %d\n",
+				__func__, hba_ctmwb.ufs_ctmwb_state);
+			return 0;
+		}
+		pm_runtime_get_sync(hba->dev);
+		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
+					QUERY_FLAG_IDN_WB_EN, NULL);
+		if (err) {
+			ufshcd_set_ctmwb_err(hba_ctmwb);
+			dev_err(hba->dev, "%s: disable turbo write failed. err = %d\n",
+				__func__, err);
+		} else {
+			ufshcd_set_ctmwb_off(hba_ctmwb);
+			dev_info(hba->dev, "%s: ufs turbo write disabled \n", __func__);
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
+ * to check if LU supports turbo write feature
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
+	if (!hba_ctmwb->support_ctmwb)
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
+	hba_ctmwb.support_ctmwb = 1;
+
+	return &exynos_ctmwb_ops;
+}
+EXPORT_SYMBOL_GPL(ufshcd_ctmwb_init);
+
diff --git a/drivers/scsi/ufs/ufs_ctmwb.h b/drivers/scsi/ufs/ufs_ctmwb.h
new file mode 100644
index 000000000000..073e21a4900b
--- /dev/null
+++ b/drivers/scsi/ufs/ufs_ctmwb.h
@@ -0,0 +1,27 @@
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
+	bool support_ctmwb;
+
+	bool support_ctmwb_lu;
+};
+
+struct ufs_wb_ops *ufshcd_ctmwb_init(void);
+#endif
-- 
2.26.0

