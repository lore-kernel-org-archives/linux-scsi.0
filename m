Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B09C54EAA
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbjAWWMA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbjAWWLt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:11:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB45123C7C
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:27 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLhwgT029679;
        Mon, 23 Jan 2023 22:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=S3XGpDHwlwpcVNqeENHvMC4ar4Sf5Sd4KEIldet0syA=;
 b=jyXIYOEPjprE/Li7r1nLdXAGt+tQM7cOJpQQpRCLHVbi8HKuZuje1yfjZko97Ye6ERtl
 AZZh0QPE1ipPJjh8z31KnaFDV3l67r+yqcor8u/FE6Q7Y7+iN5WwpmjoATChDGm7LV7w
 mqcaZvoGkAh6w1rxj/hucUQT9AJiq5HImwcylV4UX+0e1KdG25XZl5tPW17TuKSO91VJ
 dg1zt/RiKpNJmKF02+JKtAHD4W7/0m2dklCbVJpfNWN/RJr6z+Cqv57n18jaaxkhnqqt
 W2IslkfvlmF20E/iyQe4Ovl7m09IZz5V2MyC+PypXcNGng4sjBP9s0PRg2ERdt+a6JUc oA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n883c41nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLEfqQ011737;
        Mon, 23 Jan 2023 22:10:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g3nd9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:10:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxwyEeMWz0ztsvDo2tkXj+YnOzZ1YBm3k/vDiFb4X7Y4WTpTJ6VIaWSvGQZ466/Uj7AB6arqByTWiqhmxOkCF2/1hnbFYCaEjTpeJr/xZjAXW1BqWL8oFsPOrcIr5Gc/8L7+7fs60aHop04D6DLwgGXlXEP2kWjcM97WUZ7tz1f5dvjLFN+ksRrm4GgufyL3ZW+cAboljEgf2kYhuDqNa3/etUxFzhsTz/Ev57F5psxDacVO1f3EE1W0j9wPTunbjg9IfzZwG6vWtIStPy0yt3rHZLd/eDlPv0sQW+K8LYqatp0N7cvQRdTXA6Xnu/VX5Ug6EhyIr59ip6bGCIiddA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3XGpDHwlwpcVNqeENHvMC4ar4Sf5Sd4KEIldet0syA=;
 b=IkjCqdMk3JppAWzFAEIvLYaaKnJU35cUqGn33fXTbM6YAH8XwZMA2y685+usGxc/CSjJjkpKN5tU2xMuljr2YQ909pD4PkF+Occ1yauzd6Vsqr3MfUPQUuvzWfA0TrNlFDvzgLboebiqMrFoD8E5Bxqqke6YGaVxwzLLU0kHdeT/xJMadCzX7T5IWnAwe1MZb2ZV4/NFI5x6nYUSG4g3UokIfXYTHrZ9iRj2TBS/kocV8Ip9u80s2EO+WtQMXq4kphY/ZAdQHSgmvX2IGkfMm2RlxzLUlzqpBPQvRn0iPgXBHj4mKiI5WGUV2XCbF0dk/hslqSdBUNKAEvXRPdo42w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3XGpDHwlwpcVNqeENHvMC4ar4Sf5Sd4KEIldet0syA=;
 b=UzSdikO3NAVeTNpv3nlVrJSbWqq1yn7vIbOybJFCQi/kdaCEfXSr8txo4v1piJ+I+aBNqqd+VnBiE/ylpJYKGBoTRw4ja0xVl+TJTUrvogEXIcQps3WBQiQcHFmC+byz4HEEVd4pO7ZnCRFhElckCJiK56uNAIPaV7otqfIRgXs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY5PR10MB6167.namprd10.prod.outlook.com (2603:10b6:930:31::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.9; Mon, 23 Jan 2023 22:10:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:10:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 05/22] scsi: retry INQUIRY after timeout
Date:   Mon, 23 Jan 2023 16:10:29 -0600
Message-Id: <20230123221046.125483-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:610:54::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY5PR10MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: 76370375-d44e-4b97-7e67-08dafd8eb406
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bm4IO83jdOBBNDcYKywZ2U09AdRZg1Hjj2z8NeY6kmIQjuIKDTGGo49Zm1PsMB5PGMdKyTBZfOwp04afF2a3ASJjDseYwz1rrgTAXW3V23wUQtbO4AbBm8ZNQDN3LlkWumAiBDWN/vFF5n322UpvEC3DajZFmE33iJhZYKOLPJCdm8pcEXhwB3eUdm72SWuz6aZ0Yj8aKLsvVdcHiiDPv8nsQ+SxuTQ/V1KuB+6b+zGcA/eQY9vP9lIRlBU9U73nP/4SotYrfgPEd2FmAQ8fMqvRiK/uA78H6WPUacwTafq4MheaWHi17mUDZjqGfb9jMdJc9hjm71kX6Fki+2z5LXY+cV1i2ElrTLrjZiLEaUThn92BtioV9mPN+PDyKm1DpD8SqBjBkGayNCo+dOAQ/ra9atvneS/gmTQNF5YhBABY/fiAZnv3boYCyoppDvUOu1j9rXpKA23NkOaBlU/HH2tWjqb/52ZH7XcCvOmJnPgUSJFgVcAiOP6yQagi623wYslaYZqW39eqXdosYpZaw7xOXTyBHGcvlAfMUWAimWCsDoJgS4FE1YS9uL99Kf7om7eTWuCqh5FlGJocrSdM4VunKgEZCnu4tvknVVxUn98fMehJsiE8Xc1fD30/wpl8tKGfo+wTi5qK99ukXbngIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(86362001)(2906002)(8676002)(66946007)(4744005)(26005)(6512007)(66476007)(186003)(41300700001)(4326008)(2616005)(478600001)(66556008)(1076003)(6486002)(6506007)(107886003)(316002)(6666004)(38100700002)(5660300002)(8936002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gg6bA8F+JhXDYvoTUfkNHSPdCQKRwFrtHViJklAoyDHbWUT2jkCjyDeFni5i?=
 =?us-ascii?Q?bNlnbRrtD4Kp1ADharTG4MViEFjdAeSw6QJCgocgs9Ir9zGI4ddQ65AeCwiR?=
 =?us-ascii?Q?cJuqqpyQTm9af9iRcZc/scFgOr/4xSTnQPBYsB4/wZPPxAV8xt6/bGTX3sLR?=
 =?us-ascii?Q?/kHE9B8QDyDbWLPvRL5hUTuZmrY6BJIROwIbWNwDUVFWlPopuoqCrHyJnKmd?=
 =?us-ascii?Q?qrmlPAJPNl0pIkW+ONkb0KcGm/GHHrn0n9BYUQVBsGy1x9QtPO1STY7T3CxB?=
 =?us-ascii?Q?R0+NMwXQreSLnIbnMGYL90eIFNptBxMleFKlbdnA1v+IOU3NiD1A9Riise3l?=
 =?us-ascii?Q?Y+eWRzbywuiVJ+3pu69g9pUnyxIwuK4nhwdlligRb0b9iqJvSQmwnEC+XX7U?=
 =?us-ascii?Q?DdMg3Tgt/LKMOOpBwgIpuAZwXzhHxxHqRTHLZ9zJNzF9RABl7dnC+hPhrgCZ?=
 =?us-ascii?Q?KBl7R7G4cN/Hnkc9ruVUzjFDuDIeyBFBxF1dJNcGtGgqttNd2vAv4hARoSEN?=
 =?us-ascii?Q?VlbOVAmBdOHIlboEdb7ADzq2xpkmh08ov1CFA3fhCph0Ip1bWxyHLELMCLpq?=
 =?us-ascii?Q?9j/EjaACcqW57Qf3tTZFDCXw7mM1honhOrtTcF8deV7XVJiFS/AT0fPs2/FS?=
 =?us-ascii?Q?02LCBxZ/xQvaTxjxmGjmKNeg1jrIEl595TVMnNigMxz6UFeZUDpuAVSBGHbY?=
 =?us-ascii?Q?L6q+8/8Ba2whSNLrRfNd2aH6+rCklndjMCHMKeJDltJKozlbfy93+jizHkYB?=
 =?us-ascii?Q?6PYSKECB8v4ktOEGRRYUVQt65ffp6F7u/U9PYJoW8nM+7lXx2TEQTNOxCOQi?=
 =?us-ascii?Q?Qj4AVUlp9e6HR10UsffQsMKIAOTar+dk4Bc4My/niq9lvpUc/Qqj+lsUe0Za?=
 =?us-ascii?Q?NwQw1Y8ICArepZSzpEda2xVTaF6J5qhHMQ/Y0f1MNGEkZ86Wlqlf9QUagYUw?=
 =?us-ascii?Q?f6JUSx8pQw4jiymY29aos5OokTwwS6hEZwaGWaDl95clTMuB1YL82kNmFo7J?=
 =?us-ascii?Q?j3RbBXhjYL0hXJl4i2ubFaZ9MGRDagXRlt0xOegx1WfSWAxTMAULu4kqQBSW?=
 =?us-ascii?Q?VsEBVVBKGuf0L5EMJmAZMwCf2ZunzRuzy7pKlY5rClsAXgpMVlxsnVRibPnK?=
 =?us-ascii?Q?NWNg+9VmoR9+XAwK2Mjif4/loaRRNjmsN93FnMCbqmIXaSQcGDVYr4hHsnUl?=
 =?us-ascii?Q?6oyKiRaY+6qN7pCtHpynSFjMVSBNeeDFArHGroI7Cz/QlVwm7AZvRUiPq+k+?=
 =?us-ascii?Q?Oq3SHqnNx7n4YC9Zz8Sa/fjE2GytGZ8mLoo5OcXjVBdNvM6bWalHyDL9zxb+?=
 =?us-ascii?Q?Ribh3yrnE+G7GGkFAOkjbwOEDdrPzbBx/P1IjcUNXweqC5FGi8Goztmtl+8w?=
 =?us-ascii?Q?0d6QDEAjnN/d3SvjXvhKyGg1lKzT7lpgtlQ93M/ZTF+nZKNNAm94pEU59zKc?=
 =?us-ascii?Q?Va+LQOokzfrjtN2qsZxa1CR9VgAecq0oFZPpVIMtNeDQ8tARFKUwUO6sIRr9?=
 =?us-ascii?Q?mY7cclWSJK6Fal38CjAXVQIAACrN+aSQndwuOWs08fVQIeea3FslLEvqM/yZ?=
 =?us-ascii?Q?oV1eD2UoXiQudeHsbuIs1IfOmfy4f1GgbzOl4p0BMqdEL0zWoIWg5zwCfGRj?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5uWNUGloYtatuFGqrr2wwKngofm/a80zih1DFJVqXshd0QOzfvUp0/71zVR1qhOcBrPR2VIaTq6KEB2KUgIM3FQq69eNnYXwxVQgAmI+0K5DUjpZOzEN2OMyA/ttm61M+VO2LMgSQ1BSrfsMC9ck10DXSi4x+ZpGgip4h0vjeV7/UW7DpAiT2kDSxf3sInEVOPY/joGlsIhLmJj58avWbIxIVT7+csSC95m6PXMFyPe/Xn61mIiTLJU3d1nVYBD//M3Aprf6n8SUEWnR3CZHBeqMxcMe0wMqOXj3BM+NlrbP6UePHqauMWORSW0wqyZF5NP1/4VHAUFNcU0Yb4mwKXFFOXtMdglsxoTyFTf5I6dJko0Yp7gAb2M8w4qA4pFi5fypzUVZQx7cGfSf6hsR0yZ9exoeOwCfS5X+bfmAgME3W5DMNpUohq1cnw7vmzQMf3H7CDjEWo5Qu2OY+aYwpBJX4rsH/Cnfhbs2l3nYQjO56SikGj5RYO9usjct+/o8s5LdncmHwFAuvuOJivwDmYx02pfuX4RnmXGr7a4UlrC6Ta48TFxRDaQdUHyhrMLK8ckQ9aRz/TppDafxMClmF77zOzSwsYc8JVDw3r1XdLdvynq1a9ZLKvMcpQEPVuC+teCVSXBbn1zIfkFsD/U/1WuDyFWypW1nwiKp6o6ZU3q/Z1DjzSvDO066NoMaVO/ZClxWocXoRaJucXLRZm2xWa8cIZyDYcm4pkKMcNuVz94lyfdC6KtOH6+RTc+9+4Fj2aAXjFkiCnf0e3UWdXXTpa3ok+Frkk4vutAgGwMphC/MXOiSbe2a3RLxGBg4KZ8BdTzFSm9YblAPpm7bJvmmsPlzO1k411/Ko3KK9xKTSv4zRa4fW3tC833qoKjfzHOD
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76370375-d44e-4b97-7e67-08dafd8eb406
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:10:57.5416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SAJCsj7lrqR6qRMrvCcifip4LRf/r4adyaXJCbQTDgiYwe6ZkVfX7HQKh0hULS+JUCDuAvFAqWnrt2a06ZeouzyO7AHQBTGw0qCYRJ4/ivg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6167
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-ORIG-GUID: V-PQT59u_ZEMuvbR6DgC2ED-Cd73-bqH
X-Proofpoint-GUID: V-PQT59u_ZEMuvbR6DgC2ED-Cd73-bqH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description from: Martin Wilck <mwilck@suse.com>:

The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
scsi_noretry_cmd()). Packet loss in the fabric can cause spurious timeouts
during SCSI device probing, causing device probing to fail. This has been
observed in FCoE uplink failover tests, for example.

This patch fixes the issue by retrying the INQUIRY.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1831a0c2b54c..b8a526c4f6bf 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -665,6 +665,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			.allowed = 3,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
+		{
+			.allowed = 1,
+			.result = DID_TIME_OUT << 16,
+		},
 		{},
 	};
 	const struct scsi_exec_args exec_args = {
-- 
2.25.1

