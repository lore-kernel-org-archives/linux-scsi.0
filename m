Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D951C4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 04:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C86F23BE2
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 04:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgLSEuB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 23:50:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46513 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgLSEuB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 23:50:01 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201219044919epoutp04ca8a731045c9f4206469fe80bfee4637~SBNvjYFJ72592025920epoutp04N
        for <linux-scsi@vger.kernel.org>; Sat, 19 Dec 2020 04:49:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201219044919epoutp04ca8a731045c9f4206469fe80bfee4637~SBNvjYFJ72592025920epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608353359;
        bh=s0llwHS/xL0pI/FKzryAh8MFmf/jyf2TBssjA501EQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=X1ZvFyq9wecM64CtRaakzbZuBxEl+rdyM0i8dqgkxq6Q/0tGzXBMFAyo2ny3gzgBs
         SoiOLbQKI3Y7Llh/VbMUPJs4hpjxBbjGyliNAAP4OUWLn91qRBuAXSxK6DJC4x//V1
         eV3NJun2pop5Ue8SxfJbyyLcldtvf7oGgqjGPKkM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201219044918epcas2p268fe725d6b1f0276cc2bcff1436fb8c2~SBNuumCxF1118811188epcas2p2v;
        Sat, 19 Dec 2020 04:49:18 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CyYDF2Vm1zMqYkb; Sat, 19 Dec
        2020 04:49:17 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        48.CE.56312.D468DDF5; Sat, 19 Dec 2020 13:49:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20201219044916epcas2p16927b09270a3d829520af414dd64d80f~SBNs5akeO2581825818epcas2p1h;
        Sat, 19 Dec 2020 04:49:16 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201219044916epsmtrp25074a4b25bfd97bcf3972667b135ab28~SBNs168Pd1908619086epsmtrp2E;
        Sat, 19 Dec 2020 04:49:16 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-18-5fdd864d08f0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        84.D5.13470.C468DDF5; Sat, 19 Dec 2020 13:49:16 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201219044916epsmtip1bd12bb97f4bf91379dac34165e3c6155~SBNsn0ENw0866408664epsmtip1l;
        Sat, 19 Dec 2020 04:49:16 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 1/2] ufs: add a vops to configure block parameter
Date:   Sat, 19 Dec 2020 13:38:25 +0900
Message-Id: <ecc0563a5a48e3339e59760cc8cb73a698061851.1608352548.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608352548.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608352548.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsWy7bCmma5v2914g2+veC0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBE5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyZh+4SZTQS9PxYnb2xgbGDu4uhg5OCQETCR+njLsYuTiEBLYwSgxceI5FgjnE6PE
        l0sfGSGcb4wSZ/a9Z+5i5ATrWD57PhNEYi+jxNd186CqfjBKnPvbyw5SxSagKfH05lSwKhGB
        M0wS11rPsoIkmAXUJXZNOMEEYgsLeEg8+HGGEeQQFgFVibYDjiBhXoFoiSXn/rJDbJOTuHmu
        E2wzp4ClxOL/y9lR2VxANXM5JG6f/Qt1novEqmfnmCBsYYlXx7dADZKS+PxuLxuEXS+xb2oD
        K0RzD6PE033/GCESxhKznrWDHcQM9MH6XfqQQFKWOHKLBeJ8PomOwyC3gYR5JTrahCAalSV+
        TZoMNURSYubNO1BbPSSm7O0DaxUC2fRhe80ERvlZCPMXMDKuYhRLLSjOTU8tNiowQo68TYzg
        hKrltoNxytsPeocYmTgYDzFKcDArifCGPrgdL8SbklhZlVqUH19UmpNafIjRFBiME5mlRJPz
        gSk9ryTe0NTIzMzA0tTC1MzIQkmcN3RlX7yQQHpiSWp2ampBahFMHxMHp1QDk8Smc4HvRPK2
        bzzDf6T/0hzh2kgP48QHEZs2t9lz8EdzNRjZTvL6+EUn4IpF+9xzmc1z5Gs811xj3l6nsftK
        6tqN3NeLFgV9FVy6zaph+tQ56cZrni997WEUd3uHY85pM7MvIclTQosya/ftilZYszVXycxb
        JHZLaHC9jWFm2/ZIMYXsPp7WriOpmZIbZkTnnpT732y6U+iinv2kW5m3foYfidh2/8gzz/6k
        RRycjfFdV7VVZC+5vmHd0/Se41F94J4pR86rfWCMYTxffX2W2I8dxjZ//sfaC7wz17qm720y
        TUWskIFL+ZuQ59yZ17XEPTjeKB688LVgozW3hOHHnwsspI1+hZlFN+WH585WYinOSDTUYi4q
        TgQAQC+ivTEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSnK5P2914g+ePxC0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGVMv3CTqaCXp+LE7W2MDYwdXF2MnBwSAiYSy2fPZ+pi5OIQ
        EtjNKHH63CVWiISkxImdzxkhbGGJ+y1HWCGKvjFKLLt4mRkkwSagKfH05lSwbhGBe0wSlybM
        BUswC6hL7JpwggnEFhbwkHjw4wzQJA4OFgFVibYDjiBhXoFoiSXn/rJDLJCTuHmuE6yVU8BS
        YvH/5WBxIQELiYfXPrDjEp/AKLCAkWEVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpecn7uJkZw
        TGhp7mDcvuqD3iFGJg7GQ4wSHMxKIryhD27HC/GmJFZWpRblxxeV5qQWH2KU5mBREue90HUy
        XkggPbEkNTs1tSC1CCbLxMEp1cDU3GbdHHtA4/AGyffP/vgtEFEW0A5rYXkdf9ZuzxmewyYV
        xZ+zUk5P2HD7gaan7NV3K28qHH1m33uhaL2lQ0r9lXVWOprinh6fVViSnhTtE/q3I3jWo41n
        Fm+IdP15fNGfLy9D9i3+wKG7YPKXs7V+H27lCG0yVS9+f/nRuph5H1+wG6wzVXKVueWqz1v1
        nfuimOhtLe32JE/Jz2IeM0oeLqy86ej42eloHPfDT/t1v9Ts+FV7f94StyMBy/1ez3E7+T7k
        qVI/748JisIvX3uab9y1V0x02dZnqbkJ5nfuirDe5EjnYbXi3uX/m30en0hOuFRGccrdo3Fz
        8/Sjb238Jc1QVBMxV2L6D43wgNf7lViKMxINtZiLihMBwvZCpfgCAAA=
X-CMS-MailID: 20201219044916epcas2p16927b09270a3d829520af414dd64d80f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219044916epcas2p16927b09270a3d829520af414dd64d80f
References: <cover.1608352548.git.kwmad.kim@samsung.com>
        <CGME20201219044916epcas2p16927b09270a3d829520af414dd64d80f@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thers could be some cases to set block paramters
per host, because of its own dma structurs or whatever.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 drivers/scsi/ufs/ufshcd.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 92d433d..58f9cb6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4758,6 +4758,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 
 	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
 
+	ufshcd_vops_config_request_queue(hba, sdev);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 61344c4..657bdbd 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -329,6 +329,7 @@ struct ufs_hba_variant_ops {
 					void *data);
 	int	(*program_key)(struct ufs_hba *hba,
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
+	void	(*config_request_queue)(struct scsi_device *sdev);
 };
 
 /* clock gating state  */
@@ -1228,6 +1229,13 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, profile, data);
 }
 
+static inline void ufshcd_vops_config_request_queue(struct ufs_hba *hba,
+						    struct scsi_device *sdev)
+{
+	if (hba->vops && hba->vops->config_request_queue)
+		hba->vops->config_request_queue(sdev);
+}
+
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /*
-- 
2.7.4

