Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13439C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5D8A64E0D
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhBJE40 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:56:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40994 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhBJE4V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tXtv139912;
        Wed, 10 Feb 2021 04:55:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=w0bkrPorxBkVypHpKPWa3rd2csO7WNGUL6M2nensSN0=;
 b=eDc8DXjMwBUaPABmN5ibFnJMtnNf+ntaMZjtj9iYy0cZYhIxZ40GqtNZOJ4uDAYtzKz/
 9xsX6uOPjAs5zdihpqKBA5G5uID0vNPrWPon7WfEXDeBclTX1CHZ/oWKjED67+XesM1g
 gxwwefdVK0kUpY9v9g6H+/dD2FpmAMUBIWFcLHzFqGPFbJVWD3iexdvHpDFcdDw4OMs1
 rgzTiQF4T14KXwYXFNQb52uX4YSKDmGQDwMuhT4BoM4BmW/MYPftmVyH9W8GTLFtrBQ7
 oJxSi0zZLHk+UzJomPWf4+9yaYHNrAX5tW7ZAFUZbCVdxaNIMmCvKjLnPCRr1Xip5nV2 1g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36m4uprdf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRB4048727;
        Wed, 10 Feb 2021 04:55:32 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhRCKbd02HdMWkceeXMn+2sCFxwo3Tl/o7+sJK8h+q4zeJ3KX4xaoMO01DWw/US2bDVbZfHe6vAI5bJra2exKcCdLq+fP1YgXHzxzqL0K1HWTSXseq/uwN5D7OwTMbtf5zNm/iObsPaD4PTaDu6B2EBpfygzTEqf7uYLeWPJtM2D/8YYS25P4covZ+7RWSTJjbbf6eEZxyQbkSTIc/wfBTZ4XLkfZ6UjjZpDD3pZQceY+kc5PknZe+yOWmpHgg2j7Z8rT3DKGmGLK8XDfsC1M1TU/9Li5/nH6nY2bdZz2F42FVBltogHeBZQixn1wviG3HtQGTX0rDa0RXta9QWOBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0bkrPorxBkVypHpKPWa3rd2csO7WNGUL6M2nensSN0=;
 b=nJe+OMKJ/gHya9Js/Kd2z3W45Zbnb4b/r6TyZrRChwhkNg5wSIpCWFIUOzCiq0hj9NmATgO7mFTQGcnmxKOygjvs5ypdGfTLKgM0kfv+RZMOAnOPmgRjLx+Ep73NtMWy8mDAHJ2+Jd2s022Naf4mOJ2mj+X5TuSbYnHRpa62yu42qkwrNLa/hPr2XwwWh6lJ3q6S0NzBjc5Er73GyMaswyiJQuodUvTdFEZjEqFE8pIloWSQccbcmJjrEK9oodIL5OnSNo/me5fEJXpV1X4iiy3a4+W9RBEQrrXVrrf9E3UTOnZ0yjy6r/z0ixUPjvWWglQprTGB43LR3LwNL/V5ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0bkrPorxBkVypHpKPWa3rd2csO7WNGUL6M2nensSN0=;
 b=eVllznnVZTCZeBUprbd9aiDk3sLrtuDhry/ajFQWdB/UpFTNKo7BbreyH460O+KpsLdcArBGaK9tec2VmKnQQj8+rNjb4umwrlE9LRqDHBu7UGUOLGUIi9B03lyLL0w4owpQI8OWakRYZIIWBsRleE5tKg3/zHTN57fW5nWT3No=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:29 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/13] target: split target_submit_cmd_map_sgls
Date:   Tue,  9 Feb 2021 22:55:05 -0600
Message-Id: <20210210045516.11180-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210045516.11180-1-michael.christie@oracle.com>
References: <20210210045516.11180-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:610:4c::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11ea16f9-e7a8-439f-6653-08d8cd8015c4
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3366EA54D45207930A059BAEF18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lr4lCjZk2PqSk2wvdAbEM5jStNLpsCh6ngUkds55aptoPGYj0H6Ksakt2POn6+k3qRZ4gqDER+yjXUHYZhUrpC8JeHJdllxtEVH/rGuYTLPdN381Z1ko8ATvkIlaD6Xpl9J9ML1D2UQygmnJsrOIrIEJidyHhw6vl2eowWnLiBTya+FQpxsJS2Z9z91LvWSdGVGptXI78b865+XdSjbzdKByI89o4EEx4GBraKfDY96oY/i+ad/7bostFh1qXLOZUH2VQtKOPbeRvP6ChK5jF67UzR+VlbxYs9OwV5ZveEYz8gWZVKsSEzjBTE2aD6mv01wOZ8vuOp+d7r/ZU+7eHvl5polZGERYV/41rxmuXwH9cq5tRRKoWGjgFNlw3GFLWCbdd06ikSnfsvvoZcfBqIeJC4L6uePKaAgiTyeJoyZAmguSGYNXCmHaGYQeaLX+WuQuM5neVPvdHGRPpPFRo2OCEXUyzXHsi4O7yjju01kuMO/aPXR+DlCFB1F0QSHrZsLVTIJfe4ldc9+SPppANPHW1/hOGzLNsJowAKM2Y/fVFn2CD8UxrAkcio01vrbbshNdyLDVpmfynvN5zO0rnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(86362001)(26005)(5660300002)(478600001)(52116002)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(316002)(66946007)(66556008)(66476007)(6506007)(6666004)(4326008)(8676002)(2906002)(107886003)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PnMchR/nxs/dNjOcXjGdBYpqVOEGb2PWqE24e06Q5Uu/B360DCERm/xi7ct9?=
 =?us-ascii?Q?/f0+pyCva9NcFsMBOlD/nh8ST7k4NwIkKAe8lkqUFiFG6FBhsVLF+6uZThLX?=
 =?us-ascii?Q?pBj47hbWsMdCnmUnuj4ZrDdLoQ4NfgAdoBLOH3P8RjCe1QwDNInuoQhmKJR5?=
 =?us-ascii?Q?i1daTGgbkDkQ6/HJwOyr7UOena3Cl5H1SxM+Q1evVYfHMCoWeOIfsYAH483M?=
 =?us-ascii?Q?lZTpZx84Pt/aa5eJAVy+YAf+PZFZ6KM2TPN2SC6QCp68ZLzJyoXUewiojqJH?=
 =?us-ascii?Q?AxZbiPCHjU1zOLYqX/1v2gJ4rtuNN1uyTMSSqc7E4PKIMA9Dn44F26EjOrvz?=
 =?us-ascii?Q?uU7t7FtDH5Y6os2OYYA9Mf/ITTOhq3uQ8CkIQTZp0tPna7OCyFXyj9vObiIP?=
 =?us-ascii?Q?T9YDBr03b/Uh5X1oPvA+MmCmb1W07Hlf7ppEJC43HTOskwVGTGzG7LuVtd5N?=
 =?us-ascii?Q?in45h4IKZLIKCxM2CehZEBLwanPfO+drJ61uW/Jlvmsj3vUP8BALr8CQ/DbM?=
 =?us-ascii?Q?6yxNnov5RaO+as0B7iPPwQwKssA44g92dHwqrHBD3612IzJ0TTT2IgjAwjmF?=
 =?us-ascii?Q?A45j5hXRiLfnNm9akqMWxZzll7b7fTtPmIdOuEQAHyzcfGxgOS+fUtueKMh6?=
 =?us-ascii?Q?4KDVAsV5Ydt05fZMHC9lSM6apyCEuAu9mVid5HUsrqkJqYQqFAVkvxJP2hy+?=
 =?us-ascii?Q?9DoTerhb+L281xJj0e3Z4POdCKwA4izKYUG1G+DqUdRV/AxDWnEQWAI83UVG?=
 =?us-ascii?Q?1EOZC+vXp9TtAtz7FCRalzECFn2r87kLeKxckQOpOhfcis2L6TBrAAk+eyxa?=
 =?us-ascii?Q?4HiCwFaSdbRdRMAFZVH5KmWeOCr+QFkd8drc6SnRATdxJmkwl5R6pvLRHDoP?=
 =?us-ascii?Q?/yAd+JVKbx7IfaRMoDZEthpu/0apebhI06LFmVNADkG50Y16tsIF9k/mwyXW?=
 =?us-ascii?Q?HUygnehFMmk8cl+Dveu9Yl04b/9BeD0ecT3s10uOuACLtX7Hmd49h0k+KNT1?=
 =?us-ascii?Q?53F1HXTgQhCiMx47JFkzhn+GcaeOS7ynvQ5cVJ1oDKIgbfr6rD2XjwZrMhHY?=
 =?us-ascii?Q?mdCAfmCXfykJIbvJZrtqca/CJWV2E/l0GZjePaZwFWVDAnn6wBsIWAhg2hMq?=
 =?us-ascii?Q?P0VwqeL3HwijxDT+lRSvpb1tDRvG6lQMQmnT3VzoOvCTxbiNlT+e9GgDUY2a?=
 =?us-ascii?Q?Tjg4PEOkzCxc3K5s6r30n3oBWOqxjf73T6LU1XSYPdL0gkeoRfb3SNj/5uvg?=
 =?us-ascii?Q?CgWw5lkx2WsN8H0+nRaBD2mU+dpFGJkkAvzhtDuBUr5QWhvAlKFlAntLqf5M?=
 =?us-ascii?Q?9YxMIvGMrBuAPFjETr5pCIKW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11ea16f9-e7a8-439f-6653-08d8cd8015c4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:27.9764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LaDvGvA6WJ2LExNfDFPneNDERh8IJ1u7cWQABl2o6UbMGLTnU0BQLAkLpJlIVGZc9uO/DkQHcnH5ZqiXPWeCdaX2s4h72O7/UYGHl1TdVEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Separate target_submit_cmd_map_sgls into the part that does:
- the initial cmd setup
- will not sleep
- and gives us access to the se_device
and the part that:
- can sleep
- handles the actual submission

This will be needed for loop in the next patches which needs to add
the cmd to the lio workqueue and can't sleep in that initial submission
path.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 149 ++++++++++++++++++-------
 1 file changed, 109 insertions(+), 40 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5c4adde96d5e..f19b4b81e3b9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1571,12 +1571,9 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
 }
 
 /**
- * target_submit_cmd_map_sgls - lookup unpacked lun and submit uninitialized
- * 			 se_cmd + use pre-allocated SGL memory.
- *
+ * target_submit_prep - prep cmd for submission to lio core
  * @se_cmd: command descriptor to submit
  * @se_sess: associated se_sess for endpoint
- * @cdb: pointer to SCSI CDB
  * @sense: pointer to SCSI sense buffer
  * @unpacked_lun: unpacked LUN to reference for struct se_lun
  * @data_length: fabric expected data transfer length
@@ -1592,26 +1589,29 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
  *
  * Task tags are supported if the caller has set @se_cmd->tag.
  *
- * Returns non zero to signal active I/O shutdown failure.  All other
- * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
- * but still return zero here.
+ * Returns:
+ *	- less than zero to signal active I/O shutdown failure
+ *	- zero on success.
+ *	- one for all other setup exceptions. The cmd will be returned as a
+ *	  SCSI CHECK_CONDITION response in this case.
  *
- * This may only be called from process context, and also currently
- * assumes internal allocation of fabric payload buffer by target-core.
+ * This may only be called from interrupt context if the caller's
+ * queue_status and release_cmd callouts do not block.
+ *
+ * This assumes internal allocation of fabric payload buffer by target-core.
  */
-int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess,
-		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
-		u32 data_length, int task_attr, int data_dir, int flags,
-		struct scatterlist *sgl, u32 sgl_count,
-		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
-		struct scatterlist *sgl_prot, u32 sgl_prot_count)
+static int
+target_submit_prep(struct se_cmd *se_cmd, struct se_session *se_sess,
+		   unsigned char *sense, u64 unpacked_lun,
+		   u32 data_length, int task_attr, int data_dir, int flags,
+		   struct scatterlist *sgl, u32 sgl_count,
+		   struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+		   struct scatterlist *sgl_prot, u32 sgl_prot_count)
 {
 	struct se_portal_group *se_tpg;
 	sense_reason_t rc;
 	int ret;
 
-	might_sleep();
-
 	se_tpg = se_sess->se_tpg;
 	BUG_ON(!se_tpg);
 	BUG_ON(se_cmd->se_tfo || se_cmd->se_sess);
@@ -1642,14 +1642,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	 */
 	if (flags & TARGET_SCF_BIDI_OP)
 		se_cmd->se_cmd_flags |= SCF_BIDI;
-
-	rc = target_cmd_init_cdb(se_cmd, cdb);
-	if (rc) {
-		transport_send_check_condition_and_sense(se_cmd, rc, 0);
-		target_put_sess_cmd(se_cmd);
-		return 0;
-	}
-
 	/*
 	 * Locate se_lun pointer and attach it to struct se_cmd
 	 */
@@ -1657,13 +1649,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	if (rc) {
 		transport_send_check_condition_and_sense(se_cmd, rc, 0);
 		target_put_sess_cmd(se_cmd);
-		return 0;
-	}
-
-	rc = target_cmd_parse_cdb(se_cmd);
-	if (rc != 0) {
-		transport_generic_request_failure(se_cmd, rc);
-		return 0;
+		return 1;
 	}
 
 	/*
@@ -1684,6 +1670,43 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	if (sgl_count != 0) {
 		BUG_ON(!sgl);
 
+		rc = transport_generic_map_mem_to_cmd(se_cmd, sgl, sgl_count,
+				sgl_bidi, sgl_bidi_count);
+		if (rc != 0) {
+			transport_generic_request_failure(se_cmd, rc);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * target_submit - perform final initialization and submit cmd to LIO core
+ * @se_cmd: command descriptor to submit
+ * @cdb: pointer to SCSI CDB
+ *
+ * target_submit_prep must have been called on the cmd, and this must be
+ * called from process context.
+ */
+static void target_submit(struct se_cmd *se_cmd, unsigned char *cdb)
+{
+	struct scatterlist *sgl = se_cmd->t_data_sg;
+	unsigned char *buf = NULL;
+	sense_reason_t rc;
+
+	might_sleep();
+
+	rc = target_cmd_init_cdb(se_cmd, cdb);
+	if (rc)
+		goto fail;
+
+	rc = target_cmd_parse_cdb(se_cmd);
+	if (rc != 0)
+		goto fail;
+
+	if (se_cmd->t_data_nents != 0) {
+		BUG_ON(!sgl);
 		/*
 		 * A work-around for tcm_loop as some userspace code via
 		 * scsi-generic do not memset their associated read buffers,
@@ -1694,8 +1717,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		 */
 		if (!(se_cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
 		     se_cmd->data_direction == DMA_FROM_DEVICE) {
-			unsigned char *buf = NULL;
-
 			if (sgl)
 				buf = kmap(sg_page(sgl)) + sgl->offset;
 
@@ -1705,12 +1726,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 			}
 		}
 
-		rc = transport_generic_map_mem_to_cmd(se_cmd, sgl, sgl_count,
-				sgl_bidi, sgl_bidi_count);
-		if (rc != 0) {
-			transport_generic_request_failure(se_cmd, rc);
-			return 0;
-		}
 	}
 
 	/*
@@ -1720,6 +1735,60 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	core_alua_check_nonop_delay(se_cmd);
 
 	transport_handle_cdb_direct(se_cmd);
+	return;
+
+fail:
+	transport_generic_request_failure(se_cmd, rc);
+}
+
+/**
+ * target_submit_cmd_map_sgls - lookup unpacked lun and submit uninitialized
+ *					se_cmd + use pre-allocated SGL memory.
+ *
+ * @se_cmd: command descriptor to submit
+ * @se_sess: associated se_sess for endpoint
+ * @cdb: pointer to SCSI CDB
+ * @sense: pointer to SCSI sense buffer
+ * @unpacked_lun: unpacked LUN to reference for struct se_lun
+ * @data_length: fabric expected data transfer length
+ * @task_attr: SAM task attribute
+ * @data_dir: DMA data direction
+ * @flags: flags for command submission from target_sc_flags_tables
+ * @sgl: struct scatterlist memory for unidirectional mapping
+ * @sgl_count: scatterlist count for unidirectional mapping
+ * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
+ * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
+ * @sgl_prot: struct scatterlist memory protection information
+ * @sgl_prot_count: scatterlist count for protection information
+ *
+ * Task tags are supported if the caller has set @se_cmd->tag.
+ *
+ * Returns non zero to signal active I/O shutdown failure.  All other
+ * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
+ * but still return zero here.
+ *
+ * This may only be called from process context, and also currently
+ * assumes internal allocation of fabric payload buffer by target-core.
+ */
+int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess,
+		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
+		u32 data_length, int task_attr, int data_dir, int flags,
+		struct scatterlist *sgl, u32 sgl_count,
+		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+		struct scatterlist *sgl_prot, u32 sgl_prot_count)
+{
+	int ret;
+
+	ret = target_submit_prep(se_cmd, se_sess, sense, unpacked_lun,
+				 data_length, task_attr, data_dir, flags,
+				 sgl, sgl_count, sgl_bidi, sgl_bidi_count,
+				 sgl_prot, sgl_prot_count);
+	if (ret < 0)
+		return ret;
+	else if (ret > 0)
+		return 0;
+
+	target_submit(se_cmd, cdb);
 	return 0;
 }
 EXPORT_SYMBOL(target_submit_cmd_map_sgls);
-- 
2.25.1

