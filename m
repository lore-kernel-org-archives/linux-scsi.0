Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019BFEB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243442AbjFNHXU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243251AbjFNHWg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:22:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C341BE9
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:21:03 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6jxrH025387;
        Wed, 14 Jun 2023 07:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Z4l0y0WyOcdKSv80swwNM3UbRKwigIdTdoj7ieGgWLY=;
 b=Mp8RVF+jOS5QMlfvMFNIW4BVkIg0Bgz8rZ4OO7NSqRaGyAzWE9foQRCQrD45amNSG+/L
 BeH6aGDSMQpOcmrTji3rSqz33oe/7gooCfT9QJZazSYeO3ZoS43R2G7AxLJQEDOxHdNq
 /NmT50K3MPVu531xSmkWRGnyntHbesWxXgFLA7lcwcPqh2BSwGPu0bJwAXBtQ1pE9s4C
 TfqDBWF85vBlzEsTMIdnCuX+zPSR7sWKwEBYyxH2jo2S4TPP6Hdc6dyTvJDcmKqW6dkx
 jh5ahPCk8R1GF+nTotsGz0J65kG0oRAu9OLc+91cxDyhj2cR8O3TcAfRnpL7LJC37+qO mw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h7d6vre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E61KOF016307;
        Wed, 14 Jun 2023 07:18:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56q0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsNWfvwYaRxdDF15j3ujEquCi/sTURfiWezchdm9MtovZWl1lHQdx4G7iCsS9iOlaEOjy+6Hc2hrbHvsANp9ZIOzGN5puTZyDu6fg5A4vGsaEMCqpWShEw6uRnaosDvMeHe587rQ8pfpDONcZjtNRqg9MkjjQwBtEeGsKGuEb1omT1BOXc4GHOjfr0z5h2tvhJG16tIE5cOKI0339+lnBp9CL24cmd5dXIbRyXMAYfZUxUI/PjuPNnQ/VpFezf9S0slgWzSX7V0HUrzPbs2/FhJ9xrp//YU4fTg7AIp2ZbgQcaRhkgXoxeFa+sg+5y0afUZSjbSg6aKIILvhLYRjug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z4l0y0WyOcdKSv80swwNM3UbRKwigIdTdoj7ieGgWLY=;
 b=Lhr2AWHMIBwEpno6WqoSpKv5KhFuJ6ReTwMeD40Kx9LNp5Jp3aw25G8F05hjCdmP0j5aC/cv3/3dR5gT62e34eNFRakIs+Dwkzy7c/c+rGN2M31Q0n3ngsKCRv2Egvr0fPUk7AMBmbGOui2EjyOOyIYgaOMPB+vBkIZhd9ZQQ+D3rTZQR0oK7atbwmkLTqFFTSvTkDGASeeud7g/zEc4y985V3CmXj7mUtQYzLNgF1VRA5+hDwYrDBH/BSAIqe0AATSP2PTXEsj7YO+/lRyFyHe7Y+6BOL4uu3DqcEsd9y9JhMFjjzLnUyBTWWe77mdef75/9kMv0Sb8Xr04JHJRlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4l0y0WyOcdKSv80swwNM3UbRKwigIdTdoj7ieGgWLY=;
 b=HdjCJNAn2Z7/2YwcFHHv2KQLbBH2IpiKXphMWBOV70K8P+QVMIVZOc/iey02htHSHDWEwmVyIcTYymFa0kPBOJHkjfYbBA1+oInLa73gow+EkV/tbdYAfB9g1hUFkgeUK7gwVhYQ6Gq/A5WbakWdFjxDrXbiQ15DgeOMITWFKpc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:18:07 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:18:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 26/33] scsi: ses: Have scsi-ml retry scsi_exec_req errors
Date:   Wed, 14 Jun 2023 02:17:12 -0500
Message-Id: <20230614071719.6372-27-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:4:60::31) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: 7342d7a7-c6f5-419d-5834-08db6ca78078
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Otz0aqo3Hdu1p7SVWo6u+GaLOfW+Qc5QSGdmLRwc0WYS5Z5Gd7a6VmCJZO2V4lu8m66C6Ugd9Uecmwtfk43aIaAdsK7RRrVitVCLsonJcGWWIgckMGXG6s1cnidFz2EC53k7o5F5YlFWsfq4WvzXEihJACusaiLWLVEPHLxrJaPYlBXoe1ifTHxXlLwDXonASwlouAt+79VIWJWujwQR2K6R7I96SSYw1W1Q4+8Rt1T862mxFriUlPSGSN8js+SiuooDw6hF0rwJP8cCWiyXPEDB+3htF2kd+jXhTrWqrSX7M5qodPdAhayhDNt6Yzl1mYweEPnSGsz2vbfEiqKBFY45xforJCS0PGIL3SZmB9jgzZe6FfueCYxkT2QuZq7vZxqJr/+gXPZoiHGrAgjJX4M44f+JlXf9DZ2p8TCJefNXSqJnldTE1FLG70KKf7LWQQzcm3+C1L1xCC9mw8tzpK5sVSnzHGKpcji6ZfjcKTsNM7ilZ7JWT2PobYDgdQPIP973mytxED7SisLhQF6q58oSwLeJsEC23VyBi54z82bGkZAb/lTXeI1GlqZTYnn3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(6666004)(8936002)(8676002)(2906002)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B6w/HECjexIFsETxh50uS37UhNe15A/DQ8wD/iwLGnY1DQc4ARgHVzKgEfkV?=
 =?us-ascii?Q?TxJqzLLCl/sV35qYDw20xm2q+ENupNQ2We3IGOXt1wW2qtieq4/pFGhnWFI8?=
 =?us-ascii?Q?aEpfi2DEIjRvkoZGL4cHxV+EPtkFX/H6sh0vrvP1LbOoGjqYmYMs2C1z0Zm9?=
 =?us-ascii?Q?EINCemifHz7I3XNc4pXSSi+JQEpRmekHAWd4HMxTv1yuTN5cDRL9NMD/PTu/?=
 =?us-ascii?Q?J/lk+w+fsfi1AlnRW5OHaTBsq07liNXOzMmfBJuI7q4s2g+ye+NBTp3A8lsL?=
 =?us-ascii?Q?VBuUVN8KffaPUzEDDuQEKiUCJ9pFahejmGJ2nG0ViXSJNBj6OKFj6DMt3K8/?=
 =?us-ascii?Q?70jmPQQ/S4asiUVrnxz6VbWrJqCFnhDG/8aDXBPwYhcQH4JS17LBNTkzQCZM?=
 =?us-ascii?Q?EX0UW1GPLvtljtqiMe/nHvvyzLeaOmI0aLP7BophXGoxSAcsmj9To7VGIqz6?=
 =?us-ascii?Q?stCDsXHcIhZDe6zbso2SemKFHn/Xvhpz6MXOWw9DFUh5rDhRgUKyzVNM1lTB?=
 =?us-ascii?Q?d4Q73j9woK6supn0NYBfPKKCAsd8Oo3qef8iQlfAdIlrrde74nwBH+bWldae?=
 =?us-ascii?Q?U/Czgn6DETj16rq+ljgPcW8r3hK458SiQgQEQRuIISdJ+u8EK2rM6zdi95e1?=
 =?us-ascii?Q?OEVfIjnB7LClCaXGgA96VUr9O/TOoOherKjVXJ/BzDwAHrh3cZX8tLygs9va?=
 =?us-ascii?Q?dqCEOFGqk5Ab9l4qs1HAANNa6fyS6D77Y5sUioPuvzT2HocrBls2nntPj9uW?=
 =?us-ascii?Q?uSA7tVSuW5SX36pv9sBg9SHhJwu46ojbXNLhWmyzSzWecZhiCaC7yttMB9Jy?=
 =?us-ascii?Q?j9iyZ3UQZkzD6hDALPoz8xT9UKJw2xxLHZWzNFggyzYzsT7pHA5IXEpWPuXC?=
 =?us-ascii?Q?bKqBapzqPzQ5bRAcy2jYIZf8RB83eeVTCj2aLuIDlddMN2fgHg9nKMhh+hbD?=
 =?us-ascii?Q?Rx3xEj/keppNhaZEQAWqdfHVUrI41MPf7kwqr3BdYWoKhRLQ4KnIFlSrA+VL?=
 =?us-ascii?Q?OXGNz3Kbp6M+zIhGYLw6NLtr/he0MVl8BDG1YqrBOuRIt8v2Zrn4PWu0pJuS?=
 =?us-ascii?Q?0t7AaVLlu3PP6yrXoqrauxLCmpjJNQY0JcYmK27/Jkq5hlEHaaQK7EtokYgE?=
 =?us-ascii?Q?OYOH6eaXfQOM9f0+Yy3O6gZ1tFEnje77QTD8eeSO49tt465fR2hwogAJhh0v?=
 =?us-ascii?Q?cq7J8YAAtdk8SLk9b3Vgnd5muKWTJYRKayvpvkOC7WkT6RSgeSb80XtuiiXT?=
 =?us-ascii?Q?mxGLTsMeeZXbztHacFfprlon2IolZCR6STIpotPdg7AXaXJr74VJEJeOnGTC?=
 =?us-ascii?Q?tYM6OFjF+n2IqoBynkOsynqvpca21PJ9vlAzKxUQybw9lM3DzIApMjHUTpuf?=
 =?us-ascii?Q?vBm9iPp0Al6lA70o3MaOzW7EAxVcedV4tCvejwz6Cq2u4INn8WjRzpHw/mQq?=
 =?us-ascii?Q?1ffKXI+5UNLdjr9MYIlleXQOsJ8GQdQ5qZsOBq18N+CXysUqlxJkXTj79D0o?=
 =?us-ascii?Q?BMdTeFGGo4ey76Jv5tuhUs/VEyxij+ITQinVGA48PzjQ19dqcdEYAGXe2lwl?=
 =?us-ascii?Q?gQqXhRFqLI1p9pHkCTrr/tJifS0I27Zr7kkeEz+Dbaob+73rMYk35V15VQdd?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xJSTGpO61Skt/jpaSwzStc5Z0gUvs27eJv9k5g3wKcxVTTAuLOtc9qxQea86+lA7YobQ2PCk97TJBD46JZYpvQED2ShlY67lEbhiUZuqm/9dA8zmNa6g7fR3UkcQguQ76Lq6vwZM5Z0famv2LoVazjBcj1iOZ8+Qrm3F5l+h9olVyA8HOUQvwYl4aFRfMV0zULynN95yAPWh56I2RXvddhRDtLfdRyrVwa1GqsDrH7bdcrRBxihigWihZYNFwMlhav9ZW0Ryg2jDgiOpNAgBqeSsmXF6069KK/fjkKDKJWqYzKaMjXHEhRjzRYXQMtH2ofzpdMxerXEddUmgjZfqvmVlze6bZqKQoU941cJpqj81UtR+jg8GvgHvOFyXx9bpvX6fgfVTqdvxEFN3ag4mmr+IhTvTIXxBFmUR3I+0e0g/bDVcCCI9Uo+fKHE8Y8emQBX32sgU64ZLjxCwF40pbqRYMyKPeA5lBrsRTBOT56uOrJ54g939+H1saiNqYQE2YRaS9dXsINj7RmTsdv+Xujl4Extr6X/h0zX26fmPGc/pknKDH71AfGsP9vPu667tnP7m73Xx7SZUyRWla5VlcZ9u6I9n/xZCJVuHzra2H6HezCLhePHx9Fbq0RdmaTTNDdfoSnuOSnNhJTVYhO96Ewa3FMm3hCZy+otSXPxI9wXvCzV3+fedtPrYgQt7L32ccpO+LlOo0s8Lz3TDChTScHk1q+akLp45EXQG0BfBUC00nLSPZBjY0zmV3qFRI0frr0UgIHreXiY4w1KTSrsPW9KMWCTeNeRj+lzOeg4s7cfWJi/zkZsw94+xzWg4rgJjTCt195E4cqDVv4r60RNOGVPanF6o6cIXxXRaw5xhXhn/p5Nf2+2ro6g3rFkZx28/
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7342d7a7-c6f5-419d-5834-08db6ca78078
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:18:07.4870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEmZ7qY8zAVfF+HN+oGdEZsPLWOUfQM5PwHSuI9e6IuztcmWXab8CcaUGY2iXI6f9b/NefRzhYSupQxSKc6Ce5oCmSAkatN7X9Aj55LAa7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140063
X-Proofpoint-ORIG-GUID: S6sRwKjXogHQ-o_gc3wgC6KtA5oxS4I0
X-Proofpoint-GUID: S6sRwKjXogHQ-o_gc3wgC6KtA5oxS4I0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ses have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ses.c | 60 ++++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index d7d0c35c58b8..678666ed9cce 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,19 +87,29 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
-	unsigned int retries = SES_RETRIES;
-	struct scsi_sense_hdr sshdr;
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
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-	do {
-		ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
-				       SES_TIMEOUT, 1, &exec_args);
-	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-
+	ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
+			       SES_TIMEOUT, 1, &exec_args);
 	if (unlikely(ret))
 		return ret;
 
@@ -131,19 +141,29 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
-	struct scsi_sense_hdr sshdr;
-	unsigned int retries = SES_RETRIES;
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
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-	do {
-		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf,
-					  bufflen, SES_TIMEOUT, 1, &exec_args);
-	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf, bufflen,
+				  SES_TIMEOUT, 1, &exec_args);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.25.1

