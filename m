Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB583E936E7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbjJDVAg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbjJDVAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:00:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D7CB8
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:00:29 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FIvas014490;
        Wed, 4 Oct 2023 21:00:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=HlDNIK81sJTU0CUuzmD7d6L96l01EMkXBd92haI/Y6Y=;
 b=KRKbHQpFQoHTqTeKF10xH81k6a2b9+0npMrPgn42uQGklsNoS+Ry27zfmsS7mEQmhSnu
 15x81AH9TVZoUrhEMzdJ0PjgFCZc27xj4WFcs1DgzcPyPTuWdAtsRSal/aCbtAWjf8i5
 tXFq+MxL0uceutSqh63CFs1+Ph6wSNVDikAdeN3utD0SA8GaM07RLpASlxS4IXKPUL9U
 Go9lnVAlV3vyR8pL5aaKSyVFB82Ot5dm1JjcrOW7UTkOYKRDyQRu/EvzeuvIyYYaiiu1
 sq79nybcjeTdZNrenE7VqQoE1cC8jslo2bzUALUKZ6d1OAeFyTn0yns8eK6Vkw5Ok6Xv 7Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea9283kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394JYJA2003023;
        Wed, 4 Oct 2023 21:00:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4853sd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVL4o/tSiQ9bjCKzPL0W5J1GK9TC0CIlLFOMp/UFRDl2gffDIMBLxcYl2JueaOsOKJ/Uqn4/z98uvJMniCKhy/yTEGmzQR6Gmd9kIcAKHtjkcnEK/pz9ZSnffHBAlkotJdVg9OCRyM/+2+YpQQ6Vzht/8Oh4zjZDTK6mBQDHyYE14UmA8oke7e6Czjy//xn6sq1+UTHDy8fIqqCS6bjlKT8v3KB2AM6oqqnwusT6JFf4xV2TRPaT5eCCTtn6hqaSsXHjgpTD0CLvR93cAdXlPM8EG7Q28wWPZPEmPOdr0zw/Cf+T1TPqahGrlI1q9cTS17ZnrWKjyeh65Z5YVw7jeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HlDNIK81sJTU0CUuzmD7d6L96l01EMkXBd92haI/Y6Y=;
 b=Kgf7Qw6JsGIfFfYk2/58NN62ZQqRE/LRxa6x9AqPOgeDxaNoxTFE+PHBNJzJDMGC9J6aHPEkfuhDMBCjGLYzvLQl0wexnOTg8/GFW7rLW5bAaqE53V/azkeMvIwk+8KoNJ5G4dpc28+gpzhqoxHAFP3AWzQLIBkRTdTUZJAz/s6nKwQEAIWaNIyGHEZ7aAr3JKXkI6pTLiJe1dgiUsqwOBjTzUBhyVnQL6gKO3A+Ys1TuUDWBRxsh/aikPcq6XGMdaUV++th2khHEbN0soQc+VjKNJo21Dwf1KxjlPgScWmTaJvs8Q2tvsqLWcckaPFcChuyXn2Kx2osuPQi27dkrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HlDNIK81sJTU0CUuzmD7d6L96l01EMkXBd92haI/Y6Y=;
 b=ShixH0w8ASCgDDNFIKIsAiJ+es8a0YP45oowWUEfaC3wc2e7NS0wbLY1PxpmPV8xM3kONhxuqk/OdWKOxFPTtZ/p//v8OKrkCSJiehqM9INzHwV34L8FKM8KMzNGeiWeOkxu8sJbK2WjyP/u4dT9w7YGPIxzifNLO0NRHKhfjUk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7413.namprd10.prod.outlook.com (2603:10b6:610:154::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Wed, 4 Oct
 2023 21:00:18 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 21:00:18 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 01/12] scsi: sd: Fix sshdr use in read_capacity_16
Date:   Wed,  4 Oct 2023 16:00:02 -0500
Message-Id: <20231004210013.5601-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0166.namprd02.prod.outlook.com
 (2603:10b6:5:332::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: 22a4d5e4-17a7-4100-9c59-08dbc51cea45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jxdNjSvcxE8+eAbsWtcK+3sfF9Abve2ULoijMFVbvnMDTElP2XSYw2ANaD5YbaBZpBjYBQQsy35T3hYYv+eg3Ov9gg7QAaWNuesARHZEvhLSnKhJvNOhjsoosJTJ6bZlreb1aAirDf2OQiLiEHgrjnqTUwtb4q4TwHMAX/hXjoQYvM4hc6TxyQoMWopuaBkXLkb5lFohHBSDZ5XfbyU85fTKKX4YpwGaggpoBWTgAoxU+uXe79c7RPL3N6hYSXcbCQS4rpS3LHR2nZT+bf8ZJSp7T2CvIXeF95LAXiNUXbahoOpvwYLputMODNubV7Og9hJ2avzkHSdvdD4SWP6hjeudE7U7Caicb+4761mny5etEA0lBPhAM7FUZHfRauvPos/KJiKARNnGLfvWxc/FFkT9YdpNHPo4gUt3lAICCpcnFy3lgbSnYSCYZdUEaX/a25yi8+pEtGLUzcCV3DEuJghRnf3XZO3liRManLESgBA+1V1a7ZmusdybBBSrrsCsHBIch4eAA0SnzIV/+qu5RU2erHFJlYM5UvJ5vFnoBso=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(39860400002)(346002)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(6666004)(83380400001)(6486002)(6506007)(38100700002)(6512007)(2616005)(26005)(107886003)(1076003)(478600001)(86362001)(66476007)(316002)(66556008)(2906002)(66946007)(41300700001)(5660300002)(8936002)(36756003)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yAXGlCXH+TEQvXpuT7CCKhisWK2uC0VL6hTUnUJPiXyp7sji/SgOXPXxZrK0?=
 =?us-ascii?Q?6B2ijbilViggrAOTfRAyZx9otqx1XcKqb5D6krEt92KuIPm24wgb2fYU5jpN?=
 =?us-ascii?Q?xmEepOVtyTZb/dHPhbh0GvtJwglrsaIOiYeKUvVdErbMrppjcmt4BDufl5FG?=
 =?us-ascii?Q?LWhWLOrmHSF3wAyNNGK1qhdnM1zHX19pgB5iIgGiOHSsQQMURaG3YCX7rsZ+?=
 =?us-ascii?Q?d6jPdhMCDdC2NGZnQkAXzP7LYaxAIlrMAW8fde9b/FKZgFmN3CVlFCWAUGOJ?=
 =?us-ascii?Q?Kl2WfkRlq3SKThfAdVoSV4SX/sJT6w8s/hX0QtNTtxS6CYBEXbTdetylEmNN?=
 =?us-ascii?Q?TEpFyPDlX12chVkOglyc+7KHX1qLxYVgzqarSAXLgzqMdD225Tx8D7xyvOxn?=
 =?us-ascii?Q?hsLZctg9gnGWBKv9XyUAiI7gEwYsq717jjOSo68ZaygCj4BjVX3iKpqwHMZV?=
 =?us-ascii?Q?hgqTMEucvJQZUNOw5cWjRAA4688R44JMg9qBEb4/mbpC4rRtl8VGLpfCWSFW?=
 =?us-ascii?Q?xIgIZgdlKvBPCS5ZYpVVG3e/hBezwoEL8lGSF/U71gJMqoZTif75MPDnf3qz?=
 =?us-ascii?Q?Zv11G3PFOhZxCgietponuCRpDwsyRI2tQI2rMGn1x67IEelIW52K7jKlJ/E1?=
 =?us-ascii?Q?mTeDUUlBAGopC+0Mv7vcWa9aDWoBtfjybbLKCnZqybGpnJ7S+I64IGCKNzSf?=
 =?us-ascii?Q?vtj5ODaZoYIUSgRnr/J5VSahZpdcFkmtpguTfI50bZmSq0KjpWBeH3iO5CbY?=
 =?us-ascii?Q?L8jH5ro7kiOUjIsdmycLu8yGDK0F6V4racZZrUzIkwyp9dlOX1KQYskd8I0w?=
 =?us-ascii?Q?lOjyy0K4f3jBWytkFG0yL09FL//lXvNwFAB5m7Teykpu5eAC4nChSXtU1Ft4?=
 =?us-ascii?Q?vJgxU1WSawiBq9n5P02tTU/KpisodqZAMrpf9V0KJA1CuPP6hbdAsTGX0IOK?=
 =?us-ascii?Q?2VqG8qvMM3ebNIXh5VyOeSgs8hKGBf/TeqF7UsUjIkOGzQAPUxtkcH5DcXqW?=
 =?us-ascii?Q?VGyzMKO4ISPrJu53Up1/jhpEi9onp8AMid4AAHxsnyun34n3TcnyjbPKwbKU?=
 =?us-ascii?Q?sRwHYZuOZP9KgZ8RdG6pLRkhhn8tKjouSZqUpbFhAWVIfZrhdspvcSm+ypx+?=
 =?us-ascii?Q?HS0zN2wmnAfT0dUDEpEHEQf8Fut+RPk3l3SzNc77WdHvZhdY9yDjZY1oLxN3?=
 =?us-ascii?Q?9qNBREW/hxWFOjdAjQtpWJtHZExv+Que5j056IXbxZ3A1bRyXNEjrWsx9Q6Z?=
 =?us-ascii?Q?Pz2MfHvsLj2DEWknitBASsIiGyPlP2a5v4rT/lwuhyL90rLwqXcEQhVSQsi+?=
 =?us-ascii?Q?xHeHV+4UyLuV3nC13UTJaBJCMEuhfDkZTJS1Z7VCHkPXmqNBaCWmhbqalkIZ?=
 =?us-ascii?Q?CFyhkd/H0xVTwlJHD4KK03DqhJpd5rtAuvaSsgDGa8nibv3GhKjq2rOZ8PaG?=
 =?us-ascii?Q?YQyAjJD49HLcjrMkFJk3oIAlHIAJ50WaXnblGXp4qGy3fMnBkmB3pEKPvOTO?=
 =?us-ascii?Q?U+ltmtZkWLbG0nagx84YGdD6p5esa3ahOvO5yWQoSCzCSXV+9fJmvQijpkMJ?=
 =?us-ascii?Q?HGk9e+SmJRxa2Fu4ge/4yf1vixvbXH4Dthyxr0GBDwfYmTQqSS4VU4wkBHFH?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /9r12K8e/srtCDZRMDiaQ+dC6s/m7h3aGWSN+INZ/0eCzFxwLd41rb8doaHsWqhZfgE0qSNXWJtSi9xA2Jcr6b3uRj8DxIpuO/y/1QwAFFUb+iTSEa8AJMeAJZMpbiwGtpdsa+tpuqu7Skgx2bkoB7HJsXAtkINco09K4o+zStT1RMC9QUEFrpjSZ53HJi3GRhD7Fu7rQd6Q0tQdPHl/xubRsC0rDTpU3fNAkmdMWoNCaVAbTN5ZQpVrgsAPWXeSPNVeRhCyy6W07+j4kJHAQ9VKweVseYKbz0BzilTQDZI02BHiHOUS3VO8kVMwt2W81EFX0s7gLPUgNpp/l+lsl3YUqIozry6wsnyGHLC8Z4sXIJxkrfIAn9Hbeve6COAG6e3f2lQqGoqws6w/vNV234xuVsg4k4/KJkSdf9UE9/xIUETvtZNhJa+36Of9YinZOW4A4y2SjsmVrLhEV7sMtj6aE2USefBkfKocuJLTOwFvuMkKPL+zGoQ88KqqPMD+NnC4KqWQXIpj7LadO3auHC8jQbwRI4sM0ajHh2FARyI9nvG7fmHEjfwM5Kv/w+/6v00c/nsbs98C+C8QzrGlxVy8hWzurSk6g6tQFDNvaVyrHZr30xWhbk0HwKMOdNjX06O44cp9kdR81Nmp5MPX5XoYadcXn26JgAry1jYgBeaY7gRdYmViZkgibqMaW8Rq4PfnKHCHbzP5UDaYO9qVx5RbZHUegSuzgQU+ynhkA1rAenh7IQ+/N4YrEPJ+fnJrswV63lZKU2PdhFrGUczsssYm5brEF9nPHDlPWJXC+nIsPML5hTOjd8IfX5ATS46XH02CLJ7Ql+iWrhCfdlM0t6srqcUnPPk8MGVH69QyX3eBYda+2iVANLAaAy6QwDNm
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22a4d5e4-17a7-4100-9c59-08dbc51cea45
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 21:00:18.4211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZ4B5Q0pIjfs5uWTVopy1x2hHkFJuabcAT5P/mUuiEkShuEVB9cPsgJxEf05ikexDsk4dhWP72jl46yCUr6DEbmgiEs75GMb0lrzfLuCvi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7413
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040155
X-Proofpoint-GUID: qUD4GTgb0Hl9a6gLgavHE9ej2PTb_rGF
X-Proofpoint-ORIG-GUID: qUD4GTgb0Hl9a6gLgavHE9ej2PTb_rGF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 83b6a3f3863b..0754949c9f55 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2435,11 +2435,10 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
 					      buffer, RC16_LEN, SD_TIMEOUT,
 					      sdkp->max_retries, &exec_args);
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
-
 		if (the_result > 0) {
+			if (media_not_present(sdkp, &sshdr))
+				return -ENODEV;
+
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == ILLEGAL_REQUEST &&
-- 
2.34.1

