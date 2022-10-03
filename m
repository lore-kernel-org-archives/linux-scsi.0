Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A896C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiJCRze (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiJCRy4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553983ED6B
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:12 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOC60029461;
        Mon, 3 Oct 2022 17:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=3w0UX2ZqiBlW2PS8bR9mI5uNY046r91V5K3LINURgPA=;
 b=VtRcYBFZUUIeKby70+sDSRp+b5VKvRELF0tCrX8i3VC87ff54tyjikiON5bGfEr2QKeh
 WNzdbKllApm6ncT1u3IrhB2rksgXG/JK0QOhH1rpRWAU8PgtkQbzDSzE6H3WtwzKOkhV
 akZH+PnkL6jvzkuWC9OkOvTOohHyMN/7+RNaIGK4jAxwfjt8YLM3buJLOYPTouQ76izx
 jD4Qi6GTjjkuOGrkbLTiOzLCpVbPjJRBrsUVBLpw6WOfAonLqMWLS14e6qIzzguGelU6
 npjiycT9g/VnpfWF1VlMQb/ZWSpF9JFNiflprI9fJCqqUaNmk9rextURjv4Lo+sOD5ld fg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxd5tc936-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FFNfg028067;
        Mon, 3 Oct 2022 17:54:04 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09gdgf-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHYr9dI+FtRwISco5XwMzHKei5VwH6jmz4UhxIqeIekaZbFIen+0UWdjVBu43zE5hJkmkLuDpt6uUPvlzQVakbClhuN9evllYHp5ek2uYTVHqgWAd086sdJe6EnRwN+OaK+IGZtaL2/sD+VrBbyAR8AeaoG4f9ZF6t8jiB7jDuvcsfrktaoCvM7rKxp2nj/wgqXRMHNDn3LMavxp1mfdzAEjpxS/9vWLSJ3TRZx4+LeSEqLYHsiWsHKEcuAbRync+q1e3q2BkRbvaa0EDC21LsHSIhmcIQJ1pUTKIoOew2lTGg7wPtnT6S9ettGvlHtu4ujoYWH4kIJZcV6NbobB6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3w0UX2ZqiBlW2PS8bR9mI5uNY046r91V5K3LINURgPA=;
 b=cnlhHcagVOW81+qZ77Z/Xic+pCPsF8cqC3DTMI/dy5i5Vx8q1g5O4GNdBTlePcv/9gI55Oyw7zNvIcuvdPXVHnRDEpo6BJKW3LFConcUBweTAsft+qfcPxrTGgbu1+qugecIgc7iTV6/dYXAE7Y4u6J0o0oe89o09pplhBswjDfxOYQPl3Y14yNGnIti0VGgNm5oK2UzgW8QKcfcPG1EdN1ZTX8KeGjv6y8oEjE7LfqHlDS934+GceIJG/NwJY8qlhTaZAoI2HVJLqevP6cInrG/pBdMDbbLnGgD6CkdVw2ocuu0Me8ZLW/bo0elPH50yeXOU/TE4jUlzqJDs+6GIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3w0UX2ZqiBlW2PS8bR9mI5uNY046r91V5K3LINURgPA=;
 b=Egt/+WUORgWeK6qukEfKdQIRvkGvRTyq4/qfzpawuAK6pt1/n2Ns/WqAWSG2fFoUcS+ncmWH2vBToAvSk1v0WmkC3w/hghaI3gHByFjh+69vdORIrH4KT0NRizxerTfrZouUig4Otwwc1KbmbloEMmCEFaWj+jFVo/PUtrKTEmI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:54:01 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:54:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 25/35] scsi: rdac: Have scsi-ml retry send_mode_select errors
Date:   Mon,  3 Oct 2022 12:53:11 -0500
Message-Id: <20221003175321.8040-26-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:610:54::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 79a2e020-dfa1-429f-1b6f-08daa568410e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3EmEeeg1QOZOh0lO+44TYqTtqwzUBxxfvuPSSBIG5ddZemmepmK//RgC8AdBqhkFXM34h4VfAw4pYA0UBphPA2V4LljK23pl40i7QZ506NKBW0jG1op4MmFiyTSt9ZCrDzTsCU4macxvcTQkrDeBM0Pgw7IpJKMauLLDvfK4eCQX83f5EnZhAjtKYz3HK3YsMiyl3ODv3XeMOemjmOjuXeBTM3ej+nNMBvuaezX8OvuVcM9hHOybnLMfeU9XTYW0khHdLWG7tXYE9Wh/7bv46AJybQJblEW351sVi3UQhPrXwC3/tYNau+ZTEKSWchZjBkvzElwYSzTDlZRlz0ECeqCDlZMu3jJJGGCx1pZJoFJ9Wj4C8zenTvBjf56fLmhM/pPNqnyh1WKVM0wjaJfoxNNeYMDIuPK0uaty9pjjwsXfhx678xurCF+r8Rq6vlY5isP/oiLInWMmEEJUu1vKdz+wpjBzBbs07JHj8JoW5yZAcbN6TEhzKvJSoXNw4bEN9Q4HG10M6OVJPmPi2FZb7D+lhVNa3HIMLqcyE7KIIwqRmqjxPRTN4tj+GorfwJBIXyI0X6WNpwmZfXv0OhZ4cEuaa+eQel99EuewGy9wL3Kizv0QtO598HQ7VSyjoTxqc0YBsAYLrnzkzeIFu6Kt3mbTXl2Upx98dsFeHSDQD2LdjnpZ8hZUZ51YD/L9pFBI27AIXXWf1ii3qiHKtEDYkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(6666004)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8npwfcWmt5Pc2ZF5EbeSIKYgvE4V6VTW2wNdK+KnUCK8QvLaXJ2nZ0y6m1ft?=
 =?us-ascii?Q?Dsz88PRC0joz+qw+3hAtCAzyqtjvxSm5lr7dfxG8ZCV/BK8mWXZZVaMojhUD?=
 =?us-ascii?Q?CUuTNPU04kvXtNJY9H18iKXMSY00jj8iFVcS1MPN8ihJ8EStGTFufEt2tQWG?=
 =?us-ascii?Q?GK+oISVFqEE5W1bWSp4KZaCt/DBz4BwluATovlf45wVsHnNtXqlUj5D7bAE2?=
 =?us-ascii?Q?Bk49Y33Ivy1y4+ZVl7R/Sah322UZd8lsQNSGjMBfwWbfDn4oCLBBosWAKK7d?=
 =?us-ascii?Q?a/9UUdh3khaLy9d4009pfGJVGfQfJCMKFvK1E6SgAfzrwsMMmGhqQ3VdyDAs?=
 =?us-ascii?Q?ycczXEn8JeUyGgBXsb9IN1ad2lOVbbDmDSJ4JhY+nLldB/Tz+zRoTv29CAvM?=
 =?us-ascii?Q?QtqKhrKTCZDCWQdP6m1Ih/3ZskgB0n83e3rxQ6zCzVclA+j7l5IJb2NwfFJs?=
 =?us-ascii?Q?MNPW/d1sYJny52ANynF9nGXsVmOAFgm/yQENeCNhnAMX0yCa88ASpJBb3Eb9?=
 =?us-ascii?Q?1g7ECw0bA1AkLi9UI00YnKFeWydY7DQn6JUpAJs1izgbzvv9IiqOwY1N0nP4?=
 =?us-ascii?Q?jN+I8Wq76tDnO7hOeHQvHq/bNNpkAdU7AIMop6eHtQ1MFDI8ZckgkwfGa9xS?=
 =?us-ascii?Q?XS5d018iHxyVuBdbOjEwPM3V04iVe0FlzOis9YzisYC3gcAq6qMaZgN0c7em?=
 =?us-ascii?Q?6cLcjrM7i+k08L2m8JgB4sacHqSqdUUqrzCtDrdnew2671wnYsdHl0c/tlIa?=
 =?us-ascii?Q?t9vk79YLV//JooWHTVeT3vQglMeSLbYxh6GRYZCBYjz+8SHjAc5Chg/XC+No?=
 =?us-ascii?Q?nVNkbx3VVe17hRn/CSMMwzdNlHXEx4JxnqHq/+yrNodIuc97ffdOf/9HTvJY?=
 =?us-ascii?Q?Td5Yqfoy1VUuVzmaD7hcfznITCYyH72vyDRrvEj+3qVeMprCVxzP1If2aMGi?=
 =?us-ascii?Q?ZLyN71EpE1uce8jr5TY7u4qCz+a6WESUKSU8VQ0g0uDo9xm/EVD9tBaBiCQT?=
 =?us-ascii?Q?a1MglR2RvlEbyXJEx7MDWLDDS1oKASU4V9jsQQ5F+bfyTnYyBK483KZ55vpQ?=
 =?us-ascii?Q?s8R8ZJsI5OUNXNvGOpcayu5Ny7neUuYKqtVJo6scS4mAU7veBdtnIBijlHIf?=
 =?us-ascii?Q?KmNbhgp3UxmO637/w+ErelUzleP7+f6m+VCtfN5R/jld1Y8R51tQj73n3bBA?=
 =?us-ascii?Q?hj1OH6tekEibT55B/zcDjjpB2sZtCUcn0XR7BiSIh4HACIlupIU2FzpyJoP7?=
 =?us-ascii?Q?PCSMHhi1Nm0uur1uLWRdyXeNKN1OCAFhOjVp1AunAn25KMXIyqwz5CoxwYE1?=
 =?us-ascii?Q?6NNVnJswNuE198EZMnHxd1+KhNnCbWogyZefe8epqi1DvB1ortwqDNd9Rr7s?=
 =?us-ascii?Q?aj6PLpwDa9bJJlAFrX5yaTxF/pWmzR36JxiIPVK8g4ZdP9O4VTdz3EKVTaak?=
 =?us-ascii?Q?copUN3ji4KCnaZN5OV8rSVvOnlb/qiUWBIngQfvb4e5H8yXE+3URvgb4QCIu?=
 =?us-ascii?Q?FgBgz1XCsgBQy4jQpVX3qOaMRsvFO8KT0VYz9Zn4RE6Z1FSqS2CSdCbf+1fD?=
 =?us-ascii?Q?LYiUA1V/qXj06+Tf8mfRADekJlHXCjBZM52hIv9SnpgbDoK282HJ5egAD8Zo?=
 =?us-ascii?Q?Ow=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79a2e020-dfa1-429f-1b6f-08daa568410e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:54:01.4221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l6q7tyKX1N6xDfN8KvGdwL/LzpsvUwkAjZER2sPDoyfbh4vWLxFcLMImbvchR7EYqJ56TRRBfLPbZpm1JiC8wXeVQZBtAtqEGwCdMg4dWhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-ORIG-GUID: yVr5EdNLG27jDHChsdajDHbOg9mcPkch
X-Proofpoint-GUID: yVr5EdNLG27jDHChsdajDHbOg9mcPkch
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has rdac have scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 109 ++++++++++++---------
 1 file changed, 60 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c4d1830512ca..480185d57071 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -485,43 +485,17 @@ static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
 static int mode_select_handle_sense(struct scsi_device *sdev,
 				    struct scsi_sense_hdr *sense_hdr)
 {
-	int err = SCSI_DH_IO;
 	struct rdac_dh_data *h = sdev->handler_data;
 
 	if (!scsi_sense_valid(sense_hdr))
-		goto done;
-
-	switch (sense_hdr->sense_key) {
-	case NO_SENSE:
-	case ABORTED_COMMAND:
-	case UNIT_ATTENTION:
-		err = SCSI_DH_RETRY;
-		break;
-	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
-			/* LUN Not Ready and is in the Process of Becoming
-			 * Ready
-			 */
-			err = SCSI_DH_RETRY;
-		break;
-	case ILLEGAL_REQUEST:
-		if (sense_hdr->asc == 0x91 && sense_hdr->ascq == 0x36)
-			/*
-			 * Command Lock contention
-			 */
-			err = SCSI_DH_IMM_RETRY;
-		break;
-	default:
-		break;
-	}
+		return SCSI_DH_IO;
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 		"MODE_SELECT returned with sense %02x/%02x/%02x",
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
 
-done:
-	return err;
+	return SCSI_DH_IO;
 }
 
 static void send_mode_select(struct work_struct *work)
@@ -530,7 +504,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
+	int err = SCSI_DH_OK, result;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -538,7 +512,49 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
-	int result;
+	struct scsi_failure failures[] = {
+		{
+			/* Command Lock contention */
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+			},
+		{
+			.sense = NO_SENSE,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/*
+			 * LUN Not Ready and is in the Process of Becoming
+			 * Ready
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x01,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -546,33 +562,28 @@ static void send_mode_select(struct work_struct *work)
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
- retry:
 	memset(cdb, 0, sizeof(cdb));
 
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"%s MODE_SELECT command",
-		(char *) h->ctlr->array_name, h->ctlr->index,
-		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
+		"MODE_SELECT command",
+		(char *) h->ctlr->array_name, h->ctlr->index);
 
 	result = scsi_exec_req(((struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cdb,
-					.data_dir = DMA_TO_DEVICE,
-					.buf = &h->ctlr->mode_select,
-					.buf_len = data_size,
-					.sshdr = &sshdr,
-					.timeout = RDAC_TIMEOUT * HZ,
-					.retries = RDAC_RETRIES,
-					.op_flags = req_flags }));
-	if (result) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_TO_DEVICE,
+				.buf = &h->ctlr->mode_select,
+				.buf_len = data_size,
+				.sshdr = &sshdr,
+				.timeout = RDAC_TIMEOUT * HZ,
+				.retries = RDAC_RETRIES,
+				.op_flags = req_flags,
+				.failures = failures }));
+	if (result)
 		err = mode_select_handle_sense(sdev, &sshdr);
-		if (err == SCSI_DH_RETRY && retry_cnt--)
-			goto retry;
-		if (err == SCSI_DH_IMM_RETRY)
-			goto retry;
-	}
+
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
 		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-- 
2.25.1

