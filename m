Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEC3C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 00:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiDHAPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbiDHAPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 20:15:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A6A12A8FC
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 17:13:36 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237NAa4k014737;
        Fri, 8 Apr 2022 00:13:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=dSVVvnRo7jDyQF1UEfJ9nfGfuTuhMtgmUInw4qCJyjw=;
 b=JUlC2fA/joIi01Xh8DXkkYu9smicQeYBZbvkInHKP0jHChYwilrsOCO0AFfUCnsX+Zjy
 bmmqQ4hmzFXb6pFaO8Vdcky3MOzoQNYXUTapjdYRtgB2KmwDZZ86RMsCTiy4OoQDKcy1
 kIacqUrPn5B4BdhnnPHlWXv1Zlqd+8AjJ98/4IUlxJY8Xv3SG33V67nWOenu0IhuvwCJ
 wfJTLr7kNBvwvIXr8llKAdoX1qnEVVCXEM7oIsPSZNo+YPi60FOG4ty40G8Csk4gkcit
 rPVT9iKQNLPsGpWRCY8Rp35B1cfV4mRl0JaFPRwDOqTbAdh5dcedaSH9onHp7ILCFbhN CQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9w456-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237NFHE6013838;
        Fri, 8 Apr 2022 00:13:29 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97tu11q5-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHCK5Y+7WCxk33XozxTrJGik5xxSR1L1TB7xU0PpXRxlJv2nfGEEM9+uXBuxOlZMYBRuE5ss9JNtDsLs7Tl0kd5aLyIfQwRd/8mIOYHUqbZoC2gLrGlbOsoeqUtWdvk9eLnTETFMF+cFq0UsGYvQYOowB7FuVA9k5CfquJyRWktKubIf5C7EPwmf2NqvL+hPuRbBJYqg4Zun19qxjK5zHwD6qkBoK0sAFGEWGLmeDK9vza/vJ+E7bem8Nep3cmcWp9IrCYpRZoZqRESN6tVuWT0Mj9t2hgEXBWxtVoIC2x4II/w9UwkeFCXfHmoHGGdfFDFXbJA7xh7TSXkphT+7mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSVVvnRo7jDyQF1UEfJ9nfGfuTuhMtgmUInw4qCJyjw=;
 b=TdSugBkI7XbeVRLujt9OxZcfQl92hkw7CYD36m+upmLYla2HF92QbaDfcUx7uCvqxP+0s82hPaQhgZP6uLvS8fJQ0vQnLY16T1j+ywOSAEHSPBQCPqPrz/YfnDnblPenapG2AMKukl66WwPS1DGj67VDEkXCVT89f9Yzi7CdWUsH9BExndT1Kkbcm7gQepIoai03io+vLQVYqJIDTkfwc4w75TLuvBbWw5Mcz5SR9RQxXDvjkqSaYnTtpafzaP+bsX07wEBwAkIuGDPZCm/kD/YadBChmBF953CjFUHehhm+aWRyKn+UEePFh5k+7LdwHCn3e2a30YS0Jf3b6qGKDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSVVvnRo7jDyQF1UEfJ9nfGfuTuhMtgmUInw4qCJyjw=;
 b=W9qSdMLiWRI4GsYt+gMP8mtByn8h+9UnBjgeQ/cOTWv3jngN4y6hLTDX5MwhBm/wVPNWi5ytyQrGgrUW9YweD32AnoPBhgw1+v8tQ6SCRKckz6ypNwHAFikNc9Hx6nNq/cJ7h5m0dlwBcnFu0oj/X5NhAEcIBy55hZYzwSx6FDw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5550.namprd10.prod.outlook.com (2603:10b6:a03:3d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Fri, 8 Apr 2022 00:13:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 00:13:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     skashyap@marvell.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 07/10] scsi: iscsi: Merge suspend fields
Date:   Thu,  7 Apr 2022 19:13:11 -0500
Message-Id: <20220408001314.5014-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408001314.5014-1-michael.christie@oracle.com>
References: <20220408001314.5014-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a01781e8-7e13-40e6-c4d9-08da18f499e7
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5550:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB55506F1DA1ECE604B7D68336F1E99@SJ0PR10MB5550.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LrEGPKG2xVftfG9mD4RCyno8wp/e/kbl8KNyQ28bctW/JU5m+wEresCfe6tlYEV9FfWu84sYs0lxbvn9p0kStzM0StG9lGd5Z8qXUQEK1Lsh3MOSxIa7bDsn4u8NY2vro/Y4oa9O82BFqsRHm3kLhzIaIbwTeJVKdyt83cpUbwrO1yvWwi3vw5Wkt5mfkBXYXkUdVmGy2OY+YYsGiBmZMJPLTIgQXWlyEVunEeLaawfZ7JcTF4O/MkfZ8vyPNuvFO5qxXVTRhK5EjCgfZwmfs5dsXgOFMDf1LCf/KhF3X8ewDzghn23Dm4jl5ErxN4lzxFW5RrdbWVlSlw8zkUBsPY+4dX3Bpv6hrD353+Kz8Qw0ErUMKwJuTiwSm9Ir+l1ukG0falENpd/dT4g0Td7pJ2XzA37hc9GBRpoZSB5fLi/VU5vZJxK3kGoD4Nj75ttF3rMhSZA0wSpP/7pBK6cqfys/ocUu4kdYhBBUBn7wdWquYe9gRimhgPSDOJGOHqP8BT+bnP5iyb+GZaaHhx8iCjb2CkuTBAOR66zGNvLuPCHGVAJLlq28P1u3cDpIjO9/glfbhWL3ZxgYSqVLa/vRmSoWHXEXflMgAIth0mdHpDBxpTdmvLiawcnbZGyQiegsW/KHKi8rYbxsLF7OtskXsC5a1h0y+3xp7rq2w8FVXS+O1jU/brOfpI9D0Mlu4MswrqXE2xHSOX2bXRSGO/Mcrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(186003)(83380400001)(6486002)(86362001)(316002)(2616005)(6512007)(5660300002)(6666004)(107886003)(36756003)(38350700002)(508600001)(38100700002)(4326008)(52116002)(66556008)(2906002)(66946007)(26005)(15650500001)(66476007)(1076003)(8676002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gAVDgPGDsDoNPhraBAyKnQDS9Mllkn2y/h68JUlGUbqkYFwln2k3jYPlLfdJ?=
 =?us-ascii?Q?cGmfJaXI8HSjg6laxQy6BFO7PrdkmXjtd9C0IEv9+5dVP4d5oFVY/gTtGxwz?=
 =?us-ascii?Q?2o0Fu0cWzTPKNVjvXas/xTcrQhRLV05pt4Q0vSljjyQ0xtil14gtZm24O+cT?=
 =?us-ascii?Q?isv3MP6CSWGclrqQoesxoIqc3xIRH/z1/76dTNFDG2wXZXsd019llV91OWx1?=
 =?us-ascii?Q?CImgWigQhmBa86ZTT4TVcGVgnRXi8qjlqe/Q1Kbv7pJBFlLV+mtOysSOvb2/?=
 =?us-ascii?Q?T8rQiLldUS8dflFGS/A9SkW4n3lQ6ITYiQQtgBWInA94neeXrIkOFiK5Bs4x?=
 =?us-ascii?Q?EdhOQ+R8oGuTNaP5DF9oWyO3HfngrKdBNvew5wPynehj95PkcV9uBXObSrQM?=
 =?us-ascii?Q?rsXbl6mOFUstKr8lFUhaZ2OL3r0jQprgStQLMQsY1ieQGUyKH3QKXNi2ZzgG?=
 =?us-ascii?Q?JMwxVFuMBUnHnabyUQzN07YH4owrDS4JEJOjvcy2wGi6aVsGmDboZu5diEmr?=
 =?us-ascii?Q?EYncgOMe2WvafJwmfWgDQQ4cFic8r5PAYT9q50vMPwKDeXG88WK+ccK4FVhr?=
 =?us-ascii?Q?AI8nOQePOJPjJ3uAtduwb2kS7zu8qKxvl2aMiLQF3SJfe2cctIyyMkVm0Esp?=
 =?us-ascii?Q?GyEtPEBGU2V8Ow5BGzkuQ3+E/5Fp2Yt9DLsshSTCC/obsEm4bIS1AcGhzVtq?=
 =?us-ascii?Q?3ZiJuKSFI0zjGgvw3iydQCyf18gbszfuq0X1iKpxuqj7v05wEDJaAtU7Ch1H?=
 =?us-ascii?Q?XOwpFvufqhk4iKHd0cbkhvuw/gg3AN8mhpEjlfkXqy0357sFufS0ybQqYPeD?=
 =?us-ascii?Q?Wwdr75lO/kqEJbWVAzrDysGWztCrrEI58mSprQ50L20UmkXGEZz9lUcNxt5T?=
 =?us-ascii?Q?FPNtJ1OfOmA2dkK2Mqaa4OkDvWfDswu+ixsxlZVkklFwZ6n7bt5Wchtx05tu?=
 =?us-ascii?Q?hpApofjiz7lJhWPL5pxbx4ULMqcHMQvFlpexsOSyfCSqYpOP6uSD9VW49HmA?=
 =?us-ascii?Q?1gTlIO/y4pdGmI8JxrziaSscjPYG24YNMUS25LoMOgmKEF8+6Ty/0/XW8nuH?=
 =?us-ascii?Q?YBpE2yiSqmoXwTLyBFcm47x2UUb11U+Ur5TLZs6WD/rymGghM2A1fIfYFMO2?=
 =?us-ascii?Q?RXBLpFSKCFKeJPUe1nDx5cP5B1HGCvFSEUJ1yujmHv8CUpJcM3QibWKf7Qs3?=
 =?us-ascii?Q?JwlHTOt9SejTDOFAGsnOyvA1CZXWaa4KFqsWwaSX3yPObpm8MLBhJ0tvgmKi?=
 =?us-ascii?Q?y3ClLRyO3j1Le73PYJdxWvz9gds27RvSiunqj3mvGQBJHZznFfjFs4obtERx?=
 =?us-ascii?Q?e66oDWeIKSHCOEzg2veOlUXL9KP1UWVN0YsdGaAJLeLS9iM0P4ltgnqtrmSu?=
 =?us-ascii?Q?ai19i53T05y1qGG6ZVTMV6RLy8PEB+K10D/x9VYYNYECXDujZZcAUrKIbmf3?=
 =?us-ascii?Q?2BApRXBzSLNh3ejiw1oZuL3jut/GKX+J1y1xOHkeowtcr1gRIDFIK0AuK9yN?=
 =?us-ascii?Q?YuLpBj9Or6pjENwZb4rL+etHX1Z7iYgEweTwCRlYGY426G/mwvLLKrrrNNjr?=
 =?us-ascii?Q?Oex+A4q//W604MUvcMgBvIXF91s7XEcUg5PMEdqgNJqM3i7haKrl8D8ueR+O?=
 =?us-ascii?Q?PIMKMjp1WqtTISpknB2EokTMRZTvPd1rMGYHllCr90MmRTQ/TC7Mya3L/+7n?=
 =?us-ascii?Q?ATvK+iB19sdn9RsOyKYTKvdw9SVfh/aqBNdJ08cznyxwEbNpfNAMTel19pXf?=
 =?us-ascii?Q?JoZtCb/eM0+hdsegAqx0i9W8SYNtNIk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a01781e8-7e13-40e6-c4d9-08da18f499e7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 00:13:26.0942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: igcJHrK8IxlQrceYL3VBLbUegZXX8TgsxqJYDQv4bi9PUvUpZ5+wZ7BbD63KykY7582cs5peD/zlssTBYXtuIgl3TyuuTNlwHjnc3YGTJv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5550
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070064
X-Proofpoint-GUID: oa5RcJ9XDa0IqzAZa-wrGm-HmjghsiL5
X-Proofpoint-ORIG-GUID: oa5RcJ9XDa0IqzAZa-wrGm-HmjghsiL5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the tx and rx suspend fields into one flags field.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c   |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  2 +-
 drivers/scsi/cxgbi/libcxgbi.c    |  6 +++---
 drivers/scsi/libiscsi.c          | 20 ++++++++++----------
 drivers/scsi/libiscsi_tcp.c      |  2 +-
 include/scsi/libiscsi.h          |  9 +++++----
 6 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 5521469ce678..e16327a4b4c9 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1977,7 +1977,7 @@ static int bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
 		if (nopin->cq_req_sn != qp->cqe_exp_seq_sn)
 			break;
 
-		if (unlikely(test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx))) {
+		if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 			if (nopin->op_code == ISCSI_OP_NOOP_IN &&
 			    nopin->itt == (u16) RESERVED_ITT) {
 				printk(KERN_ALERT "bnx2i: Unsolicited "
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index fe86fd61a995..15fbd09baa94 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1721,7 +1721,7 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
 			struct iscsi_conn *conn = ep->conn->cls_conn->dd_data;
 
 			/* Must suspend all rx queue activity for this ep */
-			set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+			set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
 		}
 		/* CONN_DISCONNECT timeout may or may not be an issue depending
 		 * on what transcribed in TCP layer, different targets behave
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 8c7d4dda4cf2..4365d52c6430 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1634,11 +1634,11 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 	log_debug(1 << CXGBI_DBG_PDU_RX,
 		"csk 0x%p, conn 0x%p.\n", csk, conn);
 
-	if (unlikely(!conn || conn->suspend_rx)) {
+	if (unlikely(!conn || test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 		log_debug(1 << CXGBI_DBG_PDU_RX,
-			"csk 0x%p, conn 0x%p, id %d, suspend_rx %lu!\n",
+			"csk 0x%p, conn 0x%p, id %d, conn flags 0x%lx!\n",
 			csk, conn, conn ? conn->id : 0xFF,
-			conn ? conn->suspend_rx : 0xFF);
+			conn ? conn->flags : 0xFF);
 		return;
 	}
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d09926e6c8a8..5e7bd5a3b430 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1392,8 +1392,8 @@ static bool iscsi_set_conn_failed(struct iscsi_conn *conn)
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
 
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
 	return true;
 }
 
@@ -1454,7 +1454,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	 * Do this after dropping the extra ref because if this was a requeue
 	 * it's removed from that list and cleanup_queued_task would miss it.
 	 */
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		/*
 		 * Save the task and ref in case we weren't cleaning up this
 		 * task and get woken up again.
@@ -1532,7 +1532,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	int rc = 0;
 
 	spin_lock_bh(&conn->session->frwd_lock);
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		ISCSI_DBG_SESSION(conn->session, "Tx suspended!\n");
 		spin_unlock_bh(&conn->session->frwd_lock);
 		return -ENODATA;
@@ -1746,7 +1746,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		reason = FAILURE_SESSION_IN_RECOVERY;
 		sc->result = DID_REQUEUE << 16;
 		goto fault;
@@ -1935,7 +1935,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 void iscsi_suspend_queue(struct iscsi_conn *conn)
 {
 	spin_lock_bh(&conn->session->frwd_lock);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	spin_unlock_bh(&conn->session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
@@ -1953,7 +1953,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
 	struct Scsi_Host *shost = conn->session->host;
 	struct iscsi_host *ihost = shost_priv(shost);
 
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	if (ihost->workq)
 		flush_workqueue(ihost->workq);
 }
@@ -1961,7 +1961,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
 static void iscsi_start_tx(struct iscsi_conn *conn)
 {
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	iscsi_conn_queue_work(conn);
 }
 
@@ -3330,8 +3330,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	/*
 	 * Unblock xmitworker(), Login Phase will pass through.
 	 */
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_bind);
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 2e9ffe3d1a55..883005757ddb 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -927,7 +927,7 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 	 */
 	conn->last_recv = jiffies;
 
-	if (unlikely(conn->suspend_rx)) {
+	if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 		ISCSI_DBG_TCP(conn, "Rx suspended!\n");
 		*status = ISCSI_TCP_SUSPENDED;
 		return 0;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index e76c94697c1b..84086c240228 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -53,8 +53,10 @@ enum {
 
 #define ISID_SIZE			6
 
-/* Connection suspend "bit" */
-#define ISCSI_SUSPEND_BIT		1
+/* Connection flags */
+#define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
+#define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
+
 
 #define ISCSI_ITT_MASK			0x1fff
 #define ISCSI_TOTAL_CMDS_MAX		4096
@@ -211,8 +213,7 @@ struct iscsi_conn {
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
-	unsigned long		suspend_tx;	/* suspend Tx */
-	unsigned long		suspend_rx;	/* suspend Rx */
+	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
 
 	/* negotiated params */
 	unsigned		max_recv_dlength; /* initiator_max_recv_dsl*/
-- 
2.25.1

