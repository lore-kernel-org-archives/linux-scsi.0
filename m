Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A24C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiJWDIl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiJWDHR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:07:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BF768CEC
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:05 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2t8VM012741;
        Sun, 23 Oct 2022 03:04:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=GmOtgDWTQm+DIJCGDPaIxGqc++SvsLdQKZoRRmhKCZU=;
 b=o2jlOB/ToJ07Ucs1Syuz1Phooep1wHNk43t5QUKCW9r3VpMZ0ByQEQvKQvJqNxkhSo9+
 /IbyEWSgHh63OG4yzIgmTjcWAqg0KkMOcNbr0ueSKp+BDmQyfO2DZSMIl3pV3Fmdkkgf
 J4GVkfJZQCspBo7+/HWFl7MPpJfQSFTXsVKpIbd4FkDhAENmfH5v8i/BKx3ZyHIsuL8W
 PFi4btvApygiT0zG8PEZi+ZUW+WW1ZlLrVp8eOxn3CyVt7rfxTDxQqb/0qlpAVSBujlV
 OfdXWerbz8MXbHtQqdKVShs7DOM8AZOFkAckZzbQOvE4PNNetAgwnnNO3po9C8SrvvXT 8w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84ss3g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MHYQBi003674;
        Sun, 23 Oct 2022 03:04:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8rhq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UA+D4bxDA+o2pA+5/nIToG33l2KWG/tfluhjELMf9wuYQa3y9VcrQ50c8F8bP0fEfj9AzkekdJ/7dlni9OIQ6vbQG/goWapKrdrIuqi9ApOoJtNywADseFUv4wGEZbKgVt23Wj0Sc2CgzHIVBRDAjo45JVl8xHzwWO46B4HGKahbxtQ07W88tr5HI+8LSj+MtXzJtgOwztQ0hv5W9FYYENp+NW1TsZ/fJsaqix4bNweh6Jzcnfdu1wLgAd+iv7fVLo7LakIogNX/oPH96TvspDa9Wl6Sr9+Ea8HvNF4gW5WDKD9oXhCr3ypdsA59OCGyY8BikM+UYt6OaJz8M90X6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GmOtgDWTQm+DIJCGDPaIxGqc++SvsLdQKZoRRmhKCZU=;
 b=NiNQk1qnwtGuuTVlNTbtlKvxdx55vJU6TbcCXHsT00Djp0jCsQIt8oNiAVdE0EDyfK/M4TrYyQNcFq7cmuXWmGUfvAk6QjI88M00ATI2Wfy8vQaWJJWY076ftnShgoBRD/pRd8rIH7fALk2xbPL/4jsfh/XfwX2g9CUIgmyVqmiBxb2zcAsFdMGQl+FqQbEA7GKzDqDk6ytefRyrJQciFLnFpUyYFqTGr3UqwINJuNFnuuBrq70PbCTpoLnMz6OcqYZfg2J+wCw0zSU/3Kwq8ZGFJs+wavixZQmko2wZbO5Q8VzssicSxXw0WomBal4YUEmRY9iaqEwcSLuMt6wdvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmOtgDWTQm+DIJCGDPaIxGqc++SvsLdQKZoRRmhKCZU=;
 b=pTBsSouoYkUgqEzZSANJN2d7OR+/yEyxvC/2fp3EkECskavqFFynMIr1wJFzah14J6QaJ9ElQa9fdKRkVEQL43BMZsh/t/5e/+mF8/00ak7iijf071+nTFMywLeXHy8TWd2LITIOKHqvQaim1ndN/AJP1fJU7qJxTfss5c+V6/s=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:04:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 29/35] scsi: Have scsi-ml retry scsi_mode_sense errors
Date:   Sat, 22 Oct 2022 22:03:57 -0500
Message-Id: <20221023030403.33845-30-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:610:cc::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: ee471045-ca3f-4b73-dedb-08dab4a35b23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jdx5mFiKrcED3DPwt3UPSkZrd3Svk9++N5r8gOxGODXUkJ79V9npBTLRnYn9yUAzXo5Wdyeq4GAtH/Drj8RwnUPOFPm4AIbQGgKzk6ZszB4r9bL/+p1Zxy/ie5J+reIq4NLXV4DEpxTTMs1luLqholq4QtMwbEsNVU2/q4ybCUFaWTwON+/pLAmyJW3xSB73D+lv3fFIDzjoMe1vbYhnXWzkfN/l5i1Qg+I0M+Frxm7ndNvutxNnTS5dfZeTS4QUX0xBIQOcvt1s/KxGxPUcncEnz7kvlitNCVC2c39BTiAMofFxtN65p3XwCx3kNenA/brteogCSd/AbSZ1fsg7ZoGrxbYs4CLEfphTQNzhOoNv+I6BEerqtSGPZuPn1shG733qi46UxrL7cP36MBPvHOK2LyS6sF+L1OgenSJOI8IFLmrHDqkwzLvyCIgDTDxtaGPCD2uCm/+Z4wwxScQSrGqxEvIgjINEHaRxBIGkcskJ7Jc1erxx5dwnLVadAIu3rKgeAsOODqJteNYJuOW55P8CE3T8ioOAIEZZGYtEllwrVNQYPXAhTYKWwRMbN7S7y/Wr6P11t+jlTyvj8+nyOcynuTM0SMKfjEC9D/PPaQUZDYCICc8aylFiabZY4qIoK2dBoOtvPVLoHeDmEDYt1sSPIJA0cpSt4Q8+8r5AAtMair7qtC13oRcZmU428yOQXb0ufuSi81e68V31rB/RxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VBd9M5Nrt2KQ7oLzcOW8O/7F1dCb611U5mJ22TyP1swhPH9fEIzTFy+XU0tF?=
 =?us-ascii?Q?rbsIZcXBY/E6eSGLXKmlZG7G2H/UkSOAQt4zqOKbBCEOWDX/FFE5pdag0Wzl?=
 =?us-ascii?Q?TNeVYEFP2kMFVMrX3RMIYaEki3WiduCcO7u0Yf8dIwqDHP4iT/xJNlFLpvF+?=
 =?us-ascii?Q?Gt7SmR4NGlcNsLNVf1jtp798AIdRAZ36vpaRACQczxjMhdO64xIaLj3ftebu?=
 =?us-ascii?Q?3iGUmPdE0dgTy2fBrhrUEH2URVG/lgx6iodiVZJSB3ACQTIle/m1BJ0QIfah?=
 =?us-ascii?Q?lvL60nBKAvI0MFG6/CzJtwu76pHDQ9zAuWLwjH50g+5B5sFLX2JoWeKW0Oat?=
 =?us-ascii?Q?pzqG8pn9lylXoslMn42SusM7BFRTGrc5rbaVqrk/GDWyj0KGk8KxbISXSaTS?=
 =?us-ascii?Q?xCQtNDPPtCY/Ug4UjNkrg/QWLX+A59wwqXDjRYTi7ogGW/vRveWC33roT8hC?=
 =?us-ascii?Q?AUjjeyvfEezOsj94e8Px7/UAHPrzkJ2t1ad+lVYdyGe+3B3LQVp0YJhvg+Rx?=
 =?us-ascii?Q?pAH/GL/TQHwgOvhOJ1sZvCHG0Dhf2DRBvvHTtFYRnuccLRHUUMl4zXnowCwh?=
 =?us-ascii?Q?K5FiPhXNLT1pFbRgHZzG/Bu6fJUJ/UZvLdQKL5m1EzqozDO/pA87wHE13znq?=
 =?us-ascii?Q?YsclrErXv6+GAvSpx9CXt3f8C+uzLfaCE7uqiix07ooXQP8hzWYuyZA8/Vdh?=
 =?us-ascii?Q?o4X5qvKtCtTNcyCOMY2aBofcGOUJScackjlq3PBYkZkFRPLI8iUN2P3fI/eL?=
 =?us-ascii?Q?oH903MCH8hXwkgUEa5kv+oeQogfKVef7S2PB0WO+KesLm67YTQJf3/qMJi3J?=
 =?us-ascii?Q?B0Q5SKCV3GmTZis+1NaGBtS3ko/6UivfS+b9K4HgWtZ7Ddxt1VPIFxTEnpQW?=
 =?us-ascii?Q?dfVPlDh9I6NoY0/BcvitIkGEueLt/rgnS3uRk7Q1x6844yLh2CFwPWc5vOiT?=
 =?us-ascii?Q?FQ5zDLT5uWTSvA+UgPvg+1UnNu8s558mks11voGWndNtnnh3u49L8num4dA9?=
 =?us-ascii?Q?ZgEW7pmXf2454ma4WT+GTHMoEURKVNGeg+oifay4AfIJFCIq6M8+sDefDtKK?=
 =?us-ascii?Q?4sHlRk/zFCAObmsIEQ6pc53WD1JI9etCck8rj4VnnMEidGl4VY91Ar8pFvcu?=
 =?us-ascii?Q?Vtgq/prJkxrdRkMqv8jTCRytvsMBmwnbTnqmSIKhGx4GP4scCa24DHzRg3lt?=
 =?us-ascii?Q?RfYtng+zXRQd3PEwTVTMY1VvyhK/KAuAeOblFponCxnPB/EvixozuUbRWRlG?=
 =?us-ascii?Q?qxuQBdKiCdU+feOcLlKvgOirMH2IatR/8m5ks7oUIVwt6CO2Fi3lFucYkJV0?=
 =?us-ascii?Q?WnhsDgi5plr69OBvXaFjD/cDDhsO3VWU7Kgbvn3BR00i6oStB9R6Ltr2UvKD?=
 =?us-ascii?Q?qt0E/OMzZiTZneWqWVLu4YLi0XRHRcRap7/u0+ioI6rqLMu48C0swukim4Ap?=
 =?us-ascii?Q?mwQlb++3H32L07zhmGl/TKqtOaTygouet8xXn1F1jEN5EshLwuSMA+oHVjvs?=
 =?us-ascii?Q?8xYvpjkGKqY2WvZMChGG2YEuxPtUTMUewVPYh37uI1V27DwRPtDkgT+OpSPZ?=
 =?us-ascii?Q?P2br4b2MIN3t2y2pMZ1vjAJj5uPuTXO3wBOWaweLiQ8q6Yb7XltHpKZgUMJR?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee471045-ca3f-4b73-dedb-08dab4a35b23
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:52.9967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c32m9CWSMKAoNuAgy+xDx7zWDrD7trls4lePzlwh7cJXjIm5qET26HJSJKtI9AJ6hapr6MxaIWP+uZfgQ/u3z9o9ohh8lCcVVJzDKdawcWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-ORIG-GUID: G41ru4roIv-4ABu9MbdXQht8vBrn4Fmb
X-Proofpoint-GUID: G41ru4roIv-4ABu9MbdXQht8vBrn4Fmb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_mode_sense have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9b19fa939eb..f19bc3a7ef59 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2160,8 +2160,18 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result, retry_count = retries;
+	int result;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = retries,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
@@ -2203,7 +2213,8 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 					.buf_len = len,
 					.sshdr = sshdr,
 					.timeout = timeout,
-					.retries = retries }));
+					.retries = retries,
+					.failures = failures }));
 	if (result < 0)
 		return result;
 
@@ -2230,12 +2241,6 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 					goto retry;
 				}
 			}
-			if (scsi_status_is_check_condition(result) &&
-			    sshdr->sense_key == UNIT_ATTENTION &&
-			    retry_count) {
-				retry_count--;
-				goto retry;
-			}
 		}
 		return -EIO;
 	}
-- 
2.25.1

