Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C48C43217
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiJPUDi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJPUDb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:03:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2308323EB3
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:03:31 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GGLn6l007234;
        Sun, 16 Oct 2022 20:01:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=bv2QDst3SvZ9Om5sDv86682KKPj3G+AqO8+l3f6Ty5k=;
 b=rqVEb6mkLexEO4/0n2uOnk1rr+0CAfkfLoNuhWrQd3EjdAYwZulo+Kg4m1AkjTgu3lZV
 2HMKaT+xnekmN0Pz5F5JehyujHSZdC7zN5U2F5v+7IMy9GJehQO9rQmxudWnbK2fgB4H
 27/cUP80tEXO8aI8AKG+UOfFGrwXZJ5yByPdWg79TrKR5+9Ko6GSZa/cORawJEOXhfPx
 ixKqwYpNR/qImEMrR5OFfQd5uaT02OO3k42Lzcn0axOI9gL0aDyXLyi9H3qA2l6iDEE5
 iGG0nbd5lb6XWRAzF6jaP6NcUoqsy5hNFygxi0wYeu2OgOJroad05RFQ6y11d220J/Mh Xg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k85mfs5rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCHbSl034322;
        Sun, 16 Oct 2022 20:01:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hu54e0w-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6LRYcziZSmtNVQw+Klqf9NElUM22TM7S4q5GxkHJXAi8Rn91FW0XVZ9xem1meimzpZumrG+kQg93vgMWn6idFEfOWJuFM+5bJNGueloHwEjGl4XihLCOcQDFDdIGyoCTK1T6CQLokk1Xw6/p0BK9kRoQIyd6C9WeLKwyrV9lHmn9SnC2WHNCP7/TfU6sl4bYYLSF0MUY+WN1YGK9pcknOwPQhtNjWVYGhotFEhrDK3nr2C5ICC4mBsCm7gsaEyrs13c8PQS267v/fFviYaQqFSxuKF8+UOyqNQ+AYjmaVezo7y1ppNm7FKiMCVEER4x80T/gcxQgKTlGjoYQVklew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bv2QDst3SvZ9Om5sDv86682KKPj3G+AqO8+l3f6Ty5k=;
 b=l1eySLNE0bJxhQyeAI+VUC800WFkxpkWpB4qC8DaNAtK88uHmsJ1YBsKPe9XGIYivnDE2Q1oMybfDs5IEMcdDuY8D+9yr72cf/pimV3x8/YNXuu7wBMGJ4IBlC6yurTjnbgzl9kdruC2kJ2Cn/cjouNw+Iab8D0fBe1FBiimxLHz5BZTp6oenChlUbKUR2JTOos10huM5JwG95leYrFnlvioyxPVWI6ZtGcqd3exU749coDLeK6Pw6hViHQxeTno//1Ux4a1FjImhz8JNic8Ub7VATudjvdgv1cKr2JzziQ09dUpcC7ShoEZ0zSQDhVu2d+fpuKjAnhxmQnK/7S3Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bv2QDst3SvZ9Om5sDv86682KKPj3G+AqO8+l3f6Ty5k=;
 b=keQJWvETypLaNfgw0QuIDgLFmueMlJNPK68wmxL2V1hSfV/UN2lrFlhcIoPto57gSIMct5nBOtNA0svx4pPXs1bCh/nrsukylj220gp8ki26MnGIxwbheV7mj989HUoRioZQTFdEouTFk5QIc9V8IT9UedW1mw+1IpYxhh5QyZ4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Sun, 16 Oct
 2022 20:01:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:01:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 33/36] scsi: ses: Have scsi-ml retry scsi_exec_req errors
Date:   Sun, 16 Oct 2022 14:59:43 -0500
Message-Id: <20221016195946.7613-34-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:610:38::23) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: 07e5ffed-738a-4f30-f277-08daafb11f0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wUf4rqYMLGE4yrIAbUNdb59VjLMlfIsN5DmC6JKtbsazvduZtKwbo/dsm7PLluQboxhTx0+lw7fN2yzNQtAE+w+yIqtB1V8UK0N76/B9T4JBDd7UIrxHVqkPUCEoETWpDy14G2z6whZ4XqWuKsu4mXX9gSjgXJ7B7LWiZQg4sfQ7BDWXKWL/qt5zuR0SBlDi5J91gcfns0MaZ4Ipfsbpe1lsauHVaxE3473xBCQK+4PkeXjP2LOpLwD+5VWowtsLxRjITusOPNWA/HwoxJvjP+LuyM7VnXPtznTF48uuqMYuuWPvWzgzOWF4cwtqrtc/It847xfNJfoqFZrqSs263ggtT7opcJj8ThJys0q6/2XvmG3hiIsfYD9uKNn8H0+5Fy0apHJiv1rNU3E4G9c1FEkJr6lk++PZiSMHTzRcut2bl8xDsm47b/chNAtjuzxawy7OgkKJL1F7gbE+0bRnVna2SMBneozoGKIqEnkFXpUfsblSD7uWqKHjO/4ALD3EjmpmMpywpSjmSt24/0WXu9wqGCb9ofE7cU4R4KMwYioYfxefa9846rgFnZoVOE73eIcR6UNn4HDr6K+EE4mTWzRNB5ajyyX92O4oc08/gMHpzs+trGsI1DYoqTk/tLQbhdkF7cjwaf9Xs1dJ+qeH+rIwmtqxOudQ9pvcyx57Vjm00yX8kbg+66x6QJKmydGtzOVYiyw4Uh7eDLltERqtDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(6486002)(4326008)(6666004)(316002)(478600001)(107886003)(66946007)(2616005)(66476007)(8676002)(66556008)(1076003)(5660300002)(2906002)(6506007)(186003)(41300700001)(8936002)(6512007)(36756003)(26005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H+DhKCnr9m7VX5hHKzUh+SUQ82+dcM/1sZuHwakpHSN3Lna72pwd83srHjZz?=
 =?us-ascii?Q?ruYVUVR+HtceoyzBHBkTeKxcDhGiVqV5LecMj4RoHPTZa9HMR1Me5QhXf8mQ?=
 =?us-ascii?Q?Hgxui+W1h8mmaBS3WakZPEuAXaAUST8e9I+fo6Me/+jJWu9xn85v/qfS4+mK?=
 =?us-ascii?Q?YZrV8CytEIZbvGDD/csv6eeNjlGcBnXkP9IOn5JLNuLDv18wbBHJp1a/NYxp?=
 =?us-ascii?Q?1JPJR2ZVVwzyG+Us/ok9p3jdpj1q8pFsylUeTkO2YndOcg/0zqR5r93iE5Gh?=
 =?us-ascii?Q?lyxv5fZeqvxWHKns+VPwSgPyQEImY7icZSArnAw0RzGQpEFHAMog7ZJ5qvY8?=
 =?us-ascii?Q?qw0ohX8Sx2EhdzYX5wAqQ13SCaWmQ8EeDZfLn1aXmXKltIDzVWAQKS7RW3Y9?=
 =?us-ascii?Q?U8kQAPzIL8Wn3sCOfbkbpAEKMiSSxWfEk13IU4bokGmEc+rEa1AaLXI/s4XF?=
 =?us-ascii?Q?91GlSz2Lv4uacLn4hlMDT//CcQV9cUfNEWV0P8GOwWaRKI+3VkL4DHbaQRKV?=
 =?us-ascii?Q?cTBet08LybStUcEw4f1pC0whTwAVweY2dD/H5W9nWIkbvQ7uQunE5j/L0Osf?=
 =?us-ascii?Q?i9eabTWaHWvpYBkgc9CDdz15QTuGc/fOhTkLvUnlq8+EaIcNZ5ixspt6bYQa?=
 =?us-ascii?Q?q+oP4NNSzxL1RFhQZ/4YLaJaeLBJFTukAobB2Fe0LiscODrolG/CAoJfmrk9?=
 =?us-ascii?Q?NUWL21ZY1yN/Rrw6+5rkoSoUtL3Rzzzbv84WKRTzZim/u+9JS6qHYC/VTg8f?=
 =?us-ascii?Q?kZE6sHwrmF7SnP8aJgliO6xl6FGujRQRviu9jrDInv7heVFbTnDEV4+7LOep?=
 =?us-ascii?Q?/2r5+Bn8eLpsO48GxLLQX7gecNi8bw25OpF+y6W6o1v1tlGNZD9n1azLNZHO?=
 =?us-ascii?Q?oB76riu/izTQ//aPaM+9KuSXImhxIN9Lu4eFtQ1aFVcfGAZAYXXXv3dsCqOM?=
 =?us-ascii?Q?daLeCmnzmq1aaTDMbip3jEX+e6Igof4Jmk7SuIVcmGFeqt4jJiAtvdmdh+lG?=
 =?us-ascii?Q?b03KkBtPav/ZzlBSfjz+qazRptG0GrqIcbpc9eopR3+DxKTm6TKSm/2Fj0sG?=
 =?us-ascii?Q?oJzZ6Q462bb61GXMEX4lB3dwiAnurxT6lhvXL3vIqDHUX8MelORLCewebAyF?=
 =?us-ascii?Q?cK+1a1Q6iFr1vX7/MsKnVdagbO1DMmAuxVylBCYL+HcySCffSwE5o0KndOVM?=
 =?us-ascii?Q?JhN9f+N8mkEvPtfF3opASFEbTmDRnJbVv4D0Zap7AazDEsqblkadHX61jWMG?=
 =?us-ascii?Q?CYezu0ekiBtIb9ssDcGamN10e+TByLpNK+W3HbEZXm4r+D/SIVtijdp82DwB?=
 =?us-ascii?Q?Xc/9KLXmZfoMvfTp4KeXPPs0IvgAh1oEjzKUHZHSb9ESnR5cuaBXgIoUBlhK?=
 =?us-ascii?Q?33pqRx2rof4u2JGmJqRJLG6wGwfDa1leH2eXut/rjsggxepKNEi5x8hSnlnK?=
 =?us-ascii?Q?OkWJOBm/hHphZytvY9cWA72qxTrizboUio+Veg4r0ZJmP6uxguNowMn63LeV?=
 =?us-ascii?Q?Gkw/bP415p9QqMT1sqacEbfcEQvY0FwMe6jj6vaxIHQbexpPkz+BMYij+Z2v?=
 =?us-ascii?Q?+T3QZOhC9KaHaCEInEnbnjKTmTgTv7lfu7kYfIdi96FiGqsybFkVxy6GEPnG?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e5ffed-738a-4f30-f277-08daafb11f0f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:49.2651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74JNP5oi2yON+tCdR5nptQEuteEBYPn8gsH1MrbpkBUyIS49I8Nishds/3N4TMXCw5zNXrYIJvXGEOaFRvctglItIfy6Iwy1luhguItmGNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: v4JGfrYsEHkKUZYicbgj9d0usNNJsOI7
X-Proofpoint-GUID: v4JGfrYsEHkKUZYicbgj9d0usNNJsOI7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ses have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/ses.c | 84 ++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c90722aa552c..d8b31c0b0125 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,23 +87,33 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
-	unsigned int retries = SES_RETRIES;
-	struct scsi_sense_hdr sshdr;
-
-	do {
-		ret = scsi_exec_req(((struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cmd,
-					.data_dir = DMA_FROM_DEVICE,
-					.buf = buf,
-					.buf_len = bufflen,
-					.sshdr = &sshdr,
-					.timeout = SES_TIMEOUT,
-					.retries = 1 }));
-	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buf,
+				.buf_len = bufflen,
+				.timeout = SES_TIMEOUT,
+				.retries = 1,
+				.failures = failures }));
 	if (unlikely(ret))
 		return ret;
 
@@ -135,23 +145,33 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
-	struct scsi_sense_hdr sshdr;
-	unsigned int retries = SES_RETRIES;
-
-	do {
-		result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdev,
-						.cmd = cmd,
-						.data_dir = DMA_TO_DEVICE,
-						.buf = buf,
-						.buf_len = bufflen,
-						.sshdr = &sshdr,
-						.timeout = SES_TIMEOUT,
-						.retries = 1 }));
-	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = buf,
+					.buf_len = bufflen,
+					.timeout = SES_TIMEOUT,
+					.retries = 1,
+					.failures = failures }));
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.25.1

