Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BB3C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 10:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4D5020729
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 10:11:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="K3UuR1gS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgHJKLC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 06:11:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64860 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgHJKLC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 06:11:02 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200810101058epoutp02449f7199a8b250bbfda4335a6e070332~p4GL4t8WY1641616416epoutp02M
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2020 10:10:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200810101058epoutp02449f7199a8b250bbfda4335a6e070332~p4GL4t8WY1641616416epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1597054258;
        bh=sDkMNPJIXPyW6i2N8HfT4bD1U6t7hLbCdoJcoPdX0x8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=K3UuR1gSeCKvfSWOGQjXN2kdWctzzIoSa79LpmXBnNMgx0o+zF1UCOk1NlbLvj7G8
         fMEYJR7Ba4YuACxg6ovogoB8elEwmXBgzUZ+ivspdKzNJ2wtpVJ09rFyyM2tdD6Vpn
         PiSauqO4WMIxDk/nEN1Ofm9jFJUugEo2hixlPqyI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200810101057epcas2p47a69f0bc69c3083b83d427f6b879150a~p4GLF2EX22726927269epcas2p4v;
        Mon, 10 Aug 2020 10:10:57 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BQBYq3CMqzMqYkd; Mon, 10 Aug
        2020 10:10:55 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        AE.B1.27013.F2D113F5; Mon, 10 Aug 2020 19:10:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200810101054epcas2p2e1a4a550e7f4732e2ad1ee127317b0d2~p4GIbhMSl2327923279epcas2p24;
        Mon, 10 Aug 2020 10:10:54 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200810101054epsmtrp2a49bf3593579247bb461be0704f4d0b6~p4GIawLVI1354713547epsmtrp26;
        Mon, 10 Aug 2020 10:10:54 +0000 (GMT)
X-AuditID: b6c32a48-d1fff70000006985-0a-5f311d2f0801
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        45.E2.08303.E2D113F5; Mon, 10 Aug 2020 19:10:54 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200810101054epsmtip10942c4d5991986c967e0993c864fa1be~p4GIMl3V-0537805378epsmtip1Z;
        Mon, 10 Aug 2020 10:10:54 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3] ufs: change the way to complete fDeviceInit
Date:   Mon, 10 Aug 2020 19:02:27 +0900
Message-Id: <1597053747-75171-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsWy7bCmqa6+rGG8wZenYhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIwrDXuYCo6IVnxdPY2tgfGKQBcjJ4eEgInEjG33WEFsIYEdjBJHNyh0MXIB2Z8YJQ4s/8YM
        4XxmlGj495kNpmPK7oNsEIldjBLHdl9jgXB+MEq8ajnIDFLFJqAp8fTmVCaQhIjAZiaJVwvu
        gyWYBdQldk04wQRiCwvYSzRPeskCYrMIqEosW7YSyObg4BVwlZjwTBRim5zEzXOdYGdICPxk
        l/g4aQ0TRMJFYtLOdVC2sMSr41vYIWwpic/v9kKdWi+xb2oDK0RzD6PE033/GCESxhKznrUz
        gixjBrp0/S59EFNCQFniyC0WiDP5JDoO/2WHCPNKdLQJQTQqS/yaNBlqiKTEzJt3oEo8JI73
        FIOYQgKxEh+upU1glJ2FMH0BI+MqRrHUguLc9NRiowIT5CjaxAhOiVoeOxhnv/2gd4iRiYPx
        EKMEB7OSCK/dXf14Id6UxMqq1KL8+KLSnNTiQ4ymwMCayCwlmpwPTMp5JfGGpkZmZgaWpham
        ZkYWSuK876wuxAkJpCeWpGanphakFsH0MXFwSjUw7b63Wmn3z0/Vp3/Nd29SKv89q/nhgkuS
        CyOP8mZd+ta3oYYldOFGj9YJ3WviGljLtzjfP+caqrWvYcrPbrU7iXwWb0/1fn7ndX9ekn+j
        qaD9OpX4+O/qx8/u+mQVdDcy9mj8tB2mPH2OGu+E02dtXyDK8ndTgnJF854f6z52XHtwWLB5
        4run7vrvBe44Ml/9G8+fOEdzz96FHS+s2Sbc0Hg23ZDRIFjijWlhwmmJN+1207KyVn0pE739
        yZ7xf/CxpjW7al8GWC3Tvls+8fid/Y8crANiDrZ31TK0CypNsxZ4V5i9MUUr9KyBzme+e467
        ZH/XSD3z+toq8rTh1TQFjzqXuLqbp2PX8rByrIl7o8RSnJFoqMVcVJwIAOd7acwSBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSnK6erGG8wdfH2hYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfGlYY9TAVHRCu+rp7G1sB4RaCLkZNDQsBEYsrug2xdjFwcQgI7GCU6
        Lz9ghEhISpzY+RzKFpa433KEFaLoG6PEidUNbCAJNgFNiac3pzKBJEQEDjNJ/N/6nB0kwSyg
        LrFrwgkmEFtYwF6iedJLFhCbRUBVYtmylUA2BwevgKvEhGeiEAvkJG6e62SewMizgJFhFaNk
        akFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcKBqae1g3LPqg94hRiYOxkOMEhzMSiK8dnf1
        44V4UxIrq1KL8uOLSnNSiw8xSnOwKInzfp21ME5IID2xJDU7NbUgtQgmy8TBKdXAVLjgpVLF
        26veUiXSVfMvve6a8O7Kk7ccUTnmx8qLY1S7ysJXMAV3bfHZmpIz4ej1ovCawJwz0w5umfdz
        TlmC0XUZra9Bp00MFy/uzTPIPqsccveZgPv3DI3oGQr5ATOW/opZ++v516PsB2Zlxt0wWe2U
        LPnEeN/+BMHoAJWfjg6Zf5o38ztvtOjisXc6tTP0tV3XRsM1f/0YchZH/jWb7RPQmXZPmaNu
        0ca7M3tr5GMWCbzce1U4QMAw9vauRz4tUaqpH3LuBXpZnQoQb6x/WHRG+S6nEuN2vgeH3wiW
        LtkdtK/hXAQvt9Oqd80KBpe5zs2Y7X6pZvYMpVfaleUa4WLVXu2S9uc2T1hk/6hciaU4I9FQ
        i7moOBEA9/KhosMCAAA=
X-CMS-MailID: 20200810101054epcas2p2e1a4a550e7f4732e2ad1ee127317b0d2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200810101054epcas2p2e1a4a550e7f4732e2ad1ee127317b0d2
References: <CGME20200810101054epcas2p2e1a4a550e7f4732e2ad1ee127317b0d2@epcas2p2.samsung.com>
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
 drivers/scsi/ufs/ufshcd.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 092480a..ed03051 100644
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
@@ -4148,9 +4151,9 @@ EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
  */
 static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 {
-	int i;
 	int err;
 	bool flag_res = true;
+	ktime_t timeout;
 
 	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
 		QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL);
@@ -4161,20 +4164,26 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 		goto out;
 	}
 
-	/* poll for max. 1000 iterations for fDeviceInit flag to clear */
-	for (i = 0; i < 1000 && !err && flag_res; i++)
-		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
-			QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
+	/* Poll fDeviceInit flag to be cleared */
+	timeout = ktime_add_ms(ktime_get(), FDEVICEINIT_COMPL_TIMEOUT);
+	do {
+		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+					QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
+		if (!flag_res)
+			break;
+		usleep_range(5000, 10000);
+	} while (ktime_before(ktime_get(), timeout));
 
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

