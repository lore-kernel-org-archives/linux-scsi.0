Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B2F4C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EE042064B
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:44:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FAaHqeAs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgF2SoA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 14:44:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58160 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727964AbgF2Sn4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 14:43:56 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200629102359epoutp041280b406d8f74d0765f0a0edb4dd859b~c-Lj3ODX_0782707827epoutp04s
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 10:23:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200629102359epoutp041280b406d8f74d0765f0a0edb4dd859b~c-Lj3ODX_0782707827epoutp04s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593426239;
        bh=iO9dqCnrbL9OrGTJU2+4BM2Rv7CtQaF84mdvj1REYWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=FAaHqeAszbe79QcaqMAFbtdYTXeO9WdJYswDCXd/sIzGskXmCeNDR2IeHbS902H8l
         iq0rBBZf4uigs8Yh4LPfwqqoPRabSJcQba6ETVfPJoqJ13zqXH29aEpZ4/H55MnofO
         cRn4KdUb0/2VgAyteNu9qYrfqf067DApDbNNmbF4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200629102359epcas2p3185d7239c01e8c53b8d4df3f4a249cb1~c-LjjJHfV0169901699epcas2p3t;
        Mon, 29 Jun 2020 10:23:59 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.187]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 49wNrF1RgTzMqYkZ; Mon, 29 Jun
        2020 10:23:57 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        E7.A5.27013.C31C9FE5; Mon, 29 Jun 2020 19:23:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200629102355epcas2p13f8714a906291e5444adfb2f5ac2c469~c-Lf79AKN3124231242epcas2p14;
        Mon, 29 Jun 2020 10:23:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200629102355epsmtrp179014ab9b6f13b67609c2ef141f2f8dd~c-Lf7XVo-2797727977epsmtrp1w;
        Mon, 29 Jun 2020 10:23:55 +0000 (GMT)
X-AuditID: b6c32a48-d1fff70000006985-38-5ef9c13c477b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E3.84.08303.B31C9FE5; Mon, 29 Jun 2020 19:23:55 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200629102355epsmtip221b90ab6809fcedef555eff318798d89~c-LfvwEEf0968509685epsmtip25;
        Mon, 29 Jun 2020 10:23:55 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v2 2/2] ufs: change the way to complete fDeviceInit
Date:   Mon, 29 Jun 2020 19:15:56 +0900
Message-Id: <1ca1a52df36ad3393c0487537832cf7f0a7e1260.1593412974.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1593412974.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1593412974.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsWy7bCmha7NwZ9xBm8Xq1vc3HKUxaL7+g42
        ByaPvi2rGD0+b5ILYIrKsclITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
        VXLxCdB1y8wBGq+kUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTA0LNArTswtLs1L
        10vOz7UyNDAwMgWqTMjJ+P5lBnvBRNGK29sqGxh7BLsYOTkkBEwktvbcZuli5OIQEtjBKHH8
        9Ud2COcTo8SfY5+hMp8ZJe7dPswI0/JhfTsrRGIXo8Tsxk4mCOcHo0Tr97esIFVsApoST29O
        ZQKxRQTkJDYv/8oCYjMLqEvsmnACLC4s4C7x6dITsHoWAVWJL//es4HYvALREvMX/YHaJidx
        81wnM4jNKWAp8eL2dTQ2F1BNN7vE06YrrBANLhL35l1jhrCFJV4d38IOYUtJvOxvg7LrJfZN
        bWCFaO5hlHi67x/UNmOJWc/agWwOoEs1Jdbv0gcxJQSUJY7cgrqfT6Lj8F92iDCvREebEESj
        ssSvSZOhhkhKzLx5B2qTh8Sh11OggQW0acmnY0wTGOVnISxYwMi4ilEstaA4Nz212KjABDn2
        NjGC05KWxw7G2W8/6B1iZOJgPMQowcGsJML72fpbnBBvSmJlVWpRfnxRaU5q8SFGU2BATmSW
        Ek3OBybGvJJ4Q1MjMzMDS1MLUzMjCyVx3ndWF+KEBNITS1KzU1MLUotg+pg4OKUamGIz3s3o
        Zr0pN+38r/eJe7XX50anWSsLO5nc3THrpd7zd1M8KhtF+C+ltgS/+Dtp353XZhab7pzleVxp
        tkih2WTBBF3ORrVv03ICfmvMS502oX3lRc9/F/2aKpMVGq+c5kx7c9N4dW3pwaX1vnIJ/k8P
        3PsudyzK84RA3Y373X/dnHZq72oXPqeT/muxPF/8s9vajL6X9reqXNZ6VcJz1jAl2Jt5w487
        e96eerf766dMhY77r/f8ENjLPW+tvvaJD1PfrtcMnXVnJtf+LdYtIrzCV2o/8yRJ/DxpXL03
        7tvWWUuzki+wmXwXPRR/eKub4fvHeqJL/i5T5ZftFd+cw+IUG53+91zvyc5lL4uil/ArsRRn
        JBpqMRcVJwIAExmDRdQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42LZdlhJXtf64M84g0tbuS1ubjnKYtF9fQeb
        A5NH35ZVjB6fN8kFMEVx2aSk5mSWpRbp2yVwZXz/MoO9YKJoxe1tlQ2MPYJdjJwcEgImEh/W
        t7N2MXJxCAnsYJT4tmsfC0RCUuLEzueMELawxP2WI6wgtpDAN0aJ1mlKIDabgKbE05tTmUBs
        EQE5ic3Lv4L1MguoS+yacAIsLizgLvHp0hOwXhYBVYkv/96zgdi8AtES8xf9gZovJ3HzXCcz
        iM0pYCnx4vZ1IJsDaJeFxJdDcTiEJzAKLGBkWMUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpec
        n7uJERxOWlo7GPes+qB3iJGJg/EQowQHs5II72frb3FCvCmJlVWpRfnxRaU5qcWHGKU5WJTE
        eb/OWhgnJJCeWJKanZpakFoEk2Xi4JRqYLpgsGyZ+rUX7iKTww32aBTPbbSw/X1M3VGlMO38
        7ptvb4Z/1f15pDZ47r2X2+V+ztq+aneNkMX6F2o1Nd9luSbJ711wkjPx9+KK2VxnlNhmWNfs
        71g90SDs9tYUu/I/B19Xr073O77itW76/VD5Vb80OepfR0uldjt8THPYwWMkXTk/fIWo1iI3
        7VDB50k1fS/csjL1CyQX3FIMdrFzvVrnxx17yeLcrFVMs36ueHlfg2WqgDBL0NooE8aAqus7
        TWbGCmwXDrV+fFjpcbniA1Wd+fUVj55ZOr3+lRBm4uy30ySGRb/sYc+Tiu+Jq16fUTidO0X/
        hWDTti3MTZ/5rR3lv1y8rtvduVFGW6GxW4mlOCPRUIu5qDgRAGgOIX6WAgAA
X-CMS-MailID: 20200629102355epcas2p13f8714a906291e5444adfb2f5ac2c469
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200629102355epcas2p13f8714a906291e5444adfb2f5ac2c469
References: <cover.1593412974.git.kwmad.kim@samsung.com>
        <CGME20200629102355epcas2p13f8714a906291e5444adfb2f5ac2c469@epcas2p1.samsung.com>
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

I first added one device specific value regarding the information.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7b6f13a..27afdf0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -208,6 +208,7 @@ static struct ufs_dev_fix ufs_fixups[] = {
 };
 
 static const struct ufs_dev_value ufs_dev_values[] = {
+	{UFS_VENDOR_TOSHIBA, UFS_ANY_MODEL, DEV_VAL_FDEVICEINIT, 2000, false},
 	{0, 0, 0, 0, false},
 };
 
@@ -4162,9 +4163,12 @@ EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
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
@@ -4175,20 +4179,28 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
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

