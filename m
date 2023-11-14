Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACA2C4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjKNBiR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjKNBiL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:38:11 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F651B2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:38:08 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNs3dD030162;
        Tue, 14 Nov 2023 01:37:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=3APavx0stkgEF/t2ZpDbC2c+AXMAWP50GezwMxmx/GI=;
 b=XFeqFupYiUYF8fH32k/CpKKzhuUYC0bwBhQJtTWdRzRPIZ8TwG1zfLf1ePWvtK1vuNT/
 MQduaW79634Jse32blA9rtgR5668ipySn9X+QSzL9HCpPjPEWTLhm0WF3f1knWaMMgL5
 zDGbJi2KwE6vB+EhtL7z4eXbXEJrwRYNgqQP5atxi/pOFX83n7V7SnihgB7QeRSUEa33
 A2vtMLv1325D+cSOvdX+gnGYUmjougvM0TetCUq9EANqFHsOS37w5DgXLsIUOVIOP2Md
 qmuSpe3hQ7iWFbhf9LZzeZGIP0NZr1hAr+d56Vl9fWquxXWS6R4czADtdpSMrlhOpG0v Sw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2n9v56m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:37:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE19n3Y013669;
        Tue, 14 Nov 2023 01:37:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxj193ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:37:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYglTnTLRH1P+fYtYh6bAWLhCeNUPqeOTvagsoOjVOX5FUTnYfspoBAjoTIJgV3ViIl+W8wGlimXKEetLbVB4IjIHxH7jojlwlD1dgReIz+OTkHCSRCvV3p/Eoxh7YLA/pQeeHkM0nvP8ob44PR7+pj0Z26bU4AwGhM28VGgzNp10eiVkazXqyXCC/aVj/6jBzTPVJlxaKd+JFs3ymyDgPlculjZ9GQyJYo9lwwfUMFKVd/SqwsXwfybuyl/WzgUUoKRimHSn1I3c2hunBdo0rfhrrnagrO3i+IRulRZz07QbmNrEenUOdJBdpd2X26/qDrjc5ILUySJsQNf2gzOSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3APavx0stkgEF/t2ZpDbC2c+AXMAWP50GezwMxmx/GI=;
 b=gfNt1wS8b5lZkpDSfXhsWnN1ORVxCFTPOTOp3dC6/dMBcawGHXlUJv7qEvkAWUYswa9RLVi8Pw9zKq7uzVKtDml7/MwEVxk3kfvtjzY2fAwtLp/6JsJxZSP1hjKC6zmf0upWS4DE6SwuzAMZJGQTlNBl4gHKGTQxO9RJlnt5uFraFCAXlAY+ESN7ElJDuRmqUSz2gXSxYpY4S6fFkcQXTfG93nnhiYEM2jafDthQgs9oCcNn3m7Mh9aePEJR5KKrRyhmQ4Jx0XXgDftoaljc8n7v9JOjuzzZetG+qxvFxUqiicW4kwZFUVf3hSvFPF0LPIWg3rCbl7B+qCP2tS3QZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3APavx0stkgEF/t2ZpDbC2c+AXMAWP50GezwMxmx/GI=;
 b=bZCeT7koujN7LYvh8SClB5NQiGStnFtYFnnaF7aLpfJ4Xx13gWdv2uMQcaAvQ6NEX1T1fXgTbaOqgFR1RXmnMDxZsKpAqvBrxv1tjUjO3quO6qNtUnJ4DIwo+vSHf7r/Sir9PR8TbbDjMOtL3GubA+EJtPqfowrCvlUiKWvruls=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB6752.namprd10.prod.outlook.com (2603:10b6:8:133::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:37:55 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:37:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 02/20] scsi: Have scsi-ml retry scsi_probe_lun errors
Date:   Mon, 13 Nov 2023 19:37:32 -0600
Message-Id: <20231114013750.76609-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:5:bc::38) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB6752:EE_
X-MS-Office365-Filtering-Correlation-Id: d14ea054-2e1b-4eb5-a63a-08dbe4b25309
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7T0oHqQoLHBnflsHQfq9URZeteN0e51uGAzn5w6uCNJbe2ARS7uaSjffev8mf+oanXpyEj2vv1c6H45azWIhglEei51obbOcjiUpcSQAj8Q5dKnb4tQyPHzOa0YYfUdZNC0r6gy3/QGlu7jA84WgfIyd/htDDBaadCdM1Nvh1CyLfXPNOZcP1HbMpDcMP+cprR11q5VVAEC1u5FoYdOkMI7FAHddGQCkJ+cZ+qriTzE2YeMz2U8BfEs89xWrPPWDiJNZO5HQ+6xw/cjy8CiyGP/Qlru2ldB0kyMlNXiHXqhxZXfJNSgRGWrNou1eoIHUBSDNHw2YJ0+fI1snLrQUhIZRTIdAG8MJbx1SgIx88kA2zDzfBmhLvGFEAPm2OS0tPUq6JWfvC3ZXg/6ZFjo1EZ1Wzt/lfoxB1Ly8dMrOCOJaOKe//z8Cv0Vh1LxguIQvS/gVRLZ0k8NVTlFzaoiI3jA1InsfxUY8NvuaJ0/ph5ZscpaKeAPFzWI5X7qHQYJ9soBL90LG7x9ITaV6U/A2OE0zIg/QGaLX/Qyfy/zIFexQT/YEnXdXvAbuPKzxmvWB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(376002)(346002)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(1076003)(6666004)(6506007)(107886003)(2616005)(6512007)(83380400001)(4326008)(8936002)(5660300002)(26005)(8676002)(2906002)(6486002)(41300700001)(316002)(478600001)(66946007)(66556008)(66476007)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6cWm15si1x4fsNH8Yo34AyufUQjBLrSlrmk7oR3c1I4m9qoaI1fmJ02Tj+2D?=
 =?us-ascii?Q?xWGfAuXPNedipi83vIQJWFHOuF67hGz0kcl5rvWD54tEXAOC6onCyzWhISza?=
 =?us-ascii?Q?yB9Clt2nf8qdsntpJVBQL5aeH9sPV7Rdt18DMZDtKy4jibpIKx5HS06KnaGw?=
 =?us-ascii?Q?OjGRRJDFnLdYr2xMdGcC2kdyzowSWF0u+hZbIGjQuch70SYHupkqkAUZ/dxy?=
 =?us-ascii?Q?fvv6tbDDqScI5qKs/tQ2I5EPH5CrknftoNT28wINviGYpanH+GMSqeJ3W793?=
 =?us-ascii?Q?MdnHA4WplIIJlUntKNx+R7eSRnpOGpjTBG3zRpsbBDqSNArT3a69V1qibQOC?=
 =?us-ascii?Q?f9bHxv57xvqJefwmFyNc6dF4KsT0zl3ESN7dyCK66R8eHzfRKL5QzBjAY2Ji?=
 =?us-ascii?Q?mthYEprK7hFguIYdWBqKFc/RIFZYFBHtlYVcdxlwWpXW3vSDj03FedatARH+?=
 =?us-ascii?Q?mdjf6vQAbaCCVLg95hAqZ+4f0Zjqd9h5aO5fb6ektfe03PKSLSvjubveHLFk?=
 =?us-ascii?Q?QywB7DoRUR/K9fty6QYK8bFmXcGIWxqFhx/0ojsA6CyYL50HnrPic32TXYcZ?=
 =?us-ascii?Q?m72SQMPlBpSXtnGGd4TErPqch9jjgz2cIKHpJ94XHYWgMtH5YWDWbnudPp5U?=
 =?us-ascii?Q?S5gx7YKS41U17D30OPCIfE5UXBlHGELtrDNWzYl4dh4Di9+URbqFTQlRNEnh?=
 =?us-ascii?Q?g3c+LAucx4uGrQ5ZU3t2BAValofKmu8ACF65smrpXa2JhFHrUqoOdPdKserT?=
 =?us-ascii?Q?L9wDmSP/Is7AYu7NpTLjfGcUN1oF+NkLGo8qLHaeYanB96FkUnho5VufamIT?=
 =?us-ascii?Q?LG4v9cDu927NBeX9M70hCXfFs5al2kBOEKOfZ1GImE3/DL213bq/P+t3AmA0?=
 =?us-ascii?Q?nvSIW3sZ7xsX8jnea6L+LIj3Y5v9O6cYl4UY8EzxriZV+aI0R9hDdgGZHGjK?=
 =?us-ascii?Q?bzsr1T+bx33qlRM6mfkVzGA3CQFotXROad1u9dX83MEUSR0OH9BENyk1ZBEE?=
 =?us-ascii?Q?h34Y11EEB8kEGCvBLRGj9vc0g5Lj6wJvwsFz85kXGScuqtCSxDHJh5SHPMWA?=
 =?us-ascii?Q?aZRqWpYshuorf+SOXBEl9PUJ9GpKo0JI/Tqg9iF2hsEhp8mVR9EUPypJWMbx?=
 =?us-ascii?Q?A3Q5rKR+uq18kL7GlYUD0ZHBj4CRGKABf7loBVMmzFg2xMke+c5X9JPuHDOM?=
 =?us-ascii?Q?NvGmU6XJp2Ow+P66rkD+yFzcyWqHOKVjY3XtzRwoHNttjYqo340NqtPfAu7G?=
 =?us-ascii?Q?qpbmT4RtYXIHz90qiux6n3Z9q+8oyFqBC82O0sbXyppu+tXGO9b97igXcbiO?=
 =?us-ascii?Q?0+aRwco+9Zwvs4cvnvottz4kBWaAVWCc5e/xRJWMjgwjagay4wbF1OIfxZ97?=
 =?us-ascii?Q?4pzslU0QDFPaCzTxY6+POZQhzr4ZuhJqHihbQMAdL5pPWEXWzlYs6odi5/LB?=
 =?us-ascii?Q?w36/+/3T3X7VEp2dGnuZAxacgeeoZy1jYMs0hqqvYXRCaZ6Y3xm+2RQR0vcM?=
 =?us-ascii?Q?z+apU6npI2akg/tGlKGhRQ8YvylO2tVMbDMkXfbmZpCkxfF9rIHqTxsS2X4G?=
 =?us-ascii?Q?1CyIW072ELMewxsI5ZopY77QrTUh1SdkJn2ctjLlHnPOk2DdvGGe5eitHXoM?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SCqauVOWksc4/PlK3duHQt+GZLWO9SAYqq4uJA1L2lHA2acmgoEReW4uodMm7AVxrZESWe1pw51RoUpfLgmlHX0eWHqJcOXeI/FDNR+LuXRUR7CUeGxLBzD/ySwJ9U9M2gzzjfySuRHUwMOaOfkf6pwSnSonO+RMp56YBKQkonnoxlGN2qHAfKBDTjb1At8cwD2cucb2O5+h6Jo7d+vP2m+4pj80vfsk+83LPe30nrENcV0tEKbvjjDBRQCY8yl17c/qGO3G2x2bs0pZDgPwdlXbJpqaOBVgp1vnnt1fGY2adTgdn5gHnZOoX98Chm9nqvtb0ALLY6FNAco7wpTiaJwXLJzDbUxqyL9TjY62zQ3di3C/lPGNeoG9svlVuMcDaUl/ZIJJQWjqMsqwYqiSztOrfhQub9A3vM0aDEJyw20znu2pkEKNDNe70VJQaiIq2SKr9kyFl0jPCP7rlYz8VCbDxj55YRCN/gvf37Z0WIVBWAfAOe/QwVcCnjo8pqnG2U/Vs7b1Ii7oyU+491Qq6sf4QbQVa7OWfCwY2AFo7LUqszxL9aXyPAc3r/kKstCepha6xuzjnWUs9ak44/KrcnhAWQoX2ecE9PHlUy5cTCoFFSONtfNPqeUholla8rq13/j6CrnydGJQzsw/ammVCYIxLhJ9IKfu15MebV79/B9AM9/WSwxrqrBNmDdJ/oG2OLk7IZafnst9HNhl9zqEmDkIJWdxko8VpPDxxrGg6Tm1ny+gl3Qg4hEdDvz9LIp3pYCAtEFaNze+Spn56ahWTVqltgGeR+rgDZBDC1ivIaEcm+a0zn7RhewfByFFu6g8NdN6SrnslcnfRX+FrLQGZBPuPJyy17m5DQz+LSi72qikiOl81UvedNIK+98pNqwb
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d14ea054-2e1b-4eb5-a63a-08dbe4b25309
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:37:55.2577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ni7hAJirMn1gSPgT7D/Qow35erihxKPqWkX+rKW9A31OdIPcZGGmOoy189gw2ioOaHiYw8aOKH9iQg943Uc5HeOL3HqdkmsXh1q94RW8Q3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6752
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140010
X-Proofpoint-GUID: jLhPl-Hre1oNUvtqIiaWJtRi6NogCPa2
X-Proofpoint-ORIG-GUID: jLhPl-Hre1oNUvtqIiaWJtRi6NogCPa2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 46 ++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 44680f65ea14..eeb53c28581f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -626,6 +626,7 @@ void scsi_sanitize_inquiry_string(unsigned char *s, int len)
 }
 EXPORT_SYMBOL(scsi_sanitize_inquiry_string);
 
+
 /**
  * scsi_probe_lun - probe a single LUN using a SCSI INQUIRY
  * @sdev:	scsi_device to probe
@@ -647,10 +648,32 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result, resid;
-	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		/*
+		 * not-ready to ready transition [asc/ascq=0x28/0x0] or
+		 * power-on, reset [asc/ascq=0x29/0x0], continue. INQUIRY
+		 * should not yield UNIT_ATTENTION but many buggy devices do
+		 * so anyway.
+		 */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x28,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.total_allowed = 3,
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
 		.resid = &resid,
+		.failures = &failures,
 	};
 
 	*bflags = 0;
@@ -668,6 +691,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				pass, try_inquiry_len));
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
+	scsi_reset_failures(&failures);
+
 	for (count = 0; count < 3; ++count) {
 		memset(scsi_cmd, 0, 6);
 		scsi_cmd[0] = INQUIRY;
@@ -684,22 +709,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
2.34.1

