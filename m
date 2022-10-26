Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8A9C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbiJZXXk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiJZXXO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:23:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606E2E09B8;
        Wed, 26 Oct 2022 16:21:03 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLHdMc020594;
        Wed, 26 Oct 2022 23:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=YjQjZFKhtM6E1T3ecuD9hROX2zC0btWkCWwqtV6n8AE=;
 b=zo6C9I7PQwiD+C3BharH4GwHLyB1eOzqY8hyZ1GoShnB57Abtg3B/Uzlti8jXXVoJkT3
 qzPH8kOx676PCkMBeefeQLhcvVd96/gCP/qXGUFULzcYdORVZ2C+7u/fYEgz/3e9Pn9h
 KFBTzGSPS/85P1EZ4CiR+arz3J+cpS1iNuvStKtOintcTeyS6VBhBs6S1iPA2rJMLLcn
 9VVb7N4gN0eWr17iuVnNsf+1jdjxtmozL/1MCFJXEm6J0WDJHFs4Y0Nsp1NeEXKD2KAQ
 cG63N602lFNoaEV5/imAy8FacStwK/czp4BwyoyLFax5t4nwZC+VEhB3K50oASHOndJw Jw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahe8n82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:19:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM7DO9006899;
        Wed, 26 Oct 2022 23:19:55 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaggdrg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:19:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGme/HmplbQbaxAu2V/qRniqdWTA/yB+4VA1PEaEsssBGRGFdgmNRFfZcZnNjRJzf0cqBEqEoMYjKR1VkbFjUkKlgAQHVRJvhoCs9EAoIwJkH+evkFDWLNvAKNBDxYDrq/2EgxfkFJVsahoYZit9+GqUOZlareEdsij7JWy8+WQRkmKsV6uQ+omydd+rRKCGWvGoQ+eWLSN3rjwXtvVR5ijqkziShLrFuh5jH/Yl2/RtPyBmiFbIcSkHCvCe75EHCRvHKKS+hBwevbkIrXfKnfgt848yADKNOTMlKK/qDUFqKbsVfaRSTUmCK56GF7HloAwrBXhpbkTeVpBAf3oUiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjQjZFKhtM6E1T3ecuD9hROX2zC0btWkCWwqtV6n8AE=;
 b=Dsj9toIyqAI5JW2IpGFGh9W9KNVTy49kWEQgQFD60bPscO8t/knkUNdLGx3nj/t2mZpTmsutHUICEA/Nvb3qQFhFCP5lxSKA6H+2vbDA1vUOqNpq9zl6KB3i05pFsDtGEThlGhPk24LDnUclbMn6MdexOnduq17JqIbGGwAt1d+ZuO5N0hF2+SitJcz2u6S4cmqmbgsr5t1j8dASOPQWs7O0OEbWFEqIEcsViVnTomaGoGoN4aVd9cn0FQHw3z3bhMmVIdNYr6ABOWFnq8uWA4z/9WmfCUbQRvejManND5RDl5W0/+jq5FoD4gaSC/B0wBiRj/40NgiK8TPuE2861Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjQjZFKhtM6E1T3ecuD9hROX2zC0btWkCWwqtV6n8AE=;
 b=RxwtB9hS8andWHorY3Xv10bdEUWYVoqehJbCNru5B1PoRr+Gq93rm5t2o/yopG0n1cN0lzJp8Funkkwd0e5RFNl7YCZcp6EzDLv/aJunZmF9vegOzb63Xfnyo2YhRIxqbZ0uLdR1VU4NqRkS71q3Bq2ZW6Bm6YhzoIvJDH3Rum8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:19:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:19:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 03/19] scsi: Move sd_pr_type to header to share
Date:   Wed, 26 Oct 2022 18:19:29 -0500
Message-Id: <20221026231945.6609-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:610:74::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a34542f-eb2d-43da-b66f-08dab7a8966e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NlvzxDQbCrV1kgU9ubM1vPQLtVJx/VgHEz0i2LHcZ25vlq2bKzyh7celx0g3ozlZLaVntCJ4rUWTeRR2omi57fCWrXeWhxm1ODjX6yeWvx3LybfIC33qpi1C0Qm88f7gH1CgwNwAt7rKH/zmvsEk3uZfm3Gg3w+rVHWnUJfh0T++4FkWPSC8tVxM2xZTjdleRsUk+5W4n6VAQJ4EWA9pOfdgSN3b8huvfZDv03VrTqBlkLnvAIcv/NWIluM1xHeDGJLRoe8hSZ69LHrXOOuHdinp5DLWVzxsIskTDvKtyEcCFRkiHydhWVFY0ftDIQcuhL4UW24zB37YHzTWZRYWejtXec8qU8+jVprlLPwHX8TY2vXiT3N//YikJ9O8zp9Ne9l3E5LzCPEEC9BpWqG7bImNYSjflND6m/4lki3y80r/LSM4lbBbuI6JWNCBa0ql0wB3VBLX0ObRJYZbx58OPOlpwccLHguldiZE4tCJAnpP9hrtQcCLPFDzo9ut162gulE71WJQ5AAblvLrNeQpl8CxY5NhfiNMxZ8Uy56t8YLB7UaAS9zH7zlCpkTSf/qK/ETVqwm6I9Ba+W5VNafd8LKFXHcQgjDFA8dqcObBxTaY+h/5lfzt8c+WPCveTAqCuYkpBAvGIQ7AKpwhgTbISFQXY0VJronWGI98vZXbxEjEVgxC9M4hhYxZnu2tD0oV38pWYP7GPQ72EBfoPwt43Nriu1cf408nHjEgr0H/Nc/f3mhhV6Rlfx9q/YdKF6tV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sVeIA3cRIyXHXWYJY7jvrKih2coMb6qKTic3L9+ZAqHi5Bwu/I3nn2RQiyzK?=
 =?us-ascii?Q?7juPq2vvhg2r+Uy4sfjl4x9Z1cktqyBEwhhRiflGI3s7OEbAQ2C4b0AQx5II?=
 =?us-ascii?Q?EJCBCNLDxmJziGe7xgKG2BfH8sah73UYI/lIe8wihuCL0rhuOo+iZjUtYktm?=
 =?us-ascii?Q?RqgNVGK059Bppb5HXlPEgAqSMefnNwkHeRw1ePafuHBzWW0BzqYtWWRFKEwi?=
 =?us-ascii?Q?PPXW0K8/g71Qt92O/HPRgeyE8iw9du2bQne1LiALY39ouFe6PnJqupn5XsbZ?=
 =?us-ascii?Q?X2WljXr8leEtolcwlEECj1wSZPODNpFxH2ugLlzu1cX9W+ddB5JSh2TzPKUM?=
 =?us-ascii?Q?0EdTvotXGzaquCfF5o/xyMmYRU9ql07Y/SpCF0XAoxBuaf6RJsK3nPfwKPeF?=
 =?us-ascii?Q?j2ofW94kWnhGwG8aaSYmHW3xMICPZFVJMujvjXqEyixTmmRRblqeBxvwEXV+?=
 =?us-ascii?Q?RNyVT25wmA+cy8ZGCvWgX4MpS9j2XsMHVIV7MwCfS9A46GQ5bl8pybjmznfJ?=
 =?us-ascii?Q?BJH/pSmBO24dx61IIeRBpmiV2O6Z4OVYEaYUigBAoabgRYwR5ttgeAalPBTM?=
 =?us-ascii?Q?9yKdCG3ZBO7Vpc6m0PKtA6ZkMwU3NyM9jW5g2TSKxnhX/nuy1DJt/3h+3q9Q?=
 =?us-ascii?Q?DP6Uu75bvdf3vyR/tsDLSScSxmGW83/fhyg7Q/YVQtnjrPeeXFTJFNaOUNq0?=
 =?us-ascii?Q?zFux0hrwx9fl/kvjnEN/YMP4hEo7xhC86e8K9LqcekZo+DjODg2+jwiWD948?=
 =?us-ascii?Q?q7k5P400CTzHPQZORqs5+W/jZ3qkiPwchL9OBE+z1Ywwp9VaBY3GNwIAr7ZX?=
 =?us-ascii?Q?pvm3F34InWmjwXfz3acS3qUI7BfNC36wvf8IIrRS2V3saLtbD3hSy+wkB23S?=
 =?us-ascii?Q?YPaBTHeKhMjk/R9CNpE3HFstvkmLOGJA208T9yiy3Ptj+5pOfKlWb81VKMqv?=
 =?us-ascii?Q?bLT/dxe7+LmwTrH0TamdDMlrH+X/PgauJDvuF2X+QFmsQRMS7PD1Xr36NC/u?=
 =?us-ascii?Q?LjjqMbxts8dIjVldGTqiIJ8RGVojWRAWTu5jE2HkkWuuJCVZuWhihwVujOOP?=
 =?us-ascii?Q?v0B0Mi/Jchx5RBcw08eNX8pXtYo9DCNoi7XRBNBTgEN8boPoXNNdgyjyG8Mg?=
 =?us-ascii?Q?SNeSdzASXpytzUNaKXBJ6iELSvbUHlphhVKoR9tkpuB8DT9XnwOnJf84BGmV?=
 =?us-ascii?Q?Y0KKVbpZyQLHyvoVhwk/we5dACBxX4qbNGoO1QtzhbBM6jxh0toKlmLfk3Cf?=
 =?us-ascii?Q?StyGtO1CHlG3zatPGSSePa/viybhqls+XjJeY8m8WkN2hO/CogJuesZ9F/P0?=
 =?us-ascii?Q?qBTt6FiBtfETH2w0daB6IcKSe1zl+IxraiRREhc9jt0bjU/W982JlCDd062b?=
 =?us-ascii?Q?LvzXX2iv8OuuoiHFvgyzvhhX/YGPI48zhlzvMZmSV0TfuoPJvbQODnCCVA5E?=
 =?us-ascii?Q?ZnGmX5J5Qo1CO1Ix4YsNaQkr2UOIDEayVv4bIYTAxBI4XaezngR9N/M3sOLi?=
 =?us-ascii?Q?/U7Wgyr7eOFoZy/JUaz3uWk1Cy/+w5FSDV89y1NhpOGFpzBj8XMbw9AalhTD?=
 =?us-ascii?Q?VkGwftBFvk/pBnnO7xuvsExjxGP1cAEqHu98A/DvCZLkxwVDxz0wg+9AyDEt?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a34542f-eb2d-43da-b66f-08dab7a8966e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:19:53.4135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8v0CsnOo5QTwaq+rfEP/WZA+VcddxgvyXj8I8CGIpaBuPK+SAZyuT+J6VjIT6pbChmeDyuAdgHRdC7vkvDwd0kATnF8f52iNWJ1R7K1QT3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: 8PDjxxknKpQ2_EofDiFo9mrLYCCC_FDr
X-Proofpoint-ORIG-GUID: 8PDjxxknKpQ2_EofDiFo9mrLYCCC_FDr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LIO is going to want to do the same block to/from SCSI pr types as sd.c
so this moves the sd_pr_type helper to a new file. The next patch will
then also add a helper to go from the SCSI value to the block one for use
with PERSISTENT_RESERVE_IN commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c            | 31 +++++++------------------------
 include/scsi/scsi_block_pr.h | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 24 deletions(-)
 create mode 100644 include/scsi/scsi_block_pr.h

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4dc5c932fbd3..ad9374b07585 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -67,6 +67,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_block_pr.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -1694,28 +1695,8 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 	return ret;
 }
 
-static char sd_pr_type(enum pr_type type)
-{
-	switch (type) {
-	case PR_WRITE_EXCLUSIVE:
-		return 0x01;
-	case PR_EXCLUSIVE_ACCESS:
-		return 0x03;
-	case PR_WRITE_EXCLUSIVE_REG_ONLY:
-		return 0x05;
-	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
-		return 0x06;
-	case PR_WRITE_EXCLUSIVE_ALL_REGS:
-		return 0x07;
-	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
-		return 0x08;
-	default:
-		return 0;
-	}
-};
-
 static int sd_pr_out_command(struct block_device *bdev, u8 sa,
-		u64 key, u64 sa_key, u8 type, u8 flags)
+		u64 key, u64 sa_key, enum scsi_pr_type type, u8 flags)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1778,19 +1759,21 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 {
 	if (flags)
 		return -EOPNOTSUPP;
-	return sd_pr_out_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x01, key, 0,
+				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	return sd_pr_out_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x02, key, 0,
+				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 		enum pr_type type, bool abort)
 {
 	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
-			     sd_pr_type(type), 0);
+				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_clear(struct block_device *bdev, u64 key)
diff --git a/include/scsi/scsi_block_pr.h b/include/scsi/scsi_block_pr.h
new file mode 100644
index 000000000000..6e99f844330d
--- /dev/null
+++ b/include/scsi/scsi_block_pr.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_BLOCK_PR_H
+#define _SCSI_BLOCK_PR_H
+
+#include <uapi/linux/pr.h>
+
+enum scsi_pr_type {
+	SCSI_PR_WRITE_EXCLUSIVE			= 0x01,
+	SCSI_PR_EXCLUSIVE_ACCESS		= 0x03,
+	SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY	= 0x05,
+	SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY	= 0x06,
+	SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS	= 0x07,
+	SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS	= 0x08,
+};
+
+static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
+{
+	switch (type) {
+	case PR_WRITE_EXCLUSIVE:
+		return SCSI_PR_WRITE_EXCLUSIVE;
+	case PR_EXCLUSIVE_ACCESS:
+		return SCSI_PR_EXCLUSIVE_ACCESS;
+	case PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY;
+	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY;
+	case PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS;
+	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS;
+	default:
+		return 0;
+	}
+};
+
+#endif
-- 
2.25.1

