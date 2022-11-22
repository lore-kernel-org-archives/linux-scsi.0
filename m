Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F420AC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbiKVD0p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiKVD0d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:26:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A269E24091;
        Mon, 21 Nov 2022 19:26:32 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM2LVlO003208;
        Tue, 22 Nov 2022 03:26:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=v0bSNlUQOb7KbDVCCxR9LPYum1cei0IMdrbD5CfPI4w=;
 b=0DU+kQLZAZKiZPH8UJJLY4eDxE29r6B+o85mpXR/pACdj6kD7n87V24bDzb8b6VXHZHU
 6X2abUQZaJq4GN+vPLdf0ZzcJlL07RjgTRsO8UBNSj1xxcNRgUZdkpTy9xe3NYlaFnFG
 W7xYN3PPgxy9GaLEbAZNH/FEKl+AJk703nk1Q9dInT+o+/QaNCXITn7r6ggInDphbQ9Y
 rMX7HJcpK8XMTwJWGC7M/hiFA1Ew66t9eCG3suAq7rHrIvGxTygnivXXThcFJsmNtYpT
 DzRvr5+upKmQZAZUm2xAAGsS9JhvHubXN5AofXpp6PjD/ssmMhYht3aPPzhsxQ/sL367 SA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0gas0wyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:26:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM1Mnjm028985;
        Tue, 22 Nov 2022 03:26:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkag7mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:26:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOUJdNUKUYz4KDO+kTHOPi03+RyeNAqP8Ebs2Y6f8QUSxcynr3AM6cQkToWTN9PhKEvova1W/0roAXPIAVRZtxKdS/3TSCqPl2wNgrFP8XCI4VLBiE0o2zm2EKfaWiPTswaL+dk98AZkz/+quvT6u5/YU3/wMUN+O5ZevkIEKwIhIWynBXlhqvWY8GW/M2ZwrG6eFQ68Ntyp03/9ytJaHrRFuYs0O+KljRJhhuMi8EUaaMitV49XCPqERYWr5qdczMh9sUr6ptXsg5GVTwIUJMY2hu14G7+2P+pXs0wT12Xc+G5zZRPlKzvFKlBt1sJnKDo4qG8phYI37LfAsJpxzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0bSNlUQOb7KbDVCCxR9LPYum1cei0IMdrbD5CfPI4w=;
 b=O1Q2zjyboQT2UqezaoPIZB27C/c8oQhSEjmYCUr+bNREEWjx/yekQCztJhKvUOcQa52OTk/+xoYPxxZtmVvVEnpnXCmQFaZDR63LTvAeL2n7MyiY7J5un9DmScSOLP9MHqYQEVsd5B+h1YR9uRKvrh2iAM1Gyp3J6alj7Z6kztYxPg/Y3zu7PiwMx1EYbrxfgMeDnmftMxnZ+2IKUAhi63IckB0+6eIuG6uB0bmPXz2AMgLGxF7m8m0ZeQwQ2xu04GPdCL9UPrZF72Azfps4opPG5acrk5ONiqV5RkVf4GuFMvMlSq1RetHH+MzxTYKDsCqMCugYP+SZLu1SQtbbeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0bSNlUQOb7KbDVCCxR9LPYum1cei0IMdrbD5CfPI4w=;
 b=ciGLfgxyzxivaV8jX7M5uqmskhpxGHcDFwhkr86Ldv+6C86L1/Fh9N9LfstAE2zCI8twA2NBuEi68jpf5PtH20DHhnxnUkhqjqE6eBPCHXTKpthSWUSGONmoAweg9eteOUCaykmw+aNGWqhsHjDNJJ7ZgeDQ0Nmi0cc79bz1L2s=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6130.namprd10.prod.outlook.com (2603:10b6:510:1f6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:26:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:26:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     chaitanyak@nvidia.com, kbusch@kernel.org, axboe@fb.com, hch@lst.de,
        sagi@grimberg.me, martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v3 4/4] nvme: Convert NVMe errors to PR errors
Date:   Mon, 21 Nov 2022 21:26:03 -0600
Message-Id: <20221122032603.32766-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122032603.32766-1-michael.christie@oracle.com>
References: <20221122032603.32766-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:610:b2::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6130:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e7cda1c-c8de-401e-f1bf-08dacc394df1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 05F9UfaXF4C54+gVNzhC9iwfB/qH6GY+wtnB2GmlMS8w0Xfk9b5bqYIi3MBC9UZSuz1gV0o/aSPFp2L9q0wtO5qPrBrW4z1Lc0/QOIuF/BpgfZbVcCGiO3dq1PI7kHBvvrpjJeqWZBZ3Am3jfbBX0XQw+YKvI5K/FYmOP37R+GDsmfeWtoOiM3YcSmMdfNxn/rc3KDzklsC1vkMo84IdwVy02ccN4xwtMl08A+vukvlthy/lQ5jqP499a3nLiiTHe6MH6qXkOUq2VwV+49gLVMMeuKalfYIP9oaNgQE23Tt+tSK/FmxV85mvKUiKXkfJS+oKdAVbLdFtbneE23UiXP1pAi/DUgH/T9eK52FIjNiqmbvmb3zfaDONDHty5ySu3goTXg3XUE8+rkhfHg+AhaygdgVn6XRdobktIkyv5ZAwJsBEGnh3rca6t0l2RGoUq2pz61ZgPR3FmEUWwxQ1G+TH9gfGLwPgTn+1Mlig94A2fCfriI89z/oO/m9FBvli7+4lwNuyBGryVTxG3mQ/lzrMRkQ1JSxIYc4wGAz8bVYIsZxLri6V3kPSZgdBh4sX9Yufig3Zwpye4Tsxkh6BGfrZNyM3QI78Qwxxj5V7LCHN20MgsuzHutiYJxiIPk7mz3VDpe630zD3RY/cH843wcYPWObplBBkSOSNrrhIq/GzwRLtn2Gv3Oh+VP8LvXTR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199015)(4326008)(8676002)(36756003)(83380400001)(54906003)(86362001)(66556008)(66946007)(316002)(66476007)(26005)(478600001)(6486002)(6512007)(6506007)(6666004)(1076003)(186003)(2616005)(2906002)(38100700002)(41300700001)(5660300002)(7416002)(921005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nDkrMiXeEKG9U6Wrtuzl4JsGvSGiOeoDhX/gbK8+ZaAjnaBFu9s2+oHfJPBN?=
 =?us-ascii?Q?rOvpJHs28UoqeC4h7eRtVUTzcMQAEb7A3np+4O1U/aWmmzSr4ldBQkKAQQn0?=
 =?us-ascii?Q?65wSGegqOF4z7Wf0FW7TsipndWG8AXaub8wd4W/MRc6WmhhR9zRBlhYe0iMb?=
 =?us-ascii?Q?6yw33Q41SDTWqBrvfv5JKPnCXfndSQGZklAHs8Rz7fqblTHFHrMXYcha8OSb?=
 =?us-ascii?Q?D75LgE+MFZTLTES697Ly/g/8J6YsKmeuqd4VtKD3bt+iyOmQQKrCdVDgQ3ya?=
 =?us-ascii?Q?OvyrBMcYAQ5Vq1b8V/8WUXZ+IEP25X/Neoays+gLxw37SE2pjxX5A5hAKYjE?=
 =?us-ascii?Q?2/9/pk7DeBE6h1lt6SWKlabccP4E7uzthq+/jN+k9v66eQJRPQ+hK/8FTIrx?=
 =?us-ascii?Q?qHFqse56omcgUwS0a58D7zz98lbgs01uvkTxqZevCGXYKcb8NhO0y14Y4v4P?=
 =?us-ascii?Q?pIH8XhUYwM8DRg0MQZM47PU8QvEHAkBWjBglkYX4LrV0BAjMnPUr80GXvKJP?=
 =?us-ascii?Q?zJZcdSOZjQDH2Lxy0uQdbgj3dbIrkvG7ncJDSVC0XMWLUhXgMpBiB7YUcO5C?=
 =?us-ascii?Q?Hi/uDSAofdCcUxpqwa1TcKNHT2Ws5PdTehxhxQd400V/ch5vflj8DxKvQuox?=
 =?us-ascii?Q?bbxDRcWS7PPWTGqqG2Xfmdp6yYLXZsytHwCB0jkSsmlksblKP/yCfugcfklw?=
 =?us-ascii?Q?KwL33/Kw8mWqTVFfcGfAr8tF8zLhDz4Mgc8BywPEQazOLAlUnIqLywmSaolp?=
 =?us-ascii?Q?jK1TPk89btbWkAC2m/vc/GB23WeIa4yzssEYczhLOElnHDRBrol6v0pXoNKL?=
 =?us-ascii?Q?aIESZrWZAxSLSPlWw6W1TF1hVeBoScCwtRvi7Xm2TNyc1ibVBiXpHq4oUBrm?=
 =?us-ascii?Q?CnesArvShrlrOoOLT//Sqae3YLf1uTY8M1DJ09NG8BjZcJeInZx975GxzfI4?=
 =?us-ascii?Q?11Kdj5t+lEFy9RMINz4UgbuXasK9f+vX5dTT+KRcGbMhsl5qOYLWRTiA6V05?=
 =?us-ascii?Q?Py69esCLmqFPS+4TDi6JkT6bJe74QEwDTR7L+mW7DWlYRFKoi0wnohMCNvto?=
 =?us-ascii?Q?ARJ/MiCEhyR+KxZ1pSknZM0Pvp+nDWvDDNJ0VOU4HTJHm3DO2A+00R0tWnjf?=
 =?us-ascii?Q?Giw7U7m9+yniZWtr6KkZyMbXenF/8ppGKLeFRtoat0KUFvM6Wyh7/1ZqnZjX?=
 =?us-ascii?Q?CEKTIrORf7cOImm/IyYR8JJgSyfDCRdPlb2f/1l/0ctKufpdhbaJUcLVaujk?=
 =?us-ascii?Q?zbIIGtQavn8zT3y/NQtDYMpzCPsGpyUcf1HkQtR80SXnFOaHz4bQlAs+4Bqv?=
 =?us-ascii?Q?JH4puy4WcOPs55DTIfOeFbw0/u2RQO1l99d9qtH6s4bfPv7PwOKbxdI1wE0S?=
 =?us-ascii?Q?Jvyu4KXp1roeuQN4MjepUMk5ldh6LU1kyhtdsuQZf3cSkXrZBH4E0ly8xNz9?=
 =?us-ascii?Q?+Fn9YhXAVcYIKm1ARL62sO412FdEXCbAdXvDBua4Bhif8uBhj0XReU5hYiAd?=
 =?us-ascii?Q?NOGDP6QMD/k5qLjBPVxJM2Z80HTgsafQWpR9ZUcRV31qhOprOLOm246XErub?=
 =?us-ascii?Q?HlcQxcTYI5bdrPxD1eFYH9Qauwio7BawYN7h0WDG0Q5xv53SeFyYuv67asL3?=
 =?us-ascii?Q?uQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?XjZ2eQr8c98e+2iriX6Z5RFio4Of5I4YKU4fn2wZWkfhYrr78SVald3izzkL?=
 =?us-ascii?Q?d3VpnJX+pCTMtwQFuN+5cGTodoRGkm3psLGVCG+eVNG5QvgNhNrlWqaDEaxq?=
 =?us-ascii?Q?MlVBOD4AqeKVh6BwaFVskLOBERHl5YG65yjqT4L4DxfdE3pHYlb9WUxny9Gy?=
 =?us-ascii?Q?OabYeLZr8QP41r4GImijnM0owajbNypHcZ3LHXPyEBRujRLlVqHSojcEoEWp?=
 =?us-ascii?Q?mZITcBNP8mGY4S9kZDw97Pjr0LXmXHUYUTKpEGSqnp+opOecmXQtejv/nn91?=
 =?us-ascii?Q?5/vv/1zKzqp1mT0O/kJglOb1SgHLAR5AA+IROvWGf9iGdVxgoqJhGtaKa8+A?=
 =?us-ascii?Q?FsSvtNZqRJLK4WIQhlpzMUl9UQC5bDdkwt20/KWLrJNhI0QmA5DIrSmbuvT4?=
 =?us-ascii?Q?0f2tkV5d/PIZgIO0uVUMIvcg2lfCbrnqz4eIZ7LPStxHbC4Swbex4tBCF2XP?=
 =?us-ascii?Q?xfxAusb59QLK90AmrqYfFNJ61TKFHjRW1uIDfCdxFeQ+HCx8xkHFK1Mm+d0w?=
 =?us-ascii?Q?bgBjl+YnMYhG/vlZ2y6TCKGBcgatl5mO3gba9eHpwcER3VxB42J3E/52maZJ?=
 =?us-ascii?Q?RpycgYtDCNoULNUd/CnFtIOntZUwE8FIWSSMz9EAzfpZWSMi6w4y3pnNJp59?=
 =?us-ascii?Q?B4Gs6jV2y3kyuy0Nnj6fIVjNacDZPzoUQZdpDH++F41c+k0qMuaZJCX/g7oJ?=
 =?us-ascii?Q?Cofk9u7KnWG0G9KPgdNVuJ7WuukBRvLAFx+z3pQ0UBzevBSxB7d+5nJCaFqA?=
 =?us-ascii?Q?/+siG5yQgY2yTLbID9IQ//Qr8jX99QCZOeZZjIf0E5uZGD293a/S9u6wcfjR?=
 =?us-ascii?Q?HbT++X90YoU3DIftKc8qoaX9nq8igJ5yys7LO9C+bfZCmwG6dX0BM5wlO4I4?=
 =?us-ascii?Q?3BpQhSYvQvVgTMC/6j+sbH+3ITEQBu/GEXvp714OLr5S5iIdlY/9zqn/r6E1?=
 =?us-ascii?Q?ckBPcdOyrAutf6OMOp+Alh5WUFpQ/uMtNZl+/df2qrudsshUe2LhjkGwnWF2?=
 =?us-ascii?Q?KHkWWvzAjj8P3UDYvBfTA/w15h63hp8E42OlseHiCjw8/N8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e7cda1c-c8de-401e-f1bf-08dacc394df1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:26:12.0344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7NJWdEZidocBy6/gLIxPDGF7pwrKaQ5aR2x9z68J8h16LcuV+Fpqj5BRj+FXxS3iMMFO1d5a1N4j4fVKjiN/spi1xzhR3keUsUXKHfFk6w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220022
X-Proofpoint-GUID: Fz05X6wdUQCWOxwGcujIrEHst823uu-p
X-Proofpoint-ORIG-GUID: Fz05X6wdUQCWOxwGcujIrEHst823uu-p
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This converts the NVMe errors we commonly see during PR handling to PR_STS
errors or -Exyz errors. pr_ops callers can then handle scsi and nvme errors
without knowing the device types.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index da55ce45ac70..6cd66f6d5e9b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2103,11 +2103,34 @@ static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
 	return nvme_submit_sync_cmd(ns->queue, c, data, 16);
 }
 
+static int nvme_sc_to_pr_err(int nvme_sc)
+{
+	if (nvme_is_path_error(nvme_sc))
+		return PR_STS_PATH_FAILED;
+
+	switch (nvme_sc) {
+	case NVME_SC_SUCCESS:
+		return PR_STS_SUCCESS;
+	case NVME_SC_RESERVATION_CONFLICT:
+		return PR_STS_RESERVATION_CONFLICT;
+	case NVME_SC_ONCS_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	case NVME_SC_BAD_ATTRIBUTES:
+	case NVME_SC_INVALID_OPCODE:
+	case NVME_SC_INVALID_FIELD:
+	case NVME_SC_INVALID_NS:
+		return -EINVAL;
+	default:
+		return PR_STS_IOERR;
+	}
+}
+
 static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 				u64 key, u64 sa_key, u8 op)
 {
 	struct nvme_command c = { };
 	u8 data[16] = { 0, };
+	int ret;
 
 	put_unaligned_le64(key, &data[0]);
 	put_unaligned_le64(sa_key, &data[8]);
@@ -2117,8 +2140,14 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 
 	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
 	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		return nvme_send_ns_head_pr_command(bdev, &c, data);
-	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c, data);
+		ret = nvme_send_ns_head_pr_command(bdev, &c, data);
+	else
+		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
+					      data);
+	if (ret < 0)
+		return ret;
+
+	return nvme_sc_to_pr_err(ret);
 }
 
 static int nvme_pr_register(struct block_device *bdev, u64 old,
-- 
2.25.1

