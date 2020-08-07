Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FDBC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 06:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31721221E5
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 06:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QWsElZKp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgHGGoN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:44:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32116 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgHGGoN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 02:44:13 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200807064410epoutp013e107a6c0dbbcec31e3f7b5714d69925~o6VxmyFPo2173021730epoutp01E
        for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2020 06:44:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200807064410epoutp013e107a6c0dbbcec31e3f7b5714d69925~o6VxmyFPo2173021730epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1596782651;
        bh=ZnUNVIsgVf6GOO20ss6OX5j8BHWnWscPqwY9BTp1AF8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=QWsElZKpKVje9P4lonuCfOl1Q6Dh1xPvhm6m7VxLE4n9jQNdz0q/Cqj9XGj6M4rEp
         u51ZiJHIGthsbAe22BqPHrVwBXzpTlLqwR6pNYWGPTSB8kBx6htkjSGYlsGtHUBGFk
         aDoQ0g61hqMbY3/3TDmJPjt7hZsmyO+pc5ADW+HI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200807064410epcas2p44ce027e58bb930b1dcec2ca523ce3b30~o6VxBEH-i2831128311epcas2p4H;
        Fri,  7 Aug 2020 06:44:10 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.184]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BNG6c1M2VzMqYkq; Fri,  7 Aug
        2020 06:44:08 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        6D.11.19322.838FC2F5; Fri,  7 Aug 2020 15:44:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200807064407epcas2p464c2400c3868cfaa12b0e23310617a29~o6Vul4Ccy2831128311epcas2p4B;
        Fri,  7 Aug 2020 06:44:07 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200807064407epsmtrp18bff380c351c77c8001815d2be0959c2~o6Vufkbd_0690806908epsmtrp1a;
        Fri,  7 Aug 2020 06:44:07 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-a9-5f2cf838c456
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        45.40.08303.738FC2F5; Fri,  7 Aug 2020 15:44:07 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200807064407epsmtip2fdc1ae2918c7093dc6aff1baa2577518~o6VuTDPWT2707827078epsmtip21;
        Fri,  7 Aug 2020 06:44:07 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v4] ufs: change the way to complete fDeviceInit
Date:   Fri,  7 Aug 2020 15:35:43 +0900
Message-Id: <1596782143-22748-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsWy7bCmua7FD514g+VdHBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIyfJ6czF1wQqHje49TAuJa3i5GDQ0LARGLhWc0uRi4OIYEdjBJ7jy1ih3A+MUpcf32eDcL5
        zCjxYtohoAwnWMfmfVfZQGwhgV2MEg86BSCKfjBKrJq/AayITUBT4unNqUwgCRGBzUwSrxbc
        ZwZJMAuoS+yacIIJxBYWsJd4fWwpI4jNIqAqcXRHDwuIzSvgKnF4/SImiG1yEjfPdTKDDJIQ
        +Mkucbb3BStEwkXiYsM9NghbWOLV8S1Q50lJvOxvg7LrJfZNbWCFaO5hlHi67x8jRMJYYtaz
        dkZQCDADnbp+lz4kMJQljtxigbiTT6Lj8F92iDCvREebEESjssSvSZOhhkhKzLx5B2qTh8SC
        ns1g5UICsRJHX4ROYJSdhTB+ASPjKkax1ILi3PTUYqMCQ+Qo2sQITolarjsYJ7/9oHeIkYmD
        8RCjBAezkghv1gvteCHelMTKqtSi/Pii0pzU4kOMpsDgmsgsJZqcD0zKeSXxhqZGZmYGlqYW
        pmZGFkrivLmKF+KEBNITS1KzU1MLUotg+pg4OKUamDYbZt2sf/7jv5lWdll6NEvS2cOujWpc
        Jga/OeXnvzN3eXzedOX7oJa116T1AgKn/Ztgs9xk4aN/HIahknetJgtfPv0v8JTntmuHDK8p
        HNxyUdChrPfBvMcvdYR7T9TbT7zb49v0l3/GtED1nmx31vZbz+dW3m0MZbxyvlq+7nVKw8xD
        +8X1d3o82Nk3p1cz7ZdmZ9oaxpvK+a9WHDrpEbD4ml9YdEy++NS7GVOa/c89aS3s5/s8K2bC
        o9MH04O+/cr7NU9ve8XBB9q1iszJc3Lv/v7o7bfjU3GuiPl/waPsm5/8br7A2OU96am9bI8L
        84b6nFrhrPUZJcUd3fMnnw8LPXvP805uCquWZWeRmBJLcUaioRZzUXEiACR5nswSBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSvK75D514g5tzFC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6MnyenMxdcEKh43uPUwLiWt4uRk0NCwERi876rbF2MXBxCAjsYJS4e
        /sQKkZCUOLHzOSOELSxxv+UIK0TRN0aJvtmbwYrYBDQlnt6cygSSEBE4zCTxf+tzdpAEs4C6
        xK4JJ5hAbGEBe4nXx5aCTWIRUJU4uqOHBcTmFXCVOLx+ERPEBjmJm+c6mScw8ixgZFjFKJla
        UJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcqFpaOxj3rPqgd4iRiYPxEKMEB7OSCG/WC+14
        Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxfZy2MExJITyxJzU5NLUgtgskycXBKNTCd4V6+vqLo
        3skfv5+81Fc+nORbeHT2FV6pp6smbH7srjq5WurYPNWi1GQ7i9Pux3/47y+YULH/S2Hzu4iV
        T5bMffDvy86/R31/3pm0ufxZrIqSesdHm3/bRaz+1/xybdx2wERynuj79ZmXdn5gzzkd+NrU
        sXBSuMVbEaOPwu/4Td5/NYyxZag4rHfbe0b50csipgdOZJb4Ky2I4Wv9xVdokWZ/bMs8Jx6Z
        uPQQ9RPrjk73tv7eH3Oz1n/Di8fRMxQy5np5fNlxlKmH06fmufM/d78u3bBw1zUseRwdrz8/
        XVaiuyphuciBP7Xdn4zMBJsuqVuwal7JmxwqIhzOcPjjz2+P+CNXzeRPKih6/J9biaU4I9FQ
        i7moOBEAbex6ucMCAAA=
X-CMS-MailID: 20200807064407epcas2p464c2400c3868cfaa12b0e23310617a29
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200807064407epcas2p464c2400c3868cfaa12b0e23310617a29
References: <CGME20200807064407epcas2p464c2400c3868cfaa12b0e23310617a29@epcas2p4.samsung.com>
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

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 092480a..c508931 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4148,7 +4148,8 @@ EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
  */
 static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 {
-	int i;
+	u32 dev_init_compl_in_ms = 1500;
+	unsigned long timeout;
 	int err;
 	bool flag_res = true;
 
@@ -4161,20 +4162,26 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 		goto out;
 	}
 
-	/* poll for max. 1000 iterations for fDeviceInit flag to clear */
-	for (i = 0; i < 1000 && !err && flag_res; i++)
-		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
-			QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
+	/* Poll fDeviceInit flag to be cleared */
+	timeout = jiffies + msecs_to_jiffies(dev_init_compl_in_ms);
+	do {
+		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+					QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
+		if (!flag_res)
+			break;
+		usleep_range(5000, 10000);
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

