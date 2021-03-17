Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51567C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 03:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FCE464F21
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 03:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhCQDc3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 23:32:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34351 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhCQDb5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 23:31:57 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210317033156epoutp0393b9691561b5acbcda2637c14f5f5f05~tA7S4AATo0560105601epoutp03n
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 03:31:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210317033156epoutp0393b9691561b5acbcda2637c14f5f5f05~tA7S4AATo0560105601epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1615951916;
        bh=SjjvZfmSAxkwTLR5wOIxf3VFHOs2h4R0KlFyF6VAN1Y=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=cWbWmdT+dXmEefZc1Gw4aYjQjwDQ0xbFIPNJdh4SD36s+LzgIfKEYvjr++BxeOZ8A
         JB34/z3Qq6cBkMFDsn2qP6WtDrltYcx7J/AwrRNInioCZcyJ9FRlizlOxMfNl35eQ3
         0YY5kb1XmUd9lBYrkYurRaLRnOrKQ9AxO0W+6yMg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210317033155epcas2p201bd59112e1d1819f5ba09a1085d0283~tA7R8Q7a80353803538epcas2p2B;
        Wed, 17 Mar 2021 03:31:54 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4F0bLJ6sCyz4x9Q0; Wed, 17 Mar
        2021 03:31:52 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-f6-60517820764e
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        B0.80.52511.02871506; Wed, 17 Mar 2021 12:31:44 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Add selector to ufshcd_query_flag* APIs
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
CC:     JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210317033143epcms2p25b37bba2bb515c1ce85bf555656ca3f2@epcms2p2>
Date:   Wed, 17 Mar 2021 12:31:43 +0900
X-CMS-MailID: 20210317033143epcms2p25b37bba2bb515c1ce85bf555656ca3f2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJsWRmVeSWpSXmKPExsWy7bCmqa5CRWCCwdK3whYP5m1js9jbdoLd
        4uXPq2wWh2+/Y7eY9uEns8Wn9ctYLV4e0rRY9SDcYs7ZBiaL3v6tbBaLbmxjsuj/185icXnX
        HDaL7us72CyWH//HZHF7C5fF0q03GS06p69hcRDyuHzF2+NyXy+Tx85Zd9k9Jiw6wOjRcnI/
        i8fHp7dYPPq2rGL0+LxJzqP9QDdTAGdUjk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
        pYW5kkJeYm6qrZKLT4CuW2YO0DdKCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAJD
        wwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjLW/hQqWG1RM/qXQwLhMvYuRk0NCwERiXvMqli5G
        Lg4hgR2MEh2zfzJ2MXJw8AoISvzdIQxSIyzgLNHROYMNxBYSUJJYf3EWO0RcT+LWwzWMIDab
        gI7E9BP32UHmiAjcZZHYcf4bI4jDLHCJUaJ3+3smiG28EjPan7JA2NIS25dvZYSwNSR+LOtl
        hrBFJW6ufssOY78/Nh+qRkSi9d5ZqBpBiQc/d0PFJSWO7f4ANb9eYuudX2CLJQR6GCUO77zF
        CpHQl7jWsRFsMa+Ar0THvKnsIF+yCKhK7HqaC1HiIrF971qwL5kF5CW2v53DDFLCLKApsX6X
        PogpIaAsceQWC8wnDRt/s6OzmQX4JDoO/4WL75j3BOoyNYl1P9czQYyRkbg1j3ECo9IsREDP
        QrJ2FsLaBYzMqxjFUguKc9NTi40KTJBjdhMjOFlreexgnP32g94hRiYOxkOMEhzMSiK8pnkB
        CUK8KYmVValF+fFFpTmpxYcYTYH+ncgsJZqcD8wXeSXxhqZGZmYGlqYWpmZGFkrivEUGD+KF
        BNITS1KzU1MLUotg+pg4OKUamAy9m/esz1VW90+sX3uuv9k0tOf2rw0tR1pt7t7aFMHxP1NH
        4dyzW7ZvuooZjjLGxs3Tqlj190KTde+B7a5FzK0vt3nWTvYP+pTN0ivxvmb9toaHOomXaydz
        WTiLbnmo0K7dxBlu2nXD+2y08a2gTvcJb7ncZ/zR4w0UuafrLBujfKw0ryZxaVLbO4bky1oe
        gRUvXkd6cd26nxr7m+Xxzk+XNqhrH39QVVM261GU0qIf8u4s3O4Pe1ULeIJ+OrGLvlz++ar9
        nFN7X+7WvXdLKo3NrP7WlPC1hxbFMvi9i5TNKTfqE09foDxV2kJ5rcSOWTc4OvJqZi/TPb7o
        +L0o5ejpbalNX/Krg481C11RYinOSDTUYi4qTgQA1Qkx9l8EAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210317033143epcms2p25b37bba2bb515c1ce85bf555656ca3f2
References: <CGME20210317033143epcms2p25b37bba2bb515c1ce85bf555656ca3f2@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unlike other query APIs in UFS, ufshcd_query_flag has a fixed selector
as 0. This patch allows ufshcd_query_flag API to choose selector value
by parameter.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufs-sysfs.c |  2 +-
 drivers/scsi/ufs/ufshcd.c    | 29 +++++++++++++++++------------
 drivers/scsi/ufs/ufshcd.h    |  2 +-
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index acc54f530f2d..606b058a3394 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -746,7 +746,7 @@ static ssize_t _name##_show(struct device *dev,				\
 		index = ufshcd_wb_get_query_index(hba);			\
 	pm_runtime_get_sync(hba->dev);					\
 	ret = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,	\
-		QUERY_FLAG_IDN##_uname, index, &flag);			\
+		QUERY_FLAG_IDN##_uname, index, &flag, 0);		\
 	pm_runtime_put_sync(hba->dev);					\
 	if (ret) {							\
 		ret = -EINVAL;						\
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8c0ff024231c..c2fd9c58d6b8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2940,13 +2940,15 @@ static inline void ufshcd_init_query(struct ufs_hba *hba,
 }
 
 static int ufshcd_query_flag_retry(struct ufs_hba *hba,
-	enum query_opcode opcode, enum flag_idn idn, u8 index, bool *flag_res)
+	enum query_opcode opcode, enum flag_idn idn, u8 index, bool *flag_res,
+	u8 selector)
 {
 	int ret;
 	int retries;
 
 	for (retries = 0; retries < QUERY_REQ_RETRIES; retries++) {
-		ret = ufshcd_query_flag(hba, opcode, idn, index, flag_res);
+		ret = ufshcd_query_flag(hba, opcode, idn, index, flag_res,
+					selector);
 		if (ret)
 			dev_dbg(hba->dev,
 				"%s: failed with error %d, retries %d\n",
@@ -2969,15 +2971,17 @@ static int ufshcd_query_flag_retry(struct ufs_hba *hba,
  * @idn: flag idn to access
  * @index: flag index to access
  * @flag_res: the flag value after the query request completes
+ * @selector: selector field
  *
  * Returns 0 for success, non-zero in case of failure
  */
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
-			enum flag_idn idn, u8 index, bool *flag_res)
+			enum flag_idn idn, u8 index, bool *flag_res,
+			u8 selector)
 {
 	struct ufs_query_req *request = NULL;
 	struct ufs_query_res *response = NULL;
-	int err, selector = 0;
+	int err;
 	int timeout = QUERY_REQ_TIMEOUT;
 
 	BUG_ON(!hba);
@@ -4331,7 +4335,7 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 	ktime_t timeout;
 
 	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
-		QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL);
+		QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL, 0);
 	if (err) {
 		dev_err(hba->dev,
 			"%s setting fDeviceInit flag failed with error %d\n",
@@ -4343,7 +4347,8 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 	timeout = ktime_add_ms(ktime_get(), FDEVICEINIT_COMPL_TIMEOUT);
 	do {
 		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
-					QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
+					QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res,
+					0);
 		if (!flag_res)
 			break;
 		usleep_range(5000, 10000);
@@ -5250,7 +5255,7 @@ static int ufshcd_enable_auto_bkops(struct ufs_hba *hba)
 		goto out;
 
 	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
-			QUERY_FLAG_IDN_BKOPS_EN, 0, NULL);
+			QUERY_FLAG_IDN_BKOPS_EN, 0, NULL, 0);
 	if (err) {
 		dev_err(hba->dev, "%s: failed to enable bkops %d\n",
 				__func__, err);
@@ -5300,7 +5305,7 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 	}
 
 	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
-			QUERY_FLAG_IDN_BKOPS_EN, 0, NULL);
+			QUERY_FLAG_IDN_BKOPS_EN, 0, NULL, 0);
 	if (err) {
 		dev_err(hba->dev, "%s: failed to disable bkops %d\n",
 				__func__, err);
@@ -5463,7 +5468,7 @@ int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 
 	index = ufshcd_wb_get_query_index(hba);
 	ret = ufshcd_query_flag_retry(hba, opcode,
-				      QUERY_FLAG_IDN_WB_EN, index, NULL);
+				      QUERY_FLAG_IDN_WB_EN, index, NULL, 0);
 	if (ret) {
 		dev_err(hba->dev, "%s write booster %s failed %d\n",
 			__func__, enable ? "enable" : "disable", ret);
@@ -5490,7 +5495,7 @@ static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 	index = ufshcd_wb_get_query_index(hba);
 	return ufshcd_query_flag_retry(hba, val,
 				QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8,
-				index, NULL);
+				index, NULL, 0);
 }
 
 static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
@@ -5511,7 +5516,7 @@ static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
 	index = ufshcd_wb_get_query_index(hba);
 	ret = ufshcd_query_flag_retry(hba, opcode,
 				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, index,
-				      NULL);
+				      NULL, 0);
 	if (ret) {
 		dev_err(hba->dev, "%s WB-Buf Flush %s failed %d\n", __func__,
 			enable ? "enable" : "disable", ret);
@@ -7751,7 +7756,7 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 	ufshcd_get_ref_clk_gating_wait(hba);
 
 	if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
-			QUERY_FLAG_IDN_PWR_ON_WPE, 0, &flag))
+			QUERY_FLAG_IDN_PWR_ON_WPE, 0, &flag, 0))
 		hba->dev_info.f_power_on_wp_en = flag;
 
 	/* Probe maximum power mode co-supported by both UFS host and device */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 1af91661dc83..67a26b2be36f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1077,7 +1077,7 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
-	enum flag_idn idn, u8 index, bool *flag_res);
+	enum flag_idn idn, u8 index, bool *flag_res, u8 selector);
 
 void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
-- 
2.25.1

