Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE942C04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiJWDIY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiJWDHR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:07:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449B172ED7
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:00 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKv6q5032405;
        Sun, 23 Oct 2022 03:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=06H2zVYeAsVKMHrknavrlAA1PQzNf3cQ9LEgbZtA/uA=;
 b=gzpRGqeAfJzaN7yZA/JtdgHaRjhSmSjj5bGQUBtjzPZRqkVLMjAa2/3CIYN1/0dTsgof
 9SL61Z8QbvltpbIUR2MDfQOto/isE4TveTe7vwZEJBMBb5Y2PsG96qS+lKrt7o9QdJH5
 bV2V9Nb7ZCJ1Rcin0cTpeU7+Ls0TMHgSATMXWDfjZNlU5RJydsuEkmNDPlk11n21NGvj
 lqnMw/7txx14Q+DontWtoqia9jEUvRYZedVs9VLSAJ0N+38rZiXn4TgaC0J8yFfaWFNs
 /Q8D3YXGXYTj19BqGsSUDvTUPYIKZj8wes76wp3EtFhY9f5CXotIJwSf+I0pi0CE6gQ5 4g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8db95nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MJfDZX030736;
        Sun, 23 Oct 2022 03:04:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y2s02t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjidhvB+EW83+ELz4j5kLDEuEbCfwsEUuZLOAn91Aj0xZ1qykQp3ZLOD3hlg9upvzO+qiq4FCpx3bwNUPND3VwC5DMaurerVCduBd4Cnu7a6TQPfsl13N34nu4sLeeJvERwmMWZeJGQYKRkvBfXQ6hjy1TefwkxkGvIfQQgFg8Ddn/uXi3meAYDYYeMBzh5AIp1faMChmSss8q+9Hi1CdAbFGLBzKf7Vx1gVWHVCDZ6IBykpm45ZQ4buUVsELQEiD8zoBFGr7YDuRkGT3Q+GflCNpTKfVZ9wBaG5oGopynEiqh5OTTTggyIUqrHWwpAxmvz1riIF7w7dz8i4n+35MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06H2zVYeAsVKMHrknavrlAA1PQzNf3cQ9LEgbZtA/uA=;
 b=IYz5RAJDKwTB8l25mkRrbAHlNS/bLYm2ddjfhPllT8xqt/trS7qlcIHAkqrBuALn9MU/qm9b/dXlsXr0HwMG3Ok7Z16lxyZ1HZS0QVj/8/hU5uCWUTkRxY0rgRrdXPcuj/mklawyFD+tDdtaqCvyhoCY4OT7hEkIx0hTzlosjYQvu4y7HsKr8lShd/TKgxcL5dg0rayRL0/BZeYzg943dGrcKBsemaFPzBRK3zCqMxALunHpiWjYnyWo4OjV+KpGiEdfa3n8qlgbel6pgZZwaX8sF31X3hnYyVMq3hlCxeqKLF635Jq8XBF03bR8L17IayGG9wO+LCD9D065IWTf3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06H2zVYeAsVKMHrknavrlAA1PQzNf3cQ9LEgbZtA/uA=;
 b=0OXcAEH1nBELdrh6nr12dVhSlJ0v7ToiZGh7txmhuDB1LAjTZ9ahM63HPkGE2kGIk61+l9plnKdGmd+bgtz/P2i0RSzuKt1td8JwXS3K4zXSUTNFMVlYxpEhtZc6Mny7Oo8Wa6Qa0y3zshXi0Ds6oyK2W6XCSH6GuzKyUrmZekI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:04:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 26/35] scsi: spi: Have scsi-ml retry spi_execute errors
Date:   Sat, 22 Oct 2022 22:03:54 -0500
Message-Id: <20221023030403.33845-27-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0332.namprd03.prod.outlook.com
 (2603:10b6:610:11a::9) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 6984c135-8da2-4c95-b6ad-08dab4a357bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nh9mprSfivuP6emIcozs1ZyFhKzc2rELYmYSZ/vRsIcGOqwoWtQ5k2HVVEtkJO34L95uIkNXYyFcgsituUXo7zlw584/0uu9jP6QlMFiXKnxtNpufqpmLqjPjBlf0Z117E7ogJV1/ju/o4r9C0WgoY+YjAAhlSfY71t5PA4d8I5I1TcKYxe+qTI9axqyog90GZtwRBsp2XSR1K7yxbbxZgigYQCjLwcJV1u8URQYF5pdRLYpGV7XQwe5NIUOlUiCnweObKokIP8FZWOwlHfda2kvuEOCdty6fMtgSKbkzrH7uybLx6tf5flBWTxZ2XfxwGGHIRBEJZiMxDp1bL6rbrwvHmLmcfXQd9Q/K8AH08J5hxBGTGM/bjkhQ+K/TZ4W6yUgmm7wfxFimJqrAXPllqzQRrkIrEKA8y9kZpiQZAjoWCFLCYF8ghI4X2NWMu+W0US5vgrAkgNhdhTg8eNOxdBRWDCWzGkGJ8RF5z+JvQaUjpKqhPDvr9UlOH9tPV7hgJNOZKxLwiRRITX9hwi/4FCzHrqRJB54g2zSF/0wvn6cJr3fyc2tVbnipAyb39SRi4PvOdPESWWkwtniWTbgq7tDgWNf30JnMva2yAstFscgFFc+fARBxvdSmYtZpalfK+g4OTHkCJ7yu+Y3LcIONLGciYV5HTiePaPpu6ifM5n6uuJR0hNytAQAzY+sMnIcpqqZl6Ih2Ez8eliNyh5jrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q6q0q8ckRZDvUXkATxmejXmXM1VplTdQ33DJykJkYo9avmrbX2a3USY1mYji?=
 =?us-ascii?Q?5lX1ylg1ylnyAL0XPWY6BR9CB0BZ1v8cOYekUd2/iWu+suCaUXSGuh2YGNfo?=
 =?us-ascii?Q?zQH59mSaAA32cl5U2WMCEarDSWUlKbkJCYk79X8fHSDMwuISa7jBbJtGs9uM?=
 =?us-ascii?Q?/wtC1pugnrdaVs7L2Kux+SBJr6eaTaHjs2cA9UMljpEsktkBZU8/KrNkNoK6?=
 =?us-ascii?Q?Jmqbji43rEf3dTxEr5et95B1XC0pcCfbdKYuUJqABUBhstLou0QWrv9WlfIC?=
 =?us-ascii?Q?dRbQGSyl9u8JO4cwS+YqEjVe0uJPuOxcKuHq9XwPJUKDad16/nqxYtYEyYEH?=
 =?us-ascii?Q?UrVjuQmJo+hG3yIHEOPAo7brhU5JHSj2meu3VwAm0WUVu1VKRb9y6d6CRAek?=
 =?us-ascii?Q?MjLqzuWihZxDpdKIogEoGzoaGv0nFS5jXulLAJsvgX2MDWSksk6eEJEuNmHQ?=
 =?us-ascii?Q?t9MM+Y3kheg4LUzwu8sXeMx4J0cOnZ1cdPKgYQ8LIOQsj5C1fvFpC+/NAMEt?=
 =?us-ascii?Q?z2Hahh2GilLNiQLocf3pfdpvIzBmih8KTOHBRkP2OTM2QBpm0QIw5pKvIN22?=
 =?us-ascii?Q?NqkosUm0TuMx+pAOR7gzpRPQ24MKCyMkf4MA06smd3LS9S+GkZ0xr3quQxSS?=
 =?us-ascii?Q?/SzFSR7TWzlT4OYm6ukR7Ryj4QsR31tWfKRnQosX3t82bbDCIJ/joQz96Nuo?=
 =?us-ascii?Q?pC1DoAXLk4B8k3pAOS/lckD/1h9JAADyJ9LDhBLN6/8Ob/qDPi8Q9lIraArA?=
 =?us-ascii?Q?zjUa8gMMTkcYJ+h/gRxC0NZ5LjAOtU+6WLJsuPzfclxJ67Zpi3wHiDGyULqt?=
 =?us-ascii?Q?aTDFBQCduz8INefJCiReXrcPl/8HkZpy8637TpjtXobls4rgRSJ5TsdijqfU?=
 =?us-ascii?Q?ZvFIs2YcvaB2JpJUpGyN4BhnE3uS8ConyDL8luXzI4JwQm7wVNYCRhTLclV7?=
 =?us-ascii?Q?yIjctSxy7hybr68FbY1xCAhqnxuR/vdKs4ArpB1K3yFUmlXYBQvJVXdixQPk?=
 =?us-ascii?Q?9lUuRJCdqsM5ItRHI5AKIcy9BKgRecSm2jq69iU9950ylB+X2RQF9wJDS/R2?=
 =?us-ascii?Q?4eHxmzTYoov7+WDuIBgj+hD+XpxGLFVIZLlIqCNRVcM3/Qd5JA2S6JNQaKUj?=
 =?us-ascii?Q?FFnL4/cvA4Dxw8SDpMfqWrruG/uOyTE0+fQrIIop18P6s1fjm6Nc+QTQBkEf?=
 =?us-ascii?Q?cfY4CIfNZ8RzLM6likSBnGYNSw3v08FJwOXkTtBn+d2GumxDD/ajMLZqK8qE?=
 =?us-ascii?Q?oTtxnEUn1Pp7Qw/zV+8u+GFuaKN05ugqmZquiwhVU0d0UQH7aIdlKFhWshSR?=
 =?us-ascii?Q?ws5VysP+evU6R7iVw34e+4Jis7TWJaMcUtrGjVHV7NtHWVThp2c40fqNhaAu?=
 =?us-ascii?Q?YWLy7o3uGm1cc7mkmqbgFhViziGqCQeKuyCfhNTk6Sln6NSiEBrLDG5l8RWf?=
 =?us-ascii?Q?uMXfc/csGnJ8Km9Y/9Am5e8IiQ0/XFG0itONLKrWXRmOGQl99r3O9uiE1ryq?=
 =?us-ascii?Q?BvlKJ5jwjreWT9wCAMeunvGh/HTUEZ/hrMvSku2H18B91i8TroVw2JmbadVj?=
 =?us-ascii?Q?18M8JRWTEScA09eLzD1Iiq6W6XipCFG+bp8gZb3TGhm8poRBMrYfVRQxiE1B?=
 =?us-ascii?Q?jA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6984c135-8da2-4c95-b6ad-08dab4a357bd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:47.8409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYCKqaqNkP/gfYv3LiTMDkwKBD4Sh/DwXSHaFZwOhFczWloLL75io38tipAsndPG+Mc46fpa+psukr8bnBp46YpiGgNLnt/XJ49JFhUWmik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-ORIG-GUID: OWp0NpBX1FvGSaL3Vwg-eINWVdeAL9T1
X-Proofpoint-GUID: OWp0NpBX1FvGSaL3Vwg-eINWVdeAL9T1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has spi_execute have scsi-ml retry errors instead of driving them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_transport_spi.c | 56 +++++++++++++++++--------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 18a365c577ed..b172dd0205cc 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -109,38 +109,42 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		       void *buffer, unsigned bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
-	int i, result;
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sshdr_tmp;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = DV_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	if (!sshdr)
 		sshdr = &sshdr_tmp;
 
-	for(i = 0; i < DV_RETRIES; i++) {
-		/*
-		 * The purpose of the RQF_PM flag below is to bypass the
-		 * SDEV_QUIESCE state.
-		 */
-		result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdev,
-						.cmd = cmd,
-						.data_dir = dir,
-						.buf = buffer,
-						.buf_len = bufflen,
-						.sense = sense,
-						.sense_len = sizeof(sense),
-						.sshdr = sshdr,
-						.timeout = DV_TIMEOUT,
-						.retries = 1,
-						.op_flags = REQ_FAILFAST_DEV |
-							REQ_FAILFAST_TRANSPORT |
-							REQ_FAILFAST_DRIVER,
-						.req_flags = RQF_PM }));
-		if (result < 0 || !scsi_sense_valid(sshdr) ||
-		    sshdr->sense_key != UNIT_ATTENTION)
-			break;
-	}
-	return result;
+	/*
+	 * The purpose of the RQF_PM flag below is to bypass the
+	 * SDEV_QUIESCE state.
+	 */
+	return scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = dir,
+				.buf = buffer,
+				.buf_len = bufflen,
+				.sense = sense,
+				.sense_len = sizeof(sense),
+				.sshdr = sshdr,
+				.timeout = DV_TIMEOUT,
+				.retries = 1,
+				.op_flags = REQ_FAILFAST_DEV |
+						REQ_FAILFAST_TRANSPORT |
+						REQ_FAILFAST_DRIVER,
+				.req_flags = RQF_PM,
+				.failures = failures }));
 }
 
 static struct {
-- 
2.25.1

