Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5DC5C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiKVDnX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKVDnH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:43:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EC22873D
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:43:05 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM2aZKR032413;
        Tue, 22 Nov 2022 03:40:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=rJg1z58ievsiinjbVXviLJHVBoa0DK9vJdxMe152pXg=;
 b=qBg1ZZHTKYtEt209cpHs20Ycov9hSo8FmAWoDKgBJnHxHhpqtVdHalIy84fzTcS/sVVq
 F6oppjHXT09IKxCopQPG39gW3huT9mMOoCw+HNTw61Ab2tSt/sr/BSCHEovQxaBSxIkS
 C77pe9zGbt5CqxVia6w8rzHzYb+5NfdFvf0cd40oXFV7V9ma1c7TCk7p34jAwsECURRH
 aQcrtUIDIPZ2IjGwpaIkZ81yb1o2iHevKqoAvvAGxsNkt5jW+jSGUVtncJWqwRRl44mt
 97n7iXeEUegBHyCCJfJ3ay4CW7CheduPHhzKxVHc5QzeJGjNmjT/8PEHaCr61AOVqqAN vA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0gas0xys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM30hLn002244;
        Tue, 22 Nov 2022 03:40:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkbgdu6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZDBXPg7BM1nfqixE3WJ1gPiaxoAXxM8D8RA65is7uCgDiUn+yCrLeapQ+6ExNWej3Mrgcfa5fH5dy4hrSU7fPRncMwdYeZb00YxCJYeIB6Q8uhU/UrL6UpTVRxghIX9j2SJ3rucn+0f7im/phRlyfC/3eC8hp62CJZFIf889a2Nx5AdFehoKa5gvVVGlB4aCS8CD3ay9y2HudLcWFNSy/5QXP17BuE0lARq7I2KcXG2xmJWFKMdGkea7KxP9bP5Kh7UdgctCYQrrPp094S7E4HmedUCdTxj5d8P314Ww99e/uuOjdHEdqW/4xdk+PlcC2yRLgu7U9lJiDMBD3j+Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJg1z58ievsiinjbVXviLJHVBoa0DK9vJdxMe152pXg=;
 b=XCaDwWGWhpeBSLHWi0JJvt+JDO2Z/Z34DElnDSIiyYPf817Bi0RaR7gvec9zK1lO+FV1HhKdGPHmtlPqReI6Yc6unHBRZUGZukTLl2FFK9m8h0QxB26VZUZHNcoS2Nzchc36HCixARJjBhkODFxcxI8tuItEENPSkv4VjrEu42jvHSQFkNqpH3R0CDur4xABlobYdok0JeN89z8CLahq7b/GQ+J0UrzroUNF34tY0oYIjhmMx4uRLEeUvUDAJC8cFJb89Uihl4LExHz836Q2kDPtcrgDMzl6UFHOL2o1Dw3gIX1vJKEx8jXAIcJd8RdzPDmun1SVuDLEtFI3VKWzxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJg1z58ievsiinjbVXviLJHVBoa0DK9vJdxMe152pXg=;
 b=zjt+f7tFNXv9EB3tA3ipkCSAsO/T8CI1XVtvJrgu8FRuCheQD2KJqCZ0hEKaTFZztdOMRit8fcaqMXxfgnjPyDxt/yBTeZqSzzs+TkNuR2owQHJkGHotJLxrk3UF2hcFRfz7U41H1xKWpPpQO2+PTvwUuXg+EJwI6JoVCCaXMKs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB7055.namprd10.prod.outlook.com (2603:10b6:510:278::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:46 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 14/15] scsi: cxlflash: Convert to scsi_execute_cmd
Date:   Mon, 21 Nov 2022 21:39:33 -0600
Message-Id: <20221122033934.33797-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0080.namprd03.prod.outlook.com
 (2603:10b6:610:cc::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB7055:EE_
X-MS-Office365-Filtering-Correlation-Id: fe7c09e2-78a1-443c-5efd-08dacc3b56ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9B9nieUTuV7z/glK1Gy15adNZZqXeMbfdVDX1dM8Y10VnnDd3MmZgzZkHGidfPMhX2Aj+OavWmxeJvSAlar9p8TUdQUiR7ypjPHKt5z7jKfPz1Sk6ccI6YGpcsmoZUHVF83fc2tUH4dagcjNJpUSAmF9DWV1HYEzpryDVAwmdTWfeMm22nz2oya2I2UobAvzQbnZa/2ccU7XeZElUt6HbkErPe9Y/Cvq5rTh/36D0byTYKsls8DesLyVnJDp4XNOb6dMwgkmxXx5yQmvMV4lUm42hrwqfe9Dv8v1mSrHonBYcd/biqbqB5F53Aw3VlCzIQgfdp1uwpJNETY2n1Qhz8TQ7MAeBj6b/d/XphLmFhl2uF3c2J+LFJgxkAGOX7Rg39Kgq9BXSLpFoiKyw37r0S+2snqSeyqcXo+21L5W/WFUU6a059nFrxPtj2hnlvpsazi4lqzKuBoTcs3B3NNytYZzpe2gVa11M2O2AKPbLIQ5u8IvwNphAhW1TTAs9WUgTNQECEH9UpmuAm8FPIQcIz0LmhlGjBpK6+6lmhM7IcpDz1vl4sm4GAIDR1nxzWEdOmQX3LmdFiEPo/fsfr3Mzx/V98cf1uNlSli83kTzfanwLySnJpm2nHXXrFPFXOf4zuhjf2tIFytWodNkbZUz1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199015)(86362001)(5660300002)(478600001)(8936002)(2616005)(2906002)(1076003)(186003)(316002)(6666004)(4326008)(107886003)(6506007)(66946007)(66476007)(8676002)(66556008)(26005)(6512007)(38100700002)(41300700001)(36756003)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OXNHOs68ukrGjlNKH3eY0eHTAN63aoVFpbVlQjG5dur+BJI5BAvBdKIaVpB0?=
 =?us-ascii?Q?hixPW/s4YB4RyZuyiec5hqlAxoQrduHQU0lPnY5MOEPG96W3pDE4PTl2uhld?=
 =?us-ascii?Q?U3FuS2Tap76/k0eps44a3bzCuJgHoGKOpHgrTO/R2unQuVadt1OaBf2Ut0YI?=
 =?us-ascii?Q?7ehDcwfzl+ztNN3h/OO8Pheapm0Bcxfkj0mKVjktHZgpHcZ559VDFQkA2Mcg?=
 =?us-ascii?Q?Zm3QeTlY10flm9ucq9/KJVpllGfgzvdkwlKnAhVnjCdPbfp9otiMBrXuqo7R?=
 =?us-ascii?Q?8azw8JADt1+caGye6NyWS2XF8gbzK895YoOatYlbYGMRYlr//jEdNNyBFCu/?=
 =?us-ascii?Q?29UT7V/5U04awBwtcTDMI0C7dtzwdl1EP5qGwNrAYH0zmVvHWeLGqPIepsLp?=
 =?us-ascii?Q?vhUOO1yVrSMMfrfylautjXA9SZAI1nx7uiyD3DiuTOQtvze0F+y37BVdZuta?=
 =?us-ascii?Q?zgG4TUkHG0zZtrJ0LRva340BHAptSfgO/Wnr6xMi9sjR7Otmo7G7f77O4lj7?=
 =?us-ascii?Q?lig0azw8+eNRiO5CDHZcmow6Td06gs+L5PUlq8XSMbZr1Mp6+lnRMypT09kb?=
 =?us-ascii?Q?Zp4nSsRj7cTeJMPPh/NantH+VhvPe7Cq3c74yFOHmCTy0lC3OnctTtUHChX3?=
 =?us-ascii?Q?m+Pt0utQjsHIDudYKv+p2h04ONJykvsxKAYUhgGjp6oEVdpJxAGI1Vhrv3/f?=
 =?us-ascii?Q?lNFC25dCqwycd+9hSICboE1A2Xa/oUBiwdKkJ2QmFZNQTr49GXl5WRDKuJ6B?=
 =?us-ascii?Q?AIeHJQOGzKOIGp30ZkPSGBPCEV8TD+fsuXfV10Q3VF1gzDS2TxCCI4TgNL44?=
 =?us-ascii?Q?/y+l+9o7iP5UQx7N6NWG8Fpl4seBzkuwHKhFZlQyrgX3abJ/3qQhdDHcF1b/?=
 =?us-ascii?Q?l3KIrsbDYg2TSjaOUfLsylyZarBV4jkS7Z1ADXqAI7rwalgWPfqZ1DRmG0jn?=
 =?us-ascii?Q?jtYvapvMJLrPkHkdu/GDwv0M2UvdX8YL/g9zzBue17dx2UxYBPQcr7XYtBvF?=
 =?us-ascii?Q?EIC5QDJeM6JYr7Juj8FErJY9wws4fQsNQ8ttqXrdYKdMY7HAixDbx2enICqE?=
 =?us-ascii?Q?SXtoMA05y02sm7V+5ETMtMwEsUlHkqJx4AmoZZKCZ/IyYpwpjvivmgIP4xPm?=
 =?us-ascii?Q?j59g7PudXp84LBz8BvFIVqALbXj5VmKxsTjlep7dXjkg03uV+L3ixKs4oHmD?=
 =?us-ascii?Q?0vloy5Jgpe/pbVJ0wpu0qklKBCRmCLrV4OKYLlHuJFzFir0goy0nMPtR/tWb?=
 =?us-ascii?Q?/a6/9o57n+O1uK3VzjeTJCmaKG5FFzLsWGPTsLIWxvmoOglAcQW8RZBlAm4N?=
 =?us-ascii?Q?zqZ0rtQG/5ygHcmjbmOmttEnAjjPZ7uJEW0ZftYGhols/JtH03Wd75opgBgM?=
 =?us-ascii?Q?slr0rWaSfFz9zaTb2KC/9kIT9H/rEZRfcu71a4za0EdZ/7pCKk8FWXXT+y3P?=
 =?us-ascii?Q?CB3KUWlDYDNIEyX+f9fSuRNVG+vp3ngHi+uf3bvtsThxP155N+mtEwNd9blR?=
 =?us-ascii?Q?mGvSTX1xk7jah0MtdIvowLHkd2Pqrie8LgoZZrXxelhZ42a1KFVj3yU9bEuG?=
 =?us-ascii?Q?hIqpClNgJNFD925YKyipJOJuW5ERorpdsTaKJ1CWwkfd8YcSv1yvNHTljdp3?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: fUt290WJOjdKaNvfhwyDd3lpVcINkfcEoYfFf2bG1cBXqdzrKoFjnmNCH+AVkK/8V/vZvQF5o3Cmh6V8D8/Y/kY2m6jYLTa4Fa1q5dmUEQ0uEtDc4hxuOeNZPV9PpERXzxdp8etAn1yklx8z25JKoYUmXh6IP16I0HRtRQGlkXvcWRe5MWXeK/d9AoN3ZEVl/u8JMQT+Zs12n4T7+Fqwvqo75Y/ObP1WlhgZsCmH2O7og7fe1kEBD7ugz4UYei+K9HyWytzS45IJAM21KcTDithJBFRgdYoXUrIAMqunIni3YVbAyuYXH/goD9w0JuN4IW/8Ens6h59TXfDw/F6zB8C+pAsNkfHg/QVHCw46tWeYaCe9glcgPdM6t2Z2Hge7xqHrTVk8ixu3t8OASnayk4y6dl3aiHuqJQbqrvLnSwP9EGfukKz2jW3Up51KxfS9+Grw01zOoucWOUNFUOMV1uucxjKT9/zyk1fydUB3H1sfWVAUMlYnrUFu+ayiIddeRXptzrsCyQdcRDikxPxxhyt03Z7VL8NirynHJQfIMh+fLlBIDj+iCqUbUGlR3rRdfnTE+ZWlknXCNigq/X1NHCzR2QVOmOFkUC1a17uwlizYgN7Y2d+orhcy/amc1TZcKGeJsy8jhlYAsapM86z5CoEjigfaB0KaT9RpeRN9aTC6ApxFywFZxQaVEoBAyB0b9Vzs0CQhNjcElsjcqEcaHKzl/eUVtSXEH8j4EAoRuME8RTzcp48PGdpT4PRhXhgpPEApDrwxn5opypgmuyg72sWJIMGd49KCSiTouJcYCDN4k8b99W5+rMIyFi+QPriV0YNEDwbNV+knKbv5uCIjNuJdc0lKL7jaKlsWRH/0+D+oo3zlnGyXesrTwra/ijhp
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe7c09e2-78a1-443c-5efd-08dacc3b56ff
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:46.1997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PMh1qq8BtAFA6g3uydX4zeqQ230lzvID8zom+pDEUM7ALmVm8iNOYULyngCC1ZB62s5Yr28DGSfqA2wihVhN3fNXvj4czAmDCJ6sogF36wI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220024
X-Proofpoint-GUID: sV9snk88yewAO7BvHR2JUwNO4nXZVrJX
X-Proofpoint-ORIG-GUID: sV9snk88yewAO7BvHR2JUwNO4nXZVrJX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute is going to be removed. Convert cxlflash to
use scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---

Note that I updated the comments to reflect the new function being used.
Because the new function name is longer it caused me to have to adjust the
entire chunk of comments. There should be no other changes in the comments
changes.


 drivers/scsi/cxlflash/superpipe.c | 32 +++++++++++++++----------------
 drivers/scsi/cxlflash/vlun.c      | 32 +++++++++++++++----------------
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index df0ebabbf387..49f23f3517cb 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -308,19 +308,19 @@ static int afu_attach(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
  * @lli:	LUN destined for capacity request.
  *
  * The READ_CAP16 can take quite a while to complete. Should an EEH occur while
- * in scsi_execute(), the EEH handler will attempt to recover. As part of the
- * recovery, the handler drains all currently running ioctls, waiting until they
- * have completed before proceeding with a reset. As this routine is used on the
- * ioctl path, this can create a condition where the EEH handler becomes stuck,
- * infinitely waiting for this ioctl thread. To avoid this behavior, temporarily
- * unmark this thread as an ioctl thread by releasing the ioctl read semaphore.
- * This will allow the EEH handler to proceed with a recovery while this thread
- * is still running. Once the scsi_execute() returns, reacquire the ioctl read
- * semaphore and check the adapter state in case it changed while inside of
- * scsi_execute(). The state check will wait if the adapter is still being
- * recovered or return a failure if the recovery failed. In the event that the
- * adapter reset failed, simply return the failure as the ioctl would be unable
- * to continue.
+ * in scsi_execute_cmd(), the EEH handler will attempt to recover. As part of
+ * the recovery, the handler drains all currently running ioctls, waiting until
+ * they have completed before proceeding with a reset. As this routine is used
+ * on the ioctl path, this can create a condition where the EEH handler becomes
+ * stuck, infinitely waiting for this ioctl thread. To avoid this behavior,
+ * temporarily unmark this thread as an ioctl thread by releasing the ioctl
+ * read semaphore. This will allow the EEH handler to proceed with a recovery
+ * while this thread is still running. Once the scsi_execute_cmd() returns,
+ * reacquire the ioctl read semaphore and check the adapter state in case it
+ * changed while inside of scsi_execute_cmd(). The state check will wait if the
+ * adapter is still being recovered or return a failure if the recovery failed.
+ * In the event that the adapter reset failed, simply return the failure as the
+ * ioctl would be unable to continue.
  *
  * Note that the above puts a requirement on this routine to only be called on
  * an ioctl thread.
@@ -357,9 +357,9 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
-	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
-			      CMD_BUFSIZE, NULL, &sshdr, to, CMD_RETRIES,
-			      0, 0, NULL);
+	result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, cmd_buf,
+				  CMD_BUFSIZE, to, CMD_RETRIES,
+				  ((struct scsi_exec_args) { .sshdr = &sshdr }));
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 5c74dc7c2288..262763810570 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -397,19 +397,19 @@ static int init_vlun(struct llun_info *lli)
  * @nblks:	Number of logical blocks to write same.
  *
  * The SCSI WRITE_SAME16 can take quite a while to complete. Should an EEH occur
- * while in scsi_execute(), the EEH handler will attempt to recover. As part of
- * the recovery, the handler drains all currently running ioctls, waiting until
- * they have completed before proceeding with a reset. As this routine is used
- * on the ioctl path, this can create a condition where the EEH handler becomes
- * stuck, infinitely waiting for this ioctl thread. To avoid this behavior,
- * temporarily unmark this thread as an ioctl thread by releasing the ioctl read
- * semaphore. This will allow the EEH handler to proceed with a recovery while
- * this thread is still running. Once the scsi_execute() returns, reacquire the
- * ioctl read semaphore and check the adapter state in case it changed while
- * inside of scsi_execute(). The state check will wait if the adapter is still
- * being recovered or return a failure if the recovery failed. In the event that
- * the adapter reset failed, simply return the failure as the ioctl would be
- * unable to continue.
+ * while in scsi_execute_cmd(), the EEH handler will attempt to recover. As
+ * part of the recovery, the handler drains all currently running ioctls,
+ * waiting until they have completed before proceeding with a reset. As this
+ * routine is used on the ioctl path, this can create a condition where the
+ * EEH handler becomes stuck, infinitely waiting for this ioctl thread. To
+ * avoid this behavior, temporarily unmark this thread as an ioctl thread by
+ * releasing the ioctl read semaphore. This will allow the EEH handler to
+ * proceed with a recovery while this thread is still running. Once the
+ * scsi_execute_cmd() returns, reacquire the ioctl read semaphore and check the
+ * adapter state in case it changed while inside of scsi_execute_cmd(). The
+ * state check will wait if the adapter is still being recovered or return a
+ * failure if the recovery failed. In the event that the adapter reset failed,
+ * simply return the failure as the ioctl would be unable to continue.
  *
  * Note that the above puts a requirement on this routine to only be called on
  * an ioctl thread.
@@ -450,9 +450,9 @@ static int write_same16(struct scsi_device *sdev,
 
 		/* Drop the ioctl read semahpore across lengthy call */
 		up_read(&cfg->ioctl_rwsem);
-		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
-				      CMD_BUFSIZE, NULL, NULL, to,
-				      CMD_RETRIES, 0, 0, NULL);
+		result = __scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_OUT,
+					    cmd_buf, CMD_BUFSIZE, to,
+					    CMD_RETRIES, NULL);
 		down_read(&cfg->ioctl_rwsem);
 		rc = check_state(cfg);
 		if (rc) {
-- 
2.25.1

