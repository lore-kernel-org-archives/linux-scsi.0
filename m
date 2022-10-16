Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C979C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJPUFe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiJPUFc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:05:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4346A31EF2
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:05:31 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GIrcaX019532;
        Sun, 16 Oct 2022 20:05:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=/DboAJlV7RjsQFvZaceA93eSufe7uId8X5+i5BkU5dM=;
 b=IJktc66ekJ1MdpkXz04UYP4uFhhEasgTAqlRAJ1AxwxwqfSlGxXYw7W0+yXwAOGzaCm0
 uzchUYryYfxeZo5TAVHO3E7Zq/8EZivcctxhB24vl17TZ++w5FJVPynpWB1VMiULWgdU
 sOIfKOrJtAjPT5iFAj8MlxqlQWrinlgqbZAGJyWBj3ZoXO4seH97G8am3pfKeVie+xnv
 NIC7Ix/CnFjBuoxq8R2oFUsTguWr+f3ID9ZM3geTnme+UXOtGOdpWWCWXzSXEZgETDNp
 KNz57TWmH4VKLqEaYRB0JaTybyDtKdEA+V0EQKJz/Dc9hYKtT0zBgPu4gbr/ol4ce2xw CQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7ndta6ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:05:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCTWXW040718;
        Sun, 16 Oct 2022 20:00:22 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0nc1jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XY9n14TcHRceqrCA4FquScsqLkCJIhIqAZ3bdHJa5+/cdtWmm0vF4WSkPzwiHfjfdWtkZ/4rJhMeCmnHjPUPGNJ33LuZTlGMRMQDpaK0IOEPaZiRONVgjBQQ+Mq+vPD7D91m7s7eGZdNGKHrNWHthUGoPsCPmSSYKm5qglPRCG+ZQ6mNJivwV1xyvpdnRO0/YOPdx1bsMTHnksVGfEyOFZb6HCYKDYMZqw77MbNXIwRcH4o6cMXQ8P26QHhZImPBY16E9Mxl1ttgsd+ZCHamoAciAo7a+lh0R7kKuyR9x0Lop9AJ0J8ps3sF45u15UzJi70sVjviifDwu2rLc4wk1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DboAJlV7RjsQFvZaceA93eSufe7uId8X5+i5BkU5dM=;
 b=ANzXbQHv4jPh4xtxe18qVSO3E1rCy80OnHr0kRWxyJ+Qur+dVZvi1akjBiNqxydcVDOlpp35jwcJLkz+pssCjcsTnvDvo/uxljGGu7k8970QnCxFXkJTqXiGn4QjflKnCi7Wts5R+QtR4ur26Q6uWNltl7q2gSkKw6A+LMoaXZWkp/ofVef593XQgAap/I5T8yYMbewWWg58JFJO5SzNqbp4oJZt2ASPj4IQKpS+VgGXFV6goWhQjENGovbHgtwctatEnyaJQCw8OsGMi3NJrIuEeNxYQfRYTt0NyqGDDuI8jSJXdyG/Mg6FapuK8EcW1yd2VAVGl549UDx0MemIbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DboAJlV7RjsQFvZaceA93eSufe7uId8X5+i5BkU5dM=;
 b=Uw9mORLlRJns1/31Epv3RjksgSmmuNn45kBwMZy6oVPsoy/vuCt7nngwr6/LncCirhh/v6/+qdwHeghmBhSwnTQp2Dljnbv6zQX6D9cT16QQraUWGQZ1S7wtt17ccD69MhlS3uJiJ3VxipUc8Rvv2ShA1ZG6hFjp4FKSc43q/X0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:20 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 20/36] scsi: Have scsi-ml retry scsi_probe_lun errors
Date:   Sun, 16 Oct 2022 14:59:30 -0500
Message-Id: <20221016195946.7613-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0111.namprd04.prod.outlook.com
 (2603:10b6:610:75::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 4151189b-afac-467f-cab3-08daafb10def
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hGszl2iTBni5CDQspSnzfWs6nEJ2UNagVO6cYQo/ZJKifFFU3WbkbcsiKmK2TSUY26+bF6sD1woZ18/hIa8H4sDYHOmHI9kJAdRsoBBsnDGJyMUYQmFyyOhJbvnv4TLml6aJ2fUkN6Dm77QidyPdfUpfdEfytIBxluFJJCdyvMRis5F8YnI+HYCzggPNpwejmcgJWctjDdJfKUyZK7/utl8Yj0iPOq9gSMX70+ou3YpKfDIMRqIjkJN2Ld6M1nUy9GS3Eqyb0NKs7Kmi8ms15cFDlLCNQS+yHaZOaPxHgoxN9vn4xY1RmeagQ11SEWJL7jra2+oFwR+40UaaME4+Gp0l5qtEZCeBaGFIsiEVFwcQ5jei3JzqV7t/MKzjH8Vl3mUUSNmP1TFWGCBewXmlEFcoPTUvzC3oGhHZ82UyTzosDI7oizSTqAdvn644YwfIXUfO3SQ/I1Mm27QXEZ7x7jtlLvT6L4HAFYw4cxJZj5b8ysjYqYOhOf2oNRJvDzn5PQUYJjkWVz+kLUQ6what5R9wgq7VaodJIucex5yrwIlE9OkKIT2vgAmsyFN/rv/SE6a6PsY+kQv1lrkJcMKSrk47ygT4E1jswakQGxrceCMtCmrfTAxHXnZJqrnHm6wR/0rR8XweddJ+sLYg5wTiw9B+bub4OD5ABlEOOA4NXqJPi2vDfK8OsCdiGyERrtBB5IvlM8Eo1HoAFOsCC/Hgbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7AUlhwphasHxX0kT3I8ybTrADTSdKs6veElbv8N/rJVRbW63RD9a7Qq9/nJA?=
 =?us-ascii?Q?CguKjkDlbw9QcQOyPHooJe7Do+lCTonLjHZ3/qkK73m6KaK/MMIghjiSugg9?=
 =?us-ascii?Q?+ab2Syjxu43fYLLSKKc1Q5w8wsghKhSKAcN3dXOrIRLminsgDjqIWckBw6Nl?=
 =?us-ascii?Q?hKJXF+tYHwrpir57rrpqDwTAeMlQ69qUcJVDn5AK08C9rx+YUgMWGldKXEFz?=
 =?us-ascii?Q?TEM4YIwszUsy7B6ol8zSMpitpFfU8GMg5Ei8CO1O+S9JrXmMLMYT3NiHj5Cg?=
 =?us-ascii?Q?2BPczLg4zKQHaBuqm3Wwn1SBWzJePl5iE/UcK0eMZR1a9QGWx+N9/LkA2fLT?=
 =?us-ascii?Q?3lZ2BzqAconeiE8syKn9HVM03x0UqthKmLadVdoVIY89kywtIk6s/n7WxRiX?=
 =?us-ascii?Q?gv47DiIeKFg29fCDO58mxwub6S6cidFQGg61kzxeN4zwn+y1/rmiiB878OTO?=
 =?us-ascii?Q?ykvYxwtdGq3v6z7MbLY+57Us+0Ciajg9r40iIaHvtjUC1AFSTtpAtdeBGWn+?=
 =?us-ascii?Q?IJMX4n95dF6uif9xvts+yMu48TTtkTvZuqyAnysCjhk/29ResbfPdAD+reci?=
 =?us-ascii?Q?Em+TaU7YW9VXxKs3sVYqkOHRw8hmVkvz5X5EHe+0Cu8DsSo5fwoS2d8GVp5r?=
 =?us-ascii?Q?B4hBdc2jolji3KXq1olPden3kyFVJ1NK4P2LFwIJU6OrfNUO6pZ/H6qRD39U?=
 =?us-ascii?Q?gP2wc8TyIJ2inPU2dcVakX9Lr/CDiGVjViok+FOWgaRi4K2BYkjFMnlncU4l?=
 =?us-ascii?Q?/0srthmBCW1Gac9elr/toKy5XDjbYA8pgZu/u4KLWrnUbkybZwSeAyltD/n6?=
 =?us-ascii?Q?68koncQJuwRbTUSsishTXNimJgEpevFOTKfZX6QL+Vi1UHnd2Z/H/sS+eEDF?=
 =?us-ascii?Q?kmLrESQdm708zhSXL+neGamb4UPsGC+ZI13QLQ70wFuUgPV1nj+v9HWM92w9?=
 =?us-ascii?Q?fSfBgDwTHQSt029X3bkltArdnNvbg1gMbJ570PfyTfTHTw6I1ptS1ERhEw1l?=
 =?us-ascii?Q?9v5hfs5H2I9t5RZJqsIwdP4pswvm+o+FPWVCRLIHOIqChAo7S1MLo3f20ydx?=
 =?us-ascii?Q?uLeQRvn75Qmk0INtxgGyacDQ5DUpB5uCHCC4Q2pn5C3KxOYZfV6VUL05hsFP?=
 =?us-ascii?Q?b35+qtfi97R0xJDmJM5NkbdmOBqPz8RycTelwArXonEEoeJRkNvrFp8Gnj7E?=
 =?us-ascii?Q?QaymhIJ70kB1k8N36VdwYpoLt/ergXZkHYf/zzxn+up+0Av/XoS1kE2pscS1?=
 =?us-ascii?Q?EjrthgdWbo+oaNTyia/FbEu+9mtFX2T/BaqMShCqIZbjsfPNtnTLlndDE/2x?=
 =?us-ascii?Q?8B3ivx8CKyxqSEw9N4aI0qARVG0yb20Fxjj1TBhmnMFenHfOcRCEsA+Cmo0H?=
 =?us-ascii?Q?ULrxYGxV4qWa0VDcVsg08Gp78TSVN9N/tbIjwHsJ15mAOVYZYpN/U8u3Wc01?=
 =?us-ascii?Q?nd5RETIdroFxugxlkKA1DS57igkr/bx8m7AzVVP7V61o8OINySQNWO+u6MMu?=
 =?us-ascii?Q?oHamOO7+IeZSjFyPUwJXCRyFMZoACbBhmGSxsU7zLHATYRk7cySiGCFiGf5x?=
 =?us-ascii?Q?WfcQTDOmtFc0ar1/s/AG1wnSkaMRLc/jfKch/M3mY13CxYP+xdKvpN+7s+gS?=
 =?us-ascii?Q?Rw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4151189b-afac-467f-cab3-08daafb10def
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:20.5331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: htqlSsJEfcX0uevRgMC/iLJ+BOWAxEcp0gjMrp8LWt6Q1F8e38+wWB8axstdiFnI4qovpGTCSKnLAik537LVWLy1JP6LeRUgVfa9zA41jxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: i37BIzUBmuy-oTCRaOMqoPDnbqLIYeoB
X-Proofpoint-GUID: i37BIzUBmuy-oTCRaOMqoPDnbqLIYeoB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 51 ++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 58edd5d641f8..ffdb043bda5f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -653,8 +653,29 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
-	int pass, count, result;
-	struct scsi_sense_hdr sshdr;
+	int pass, count, result, i;
+	/*
+	 * not-ready to ready transition [asc/ascq=0x28/0x0] or power-on,
+	 * reset [asc/ascq=0x29/0x0], continue. INQUIRY should not yield
+	 * UNIT_ATTENTION but many buggy devices do so anyway.
+	 */
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x28,
+			.ascq = 0,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	*bflags = 0;
 
@@ -671,6 +692,11 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				pass, try_inquiry_len));
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
+	for (i = 0; i < ARRAY_SIZE(failures); i++) {
+		if (failures[i].sense == UNIT_ATTENTION)
+			failures[i].retries = 0;
+	}
+
 	for (count = 0; count < 3; ++count) {
 		int resid;
 
@@ -686,32 +712,17 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 						.data_dir = DMA_FROM_DEVICE,
 						.buf = inq_result,
 						.buf_len = try_inquiry_len,
-						.sshdr = &sshdr,
 						.timeout = HZ / 2 +
 							HZ * scsi_inq_timeout,
 						.retries = 3,
-						.resid = &resid }));
+						.resid = &resid,
+						.failures = failures }));
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
-		if (result > 0) {
-			/*
-			 * not-ready to ready transition [asc/ascq=0x28/0x0]
-			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
-			 * INQUIRY should not yield UNIT_ATTENTION
-			 * but many buggy devices do so anyway. 
-			 */
-			if (scsi_status_is_check_condition(result) &&
-			    scsi_sense_valid(&sshdr)) {
-				if ((sshdr.sense_key == UNIT_ATTENTION) &&
-				    ((sshdr.asc == 0x28) ||
-				     (sshdr.asc == 0x29)) &&
-				    (sshdr.ascq == 0))
-					continue;
-			}
-		} else if (result == 0) {
+		if (result == 0) {
 			/*
 			 * if nothing was transferred, we try
 			 * again. It's a workaround for some USB
-- 
2.25.1

