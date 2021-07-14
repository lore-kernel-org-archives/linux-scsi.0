Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3C5C11F6B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21A16613AA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238234AbhGNHPN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11763 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238265AbhGNHPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:15:00 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210714071203epoutp02165ed209c0fb85db750817fef9987ee3~RlsdRt9532739527395epoutp02B
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210714071203epoutp02165ed209c0fb85db750817fef9987ee3~RlsdRt9532739527395epoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246723;
        bh=UtUs0ckI1WjMnBc4T0luZfxA+lX2d3D8Loe91SggtwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvQ+wweWO5uEPyr2xRDuLkJ2/5Yo+cN0rRzSDt3rHIvFm0pWb71l37ktFqDpRj1yk
         wM5uSBeX92lEEhbStLrgPXVWZw/lUUuhBQSnwFq+l2CMZvfc7EQkR3S6UKjAQ9Q6nX
         MFti4gDGa/SxWOsv5VagNIR3gyrmFvZMqzPfxr6s=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210714071202epcas2p23d205134a67fd0954415d1a520e9487c~RlscYmk5z0402804028epcas2p2R;
        Wed, 14 Jul 2021 07:12:02 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GPpbN20jZz4x9Pw; Wed, 14 Jul
        2021 07:12:00 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        A9.3D.09571.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epcas2p3d39f7e5cbd9a2b8addaa496a396213af~RlsZk8fOT2304323043epcas2p3F;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210714071159epsmtrp2151ae4dbcbde4a57cea81574f66667ee~RlsZj7DHz0755107551epsmtrp2m;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
X-AuditID: b6c32a48-1dfff70000002563-06-60ee8e3fda68
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        34.17.08289.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071159epsmtip2e7df4a6e4267308d397cf34bad42c361~RlsZV3eJz2387023870epsmtip2D;
        Wed, 14 Jul 2021 07:11:59 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v2 06/15] scsi: ufs: ufs-exynos: add refclkout_stop control
Date:   Wed, 14 Jul 2021 16:11:22 +0900
Message-Id: <20210714071131.101204-7-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714071131.101204-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTVxj23FtuL5CaS2HuSOJkV5mDpdASWg8Kg01CLgEzyPyjWwI3cNOS
        lbbrBYLLtoAT5aMwGGFAddOgqONDCFZgfvBRhA6YK6OgjgQ3DA2UDINgTDCOre3tNv4973ue
        533e9z3nkLj0VyKUzNMVcEYdq6WJAFHvSIRKlljzNFveNBmLxhc7CPTH970Ecm3OEujbtU0c
        rXdd8UOOwXeQ6ccjaLK2BUOLXWYctTzqxdAPDxCy27vF6DfLqAg12QcwVPWwn0BXbVtYEsU4
        ZtIYR001xty4FslcuuPCmJ62CoKpbRkCzDPnnIipsbQBZqPnDebsUBWWEXBCG6/h2FzOGMbp
        cvS5eTp1Ap32YdaRLKVKrpAp4tBBOkzH5nMJdHJ6hiwlT+uegw4rYrWF7lQGy/N09LvxRn1h
        ARem0fMFCTRnyNUaFApDFM/m84U6dVSOPv+QQi6PUbqZ2VrN2PQWZhgRF8+2LolLQCdRCfxJ
        SMXC+TPf4JUggJRS/QBWL46JhGAdwN9dHUAINgC83uj4T/Jdw4xPcgvA5cZSsRA8A7Bpy+ll
        EZQMWpZWvPIQT+G2S/Pewjg1jsPJi8NiDyuYSoPTY5e9WESFQ9vAgp8HS6hEWP/noFjw2wsn
        rgxjHuxPJcHh7jUgcILgePOiyINxN+erm+e8PUFqioQXSmd84mTonHP5CTgYrtgsvnwo3Hh6
        lxAEVQCWPfnbd9AOYEVpuoAT4ctGi1tMuh0iYNetaA+E1D54b87nuxOWj/wlFtISWH5GKggP
        wKG+RpGA98Cq8xu+Dhg4NfGYELZVD6Dz5QRWC8LM28YxbxvH/L/xRYC3gV2cgc9Xc3yMIXb7
        JfcA79uOZPrBudW1KCvASGAFkMTpEElrzGq2VJLLnvyMM+qzjIVajrcCpXvZdXjoazl69+fQ
        FWQplDEqlTxOiZSqGES/LiHF1mwppWYLuE84zsAZ/9VhpH9oCXaqdaY+nhye/hoLGT20LGlv
        bkD+1yydTwJvRD+ci5W+SOLVGeXJaXWtjqT3bOEHB0KK8798cOpOd0kkH2+aDnm89ukr1479
        u9rv7+vjTI/6g37uC7BrnIWOitovasrub7EjuCw8ZTb6tF/meXpMcyBlebczgqx860KZKdCV
        VWQ7sWevyRBVnWqVBVg/33/4l6nNBe31ltrJYxm3b4fO2whzwwelO+atUfbl4/Ppb+48xrbl
        pWZanr8YNfWd7nj+08rhsx2X1+M35EspLdNBzZ2viq8miLSBuZuqutS3Y+lg+b0mtZE7mTjy
        cdHSbkXH+8dvZmJyU9zq4ELe0btHP+rj7LSI17CKSNzIs/8ATqwLIGQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42LZdlhJXte+712CweuPPBYnn6xhs3gwbxub
        xcufV9kspn34yWzxaf0yVovL+7UtenY6W5yesIjJ4sn6WcwWi25sY7JYec3C4vz5DewWN7cc
        ZbGYcX4fk0X39R1sFsuP/2NyEPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxRXDYpqTmZZalF+nYJXBnHLv1jKjjMXnF16XP2Bsa1bF2MnBwS
        AiYSc6deYe5i5OIQEtjBKLFs0wlGiISsxLN3O9ghbGGJ+y1HWEFsIYH3jBKtf6xAbDYBXYkt
        z18xgjSLCOxilDh85jA7iMMscJlZ4ts0kLGcHMIC3hKXji0Bm8QioCpxfN9DsEm8AvYSk9/s
        h9ogL3Fq2UEmEJtTwEHi4IYPjBDb7CX+bVvNBlEvKHFy5hMWEJsZqL5562zmCYwCs5CkZiFJ
        LWBkWsUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERxbWlo7GPes+qB3iJGJg/EQowQH
        s5II71KjtwlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1
        MC07d6W4pz/9Y0py9Pvp9SZXOi0OLLS77aMm8rUzQ/z0VPe38Z4HePeUP00M0UyVXzeTV153
        4fzn84N8C+ZtOe0svddSz1nuTZSY8hXRNNdQi87MNuUp1efvuj8J9xWv1FgvbWAV9umBBeuL
        19u4uq9cnpb+ahdfBI/6FqE7Vx7YMTk5nl6Tfcic8fTcEyItRv8WRJYfDeDLCxdQXrNfcvuZ
        BfdmrJ38PXK38b3YVUsOXy35MnHVsjtT//0w2qycoVykP1svZ86Mexl15o/m3Xs6yezpp3kP
        nALCJG70c69cavvS48rkOW+3X3ufVxF+x3Fd8Sa/Iz7qdeYnanuub3q1qYorrYGl9KeBdFGk
        e6ESS3FGoqEWc1FxIgDuo8WTHAMAAA==
X-CMS-MailID: 20210714071159epcas2p3d39f7e5cbd9a2b8addaa496a396213af
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071159epcas2p3d39f7e5cbd9a2b8addaa496a396213af
References: <20210714071131.101204-1-chanho61.park@samsung.com>
        <CGME20210714071159epcas2p3d39f7e5cbd9a2b8addaa496a396213af@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds REFCLKOUT_STOP control to CLK_STOP_MASK. It can
en/disable reference clock out control for UFS device.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index da02ad3b036c..78cc5bda0a1f 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -49,10 +49,11 @@
 #define HCI_ERR_EN_T_LAYER	0x84
 #define HCI_ERR_EN_DME_LAYER	0x88
 #define HCI_CLKSTOP_CTRL	0xB0
+#define REFCLKOUT_STOP		BIT(4)
 #define REFCLK_STOP		BIT(2)
 #define UNIPRO_MCLK_STOP	BIT(1)
 #define UNIPRO_PCLK_STOP	BIT(0)
-#define CLK_STOP_MASK		(REFCLK_STOP |\
+#define CLK_STOP_MASK		(REFCLKOUT_STOP | REFCLK_STOP |\
 				 UNIPRO_MCLK_STOP |\
 				 UNIPRO_PCLK_STOP)
 #define HCI_MISC		0xB4
-- 
2.32.0

