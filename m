Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F99EC2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11E1B61404
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbhEYSUa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47096 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhEYSUW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIF6se052980;
        Tue, 25 May 2021 18:18:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ytq8Pd73E7sqXcLqXUVeHitld6tMEne7hQpeAlPIJo8=;
 b=u9qH/E1z1l8RbopfUhbJaXUOw0Xl6pxxIYarViyQjvKYOR7G7yfYl+hNvuTgSfpXYcGX
 5X4IYG4ZsMKm5K6lYRvwZ0tv9o7lFb2EUMMlhI4EPSoH5pBflRMDf1fGnJQiIuy/s9Hf
 87fY2L6yEcSuI6sasHrtLEvpmlFUOTLQbMRCiQKg7Gb/XH+465EljG8E2HXD4Jmixb6B
 O71U/t/zE06dw83mdlbNjjOtvOZHWyWUMnK9xI9ZaBn4juEchcdgo/56sc2PYJsHcZkw
 V0hsBEq9+Q9QW7A5mIoHq8EN50fYzS1w8kaHUF/KtVE8mptapUExgH3XxHVUlkAXCZTK Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38rne42gun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIGD0q010935;
        Tue, 25 May 2021 18:18:44 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by userp3020.oracle.com with ESMTP id 38qbqsggy9-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mwe3+KasDtnK71GLlUVNdhwDzyirtbK1mCQE2UgCfTpb0AqTb+nRFKgri7IPt+IKMSjvt/WDgyYX/RyziF1wHxqE9Q42BaLKNtav5yjrl+4ilzKjnTLfjpA/FXb2/9MKIj/JqRBGidNMuWAFTKOlI7zb0CEju3C1DeoSTKUg+nxZ11vS4rztZlxDoYLg4lZ7tO6C9zZdPd28cavXb1wMErKjZcy1lBj9xYMpc3wDntIlZY3xcF29uYcdgz2Hw0BZTyUrrLMwhY2/qC0qgx8Mctm9W5AClIPHVr6D81kUxdXVQ8l9rEPJ+eADNaaQUAJyvlGfIWRQmEprKiYZHwMe4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytq8Pd73E7sqXcLqXUVeHitld6tMEne7hQpeAlPIJo8=;
 b=aS8rjYZulz0eIcTp9JOcgVv25bPXuBkf8SikJHEZ+DP9Ekl50av46cm1plPH79iy6/lAl4rAQzsNsgQ69mmfsNm6BlAE3zZpJbKJlZlDvSRnXKA5PvjBZ8qxtqtBg611YrIh8rMeb2oiIKWc+iswsqHgwh8I29JxmBS6YSfnS6kTWreNARC7utS4slgclswG9m0OQ/ePOKpBeIOLlsBeQgKqI1FR5ns9sCgYJZQdbtbverPxSYMsn76tILmZ7BJWrqIcXGNM4jfnSV2OaC7y8HemAJ98xQRl1NciyPI3lXns9VX40JMlJdvo/1/9rNMGSYW8RppKBshVRCRBx2RSLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytq8Pd73E7sqXcLqXUVeHitld6tMEne7hQpeAlPIJo8=;
 b=K9nHJGDgJx2i36cnpyAjFQ5XFP6u9kMVWrGLIc8wyzeXsVxmUCwzB4HrusGpaLtbsx/Di8NO7e6SFoZHb5tGyBX5ixp4+5eNt187aN6ncmv+EmT22AkxYFgEPgUnjENUb3crQMbwtfqGa7ftF+OVHrA7Q/CtQmBxw/d+5Y3Q+MU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:43 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 13/28] scsi: iscsi: Fix conn use after free during resets
Date:   Tue, 25 May 2021 13:18:06 -0500
Message-Id: <20210525181821.7617-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6facc7b-52a8-40de-d793-08d91fa9873e
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3891921E27962F36D4998835F1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:608;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KEa2Xj/9cGzhtO9M/cXtCd+3N19ZcWiF5U2jDJgrcLW+tEFUDIznmWfLMscWVYU+nyYZcBM+VnMfapZ5H5EKFCPN5KHrTw8/SbRYPWIFj94yireklpDng25W/Q+Fd1m4sijqH5tHs8htsgsQqyTCj4KSvkA3RMqyxnY+W0MkHDD+sfqeerrZnQJ43J29JT0+5UoYMu1wyDNanGmhX66+xVJSY8VcJMxo0WUtUzpneWPGRmF+FeLV5UvCm3JSjiwy42+DcC7Mq9THvE5p109ATwVZfmpQAnqmLD/tVMgd9kqPR0XCfzK9URgsVAvOlNaaQh00sJMHUf1y1LuJ+HMODmo35ZSytSpvZtEcrLR4+Evk4WSPjP9sRYfXEA3qtf0Ci+GbZY/XAbVpe3sjgFJAD5jHYP7ek3z5OP3G1hJigXMPxhGjfOoVJugzPp6tyviVn7Oxd//ZYjdOXF35KU9R2mc3TlmwH1qZtUFRuFuNTbpsupmOM7R/h6VY4wJ2lZZsYCnVqYDyxJ7QtaNV8cfUoRJmn/PDdmOdvBfI2rjv3+OvfuBg5//AQkI3q8Wau/juBNLdv6nPjAvZgMd5fh9T9mEOqv6HfBz3espmpfBQecpcDugP1POXkWzkWtdYzOoWe2gwQ7XyuUC95DjC69/gy9uf/spwwkJtCD3CgW5cOnbaYIG5DMjGdsKWUns/kLQL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(30864003)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5ScOjyclp4/eCMEesZsgrHmHU6gMaEv+D/QKKZkByyMAanzCkTVe9RoNe+SK?=
 =?us-ascii?Q?F6Ich5hLUEz6/nPf8pwLIOCq9ZtUimhcAcrAYScDo1h5WBO/dDGRwEP4Ea7A?=
 =?us-ascii?Q?DlnuFA1dAbqO6+ZGQcvsBFRRPhK4PsvtUXUUK/4QFRjQApq/hhX+yKOjw3By?=
 =?us-ascii?Q?LZJQRGB03cFWVUy4+fCII6DJ+E3VKAnFuK9gkhFfo8Sz/IsSYASTqJT0eLIU?=
 =?us-ascii?Q?0d930LC7XOvrMZJfFj6IyD6U7/C1Ori72WC1MTXgmx4FpdfNcXxEEA0DccBa?=
 =?us-ascii?Q?iDZ5Qp/KN1gI9vAEk9dXhAcDbEDu+pRkyhHp8J9m86OVuC1Dr9JDmQtEWuti?=
 =?us-ascii?Q?ljA6yqGhxLlbzo/llncU1rnnmPG1rPyNH0JLrHreCN3YDeziIhrCIaoCxbOm?=
 =?us-ascii?Q?EcKgcCa59iKzM2gQFKOHdnUAmQ0sSxyHYkoRw1b2ZegGHaVPFbRW8NpgkEdr?=
 =?us-ascii?Q?5qa0j78O8cWpwH8NSM4xGw32e7CbraJD1dwFtVSikFC4q0UtMjt6INsbTft1?=
 =?us-ascii?Q?SYNHOCWcQSxclI+dTrmfinIrEWWYekMpt5SsdzUuPWvhjxlYhVJe6sWSvdQV?=
 =?us-ascii?Q?PIPJLRHCiJ4j/pSjE74A0NiJdeDcyNLHLVD0Kum23Dw0vRJ7HYLrkKqj/+ZP?=
 =?us-ascii?Q?XetVZmtAOfvrgH4f4cN9nY+mBO/mP1BkRVpVm/5ddhLdXqfX/WylG17BpE67?=
 =?us-ascii?Q?CaaV1UnVvBsxa4Jl4kq3r6hwgQ4JhgCM02z+Vxs7HaVCwj538G1qni67fyez?=
 =?us-ascii?Q?qSh0Ahw6yA6Lb+8XkKKi1vNRTMFldeYK/TOe17cXGBbFFKBd92jcUyfYCHt1?=
 =?us-ascii?Q?es1KwLTvcjH/LjjKLuUa/Xj1+1KaDfIcTd9VPtXFfgyXhyMmOfeXHJ3cHnU7?=
 =?us-ascii?Q?OVAyFVpUvuwTl/2xisuAbonDkbD4rS/tIvFAUIpG76jLJqRTOrbASbm3uJol?=
 =?us-ascii?Q?hu4LCQreTvctD2oU8gBZF3Qj5LmEKGumdiBhB2kwUUef7+cYCwEGDs+60bu+?=
 =?us-ascii?Q?hW16Xl3HmV1xSXEw/4+LC1h5LG+p1L1sycOJQsRruCVHcR2BMm/GPSZqYpV+?=
 =?us-ascii?Q?NueG2J/RLoQ2b5XPGwJEioVxh0cmqTSRkLJUttSNW6YXhlSnNWasZYbRzl0y?=
 =?us-ascii?Q?4C0vgSDktze3MvP3pPUZThEfv5QNgv83d0GT9lue6HUszaRBmR4Vf8SeNvqf?=
 =?us-ascii?Q?pw4gJSDArRIrmDNtre82ezYazIaXGx6dTb7aqHBEIzzFOUL48aFaMKcAoz4d?=
 =?us-ascii?Q?Yss6qVVOYT/kKpeO6LLKYGJVgD+t5eCiJRvp7FYbiSE23uA4L3XJBODfLzE0?=
 =?us-ascii?Q?KjO2wfTMc4cgNre1BWRiGEgH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6facc7b-52a8-40de-d793-08d91fa9873e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:43.0731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X/I4fo+zTtboPbUIlpFpNy7oj3zP4sTfr+AfczAhVHXS0AWWuNx1yUcEhJ7VIp2DeqPovu6RLHyOAmQptLHVZPc2xmjaxEo1L7HOPM8soxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: lLAN0EosNXVkZ3bSICaQPlNAqFFHMLuH
X-Proofpoint-GUID: lLAN0EosNXVkZ3bSICaQPlNAqFFHMLuH
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we haven't done a unbind target call we can race where
iscsi_conn_teardown wakes up the EH thread and then frees the conn while
those threads are still accessing the conn ehwait.

We can only do one TMF per session so this just moves the TMF fields from
the conn to the session. We can then rely on the
iscsi_session_teardown->iscsi_remove_session->__iscsi_unbind_session call
to remove the target and it's devices, and know after that point there is
no device or scsi-ml callout trying to access the session.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 115 +++++++++++++++++++---------------------
 include/scsi/libiscsi.h |  11 ++--
 2 files changed, 60 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b7445d9e99d6..94abb093098d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -230,11 +230,11 @@ static int iscsi_prep_ecdb_ahs(struct iscsi_task *task)
  */
 static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 {
-	struct iscsi_conn *conn = task->conn;
-	struct iscsi_tm *tmf = &conn->tmhdr;
+	struct iscsi_session *session = task->conn->session;
+	struct iscsi_tm *tmf = &session->tmhdr;
 	u64 hdr_lun;
 
-	if (conn->tmf_state == TMF_INITIAL)
+	if (session->tmf_state == TMF_INITIAL)
 		return 0;
 
 	if ((tmf->opcode & ISCSI_OPCODE_MASK) != ISCSI_OP_SCSI_TMFUNC)
@@ -254,24 +254,19 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 		 * Fail all SCSI cmd PDUs
 		 */
 		if (opcode != ISCSI_OP_SCSI_DATA_OUT) {
-			iscsi_conn_printk(KERN_INFO, conn,
-					  "task [op %x itt "
-					  "0x%x/0x%x] "
-					  "rejected.\n",
-					  opcode, task->itt,
-					  task->hdr_itt);
+			iscsi_session_printk(KERN_INFO, session,
+					     "task [op %x itt 0x%x/0x%x] rejected.\n",
+					     opcode, task->itt, task->hdr_itt);
 			return -EACCES;
 		}
 		/*
 		 * And also all data-out PDUs in response to R2T
 		 * if fast_abort is set.
 		 */
-		if (conn->session->fast_abort) {
-			iscsi_conn_printk(KERN_INFO, conn,
-					  "task [op %x itt "
-					  "0x%x/0x%x] fast abort.\n",
-					  opcode, task->itt,
-					  task->hdr_itt);
+		if (session->fast_abort) {
+			iscsi_session_printk(KERN_INFO, session,
+					     "task [op %x itt 0x%x/0x%x] fast abort.\n",
+					     opcode, task->itt, task->hdr_itt);
 			return -EACCES;
 		}
 		break;
@@ -284,7 +279,7 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 		 */
 		if (opcode == ISCSI_OP_SCSI_DATA_OUT &&
 		    task->hdr_itt == tmf->rtt) {
-			ISCSI_DBG_SESSION(conn->session,
+			ISCSI_DBG_SESSION(session,
 					  "Preventing task %x/%x from sending "
 					  "data-out due to abort task in "
 					  "progress\n", task->itt,
@@ -936,20 +931,21 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 {
 	struct iscsi_tm_rsp *tmf = (struct iscsi_tm_rsp *)hdr;
+	struct iscsi_session *session = conn->session;
 
 	conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 	conn->tmfrsp_pdus_cnt++;
 
-	if (conn->tmf_state != TMF_QUEUED)
+	if (session->tmf_state != TMF_QUEUED)
 		return;
 
 	if (tmf->response == ISCSI_TMF_RSP_COMPLETE)
-		conn->tmf_state = TMF_SUCCESS;
+		session->tmf_state = TMF_SUCCESS;
 	else if (tmf->response == ISCSI_TMF_RSP_NO_TASK)
-		conn->tmf_state = TMF_NOT_FOUND;
+		session->tmf_state = TMF_NOT_FOUND;
 	else
-		conn->tmf_state = TMF_FAILED;
-	wake_up(&conn->ehwait);
+		session->tmf_state = TMF_FAILED;
+	wake_up(&session->ehwait);
 }
 
 static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
@@ -1826,15 +1822,14 @@ EXPORT_SYMBOL_GPL(iscsi_target_alloc);
 
 static void iscsi_tmf_timedout(struct timer_list *t)
 {
-	struct iscsi_conn *conn = from_timer(conn, t, tmf_timer);
-	struct iscsi_session *session = conn->session;
+	struct iscsi_session *session = from_timer(session, t, tmf_timer);
 
 	spin_lock(&session->frwd_lock);
-	if (conn->tmf_state == TMF_QUEUED) {
-		conn->tmf_state = TMF_TIMEDOUT;
+	if (session->tmf_state == TMF_QUEUED) {
+		session->tmf_state = TMF_TIMEDOUT;
 		ISCSI_DBG_EH(session, "tmf timedout\n");
 		/* unblock eh_abort() */
-		wake_up(&conn->ehwait);
+		wake_up(&session->ehwait);
 	}
 	spin_unlock(&session->frwd_lock);
 }
@@ -1857,8 +1852,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 		return -EPERM;
 	}
 	conn->tmfcmd_pdus_cnt++;
-	conn->tmf_timer.expires = timeout * HZ + jiffies;
-	add_timer(&conn->tmf_timer);
+	session->tmf_timer.expires = timeout * HZ + jiffies;
+	add_timer(&session->tmf_timer);
 	ISCSI_DBG_EH(session, "tmf set timeout\n");
 
 	spin_unlock_bh(&session->frwd_lock);
@@ -1872,12 +1867,12 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	 * 3) session is terminated or restarted or userspace has
 	 * given up on recovery
 	 */
-	wait_event_interruptible(conn->ehwait, age != session->age ||
+	wait_event_interruptible(session->ehwait, age != session->age ||
 				 session->state != ISCSI_STATE_LOGGED_IN ||
-				 conn->tmf_state != TMF_QUEUED);
+				 session->tmf_state != TMF_QUEUED);
 	if (signal_pending(current))
 		flush_signals(current);
-	del_timer_sync(&conn->tmf_timer);
+	del_timer_sync(&session->tmf_timer);
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
@@ -2308,17 +2303,17 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	}
 
 	/* only have one tmf outstanding at a time */
-	if (conn->tmf_state != TMF_INITIAL)
+	if (session->tmf_state != TMF_INITIAL)
 		goto failed;
-	conn->tmf_state = TMF_QUEUED;
+	session->tmf_state = TMF_QUEUED;
 
-	hdr = &conn->tmhdr;
+	hdr = &session->tmhdr;
 	iscsi_prep_abort_task_pdu(task, hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, age, session->abort_timeout))
 		goto failed;
 
-	switch (conn->tmf_state) {
+	switch (session->tmf_state) {
 	case TMF_SUCCESS:
 		spin_unlock_bh(&session->frwd_lock);
 		/*
@@ -2333,7 +2328,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		 */
 		spin_lock_bh(&session->frwd_lock);
 		fail_scsi_task(task, DID_ABORT);
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		memset(hdr, 0, sizeof(*hdr));
 		spin_unlock_bh(&session->frwd_lock);
 		iscsi_start_tx(conn);
@@ -2344,7 +2339,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		goto failed_unlocked;
 	case TMF_NOT_FOUND:
 		if (!sc->SCp.ptr) {
-			conn->tmf_state = TMF_INITIAL;
+			session->tmf_state = TMF_INITIAL;
 			memset(hdr, 0, sizeof(*hdr));
 			/* task completed before tmf abort response */
 			ISCSI_DBG_EH(session, "sc completed while abort	in "
@@ -2353,7 +2348,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		}
 		fallthrough;
 	default:
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		goto failed;
 	}
 
@@ -2414,11 +2409,11 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	conn = session->leadconn;
 
 	/* only have one tmf outstanding at a time */
-	if (conn->tmf_state != TMF_INITIAL)
+	if (session->tmf_state != TMF_INITIAL)
 		goto unlock;
-	conn->tmf_state = TMF_QUEUED;
+	session->tmf_state = TMF_QUEUED;
 
-	hdr = &conn->tmhdr;
+	hdr = &session->tmhdr;
 	iscsi_prep_lun_reset_pdu(sc, hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
@@ -2427,7 +2422,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 		goto unlock;
 	}
 
-	switch (conn->tmf_state) {
+	switch (session->tmf_state) {
 	case TMF_SUCCESS:
 		break;
 	case TMF_TIMEDOUT:
@@ -2435,7 +2430,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto done;
 	default:
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		goto unlock;
 	}
 
@@ -2447,7 +2442,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
 	fail_scsi_tasks(conn, sc->device->lun, DID_ERROR);
-	conn->tmf_state = TMF_INITIAL;
+	session->tmf_state = TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_start_tx(conn);
@@ -2470,8 +2465,7 @@ void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
 	spin_lock_bh(&session->frwd_lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		session->state = ISCSI_STATE_RECOVERY_FAILED;
-		if (session->leadconn)
-			wake_up(&session->leadconn->ehwait);
+		wake_up(&session->ehwait);
 	}
 	spin_unlock_bh(&session->frwd_lock);
 }
@@ -2516,7 +2510,7 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 	iscsi_put_conn(conn->cls_conn);
 
 	ISCSI_DBG_EH(session, "wait for relogin\n");
-	wait_event_interruptible(conn->ehwait,
+	wait_event_interruptible(session->ehwait,
 				 session->state == ISCSI_STATE_TERMINATE ||
 				 session->state == ISCSI_STATE_LOGGED_IN ||
 				 session->state == ISCSI_STATE_RECOVERY_FAILED);
@@ -2577,11 +2571,11 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	conn = session->leadconn;
 
 	/* only have one tmf outstanding at a time */
-	if (conn->tmf_state != TMF_INITIAL)
+	if (session->tmf_state != TMF_INITIAL)
 		goto unlock;
-	conn->tmf_state = TMF_QUEUED;
+	session->tmf_state = TMF_QUEUED;
 
-	hdr = &conn->tmhdr;
+	hdr = &session->tmhdr;
 	iscsi_prep_tgt_reset_pdu(sc, hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
@@ -2590,7 +2584,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 		goto unlock;
 	}
 
-	switch (conn->tmf_state) {
+	switch (session->tmf_state) {
 	case TMF_SUCCESS:
 		break;
 	case TMF_TIMEDOUT:
@@ -2598,7 +2592,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto done;
 	default:
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		goto unlock;
 	}
 
@@ -2610,7 +2604,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
 	fail_scsi_tasks(conn, -1, DID_ERROR);
-	conn->tmf_state = TMF_INITIAL;
+	session->tmf_state = TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_start_tx(conn);
@@ -2940,7 +2934,10 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->tt = iscsit;
 	session->dd_data = cls_session->dd_data + sizeof(*session);
 
+	session->tmf_state = TMF_INITIAL;
+	timer_setup(&session->tmf_timer, iscsi_tmf_timedout, 0);
 	mutex_init(&session->eh_mutex);
+
 	spin_lock_init(&session->frwd_lock);
 	spin_lock_init(&session->back_lock);
 
@@ -3044,7 +3041,6 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
 	conn->id = conn_idx;
 	conn->exp_statsn = 0;
-	conn->tmf_state = TMF_INITIAL;
 
 	timer_setup(&conn->transport_timer, iscsi_check_transport_timeouts, 0);
 
@@ -3069,8 +3065,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 		goto login_task_data_alloc_fail;
 	conn->login_task->data = conn->data = data;
 
-	timer_setup(&conn->tmf_timer, iscsi_tmf_timedout, 0);
-	init_waitqueue_head(&conn->ehwait);
+	init_waitqueue_head(&session->ehwait);
 
 	return cls_conn;
 
@@ -3105,7 +3100,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 		 * leading connection? then give up on recovery.
 		 */
 		session->state = ISCSI_STATE_TERMINATE;
-		wake_up(&conn->ehwait);
+		wake_up(&session->ehwait);
 	}
 	spin_unlock_bh(&session->frwd_lock);
 
@@ -3180,7 +3175,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 		 * commands after successful recovery
 		 */
 		conn->stop_stage = 0;
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		session->age++;
 		if (session->age == 16)
 			session->age = 0;
@@ -3194,7 +3189,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_unblock_session(session->cls_session);
-	wake_up(&conn->ehwait);
+	wake_up(&session->ehwait);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_start);
@@ -3288,7 +3283,7 @@ void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	spin_lock_bh(&session->frwd_lock);
 	fail_scsi_tasks(conn, -1, DID_TRANSPORT_DISRUPTED);
 	fail_mgmt_tasks(session, conn);
-	memset(&conn->tmhdr, 0, sizeof(conn->tmhdr));
+	memset(&session->tmhdr, 0, sizeof(session->tmhdr));
 	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
 }
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 13d413a0b8b6..9d7908265afe 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -202,12 +202,6 @@ struct iscsi_conn {
 	unsigned long		suspend_tx;	/* suspend Tx */
 	unsigned long		suspend_rx;	/* suspend Rx */
 
-	/* abort */
-	wait_queue_head_t	ehwait;		/* used in eh_abort() */
-	struct iscsi_tm		tmhdr;
-	struct timer_list	tmf_timer;
-	int			tmf_state;	/* see TMF_INITIAL, etc.*/
-
 	/* negotiated params */
 	unsigned		max_recv_dlength; /* initiator_max_recv_dsl*/
 	unsigned		max_xmit_dlength; /* target_max_recv_dsl */
@@ -277,6 +271,11 @@ struct iscsi_session {
 	 * and recv lock.
 	 */
 	struct mutex		eh_mutex;
+	/* abort */
+	wait_queue_head_t	ehwait;		/* used in eh_abort() */
+	struct iscsi_tm		tmhdr;
+	struct timer_list	tmf_timer;
+	int			tmf_state;	/* see TMF_INITIAL, etc.*/
 
 	/* iSCSI session-wide sequencing */
 	uint32_t		cmdsn;
-- 
2.25.1

