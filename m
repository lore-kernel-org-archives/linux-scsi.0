Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD89C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiKDXZc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiKDXYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386392A72A
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:44 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KhwDA026577;
        Fri, 4 Nov 2022 23:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=DWQKBkcxjGSuQTCm1iiBBb8oB3tX+WUgckUi9AlfG2M=;
 b=IhOozfkqyrEAQjTby9/uTt9NGRYEx3jLXPF/kk000U/P9gc+6VD7yDxCY3JaWsVvAttp
 aeF84IwA3HGMFmbK6Z7gqu1veR0hVLIsW6GcCh/cY9COYbWusIbMHfNFlXSSQApnU+6c
 Qd1jWpfSEnwT+Ud6lbDXy/9KruS3XflOAOVwJXxDohI/bQDjwMnCj2ayYpBe8gMXgXey
 f23Vm4LGsuZ+OiEnfAmZi9G1eaeufY540/HhF/7PpJwlqi2x8KAsOd6Yf89Hp6DfE4SI
 6HpaEkoG6EIIcuo5GYNk9y/Zs9LUSLXqfGdxkonlN+91S79+xBrmuM9YaddPSOkJKQzQ lA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgtkdgf07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4K2H9n032976;
        Fri, 4 Nov 2022 23:22:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmq86ge1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SamhA9F8TB3mP2qyvNIu+5/YZ5EpGKJr5yq9eWYoY1/Axx8APgctnXsAj3s78nh8jAfhTXKfyOTrxsWnLMFWQAxbRzCGRg+qmZep5yY+ezWULJKfsFfKWRdd9zIkqs39p8NwdSzao+4XlL1LTG/q03drirHj2SxRzhZvxwondzOCrEMkhLtwFrF8bG9M0zI9i0TDIt+VPJMaXGvoQ9/Ggk28c0DOR0NZFW2Xz+i9A47zQbWSsE6tWbOMkT2LUs61GUe4Bah0HwJS07CXnhKZGohJr1n3FPUuuRMXzmwg3iKEUI8vqFeELCKFk5fcRni+pffamGuWyjToEdC+PtlnLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWQKBkcxjGSuQTCm1iiBBb8oB3tX+WUgckUi9AlfG2M=;
 b=ateW52qyaBlz60J3wqxEIvVPOWKP5DKd97vDcNybbGZr6y8itbupI3ts+q7NxzOjm/FuKvhEBOy3ucv5cBVaZQodJtpdDdIqdBAhr4cqbOTDfwbxLEb1p5jxPTEeiJC8qYcsxnu2usjZOMOm+zCNCBw7N50hOxubYD/jyChdTQ3Oj3W4NNNv36lmpxtyOfmsf+Y5NhnkRvN51YHyo7efe0+NF/ou1E8esSbvP9MbqTNXGDRzBFINCaN7aPqQ2j8ClAsX538LN4Fk8SUpEPDGG0STgJbi2B8W67bNhOoSxOoj5Lhj71OhIyx5GUrXkcEmUpY4B0oPUiDAiLqC8jahzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWQKBkcxjGSuQTCm1iiBBb8oB3tX+WUgckUi9AlfG2M=;
 b=sGXmdvcybQ+DddthnSTkKvtRM+fPhpIA4k6zu113jLHezXNDq8YXZKc7v5VsIF+eB4T8dLhpOcWtSi4Y5wc4PXzGg7PtzsqRhZ9phVRAEhuDCJW3+h8T5FxaVjRQzBLsEed+GPu1JicwM26ipj8GGgk1DB/Yi7HejGRR299Tnbw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:22:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 30/35] scsi: sd: Have sd_pr_command retry UAs
Date:   Fri,  4 Nov 2022 18:19:22 -0500
Message-Id: <20221104231927.9613-31-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P223CA0027.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 83cc54f9-4530-4025-8ab9-08dabebb69e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X9+usfKymUNrr97Ra0mA60Y+SCz61r//LlUxf9j+d5ComphedWyUJn0KmbvFoEdCGyzOclRRm1HGtXo8nWmSR0Rp1F/AYdbS+hkvBUDQV3tcaQo8nOtYsZjf32wtMXx1P8+WnKKCck/KN/7oRsbGSNKejzTgitWCghk2Bo+CLN1yoZIjOlG+xsltPrOKnjh8AV2FiY4K9fCZ9G3mTfKTv6g2S5ZKcwQ3vPlNLGYiN/q3MgdBg7e1lgQWPRfxy97DooiB1RLSt3cU57MZFxhJCw2zh/IyL3WHuXSFdEPIC/vAozD9C+C0DR09tvC+j70E3/jMtb+WJrucIMYQ/3afnop7V5t08gq8q0w+EaRXGpD5GTUshvCXaGNnrrowI3O+fJMNhsYNNQgv+gq5CC/ga4a4AVyf7+BAKNdscsuRrKh8Yz3TgtnBOvRHaHHxWIJeuuRpdAWeqG5WIk0EYzYWW4jmYo+lr6B2nySLe6zaGVwOz6CSw43VRaKsXBsNZjOGuJKiBPqAQYwK9+l43eE6nPH1m5+P4BSJruXEiHqM5IR6sNdg1szuAxbbrNa2Ucg7OQIT/JZSBoITKwNGkzq/Mkh8HGN/xEOCcGLMkmK6J8uZARfJbdW00z+dii26DTbvj4MDUupbJd2D92pqjni7kxDipB8F7QKjA6A3ypA+rHRBQ6otjLbnJ0ApQF3Zytl7mRmRGDZbR3N9AIKNBbwyxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(107886003)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o5vqJw74rIWq2XFcnNsPYmHimNroXPR4y6iVfjeWO0sXNQMKIA/zQ76ayTWX?=
 =?us-ascii?Q?FFqm/3l8cRSSd1I3Aj3prK2cCyanzEHN/xIJobeeOFApgQRAbJaXyOsYf5Vv?=
 =?us-ascii?Q?Rk+pOduR9a2gdc3GYwt0L080JXwAz8iwYLl4mWCZlsSvDzQ9VIjVY48c2jqc?=
 =?us-ascii?Q?KbWbFNk/huwd35HeNciKITjx5KDVqSDXVCJY6W5bi3iUP1nu0ZVHCZhCfhMT?=
 =?us-ascii?Q?+l7Q2MxK8YJ8ScNbjWQVTL+mnV0sThyDWCFaKTvM9Th83ammzNO1HLy5ViTn?=
 =?us-ascii?Q?5UnJSU5krbhHtTqcr4VhG/wKh4krVO/goigbG8yI07YtEWb6EpGRVmktSUh3?=
 =?us-ascii?Q?0WAvuQwNsTNTq+rG2Q4r6rrKIxQgTHhAnijXZUiSPKwT7yJi0cuE2xNtkDwD?=
 =?us-ascii?Q?KNrnK/bJEyVxIPpkU8WTL4po7ZdYZpVQXjuVpY9xbgAE6ZVUeIu7Q8bC05mK?=
 =?us-ascii?Q?Ke8SE1rlRbbmWSN+lI8IeABTTxqi8XTE73rOqzmu8s2/7mNnmNKvVEkWtgYU?=
 =?us-ascii?Q?oQ6vne7npF2RrPTMdWJHKdX8ttzh766EbnI1Ys7ge4PCW+MJBRUJlMyJXjIM?=
 =?us-ascii?Q?KckCOlr8P/m6O90YGDY/7CYtvSLsZ5QaNUXZRhseUc56Hy9rG0k4DrdUDkzG?=
 =?us-ascii?Q?HFFJvMgqm8wUh9ynYIoiNKM4aXfYeXiFFM7+JKsIq10ecne+MFYKXRms6+cP?=
 =?us-ascii?Q?oczUQ1aHZx9eoxUANDeknINtlVkcldfBuR7b9BzPWq7sB2ETD7Mfnt+SWwr+?=
 =?us-ascii?Q?xLfJlivzcZAtsikyAsKtDci+0aAHQwg7/STEdCvPH2hyWD7KKyAfUs41M8ue?=
 =?us-ascii?Q?fkjgU5N9FIEPIF+aO9s5TZfBufsV0bgudgYiYOjCRZ78i3wdqis5wUMs7XEO?=
 =?us-ascii?Q?8Sxh4WzTiX5w/ZOoDvVrXdSd+2bsMFc9Oin6lK1iiq/X4tr9gBMjUpEjtTnj?=
 =?us-ascii?Q?HBw8BAK4IjCImz4F6GK4tjKI/UYbCH6vg0vJQnb8JACrgsDrXuieJ3JUlXlr?=
 =?us-ascii?Q?l7P9axAUxeP75Qer5MHzsey4VMfOvyd+XhJzDpdoUdh/zdLkuXDmoFSGmO6I?=
 =?us-ascii?Q?MBM9Vcy/BYlt6Ekl8pRMwMM+2ixZ6l5zsCZc3w90GUURwjsqRYH29BsaGIHD?=
 =?us-ascii?Q?PADoVXdkUOTPpwZzhmSumglsuaoz+6KsyADD+ViNmyeNa6EnDOlo3ikmmMbC?=
 =?us-ascii?Q?ajtxBy5OvvRIRFsXTJ+BK3gmAwTZru/5gp3x5IFKg05LPoWhum5pARMs21jT?=
 =?us-ascii?Q?j18vmUiuZtku283R74YEsb0TuJIe41a/4Oz0ueXxIx05CbD1AddLF6iYKb8K?=
 =?us-ascii?Q?nFby3r5hVE18pRjODkosPN96x1u1MT9VoPukiATkkO3mWrhUfsNQqPgIvWR9?=
 =?us-ascii?Q?S3vytf8dG8gTvyUti+0XMh8eXKhe9nBU7/5pU3oUjzEbFA50eRyMKMJRRS9s?=
 =?us-ascii?Q?9sW8Y4vYL8ymiutHWHTG+YcMEO2LkGDajZ2faF9p0//7i3R2TnjxN8fWm8Af?=
 =?us-ascii?Q?pdBleiDKhE90wXPL8h1OeNZwEX6NvLF457Va6TPR4B90JRwPZcc0ERl4/e9a?=
 =?us-ascii?Q?BuieG0AVs6XAnabofSfFL3Ql/skOP6k4n9Ulsi79A20iQOD2a5FpDjgWQ5Pr?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83cc54f9-4530-4025-8ab9-08dabebb69e5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:17.2096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b/Sw6YpM0aI0htIcIWGXyw2konVXyJp5rmKNt4t9sE0W/JTTYtoXcCB6ecdJ9B9e75ESbOjawVJbGeeOwYXDl/9tP6VTaGoOKMgcPVdN4uw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: 4F58PmCUg3VvBljpNlfgGEpkC8BHsS8Y
X-Proofpoint-GUID: 4F58PmCUg3VvBljpNlfgGEpkC8BHsS8Y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's common to get a UA when doing PR commands. It could be due to a
target restarting, transport level relogin or other PR commands like a
release causing it. The upper layers don't get the sense and in some cases
have no idea if it's a SCSI device, so this has the sd layer retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a07f569b5812..0545fadde8c5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1723,6 +1723,16 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	int result;
 	u8 cmd[16] = { 0, };
 	u8 data[24] = { 0, };
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	cmd[0] = PERSISTENT_RESERVE_OUT;
 	cmd[1] = sa;
@@ -1741,7 +1751,8 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 					.buf_len = sizeof(data),
 					.sshdr = &sshdr,
 					.timeout = SD_TIMEOUT,
-					.retries = sdkp->max_retries }));
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
-- 
2.25.1

