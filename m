Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.1 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_06_12,DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A08C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 06:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5795B23125
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 06:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbhAMGqH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 01:46:07 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:18970 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbhAMGqH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 01:46:07 -0500
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210113064523epoutp010cf4f0f3ee6b4a393a38b44955011996~Zt7OnTEsg1640316403epoutp01J
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jan 2021 06:45:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210113064523epoutp010cf4f0f3ee6b4a393a38b44955011996~Zt7OnTEsg1640316403epoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610520324;
        bh=6XEWyvphJ0/G11FxbmVEVsJYFzzAg58obUspSqXP5Bg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ry2X59uJo1ZD/cELDG1NP5mvmhZjuPLODBuxRjv/Qg+1MvqwrNfhQ567PLzDNg2dn
         QabuNFwDEkc+KU+anJBMqG5Qoakadz7RrstqjbY/yYEipXiFYnZfdh3D+wdfuq4CpE
         c6ugPu/fIiNoRdprNdlxSSxMHbbDjGuGQ1890pi4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210113064523epcas1p128a17e9cb709017d2ad51da97f368710~Zt7N0vpsn0191501915epcas1p1C;
        Wed, 13 Jan 2021 06:45:23 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.161]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DFycf18kCz4x9Px; Wed, 13 Jan
        2021 06:45:22 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.3C.02418.2079EFF5; Wed, 13 Jan 2021 15:45:22 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210113064521epcas1p32f0e65bc54d559b55db65bc5556103e8~Zt7MURoqQ2137721377epcas1p3K;
        Wed, 13 Jan 2021 06:45:21 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210113064521epsmtrp2eb58868ee0cc7d73ace16856b9e3fca8~Zt7MTa2Y42462324623epsmtrp20;
        Wed, 13 Jan 2021 06:45:21 +0000 (GMT)
X-AuditID: b6c32a35-1b331a8000010972-f7-5ffe97021cb0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E7.E0.08745.1079EFF5; Wed, 13 Jan 2021 15:45:21 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.98.109]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210113064521epsmtip2621bb8a5f14fefd648634cc154d72c5e~Zt7MCrS9C1463414634epsmtip2H;
        Wed, 13 Jan 2021 06:45:21 +0000 (GMT)
From:   Manjong Lee <mj0123.lee@samsung.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        nanich.lee@samsung.com, woosung2.lee@samsung.com,
        yt0928.kim@samsung.com, junho89.kim@samsung.com,
        jisoo2146.oh@samsung.com, Manjong Lee <mj0123.lee@samsung.com>
Subject: [PATCH 1/1] scsi: sd: use max_xfer_blocks for set rw_max if
 max_xfer_blocks is available
Date:   Thu, 14 Jan 2021 00:50:08 +0900
Message-Id: <20210113155009.9592-1-mj0123.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsWy7bCmni7T9H/xBhPXsFosurGNyaLnSROr
        xdeHxRaXd81hs+i+voPNYvnxf0wW0zfPYba4dv8Mu8W5k59YLeY9drA4tWMys8X6vT/ZHHg8
        Jiw6wOjx8ektFo++LasYPT5vkgtgicqxyUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
        MFdSyEvMTbVVcvEJ0HXLzAE6TEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhQ
        oFecmFtcmpeul5yfa2VoYGBkClSZkJMx8edsxoIe6YpFf9kbGPvEuhg5OSQETCRW/ZrL3sXI
        xSEksINR4sy0OcwQzidGicN/v7JCOJ8ZJVonzmGEabk27RQTRGIXo8SJ3T/Y4Kp+3b/FDFLF
        JqAlsfzZBXYQW0QgT2LhvudgNrPAQ0aJ57d8QGxhgWSJO7sfgtWzCKhKfNgwHayGV8BK4sLT
        xUwQ2+Ql/tzvYYaIC0qcnPmEBWKOvETz1tlgt0oIvGSXODL1ENR5LhJvXqxih7CFJV4d3wJl
        S0l8freXDaKhmVGi99M5VohEC6PEjotlELaxxKfPn4EGcQBt0JRYv0sfIqwosfP3XEaIxXwS
        7772sIKUSAjwSnS0CUGUqEjsbv4Gt+rNqwNQ53hIPH6wAqxcSCBW4vsLsQmM8rOQfDMLyTez
        EPYuYGRexSiWWlCcm55abFhgiBypmxjBiVPLdAfjxLcf9A4xMnEwHmKU4GBWEuEt6v4bL8Sb
        klhZlVqUH19UmpNafIjRFBi+E5mlRJPzgak7ryTe0NTI2NjYwsTM3MzUWEmcN8ngQbyQQHpi
        SWp2ampBahFMHxMHp1QDk06he3vdw5SGC03fW1L4Gljmiv5h2BUlsLZiMneue0pPUkBj6BQF
        6wPWVzdI2h+bzPp20oQj5xbVzMrN78ne2rZ0nrSMxQYdH+6IO9G1N25JxX7XCZn4fqPWQZn9
        T8pfcsmwVNyYePyFv8997jWfPlobHavg72s4d1JzTt0TLTW76LX7oqV1thWcqlfSKl72fGW4
        lFRcA1PZrE9x4ouklsQ5lsw5KyHmqf5K8v3qFy9YAx9ZdvwUX6Tfd/U1X9T2rnMmT8IyTp+p
        Vvx66RqHSy5fRr1y/sHTc557cB9r6yk8vzG7Q0/qguA8mWMHstVEd/nkvvgiYhb8bOORhIBt
        61M9yqrv8GZpzZdhf/JIiaU4I9FQi7moOBEA1V3a1SUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsWy7bCSvC7j9H/xBlMPi1ksurGNyaLnSROr
        xdeHxRaXd81hs+i+voPNYvnxf0wW0zfPYba4dv8Mu8W5k59YLeY9drA4tWMys8X6vT/ZHHg8
        Jiw6wOjx8ektFo++LasYPT5vkgtgieKySUnNySxLLdK3S+DKmPhzNmNBj3TFor/sDYx9Yl2M
        nBwSAiYS16adYupi5OIQEtjBKPHr2Fk2iISUxLy1DUA2B5AtLHH4cDFEzUdGiSUnTrOA1LAJ
        aEksf3aBHcQWESiS2HB2E1gvs8BLRomunXIgtrBAosTUtdfA6lkEVCU+bJgOVs8rYCVx4eli
        Johd8hJ/7vcwQ8QFJU7OfMICMUdeonnrbOYJjHyzkKRmIUktYGRaxSiZWlCcm55bbFhglJda
        rlecmFtcmpeul5yfu4kRHMZaWjsY96z6oHeIkYmD8RCjBAezkghvUfffeCHelMTKqtSi/Pii
        0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYJnMfcUiJbi1s8w+2+xkbo3Lw
        hLDlt7oCt0/nvY399hauzspf1PTEqfrPw+hPfJxM/2T4ww5WPzmyxuuH8kPVgu96znmmR+sj
        zl9gZCvnvdst9lGq6kCveN+vk/fM5lY4H99411xJv+XVHa1HM7yrxV9/Mdvz/P2ffdELfB5w
        9f/cbXH3NO/ivJxDW1c0/41+/tf4weuW5ysd69b2TVhyySXS/sbHyvjbXA46aWsEBcOfK3YW
        lWgePnSjwVvw/1bFBKXAgsLSOZP2c2jNy/vNza2jEvfPoLYxiLfm+yW1LU7rz+6/suxTdnvt
        pYjd0xyiFZZZzxeRefktkWehUeuq2y+2GK0+dvkizyaXbxKtSizFGYmGWsxFxYkAjGDxRtIC
        AAA=
X-CMS-MailID: 20210113064521epcas1p32f0e65bc54d559b55db65bc5556103e8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210113064521epcas1p32f0e65bc54d559b55db65bc5556103e8
References: <CGME20210113064521epcas1p32f0e65bc54d559b55db65bc5556103e8@epcas1p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI device has max_xfer_size and opt_xfer_size,
but current kernel uses only opt_xfer_size.

It causes the limitation on setting IO chunk size,
although it can support larger one.

So, I propose this patch to use max_xfer_size in case it has valid value.
It can support to use the larger chunk IO on SCSI device.

For example,
This patch is effective in case of some SCSI device like UFS
with opt_xfer_size 512KB, queue depth 32 and max_xfer_size over 512KB.

I expect both the performance improvement
and the efficiency use of smaller command queue depth.

Signed-off-by: Manjong Lee <mj0123.lee@samsung.com>
---
 drivers/scsi/sd.c | 56 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 679c2c025047..de59f01c1304 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3108,6 +3108,53 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
 		sdkp->security = 1;
 }
 
+static bool sd_validate_max_xfer_size(struct scsi_disk *sdkp,
+				      unsigned int dev_max)
+{
+	struct scsi_device *sdp = sdkp->device;
+	unsigned int max_xfer_bytes =
+		logical_to_bytes(sdp, sdkp->max_xfer_blocks);
+
+	if (sdkp->max_xfer_blocks == 0)
+		return false;
+
+	if (sdkp->max_xfer_blocks > SD_MAX_XFER_BLOCKS) {
+		sd_first_printk(KERN_WARNING, sdkp,
+				"Maximal transfer size %u logical blocks " \
+				"> sd driver limit (%u logical blocks)\n",
+				sdkp->max_xfer_blocks, SD_DEF_XFER_BLOCKS);
+		return false;
+	}
+
+	if (sdkp->max_xfer_blocks > dev_max) {
+		sd_first_printk(KERN_WARNING, sdkp,
+				"Maximal transfer size %u logical blocks "
+				"> dev_max (%u logical blocks)\n",
+				sdkp->max_xfer_blocks, dev_max);
+		return false;
+	}
+
+	if (max_xfer_bytes < PAGE_SIZE) {
+		sd_first_printk(KERN_WARNING, sdkp,
+				"Maximal transfer size %u bytes < " \
+				"PAGE_SIZE (%u bytes)\n",
+				max_xfer_bytes, (unsigned int)PAGE_SIZE);
+		return false;
+	}
+
+	if (max_xfer_bytes & (sdkp->physical_block_size - 1)) {
+		sd_first_printk(KERN_WARNING, sdkp,
+				"Maximal transfer size %u bytes not a " \
+				"multiple of physical block size (%u bytes)\n",
+				max_xfer_bytes, sdkp->physical_block_size);
+		return false;
+	}
+
+	sd_first_printk(KERN_INFO, sdkp, "Maximal transfer size %u bytes\n",
+			max_xfer_bytes);
+	return true;
+}
+
 /*
  * Determine the device's preferred I/O size for reads and writes
  * unless the reported value is unreasonably small, large, not a
@@ -3233,12 +3280,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 	/* Initial block count limit based on CDB TRANSFER LENGTH field size. */
 	dev_max = sdp->use_16_for_rw ? SD_MAX_XFER_BLOCKS : SD_DEF_XFER_BLOCKS;
-
-	/* Some devices report a maximum block count for READ/WRITE requests. */
-	dev_max = min_not_zero(dev_max, sdkp->max_xfer_blocks);
 	q->limits.max_dev_sectors = logical_to_sectors(sdp, dev_max);
 
-	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
+	if (sd_validate_max_xfer_size(sdkp, dev_max)) {
+		q->limits.io_opt = 0;
+		rw_max = logical_to_sectors(sdp, sdkp->max_xfer_blocks);
+		q->limits.max_dev_sectors = rw_max;
+	} else if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
 		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
 	} else {
-- 
2.29.0

