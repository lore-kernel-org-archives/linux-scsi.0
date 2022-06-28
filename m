Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24887CCA497
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 02:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244739AbiF1Cdx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 22:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244980AbiF1CbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 22:31:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D852529A;
        Mon, 27 Jun 2022 19:30:11 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RK02WF031609;
        Tue, 28 Jun 2022 02:30:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=GfQovHwOwOOb/ZjRzBJKGHQud/6QBqk3DPTjWhSwUIE=;
 b=uj4iFPXGKxEEYTf2KpO1cO4cFautdF9oKK2rrfT/KmJg9V09tNMBzE407YUCrWAksCqS
 h5aWk/B84YAIjKJZfhaXWOxhEeOwDPFUpFnJh2eMXJBssh9+s6AkqPUW42UTOc8g57TJ
 WmE+uyNk0mKVBrrd0e7F7YX63SZGTAvUVZnK6WajIL6J0BGJeg5MyifTcm1/nn3JBCvo
 AR96nOVTT95le3G22RjQka/AYdL+Ccv3Muwx5mVtPl+L918pArYQcFW3FARUkXH+QYC0
 HDrVuQyv/mdbTb+sN8cM6htw43mzbA0Ob9F35KECZlHfgx1TTvUD97qo9LwFG+CyahkH Kg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwrsccrkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:30:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S2KJsC018705;
        Tue, 28 Jun 2022 02:30:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt1t5vh-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:30:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVvYHIgPPV9+OKNhvrXR8/KIFHO+o70RHgzYO8mHaBVGTdXFHMZt5A31rMFbUF/Mmvq3kVkClTiBkO4bGxCKmASKSih6G8Gi8xFFXJK6A/iGeeRSYmwAMd9WQ9MaBAVLajRHjhjGyhHCRpfyteSpz84dub5wtx/x9JMza3A4JZX2meAo8qAzdVLV07VIQbr2egOdEBCgBNnAABIjQgkRxpLt7csusVt0IjXVzXsbtQMf51TRxSyGoOHGDtj3rcc618AXeACFpUOLGwnnBcePYbLMAzpxvSLG6E99v13MDaMJNsw385B1rexbI+cATVPcOJPvehe1kpnUuMUNmqweOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GfQovHwOwOOb/ZjRzBJKGHQud/6QBqk3DPTjWhSwUIE=;
 b=I1CUckBb9qYLmar/tCCHHj5/WcDd/1W0IUu2b7mmqhVaMvP+1Daib/goOGiO2nwB0odfuHPYwGEVtrkiEeLp20s9RTRZ3icMGV130bL4Go9O8wwG3xq+VS7Wk313kwNaqvaaS/spL8LwynM/vE2E6aCUjlUsVh8mVtQDsqgfojAVnsP2RvQ2vq/RKh7cGx5npGg2dqOlq8Fe0BCxN7wnLkO+Tee6akAjdQaWe7/SQSpKPbSm7OteamZ4mjV6LdeEKtb8lzA35eOkwp6vza2CICOP/2mfpneidPxJluPDE90Aeb2FxFXCFYMvwPYs8mSfzMlq2LvUYY4Ifa+auR0vpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GfQovHwOwOOb/ZjRzBJKGHQud/6QBqk3DPTjWhSwUIE=;
 b=DLL+fLwDQm/Ed4+tESwYh66b8Q+pRoczHSM30Xyxg8mp6cH0QS4ZxUNh4K0YuH3PJ6rwmK8RT89gTyGen5kUwtiBW59hVXtRvImcmNVLED6jQEpN+eLLuLP2xZ3eX9K2qqx+CDUM4DaYawQ4ZOIeMMJCjc6zDRvu+LAc5iww35c=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB5140.namprd10.prod.outlook.com (2603:10b6:208:320::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 02:30:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 02:30:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/5] scsi: target: Add iblock configure_unmap callout
Date:   Mon, 27 Jun 2022 21:29:51 -0500
Message-Id: <20220628022953.20948-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628022953.20948-1-michael.christie@oracle.com>
References: <20220628022953.20948-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a11e666-2a53-4cf4-ed54-08da58ae1a83
X-MS-TrafficTypeDiagnostic: BLAPR10MB5140:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1rRNHqBWIgazxwr0cYtCyORydZsaxri76Z57EffEWQMIldWvLiruygyTfZq8yr2Zq8IhFRd2SPflMuTt5wcgJ+GFxgxeLM8jwcVDyYL7DIRaCKCiDmEO0nizOE09QCYQcmnu8vIYbGA+houOINqfsv+YdD19G+8IgTIqE7b/oeq5oiSUUfoDzBedXOsxdqvxM5ZgqEdxRohogv3E3L3SE38eXWX5CZ8gcZw56PcpfEMLW3U/LdMzOxGHT9Zn0hKX4PpQWfDZ3dE+nbeZiSETQstn8rWP30SGd/LUO+PbRMq7AA+85orCbvgjLnVkjPvVeIEDnS9xGnLdT/MdmE/YpPr+GbCtusV2N+ec2hgf//3pZi5u0tVE/Yvkfk3uorgNusZYUZFhyPRmrJG2cscpOIJ/B3hGDnQY1tdezu5Y0DtsQA/reJqfVA6g0A032J5qsOf3daGmVH5ZlAQhntZnz8PZ6SxKCsdNsHMpbzd6jMjSnV5YGSGFtyuw/jxbgOuAeeEaJDHDxwkdbezEN/rCBCn+iQO1XXkO2vEwp+hNqKsJqceJv9CMpIjtMtZ3vTE9yqBa8FStSjmB0vOFjR8Hnf4RKypbQ24ma5MZgt7HBufV8VccHvaeFm8i+MAqAI/A7w+f1kCeSO6nFon+TBGbN+GV9/2xF/ppGc+R36633GtdQndKx3kV/T3UfAOZ660JOrDWZqC4xdyrFmkVaBKOTjsBNosjalgx9lWEbfXHbI4aPnfbPjE6f7QhhOsYJalHE92ZurGO37jZcY153AEQFJ4TARdbx02MekjI3k8Sg3A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39860400002)(396003)(376002)(346002)(478600001)(26005)(83380400001)(2906002)(52116002)(107886003)(6512007)(6486002)(2616005)(4326008)(8676002)(5660300002)(186003)(66946007)(6666004)(66556008)(8936002)(1076003)(38100700002)(36756003)(41300700001)(6506007)(38350700002)(86362001)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ab8ynY6/8+qjf+uMHiu97gsjv9F0w3v+bTrKdnZyQp92sz7VlzLAvqAeFL03?=
 =?us-ascii?Q?yP8Oq2oa+z+d/XrV7ZPew3MQvTQI3hTUbntW/MotRvnoP8btApjOEP4iWYUD?=
 =?us-ascii?Q?MaT5u72dXeGHoweeZ6wvUaJ+e0l6/XXQcEbVoW138lHvks6U/P9bAfJRaPJO?=
 =?us-ascii?Q?HYNIPA1dmhc1P95POt3HYp5eQgnxSf3Lr8FWYBpdy7NAkzWe0wkv4TJbqk11?=
 =?us-ascii?Q?KGntAuKD9XafGVt8dn7UwbIMg//u60xtRzCGl3ACECipZO1cTE2g7qpRogqA?=
 =?us-ascii?Q?9HX1o+4dT39qaR+NZF9/mPbpm5IUsQ6XZcEjYYAaOzCpTIYbRlFM55IFzTU3?=
 =?us-ascii?Q?q1zLXWRrrmlBFxrudDM7zCLmVekBaeCG1dkFqTD49Lhn0U4WR9DTptKZrEJj?=
 =?us-ascii?Q?HJHj4qCKSNZRy8sAV1ljjhizpoyLVUUFPYfeIEbDqHQP0E5k6jJlgNLied7+?=
 =?us-ascii?Q?owXOpDWdJMcRZL/Zwl+Sy69NZL4ZCOa6BqgZNAo8VJrXqzQcRAy3vDF84D/9?=
 =?us-ascii?Q?R6+TT5qcUarqMEb9kDZ9JjtRjwYm+1aWbN6nuYMMG7niwXMG3fQ9G8uRW8Wv?=
 =?us-ascii?Q?GkVZvEqkLdCZcDtMjZ1aygJKnsAkjFU9P81ZdV3+woIbG43LT0NmNShJ7RiF?=
 =?us-ascii?Q?W3GKYGr+OP2HGSFAxUzr6g47yaqPW0lyeocV5lwAm0SwiuvPZxsrm33msumv?=
 =?us-ascii?Q?rrYUFpzG4LZ7e7u7FdGvnDktswT5NDfQK74FBojpVwuR00qCg4wCnIhMzEOJ?=
 =?us-ascii?Q?zni/F5aTuG1MOfHobMTyVPByhnVYzYxBuw6p4di/3hSYvkht7H1okyIWkER3?=
 =?us-ascii?Q?2AlVBpNyQTarw+pCCSSxSR+TH7xqHuzcPUhCCiY+R+1+ODzaww5yYR/atrnS?=
 =?us-ascii?Q?QAPifcSorwdT14hQqzLIJXQ9y6J3BVh7kSye7wiBOHFSc3AK1YIi/ylaWbcR?=
 =?us-ascii?Q?OEvdQVlWsch7JcTa71cBGLtp8WkwdCv6GeVavCYvyARxTptn7EJUq0Cm2oot?=
 =?us-ascii?Q?lD8vzbcBetcttQEyWVRRIFuoBVq3+pYKQTu2RIhdjwrn+BgCt1f71+WMOk/y?=
 =?us-ascii?Q?Q6qY794jKvrXbuG6wawX2EjKYYJ+DcGt3x6VKbWUYrR4U0xZJGswZ5SmilYD?=
 =?us-ascii?Q?C6ktkuF62VXVlZa9U4Qvnz8788xAgxNzogo/kDjNtXh7ame38rCORjtNdBAH?=
 =?us-ascii?Q?+PSWHUnp50QRbIWTqpuWlBS0+dGe/aarsRiZ+roye7K3hIleaTUHkcFh5BX6?=
 =?us-ascii?Q?ezX8mOAd0AWm7XaQC9C8LenoSxgb+Az+WMo3BZVUHGLLEyRir+mGuBYSpwps?=
 =?us-ascii?Q?ACTB4tRdNWXV7LgXHQGYpG2eZ3fXA3dICArPZn49Nu3tzFV79vljXEofXG/9?=
 =?us-ascii?Q?Z0gioYqpQwhBnSLelw7MY4VKHEwLwrqS4KP6jEq6EBYcdWxgW2uQyssNw+Q/?=
 =?us-ascii?Q?fUXboYBmTYGKmiJj81Xx1NHsdlN8unbVQbjcLuopXue4ZGJNFCM/wOjp5mhc?=
 =?us-ascii?Q?8afPU6PlQMiNWrV2upgy3KRoCKqpzIdoth+iuBeqqnUoceBwKUF7fnXEw0db?=
 =?us-ascii?Q?O2kvWV7Q4UwRiKnTuAvmX4U3yuII0dDE7vidp75IAFN/KCbAl+GuPjs4PrQ4?=
 =?us-ascii?Q?/w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a11e666-2a53-4cf4-ed54-08da58ae1a83
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 02:30:02.0316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okwnv9nqGIn2z6mo2ean4bG2Jw7JFgrf8UU0GuXS2ilBwhO/11NrrDBtQhkIFLgJEMkmkR5Kke/clVrJhDNn/rVPgavFMUyM2ozfdXc0lZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5140
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-27_06:2022-06-24,2022-06-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280009
X-Proofpoint-ORIG-GUID: FvwpwY-Pa9lVXm2pBaXyd0xSWwx5oVYE
X-Proofpoint-GUID: FvwpwY-Pa9lVXm2pBaXyd0xSWwx5oVYE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move iblock's unmap setup code to a configure_unmap callout.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_iblock.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 1ed9381751e6..7bef97097b78 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -76,6 +76,14 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
 	return NULL;
 }
 
+static bool iblock_configure_unmap(struct se_device *dev)
+{
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+
+	return target_configure_unmap_from_queue(&dev->dev_attrib,
+						 ib_dev->ibd_bd);
+}
+
 static int iblock_configure_device(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -119,10 +127,6 @@ static int iblock_configure_device(struct se_device *dev)
 	dev->dev_attrib.hw_max_sectors = queue_max_hw_sectors(q);
 	dev->dev_attrib.hw_queue_depth = q->nr_requests;
 
-	if (target_configure_unmap_from_queue(&dev->dev_attrib, bd))
-		pr_debug("IBLOCK: BLOCK Discard support available,"
-			 " disabled by default\n");
-
 	/*
 	 * Enable write same emulation for IBLOCK and use 0xFFFF as
 	 * the smaller WRITE_SAME(10) only has a two-byte block count.
@@ -903,6 +907,7 @@ static const struct target_backend_ops iblock_ops = {
 	.configure_device	= iblock_configure_device,
 	.destroy_device		= iblock_destroy_device,
 	.free_device		= iblock_free_device,
+	.configure_unmap	= iblock_configure_unmap,
 	.plug_device		= iblock_plug_device,
 	.unplug_device		= iblock_unplug_device,
 	.parse_cdb		= iblock_parse_cdb,
-- 
2.25.1

