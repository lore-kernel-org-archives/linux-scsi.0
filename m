Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B91C6FA86
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiIVKII (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiIVKHo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869A6D576C
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:43 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA403D009741;
        Thu, 22 Sep 2022 10:07:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7g+5w5oGb/4K/f+ipQnSNgHg0IKFuGpB0sxh4+zUdaE=;
 b=FNALoFCigA7LchQCE6ANwK1z/r2DZwYlJnI/uHhJ1ulCCLroEUGfJdXrhQXjB8rdDFHu
 U9mty71bnIaeq7egjyDeyUv5eMmVt/MJhQbwbTe7DQrZ+RqMeOqmNSNe4nasI8tFzuV1
 Ou2hWwKDrLnC2h4N/uqG27a0pAvAFXPRzCtAoDzh5XKlbXOu/NS+o9qdixDW/2U2dpmA
 UNtVMBU4YIJgTiofX1rGXXssWpeplNfUk0v8ujbkE2DiePxMrP6Pqwt2G0nMzAv1q5+Q
 FJiBGMO9XRMRrSXPIdsxXJUw/ut9hN7Y8PdyhNVqertcPXgLaVwkd3N8ILdVuYGfRoSE BQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688mgpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l3V4001288;
        Thu, 22 Sep 2022 10:07:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cb3fss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etU4usS2MJFmlo1gVpXHGcyrYEoi2lRfoIGeGLiSVjOJpQWpF9B/YT5Yjr2/TzTxwI43wxdWHNz/JJEcjdsak8dfv40/7GbWjPNOFDgmF2mJRCtPEeThqdrmHwaHNtj63klKpnBVubiuvo3wq3pWfMLU61CQrcdKpSur2IoCHtfbwNGJRwXv2oRhzxzObOGQPY0DquLhrxZTlbpiQScwIUyQG8BjXGKCrNPqUH2bnODrwKq7RtXTnPmjHEhYtbZmTRa5hrRr7rq2rC9BHliyx4dGClRY94051/TqU6/zZyDco+oShJb7hUPezTwvTwHM1P7YaeKVMAgAG8hhR7BuVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7g+5w5oGb/4K/f+ipQnSNgHg0IKFuGpB0sxh4+zUdaE=;
 b=KIxlQ5E5UoURzYD3Qt1bwet52jEWTlsvibfn3mxdg2f9q7btG7hp8zmUcUl6eHHuo6YEoL/6V5dJoYvKTtGATs3jkO/zYuaxqIPI5TzI6aMa7qtJMhUOK92MmJKyvw2VFloYoPyFGD+4XyAOqGsrXGzVJ5TftJahfhhRFhUX6u0TNVo+UHasG1Uu4eZhWPaWxkJCus0qLoTNWZBqH8yTRLqfECcJpSswU9lM+EaouDwaZGsHFn0/41jhNNV2ZHlrtC2bLCDhyQwcUiwk9f3CF176bkywF+V5PppXqqWrwlFWwsrZ5cqWJgrrc2C+z+Tgu+y1H6Bzt3jgSvAEsRP0+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7g+5w5oGb/4K/f+ipQnSNgHg0IKFuGpB0sxh4+zUdaE=;
 b=ODXTAnxXzjtGsUmqXGW/BLtEdTuQcKUqTvtFBVGW1TpF3/ATBao6XPqXyboF2dIIJJdqChkF0YAxZHFU7mAWaYMe+fG5peTn0IF/V+Nv1YqXXnFKfEDkWy757FUyVY3t83lSP3vDII1zjNfiRGbFs9BtXkql3dwlLacW/c/g+HI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6243.namprd10.prod.outlook.com (2603:10b6:208:3a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 10:07:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 11/22] scsi: hp_sw: Have scsi-ml retry hp_sw_tur errors
Date:   Thu, 22 Sep 2022 05:06:53 -0500
Message-Id: <20220922100704.753666-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0007.namprd12.prod.outlook.com
 (2603:10b6:610:57::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b7e1536-e2d4-4dc9-8cf0-08da9c823f1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x4mFD7aHez2KeLHOLyh45um0Xs+3mJ7pblPL0iMVPrR9nDaZDvO/McQiGFAVLxZhmW/QYZgzAJHeloomcgJ6+mF9vjxq9Z79nmQ5106Pls11dRc69gS+YWM3zzxXAJtZyELVbv/qtNCeVuicUqLOm68Vakgx28rtwwiN2yzQvZ2Fng22iZIsK4atYaLJycUhqus2DMmxPI7O60Ak4ttnW9CqwP4v2VgO+CZ/9T25B8Y7FLzDEtsmV2yL1jThhQKSDmKF/1okDTc253+DA6XSzk90/AbSDqFmGOAglSlQSQgpPJMBge2IrlKD+IW9IfSANaSIZxFP9ZhUIfQMnwrKUKaYYnrzBYDo498WGoqE3EuHalXcAhIqqPaACiK0PpAoT0R7CMcEg/leIzra14AI0yX4lYs3uaTvl9sqQY/OPxHcjkOCRl3yF3skXrb4V3N/6Kx/NQJSQJNcRQJhBrTcBPA6cDi9lMbI9p8Hm5I1pyHR+v5tnTUZAK6qZb4tBZrb8XVUIP3Eayb6XEL+PVR8JDU/RVGuBxxPcnHq/n60Y36ouH0S5ioRv3NZGtsCF4mBWnFDsM5whRdAKMLc/1akgPvHrPt0bND8egAY6+1qivTIyMNK8cFiTn6RIUPLfb/CjaJRkDifUpfRcW9LE0l4/7wJ+ayAmQ+qJMxEPySpUW3hMI1PRQ6f5gI8NYgYAgpCsXpsRh9QMSF9QQtw0wVJ0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(107886003)(66476007)(38100700002)(66946007)(4326008)(41300700001)(6666004)(316002)(8676002)(66556008)(186003)(1076003)(83380400001)(8936002)(2616005)(6506007)(36756003)(6512007)(26005)(86362001)(5660300002)(2906002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?05EHBFiljK3+0TVmKO6u5Z0d4fzMNHSsF1TMtpxybr6qYdPw/SutIckAqNhD?=
 =?us-ascii?Q?Z03gw7XalPoyn6/y/HM6niuK0kd+UlLiWG+FPKdT2FWW1pF39AfP1sZAgHGm?=
 =?us-ascii?Q?Nas9SpJmgX6pqQpIoJxR3ehAPu5srmmF+/SlU78iBDtAXE7Zjb9DrOuWxqAe?=
 =?us-ascii?Q?V1YKe4rV2UbVtlR1HWD/h0lQAkUhEoku11ECG7w0kGMau6lXcplAkUz2fn8l?=
 =?us-ascii?Q?Txv3x0D09FMrrstQXXZk9/UlFd4QOztaSPPoAEhYLfc/geN17t8oeKG3WmDt?=
 =?us-ascii?Q?Ml/WJSaleBS0qWgTz55LlgmPCqPFROMyi5XgVWKlT8jU3xQ/hmV3BVSmRd3U?=
 =?us-ascii?Q?kRmI2mMKv4W6JJTEBYbhAGNSawj7ksWHggqpj6Ca4jzrox3qkO2yOT+i24iq?=
 =?us-ascii?Q?pAYdaRUDjK0V0Hur9TJe/aGQr2Ij2G40HbPkOb56a1uMFzFhDtVFgP67kU4l?=
 =?us-ascii?Q?nR3AESQYn6c+H9NIq+4cR/TzVL0I0zgMmoMJomoM9tMisq+5ZEV+pr1UCp33?=
 =?us-ascii?Q?KA1S6b+oEY1a2qNTLV+qofNpjJbTS2Yi0JQhacWndOuCAXilKwaEZk5hUMnO?=
 =?us-ascii?Q?iZc6DQ90nc+Jg4COAuxF5tyZONJ8CuKime9y7FVBOw+dpHiRXWVrM8O4IQHc?=
 =?us-ascii?Q?i4oort4jcxh8ze0rc+PuUK0q1LFAC/7OgQibUjivt2RW2NtmzFoNCo411V+t?=
 =?us-ascii?Q?b18v/dUt4k3W3U7XWXnKXmJtpfsWgw3R48L5+kNgIF6wKQ6L2ChGamscA8ig?=
 =?us-ascii?Q?AcLJc4ySiBxJkX2xjrZ7LvERKxTTsfAv8B28auj61wBeZ+mBQYAVdM9Fyqs0?=
 =?us-ascii?Q?aqO7uBv9/2zpH+r7rP8/3+J9Mhzi4O3AmrzDJ+M90BMvYjw+bzYpsf20fwSo?=
 =?us-ascii?Q?9jBpo42BxBFqpYsvepxi6pvaZtwkeyznvodk3/OK1eOI0TWX15V2634YaVlP?=
 =?us-ascii?Q?5BICwp9Rg/BhA4C6CCdsF+x2F3qdaq75brI0WWKOSKiqlkbYJQ9LXWOCsKLc?=
 =?us-ascii?Q?MP1zEwOARPsRYpUBO764oq1bcYlbswnTPBG/vSnfkx/Ddkf6Kh75SqRZQpWp?=
 =?us-ascii?Q?3Mlh7kaBp6/FyKDxYth9yPHxsN2r1CgVvGv8zT70NEGndKhOuwgOxKpZUjDO?=
 =?us-ascii?Q?tR3j5+KyRSd8hTezekwGiKPclihvL0glfx0aEBk1MUp5EbDa2Vq/86CC4c+r?=
 =?us-ascii?Q?zRKkO8ydyKSt8C/YLv54zCex8uD4MUR5zwZszo5m1dYElpbeswM8OnFzsaPF?=
 =?us-ascii?Q?megDcymAVtQh8M3FIhNEkqtcIb/L77WeOcJpsA5xGWqym2yJURRuzCe177YF?=
 =?us-ascii?Q?9MRdPR6yz3fEJT2WXNBBIib/U8KFWyFNsSREqU105jg02gfncVi8/j/GsDxc?=
 =?us-ascii?Q?lG17Hx2lhK5AELHIfqyckosu6YTl8trMlKaI9Qn+v3WFqZ1WoGqxXfPvi0LB?=
 =?us-ascii?Q?GA8xS6j/vI9HdDar2GYvAjqnj829THOfTn2ZIEqEAtDzG6ZU7/+Gq2jV0QRD?=
 =?us-ascii?Q?d1UFFzPhURZDcNWfqMulFw7k4mt7ZqI1ZkTSt0br08uRtWNtax22Hwmc5tzo?=
 =?us-ascii?Q?JpNrGrDlq2dZ1eGYXH+CPkp6n6n/RXhDSH58c+6uiIDYOAWp+vmvnXxptLPx?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7e1536-e2d4-4dc9-8cf0-08da9c823f1f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:24.6310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j7rJKbDOSHpguN9OeijDCVPMU0pgtvxLsaIVH7WdyRcLfO97wdxuAN0NTxNVMYbc+RDaikAWaVQDcD7zhnxWQ6sEOrrJ27f+zpOJP6XGXNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6243
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-GUID: Q36pCjS2sZeAhLyq74wYHVz45xtttYhw
X-Proofpoint-ORIG-GUID: Q36pCjS2sZeAhLyq74wYHVz45xtttYhw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has hp_sw_tur have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 07f3129abe4e..e4f9d1dc6efb 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -46,9 +46,6 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 	int ret = SCSI_DH_IO;
 
 	switch (sshdr->sense_key) {
-	case UNIT_ATTENTION:
-		ret = SCSI_DH_IMM_RETRY;
-		break;
 	case NOT_READY:
 		if (sshdr->asc == 0x04 && sshdr->ascq == 2) {
 			/*
@@ -85,11 +82,20 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	int ret = SCSI_DH_OK, res;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 			   HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL,
-			   NULL);
+			   failures);
 	if (res) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
@@ -103,8 +109,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
 	}
-	if (ret == SCSI_DH_IMM_RETRY)
-		goto retry;
 
 	return ret;
 }
-- 
2.25.1

