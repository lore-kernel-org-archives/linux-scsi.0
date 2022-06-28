Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2FFCCA481
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 20:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiF1UNH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiF1UMD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 16:12:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC8F37AA6;
        Tue, 28 Jun 2022 13:05:12 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SJBcSb006374;
        Tue, 28 Jun 2022 20:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=/pNmDdT8p9MIDe2fOUZ0ESfMW/fxBIj0JHC1MvAQM/U=;
 b=rNpnLeij3XCAbp+pDO8ThSCp+Kz0NhkPaDNvImzqZqtR5Ftsi2DBl29vpTncvE+CQU/h
 99/lm1PtA4TUmfTE5dNwgwsuJPA1Pho30gB2U1oJr/ki4Za4lQT5vjnzhz2kwQCmo+FK
 tGmnOFIvN122/rQRe9WWagP8mZ31Z+AOzapHOp9PSzSsGn/0Ak+fhlRwd8hhD4k5ahrO
 7PVevW1oZoLp1iR6yyCcl4IpOF3h28LGg3t1WT6Hq2yJWR7wRI6aP0yIi5Ea2acAZJAB
 HB6rVtRYlI55RXIGb7fRjUrBIIbmKyzB+LXck9EdKh9Q6BizecjC+VZoNIVP004q+y/J bg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gws52f6nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 20:03:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25SJsvOH004522;
        Tue, 28 Jun 2022 20:03:06 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gwrt2v50m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 20:03:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnM9FwEOIL1CI4z/f9UrYav3SpI1baNgE69AdMxSh/FsMiXIooiO0kdtbgUpcIRFo5lAlkQifaaMsQ/bT3uUwzZkL2p9ETZ3ESYMzeb2M8hHoKVZEkvZQsruj8dMtrvDnZXC6aYH1mZcAD7AgqV2F6N2jKieUv1YQpSZfUZFi5VbQr3TXkFBiA5ZJVpb1tJKvesMVypaENL5U4cHi9U8ibPNRUOgSzWEU0czEEmZJvYjSHrcKpbahbMkNGG7WG7xLYFz5N1gaDMNbOT+5SyLlwX1o4rP91qp5tNaiKUM8j4C5cuLSAypS+vjx6An83kGnC1TV6jB3aLX2OMDn09QLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/pNmDdT8p9MIDe2fOUZ0ESfMW/fxBIj0JHC1MvAQM/U=;
 b=mlBwTnkoE3fz6aoRC5jrn+cXCuO0YOW7oyk7Pgx+b8jfilVQu53wNgk53y7uuliGMYBw/+W+UuMSN4jlNmvcahKJ04NsyWLf5Xi87bxY+MweUI6hmZgcQ5ACgTAMX4vUSzuNfZHYtza0OvmWIZ9vlGqzEsTZrxRb7vQSb/7R3tTI76gXv5I/bEygK+Ro4IRX32RaJP9Pqul8EgPUlyrhnaKdwU9YRFxkRpVtBBGVUuKkoLZdxIta1NskSlCN4K2NuaujgngHwMplKUSwrmokaWq1zvlLxNT0Ed4MDd5ujs+hJ/AQPzS+cTr7DcNDNBplZsReWqQZ5nLFsOEee4bThg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/pNmDdT8p9MIDe2fOUZ0ESfMW/fxBIj0JHC1MvAQM/U=;
 b=VY30j+l/U1ARO1vbjntqcfU1Z3UCQMuxZfWF+NsW4BlzcQ8GxuKubqRM56U+AF0AQDjp+16TQxrpyCxshymQs5C+p3hH6evNXfSQ0qZ29TrVwUcgXIXHLmzj0EAcxLzgD6nScs1luDEJWuq5hPS+SJPijPVhBuRLJ2R84uQHYXw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY4PR1001MB2376.namprd10.prod.outlook.com (2603:10b6:910:48::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 20:02:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 20:02:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 5/5] scsi: target: Detect unmap support post configuration
Date:   Tue, 28 Jun 2022 15:02:30 -0500
Message-Id: <20220628200230.15052-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628200230.15052-1-michael.christie@oracle.com>
References: <20220628200230.15052-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:5:174::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31c2a702-98d5-42b3-24ba-08da59412884
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2376:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zyJjEWDrMjj60UKtzsGr1fOwzjTLIVIfVacYmD/llePRP5cVqjKjtsDZARA7bj+pmtfPlnfPNTrbkHbebDeSrVzjk4Wo8/6nXeRFYoZT7GJkoakTnGZXJNIbnZltfh1h0DvtHR4diKbIbAR07tjUDaCSqvYS0vvi3Ry+ZTvWVEU8NHf+FDvXYzqW52IqTJgW4w1xb1nNKwc3zPt/PCJpWWeKFekFaPwd9w1mLi7SvE5rk311u1YiKCnVJxermcU9ZMTVHtQG8mpOJwRYGSKI8FgSpswbwsn+fTI9tS3o/XqWkXYPTUQ75EaAi3+x8Ql0tfKtu2NLmd5hppb0Tz6FBGI6Dvk9i8NRPQRnAaqIBFoCtKKAXjZEIOtjKp5oTrlIkp74jkbvee9s5ZFZpHtaHpK37/GH3yGLMzk4grm4mS7oV+xHi0hKYb2Vt+GeKjRFOwBpw2F8CimSgOiNqZOS0WQCG4JM6V/cajh43aPdCG5eYeqvTFvbelSgYAvWT+Lp8GGKE8oPe+ci4xwSt0nCC2CMI1EXmr8D0P8QY4/+OxmBO6yEHYfKPvEZlgFAVTaNBIv3tl2xOUxrItG7ItcuF8K24ugRWj4uUp6Y5fs6+iDBji+079l5ZBSP0766nyFF+IbSROGpWZAJU+R7k2/DWys8TChZo3FlJmOmcvSxDYItRfQnIVVpZJ9OnIMF88Iz3P2qVjWCfLSIpKuFMkBcliRiyqiBFr6p0G7wYv4LLEMrjH+d06W9Of79TdrJLR86iO48D3v+8R70Wu7xk3hjucgdf4Q3cQwmCTUAblxXKGI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(39860400002)(366004)(376002)(186003)(83380400001)(8676002)(6666004)(6506007)(2616005)(52116002)(1076003)(54906003)(26005)(41300700001)(6512007)(38350700002)(38100700002)(66946007)(36756003)(4326008)(2906002)(5660300002)(478600001)(86362001)(6486002)(8936002)(66476007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MVASGn2l++GcUU5LtURzJL0FkEbVcRoo5Idc6KD0iOE403VCprYYQ0juriBn?=
 =?us-ascii?Q?ZXe4rOY4XnEjpWl4fzKWAKnMy2IYCuDSeBw/UjUGjYjltOg7olVI3Yi4gXpQ?=
 =?us-ascii?Q?np9l8OgxpsuQ629rMRXMSB1Ub4ZkJ56WQrGfY7H3Mcm3GNLDvz+J6hyevCuG?=
 =?us-ascii?Q?mTbmj5TtMirfuA4QpqxRZ/n3g9sUw3EGznSPLzZOMbKrIP1H1YntTC3X7Dzv?=
 =?us-ascii?Q?H37DL+/E3ii8dOrnw9NPair3jO3ph/IBA7CrmYldbjbnz5uyXShbWnrFoIW0?=
 =?us-ascii?Q?thssvj+rCixGEIXC9ighiNiTPFbRG1wTJzeH/EuSOHKmmyGyhWJ4hN25PiJw?=
 =?us-ascii?Q?0wvtx2NobJdqnAyAf2yQHWLjaxMecpRPNUGpWx5ZjACeMSP/uFT71lTEH5Tk?=
 =?us-ascii?Q?jIWQvtPQ2BaZt8yPX1lQ2kO55MQLdMOsZ/3sByJE1mrpgPrDq4KKE2jU2NSR?=
 =?us-ascii?Q?UMEPi9vBR7OLxjzBRrrYfK2Mev22iJwo2p370jh9lfuEaUtnayNRU1d5uB0+?=
 =?us-ascii?Q?JLkW92WLYMCFv+Q1Xm2H7GvPraSlDfLft4WfdnoKYD8xHNf/bMRX2av+tfkA?=
 =?us-ascii?Q?Imiph1imWGtbz69DqD1ggUUH74BoQd3eSJ0PRQ0moJ6KtrTxGf49qzAZz/Sj?=
 =?us-ascii?Q?ggm2HzkmNkwFfPZz3c2AOQWKxPs6GtpkJp+xdmnJyVjorMnzvRjTB4F63GiH?=
 =?us-ascii?Q?YHucAozBwESoi8ePo3FFo8DcWPy5OrPHhR9a913ifrZbOU3skMdbqhjzOJkN?=
 =?us-ascii?Q?4QQeMObnXbx534dHN8k5VrQotBM4IAVqx76CpkM9YyMuN+e2wNNLp3M7b3T7?=
 =?us-ascii?Q?bSE+N887qaOLn/bDMlEF2KNVi2EQEyuEzOQVlUhlyLVk1CUTsEfKL+4DxvjR?=
 =?us-ascii?Q?hHxQI0gT/EtzFcEf8MVICndh3YaAp2U5frGwwz90JUg/WSy/Lu7enZkQixKq?=
 =?us-ascii?Q?E/jLbtdgTR8Ogi7YqYLyXhA+sods3WKU58dLBQhXbGEgSkRdy8ZJTotludp8?=
 =?us-ascii?Q?VUztXQyRK+L6VJOE4CW0Zf2Ux4nbbk2nPuthgLqMgFIr5nQFwqEAV4s7pCl7?=
 =?us-ascii?Q?yHV9iFjvYhmzDlIYzHIiXXsQVqxJ4R/0wnbtCNUxEI2KpknOaVYTadvGFLVi?=
 =?us-ascii?Q?xjpU6Sunrs1+jmvWy0zNXd+1iH4XATFGukCiCg8P4+MQZ/7+KJkJxAfAqD7c?=
 =?us-ascii?Q?Qcg9qkGxvCefVD25rX+Z2N+de4KMLFXF8ya1N3zYBuUwPSEoFTURExIor1ZM?=
 =?us-ascii?Q?C58LvW2swnIltJEGlJ3iRXxDzQojvKnb93J+ogeaPPaJtMzcQoRcndjGyylD?=
 =?us-ascii?Q?70NtTD7kdgux5lzyMFnzLz+s8wgUl2hv2R+5xRwSWNzlOWBAtWM2jtOssae+?=
 =?us-ascii?Q?IbIZSUrwwRDLJ2+Z8AYufE8bSQb89Ysigjrq5gzzUgV0sd+bIDs3vlUSQsJE?=
 =?us-ascii?Q?Dsnd2P7rDb5nsaHsjMCuxIZoXGLGvPWs9poVV70CPa2WVRWxicQSJz32xB3z?=
 =?us-ascii?Q?jS9pqW4lhY6Ryh1kR3QDgGkzowa3v9oG2Fr7WLKZ6zlhuxZ7d4DVZDsGeOcH?=
 =?us-ascii?Q?Gt3IznP1Tq2vszkA/LyuRaP1PV0JSBvoh6/JpvXU2kb/JcbAG+efMTmaIOf6?=
 =?us-ascii?Q?rQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31c2a702-98d5-42b3-24ba-08da59412884
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 20:02:41.5403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VwYIZ7ZYb0petBmLPqQeOWAI1KcaUl+rZfB77334Woz/j8kjcbWd+6qajXAGjNi6A6xU6q4NpAzhmuqbgt2eN8ndnF5Jn91O08v0akWaZlg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2376
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-28_11:2022-06-28,2022-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280079
X-Proofpoint-ORIG-GUID: KHjtdYsBd2EtqCuNHdSEQXsiesvQo1A4
X-Proofpoint-GUID: KHjtdYsBd2EtqCuNHdSEQXsiesvQo1A4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On our backend we can do something similar to LIO where we can enable and
disable unmap support on the fly. In the scsi/block layer we can detect
this by just doing a rescan. However, LIO cannot detect this change
because we only check during the initial configuration. This patch
allows unmap detection to also happen when the user tries to turn it on.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_configfs.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index bbcbbfa72b07..f28d3c6dab98 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -732,6 +732,7 @@ static ssize_t emulate_tpu_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
 	bool flag;
 	int ret;
 
@@ -744,8 +745,11 @@ static ssize_t emulate_tpu_store(struct config_item *item,
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		pr_err("Generic Block Discard not supported\n");
-		return -ENOSYS;
+		if (!dev->transport->configure_unmap ||
+		    !dev->transport->configure_unmap(dev)) {
+			pr_err("Generic Block Discard not supported\n");
+			return -ENOSYS;
+		}
 	}
 
 	da->emulate_tpu = flag;
@@ -758,6 +762,7 @@ static ssize_t emulate_tpws_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
 	bool flag;
 	int ret;
 
@@ -770,8 +775,11 @@ static ssize_t emulate_tpws_store(struct config_item *item,
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		pr_err("Generic Block Discard not supported\n");
-		return -ENOSYS;
+		if (!dev->transport->configure_unmap ||
+		    !dev->transport->configure_unmap(dev)) {
+			pr_err("Generic Block Discard not supported\n");
+			return -ENOSYS;
+		}
 	}
 
 	da->emulate_tpws = flag;
@@ -964,6 +972,7 @@ static ssize_t unmap_zeroes_data_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
 	bool flag;
 	int ret;
 
@@ -982,10 +991,12 @@ static ssize_t unmap_zeroes_data_store(struct config_item *item,
 	 * Discard supported is detected iblock_configure_device().
 	 */
 	if (flag && !da->max_unmap_block_desc_count) {
-		pr_err("dev[%p]: Thin Provisioning LBPRZ will not be set"
-		       " because max_unmap_block_desc_count is zero\n",
-		       da->da_dev);
-		return -ENOSYS;
+		if (!dev->transport->configure_unmap ||
+		    !dev->transport->configure_unmap(dev)) {
+			pr_err("dev[%p]: Thin Provisioning LBPRZ will not be set because max_unmap_block_desc_count is zero\n",
+			       da->da_dev);
+			return -ENOSYS;
+		}
 	}
 	da->unmap_zeroes_data = flag;
 	pr_debug("dev[%p]: SE Device Thin Provisioning LBPRZ bit: %d\n",
-- 
2.25.1

