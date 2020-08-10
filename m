Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191E5C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC5012073A
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:05:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tx/g3DDN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgHJGFF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 02:05:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11374 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgHJGFF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 02:05:05 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200810060502epoutp01b6083dd917412f00924f252bb1daf667~p0vcxr9KG2244822448epoutp01D
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2020 06:05:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200810060502epoutp01b6083dd917412f00924f252bb1daf667~p0vcxr9KG2244822448epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1597039502;
        bh=uYp50+se1IM6kHOIxJlMXCxgM0t423FCLXlE+21mb+A=;
        h=From:To:Cc:Subject:Date:References:From;
        b=tx/g3DDN+lSMdMKd3mZy4PPLu/XvOZC3Yz2glpr2Rj/8fBlmUx0fwxdeqGGQX8TnW
         2d3aTg7/0gfIB5JyWryRWsCw6znGfwFPpE4fwfxdXJdDhKTLhOPxWGrihmnqOD0ftr
         ygyfjskrb0PFmEX5ozTWnJYO4/OtZZMmMUyFnNgQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200810060500epcas2p190622855b9f1e7f6935de61b081f5fd3~p0vblv-D10111501115epcas2p1B;
        Mon, 10 Aug 2020 06:05:00 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.186]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4BQ5623V3XzMqYkg; Mon, 10 Aug
        2020 06:04:58 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.BB.19322.A83E03F5; Mon, 10 Aug 2020 15:04:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200810060457epcas2p3023e61584089a0f285338d7e04ccaefe~p0vY3gL1j1937319373epcas2p3-;
        Mon, 10 Aug 2020 06:04:57 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200810060457epsmtrp2de265b143aa280334910b2176a71d5dc~p0vY2mGbN1483514835epsmtrp2e;
        Mon, 10 Aug 2020 06:04:57 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-65-5f30e38a863b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        60.DC.08382.983E03F5; Mon, 10 Aug 2020 15:04:57 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200810060457epsmtip1dc92fc3e24987c3913a361b6892cdb56~p0vYm2NLK0293502935epsmtip1j;
        Mon, 10 Aug 2020 06:04:57 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2] ufs: change the way to complete fDeviceInit
Date:   Mon, 10 Aug 2020 14:56:29 +0900
Message-Id: <1597038989-192527-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdljTQrfrsUG8wdHpEhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIyHB64wFdwRrZj5cDpbA+NDgS5GTg4JAROJaz8mMHUxcnEICexglHjWs40dwvnEKHHqxg9G
        COcbo8TJPytZYFpO3f7ODJHYyygxce0LNgjnB6PE5CfvmUGq2AQ0JZ7enAo2WERgM5PEqwX3
        wRLMAuoSuyacYAKxhQXsJfoXX2YDsVkEVCU2/uxmBbF5Bdwk1hzrg1onJ3HzXCfYOgmBv+wS
        045fY4ZIuEhMWXGTFcIWlnh1fAs7hC0l8fndXjYIu15i39QGVojmHkaJp/v+MUIkjCVmPWsH
        sjmALtKUWL9LH8SUEFCWOHKLBeJOPomOw3/ZIcK8Eh1tQhCNyhK/Jk2GGiIpMfPmHaitHhKz
        P54Bu0xIIFZi4sw2xgmMsrMQ5i9gZFzFKJZaUJybnlpsVGCIHE2bGMGpUct1B+Pktx/0DjEy
        cTAeYpTgYFYS4bW7qx8vxJuSWFmVWpQfX1Sak1p8iNEUGF4TmaVEk/OByTmvJN7Q1MjMzMDS
        1MLUzMhCSZw3V/FCnJBAemJJanZqakFqEUwfEwenVAPTOYkJatNvJC/dmJTxTHbjYaaDUr+3
        K3c+28G8Yu3Nk0nHPeckvjLizf+9ZcnNaXzhm09NcRS2fxozZVvkzvPrzsnJ5j4rtgv3SWpI
        K/nhMkP+HZPRvp3rk5Mv/ZO6dqzp9eNrxXoOIofDVa3mn4p7UCNSeaHRJljh1ep5S1/3OCTe
        1vsp3sxu/Gqv2+64/NlzL57i5Hp2f9Orneah22+XbhS23Z2p+Kdjd2bbFN8Hc2//XbZkUudu
        izTpWxPmrZkRITezVnHhp71r95nciNTe8kt7MnvBm8UaTCyWFktMrB/nn4gRKN3LYpSRYsMY
        JXv8+dLGmnuf0/bkhanMEs/jNTH9NPfdM7Xzs19axubtzFBiKc5INNRiLipOBAAfj1aeFgQA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsWy7bCSnG7nY4N4g/MbNSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6MhweuMBXcEa2Y+XA6WwPjQ4EuRk4OCQETiVO3vzN3MXJxCAnsZpRo
        Pt7CDJGQlDix8zkjhC0scb/lCCtE0TdGiXWzvrOAJNgENCWe3pzKBJIQETjMJPF/63N2kASz
        gLrErgknmEBsYQF7if7Fl9lAbBYBVYmNP7tZQWxeATeJNcf6WCA2yEncPNfJPIGRZwEjwypG
        ydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOBQ1dLcwbh91Qe9Q4xMHIyHGCU4mJVEeO3u
        6scL8aYkVlalFuXHF5XmpBYfYpTmYFES571RuDBOSCA9sSQ1OzW1ILUIJsvEwSnVwOSb7lX/
        2OzZU7W5KiZr1sbn8ytI2s5rck6bEb9WIPyPBu/qS0/je46vmH+mRdnmVpKNoA7bHq5WvZei
        pee1owy0j+vzOtTIqs75MMFhq8P5A3seJmw8yRWx6lJviGNBj3W9R9jST02e+lk/n4VZfTg3
        96zvPLmC5ndtXgG5r7PenVn6v/qsbtyth7YnJzxI9+6c/ej75WjzmJ5p/ud0U5crTeZtmfwz
        a+rKndtuN7+44Hh93bY6tc6ZwT+PPdv4ffYul7rlIR9+8fHUL1kV26z4d9ri31EqO6cof3J8
        VJPwU1FU5oJQTdymt1K79+3tNsiVWyNs48IW6mP6t2pHQGv7UrWpcy6p3N7eKOH10UuJpTgj
        0VCLuag4EQDChWvNxAIAAA==
X-CMS-MailID: 20200810060457epcas2p3023e61584089a0f285338d7e04ccaefe
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200810060457epcas2p3023e61584089a0f285338d7e04ccaefe
References: <CGME20200810060457epcas2p3023e61584089a0f285338d7e04ccaefe@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, UFS driver checks if fDeviceInit
is cleared at several times, not period. This patch
is to wait its completion with the period, not retrying.
Many device vendors usually provides the specification on
it with just period, not a combination of a number of retrying
and period. So it could be proper to regard to the information
coming from device vendors.

v1 -> v2: switch the method to get time from jiffies to ktime

Tested-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 092480a..11d61e5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -72,6 +72,9 @@
 /* Default value of wait time before gating device ref clock */
 #define UFSHCD_REF_CLK_GATING_WAIT_US 0xFF /* microsecs */
 
+/* Polling time to wait for fDeviceInit  */
+#define FDEVICEINIT_COMPL_TIMEOUT 1500 /* millisecs */
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -4148,9 +4151,10 @@ EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
  */
 static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 {
-	int i;
 	int err;
 	bool flag_res = true;
+	ktime_t start;
+	s64 time;
 
 	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
 		QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL);
@@ -4161,20 +4165,27 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 		goto out;
 	}
 
-	/* poll for max. 1000 iterations for fDeviceInit flag to clear */
-	for (i = 0; i < 1000 && !err && flag_res; i++)
-		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
-			QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
+	/* Poll fDeviceInit flag to be cleared */
+	start = ktime_get();
+	do {
+		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+					QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
+		if (!flag_res)
+			break;
+		usleep_range(5000, 10000);
+		time = ktime_to_ms(ktime_sub(ktime_get(), start));
+	} while (time < FDEVICEINIT_COMPL_TIMEOUT);
 
-	if (err)
+	if (err) {
 		dev_err(hba->dev,
-			"%s reading fDeviceInit flag failed with error %d\n",
-			__func__, err);
-	else if (flag_res)
+				"%s reading fDeviceInit flag failed with error %d\n",
+				__func__, err);
+	} else if (flag_res) {
 		dev_err(hba->dev,
-			"%s fDeviceInit was not cleared by the device\n",
-			__func__);
-
+				"%s fDeviceInit was not cleared by the device\n",
+				__func__);
+		err = -EBUSY;
+	}
 out:
 	return err;
 }
-- 
2.7.4

