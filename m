Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C22DC4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJPUDa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJPUD2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:03:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E41E24BEB
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:03:27 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GIrTHJ019352;
        Sun, 16 Oct 2022 20:01:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=prXqfiklnCfAKIAJwnFznuL6k5fw4y8eoND6CzRTVB0=;
 b=SBt6D1GDEonmf0Md+dlZexSmSzRprLSHbnDSmPX3OxoUcyy0w67uugCaDd0dKbAeN4pi
 O20OkI2EavaC/m3uxJHhQKP7ygNyCoMw7zmb7NzSq4DAxLv3DaBLZZzddkkEMNfkx+53
 u5FnlpIbaqR0GKEqr51f/q6AAfv5Zhm7+bmxVi5rive1t/41n/+N3YAPLnQFj6KKkjC0
 fkpWldbwY1W01LaMKngzSn4Ua2R6cu+hgha8YIxEEXfVcEPT4WHUjk9K8gFF/78QJ6xe
 70+M8Tilj0T2hL4jfp3QhYE3kd6oj6OplqDNhrXNfalGcYoW87Il2Qhfwq81CKH+J95r nA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7ndta64v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCHbSm034322;
        Sun, 16 Oct 2022 20:01:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hu54e0w-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:01:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhEe/+TqUxRQtWDeYLiBZpomzVQTFGqz2no/TZmWi7eT4EJtkqeCK9ltrdr3bzS3wbe9cDK+4npkLwJY6mrxCd42n8OJldncVJt8AaeMihMcZjU2wI75N4CpiNlu+BfM+wlCd5aMgY0jjrT5gYvyq/cYsLu9FMQpw77coQyEYJcw/2kcp4E4kGq7Svin8CaC7cGVu7Fy5tIDuoe5tMo7c4Ug7BhVkXixKFD93/Oksjy8pMj9nmHORXMbFI1dq6a1NC/ArSXKqF4J1aa7KRpXS/Kp8uNv5UGackWrjnJ6NjGECqQPY3DsI9hb8/jHoZ3h7cEdNvnyv0NZ83gYMBLqLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prXqfiklnCfAKIAJwnFznuL6k5fw4y8eoND6CzRTVB0=;
 b=enVlZlNyT+QDEJHKc0FEt89P8jQnRxR8mFpEW1qtZ+tMcnYcEi+TPV2KUu65GAHTdNCgA0r5biLQbNkEp/qtBnW+j0OyUOrqzE3P7WK2aK0UsSn4EcsB675ei7W8HKJtCYBI0eSPdLt0YTLAq0bW4V1C2vxHMUofZjLl++Rko6iy/Imt/j9vR2AfTXKD83c3kpyvEHEe0ZbQtIyYEQ71fE69MDAQwEjiFXP7QfuplJc8++mbd8dhULpo3GZ7weihG2YLvVm8FN3eg4H0ZeM/3Qk0Gt57a0cbGW9xGD/86Woqvbla92baiPJhQ2rakReTzNR3bmBFrQct1yV+ltcy2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prXqfiklnCfAKIAJwnFznuL6k5fw4y8eoND6CzRTVB0=;
 b=BNBiMS4RwfYYA4e7JcjYy7QEo1zam6+EcAC04tJ0jbOPR1dd3nUt2G7G/PPVWFSx6gigHbVvihfbGt8uIDK4ZS6XAeG+VZ6fWfCk+YxgRXPR3rIkdTWKYMuc5HaTznKZVPea9unDIta1kH5dIRRCe6+CnSL1vqrrJj5OLLlRfLo=
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
Subject: [PATCH v4 34/36] scsi: sr: Have scsi-ml retry get_sectorsize errors
Date:   Sun, 16 Oct 2022 14:59:44 -0500
Message-Id: <20221016195946.7613-35-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:610:38::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: 387b1b0c-b83d-4182-aa95-08daafb11fce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OxhhBECwYsTeUAt4aBbJ2i01coic/DVADhuvt5290s4PcqvDYrBlu4TlfucYlR9t4LCetrw49kDmk7Xtv+90970YV53lQjWGXtp/he0ZUjsTw3SUr9JJiGzbRsOOzJ5t5z17mxT66pdgbIK3G08/sYig6QI8MAmeDEseFB2NzK4Coy5wqWLeiI/UV7v/eM2sm3fpfLm7GhuYkYisBFmCbBZlNMuhax0x1Wjteof93KvKveQ0daIP0U76nf71C7ggXz1H5+VUriuvA20VzDO+8uxp5fghG35YC/GGhwinDbdzjl1qJGBoAqZ51FbOSpBfEjpW7Caf/LQj7RfROyLZ8M3X5NZsvHSPbgBD9sVXu6q8C0JhBxXeLUvSkRp3M4eiHR6AZY9AxGBehmH50h0MtfacwzeNdoqVoCQt+uTXDcWf21sZG7RG0zbStw9x1dB0UaK3USUhugP7B8lskElbwYRSFzR8HznZavapl9pLn52BbQgUfDqzRXNfr/AkpQ8MXPw7dYvyvHTQD4rNMfCDswGFRoMjawBIL8V8fsUjqcnRxyR1v6i9c6N0rG5l1CZ7jRb6txb3+LN1Hc0kB0Ggi9gSvbiUT+k57BY6F9BfG44g/oZZ4am+eLpIi/CtmJnXpxjUsfA4j7ZPkpVkA1rMdpsxIkEk5ZU+3BPi40zMgYn7jV0XBxX7YU9I0kH1wTpRxV/DMWOOTo6P5POpRQpeLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(6486002)(4326008)(6666004)(316002)(478600001)(107886003)(66946007)(2616005)(66476007)(8676002)(66556008)(1076003)(5660300002)(2906002)(6506007)(186003)(41300700001)(8936002)(6512007)(36756003)(26005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DmQPT2rDI7HLB7OabK4L2gf1btwXGLhrVJISIn7/K1fh62YmoR1h73HeBvei?=
 =?us-ascii?Q?pua81gEPbWKYNc7C8yalnNNpKq1yNNFy/6L4uN1zAiA7g7xNy6Vec2ODzZLs?=
 =?us-ascii?Q?K0U9Brd/evSZP3U8Nm8f4VN2vclv/0aYFbP4XlzxFWeKHswso3pdKSIRErXw?=
 =?us-ascii?Q?XQ+iplj/EW/yNgwoKsYGMOnFKSxbeksfS20+1Tx4/T9IAhf509SBbTPQiHXn?=
 =?us-ascii?Q?beM5Z2c3j6y3S28PCVv7RFQh38oSC7+6iVniYcEUchUgWDlxIzffAKSUfBK1?=
 =?us-ascii?Q?96JDiLpUK4FvGRBIu8AspFYTwCs6n2mRsJeyEuP5P7VPHTgxYDoJUI2BsQTq?=
 =?us-ascii?Q?gWlM+uEx8XglV5g94OONy3WtJLPd4WTduDIFsE/6mYMv0g6dR3pKLcQPZCHo?=
 =?us-ascii?Q?BxWfk/9vPAtdOB6FVb7ibvh/3c+xSxTnf57JBnNa0jx746Y8KNXDyKFel4dZ?=
 =?us-ascii?Q?z50EHJ8uPCjeXQzZXIR6jaYoog/1JfMmMDCcgVM6RM2UTGuEjdGyy0UEe6sc?=
 =?us-ascii?Q?Org/nl/BuMWedCYA1oPWJ6GRYZDUUW/k9bQ5QkMMShyDekZnK7NDE9Qnw3Xr?=
 =?us-ascii?Q?a2cwCspz8PxqqUqmErwAVHsMM554fUJRF2e72KW9ilfTjmeMpUuSP4+7jFme?=
 =?us-ascii?Q?rMCLlI9rDMtJaWyDLb1Fz3j7VSIba6BcUX+/WShUdpS3vao2OXqXReBGwSeb?=
 =?us-ascii?Q?TszV0JIbgYVBCppAN0VzZapi5DAPoAdctfpGTMUoISsy2wbjjS3YMSsWgYkr?=
 =?us-ascii?Q?Gxs6/X/dxL5+p/gO3safWPWP05k9UM0yt9jIgLDqlrQVPB3w+h74S/RBF4mu?=
 =?us-ascii?Q?yjNtmIG39oAIMy9qnnqxd8JsiMsw0sn2TDkmfQykzQhTMu+JiRdWM0z/mnRu?=
 =?us-ascii?Q?R7JgJJgwG3QhVL9KtGwQVPPcpFw2wtOHg2UzFqrrsS9FucDtVhmaaVSOZ1qW?=
 =?us-ascii?Q?sqE5mk1LBFUch8NZo4kh1p5RDvg3ZQuUvD4QdZJLosnWh5yQ59TON2fssIOH?=
 =?us-ascii?Q?pej/l8F6+1Q3z4waQX5iW8qPNMGtroftnTtFAwyBR7hfoVpdbZR06frrHRgu?=
 =?us-ascii?Q?KD9CucZs3iU6oLGCQ6cYrRLOqL4GMr866IuGynR+eSQ6bgPSv0SqGmzwfSO/?=
 =?us-ascii?Q?IuV0hqI/GRYJn81qv54qMISzzxTZv9tQ2EHKSou8B21R3+P/tfNkSfeBzZFM?=
 =?us-ascii?Q?U9kbUNYY6I9dJQqC+ack1ltYOb1jc8ac28doOmYNwf/+5tP05kEjKmplHOi6?=
 =?us-ascii?Q?SYEsmT53FFu1bJtzmvWQFC9HpcK39/g0kJUhd9m6PDL5Hydqwd9LGBgu/yQl?=
 =?us-ascii?Q?avZY4VHSYkqQShGWag01zoZvpU5b+Z8EcZDfnGDC67iewCxghCthe5TiVuht?=
 =?us-ascii?Q?XWuJ8h3zl7JmX4Wbzb7ZoHY8tj/kkb+SfFrH/KNy063OHhJkzdfw51xJ8A6J?=
 =?us-ascii?Q?tgKMNDffc78bZfoFRsUEvhv8Iu3wfkLyBmtFoEZuqBVU2/3tXLSqAgDnNx81?=
 =?us-ascii?Q?pjNV2hIDktWekm0mBnMpf3KQdI7nSWJ0Y66aP+sbbIkKwPZeJwSuvWwtNNcH?=
 =?us-ascii?Q?OzG1KqEp31xcxS1cC7nzBIJS9sZF64a1zMCb7COfRhd4Ma3GpbNfqtRuWRuL?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 387b1b0c-b83d-4182-aa95-08daafb11fce
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:50.5306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cHBBO2JVwjcv2p4DLM3WHRrTVBqGI1j1WOZQje06iJ+2y6n3KfJBRiKv38v00mSvP6r2/jIi/hi831fdccxI2nFVPIhrMWX352rQo4inJ7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: QOw4PF8WZ2IbSdEMIXDdroikix2_qSsT
X-Proofpoint-GUID: QOw4PF8WZ2IbSdEMIXDdroikix2_qSsT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has get_sectorsize have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sr.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e3171f040fe1..a282441d9872 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -725,32 +725,31 @@ static int sr_probe(struct device *dev)
 
 static void get_sectorsize(struct scsi_cd *cd)
 {
-	unsigned char cmd[10];
+	static const u8 cmd[10] = { READ_CAPACITY };
 	unsigned char buffer[8];
-	int the_result, retries = 3;
+	int the_result;
 	int sector_size;
 	struct request_queue *queue;
+	struct scsi_failure failures[] = {
+		{
+			.result = SCMD_FAILURE_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset((void *) &cmd[1], 0, 9);
-		memset(buffer, 0, sizeof(buffer));
-
-		/* Do the command and wait.. */
-		the_result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = cd->device,
-						.cmd = cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = buffer,
-						.buf_len = sizeof(buffer),
-						.timeout = SR_TIMEOUT,
-						.retries = MAX_RETRIES }));
-
-		retries--;
-
-	} while (the_result && retries);
-
+	memset(buffer, 0, sizeof(buffer));
 
+	/* Do the command and wait.. */
+	the_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = cd->device,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = sizeof(buffer),
+					.timeout = SR_TIMEOUT,
+					.retries = MAX_RETRIES,
+					.failures = failures }));
 	if (the_result) {
 		cd->capacity = 0x1fffff;
 		sector_size = 2048;	/* A guess, just in case */
-- 
2.25.1

