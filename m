Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23AD4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 00:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239221AbiF1ADp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 20:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiF1ADn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 20:03:43 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE51860F5
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2022 17:03:41 -0700 (PDT)
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220628000336epoutp01a94c120f2448032cbcfe6ca77bd382f4~8n-AzajiT3028130281epoutp019
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 00:03:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220628000336epoutp01a94c120f2448032cbcfe6ca77bd382f4~8n-AzajiT3028130281epoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1656374617;
        bh=y0P7p7LdrO9okqEe8nQlKVrQA8fmmMryIq8P6vYPAwg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=d7u/5GZg8zAAwMtq9N6sKyu1kYl8nMbiSBiQr+3+m4RDd0xYjwTvQLSpEmZXHq0md
         jx30siEZR8os5LTLc5jqS4HM/AKhbRIk5WJozFJRJekDo1jwvTLwHZTb6F7o0XDzjI
         x5nP0ziZFiZouFzNU8g4cEu9Oqb5onEAK2J7yn48=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220628000336epcas1p2f9ef524785bd68b3c4a3b98780d3ace2~8n-ASihX50261302613epcas1p2n;
        Tue, 28 Jun 2022 00:03:36 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.36.224]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LX4Yz5r1Yz4x9Pt; Tue, 28 Jun
        2022 00:03:35 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.20.09661.7554AB26; Tue, 28 Jun 2022 09:03:35 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220628000334epcas1p115ab4932e8dc7c6072a8e960a4d9ad3f~8n__4j_6_2758327583epcas1p1x;
        Tue, 28 Jun 2022 00:03:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220628000334epsmtrp1569b606dd8a70138b8e7d0e967599adf~8n__3ZzUr1688516885epsmtrp1-;
        Tue, 28 Jun 2022 00:03:34 +0000 (GMT)
X-AuditID: b6c32a37-2cfff700000025bd-f3-62ba4557186d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CE.AE.08905.6554AB26; Tue, 28 Jun 2022 09:03:34 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.100.232]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220628000334epsmtip1c241a8264859e47a580af16e5f7f2794~8n__owGqY1751617516epsmtip1g;
        Tue, 28 Jun 2022 00:03:34 +0000 (GMT)
From:   Chanwoo Lee <cw9316.lee@samsung.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
        adrian.hunter@intel.com, daejun7.park@samsung.com,
        linux-scsi@vger.kernel.org
Cc:     grant.jung@samsung.com, jt77.jang@samsung.com,
        dh0421.hwang@samsung.com, sh043.lee@samsung.com,
        ChanWoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH] scsi: ufs: Add colon to separate function name and message
Date:   Tue, 28 Jun 2022 08:59:50 +0900
Message-Id: <20220627235950.17218-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmnm64664kg9eX9S1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZosZp9pYLVY9CLfYd+0ku8Wvv+vZLRbd2MZkseP5GXaL7us72CyW
        H//HZNH0Zx+LA5/H5SveHov3vGTymLDoAKPH9/UdbB4fn95i8ejbsorR4/MmOY/2A91MARxR
        2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGcrKZQl
        5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgrMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7Iz
        rl2ew1pwRbXi29qD7A2Mv2W7GDk4JARMJN7tke9i5OIQEtjBKLHl3GfGLkZOIOcTo8SEd/kQ
        9jdGiVXNwSA2SP2hud8YIRr2MkpcXvQRquELo8Sj/xogQ9kEtCRuH/MGqRERuMsosenjY1YQ
        h1mgi1Hi18EuFpAGYQFvicvvXrCDNLAIqEpsvmsLEuYVsJY40zKTBWKZvMSf+z3MEHFBiZMz
        n4DFmYHizVtnM4PMlBCYyyGxtGk+K0SDi8TLHSfYIWxhiVfHt0DZUhIv+9vYIRqaGSW2fb3E
        BOF0MEpsbH3BCFFlLPHpM8j/HEArNCXW79KHCCtK7Pw9lxFiM5/Eu689rJCg45XoaBOCKFGR
        mNN1jg1m18cbj6Hu8ZD4tbaJBRJAsRL7VnQzTmCUn4Xkn1lI/pmFsHgBI/MqRrHUguLc9NRi
        wwJjeJwm5+duYgQnXC3zHYzT3n7QO8TIxMF4iFGCg1lJhHfhmZ1JQrwpiZVVqUX58UWlOanF
        hxhNgQE8kVlKNDkfmPLzSuINTSwNTMyMTCyMLY3NlMR5V007nSgkkJ5YkpqdmlqQWgTTx8TB
        KdXAVCb55NBmp1dHpJMMS07uE3NbtEalK67fgjn7ia3CbS/m6ceuXJj9/jpHfuLu9Cbz/PaV
        LXekrnEYVOTdKtnyuvea5k8X39O8U0o+rr+nPZu5yWbxnETdGxuXCz6Km/GWwfHZu6U5+Xo7
        iu6HLE1M2lUz6+9pD59ajcnmctIsn1pnRpZy3OB7Hzb746nkyaFXfepuWsncfBPT2/35wrGZ
        ZRe3XH6/QJjZa1uulfKZ6tJFZkdtLmk0da19c9n+19+7oSoPvHOes7xb5BYoYf78yG9xQ+X/
        GyS0006Yf7pydut+y1mHuWp4z1sXSbbqX9+4z2hm0q94j0tXOWvKpS0sBXdv7Jr4bNLDyuh1
        lrP+HFNiKc5INNRiLipOBAC4soXoQQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWy7bCSnG6Y664kg837DSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZosZp9pYLVY9CLfYd+0ku8Wvv+vZLRbd2MZkseP5GXaL7us72CyW
        H//HZNH0Zx+LA5/H5SveHov3vGTymLDoAKPH9/UdbB4fn95i8ejbsorR4/MmOY/2A91MARxR
        XDYpqTmZZalF+nYJXBnXLs9hLbiiWvFt7UH2Bsbfsl2MnBwSAiYSh+Z+Y+xi5OIQEtjNKPH2
        3zRWiISUxO7959m6GDmAbGGJw4eLIWo+MUr8n7sbLM4moCVx+5g3SFxE4DmjxJ3+68wgDrPA
        BEaJxVfeMoMMEhbwlrj87gU7SAOLgKrE5ru2IGFeAWuJMy0zWSB2yUv8ud/DDBEXlDg58wlY
        nBko3rx1NvMERr5ZSFKzkKQWMDKtYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIjgIt
        zR2M21d90DvEyMTBeIhRgoNZSYR34ZmdSUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcS
        SE8sSc1OTS1ILYLJMnFwSjUwzWV7/fu7wYNX6bymXzIs1EycyhvZD1RzzTzYqip0IGa/1oPV
        T9/U/D291v1d2CT1+y8/fmLgXaxk+P5b2OeYYysZuNtTfllqT+rid0upzL0xLYv3tOSHjZU6
        h69bixX5cPMuFA+Yb/rl9g7W+g/NbY9NdHtMnPdeyD145o/v2odrRB+zHcr1/er/Kkv9SX73
        jK66ZwoVav/VXJSvPa9QqnVo72DaL7b8xZHNb4pm3GENe2YkOUNyxrbPa3b4Hfh/71NP7MaT
        rOxX+hwEVP9P+TfvgNNXyyWHtu9T64mYreM4+WP0rr4LawQ7Dl2zNfJQjNgy58XdC1vq7nCF
        dbFkJn22nOG9Zmn6tsPWZku//1ZiKc5INNRiLipOBAB22a6r8QIAAA==
X-CMS-MailID: 20220628000334epcas1p115ab4932e8dc7c6072a8e960a4d9ad3f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220628000334epcas1p115ab4932e8dc7c6072a8e960a4d9ad3f
References: <CGME20220628000334epcas1p115ab4932e8dc7c6072a8e960a4d9ad3f@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ChanWoo Lee <cw9316.lee@samsung.com>

If the function name and message are long,
The output will be as below, and it is difficult to check the log.
- ufshcd_wb_toggle_flush_during_h8 WB-Buf Flush during H8 enabled

Separate the function name and message to make it easier to check the log.

Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 20 ++++++++++----------
 drivers/ufs/core/ufshpb.c |  6 +++---
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1c6136040bbe..ac5a24beb7a1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4455,7 +4455,7 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 		QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL);
 	if (err) {
 		dev_err(hba->dev,
-			"%s setting fDeviceInit flag failed with error %d\n",
+			"%s: setting fDeviceInit flag failed with error %d\n",
 			__func__, err);
 		goto out;
 	}
@@ -4472,11 +4472,11 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 
 	if (err) {
 		dev_err(hba->dev,
-				"%s reading fDeviceInit flag failed with error %d\n",
+				"%s: reading fDeviceInit flag failed with error %d\n",
 				__func__, err);
 	} else if (flag_res) {
 		dev_err(hba->dev,
-				"%s fDeviceInit was not cleared by the device\n",
+				"%s: fDeviceInit was not cleared by the device\n",
 				__func__);
 		err = -EBUSY;
 	}
@@ -5740,13 +5740,13 @@ int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable)
 
 	ret = __ufshcd_wb_toggle(hba, enable, QUERY_FLAG_IDN_WB_EN);
 	if (ret) {
-		dev_err(hba->dev, "%s Write Booster %s failed %d\n",
+		dev_err(hba->dev, "%s: Write Booster %s failed %d\n",
 			__func__, enable ? "enable" : "disable", ret);
 		return ret;
 	}
 
 	hba->dev_info.wb_enabled = enable;
-	dev_info(hba->dev, "%s Write Booster %s\n",
+	dev_info(hba->dev, "%s: Write Booster %s\n",
 			__func__, enable ? "enabled" : "disabled");
 
 	return ret;
@@ -5763,7 +5763,7 @@ static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 			__func__, set ? "enable" : "disable", ret);
 		return;
 	}
-	dev_dbg(hba->dev, "%s WB-Buf Flush during H8 %s\n",
+	dev_dbg(hba->dev, "%s: WB-Buf Flush during H8 %s\n",
 			__func__, set ? "enabled" : "disabled");
 }
 
@@ -5777,14 +5777,14 @@ static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
 
 	ret = __ufshcd_wb_toggle(hba, enable, QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN);
 	if (ret) {
-		dev_err(hba->dev, "%s WB-Buf Flush %s failed %d\n", __func__,
+		dev_err(hba->dev, "%s: WB-Buf Flush %s failed %d\n", __func__,
 			enable ? "enable" : "disable", ret);
 		return;
 	}
 
 	hba->dev_info.wb_buf_flush_enabled = enable;
 
-	dev_dbg(hba->dev, "%s WB-Buf Flush %s\n",
+	dev_dbg(hba->dev, "%s: WB-Buf Flush %s\n",
 			__func__, enable ? "enabled" : "disabled");
 }
 
@@ -5800,7 +5800,7 @@ static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
 					      QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE,
 					      index, 0, &cur_buf);
 	if (ret) {
-		dev_err(hba->dev, "%s dCurWriteBoosterBufferSize read failed %d\n",
+		dev_err(hba->dev, "%s: dCurWriteBoosterBufferSize read failed %d\n",
 			__func__, ret);
 		return false;
 	}
@@ -5885,7 +5885,7 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 				      QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE,
 				      index, 0, &avail_buf);
 	if (ret) {
-		dev_warn(hba->dev, "%s dAvailableWriteBoosterBufferSize read failed %d\n",
+		dev_warn(hba->dev, "%s: dAvailableWriteBoosterBufferSize read failed %d\n",
 			 __func__, ret);
 		return false;
 	}
diff --git a/drivers/ufs/core/ufshpb.c b/drivers/ufs/core/ufshpb.c
index de2bb8401bc4..c18147d85eb2 100644
--- a/drivers/ufs/core/ufshpb.c
+++ b/drivers/ufs/core/ufshpb.c
@@ -2286,7 +2286,7 @@ static bool ufshpb_check_hpb_reset_query(struct ufs_hba *hba)
 	/* wait for the device to complete HPB reset query */
 	for (try = 0; try < HPB_RESET_REQ_RETRIES; try++) {
 		dev_dbg(hba->dev,
-			"%s start flag reset polling %d times\n",
+			"%s: start flag reset polling %d times\n",
 			__func__, try);
 
 		/* Poll fHpbReset flag to be cleared */
@@ -2295,7 +2295,7 @@ static bool ufshpb_check_hpb_reset_query(struct ufs_hba *hba)
 
 		if (err) {
 			dev_err(hba->dev,
-				"%s reading fHpbReset flag failed with error %d\n",
+				"%s: reading fHpbReset flag failed with error %d\n",
 				__func__, err);
 			return flag_res;
 		}
@@ -2307,7 +2307,7 @@ static bool ufshpb_check_hpb_reset_query(struct ufs_hba *hba)
 	}
 	if (flag_res) {
 		dev_err(hba->dev,
-			"%s fHpbReset was not cleared by the device\n",
+			"%s: fHpbReset was not cleared by the device\n",
 			__func__);
 	}
 out:
-- 
2.29.0

