Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724D8C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378918AbiFPW2R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378969AbiFPW2E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:28:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD2460AAA
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:28:01 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GIhsMi032716;
        Thu, 16 Jun 2022 22:27:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=trbdtpi7IGaB5tQBaBng4RxSIopEbsyt0fLuRy6kkMU=;
 b=h7X0tCv7TVA5J3IHg1/xXsidCEpKsF3jorinc0/4XGuxO34CsDlVyaX1prYtqe8Ko7OI
 vzm52E93flfxaleRnHSAXK0xCVQ+Ou6AxMO1bWZQpJRKuS6k2g54F4DfxqLJRVsEfv62
 TLn+8xy41yRCvW3int+uZ1/oGt1LKEjwAlnnEVEjsm8GyrgOO9uBdPNqQH3Kt1AfxvXr
 7K5gEJ8fu6hCchD1Yr2h2Sf+Ak/NQ8vvA1MvCXmWEmUPoVKOck+DpQhxJoChlC3F58vk
 rj2MGfK1WKcs35vrjTWmiIuA1rY7RXiS3uc1fOyoxCjyB+oDiAZrt+vNxeH+fgqGKs+p zA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2vm13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMGH0d034591;
        Thu, 16 Jun 2022 22:27:52 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gpr2brek6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKer2/lK0bfVBOWP6NMQwhXIE/RePP6XnGuv8Nnvst86pA+ghA+pfgWFkecka11f7hu5p2xV7II0OQwYUNr012xQom8re9dQ/E7ZQibXsPQbRinPq+VrJVsKiQEp2VqwoKxV/0Ddl0C63ix44IQv+UD++P72dVfXs2LhEmTRyeKlt5/e2/VrYPyMhoDXFQYA9M3lTRcOrbkQEpAIn6C8VCYOltcAt49J7Hj6YVCq4fFz4t0pWaSNgUXzRwfQ5QHzurvvBPHrUDuzZ4ml5wBY3cV2sYPFdPe0Mnxq2f6yvlhGI1Zx5pj7O33qRzKTl+QYBu16VHXXlxta0gIwFcWeoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trbdtpi7IGaB5tQBaBng4RxSIopEbsyt0fLuRy6kkMU=;
 b=jgv3DntUE2DgluaAVAGTF628u5ZL3HjNttrkzq/kHGd9DN+OGPjem2BvQQ2BPu3DEfC9Qh4OnfEXfO+5ixjC6AQa5zIID+qZlOMeuVFPMMW2/HR6f4dyCD7W11Wx52y0SVNAavNWvYa8r9EZnv5vOfhLOhdk+on4o3MW34W5fus3jUQ1uvytXgoxFJfQFBnuKMmg9nnnDXYIHPe/b98a6pvoTDrOb+Yh0NDBE3BsDB1hQvoeT+10KMAG5DRVgcs7Kjhg3Ygr6ZHtHw5pyHYy99flNkl9D4ZbpJMFqrHyK6J8pLtnvOXVNcVTKBLNspNTcS/JBiaeetuhKMszOIShGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trbdtpi7IGaB5tQBaBng4RxSIopEbsyt0fLuRy6kkMU=;
 b=AugcZ421EPjiId4oVDPP7FeaCishQV2R8nV9iiun1MYtCQjDBFzWDBdhfdHKhapaXwhXKjs6yMe69Zs7gD9OVaa6wATJqfkDOp2Xw+jr7Q1Y46dyvHQCtCW2MewG/K9gz3LKLD9dJ4/BEs5/5nn0Sln1/17WdgWz/pNX/zPXIbQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN6PR10MB1267.namprd10.prod.outlook.com (2603:10b6:405:e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Thu, 16 Jun 2022 22:27:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:27:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 5/6] scsi: qedi: Use QEDI_MODE_NORMAL for error handling
Date:   Thu, 16 Jun 2022 17:27:37 -0500
Message-Id: <20220616222738.5722-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616222738.5722-1-michael.christie@oracle.com>
References: <20220616222738.5722-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0070.namprd18.prod.outlook.com
 (2603:10b6:3:22::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23a6785a-8419-4e41-690b-08da4fe77316
X-MS-TrafficTypeDiagnostic: BN6PR10MB1267:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1267EBDC0901256CFE52D5C3F1AC9@BN6PR10MB1267.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tMvC+69IqrUFs74kxfcYOl9iQ8qbtHPFIEgvH+bq/Fb1eitDsJ4R7J/z6rxjFHsMe5pGcyAEWFusZC1ircx+PRYrnhucJyLLLU8W+/rNPG/oWwVjpyAgD+dQnVtnXs4LOVTplsV5AOxRkWYJaItPsYXyWNJhxpH90e27xdyPTFO/nZ3rt5sYWpSk3Aoi2FY/W+cIq29EE5PN5QvagU8UY6kzQFwLC/G6B/CTFH6v9XhVlohOFhvu1eRFeUNylV00GYGnMYT0lCQsZBqjdd0/1LvYFTK1buGc7P2NTmfduLzlN99+lfUoAxRuPv4grYz/5sZEKo2RvyjOFN6VfVIZm2z7E2ETRUxLE10lx+2GJWizI9v46ngvjGsoTyYRnQ75GF2p+9okYkfX2t26RSCJGERBCeSYqtXyrzkdTXIIUwCx+R0oCDmMDUnJtwgHCMbhBT5HRqqFGf1s0yMps3i+8mDKATZvT/nT7ZagbmC5v109t2pm9kmJUeipwec2jbgY5EW0MjzN7Q4fTpmAeUJrQ3mPP/t9AKOWx6wLWgPwai8DqQ5TU/eUPjrUTibHxSdcBYnbJOkxv8kIu0a3jBbb6jPuTSyDtUkGkh+SEhYagqpLazS8cxs6c1940eDKCLXbEOIxxbkr/EEkVo5dWzqkdhNQOl0qjazU8Zb6gW6kf6dHNxif2EkLhTdGnMQXClsGsrlKQUS6mL2J18Du7IoPTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(4744005)(5660300002)(83380400001)(107886003)(36756003)(2906002)(86362001)(38100700002)(6506007)(38350700002)(26005)(6512007)(6486002)(1076003)(2616005)(508600001)(6666004)(66476007)(8676002)(186003)(66946007)(66556008)(316002)(8936002)(52116002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aIPZaoxkVp7YWIPReGMPTRsNV24t6i7b6PwuPjYfCk55A3gUqxZTwz/2qbZ3?=
 =?us-ascii?Q?l/G6L3l3iqF7zgSy+vvm3Q4mESCUtgwU81UuOU2G0/DG485gkRDB1PX9+cYR?=
 =?us-ascii?Q?Q9VubOLuHsUwCtErs2QZD47X8Og9xr6wzl+YkWiB5logI7h9+dzGmuD/5Yiv?=
 =?us-ascii?Q?oCCp//nyMXDCwoC+ZaBQyj0dghFOiDqiWs/GEjMiN7Vn92L/Bpb6YfDSNJsZ?=
 =?us-ascii?Q?Tj0P8CDp1SUZ591EQsKVb0mzNTuWoV1SEFc447TSCT92VR+O++pinfOfkadS?=
 =?us-ascii?Q?YDBi597qDSvHfeHHybgDfjHFTZ78ycf0TNEtxRlkmT4RfMrNEGKQEViyH1tR?=
 =?us-ascii?Q?QfcMZ7lbU799CdcfgPXeOqA4+NVVChDFlowdxGkKmGNglyuN3qvJ0iWtgX0Z?=
 =?us-ascii?Q?CIO6ttBo6g68IYF4iCfjapSM80JhYP1LGC5Hlkmdv1scTMzHuYYt3be7xRY3?=
 =?us-ascii?Q?XHecdi0pXX63SvCPfLPUeYSUVSTVljcBFto8sbqkZwn4FjPixusNU8P7bXyd?=
 =?us-ascii?Q?fAa0fmzEg00lQ8eUkmYVO6hbkvZQ9b1mKVVvMeDkMR3fKVZIpRMXWNP63ikb?=
 =?us-ascii?Q?DWeSHrjHj+SnT+wiLH4lPx0oLPSrFCcxNSoTqDbB04pWkEoBOhEx8M1UDWB4?=
 =?us-ascii?Q?BnJdxgeIMrI/niSoMekGPQam7uBHYsscZeouadqvERlyys9TXW/oYY7vivAj?=
 =?us-ascii?Q?rlVqupxTk5Q5fp4+9/OiMu/WbExblTI3KFlQGQGZzWvRdkK6SLylZrA+6kv6?=
 =?us-ascii?Q?UEVhYJhfqhlm94c5c9pT69fMEEchV19mHplgJRVKyU/xU206AFHv8FOvddSL?=
 =?us-ascii?Q?vqmf8zoHBSizT3Ki6TlMn74DgoiN7cqgI6paopaExG6mTn2CXmPXk1ghvzjx?=
 =?us-ascii?Q?7ip7Xs4QGaX2s3JLTgTWH3YNJH7I3lhvm61Xop0Uwm7RQ8gT4XzGbxdnnDgJ?=
 =?us-ascii?Q?N1DQ2b98U0rAP+we5Gv0ZuwgmVs9WVIkhs8+2t2Ci+0g2qxCdnyJPSA8+GJu?=
 =?us-ascii?Q?z7XV0P6Wj3udkM4o5HnDYRcSWV9E0eVn+1IOQSeykaMrXTdVUjFUFa+fwwin?=
 =?us-ascii?Q?OosOZ2+pYwfediM79rvQYo/9uXZdG2+simfeYOadoZtxwUkq/XNnCBimzyqZ?=
 =?us-ascii?Q?sLaqzcqaraag5Jlbc/c6nVNDVyAoxm5tmBXU2DtG9WnP3U69mQA5UwJA18m6?=
 =?us-ascii?Q?PbtPbnj+ENutuC+8UoOY0LLAW4DfXfnmhz5xga5XUrY4SDEIKa0bPXxED9GH?=
 =?us-ascii?Q?/rsw0ZmD6FsSXAUlO19xnQP0onKBZsZgxHkrDomHy/FZJMq5J6yn/bAfm8Vt?=
 =?us-ascii?Q?um3wLFL5O//ZUij7XWcdkb3TEG1Ud59GxYF75eIfrI8WHXR1DsLOlTq4yvOq?=
 =?us-ascii?Q?4lto2Vej/OHVviwN3iO+gykxXQNtmO8LWhRwx87iVSi9RZelfLcdlbuxVT4R?=
 =?us-ascii?Q?JZw919i2OnRAvEjzh7Pf20oAkGaUXVTTo/2AYMWRfwQRfJZhkq2j0I+vL4oL?=
 =?us-ascii?Q?VIg1+c8Hau/4GcIvrK6mtn06T5J0nCqm6US3H46/Ehbff+Fy21NMqdhfFiL7?=
 =?us-ascii?Q?MFe8buLLhiu9Cyv36HVavb0MTf1El2NloPYes6L7ksVoAIMC1ry4cFCrNW8p?=
 =?us-ascii?Q?GPsQ0ckpRdGAZvKTYTU9paL8qeP3wP8d8Q5/iVZ70jAEV8iCALSYI02/5NGV?=
 =?us-ascii?Q?1WdU3AP6rsCJ0FGNBetUjkEIOcX45MsV33zOR5E26RPkv0xQUjsr1By7j/Ai?=
 =?us-ascii?Q?61gDgf7gVTZNoCoPuUvflphk9QB+9lY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a6785a-8419-4e41-690b-08da4fe77316
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:27:51.5109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2QlCpxERZmUc6Wwk+9cmJQIVr56YlJhLYGwsRtYozjc5tmULE2yOgFG28MqoJOesvdNnNJAwwMUZcqBqFbpu3SLktU6L+avTJYB0br9IY2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1267
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206160090
X-Proofpoint-GUID: 9A8rD5jSPQ5DQVnlAg-Ot4xnPIFghpnF
X-Proofpoint-ORIG-GUID: 9A8rD5jSPQ5DQVnlAg-Ot4xnPIFghpnF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When handling errors that lead to host removal use QEDI_MODE_NORMAL. There
is currently no difference in behavior between NORMAL and SHUTDOWN, but in
a subsequent commit we will want to know when we are called from the
pci_driver shutdown callout vs remove/err_handler so we know when userspace
is up.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 83ffba7f51da..deebe62e2b41 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2491,7 +2491,7 @@ static void qedi_board_disable_work(struct work_struct *work)
 	if (test_and_set_bit(QEDI_IN_SHUTDOWN, &qedi->flags))
 		return;
 
-	__qedi_remove(qedi->pdev, QEDI_MODE_SHUTDOWN);
+	__qedi_remove(qedi->pdev, QEDI_MODE_NORMAL);
 }
 
 static void qedi_shutdown(struct pci_dev *pdev)
-- 
2.25.1

