Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104C6C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiJWDHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiJWDGx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109D26C11B
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2sexs010909;
        Sun, 23 Oct 2022 03:04:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5YKQhcrOjULZ+YqVj101gi0gVn3r2YkP4ZGxV+G4wi8=;
 b=VSeTA82zZG/QSuaRAcVK/UVyKz+ybaB5zncrTeBMNTjomvIAHNrgzGP4WliU0qgNUOxp
 u/OwuTEd8nJFTHAY7EOBrbAy7Up/QvY/XtmmRsrCpmilN5HAkhR/hXo1rgcnyvOFG6o1
 0X4e1LWMYIpD01UQbxlQijudNvQI4MEphS0GadpvITQKqXSbLJnfwxZCw8At6VPMJl8T
 7Xd9Jez+F8PUngVwUa1BF+McU7j78iE6dTNA0J27RlaQu3rS7hnI7Rbti9B9TGCqQrm7
 5NoFKDD9zJ1YOpEXe3F/IfQ3m7p4xeYIRMHsJF5cLJURu37quBiD/CnEL6FpyOoH79ko hA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84ss3g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKY9rO003104;
        Sun, 23 Oct 2022 03:04:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8rhmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctZbMzYS9OqefK9NvwYOKR60JphUUg97jlcZJz92GguHjYbSRsoZKoIGaVSZz7AjLPyQa0YlsNCw1Xyfa0kEj6M65xfjtXTgEGiL691Cbs0hWUfrvmCLj4aqFzBxA6LL/MNFon3/sEwmWOIOpOqPN32Yw7xdgRTwEw9MCPJEC5wuQ7X1eHwVPq4GGPgRkJhU/ghleJsZYpFBCV7ZXt1URtDLjnPt0rVFH+3tMmQJw2DmDAJQn6WtotTnWp5Jk/2vj0KPD+jkTvDyqa9a3WhFysRuruUEMRXqzugdSHYtTI2WNzzvYJIN6ZgSjJpArl5w9bluwxUJJAavZg+UkfRxCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YKQhcrOjULZ+YqVj101gi0gVn3r2YkP4ZGxV+G4wi8=;
 b=APDp8kFPfDdUHJT3F43tTMq/o+f1piLgAEyZ5cSXyuLdBQzZ+1lPkDVRe7vF79tPH5Z7DxlmIFN+GGSxhQY+1Emkdy0/hcrPKd1JrzoireflTHtvuvPvhvh4/TnWw3qt5t4GBViKDmdX3PmQPBf+1z+sR9wOhury3EC7TJzhL6GRtWJXs+cee5hg+UvCtO3NJuLVrJriOcsS07RVL5FBVe6eQhtQET0nPee82ChOY/mxVvjESRa3RutTWGAcmr4UC+LEgDXqGmuxKrwuB/uk3n/5u1Zhssf8UlvmXCShdLAsJvbQaGNFP2vGqQs2jTkXUWBEsR8IfQgbZgcvIWnvXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YKQhcrOjULZ+YqVj101gi0gVn3r2YkP4ZGxV+G4wi8=;
 b=lemYPsgQeIdzLUrJTcE2nGVP2VvZ5s12umBdZwVcRZ2zXciV8xXsUwVxbjaLb7n653hJprvTuqZNr5otmknRg8dJM1c2+vbEMv1arwemBKLoVY4Nr3se0ETV+u+88hsMK441rE39zTmjLOxEk99GM0CdYUW33vWR6HCtqYavq4M=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:04:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 19/35] scsi: Remove scsi_execute functions
Date:   Sat, 22 Oct 2022 22:03:47 -0500
Message-Id: <20221023030403.33845-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:610:5a::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 37e218ec-d337-4ce7-0411-08dab4a350ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8SKcuaxSZ9NdfqnUHKhYMsD4Zr072yDor7YolVnZDWgybJIiNyroc/7IzdDzRkEdthgqUhC+DrlAb19FIuoVYhWGrxTS//Y1rRnFzhjhQISKgJzbTSsIqbD3/bukKQs4+rVUn+MUrpjRdClH0M5kqus5yMbHGmu/bfOE1weZyOug5doZ8sqvi6EYNzx2d/4n2Y9nTmJPwgf0SI5I9Kp5idhpu/ZkEHpk3Pxk+1L7dw5kd0DqfPc4wsDiYhkn0kQIyIjNebO1htr8RMdTqiv/2IafGiJE9X6eJizadvZ/JDNDkLLYTvXfXvm0Ee8xThkD7d9xaRNOk2LdJvww8hGpJ99mPlfiigjB5j/gsByHwptzPa0clcQTWm8Qxs98Hiv5zvnnP4LhDnRl67fX2ySFcIMvhLJiRT+6R3Zr21KICiyH3aWIWJd369LWAGxsY7YPaon7j7mX2n339mhcwvFY4JvEtqA5cUciBX0BOdldGnyLyYl7XpvJNxMWuqtyxLMqfDXfPQ/k+AZLJe/tLNwBLHhdK/J/qpnks7luLu+ny9Abmp7FuFkF6h+O+4xnlvAO4Fkw0wNecMoU9ot3gW/aCNdX9N9X8k7vQKDuzLkDCGk9NFf22CH9B/ya7wWXHG+gnLzXIRZ2cKkj2Dxe3XeDXgjEOPufQ+z8v18QHlL17RTH0FS3wCT4duT48bbPty/VCA9H8wMFcLu42dBxFPrXsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qfd7XwoE81xq0v4MRTZpQwNrAJwBLeYY3hA82kNzehgtkpmXTxbolqgeDzk9?=
 =?us-ascii?Q?B6yStIC6FOMbcC75snfUNAbEyT409rVwgiL/2H4mMZG2+ND3GT1ifRJABNK4?=
 =?us-ascii?Q?nsHfOBPwFUUwSLNoVm584iKKn3Z2DOqB3oA+ZcOWmBW+T4dhjsz+qjpXzBpz?=
 =?us-ascii?Q?DQ5tGHxZHYtkREWHeG1POjEOX2+8RDhqtIQSbTZjGDV2rn10xtNUnAXtDZCi?=
 =?us-ascii?Q?rgUnFkbA0xcve2ZPeWgg6G2Q05aY4nh1qwfUuIJ/bTqPAOrZXMCGl7WtcVfM?=
 =?us-ascii?Q?EY2nFczwPtouMKRSCjDPvsNvcdqZ7zQAjL53aZl8+5/pFz7tX/i4NZZpRES8?=
 =?us-ascii?Q?N/mi4Tz6NK1rm/NTaVECeAK/0ANVFF86YlXINhKoMtl6c2lqAT2O17mL5+YQ?=
 =?us-ascii?Q?yVUHukqsrtSX/rIWKhRCbaIZyCYxb5Wd1zEz1FTrNWi9ENUWBhDllGfzwizd?=
 =?us-ascii?Q?GpOXMz/qFh72fsSiLX/qjJUrg0+LabPKq5i3onUVSfUuDJPLQC1bIr/JnYrL?=
 =?us-ascii?Q?qaQgnxsAjzgg1v42EdpPspczM7TpqQsfMpqMfUlxg4UOhinzITKmgQD8bSkh?=
 =?us-ascii?Q?BXbVKoIwFyxldDigGcVMXrGYrHBaEaUKOZqUAnTQyZaZu4mEn6/pXAZr9xQ/?=
 =?us-ascii?Q?m6mi1RgD6WyOQNDE8t+FU7cNpdu6OrRVLfaBfzmUOxIIAfcf3+6pn8w9HWnx?=
 =?us-ascii?Q?7zhXZBZ5h37TvSFiLoIbsz1uir98mjA3qfMw4VBr7qckL8Q3iHyXBjmOeXKv?=
 =?us-ascii?Q?Hi3IQn6uhmcpe/7vTcnZ2q0RZ0leUR/SYNd2/9kQhoxsS9WoWEWqr+PbYO2Y?=
 =?us-ascii?Q?njC0srVRC82UK2b69/LaTP1Wpb3IXaYUdI2nJ2hVNgZF4KFga9QV3IRtUXx9?=
 =?us-ascii?Q?y6xr5a66uI3ucHKdYnpHe/JFi6Q+1YN6LrAxkVYMX8sEAoWZYIWgTU5IAMyF?=
 =?us-ascii?Q?uOum4dgAbMMJSBqSQnAXhw+DvTPfAcfy/9iN6HT/9TcStM4NZLl/T+LTqA0v?=
 =?us-ascii?Q?EYl9L5EjW8P3UmGU1DDko14Ug3tzHZ8gIraFqyGuUZAOqvOEO7cAfDw8B7gO?=
 =?us-ascii?Q?STTiQo0uvLK7P5UbhZrVDTPghi05qSbFDusM3IZfP8VqQU13veIqUcdir/Zt?=
 =?us-ascii?Q?YgoeDTOyR64D99DZZzpsB/YQinHl4N/n7i3SM/9lOxrtOcYAu65gYc814v9Z?=
 =?us-ascii?Q?+Ec+dIADI5dpXGJXOYeOxXaijNaidog/Zcq6fLgpy/R3ktXxatSW6sr2umxE?=
 =?us-ascii?Q?Z4BTXzp5eYcpUqTMEuB7Lrh8QFI7J0wu9MkkHZjIVF8es1FYOexa37H04saY?=
 =?us-ascii?Q?KOCFVhrAwjpEw61Vmpmf3X4EFZs9y9I682NJK87/q1twnmsTmo8yOxH8ElEE?=
 =?us-ascii?Q?yduztoW5s0ewMkxw+4x66jZFg3ZqqCVHPLBdXyoVvPqJvYxCbWYQfxvvlG75?=
 =?us-ascii?Q?2nt5btV/CrNvhps4YrQrMvGI79zqi62EiGh+irLVtZoSwVfAuzcsmuAm22oH?=
 =?us-ascii?Q?q0ydqktHRsgR0VfZRSK2aKOkVYSZLKU5my+BldYP9fMi6vyW3jqJNlxXoBIJ?=
 =?us-ascii?Q?OW29TQfcD6bx/eYKOgLRcLX+7uz5KAyyoiBFdjv3h10EUn7fGeQIemNiBFiK?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e218ec-d337-4ce7-0411-08dab4a350ef
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:35.8887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cbcBWogp+q4HYN767n0DtLidz2oILwJZ5CPLltO2HBgm5Y/e94878JE3mlZb0S7e8iP3WbPD5AYPIs+YALUBltc38WQeq84ZS03klrVJCaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-ORIG-GUID: YQwX1p6zPtYZ0b-j7jPUQ6-oofq_Bcd7
X-Proofpoint-GUID: YQwX1p6zPtYZ0b-j7jPUQ6-oofq_Bcd7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi_execute* functions are no longer used so remove them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_device.h | 39 --------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 72d1690f4ff1..c2dbb8824ef8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -482,45 +482,6 @@ extern int __scsi_exec_req(const struct scsi_exec_args *args);
 		     args.sense_len != SCSI_SENSE_BUFFERSIZE);		\
 	__scsi_exec_req(&args);					\
 })
-
-/* Make sure any sense buffer is the correct size. */
-#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
-		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
-		     _resid)						\
-({									\
-	BUILD_BUG_ON((_sense) != NULL &&				\
-		     sizeof(_sense) != SCSI_SENSE_BUFFERSIZE);		\
-	__scsi_exec_req(&((struct scsi_exec_args) {			\
-				.sdev = _sdev,				\
-				.cmd = _cmd,				\
-				.data_dir = _data_dir,			\
-				.buf = _buffer,				\
-				.buf_len = _bufflen,			\
-				.sense = _sense,			\
-				.sshdr = _sshdr,			\
-				.timeout = _timeout,			\
-				.retries = _retries,			\
-				.op_flags = _flags,			\
-				.req_flags = _rq_flags,			\
-				.resid = _resid, }));			\
-})
-
-static inline int scsi_execute_req(struct scsi_device *sdev,
-	const unsigned char *cmd, int data_direction, void *buffer,
-	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-	int retries, int *resid)
-{
-	return __scsi_exec_req(&(struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cmd,
-					.data_dir = data_direction,
-					.buf = buffer,
-					.buf_len = bufflen,
-					.sshdr = sshdr,
-					.timeout = timeout,
-					.retries = retries,
-					.resid = resid });
-}
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
-- 
2.25.1

