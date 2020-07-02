Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75562C433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D37F2070C
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:19:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ju6YLoyG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgGBCTs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:19:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23316 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgGBCTq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 22:19:46 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200702021943epoutp03a1d1148d15a761c445760f49c0ccc42f~dzgmlg9_g0502705027epoutp03i
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 02:19:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200702021943epoutp03a1d1148d15a761c445760f49c0ccc42f~dzgmlg9_g0502705027epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593656384;
        bh=Ey4NFKPAdZv5rk1Pqo4Qwzaczl5dhs7AIM0WQFb0Ftg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=Ju6YLoyGrroDpUWVND9QH5oTDvMcZEz01ZPtRBmnaR6XjBgg1PENuPZLvkfra8ztD
         cfjPNAnQBuPau1SHlKCS02dl7KCcIvsibh9D2NGJoO6L2jQr5q6MEaTUR5bQbXoCgf
         ZGYXp63p0a/ZbU/zLxqVvkH1CyUNTPXcXdSM9UY8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200702021943epcas2p2dbd47d20de2141dbf17cc5b168ecf949~dzgl7BToX2428124281epcas2p2v;
        Thu,  2 Jul 2020 02:19:43 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 49y1y51tXwzMqYkl; Thu,  2 Jul
        2020 02:19:41 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.11.19322.B344DFE5; Thu,  2 Jul 2020 11:19:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200702021938epcas2p35eadff66139b6a42d438fa3ee868a29a~dzgh3V_au2388723887epcas2p3H;
        Thu,  2 Jul 2020 02:19:38 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200702021938epsmtrp23648e4828fc10f08348fff2074c053c4~dzgh2iyhk1404614046epsmtrp21;
        Thu,  2 Jul 2020 02:19:38 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-44-5efd443b69bb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.80.08303.A344DFE5; Thu,  2 Jul 2020 11:19:38 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200702021938epsmtip1cdf2143388f0bab08349716fd2efff12~dzghqWWGN2097820978epsmtip1M;
        Thu,  2 Jul 2020 02:19:38 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1 2/2] ufs: change the way to complete fDeviceInit
Date:   Thu,  2 Jul 2020 11:11:49 +0900
Message-Id: <854db3aecefab74495f4661cafc8cf116e4eaa85.1593655834.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1593655834.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1593655834.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42LZdljTTNfa5W+cQeNdM4sH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi0U3tjFZ3NxylMWi+/oONovlx/8xOXB5XL7i7XG5r5fJ
        Y8KiA4we39d3sHl8fHqLxaNvyypGj8+b5DzaD3QzBXBE5dhkpCampBYppOYl56dk5qXbKnkH
        xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAN2opFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQwMDIFqkzIydj+8h5rQa9oxcTb+1gbGDsEuxg5
        OSQETCQufvjL2sXIxSEksINR4tqag4wQzidGiZPL90E5n4GcvvnsMC33/l2CatnFKLF+000o
        5wejRPO8icwgVWwCmhJPb05lAkmICNxglJjTfJgVJMEsoC6xa8IJJhBbWMBZ4u6N0yxdjBwc
        LAKqErNXZ4GEeQWiJd41HGCE2CYncfNcJ9hMTgFLiUP7rjKisyUEfrJL9O92hbBdJO78XAd1
        qbDEq+NboGwpic/v9rJB2PUS+6Y2gB0tIdDDKPF03z+oQcYSs561M4Lcwwz0wPpd+iCmhICy
        xJFbLBDX80l0HP7LDhHmlehoE4JoVJb4NWky1BBJiZk370CVeEisO5gGCR2gRTOuvmKdwCg/
        C2H+AkbGVYxiqQXFuempxUYFhsiRt4kRnB61XHcwTn77Qe8QIxMH4yFGCQ5mJRHe0wa/4oR4
        UxIrq1KL8uOLSnNSiw8xmgJDcSKzlGhyPjBB55XEG5oamZkZWJpamJoZWSiJ8+YqXogTEkhP
        LEnNTk0tSC2C6WPi4JRqYBK5qbXKzHfdxqjuXLmrt9Q325qGnNaK3tcveH7frW63Z+kfNaOb
        bnPLvJn6YdWE2Zs7W83FJ627NHPtqo7v2zo8NjuFLyhP/nB2gaiYWDqfS+iF8MdCte4u//JW
        RzWEz7xW19h0oFgkgmHyFVuTLw9cHmxdsrnr2JLLH49d0c3yjIp+dI/BtXcLq/QrLsM5fR2X
        TX9s8ZSYo95ksDlFTeXGrXnz1VV6VnzXkpllca3h2NnPUxVfFuwMNYwXaz57/EKAz46bs9w3
        sc3w0uE4XKm4//uZBr7s77E39/YzRUf6Xrh0IdFzoq3au9vKKkyK39jZDH0OnJsQwaPDszWq
        e+Vl7qDj62y1iks5RRg/WCixFGckGmoxFxUnAgAsEvQhGAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWy7bCSnK6Vy984g1frDCwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLRbd2MZkcXPLURaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARxWWTkpqTWZZapG+XwJWx/eU91oJe
        0YqJt/exNjB2CHYxcnJICJhI3Pt3ibWLkYtDSGAHo8SRY8/YIRKSEid2PmeEsIUl7rccgSr6
        xiix5vh6FpAEm4CmxNObU5lAEiICjxglfs/sBOtmFlCX2DXhBBOILSzgLHH3xmmgBg4OFgFV
        idmrs0DCvALREu8aDkAtkJO4ea6TGcTmFLCUOLTvKlhcSMBCYs2TZ4y4xCcwCixgZFjFKJla
        UJybnltsWGCUl1quV5yYW1yal66XnJ+7iREc4FpaOxj3rPqgd4iRiYPxEKMEB7OSCO9pg19x
        QrwpiZVVqUX58UWlOanFhxilOViUxHm/zloYJySQnliSmp2aWpBaBJNl4uCUamCKzst/fmtB
        56e1Z4+Eluol5RcENK0+/CehddWpHZKpLn/qpwTarzdaajr96AbXe5Ken5hXeEqJaLl7JzaV
        Xj8nVJzYNKvIsePPpdz8To9F7RaXN6yr8nkULDTx09cjtTwxfudC2zXZ76kuOfX3K/uEhhyZ
        r5bh4fKlL7a1zyt8OPWncffyB090dWYxsHYzWyxv++IX/1OA08D6Zsfamschj6d/qdy4/b+I
        klNzuvqevGeTtsuffmy7dbtAkjTTbe3uqz/0emwOue5x71jKJX/1ueHUv4UnDF5NXn1ywouf
        nfWt9QmzQycwHk3dtlL+zoEev0tPHSv4k03CYn/Z/N187FOv7dkPW2aYL81MSVRWYinOSDTU
        Yi4qTgQA2UJZXN8CAAA=
X-CMS-MailID: 20200702021938epcas2p35eadff66139b6a42d438fa3ee868a29a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200702021938epcas2p35eadff66139b6a42d438fa3ee868a29a
References: <cover.1593655834.git.kwmad.kim@samsung.com>
        <CGME20200702021938epcas2p35eadff66139b6a42d438fa3ee868a29a@epcas2p3.samsung.com>
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
index 7b6f13a..717afed 100644
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
+	u32 dev_init_compl_in_ms = 1000;
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
+		usleep_range(5, 10);
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

