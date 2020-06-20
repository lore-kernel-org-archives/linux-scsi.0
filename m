Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FBBC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 07:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 820C623A1D
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 07:39:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YSG0sflZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgFTHjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Jun 2020 03:39:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27484 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgFTHjW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2020 03:39:22 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200620073919epoutp020aa3ba819534993b2fe44f8465f83135~aMIOVhgwj1826018260epoutp02O
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jun 2020 07:39:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200620073919epoutp020aa3ba819534993b2fe44f8465f83135~aMIOVhgwj1826018260epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592638759;
        bh=FWbn8HiU64qGTBC6xNUrPg5tQqvOMoPMKnGbyqzq0vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSG0sflZaiiEDdxLauyy/84Sy1dKhgIt8rQNuJzVK0YOXr/XOsd+uNSvaoKL69Uzt
         60siyJbim5z+hDZVItmkiiIyqPss6GXobn80Vy0rDVj/N0Lc8Nz+1TZqzBpj3mSZK0
         3dE2ReeQ/V5c17MbkjEd6z56QY6hsMYg9tkHvyt4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200620073919epcas2p413195d198c3cf148620f8c4da7d8a162~aMINlZ9GK0538705387epcas2p4o;
        Sat, 20 Jun 2020 07:39:19 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.188]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49pncP2RDfzMqYlp; Sat, 20 Jun
        2020 07:39:17 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        81.A4.27013.52DBDEE5; Sat, 20 Jun 2020 16:39:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200620073916epcas2p4cb1a2d9e70d3b06adc539ba15db8ef60~aMILZ_7380538705387epcas2p4m;
        Sat, 20 Jun 2020 07:39:16 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200620073916epsmtrp2c6a7c05c7504903e0b07637650f55823~aMILZP59T2142721427epsmtrp2s;
        Sat, 20 Jun 2020 07:39:16 +0000 (GMT)
X-AuditID: b6c32a48-d35ff70000006985-57-5eedbd25d5cf
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.32.08382.42DBDEE5; Sat, 20 Jun 2020 16:39:16 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200620073916epsmtip212a42e5225ccbc92a615f6b311c3569c~aMILLb1hI1780717807epsmtip2S;
        Sat, 20 Jun 2020 07:39:16 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 2/2] ufs: change the way to complete fDeviceInit
Date:   Sat, 20 Jun 2020 16:31:37 +0900
Message-Id: <1592638297-36155-3-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592638297-36155-1-git-send-email-kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7bCmma7q3rdxBnMX81s8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWiy6sY3J4uaWoywW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjKscmIzUxJbVIITUvOT8lMy/dVsk7
        ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hGJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+
        cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVCTsbsN9OZCpaKVKxdPY2pgXG7QBcj
        J4eEgInE+9ZtLF2MXBxCAjsYJVZP3cIG4XxilFiw6ipU5hujxM4vNxlhWia+uMYEkdjLKPFv
        80moqh+MErN/97KDVLEJaEo8vTkVrEpE4AajxJzmw6wgCWYBdYldE04wgdjCAu4SazoOMYPY
        LAKqEi//zwKr4RVwldjW9QpqnZzEzXOdYDWcAm4S+7Y9ZAYZKiHwkV1i8a+fbBBFLhIPftxl
        h7CFJV4d3wJlS0l8frcXqqZeYt/UBlaI5h5Giaf7/kFtMJaY9awdyOYAuk5TYv0ufRBTQkBZ
        4sgtFoib+SQ6Dv9lhwjzSnS0CUE0Kkv8mjQZaoikxMybd6C2ekhsa9zCDAmUmYwSZzb3Mk9g
        lJuFsGABI+MqRrHUguLc9NRiowIT5DjbxAhOhloeOxhnv/2gd4iRiYPxEKMEB7OSCO/h92/i
        hHhTEiurUovy44tKc1KLDzGaAgNvIrOUaHI+MB3nlcQbmhqZmRlYmlqYmhlZKInzvrO6ECck
        kJ5YkpqdmlqQWgTTx8TBKdXAVHUjzejsEq+Cedce/p3x7/K7BfrTOQWPXz+5JFdY+72JovEc
        vn3cXcHfOLh6t5yJC7W8Oiu1Y/rZA5P+H1/p/XjCihuzv8+y2TyRQ/7hhc1h3o0fRO0ee5j9
        y/ZS3mS3SDtAuDrmmN4j5TZ/k8eR359NTLiUrfXRPUT8sqWXYnP5MROp1eu+LF331PS549OD
        lxqlde55yMVnvTp4QF80/Osq/uVPVtlddHuReHr655CzV2xvb/b6FJNb06soytMp07tllmtF
        fP7MyteVJ5cyLb24pahI6VnEdbvqOa1PLimyqYnPvD8r2vEn86cS72tHLDY16jxht3n2ifHp
        x2ivycslNXJPSEknaX1KC+wq61ViKc5INNRiLipOBABHZu8gDwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSvK7K3rdxBlNWq1s8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWiy6sY3J4uaWoywW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjissmJTUnsyy1SN8ugStj9pvpTAVL
        RSrWrp7G1MC4XaCLkZNDQsBEYuKLa0xdjFwcQgK7GSWezv7CBpGQlDix8zkjhC0scb/lCCtE
        0TdGidvHb4El2AQ0JZ7enArWLSLwiFHi98xOdpAEs4C6xK4JJ5hAbGEBd4k1HYeYQWwWAVWJ
        l/9nsYLYvAKuEtu6XkFtkJO4ea4TrIZTwE1i37aHYLYQUM2FH0uZJzDyLWBkWMUomVpQnJue
        W2xYYJiXWq5XnJhbXJqXrpecn7uJERyyWpo7GLev+qB3iJGJg/EQowQHs5II7+H3b+KEeFMS
        K6tSi/Lji0pzUosPMUpzsCiJ894oXBgnJJCeWJKanZpakFoEk2Xi4JRqYNo+4ftXpUsWdrMe
        XnhrvlBnwXb/12erUzZv3NG0PvhsVeGGsCa3q+a3u76+uFUXuvKmczajRfhUFzPTY4JSMyqL
        pzDyVf4ULOp9uZDDUudffI6BvHNDbKdhwcQVMpsErtdvFdDx++zO+7L+9AvBwOAzJrNWNFzT
        rktbfobzwI4d/Uq5opJvm875ugYJK/YwvrPYp7FbYZqdm2K4QEJNBev1GNs5h2oOrp2i7f24
        KGzFamV9j99Cqh65KVtVuEtFxLcJfF7UpLMzRLXGuKzQ6ObM4pfflmiv38Zt987uzu/vYjtf
        bt/r1PP33b9znJET2H/8M7kt4J2in9ZyxmXrovDI4m1rPuSq+cRNDHlroMRSnJFoqMVcVJwI
        ABdLfGrIAgAA
X-CMS-MailID: 20200620073916epcas2p4cb1a2d9e70d3b06adc539ba15db8ef60
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200620073916epcas2p4cb1a2d9e70d3b06adc539ba15db8ef60
References: <1592638297-36155-1-git-send-email-kwmad.kim@samsung.com>
        <CGME20200620073916epcas2p4cb1a2d9e70d3b06adc539ba15db8ef60@epcas2p4.samsung.com>
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

I first added one value regarding the information.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b6bc333..a1d85c6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -208,6 +208,8 @@ static struct ufs_dev_fix ufs_fixups[] = {
 };
 
 static struct ufs_dev_value ufs_dev_values[] = {
+	UFS_DEV_VAL(UFS_VENDOR_TOSHIBA, UFS_ANY_MODEL,
+			DEV_VAL_FDEVICEINIT, 2000),
 	END_FIX
 };
 
@@ -4162,9 +4164,12 @@ EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
  */
 static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 {
-	int i;
+	u32 dev_init_compl_in_ms = 500;
+	unsigned long timeout;
 	int err;
 	bool flag_res = true;
+	bool is_dev_val;
+	u32 val;
 
 	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
 		QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL);
@@ -4175,19 +4180,28 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 		goto out;
 	}
 
-	/* poll for max. 1000 iterations for fDeviceInit flag to clear */
-	for (i = 0; i < 1000 && !err && flag_res; i++)
-		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
-			QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
+	/* Poll fDeviceInit flag to be cleared */
+	is_dev_val = ufs_get_dev_specific_value(hba, DEV_VAL_FDEVICEINIT, &val);
+	dev_init_compl_in_ms = (is_dev_val) ? val : 500;
+	timeout = jiffies + msecs_to_jiffies(dev_init_compl_in_ms);
+	do {
+		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+					QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
+		if (!flag_res)
+			break;
+		usleep_range(1000, 2000);
+	} while (time_before(jiffies, timeout));
 
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
 			"%s fDeviceInit was not cleared by the device\n",
 			__func__);
+		err = -EBUSY;
+	}
 
 out:
 	return err;
-- 
2.7.4

