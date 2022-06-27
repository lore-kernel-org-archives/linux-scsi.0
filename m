Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C530C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jun 2022 23:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239135AbiF0X7e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 19:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiF0X7d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 19:59:33 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B814F10FE4
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2022 16:59:30 -0700 (PDT)
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220627235927epoutp035c45a362e4ec2be5cd5c7c566a8ca8f0~8n7Ymtcin0725707257epoutp033
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2022 23:59:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220627235927epoutp035c45a362e4ec2be5cd5c7c566a8ca8f0~8n7Ymtcin0725707257epoutp033
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1656374367;
        bh=fvM+cjBDTIYSiPCr0Gh8EdwWb+A+rG3lJlXsLHxv94I=;
        h=From:To:Cc:Subject:Date:References:From;
        b=pa1CdZxLVKVxzfadsa0Q1ae5vbl9DYr4EvS/rIdqRvaZECBOi3oijgJP99HCKb9/T
         FCfKb7A8fnDL13utIdzj0Mx4u38UgmlQBkbUeeor12f8+PeZh65+F9erv6GcvweZJS
         qitrpQMQVp5Qo9YzITp3O4J8jOyWqay1XzLWbkL4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20220627235927epcas1p41903dacce5e7952a7f7950cb34c2076d~8n7YOQKyu3186231862epcas1p4G;
        Mon, 27 Jun 2022 23:59:27 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.38.248]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LX4TB6N3Rz4x9Q9; Mon, 27 Jun
        2022 23:59:26 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        DF.CB.09678.E544AB26; Tue, 28 Jun 2022 08:59:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220627235926epcas1p22a6327d6c47f48012e853aec3c8b2fe3~8n7XjDjzy0118401184epcas1p2h;
        Mon, 27 Jun 2022 23:59:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220627235926epsmtrp2cbf759496e5d08e80becd486d2dc00fb~8n7XiJbBR1326113261epsmtrp2Z;
        Mon, 27 Jun 2022 23:59:26 +0000 (GMT)
X-AuditID: b6c32a39-e51ff700000025ce-c8-62ba445e5d5f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F8.1E.08905.E544AB26; Tue, 28 Jun 2022 08:59:26 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.100.232]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220627235926epsmtip1f839b91009bbb2ba6d2085921a0708f1~8n7XXvNtg1748417484epsmtip1x;
        Mon, 27 Jun 2022 23:59:26 +0000 (GMT)
From:   Chanwoo Lee <cw9316.lee@samsung.com>
To:     agross@kernel.org, bjorn.andersson@linaro.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     grant.jung@samsung.com, jt77.jang@samsung.com,
        dh0421.hwang@samsung.com, sh043.lee@samsung.com,
        ChanWoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH] scsi: ufs-qcom: Remove unneeded code
Date:   Tue, 28 Jun 2022 08:55:45 +0900
Message-Id: <20220627235545.16943-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKJsWRmVeSWpSXmKPExsWy7bCmgW6cy64kg4W/jCzOPf7NYnF6/zsW
        ixmn2lgt9l07yW7x6+96dotFN7YxWex4fobdovv6DjaL5cf/MVk0/dnH4sDlsWlVJ5vHnWt7
        2DwmLDrA6PHx6S0Wj74tqxg9Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1
        tLQwV1LIS8xNtVVy8QnQdcvMATpNSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNg
        VqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdcev4daaCI/wVL6adY2tgfM/TxcjJISFgIjGj9RJj
        FyMXh5DADkaJq+ea2CCcT4wS3VNeQGW+MUqsmTSRFablxrxjrBCJvYwSq+cvY4JwvjBKnNy8
        n7mLkYODTUBL4vYxb5AGEYF6iWULHjCD1DALdDFK/DrYxQKSEBYwlfi/vIMdxGYRUJVY/OoT
        WC+vgLXEwvNQ98lL/Lnfwwxi8woISpyc+QSslRko3rx1NthMCYGv7BKT5r+Eus5F4sXNWYwQ
        trDEq+Nb2CFsKYnP7/ayQTQ0M0ps+3qJCcLpYJTY2PoCqsNY4tPnz4wgVzALaEqs36UPEVaU
        2Pl7LiPEZj6Jd197WEFKJAR4JTrahCBKVCTmdJ1jg9n18cZjqHs8JK62HAeLCwnESkxY9ptt
        AqP8LCT/zELyzyyExQsYmVcxiqUWFOempxYbFpjCozU5P3cTIzh9alnuYJz+9oPeIUYmDsZD
        jBIczEoivAvP7EwS4k1JrKxKLcqPLyrNSS0+xGgKDOCJzFKiyfnABJ5XEm9oYmlgYmZkYmFs
        aWymJM67atrpRCGB9MSS1OzU1ILUIpg+Jg5OqQamtIe7FY9+eDXJyfJv8v/0yIsx1XUu5156
        CDd+SBPLNV+j5L1cSeWNwybuVKdDumfeJx2OP+2RV8xo5Lvs9uL9M/kcbiWXsaxiyWybc0nF
        oVM9au57+9CHvCfiLkyNef9hp+WNO382Mp6pXSG3/HfmhrbIV6Wy95c+sLXs5RGbrruXLcEv
        tOTUEgWrwMZDUskOiVM+nX/IedLqONPP9OxAj6vc6kp7en0Wuxrpts9c+8bQuV7l9VvWvVPa
        5lgwRnA8fRDcJHpLf6NfZUJAn/2T2ItlXx4wvb3n+rS+3zVyuuobXtHlxU17Sp0s3jGtfDK9
        bXXW5QKfy0uEksrehLZuPf+b3UU17lHY623tzyYpsRRnJBpqMRcVJwIA7F8TUSgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWy7bCSnG6cy64kgyUbpCzOPf7NYnF6/zsW
        ixmn2lgt9l07yW7x6+96dotFN7YxWex4fobdovv6DjaL5cf/MVk0/dnH4sDlsWlVJ5vHnWt7
        2DwmLDrA6PHx6S0Wj74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4Mq4dfw6U8ER/ooX086xNTC+
        5+li5OSQEDCRuDHvGGsXIxeHkMBuRonfzx4yQiSkJHbvP8/WxcgBZAtLHD5cDFHziVHi/Yxr
        YHE2AS2J28e8QeIiAq2MEmtbm5hBHGaBCYwSi6+8ZQYZJCxgKvF/eQc7iM0ioCqx+NUnZpBm
        XgFriYXnoY6Ql/hzvwesnFdAUOLkzCcsIDYzULx562zmCYx8s5CkZiFJLWBkWsUomVpQnJue
        W2xYYJiXWq5XnJhbXJqXrpecn7uJERzMWpo7GLev+qB3iJGJg/EQowQHs5II78IzO5OEeFMS
        K6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYOIR2nwvwT6qkeFj
        C9viGSs9/7Y9EzXd6PKlT8Y16Lj05teqMT4fdk7/t7SraDXz5kMPLWKidR//1niSO+Fp2sLD
        8636Z8hPv/wmjo23jLnkcvH8cwcMlq7dVRLw50yFlfkLmVv/Nc59ucNmt+tGdfWR6lMvDUtX
        crxZ63XcQG1uYHzkn0NvF+zdF/0wqiM4XSRBVOwAb92vxXe8pxw/mqBguuSqU/K0xRfnx5/x
        PSJx5q+8ZOPfP1nuUi7Xb+zeN3NW1pKQL4fnxZ6adVk/ecH9yrXT3/3N4bh1rTT7VniH6tUp
        e8RsnIzfCKeFPGjjmu1ltv7ykZtZsdda1/c2fn/PljB57/Mf09Qqbp95vDnLVomlOCPRUIu5
        qDgRALubLYrVAgAA
X-CMS-MailID: 20220627235926epcas1p22a6327d6c47f48012e853aec3c8b2fe3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220627235926epcas1p22a6327d6c47f48012e853aec3c8b2fe3
References: <CGME20220627235926epcas1p22a6327d6c47f48012e853aec3c8b2fe3@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ChanWoo Lee <cw9316.lee@samsung.com>

Checks information about tx_lanes, but is not used.

Since the commit below is applied, tx_lanes is deprecated.
 'commit 1e1e465c6d23
  ("scsi/ufs: qcom: Remove ufs_qcom_phy_*() calls from host")'

As a result,
ufs_qcom_link_startup_notify -> POST_CHANGE action does nothing.
If it is not going to be updated, it looks like it can be removed.

Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
---
 drivers/ufs/host/ufs-qcom.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index f10d4668814c..473fad83701e 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -58,19 +58,6 @@ static void ufs_qcom_dump_regs_wrapper(struct ufs_hba *hba, int offset, int len,
 	ufshcd_dump_regs(hba, offset, len * 4, prefix);
 }
 
-static int ufs_qcom_get_connected_tx_lanes(struct ufs_hba *hba, u32 *tx_lanes)
-{
-	int err = 0;
-
-	err = ufshcd_dme_get(hba,
-			UIC_ARG_MIB(PA_CONNECTEDTXDATALANES), tx_lanes);
-	if (err)
-		dev_err(hba->dev, "%s: couldn't read PA_CONNECTEDTXDATALANES %d\n",
-				__func__, err);
-
-	return err;
-}
-
 static int ufs_qcom_host_clk_get(struct device *dev,
 		const char *name, struct clk **clk_out, bool optional)
 {
@@ -194,13 +181,6 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 	return err;
 }
 
-static int ufs_qcom_link_startup_post_change(struct ufs_hba *hba)
-{
-	u32 tx_lanes;
-
-	return ufs_qcom_get_connected_tx_lanes(hba, &tx_lanes);
-}
-
 static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 {
 	int err;
@@ -569,9 +549,6 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
 		if (ufshcd_get_local_unipro_ver(hba) != UFS_UNIPRO_VER_1_41)
 			err = ufshcd_disable_host_tx_lcc(hba);
 
-		break;
-	case POST_CHANGE:
-		ufs_qcom_link_startup_post_change(hba);
 		break;
 	default:
 		break;
-- 
2.29.0

