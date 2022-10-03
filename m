Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7196FC4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJCRxt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiJCRxm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:53:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A53D3719C
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:53:41 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOJi3014340;
        Mon, 3 Oct 2022 17:53:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Yx0/1yymjXfxf7tLRSmIJZrYvu8buN9wpAVf3zsZ1Ew=;
 b=wFqjaHEVcw9iItqnesN0c6ps1mJDobOBHPCuCk2hGOZv4xd2u8Y0heTbzjJ8L/xd68iz
 aB2JyIcuyWao7kJNXkhbD+ILSlFrib/gDOsbuN4zt9OZ+whUludoGZC83Q8WcqZ3ISun
 lDHy1JZ2YgAFx/t3N/ployu7LipcJy+f4UCmko/k2YTnmbF7N9hgZ9mNRuSGE5z5HBej
 9NX8b46Q/bItkd5umw+ws+YXyuwkEk30+t1S1qfrmAlq68lFuf0LPGP1AhiTRen6p9b4
 8uUhCg9ADdlV6KJv+Okay+GoPUnlM3dUSi67h3YWd6ZnoR3Pzy7+5Ea59vCxP5qZyjfE rw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc51vj21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FKuSp030179;
        Mon, 3 Oct 2022 17:53:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09rhsw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vg/ZPg9ND1bX1Qoj/SxomUwZ6PRrhDqr81LMMSZcGVKaVMWFTDa3rv0pT1cRqQtXHGixI40aQktrfOkzJnxy+Cg1B+6Z38D20LzhQfdPOPYMYtVZNiYijMWRCX9acL4qnR1lViM5D95ThVlh5X36DDoUSR1bu3CkvOFwTuadGxK7atNusMWv3MiDWHbqM1LHXxSgoe0mYL7xndrwnlWhJIR/eUXe4r0Yb85I6dXdvX3JHJlAS7Hd5ifm9mIEpiVxTqokY3hSQpF8t5A+LMW/Dznun2KEKdk/C2vH8ro5+KxJPsJ2MZ8wXMEiZ7amFlWUeT3OYwwCVbM4wFZ4rA4HsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yx0/1yymjXfxf7tLRSmIJZrYvu8buN9wpAVf3zsZ1Ew=;
 b=bPjzzhti7t4e/kwWyWLDWOfMFBhpvia9KT8E1q4njY7IPBqevG6wlIHeOZcJATQv15XZ9fMf3G6M6yowkvFb82CP7BTBy66TJmYVkPaM+skCBZPFqXL5sp1jFqGO7VazdwbKnxd/MBrByh6k79l1ipZ4NRF+qBZ5JhOQggcymRnijqdZsgzpk25+5CXFemKYQtPeMn80iY2/GLQv8SvvfEAMKkVnrC8HhxNhat/75Nn5I+aoslcmpp3l9D5lP2nLt0GGA2zSrc2waKsB0Sq67E3ZLU6YfvU/Ycw02CIgRqEPSDWCHfoHkHAlBDeZqo6awvv6PZOBncnpNxMWUi+NHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yx0/1yymjXfxf7tLRSmIJZrYvu8buN9wpAVf3zsZ1Ew=;
 b=uYTBoHBJYGT5+UR5sgX2NBsEL6o4ifnNxfbHQAhPOiHL4+3cJnsRLyQd3QOPd006Cx39QF+TxrvqvkGLWLpJGKHYFpt56R9rB+ZLICrX3nYoNFmJKTfwcUJtaj1H3D2FUm9uhhXz5rVZmG/ECGmSCGBNBlAm1EIkOdQPB9VBIng=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 01/35] scsi: Add helper to prep sense during error handling
Date:   Mon,  3 Oct 2022 12:52:47 -0500
Message-Id: <20221003175321.8040-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:610:50::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: da1f50ef-d7eb-4267-7658-08daa5682bac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GzAPMYLQG4L2+k5TSVZryXVDD2UwFmOXjOc+Iq4zfrzrlSTfyzG9t3Cmid4+iWoWW3I+Rckawe9JTdTsZd/egWLoaIfB5bpUFKXaa1zOnK5SFGv2o4UIXoV+3U1YxQ/vztP45DkVsC65yRkhX6ZwFXEw93vm3J03celMBMcsAyYjs2ddGPfL0XZKqAHrlBcx0vywcR/bn+EXV1dLEyiv/PTUSsZvza1Spw3RtW5yywTAwainZFD6l3JO321wQ7FLnzh7ZGxFNkAi3JaZILx0DM+lpTSgYsshpEl9vdLJ7tfHKt8lkDxn+7WBSkC8iq+D9JF30/8aBgA8J+W3UOYE2947bJlKDxLzb6Lhhb6cFmxgID91W1TXuj2vD7mKRm1NRFD/3WleS6Lag8vP/hxa/hfpVEz+fbIvat+xxbPS3Ke763C9Ahs6/ypzTeZxU/4F0lLhCkq2N9aFFw5gUkZv8//UG39Ek0cyS930iVt3s7XzLP7WSIExw0AvQabH7kgE0HM4sLGWaqj5FUuqcRMVAfpWQvBUmOXXHd8s20aapblKOx/U26tXBfbGkrh2srtfgW7mtOtCT5nPNZTLJdC/tgd7yLOHAkfQZ/vUAtk0T2jjH15gWaZA/k1IWMNNBploM9dXXLOsoK9ScZam2gI+DF29c77Ky1Bmp8K5Lf+9eA9E+6fzpYC8/QctyzgeYsWd6P5bS6YR1zXWItT37sSE2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l6K6RISk3fTZw6kumneOrU2J72W+dIfrr8K/jB5WgqB57aFa9m73ALHpCwiu?=
 =?us-ascii?Q?wZUp1qL/sV7crTYqibKpPsZU2qbfut1UKm+yOD9PffaUPcIX4qBnrhDMvZSj?=
 =?us-ascii?Q?mm3R4Rjo0z/VFwJbWr0Ir7rM7QkD4kb056MlAVbDSnTaiJBk0Z1ZXOpDgqFU?=
 =?us-ascii?Q?NU0UK6N7r0R15LNId863cK8HYEldvuAmw+PrUNlnjv5+rrDf3ygSND6Wa4O0?=
 =?us-ascii?Q?p7aEyoVdBWdDurri/axKsgTVo0qsMMRiIkFUnV27NcfLEi6WWoNckZHcVwrN?=
 =?us-ascii?Q?bQ/zzDT/onGrYFwKU26OdJ+N9xdtSXEEw1XVmW2S4eAS/yuZjewYPpnU8ngR?=
 =?us-ascii?Q?XLQWrnkzi8ERnhkKQE6C4mQES1zpYjuD3UQYIage942VRt8Ma7GbZjl2lmR+?=
 =?us-ascii?Q?9X1jElnGo2Nvj0In3ovEjOGqc9BbtoQZwV/x+nZQPdhtLrekBPMR2qNO26Rk?=
 =?us-ascii?Q?eEXWLUYezb9B3VQuphzmYCn0e5sEyLAkozB13VNrWcjmhHpajxPtYxL42DbV?=
 =?us-ascii?Q?63+Jila4KwKAHe1LLjP/81dKZ2KsEUNnJOHRTXaYYLy/6vRaaWRqijxfnJNX?=
 =?us-ascii?Q?nays+gRoHH27ncm0bBUTvuBbP6sfRsMMHSucX/hD1IZXxNpYpbi2ynkvFl/k?=
 =?us-ascii?Q?e2V2fgnpgBnlo7DK4kyr4IZGDDOJdbUGkk4B1k/xMYC6lQ8SK+Ms9ju2r8et?=
 =?us-ascii?Q?DPCq4UE0Y2maiW8sgnLc+bfWR/cz6Zf1JlbBv/qlcXlwFN9inZMFWuYjVFfr?=
 =?us-ascii?Q?c7wiTdgzFBSQh5rjBR6UkqHoQfORwQ9l6vgjjEz8FQzWH7XxZh+xcF71dJZr?=
 =?us-ascii?Q?hzAhQj7JW05ZORxQ+/6a0EOLir+ZnaWWG1tMiq3fFRJKnzTBkU4fI157gu/p?=
 =?us-ascii?Q?/N8sdee2O6TpWeWgs/vsBtlZXC6mHydPfqsY437WBRK5AHCtRnZVF9OhP9OS?=
 =?us-ascii?Q?Jxx2nVbdmBq/CChsAqIzlEBR5kBSlsGAdBBidXUpYdb3SBmgK32d79+LoS6A?=
 =?us-ascii?Q?QxeU6/z2WMDYX5NNxk8zb0qFoxCwaS63/v0AgVoAduS3ZsYUFJ+NmnF7fzgH?=
 =?us-ascii?Q?/ghOiTfi1ipHnkKUjCAehiaGPN4p3N58STUyGCsqn9iJamGWfYk5cupAWYfO?=
 =?us-ascii?Q?8h3J12TdhcP1Ll2KJ9gqqCVwoNMC8jaM1NRFx2qRloLj5mYBcVmn9uWApKFp?=
 =?us-ascii?Q?TGhQMwcfR2JCr3M/tDts1KTSjyllrtuaYsQrQe48Op1Lzv7x6aJqwVGhUrct?=
 =?us-ascii?Q?/23kDCJFxe6RWHv/H3mmKhkwOkZOHJCCT9rYcXZnJ/wzX2oKdGjmvyTOo90n?=
 =?us-ascii?Q?WZ9CBHLonjaG8VJunRDX7398qqj3lGifvxDFNWtZlbg3bwefJkiXcV0H1uZY?=
 =?us-ascii?Q?XaMxW2qVgiBf4abzWbskwpIan2zVUcyqvaUHgtK19O8MEfg5EGIDsy+tpPtk?=
 =?us-ascii?Q?xVP8j2Ked6QYD2DbNrEjnug4zodRe5NvLMbA0l8H3UoEcVDlK6N8seRgL3nE?=
 =?us-ascii?Q?JdxdQPGPJtpLNpxhzxLaAra1JP/3XZhYzkkONxTlYpqRx/dXSuLHgPRhMYjR?=
 =?us-ascii?Q?xe6Lb/U8PLQqXp9lelfZ6YokOHqrCIdcHxvQXZel/oY7QARCpF9GXudQEGfC?=
 =?us-ascii?Q?VQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da1f50ef-d7eb-4267-7658-08daa5682bac
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:25.5813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zKz1fT1oZmj7q+7YrBzXqrSb/Out3dXcJZ7dcqzIcCRMFKaGFluVASyjTCK9ZGdIS1FdpeszaFyrbi7rtI8km0cMJ7+PvITdOoFglF64VI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: K6rIl8QmtdrElOunhHnfiZDLcdygCoZq
X-Proofpoint-ORIG-GUID: K6rIl8QmtdrElOunhHnfiZDLcdygCoZq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This breaks out the sense prep so it can be used in helper that will be
added in this patchset for passthrough commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_error.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b5fa2aad05f9..3f630798d1eb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -519,6 +519,23 @@ static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
 	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
 }
 
+static enum scsi_disposition
+scsi_start_sense_processing(struct scsi_cmnd *scmd,
+			    struct scsi_sense_hdr *sshdr)
+{
+	struct scsi_device *sdev = scmd->device;
+
+	if (!scsi_command_normalize_sense(scmd, sshdr))
+		return FAILED;  /* no valid sense data */
+
+	scsi_report_sense(sdev, sshdr);
+
+	if (scsi_sense_is_deferred(sshdr))
+		return NEEDS_RETRY;
+
+	return SUCCESS;
+}
+
 /**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
@@ -534,14 +551,11 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 {
 	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
 
-	if (! scsi_command_normalize_sense(scmd, &sshdr))
-		return FAILED;	/* no valid sense data */
-
-	scsi_report_sense(sdev, &sshdr);
-
-	if (scsi_sense_is_deferred(&sshdr))
-		return NEEDS_RETRY;
+	ret = scsi_start_sense_processing(scmd, &sshdr);
+	if (ret != SUCCESS)
+		return ret;
 
 	if (sdev->handler && sdev->handler->check_sense) {
 		enum scsi_disposition rc;
-- 
2.25.1

