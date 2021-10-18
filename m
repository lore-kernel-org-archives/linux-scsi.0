Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41345C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C43560EE9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhJRMrn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18731 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhJRMrd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:33 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211018124514epoutp0111e3c6682a16f7ef55bbebfa66a7f329~vIKxH9a2p3215032150epoutp01Z
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211018124514epoutp0111e3c6682a16f7ef55bbebfa66a7f329~vIKxH9a2p3215032150epoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561114;
        bh=2yK8hED749QszIIrfrFDo/NEjUuWI6KG7B3Gm0sgmnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pmxe6GaXMx50uDSsMpprLL3fjUcMs6cdjyeybEc+ElcMIhWxYJ/BCWusA/lqBOk7Y
         xMwIBwa3VEJ9HO0Qz+oaEwSks173WwuNp3D4Q86QrO3H1PsjA8qbi1nMZw7KI49CP4
         Vy1IBq9jL9n+iKovj4GnEewjazPJL8RV2fu/EWNs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211018124513epcas2p1fb3fc498275eb5b0301bc4e949fb8ff0~vIKwKuiQE2115521155epcas2p1T;
        Mon, 18 Oct 2021 12:45:13 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.90]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HXxRP5Pt8z4x9Q1; Mon, 18 Oct
        2021 12:45:05 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.D9.09823.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epcas2p143bb8374e3399e2670ced625862a8653~vIKo3ffnI2115521155epcas2p1H;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211018124505epsmtrp216366a9e9e7d8b14fbee0a91242541bb~vIKozmESa2052720527epsmtrp2J;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
X-AuditID: b6c32a48-127ff7000000265f-16-616d6c5181d4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A9.40.08738.05C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124504epsmtip2947f06696b5630ac3f80a717bce289cd~vIKom0r4N0377703777epsmtip2c;
        Mon, 18 Oct 2021 12:45:04 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v5 02/15] scsi: ufs: add quirk to enable host controller
 without ph configuration
Date:   Mon, 18 Oct 2021 21:42:03 +0900
Message-Id: <20211018124216.153072-3-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTZxTee2+5LR/FSwV9RzJH7iSEbkDbtPTWibLg9DrQYVgWwxbYXXsH
        SL/oLcxNl7C5IaUIqAvMVgarYTo2JHR8OlBAFiUjmxvqQHEoH1F0jNKaCehwLbdu/nvOOc/z
        nJxz3leAiiawSEGe3syY9LSWwIJ47edjFXG7tDpa0lYRSw5OfYeRN79sx8iZxSsY2XfLwiOr
        XYso6W7+OoAcPvciWd6VQv5U5UDIqWYbSjpG2hFyZKkkgPzmKkm2zC4g5Be/nEVI6++dGHny
        wjJCPlzsR5JF1PDlVMpWfAijhisOIdT3p8TUie4ZhHI2WjCqytELqAfNpRg1P32NR1W0NgLK
        41xHHey1Iukhmfkbcxlaw5iiGL3aoMnT5yQRqRnZKdmKRIk0TqoilUSUntYxScSWtPS4rXla
        72xEVBGtLfSm0mmWJRI2bTQZCs1MVK6BNScRjFGjNSqN8SytYwv1OfF6xrxBKpHIFF7iO/m5
        p/sq+Ub7qr1DR37gFYPRkDIQKIC4HLo9DVgZCBKI8E4A75/t4HOBG8ARyxDCBR4Amz45CJ5I
        bBN2v+QMgLfqmvySeQCrbnyK+lgYHgdbb98FvkI4Pgfg1OTnKywUn0HhlUEP38dajavhWMsy
        5sM8PBpe/LvUqxYIhPhm6H4UxLV7Hg4sWVZMA/FkWO4YQHxYiIfBwWNTPB9GvZwDbXbU5w/x
        OwK4UO4APh+Ib4HVjW9zPqvh3QutfA5HQs9fPRjHtwL42cRjf+FbAC0fp3F4M1yqaQ3w+aB4
        LGw+k8BZvgAHrvnbhsLS8//wubQQlpaIOGEM7O2o4XH4OWg97gngMAXvL7n8uzoKoG3Wya8C
        UbanprE9NY3t/8b1AG0Eaxgjq8thWJlR/t+J1QadE6w8djHVCeyzrvh+gAhAP4AClAgXvvuq
        jhYJNfQHHzImQ7apUMuw/UDhXfVhNDJCbfD+Fr05WypXSeSJiVKlTCFREmuFqoh8WoTn0GYm
        n2GMjOmJDhEERhYjoGFT9O11+90xNYndr2U9lqk1I3zpXNiN8ff2Dyp2JhQUDoZJI8RzV9dK
        g8VDDQMxzkni+qVtwXf6r5+oi31d6co5fVhR93PxjtHxkfi++rTkV/In3zhF8G7+Kn+rHVWN
        z95L044t1GYbsiK60Ez7xEfump6a1Pl4dV/6b44N20an97bZ9sR0TlOrqiutF2s7w5xySWhR
        xlgT9UfBgdDlyN2KZ5nyfX3HHnWJ+YlBwoIdHZYW1cOlApct5d7loT/tJ3euWRzLyCyZK6ur
        PJr5YHdRcDi7fX1yR7ey9s3j57YvNEXXWysV8z1fJfGK2tfv2Sp7qXeXxnFp38L7IVkvRzzz
        4yjBY3NpqRg1sfS/pAv2SXUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWy7bCSvG5gTm6iwYRXzBYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi5XX
        LCw2vv3BZDHj/D4mi+7rO9gslh//x2Tx++chJgchj8tXvD1mNfSyeVzu62Xy2LxCy2PxnpdM
        HptWdbJ5TFh0gNHj+/oONo+PT2+xePRtWcXo8XmTnEf7gW6mAJ4oLpuU1JzMstQifbsErox1
        B/vZC2bzV5yZtJulgfEmTxcjJ4eEgInErEez2UBsIYEdjBInD3lDxGUlnr3bwQ5hC0vcbznC
        ClHznlHi8BewOJuArsSW568YQWwRgY+MEnO+aXUxcnEwC3xllth0dBoTSEJYIFHi8oo5YEUs
        AqoSJ751MHcxcnDwCthLfPrDBTFfXuLIr05mEJtTwEGiZ9ERJohd9hKLX84Gi/MKCEqcnPmE
        BcRmBqpv3jqbeQKjwCwkqVlIUgsYmVYxSqYWFOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgRH
        n5bWDsY9qz7oHWJk4mA8xCjBwawkwpvkmpsoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4
        IYH0xJLU7NTUgtQimCwTB6dUA5Pg87b5+yQ3G7/fk1asHf2gvSNkxt+UbY3qr+uk/kffPr8+
        q3duZNcz6SXfgxnybsvIWFUEHvoQEFcgupbh2/H3Lxfxhgjt9av98X5a2PfbXy8XunofONwX
        pbCjUOz9lvkJm3pcv64/+oaFiVEndN/TbRvTrx1eefZltlLo7ifbbaccst0dKVzb82393dil
        dcbl+kc4J+Uo6n8zXdfmNOXk1InnnokazJ7B6nbEaNOLnq4/X+bK5Xxt1/PbfSKKsyCPJ1H9
        hdXLjd0XHVTTMiyXTT7iwsyc7rg65e03fT+On+WZ3BprxV3yk5sFp6Td/zO39/UtNi955j72
        KkFWuXzGuvJFh80vC/f4aMVoRiixFGckGmoxFxUnAgAalSEFLQMAAA==
X-CMS-MailID: 20211018124505epcas2p143bb8374e3399e2670ced625862a8653
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124505epcas2p143bb8374e3399e2670ced625862a8653
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124505epcas2p143bb8374e3399e2670ced625862a8653@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jongmin jeong <jjmin.jeong@samsung.com>

samsung ExynosAuto SoC has two types of host controller interface to
support the virtualization of UFS Device.
One is the physical host(PH) that the same as conventaional UFSHCI,
and the other is the virtual host(VH) that support data transfer function only.

In this structure, the virtual host does not support like device management.
This patch skips the physical host interface configuration part that cannot
be performed in the virtual host.

Suggested-by: Alim Akhtar <alim.akhtar@samsung.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3dbfae32599c..a25b88721b34 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8010,6 +8010,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 	if (ret)
 		goto out;
 
+	if (hba->quirks & UFSHCD_QUIRK_SKIP_PH_CONFIGURATION)
+		goto out;
+
 	/* Debug counters initialization */
 	ufshcd_clear_dbg_ufs_stats(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5d39aeb2bccb..0c474432f2ed 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -595,6 +595,12 @@ enum ufshcd_quirks {
 	 * support UIC command
 	 */
 	UFSHCD_QUIRK_BROKEN_UIC_CMD			= 1 << 15,
+
+	/*
+	 * This quirk needs to be enabled if the host controller cannot
+	 * support physical host configuration.
+	 */
+	UFSHCD_QUIRK_SKIP_PH_CONFIGURATION		= 1 << 16,
 };
 
 enum ufshcd_caps {
-- 
2.33.0

