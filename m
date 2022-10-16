Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF7EFC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiJPUBr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiJPUBO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:01:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C1F437E1
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:53 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJlr1X004935;
        Sun, 16 Oct 2022 20:00:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=GmOtgDWTQm+DIJCGDPaIxGqc++SvsLdQKZoRRmhKCZU=;
 b=mulpKDayVRLnyD6O7GFDN+OvfVwgwvu647/zLdlTRHD392q3VIMLW5RMUvYwpeLVRzzJ
 SIizIkPqulvm1FXJ01S1xIVi/XqF6qYJZMJ4h/Mk4ZIW8ZyKjIxFTSzegYRIrC1aKFGY
 qyo/H7IbBsqneYKc4kgmLLaPewgw9UtwJOPmQ553W1XYt/OjgdWVJCEHigGFId15lVwe
 qminUuOMH5YGZVilIZ5S/DTbdu0AmcXMteUybse2TLcDH6v7LYAL4nGT0Y+H04S3ncMq
 JbVYqeRHGlGVsAUOjChViR88DAs1YY3TEAWSGVh/n5Hsxpn2ngNKEp7oNQ0ufZ0FbeBZ NA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:46 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCBRO7029410;
        Sun, 16 Oct 2022 20:00:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr84k1x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VD9F4RzUcSSXbN6PLt/Tk3cTJkBVh9uTUaYtVvweR7aNzZYESQ4r7ZjjLw4rTE+kdb2/YlfraXGq5RLgQ04UDNBboccwagaaiFDDnBAGhfLyeTyvaAKJaqKNKZbvN4Vr/Fpl+nECDphqdJyMtcrIpM/Nfk0ovPNHqQvL622QuYLSqHJdc2VB0J0QZfnSPj9pbGg+asG2g5MiIsAfiZeFLCXJnYZfbPOCv5ukHR9DvtjLTivTDEXRFNCswGZuivRbuJmRZ2iGEH5IUDDiueKnbw9ecl3luPpZOSNq2uBDmkxuqqFIJTZj7cJ3VqAd/wSBKr4DjsMYpBbtBDKy+YTpuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GmOtgDWTQm+DIJCGDPaIxGqc++SvsLdQKZoRRmhKCZU=;
 b=Y4KvHpniaOgwI6IHhO96sJiwdSYcsN90kPL9S16//GPx4gC1UqTE9aDV5+5DiP+MQcyuTaO2vmstLJa+EKtjsZKou3vI+CBsyJRnlDT/EGuR12Dqv2gtYa/H0/H+6Jej9ximkKSAYs6EAB/hfq6esS4en5djVAH6dLUHPZXiVsRrHveyGp3Fgnfefaasmlc7+i7TU5ybPGONuwanohgllkdej9SiTvI+v0bilJU+vWLil8CRKeDljmfg60xo5jO9G58fO6ZYI3eTbsaauJovWuCs58gZJMF8ciKEgkrl5spqZAHfRCdhp/mIDTzFeg0MgyI0AI24G5cP257urEwkUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmOtgDWTQm+DIJCGDPaIxGqc++SvsLdQKZoRRmhKCZU=;
 b=iP5RFrZ8GoasR5rPxdjMW4oDCmn2lrN2Kj/92tLw8UFc4B0ACpgrMuUfjU25Ub38mED6GhNEm6fSK+RNdwIK8U20pRVC5R2QRwrwR3M3iuCFNJvJJD7b0bUweg1bnKCDr6a8A7x8BUY2HotYuGPpU8+dyXGaWOWwxj6+4HtR650=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Sun, 16 Oct
 2022 20:00:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 29/36] scsi: Have scsi-ml retry scsi_mode_sense errors
Date:   Sun, 16 Oct 2022 14:59:39 -0500
Message-Id: <20221016195946.7613-30-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:610:38::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: 25378d9f-116a-4a2a-9148-08daafb11b8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ro2R5mRMgMWO3RJgKjpAJlPt7PjgvaI5qoWZTCYR9VhrkeW8iamXXNYA3KNI2ArPhaKsUthVyAmXeSISwDdqUiTnM0sEx+v2e+YrFFfiJBeQ4QRHuQD6vd16VCcFC1FbM8lYSB+RPcxzz746jhF3EzF1jIkyC1T55os6jh+3Tf1BMoLxmu5PQl9mSpInmxtpd8GmDcqBmpyg/S7fjouepTOnn3SI2X3SW/RbJzMk1N16O+pgoRfXtkAP0q8M2Up7DREmBvFE2UHyvXE5pcs4PIqBoQJ5jVcHRbFQUOwwOpLhuLlxYgMPImZP/exS0AC3iv/JWj4USZyMSIAXb8wkTDfOeWhGHwCOU5S6tFghBOCP5zSbjkPCPbGOTxBKwTZPmVVbDSxGOAdMNL8t+On89Q1tzLibaO4lZ3fSOYjgpwx7GKotmEk39wXNbqteNFBh7XGIIQgvPedhj9GoGY+YDwp8B/kyZN4sJNh74SKaxMAdQccnssEroNM+EaN/+i7ersPI3cE0ZI+U3SqPNpdYqbTV1T+T4uCRX+k4WuEHKt7SfWIN1eOH9+c3Ou1JtHrqI7BoBRulqtC3jGwktdw+xo3hqrgj0hq0fP3gGyPaSoh5Kd6Iap1L9FGadSz9td+wOCxV6w+oaPc3vGVRSYzZ8YdY7TzRBwC7e5VtWv02TMg5Jk+UZeBYKWkcFcINE58YaFGfzmu4DJPjQ8KPFZxDJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(6486002)(4326008)(6666004)(316002)(478600001)(107886003)(66946007)(2616005)(66476007)(8676002)(66556008)(1076003)(5660300002)(2906002)(6506007)(186003)(41300700001)(8936002)(6512007)(36756003)(26005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VEzq44rdgfUiEa1unTjsbm6YjuK+hHb14gKNVub/Td8rmzGmPUQjk2IBWjAk?=
 =?us-ascii?Q?FSuIJxTvpxkH6xxnM/CGzcX/y4eUP+LXIx1thLbU5gh6dic1okovIEdo6Ujl?=
 =?us-ascii?Q?afGt/MSDGdTAX5v6ZfDYCm+koVp9pzEY/3uMvE2biczCTqnYMHIVDdLghCic?=
 =?us-ascii?Q?LjHEwXPcURBqwsEKCXpMFhIqFqQaJhPV/TAfxhGiaQ+QQdKtLGGBooECcZLw?=
 =?us-ascii?Q?CXuKUgOXHY1cv3n49W/8megtTMbVklY0wLLVfXdEfjA0VpviTD85K90qZmG1?=
 =?us-ascii?Q?6X8cxRlLNZmBxgjFaWzlWpXc54OitaAtkKTpmaYxpEeqgeOkAQr/DJO35Ivd?=
 =?us-ascii?Q?82bWTySKHYBFW19NlhiyMbuB0eSETjIhUS9RudHKqiB9+dxUqzYUIYq2xYk8?=
 =?us-ascii?Q?Gb8MJT4PFmedFYO7GcOR9Vrw1hnDRGuQZyV7NkE2zF4TtTLq3YBvLAafS8Jy?=
 =?us-ascii?Q?OGVO+2JajiuSIvovjUzjQPXEXhck4HYMpd7cO6zpQWLVGfKqmLir+Yz8zjza?=
 =?us-ascii?Q?/AX1tT65VjbkdOs3yiTHZlrlN2WWvLidpfXKi7Lfz6MkOJuOVngFw7Phurw5?=
 =?us-ascii?Q?8fC1mH7VhL/XZ4lVEYD+FwpChCBcmhN2m5ZeCROdIi8u9CouUo6uX5yE0mGs?=
 =?us-ascii?Q?xDKeP/J+isomr7Vg2QQpCck4c+SXNt9l5mRuu/hbIeypM9PHztnjKYZvEA+i?=
 =?us-ascii?Q?H6WUbKBMgRhlElGvGUkHVpqk0LbfLGIdOt8QF2p2Ve42z8SMxLWpH2ITIuhW?=
 =?us-ascii?Q?lFLTCA6knqWiA+zSHQoVQsgwtVcMwWF9poW8AIwjoVl90HQX6yZKxeBYUPYZ?=
 =?us-ascii?Q?vZpU45mO9xHCOT180ulLf7ep5atWcm/do5hK+O4BR+NJWtPszLdfQqKWb1vB?=
 =?us-ascii?Q?kTkE3n2EpqYqF3pmqVQPVzWCifTrXIUN/V6AUiXE2CoOuQBxv6J1vhpwrH7j?=
 =?us-ascii?Q?iqA+K0fH1jxe+AvZAbPCIFc+EX9sZhzu0146d2txhmwNeA2ndGRHV0Ii53PW?=
 =?us-ascii?Q?rdKk35U++pM+xiIwxUbB11Ylgh56YrQiQuc7nVDWFl2bQq3fugerDaoLQDBr?=
 =?us-ascii?Q?CzSRm0sBtsDEXCQfBGZeNGkus6Iv+5GR3Zfq0+3Zm11B1c1K4oqslLCQmc2j?=
 =?us-ascii?Q?V44JMIRbicxoHcPrBOtRwLcOYpVZMb0hjhvurNJIoA1/D5XqIjwshfRTBr/m?=
 =?us-ascii?Q?2RW8+kR3sNjU0GO9jrahkNcCjViSqJypt/9/1Bubi+E0WDjmO2Q9x5IgQqGe?=
 =?us-ascii?Q?NoBhKllGfBcKXJ08O6dEpyg/43VTsG07uRMXkiZGv/99R9HsRweVprrhlMct?=
 =?us-ascii?Q?jz5Q8CWybfgWpccFd51JCQm75sJrVPS1lum52xvpCrIBdVCE99KrAHILKrl+?=
 =?us-ascii?Q?Y7+vfJpUinKpOiQiOUGFkhhZ4z8+L7Sd9yzAO6wMSjQGmOZFoOV7Z0pBejn2?=
 =?us-ascii?Q?OK5hb+pyc8mIR+ufRgEMkNbN2jITMLLTNEmDs0CS5C6RHDEVVTlaC4erQLtc?=
 =?us-ascii?Q?rWRHpQUjyCNS4+p5Xvj1HsVIf3inPc/94CTxNqTvJwhz3a8sCb6DC3FoJK0t?=
 =?us-ascii?Q?H6xGQ5MIxgzlQtaQQTPu8M0zsIQwhPubcXwTXeaidbN7zFa5EG5emp552uHM?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25378d9f-116a-4a2a-9148-08daafb11b8f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:43.4374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q6z05EEyiRp1jUKiQOCdCumfBFOSne346VJyzR2grplroMsX2JXIOHG3g19JVh0iyl+4HjiM1p8VkZhHjslX0Lch6UpC9Z84/73g1/KZOA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: bmKRoTyBuhBNFWOlG1KsosYPFEaPyREM
X-Proofpoint-GUID: bmKRoTyBuhBNFWOlG1KsosYPFEaPyREM
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

