Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828C2CCF9E2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbjIEXZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjIEXZL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:25:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81B79D
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:25:07 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MtoWq029259;
        Tue, 5 Sep 2023 23:24:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=CdfSgUxES5P1/GDzqlLq7p9aFKGHApjxNDVY3BFU4Gk=;
 b=GZoBrn19ZHXlNXNa3GC4KJqLKZVZSHYzmGeUOCh/INFMzPVenzHvESB3JZlOvzBUUO3w
 GLeb52UY0HfITxSnm4/1BlxU301HB92+vOldX7w6eqxgG6gc0Jei5lEaDS6kzX2dVNY/
 dqIa7WtSSr38i73i3Hmg45LSXDKSkJxVG/FSiZS0ry0aP7vpSws4Jrnwpv1NqGG9M4UI
 Pg/fzxdPPlcfMjWnX5zUoIM8i42Lol55nu1pnDZdtM63ZOIPaewyl4tZu+cZ6CWF+OjP
 Eua5l0v4Renfdgf2aPYGB6Yh9zkexZLSQg0Oun0zBk1u43IofCumeGWM6dxydf4wAkM+ Vg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdj50183-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:24:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385MQhTM029162;
        Tue, 5 Sep 2023 23:15:58 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5dx8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:15:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cl1+kIWKgPfaGmLoTyqysFsL0+BsrR/NvDyLiNmOGctkZIos0kJ50nQG6PQzg6QufECCiuSEEbgmX+UJsG31t0poKfC+5QByxjHIdI7OJBZ7Sa7a3IJSiVX4zziAlgmAv4dfyMfls1yeboL5jZhdrgXffY/qJ03xA+9HrzrbiE07kCpS3InIBuzWVaoU0ps6CTP4sYZbr3Sm7GCcf0VMnOqrxHc8+TKHVbQ83JeEvDIHtNxQs+ViLEmwT+OC/lZ5qIMhqZRVB2XJZBzfXc9QRZA/eIAMZtv7Y3ywOZu9E/DdltyLZmWYqLwv6iXXM4ZbYh59wNsakHw9jyuA7ypI3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CdfSgUxES5P1/GDzqlLq7p9aFKGHApjxNDVY3BFU4Gk=;
 b=Rgh4gnJ/isXclymHyFiE4HIz2YkyuN5ahzXcJ3DDHD6sVKws8Yl9Vg2hf//6GGlsE6jRnDVzaXzIqp6JiCcipnbe5YtXcDXeHU3gGvaldZ178kQsHkOyCzSfVqa6EuHSKAvXRwtya8B6ID+/sXUZdsjfqEJ2+TijwQKpQyBpu50D+PYQo9B/3ap9lSud9mmWBAL1OTBUA0QxEcZ3/ZJ3YQy8fj0OKHzUs2zT6GyTN3pmEavMWEN7k95WmZNHudQ6u4lXCRRGUSJBxgL8AK/hR5M1AngYWJ/6w/SwkEJXo6QwwivQUjj2xeoec8L1pfnLErcaQaNB+Vaw7Rm+RpUcbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdfSgUxES5P1/GDzqlLq7p9aFKGHApjxNDVY3BFU4Gk=;
 b=VEK8GtfdXrs1D/rTKxCLtEcn8pYUaTNc9I/SxvfOIw1VUNmATPy2KXfuWBgDPtMR19pYe42OpY+b7rv5RnK7C1OX6QNoU9uUZbhXZf6bu5PmW+UhONn1NV546JgTgA4dISTseQjfWsWp9S1w+CkUQEL8HnfcJ+x5tRdT7bXO6bo=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BLAPR10MB4849.namprd10.prod.outlook.com (2603:10b6:208:321::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Tue, 5 Sep
 2023 23:15:56 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:15:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 04/34] scsi: Have scsi-ml retry scsi_probe_lun errors
Date:   Tue,  5 Sep 2023 18:15:17 -0500
Message-Id: <20230905231547.83945-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0150.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::35) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: d0cd792a-349e-4077-083b-08dbae660e53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LSw7nfOvyB+noZu63IwoadHoWEbuXg9hj+y0Cqigl9/cNnBbM7wSdiKkhHfDHzKZ107ADBsOyyNsk1CycDfSrqC2k1Qekv0J51mx/q/ttEhdY2zeZacdr5LhDlu0yPqwZ+0QFx4SZ642N4hXGOyur04uBp90ysxtTKYi0e/MTk1S7+8X53L6PkdzPfGQaCB6Vt9lkBeLZnvJGOYQfd5iE0HH0wzLcqUzd1eA/qsbMns02Vh3lm0UUt0QIWatLbCYhMbiQNmFwMK8Slbh40Dq04VlJWqnDEaeHvC6JjpBbqOCg98lDhcUB4VXZC9iiUdr/lGilG4TFRlFsHDVFMrjs+cZE/xj6SA4X04wdEDLCdOsn65Fdiq2hdud3IvQKqOO9Pcml+A/niD610k71FrddMfib1bB5KAHPfj0gbLmft2TSWIjWpSdKcP1MRcR65dP1Zl2GiChZotY/tv0RydapI0d1AVjbl4FbLUQ/oblyKmOlej86hai0JscaEINts2wpnThGpO+q4hYSaz0qU9RmuNIoeQhAxSmnzGdbtjOgNfyXRnL90Bj+K4dABoxKMd5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(136003)(39860400002)(451199024)(186009)(1800799009)(41300700001)(36756003)(8936002)(8676002)(4326008)(86362001)(38100700002)(66556008)(66946007)(66476007)(316002)(5660300002)(478600001)(2906002)(6666004)(6512007)(6506007)(6486002)(1076003)(2616005)(107886003)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DxCLeIu30edf3t+U1Vk8muTZnMPkOS15TiTyIr8VgbEqcJk/7Sk0EbAHC/l7?=
 =?us-ascii?Q?qFgwjEKE1EgDKODoXDxWhur/I9gYZIszZNZO/ge1jvLvOnoqsj1MP9S7AAYH?=
 =?us-ascii?Q?lyDAOKvN79hrO9mcMhGz946x9GUNE+iv4bQsCfIygmaHW2JpmpqhW40nsCWF?=
 =?us-ascii?Q?1WmQviuq9psH/7WSvlEwAgpA3IUhPJOXkHmgwDbJuqL9w06EmjJjL8HmwlNA?=
 =?us-ascii?Q?bDHKwlBL+cQAMoToDyM9nKAqC6nVxunrtVvCnOGlMdFeKd3G6T/S1DpVkZ/F?=
 =?us-ascii?Q?UkGjYZ3PRaa4aVfyjf1O52rYqHPuWmBfdXjiZZIKPwJg1rCwny7aaVd7msxd?=
 =?us-ascii?Q?Wghh2mWqNQ6D4Zz7za4aTuF70uMQ7peikcGuZT9hW6aBZwrXbXye1BXIdrh8?=
 =?us-ascii?Q?d3wPUOpcR/ZXIqICJfH021JSkMA5c1RAKSMKYyH2jZ6M21ezrtqL6isx3xKu?=
 =?us-ascii?Q?nIxSqVnXIeRWTEt0f4YCO+cR2smaii6W5SJfJIfMuZsSvnB8GXzQ4dOBt+59?=
 =?us-ascii?Q?LWIj+NyJJXw9NlWd7T06WNsicxGHk+Ga+U3LMKlO7KlDxI1yMkx9086l5t/H?=
 =?us-ascii?Q?UtHxPjN8QfwIXbDGmusp9I2duRBEhtqwBNcixHO00VWkHMcms2JlMZwskhgL?=
 =?us-ascii?Q?NjFCDvLHNIhY3pglubMXXgbNrEMIU2n04UbmA6/r9o6STMVQKzrunKLy4yJL?=
 =?us-ascii?Q?upahY23XIrNlSVdoE9OB2h0FbFskf/oELdmRRHnvbKFk1C5BmzMWiwR8Limm?=
 =?us-ascii?Q?edroPbc2CAgZxtXrYT5sDKzsDHoVyMYPOiGjfGjBTYtqS1VjTOcx/vyrasyz?=
 =?us-ascii?Q?nvkXjWaPxbhY2FeJC4xwCh2LVi+N60whnvVU3VuiVeAXAGgVQ0TzCnH3eGD4?=
 =?us-ascii?Q?Tke7e3iOR321Mj2K1cf7AD1Z6PRCx6Zk0yLMMM+tqbduK+9ED64cbszuA991?=
 =?us-ascii?Q?5RxrNB2nSOCnAFEzMCeuGKCXyYQlsBUoqQezr192H8OU5BbKw3igMWvQKnOr?=
 =?us-ascii?Q?YWT5O6d8QvBv1/lEaQE9HEp9ngnMXEnJOLz41GTnwwnad5hYlY71BN2A8TKa?=
 =?us-ascii?Q?VrqBr+zKlO9zt+D7fXyrTrlZWUezE6DY3KAiHflPW4KulugCMhFiwQmwPZz0?=
 =?us-ascii?Q?Oc+Hg+p/QBPZcHs5qXwESwt+BogwoHiA5Z3oDUeOqcPKOA53hpKYZRpOFNcm?=
 =?us-ascii?Q?GxDRUxRj0a6Dezg7tfL5cxE/rdcyn+jaocdHUb8EBZUkYI2/vE5buaCR7quJ?=
 =?us-ascii?Q?WHwXXx01Tywwa8exEuTABD6jeKzqsVEsn1I0tf0PtyERLqgA14aHWKdrCYgP?=
 =?us-ascii?Q?ioFtpc8J0icp/wuldj4l7onpOZ3KFDMirEnGGpseqkwBKXy9wH+ggi/BMyD4?=
 =?us-ascii?Q?Dk99t553Ck1ST01ZHKoO1OOZhVdd8a/Z2sa0XrVeF7u6dRriyegbMQrWd2rZ?=
 =?us-ascii?Q?8IXuhyQpLv3bw3k4ksdqg+n9p4GgWYoty48qfXKmPFzs9ATIIEX0cOA8Lu1o?=
 =?us-ascii?Q?TwkD51mXTrsK2tTPUS4OBsbK4aUfS9RNyyFo/VaDKPEnRWKXSe49+lPQbyNF?=
 =?us-ascii?Q?7yMUKOvFH+tLkCpCikwI3uTSftOzty4VvYOtjcYDJZ+PiHw8ro7GBnUuuip7?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eYeVGQBjBHiUv+GRjwUwNl+dpvoQtN0eRevj1YYlWNInzB0LYv5NSYjhqu3nMnEllBQjhWsTlKxuWaVD4cna+9N5uqb5i8Y9uSaK/foX6Sf+g3VL+kPkmRrVg9A7VezwXwcsUA8wn/LmRWgC/PQl0Lo4rmTbElB8o+3pjFBlUa6bINy9bBNMJiy50PbiYamujd5daJF3vA5AjmdjK7AJiOJSLbtCZ6rKxOF3tq3D+VeE8FwRsQq4ckuVd24T37M5lc9TW5wXIy+apJ6/i0soVKvkYduOpXp2Gd4AkpLRmR1GhsNXaSWZFPGZ46znEsN/EUkzIFMCdrFxrxZje2TlhGmH3kNiMTeKbNBHqpSkqdPpKXChWAdTJniekFTVkI83iOqD+K08Q4gdznyX0+vumbg90/z1klqNZqcm4VVk11NbkMP+jk46r48CperpScAX9Nsv8AFw/Coe0Tm+YyWDgeInyeMi5ZURBcnVVh9XX30goKot2ohnvcAbt/grHtukWoILgsgtlgQCY0/6vioVY25sTqEv7g+TY72V3rFDB/Y2qd1/LSXF5gCX6i+TaDH+MCb31sZicmV4JAXFsjgwtbtFSc9kxjXGaHQsCgYHjWsw+fWmpiKIFnJf9MH1dDGvSlGNsf26fvUphjvZoSZy0/3Wf3fedSRC5kdxKQj7j9fLUmYR3MlRQct7422Rqw6gesT2ThP33LrET28AKL9Oq8s3vI+UlSamARZ4rsE81rjpekqPG7SndPHVDWilJf/X1FwOA7kq0FGVYOuerQJXhCpc9sIipFNq5w0ASfF3xUCF9/y/MzmgF64l67PYo3KQAYcHg5eCFE5Ypd9PS/Xk4qzO6bTSkkYfWR0+aYkdIuzaPj2HzHPeOvNhNQLqXM71
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0cd792a-349e-4077-083b-08dbae660e53
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:15:55.4968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bKfVYn7KsWQkMCRlVD8xFnyyAPE/Kn2Mc1fCnXM+thlwhpjEXkFTCJYdRjDNiILy8tbXcZ02B2oYW1ZeRND358kBc+g+tcqOF7QdEG1Q1rM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: p1eTJxsBn-nsCCdSEvfrw3Dld3dzSkxs
X-Proofpoint-ORIG-GUID: p1eTJxsBn-nsCCdSEvfrw3Dld3dzSkxs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
itself.

There is one behavior change with this patch. We used to get a total of
3 retries for both UAs we were checking for. We now get 3 retries for
each.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 42 +++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 52014b2d39e1..0accd2f0f295 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -647,10 +647,29 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result, resid;
-	struct scsi_sense_hdr sshdr;
+	/*
+	 * not-ready to ready transition [asc/ascq=0x28/0x0] or power-on,
+	 * reset [asc/ascq=0x29/0x0], continue. INQUIRY should not yield
+	 * UNIT_ATTENTION but many buggy devices do so anyway.
+	 */
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x28,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
 		.resid = &resid,
+		.failures = failures,
 	};
 
 	*bflags = 0;
@@ -668,6 +687,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				pass, try_inquiry_len));
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
+	scsi_reset_failures(failures);
+
 	for (count = 0; count < 3; ++count) {
 		memset(scsi_cmd, 0, 6);
 		scsi_cmd[0] = INQUIRY;
@@ -684,22 +705,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
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

