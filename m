Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB26C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiJPUBO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJPUA5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:00:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8418F2ED73
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:32 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GE3cfH014633;
        Sun, 16 Oct 2022 20:00:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mCQ80TsAuy0hmG6ldOJJBi+B0gPmmjwea4QMlokaAIg=;
 b=UNMW1SJ3Ec3SU0hOfFLkwVfVN/zGucukZOy9AGrYD9tbVwU+FVNwwCNQ6bZ42D9e9pyk
 8mQ1Am79siXi38IYKedkOygHIMgauS3U3Fnu9WThRBGpiimwDvcaCpi3fxuAmRC+qvnM
 Y5ZyNC5HZBEIFIa1TNZ3bUHQoSIXZHPXFGywY4HoWFHnBdJpuAios8g8ndakZIe2FFD2
 WAhidFdy94+xGKihojfN3Yq/kHdc7w6HrWeuBaKmumV3aPw/ZkG1rhY87kDgHm/BKEeP
 nRvEgU89L9Vza7b2JA5VWZYX45DrVJ0/4xoBLWSCMGERkvqj3ZL3GpYi7GrHke9PX6vw nA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k85mfs5r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCHWmY034259;
        Sun, 16 Oct 2022 20:00:23 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2042.outbound.protection.outlook.com [104.47.56.42])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hu54cxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPKc9YW/ibmNYuz1CpAUhlM557cyxUzDMaNk/+I0lPjvcG6oGXmgNL0OPMOuoU+ynGgwsJyynaIL3JHkRARiyM5L9CZPMmE06Yo/NY4f1rqFS5RvSnUn3h6i3KXPIoP/s4nr9yhxD1fhIaiPuznYiPXFJR8n0T0B23H5ApKBEe30Iqc/0cT2Y2DuwPfA1SBuW05u9wy0X9lDSGoZuq1c7yB7JkWcSLFLhY8qITpPN9i9XHJH9cI11aQYmfZUFUkYAZTx4xkkksXBq9FQsNdyH7VoQa7QNwGYvSegDyVqXhiUuKo5z3npRkELN/MbxZBbZg1Hlb0qwT0oQDKdTWpaTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCQ80TsAuy0hmG6ldOJJBi+B0gPmmjwea4QMlokaAIg=;
 b=j7yzH3S+0UnXSeGk9HKuZJmKp921QfZdWtgmCJ0Dnk4XiyAqt3wtG0Ov6Pjy1zj7lKUEhvlKkupLqQQGOOGstv4o0OP+W9fcxeTGv/W/qOOwsv+fcW453P0pyiCgR9R2nnGTkz6pdyNoLk7ELCbtJDkWKjC9N2viX3xuE1B1MGe4/O/schmQoALH0QiY8k9wLC3YrZDIqwtkHtDEtrg5uwVKWx7/3qsXQEIP2AqFtE/FEeiKJPa9qchFVR9hQUhrDjkMTds9orCezai/+KtMYXbTCEqZsciN/WQKZLOzYQn9mYHbi/NfF0+eU53x3NEAtI7QjVpeAA0kCn+BCDnzWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCQ80TsAuy0hmG6ldOJJBi+B0gPmmjwea4QMlokaAIg=;
 b=pennOdjLVOrEKnBVWkAMkUKgnAJ5uqfzf24lH/SgRmyOL/lsutAFmK0J6uOdywmVV07Lry/v6ZNJH/M65QhB3q4SaFa5EtDWz4XZzfeKyVV5XhXzoA/d+7pxNemPGjYxz4UKffpnla5OgoZWgpLW1/MHQYvLYCE1x/10C/kU+Eo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:21 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 21/36] scsi: retry INQUIRY after timeout
Date:   Sun, 16 Oct 2022 14:59:31 -0500
Message-Id: <20221016195946.7613-22-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0005.namprd20.prod.outlook.com
 (2603:10b6:610:58::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: a44cf09c-e7b7-47f3-82b6-08daafb10eae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jHhmVV8uwfDRY48K7xhpPnBChmfzjuXUaXuB7mvFd3uD9b8UHXOJttd6QWo20rkAAXPecGgceFufiVccbwnQwXcZ55os+/SRy+Vs3mrcGBSadLLr15UrnoPPvHPC0GhMgR1F685jsrwJOpZdOzieXHrF9MAOuQq/mSMPpaA02+NfYi1F7LAXCHrpg62qv0hQ+sMsj2slv6Y0dzjUR8p8yepOk9IlMWuZdW7fSUwNBxxk6iZSA4CpdKQ9oshbuC3UmxrCXJOt1/QbbkelQygkpz3jHuNeBgasgSSazdyhcuNgMGQIhNtcA0a+5gD6y+yVfWsEY/XM2lT8kMF4sApy2hj8ie6gNN4mfxoy8yBvFpT7zqAXWEOos0OoCFV9MwwRXw7HB3psNlOGrXrg7IyGPd7SUaqvo4+jgs1TRfO/HzHdd68FvmZTIUh8bpt8/fU08+wzlWQgDtds7WM6okQX0YijFSAaBk07pKZM7lsCa66Nlmw8YaWEhZ7hEEwAoOW5Fkyl0KzbuS1MZ/x+J4yIkbCGeq18/g9ag5DmMp/aegIoK3ABUhMk9RDw7C98IJ9ruQNkFhCYwmi7AKhCSogSVNCi/gJve9xQQkKkwiDgnYg9JrXneu0FRqtv7ej0hEugCq4oJ0N9wNrbbIwFIMwMyLaCet7DDuSZnMnHze79fi1idiFrJgxSvENRWctRsgzxLHJpmXGTIRHRZVA3Oq/hzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(4744005)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zgHUp0FtrRjqi9LENWaifV52IZ+V+QkNMAtdGkqRAnIYIhCFRTtY5uOSUPhS?=
 =?us-ascii?Q?FnniRW6m0zaIugbJNCj5klbVausS871CZNp0zNPW0mcy3htKYyaQ0I3rDalV?=
 =?us-ascii?Q?uWWudYTZmfCTFmlhJZYBgKRtAaCx6fx1kl+GVRAQyYAi2nJc/LtMU54qM8Nk?=
 =?us-ascii?Q?5AZcCSHqaRnfXKIgoeTO1SXr7baa3g3hDCEalWCvgtU3xFJbVKDgEBvhU4g0?=
 =?us-ascii?Q?srFgQ9249KEkGu8LmrnkG3qHa1mPyjsuy5L3ray3Frz4wrJuo+sA6KJiwrRg?=
 =?us-ascii?Q?0OAvZrqwxoznHySBqLFiu1kIBNowvPFYQOaeeMZPa8fFtDqYTvduXinkNfu4?=
 =?us-ascii?Q?0nUHoDD5U4rBem8uO6y6VGu8oGOAvOOVg/25yspA4sKYQRnGGVHvNCyEs5sX?=
 =?us-ascii?Q?gWGAxIi2vIZ43Z/LJ4+dHkeS++2jbF0N6108N1w0Oty4fo7JQEC4k54AA6Jn?=
 =?us-ascii?Q?p19hthce+JKh/sZY/cl9ugxWI3nV+z4KpWw7qX+lUZFaQpXbIrrHR/IbI26+?=
 =?us-ascii?Q?eRLSwkweEqoASDW4n4vEP9l7bkuWsxy/6LvkKNomCvZEXnQPoQOius5RnIep?=
 =?us-ascii?Q?fOFeRtAgORbqFhg3fx2M6aGawLU2p/dBvxX2Gwn169hGfmNnoFRSuuF5j0hf?=
 =?us-ascii?Q?aNvtI5/nJwLQkri+xo2UvSkDWKGhYCM4Cf5Lqq9Ogf18Kwq0fdN5ZRuRo/gy?=
 =?us-ascii?Q?dOi12ABWJobLmmq+wfIncpOlPhbewlz8Xb8XcIUm2XaRVm3X+iTcm59Kx+o1?=
 =?us-ascii?Q?rhbZJj9rAwG15eylc+z1f2IDu06gH1bY4sV3dzViruP3x4cVl3Oi7KfKhCbU?=
 =?us-ascii?Q?VZMxm0MgjjpQveMMy0fYX+fE6tr+Ok8K9Rp3Nngyj3D6+M6Y7xdhzVuCC/nP?=
 =?us-ascii?Q?ctqWT7LZHK/SpJYxtJZbg1rA7bffQk747bfihEDVcosI9EX11DxvvTnQZV1o?=
 =?us-ascii?Q?lIDm/Sz72oTzjj1IryftGHISPCpO8+BpYYdd0rhPHabLSIrqQdzU0JHm7dEY?=
 =?us-ascii?Q?D8OY7psXcEoRFjqzzgxPU2SvUbRYHlCXQErnOT5CfD1f0Vx6dIX1X1lJ0EUh?=
 =?us-ascii?Q?xa25BzTUz8ec4sU9C9doe2y7VRNV2GRb+ZfLvoa1ovCC362f1Dc2FYJ3t02E?=
 =?us-ascii?Q?aNT0G5lFff+A+CTenDJw8wgoGt5vM2uJXX+p1H96pg0NSlEnFIEw6ZgIQQ1e?=
 =?us-ascii?Q?0HDkpnLnglklYfGxSEzAaEDCjBOjqTGxoR1fFvTf27YlSreLmBpIg94MOoWY?=
 =?us-ascii?Q?dtw5MX0UO/kdFUa2T6HVeyanoYHAudrEb/E5f3VfLGTBrkfkmZJVPQz8e+TJ?=
 =?us-ascii?Q?x3RYi5hOvGS1ccSZWTCBjYiyOrb6fT+FWCvMTjIY6m3XqMINiMRbP3ls/3t0?=
 =?us-ascii?Q?XKVmyTKOEavgUCqOvXqrLvp5eogSDOnGRwr+mC+kx50e/e5uwXFdAHn0WVSl?=
 =?us-ascii?Q?S7eXDZUKT8KUJGnMNVi3MRIrCgLspJ+aux7LI5J8Fr1a5eiuxtEcJdIfgY9z?=
 =?us-ascii?Q?qqkS10EJ8t7xlhX86DxVu6cd3LXfqaKLX989uSJs72oM4dDHz0VvPiNeIS39?=
 =?us-ascii?Q?MMLiMWvw/HvwVlMwaThQmgd/T1GSRmmZ0LbJuZoesYr66YXA3g2CKBAcJQSu?=
 =?us-ascii?Q?dg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a44cf09c-e7b7-47f3-82b6-08daafb10eae
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:21.7986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fqgx1lUWLIhIpA9eubkqKRfh+XcZYC9gwxeoO8d1TRmCLf6Yc9DTFpzShPaOzvuZw9GzenKGBkAMDSPh97i8gGZVOXPP0UWzp6yCXAy88uc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: 2U2NLL0rNKgaGjxWbaywDKyBc8KuOzqA
X-Proofpoint-GUID: 2U2NLL0rNKgaGjxWbaywDKyBc8KuOzqA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description from: Martin Wilck <mwilck@suse.com>:

The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
scsi_noretry_cmd()). Packet loss in the fabric can cause spurious timeouts
during SCSI device probing, causing device probing to fail. This has been
observed in FCoE uplink failover tests, for example.

This patch fixes the issue by retrying the INQUIRY up to 3 times (in
practice, we never observed more than a single retry),

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ffdb043bda5f..28d53efc192b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -674,6 +674,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			.allowed = 3,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
+		{
+			.allowed = 1,
+			.result = DID_TIME_OUT << 16,
+		},
 		{},
 	};
 
-- 
2.25.1

