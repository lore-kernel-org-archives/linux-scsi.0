Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E223FC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 09:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3E1020729
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 09:57:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WwSwtO5a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgGUJ5E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 05:57:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43768 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729092AbgGUJ5D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 05:57:03 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200721095659epoutp03e4b93f48438a88a1fd144f424e431879~jvAREj4372931329313epoutp03v
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:56:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200721095659epoutp03e4b93f48438a88a1fd144f424e431879~jvAREj4372931329313epoutp03v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595325419;
        bh=rd4VJL9aR4XGc0vFytnDoTMRfRCxRzDDk60H09CpOXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwSwtO5ajmSstCTu2+tlAJBR7F/owKiiEcJxmG9IdmrIZiSa28bA0CKWAo+4k3ox+
         u55/vS4O+FjnpyGlSPUXUMu3r1hva0XAmGYd5YD+TJIBri3SdXCmW/bszmXD0bMBrV
         TUShcQROGJvYDRi7rCmdimlB6L43JNxx9yDQ+iS0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200721095659epcas2p469651b7e3c0f27e25003fef5f6539294~jvAQq5HoO2747527475epcas2p4g;
        Tue, 21 Jul 2020 09:56:59 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.184]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4B9vBw2XcszMqYkZ; Tue, 21 Jul
        2020 09:56:56 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.82.27441.7EBB61F5; Tue, 21 Jul 2020 18:56:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200721095655epcas2p13c10101ef53de47384762754271c1ca5~jvAM7aQtQ0338903389epcas2p1K;
        Tue, 21 Jul 2020 09:56:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200721095655epsmtrp228418f30d2a710935b9e6621b2ddbf0f~jvAM6rB1m0181101811epsmtrp2a;
        Tue, 21 Jul 2020 09:56:55 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-d7-5f16bbe7e322
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7A.3A.08303.6EBB61F5; Tue, 21 Jul 2020 18:56:55 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [12.36.155.109]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200721095654epsmtip2e0651e38156d9db62de112dca8a54e2f~jvAMwl4Lh0498004980epsmtip2E;
        Tue, 21 Jul 2020 09:56:54 +0000 (GMT)
From:   SEO HOYOUNG <hy50.seo@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com
Cc:     SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [RFC PATCH v3 3/3] scsi: ufs: add vendor specific write booster
Date:   Tue, 21 Jul 2020 18:57:12 +0900
Message-Id: <f509c9bc4847f3f0527fb0c8a5b0aa68c223418e.1595325064.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595325064.git.hy50.seo@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmqe7z3WLxBp1r1CwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mB26Py1e8
        PS739TJ5TFh0gNHj+/oONo+PT2+xePRtWcXo8XmTnEf7gW6mAI6oHJuM1MSU1CKF1Lzk/JTM
        vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoEOVFMoSc0qBQgGJxcVK+nY2Rfml
        JakKGfnFJbZKqQUpOQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5GbM/XGAq2B1a0X+vnamB
        ca5bFyMnh4SAicS55U9Yuhi5OIQEdjBKrG7YwwrhfGKU2P/vDZTzmVHi1vZXbDAthy/PZIJI
        7GKU6PtzHSwhJPCDUWL5Sg8Qm01AQ2LNsUNgRSICHxgljq6YzQqSYBZQk/h8dxkLiC0s4CFx
        bFYXI4jNIqAq8fXDXrBBvAJREj8Oz2CB2CYvsajhNxOIzSlgIXF29nl2iBpBiZMzn7BAzJSX
        aN46mxlkmYTATA6JA0veMEM0u0hc/bOZEcIWlnh1fAs7hC0l8fndXqh36iWm3FvFAtHcwyix
        Z8UJJoiEscSsZ+1AzRxAGzQl1u/SBzElBJQljtyC2ssn0XH4LztEmFeio00IolFJ4szc21Bh
        CYmDs3Mgwh4S93cuh4ZbN6NE0/kupgmMCrOQfDMLyTezEPYuYGRexSiWWlCcm55abFRgjBzD
        mxjBKVfLfQfjjLcf9A4xMnEwHmKU4GBWEuGdyCMcL8SbklhZlVqUH19UmpNafIjRFBjWE5ml
        RJPzgUk/ryTe0NTIzMzA0tTC1MzIQkmct9jqQpyQQHpiSWp2ampBahFMHxMHp1QDU/jy0FUf
        +9q+rrMTSovVqpguPu3Z7Spn7uJdEQ1zal23vLWqS54k3d216kR7ivNBea+SjpurQ3i9pgYZ
        mnLdP95za/naL3W87MLehsbPlGqZ8lb7Zb6Pu3fSqGAtr9e0dwltH9jCJp1vuBOb0h38/U7C
        5+s+oj9fLe7ZrD93wtYSzpk+WT9XPs/nndMgqpGSaHtUPOHpxPy5jLONc00iqkxei5VdYfR7
        fcnjQSJb9gMuqavGPzOivqkr9erttdP8kVekwWzw5N8E88KsnBU+s9p/u5vb506Rq5K2Tn17
        a1vksY0uPPlcBxNOZ3y+bGPF9DUka54+14cD+V4bahMkK5Od3eN+c3FYHpyx6a8SS3FGoqEW
        c1FxIgD+5dOOQgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSvO7z3WLxBgumM1o8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7Lovr6DzWL58X9MDtwel694
        e1zu62XymLDoAKPH9/UdbB4fn95i8ejbsorR4/MmOY/2A91MARxRXDYpqTmZZalF+nYJXBmz
        P1xgKtgdWtF/r52pgXGuWxcjJ4eEgInE4cszmboYuTiEBHYwSqzre80KkZCQ+L+4iQnCFpa4
        33KEFaLoG6PEj4577CAJNgENiTXHDoEViQj8YZSYdDoOxGYWUJP4fHcZC4gtLOAhcWxWFyOI
        zSKgKvH1w142EJtXIErix+EZLBAL5CUWNfwGm8MpYCFxdvZ5oPkcQMvMJWZfLYQoF5Q4OfMJ
        C8R4eYnmrbOZJzAKzEKSmoUktYCRaRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnBk
        aGntYNyz6oPeIUYmDsZDjBIczEoivBN5hOOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ836dtTBO
        SCA9sSQ1OzW1ILUIJsvEwSnVwJR5d2WyfNQK7vtFzZcqZjFxfWSbc4+h+OIdsxg3/iPtZVru
        ahmG3j5v7snemJBi65nG+H9q0utN9aqH2xLrj2gLL+yfpJl8+PmrtKWlNVeyNk7eG7J15g8z
        rqP6i4UL/Bev2aK8czXDy6XVJV6OordMOju+2ZXtm/yvccetGw7pk1WFErnN+CPcHiRySq26
        eDu3pGr+DtNnRwsvyybrpd3oXP9T/tv+V2UPou/GL9XzmHV26cc8p5XTm9cpLPxY+67LJiG7
        4GSNblBd9N7CS9OVVJZe3hLm/Do4KPZH+00v3SM7fNNymO6vSttSUHI6/l5M54OvZzRC++Un
        VTAft+kRFRC3kG9SPfnBsrGJR4mlOCPRUIu5qDgRAPtTHKj7AgAA
X-CMS-MailID: 20200721095655epcas2p13c10101ef53de47384762754271c1ca5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200721095655epcas2p13c10101ef53de47384762754271c1ca5
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095655epcas2p13c10101ef53de47384762754271c1ca5@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To support the fuction of writebooster by vendor.
The WB behavior that the vendor wants is slightly different.
But we have to support it

Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
---
 drivers/scsi/ufs/Makefile     |   1 +
 drivers/scsi/ufs/ufs-exynos.c |   6 +
 drivers/scsi/ufs/ufs_ctmwb.c  | 270 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs_ctmwb.h  |  26 ++++
 4 files changed, 303 insertions(+)
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
-- 
2.26.0

