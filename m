Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B795C7C88A
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B440214D8
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DPRsnYTD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgDZRmQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 13:42:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33761 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgDZRmN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 13:42:13 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200426174211epoutp034903be521abbbfcd2b3a75feffad5bf4~Jb34sQ1ni0343203432epoutp03f
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 17:42:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200426174211epoutp034903be521abbbfcd2b3a75feffad5bf4~Jb34sQ1ni0343203432epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587922931;
        bh=kDIy4u6dKypJDeZVrGE9ZKceZgeyPXJh8PvB97xxnQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPRsnYTD+twF8Bomcthr8yCQLDKZdh1N5SvRkWX81TbbRxdZ7udW/R0m6qjXMPB7z
         GhtN/7vjs+ICzQo5n04tlWC2EdhJmIPW6/UcTZHVRUaf/Om3hnqfmrWDrUWHgGoqXR
         sv9RqB17QM1viCPXoazRAk3zdBqvtivtE/3oFdYo=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200426174209epcas5p1284ff3ef56513a18dbd5997f146f7067~Jb33aBmZb1407714077epcas5p1f;
        Sun, 26 Apr 2020 17:42:09 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.DE.04736.1F7C5AE5; Mon, 27 Apr 2020 02:42:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200426174209epcas5p2fc312fae0c619674bfd784d8659d3b97~Jb32mZNUi0368603686epcas5p2g;
        Sun, 26 Apr 2020 17:42:09 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200426174209epsmtrp2335ed61fb58fc1930a17db85369ad393~Jb32lpykY1150211502epsmtrp2W;
        Sun, 26 Apr 2020 17:42:09 +0000 (GMT)
X-AuditID: b6c32a4b-acbff70000001280-fc-5ea5c7f18355
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.FF.18461.0F7C5AE5; Mon, 27 Apr 2020 02:42:08 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200426174207epsmtip16c4acfbd2fb4adc4230258ac30e25a43~Jb30wGKon2817828178epsmtip1J;
        Sun, 26 Apr 2020 17:42:06 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v7 03/10] scsi: ufs: add quirk to enable host controller
 without hce
Date:   Sun, 26 Apr 2020 23:00:17 +0530
Message-Id: <20200426173024.63069-4-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200426173024.63069-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsWy7bCmlu7H40vjDPrPmlk8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujFkvDrEVbJCraGr8wtTAeEqii5GTQ0LARGLvi6esXYxcHEICuxklLlx5yg7h
        fGKU2D/tJBOE841R4ubZLYwwLfMnNTFDJPYySlx5tYERwmlhktjX0AVWxSagLXF3+hYmEFtE
        QFjiyLc2sDizwA0miQcrXUBsYYEwiaYLS8DiLAKqEl/OTgCzeQVsJLa9mMsEsU1eYvWGA8wg
        NqeArcSpGbvATpIQ6OSQ6HlwjBWiyEWid9ElZghbWOLV8S3sELaUxOd3e9m6GDmA7GyJnl3G
        EOEaiaXzjrFA2PYSB67MYQEpYRbQlFi/Sx/iTD6J3t9PmCA6eSU62oQgqlUlmt9dheqUlpjY
        3Q11gIfEgQmzoIE1gVHi4JxOpgmMsrMQpi5gZFzFKJlaUJybnlpsWmCcl1quV5yYW1yal66X
        nJ+7iRGcULS8dzBuOudziFGAg1GJh5dj+9I4IdbEsuLK3EOMEhzMSiK8MSWL4oR4UxIrq1KL
        8uOLSnNSiw8xSnOwKInzTmK9GiMkkJ5YkpqdmlqQWgSTZeLglGpgbFwh6DiVS8z9cDqr0Ymo
        2dOl96513yptM/3qZWedE13n5ySzrY8/V/zqZfqk2/5T5NJP6iZM+cX+Pl5aXGembOvelRsf
        7hNY+/Rq6FbONV99X7gdLhaLzU9RvXhwSt1Mn0S2GqXJf+5+PmcssvlOqq7jz4JJLV6SLX/2
        GMq7Fpd7CTXzfs6/qMRSnJFoqMVcVJwIAFsPG94kAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsWy7bCSnO7H40vjDLpdLR7M28Zm8fLnVTaL
        T+uXsVrMP3KO1eL8+Q3sFje3HGWx2PT4GqvF5V1z2CxmnN/HZNF9fQebxfLj/5gs/u/ZwW6x
        dOtNRgdej8t9vUwem1Z1snlsXlLv0XJyP4vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBHFJdNSmpO
        Zllqkb5dAlfGrBeH2Ao2yFU0NX5hamA8JdHFyMkhIWAiMX9SE3MXIxeHkMBuRonvP/czQiSk
        Ja5vnMAOYQtLrPz3nB2iqIlJ4uiij8wgCTYBbYm707cwgdgiQEVHvrWBNTMLPGOSOPWwFMQW
        FgiReLj8HNggFgFViS9nJ4DV8ArYSGx7MZcJYoG8xOoNB8BmcgrYSpyasQsozgG0zEZi+nr/
        CYx8CxgZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBIeyluYOxu2rPugdYmTiYDzE
        KMHBrCTCG1OyKE6INyWxsiq1KD++qDQntfgQozQHi5I4743ChXFCAumJJanZqakFqUUwWSYO
        TqkGpu75xzenpa77UqzI+CDgLe/zt0aCnA/4NrjdaXS7y+r3+tIv3scz5rUdTZ6iIVEWPGdr
        pLv6zSUVW/3mtzGUaezp/iw3r2mTp1RcrszEXW2qS5/4p+qv38q1bdqXqT4PJhk3WC9Y8+XE
        06Xawj38t93bH0VNXbFqqbh/qUHodNY9H91YFbN+3/C4f2RrhqeIS6hGS6LnkercVQEhL3fP
        +at15jXfxKuKloqZFd/4Jl+/tWjbcZ9dTyMkPnxfNTlISFQnSkqr9Oz3qLfTMq4WXHxkvLPr
        9bdc760898ra1d9NZNhg5Gmas6lTVPK21mf3cJ7PG3leGu6dqurFY71oZdGz3beMEpXKrt08
        yNvjm67EUpyRaKjFXFScCAAXe6k61AIAAA==
X-CMS-MailID: 20200426174209epcas5p2fc312fae0c619674bfd784d8659d3b97
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200426174209epcas5p2fc312fae0c619674bfd784d8659d3b97
References: <20200426173024.63069-1-alim.akhtar@samsung.com>
        <CGME20200426174209epcas5p2fc312fae0c619674bfd784d8659d3b97@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some host controllers don't support host controller enable via HCE.

Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 76 +++++++++++++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h |  6 ++++
 2 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0e9704da58bd..ee30ed6cc805 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3534,6 +3534,52 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 			"dme-link-startup: error code %d\n", ret);
 	return ret;
 }
+/**
+ * ufshcd_dme_reset - UIC command for DME_RESET
+ * @hba: per adapter instance
+ *
+ * DME_RESET command is issued in order to reset UniPro stack.
+ * This function now deal with cold reset.
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int ufshcd_dme_reset(struct ufs_hba *hba)
+{
+	struct uic_command uic_cmd = {0};
+	int ret;
+
+	uic_cmd.command = UIC_CMD_DME_RESET;
+
+	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
+	if (ret)
+		dev_err(hba->dev,
+			"dme-reset: error code %d\n", ret);
+
+	return ret;
+}
+
+/**
+ * ufshcd_dme_enable - UIC command for DME_ENABLE
+ * @hba: per adapter instance
+ *
+ * DME_ENABLE command is issued in order to enable UniPro stack.
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int ufshcd_dme_enable(struct ufs_hba *hba)
+{
+	struct uic_command uic_cmd = {0};
+	int ret;
+
+	uic_cmd.command = UIC_CMD_DME_ENABLE;
+
+	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
+	if (ret)
+		dev_err(hba->dev,
+			"dme-reset: error code %d\n", ret);
+
+	return ret;
+}
 
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
 {
@@ -4251,7 +4297,7 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba, bool can_sleep)
 }
 
 /**
- * ufshcd_hba_enable - initialize the controller
+ * ufshcd_hba_execute_hce - initialize the controller
  * @hba: per adapter instance
  *
  * The controller resets itself and controller firmware initialization
@@ -4260,7 +4306,7 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba, bool can_sleep)
  *
  * Returns 0 on success, non-zero value on failure
  */
-int ufshcd_hba_enable(struct ufs_hba *hba)
+static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 {
 	int retry;
 
@@ -4308,6 +4354,32 @@ int ufshcd_hba_enable(struct ufs_hba *hba)
 
 	return 0;
 }
+
+int ufshcd_hba_enable(struct ufs_hba *hba)
+{
+	int ret;
+
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_HCE) {
+		ufshcd_set_link_off(hba);
+		ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE);
+
+		/* enable UIC related interrupts */
+		ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
+		ret = ufshcd_dme_reset(hba);
+		if (!ret) {
+			ret = ufshcd_dme_enable(hba);
+			if (!ret)
+				ufshcd_vops_hce_enable_notify(hba, POST_CHANGE);
+			if (ret)
+				dev_err(hba->dev,
+					"Host controller enable failed with non-hce\n");
+		}
+	} else {
+		ret = ufshcd_hba_execute_hce(hba);
+	}
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(ufshcd_hba_enable);
 
 static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 53096642f9a8..f8d08cb9caf7 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -529,6 +529,12 @@ enum ufshcd_quirks {
 	 * that the interrupt aggregation timer and counter are reset by s/w.
 	 */
 	UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		= 1 << 7,
+
+	/*
+	 * This quirks needs to be enabled if host controller cannot be
+	 * enabled via HCE register.
+	 */
+	UFSHCI_QUIRK_BROKEN_HCE				= 1 << 8,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

