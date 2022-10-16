Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C46C43217
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJPUB6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiJPUBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:01:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB36543E62
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:55 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJXgVt015507;
        Sun, 16 Oct 2022 20:00:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5VBOIbxCmCDCbH7p7/9/NxCP7ayVegHA6gbJGxtXhXA=;
 b=tfkqokNMD/PywJFMQsstY+FBN0iGLuU1JFLlDTdSqfcwyGQLAEQUEZEnUPSJ7A/0dZcE
 zRFxFeeH9MZwobomz4S20v8LdewZsyCgZo6mokH+YCI+tn8acudkwRycyPh4+sHmVeDX
 nAk/K/AnCntwypv9NjE0jkRB79PnaiJ1OFCweb/aiF6YinowdFNI0Fj2nkSrAe8y0mdV
 CWv55Gmhzc6xl0iHExBqpiFkhSRo9rfr+pVzQp0wKJBB42/k4pDrpWgmd5ZcR9WvF1z4
 tSi5hfiCpvZJvaERcoEKG3M6ce+mmRJvhke7wakri6YTNd+MLi1l2Cc2TIiNySqBs/84 Cg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCBRO6029410;
        Sun, 16 Oct 2022 20:00:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr84k1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VShLqFiZTJjmxL8sFW7ZlGdefY6Ufymo9vVFrePyGQWeXAos49HbgaSKlbHQsIHDtm49l4zIzKgeMoFzBh9SO3P3U7+ZGpPviP2icENjPi9u558vKoIBqfQA4ViH5OT2elhxJ2lPz2C4HldxaQeP1ZtqPzZJzK8/uNosEEcHKBaC94E7ndh4EoNMKgxg9AFDRwwRLGIyKQXDb1iI6vyuAbHE91H9VpeosTXbV/DtNKdli0bQpWf/nQXFDN7NyeM4+nijUsuIp8mLBXE3sh6UWnhFw6P0ibsLZ5bJykJFnbOY/hCDIpnKtA/KXeYFOQklzFAs7rRvVdjeh8RHP0tTjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5VBOIbxCmCDCbH7p7/9/NxCP7ayVegHA6gbJGxtXhXA=;
 b=SchNTIiPpaNrQmyOpDg/0GA3uq65CbbiRyW/fsVcjyDWKCDLAq1nTurhvDrNtIlOC0B+IjzoQLzBUI0lPmnnIYSET+EH6VmW5GzSEd92dIALWdKjcpJlv+phzyv+ibX6tjKgCkyp24fbNHxy8ilJXczezBjBsKWSxKHaykZkhz5cUeRq/u5Sg/jwsvlxPUxx0Kj5F4KJVlG9fdnIjlTHzXke28LACBdUP1M7HfKnAvDZ/D+nb/OVb49WXg6TOFJWBh9AcTSF/pY852YKSsSYayim/On0kj3IddPeqAenQ4vTf4O3ymQHuNtTsMJ8s4RQvU7Glr4Gg9xCPwfYsfk+DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VBOIbxCmCDCbH7p7/9/NxCP7ayVegHA6gbJGxtXhXA=;
 b=PbXULFGcaVxIfmHMg29TpM3253kAgPH3LQ8gfib0p/1CI+Nueh9Lq7Zh3k2wYrr18WS+TuYfvN5HJo9sQXjg1DRtriMhA+xzVWvoai6siiwxmQqmHV4fEcNtg2OxJf5v4D8P0jUzFfOilL5bv3PQ6/FGpNT4CWBvXcQXKI7fJQU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Sun, 16 Oct
 2022 20:00:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 28/36] scsi: ch: Have scsi-ml retry ch_do_scsi errors
Date:   Sun, 16 Oct 2022 14:59:38 -0500
Message-Id: <20221016195946.7613-29-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:610:38::41) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: c0f48d43-ef52-4c89-5207-08daafb11aa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4PFmj0IloNt3G15HrKHErVRAr35L71pksHjIUUE7GzkULFovNltNOlN2o5RGyOF11Bgm4fF/YNslJmiqd26XBAYvVjtG2V4gHv/3OL+YBA1OY1o1XCfOhVtTw/QyGf6daFmjWdZe9vpsD0ECqF28P9HVzQe2jKILDMQALDnUfgidSWh4BqGJAZeMz/aDS91/zd1IXNgXMSMmUDSVB/Vczc/kXP2Q7lO6qFGZDp5oI0x14QN8eQ2+zCrJ5vIc8RDHobc7h4sacPrWBaJek5Wqv8GBd/uuVYi+pzF+TEBhgQq2BahrWK/jnnBo7jeGoGilYiWraRtg9Q54RzEFM3SDMHApO0jajSOQBHZ6WB15hOHj9ujj0GxxPjmyv88rw2mS59WKFajWd7C9Tnc1fkAvMapFTOF0PUxaFhUl0kxGLpHEaXtoV/CeZsrytzjEqKKXYsrkvtzeR8Ulk90mVn/EC4DoE4Up7rDI06TPozcdRYskhsaqANkT8kC20HQEiAuTx+XDFXaCt1IWPSzAcuT7WZLOiT8U5GL1nd1bd5Whs+a0DPqPnhvkF1rgc2ekfhdU0W0YLxFWTEG6tJvTQhRX+Nek6P9L0tLqW01cNb76dpmTtRQnIB8Jl/l3spRt1Bz42FYygT/lUN1AW9Ra5owr3dEFaOC4vPKiONaJUjJZ+89PPVPqznjfo0ypNjBlhh347QMbiaN+5pofFKGnHg0PBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(6486002)(4326008)(6666004)(316002)(478600001)(107886003)(66946007)(2616005)(66476007)(8676002)(66556008)(1076003)(5660300002)(2906002)(6506007)(186003)(41300700001)(8936002)(6512007)(36756003)(26005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HERQRxKL9DByof+03pKdYj2w8A9nq8j3oFKCKkdaXCJeOuGYa3JiwrH5MkwR?=
 =?us-ascii?Q?U0mrn9ZZzOi7MmI9dBWOL/zBIALH/EL7GzmeGbC3aYlcsb3GifzRCXGDpU4u?=
 =?us-ascii?Q?u7l3uS4VoNlKwBF+9bvySPsFpgoqXzWNQjlHoBPcliafTb5ZRPgGQG32Ax2h?=
 =?us-ascii?Q?mrcx3TtX+qenkuujP3p1PyuW2lpFl5+AW/oyPpOatmQb+H/p0trQAvuSNEz3?=
 =?us-ascii?Q?YpT8gxj6QtMapf9Y0Wkj/yWmyh+R1YeAxXlFiPccpix76LMJ+16siusbZHqx?=
 =?us-ascii?Q?ezpwZmJH5LrQ9e/xIn7DHzOUYYCHtxUaYmCRx+KuLlCiwKRJswQ/Ln1sPM1G?=
 =?us-ascii?Q?OujvckqjYhPeQXcVrsr/62azKcbK7u0GIjONlj1D5enITk5uYDC7/ZKFMap1?=
 =?us-ascii?Q?bjmDlq3T51Ux0Boisj+9g4xrlmyhNGBgHU0Ta8YfyZ8r9fqt6WVO4uAcTVpJ?=
 =?us-ascii?Q?PeiRDeQwdvqKB18pFVUvbeleFl3L4Efhk0PbhHRAoQodlp+4wJMmknAtoe4F?=
 =?us-ascii?Q?kqpIRtXLYwUl0D01WW8TJwpTqdbEdgUrfJYAT27kZHv3molCPn3mINZxNHaI?=
 =?us-ascii?Q?mYXsX1rRoYQbTvu/39hwYChanX2JGOcUj2Fpqmo3fZqZ3Ts0JzM5rZfQ4pZM?=
 =?us-ascii?Q?4QI3UGA0I0ggMoWTjNjwbU0ZY5FWT6n2gGyzZOhGKcXi2BlInFx8YY/5XqY4?=
 =?us-ascii?Q?KGmeJ59ktqRdTPRf7z6rjWnJDXM0ARa4NbtR6Brv0rVB98+y9LR3WAOr0u2/?=
 =?us-ascii?Q?+QxGeuEDYdVUJkyEPy8NusfPUk4O1OWL8aP7ASmr2cHSk7rwJL2+XuRaHo/Z?=
 =?us-ascii?Q?yPrkUD5L0FGMX8RgmnaFLy4ccC4x+cvoQlHNamGjeItHSD8aZFpGUmmzTSq5?=
 =?us-ascii?Q?TJ5O5ps0hpC18czoANmBTzc78pYxPw+ugzCeBNE0gXjYd/oYweBFdFwNY0d3?=
 =?us-ascii?Q?9YBWe85gnD70xfmfDKchm4kv9ebdVBwyRup7TDJf6fJqXyB2yDmOdnu8RYA8?=
 =?us-ascii?Q?FzW4dKe4i3eJIlXweyqkKPCT91mKnYggi8qGRYBeoXbatxapCrPCtlEAxMXk?=
 =?us-ascii?Q?Rm//IqHZMt4qIRcEgaMtMx/DTa25XOWNnj/l3eeX3fBB22jPpF/iWT47SfUW?=
 =?us-ascii?Q?7laFkKg6b8QEawGT7VnI32zQj7ObD8eD31yYRnCLKPbCmLhioMmW1uJrRDCK?=
 =?us-ascii?Q?8CSSeKVp1BNtBct/tYRETLY1hSq8VgMahCZA5BJiCyq87pjpQVmE0GaHMxHu?=
 =?us-ascii?Q?MwkoU9AeNpjTeAUd4trcZr1vHu5e+VObiWfTdVvIOIYmSHLZb66bnCmqUKb9?=
 =?us-ascii?Q?m5AT2es/XXxBbeDOBlMoC/K+3IGXzDyeK1wrrZfctbAyDrObqJCN1PHaP0rR?=
 =?us-ascii?Q?Q3+wLIDNc46vEXeuWAKHSvg44XhBOPbs4ftyDNjdB0r7BWWf3UktIhnING3H?=
 =?us-ascii?Q?8YFaThB3fvRE++gx0xx5K6155Hf/1HaNfpeAblnxEtg+sW2y0mfjtqlBADix?=
 =?us-ascii?Q?UUHx1ezXSs84nIOg1hsHxs3qffHGM1GDN6dDDi3qayvUBgmTNKVt0Lks3Oj9?=
 =?us-ascii?Q?ZADXelZgffNNCIvJgv8HcN0BZ1lWCm0aCmqWdEIoy/DN1oG1av7vc0YBi8QU?=
 =?us-ascii?Q?hQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0f48d43-ef52-4c89-5207-08daafb11aa8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:41.9063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HsDeswbb8vJX2PV+P3VXTaMz1b75W0Whrgeyd3J4JGRrXM/2R/46rzQsizqlKJhHFcMp+cAqpqXvvrN24GajDGn0qnSqIYGNbKTPBxi0F80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: Iw2Xf25j2ovGmG6le6SROavlubc1n1Im
X-Proofpoint-GUID: Iw2Xf25j2ovGmG6le6SROavlubc1n1Im
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ch_do_scsi have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/ch.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 511df7a64a74..015cdc0ab575 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -113,7 +113,6 @@ typedef struct {
 	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
-	u_int               unit_attention;
 	u_int		    voltags;
 	struct mutex	    lock;
 } scsi_changer;
@@ -187,13 +186,22 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	   void *buffer, unsigned buflength,
 	   enum dma_data_direction direction)
 {
-	int errno, retries = 0, timeout, result;
+	int errno, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
- retry:
 	errno = 0;
 	result = scsi_exec_req(((struct scsi_exec_args) {
 					.sdev = ch->device,
@@ -203,21 +211,14 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 					.buf_len = buflength,
 					.sshdr = &sshdr,
 					.timeout = timeout * HZ,
-					.retries = MAX_RETRIES }));
+					.retries = MAX_RETRIES,
+					.failures = failures }));
 	if (result < 0)
 		return result;
 	if (scsi_sense_valid(&sshdr)) {
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
-
-		switch(sshdr.sense_key) {
-		case UNIT_ATTENTION:
-			ch->unit_attention = 1;
-			if (retries++ < 3)
-				goto retry;
-			break;
-		}
 	}
 	return errno;
 }
-- 
2.25.1

