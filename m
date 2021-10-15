Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2805C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 06:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89778610E5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 06:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235682AbhJOGvz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 02:51:55 -0400
Received: from mail-eopbgr1300094.outbound.protection.outlook.com ([40.107.130.94]:6377
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230512AbhJOGvy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Oct 2021 02:51:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SrRYbZTpu/rEpv3jJ7T9BY3mvAkkikJEyZxlNyG8MTQZInETsTpo6S5LpYMJ1XJkTIClmPN7/LLQfgKvNPin8ONt4aTT21XoC+eBIOcKR9J4fnMdzdICQJRfX1nlaqzCZoVMmBb2IFWwIYLfUqKETf8ozy0XWE38bkfIEPQ3mmjYCNloACz2sn6TBfwEDsBIF9p/mbmvSx8huVhxSuu5iwd7v+VPPnk2QXYy2kWwT2/fE7syN3bI4UVf1xObgAvBYe1ZfX1pad8hch6DSqepKYwkqXdK/NUadqXzQJR6BkpnLKqYK06rSIem4bBDTmiHxCcmtlWZjZF+Ht/mnW0Fqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7GFrZ2kpj0iJtiuCp/XFuuTcQEjI8fi1hB8aAQYlMAk=;
 b=QmueUErdPq+OyA/ldjXFvNCtzbLKtTERNCISY06Su5E+iiH6c5iBDmvlvvNqs/tDNySLugSL/V3h+blLz57qWnu6tlzGXEwNVTod/7hTLMzJPWGE/JbmDs/qYPebtezlC7JxbBPH1sR0H4Z121WDBfB+nSP0l/hwTEphwrSnlwaUwGOx1wpQEiH2LvNFb/UZHw+hstfUU7ju2U/7AWcv7bAeSWgZxFOjxdTRJ7SBbQPpTGM6IG+BlT4uk5NlL5ZUwHKowGDnWLUgg4KymT2zMCMB+NZ1eMqzUj0jfLriM7YlfyA6SF8Fr9IbLcPk6NdIqmj0wSKK0rBPI+vfVKBmkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7GFrZ2kpj0iJtiuCp/XFuuTcQEjI8fi1hB8aAQYlMAk=;
 b=YBvAuJ5teR6dmqWSfjlj46Ua1dAOuUUMM9Lu7Cwdht1nvaGvAoq/H3Y8RQ1FHV1q56rUfyf+fd8i1gGlHdbiJcFDJIQ3wcSNKn0e8sYApa7x0opEe4Pc9bkLfO6Hu9zKnSyqya6oqJBMuN7cFmPcg0oMkwaMNfmzlTh3IjT0sho=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3388.apcprd06.prod.outlook.com (2603:1096:100:3c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 06:49:46 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 06:49:46 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Qing Wang <wangqing@vivo.com>
Subject: [PATCH] message: fusion: replace snprintf in show functions with sysfs_emit
Date:   Thu, 14 Oct 2021 23:49:35 -0700
Message-Id: <1634280575-4675-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0002.apcprd06.prod.outlook.com
 (2603:1096:202:2e::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
Received: from ubuntu.localdomain (218.213.202.189) by HK2PR06CA0002.apcprd06.prod.outlook.com (2603:1096:202:2e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4608.17 via Frontend Transport; Fri, 15 Oct 2021 06:49:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eeef5f7d-0d97-4981-88e7-08d98fa7f9a6
X-MS-TrafficTypeDiagnostic: SL2PR06MB3388:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SL2PR06MB3388E0C1855561843C5DE5E5BDB99@SL2PR06MB3388.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:248;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x/w3SI4HvjcE4RhRODDv3mFIIZJ1mwdMYLZdlTMZNotq8AI0m4Kn9uGMaw8+TbnYXLOJHIE+A9A2fe1TE2+KsA0egEq7aPWZx+hKMNBR4PIs6tTQNdsB2bzcE92VS2MvzttI44qpmt99JrUIew7naT7EIyzVzmd9ebiw1kiMzSYav87mcwKAFdult0Pwf4grGodgbK37eFy9KiWiM3y/wtoMZZIyfQER8GHDDlAFPC0oYhAu8//gIGt67bLahYsV0QAuGsNNjzYxx4bXVA89U6MMzS60U0TB/6PTVaAvSSJRgyHNwt159tai+Rhm+cAdoanbAXrInvy3bHY7g8hXle7ORmPy6jJBK0I6dTXT8w7czm9+njR2/kyws2t7a002ySszhYvO70FM6VoKm45s7F0oEYJN6HD3hW5NWgS0apf0qJHhluIjdDdlaMnmbw4QRK/oDS/5nlqLGM/6y8LZlxWb2HoRV/yFmIIIYDsE4Xrx2sutAug5IoUO4FMX07zVUTw3AauAVJj1nms/4yJtzzkCwUIx07Rs5e5ey/eokDRw+vB5hvn4q3yT9nwl/bdaxMCYhJWW3OXr2YX8H96ssig5VymWOzZdmGk8wMiQcq0J1mos7j/VX6+s/QUORzQnW451y+i+xc2K9MnOLcJ3hp3U53uMxUSh5ZZNMHRbL+L8pqYaIeY+y8B4OmF0a67An5b3ySB+ZKdur0vRBN6Knw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(38100700002)(2616005)(316002)(2906002)(26005)(107886003)(8676002)(15650500001)(66556008)(83380400001)(186003)(66946007)(6486002)(956004)(508600001)(36756003)(4326008)(66476007)(6666004)(6506007)(8936002)(110136005)(5660300002)(86362001)(6512007)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QTckuCKHZvLDK6yHN5H5ZqNJYj7F/8uInuvETgfiEE2tHmJT+s/P3N41/lWD?=
 =?us-ascii?Q?BBkLuaS5FcVUSlVp9wPovjuSrveib+CMkQts9MPXX0M0Q9D4soNdlKnieqp1?=
 =?us-ascii?Q?FG5wn4N6pdyMsdS+ukSkLfmnK60vowcWWmcOQ6BLNWWQCcBsCiUhfbTAyroa?=
 =?us-ascii?Q?QhDgkPK7Qd/jK0SBlrMVH2fYGPbI1Hur5mM0Vk7/P8iBcWQPNEqrjbx88++d?=
 =?us-ascii?Q?bF/2Ci8y6XYuOP23peI+mUFzmECY3/TtpMr9jF20Jckusfk8ifCHF2PBBlAa?=
 =?us-ascii?Q?csu9qECRUrD4cEjlp5V/PfDdEzcz1loGkuKHaPCuqCDDCTSmZ6B5r2hCEst9?=
 =?us-ascii?Q?eFKtZFqC4FPxH761cn82pNT/XjrBKucmGiL3bcdFHXVc8FfdARUdfda4Af7F?=
 =?us-ascii?Q?MvmSJdQjLHlWcnlBiE3tsQkj9rPnskI9OdHb7sQGw1AmtxiaxaxND4aPX+ZU?=
 =?us-ascii?Q?y3v2/kXceFcIg7ib3h3cqjR9aOG12Pz2nUDFNh450XO4WST/395TYm0Nqr4T?=
 =?us-ascii?Q?qzuKqNrCAByTiVo0/y0QwFv7XTNaXG390c6IkbL9TMceJSnA6bRFSmKl0sNT?=
 =?us-ascii?Q?KGtVDpyIQxw6NSRGGKb3TSeVfHYSWm5bXZQcavFnNr/cOa/aOma+jRsQEboe?=
 =?us-ascii?Q?wBgiE9CWbG/lEyan4ZzPlg01C4v4/HWrPWiFL+0q/gDiG0ppwpyrCnG8hfDt?=
 =?us-ascii?Q?q8hJEHu2WEqIu0Ex/ScdtdmOFyHdMaBHX3DEAFN4sfDFmThTyoMEbZqhwnr5?=
 =?us-ascii?Q?+W2ggEGyqb4vlj+QsFmoB2evpBOhG+hfY6QJcOQ23O2NPLkzSjWhs+FnSMKZ?=
 =?us-ascii?Q?fvP4M05QaYwVwI9qr4PK8sOun1LSvzLm6LSN6dnOHbCHtEUQ/oP6A59J27mi?=
 =?us-ascii?Q?22BXk2xwTcduQuVmS2jtZlO4EVwB8bXzbfO8jIe4bN6c7QQDhUSNyrUTcsk6?=
 =?us-ascii?Q?ofLWkvkPZxl4D429TOtywparna9e5jDZamTpW4rU8tLfL9DSaIcqREOs0JPf?=
 =?us-ascii?Q?DKHBm+bleUCs98wMod5uafSKv/RMqMD/YdjX0jxkEFEH6db6A1KSwnOmh65K?=
 =?us-ascii?Q?xxoY7FpA9AMOsO7OTkA+DUBZKquzKiF0H7c6MRXe3E6xcJB+WUU/QpbPK6zU?=
 =?us-ascii?Q?E3iHiJ1QVG8rBaClPqJsRMubtBTRHR/j2adu3dfHrX0IVBtmmWET8my3bFvO?=
 =?us-ascii?Q?1NrqrCAbayhhT+X3gauVvMo749ppuFSv92oy6z3blRztfdtjZcdmJDUWWVHZ?=
 =?us-ascii?Q?VFC33JBIdHW8N0CJEykgTjcwpwJLHbuKda9IZoh6N9J7w0EaFkZkfjZ+PBJx?=
 =?us-ascii?Q?VgMlfJiefEMYGC5/UtiTZZRd?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeef5f7d-0d97-4981-88e7-08d98fa7f9a6
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 06:49:46.1676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GgRG6wHSJP3qQO0LoW5BcrEAKmqAmj/8fe7Ub7IvDKRd5u7hTc2jEtfOdv7imFkDkYpn5KArBmEM2F0XjFIP3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3388
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

show() must not use snprintf() when formatting the value to be
returned to user space.

Fix the coccicheck warnings:
WARNING: use scnprintf or sprintf.

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Signed-off-by: Qing Wang <wangqing@vivo.com>
---
 drivers/message/fusion/mptscsih.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index ce2e5b2..45bb974 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -3046,7 +3046,7 @@ mptscsih_version_fw_show(struct device *dev, struct device_attribute *attr,
 	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
-	return snprintf(buf, PAGE_SIZE, "%02d.%02d.%02d.%02d\n",
+	return sysfs_emit(buf, "%02d.%02d.%02d.%02d\n",
 	    (ioc->facts.FWVersion.Word & 0xFF000000) >> 24,
 	    (ioc->facts.FWVersion.Word & 0x00FF0000) >> 16,
 	    (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
@@ -3062,7 +3062,7 @@ mptscsih_version_bios_show(struct device *dev, struct device_attribute *attr,
 	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
-	return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x.%02x\n",
+	return sysfs_emit(buf, "%02x.%02x.%02x.%02x\n",
 	    (ioc->biosVersion & 0xFF000000) >> 24,
 	    (ioc->biosVersion & 0x00FF0000) >> 16,
 	    (ioc->biosVersion & 0x0000FF00) >> 8,
@@ -3078,7 +3078,7 @@ mptscsih_version_mpi_show(struct device *dev, struct device_attribute *attr,
 	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
-	return snprintf(buf, PAGE_SIZE, "%03x\n", ioc->facts.MsgVersion);
+	return sysfs_emit(buf, "%03x\n", ioc->facts.MsgVersion);
 }
 static DEVICE_ATTR(version_mpi, S_IRUGO, mptscsih_version_mpi_show, NULL);
 
@@ -3091,7 +3091,7 @@ char *buf)
 	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->prod_name);
+	return sysfs_emit(buf, "%s\n", ioc->prod_name);
 }
 static DEVICE_ATTR(version_product, S_IRUGO,
     mptscsih_version_product_show, NULL);
@@ -3105,7 +3105,7 @@ mptscsih_version_nvdata_persistent_show(struct device *dev,
 	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
-	return snprintf(buf, PAGE_SIZE, "%02xh\n",
+	return sysfs_emit(buf, "%02xh\n",
 	    ioc->nvdata_version_persistent);
 }
 static DEVICE_ATTR(version_nvdata_persistent, S_IRUGO,
@@ -3119,7 +3119,7 @@ mptscsih_version_nvdata_default_show(struct device *dev,
 	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
-	return snprintf(buf, PAGE_SIZE, "%02xh\n",ioc->nvdata_version_default);
+	return sysfs_emit(buf, "%02xh\n",ioc->nvdata_version_default);
 }
 static DEVICE_ATTR(version_nvdata_default, S_IRUGO,
     mptscsih_version_nvdata_default_show, NULL);
@@ -3132,7 +3132,7 @@ mptscsih_board_name_show(struct device *dev, struct device_attribute *attr,
 	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->board_name);
+	return sysfs_emit(buf, "%s\n", ioc->board_name);
 }
 static DEVICE_ATTR(board_name, S_IRUGO, mptscsih_board_name_show, NULL);
 
@@ -3144,7 +3144,7 @@ mptscsih_board_assembly_show(struct device *dev,
 	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->board_assembly);
+	return sysfs_emit(buf, "%s\n", ioc->board_assembly);
 }
 static DEVICE_ATTR(board_assembly, S_IRUGO,
     mptscsih_board_assembly_show, NULL);
@@ -3157,7 +3157,7 @@ mptscsih_board_tracer_show(struct device *dev, struct device_attribute *attr,
 	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->board_tracer);
+	return sysfs_emit(buf, "%s\n", ioc->board_tracer);
 }
 static DEVICE_ATTR(board_tracer, S_IRUGO,
     mptscsih_board_tracer_show, NULL);
@@ -3170,7 +3170,7 @@ mptscsih_io_delay_show(struct device *dev, struct device_attribute *attr,
 	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
-	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->io_missing_delay);
+	return sysfs_emit(buf, "%02d\n", ioc->io_missing_delay);
 }
 static DEVICE_ATTR(io_delay, S_IRUGO,
     mptscsih_io_delay_show, NULL);
@@ -3183,7 +3183,7 @@ mptscsih_device_delay_show(struct device *dev, struct device_attribute *attr,
 	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
-	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->device_missing_delay);
+	return sysfs_emit(buf, "%02d\n", ioc->device_missing_delay);
 }
 static DEVICE_ATTR(device_delay, S_IRUGO,
     mptscsih_device_delay_show, NULL);
@@ -3196,7 +3196,7 @@ mptscsih_debug_level_show(struct device *dev, struct device_attribute *attr,
 	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
-	return snprintf(buf, PAGE_SIZE, "%08xh\n", ioc->debug_level);
+	return sysfs_emit(buf, "%08xh\n", ioc->debug_level);
 }
 static ssize_t
 mptscsih_debug_level_store(struct device *dev, struct device_attribute *attr,
-- 
2.7.4

