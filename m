Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30106C43460
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F197861360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbhDCXZQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:25:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45964 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236684AbhDCXZN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:25:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NNCmX041440;
        Sat, 3 Apr 2021 23:24:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=IlWg0hCcyD7CjdpwjgJ7rZVLTfeBDxV6Iyd+AfrHlAk=;
 b=Pydbc69FY3PkixP2qYfJWrqbhXUlWiMof9JKZXND/Bq+VSaAHLDWvm+ydcuoptvHLEPA
 UlMb/skjq6DDmOSb6OwA5lVjXKKSDHqu1JfG46pmRXsKp6wCXlwkkyzihx3rz2gnI9XW
 8vPpvkTreoHfPH6rCceyEI/NdtgRcMK62n0ycCf2b13n/DXOzXPmlmzNs++pREdH3Q4b
 QAfRx5WoBahCFS8/VHrlq0ycxdNFbq1etBtx+2smmh6E059oCTQ0RNhhzOA2J/6kFkxB
 gUeRZ5SkB1Jch4WN3exW8NC8UX424AHC/ZEn5lf5SjmnYKY6vXz7lQcl/6sqyPVrHPXN 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37pfsrrsh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtBS117020;
        Sat, 3 Apr 2021 23:24:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbt0w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXuSgP2biBASOTsRxEPs84TKT+DIpzVPdatp7RwvMRL93yfFaTIxQPyU+9g7kwPsnYSM33tluhAfZ6gZHkSqke8x7y1C8y7FWfyoocDFPwNJ4nn+/0rabQsHQINNkNlshuD+erQQ1rHZSMLy3r8rs+omMakk8pEGlDkl5FF0LcqouOFu9T6cB90+8r7Lec/H0LS6gV67LMknXlkJ1oOnjAWHB4+G09dpfk2T/ajGECWod2fhYKb1eIAephcq9Rj2yDMqFsnPhL9KvJRCOtgz5+evuyCzzZu5Vu+sT2Vhwes3Icv3oJkZuc9/UT35zU0gqY4s6PyolDHAznNQvlP96w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IlWg0hCcyD7CjdpwjgJ7rZVLTfeBDxV6Iyd+AfrHlAk=;
 b=axAJy+JJreHISnNqdsF4KSYvajo6966UfNvWNVJGaqbc/ToMPndbsMwelQNJdkdJtNeTV6Z5uQL1jSgVD5GxaATJfm0Zsr4v2gZ+uq7nK81K53DKsf2eOOjdJnA+wv3l6u2/XLRyusWj0XnC7oS5Qfu/BJ+wctvz7skaubE51sp01kqhglH233Pmw3vdQdzXih9bjqoZlDqfKhFM1b/FRZAzHEosasLrQJyN7k1ACqKmy6xxkeHm+XzjL0sYenogFj+TbJ7XIMOZwc0t/vXRlnBvDDB8feLO18GZ43CLQorUJ3jwzrdyFQlLNkQNiD8QSoY0z+WdP1e12tuT47G7OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IlWg0hCcyD7CjdpwjgJ7rZVLTfeBDxV6Iyd+AfrHlAk=;
 b=z27uNG//GTfWmaBxA4K/4ZInNPjgfYHnuzTzV/JFYBFgMSp5xqjV6rpUBlY4EyeMwZVcg09zRHzFBrQ1fzloT9wa7JQZ5nOh4xghQ4fOqtFiuXhPefXBUD43AhIXkyE7Wt3PrJ2pxYoUHK+Y1y2atKPruVnPa4noPKcsgvP2xjk=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 31/40] scsi: iscsi: rm iscsi_put_task back_lock requirement
Date:   Sat,  3 Apr 2021 18:23:24 -0500
Message-Id: <20210403232333.212927-32-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10a2e080-fe71-4133-07bb-08d8f6f79e9b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB34310C0930328449D090795AF1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6RdAe1wkTBNjkuJyiaCskdLy8nTwC4GBGZob2kS+yWkr62iM8TZiGuHjCyPzBtnLjCfwdRbj8n4K9vkxBHHGdEi3CkfwuTz/+V3bpYlzrSqSIWF8uUSID5e4l1FIZyq3Xw2zf5VX/ySiGSCkKD7KSvNM9Ou3YJdWfP8PTDoMWBknTgtI+PcS2QMwStGxsAc3agWTWC/WXnGGpvg+GPnrAQJPXnAJh6AL3HsxtOVL+hU3MP8qlU5bPmw+zxI4s+dO22MA9ll4ASIiIhMrV91acP4v8nkVU9PoHoLwiPzbXl8bgOZRk96J6rAMQomGjc6yPl5Y22disd/8idXUK7cYCFk/iPUGhQb7biiz46Ck7jc9uUEYWrZAQHWnex5MUSwjgIWPW0ra4m3nWwc6xbzIe7bwL45GHhV5sEylVUyhNRxqHQQ45Y+l2izOsog5pOIrV59A/9wVh08dw6mlvX8JWk4z7k0brndti4nofyIv9oP9C/pqIdyvaOrifm2WLnmg1J+f7nAJxXET18E6P16zexNoRI9HgsVqW2bE9NdV9CUtyepyFHjO7Cyj90e3MQTJt9nyovMYGfRfw61Y/XDUKB5QFn84VEiD9Afzgm94wp9aQlkajNedYI/RyUZrbGfQgybLWyXxW6w8uHpQ6ZwAuwzsIIq4Tz8zAL+q/48jzA7KhjUqglsJSHFvmkkH2Ud6RUya+1nt2tN1+eOaFOIqBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(8676002)(186003)(8936002)(6512007)(2906002)(956004)(107886003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001)(52116002)(36756003)(6486002)(7416002)(86362001)(316002)(478600001)(38100700001)(69590400012)(66476007)(6506007)(66556008)(2616005)(921005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?e0sz/O9M9wTK8AfVnAa8khrgXXceXnoy8uZyKWsXpf4WkAjI2DKwM3UoWdRO?=
 =?us-ascii?Q?tgPLoSrTgJGbifV+vgjjuL8NMV6YZ4oCUDAP9oMi8BNNtHuLVnX++eBNzt2A?=
 =?us-ascii?Q?U0eg9ou/l3wCXB13ZRphYPO7mwsaVocIh/q/5JYrJqvUxarsGgSz93J33dVg?=
 =?us-ascii?Q?suI8baWsT/wJfVezAXiOhPIveR4fXm8VdEFD7zeBP9uAwsVql0mckd/SlkAA?=
 =?us-ascii?Q?RhG4YChEl51KeuUqm/sIIKQiTcwkG0gOfmitbE5YGNTs6agzTAOSWFf5h/F2?=
 =?us-ascii?Q?WY7soxAcrmSZsaE+qKzeC38wcn6dc5omsFFDE3hc4jWKr2fFW++qXE9d8Qqt?=
 =?us-ascii?Q?X1Kms15rrT4h3AFk6wT25KvQhTGdfonkZ/QQ1SekUVPvqdocs9zVmuLzo9if?=
 =?us-ascii?Q?iT2uxVQvYLhvczpC/NPNNjUIOcu/xvXEUcdqicKBiKQixIkHYcegqHlDj289?=
 =?us-ascii?Q?AweEqIIWCV6QViWFvYgZ0ee1cuFzgOsLwqarKVVJPqgq9YaSrtbfbEJJ+kH2?=
 =?us-ascii?Q?IxvZcVC/BekXB2SMhmf0DmM1MdVB3wYKFOxhQPwnDXJikFz//1qKOJ/4pfak?=
 =?us-ascii?Q?u9IcpMxQY4vVoSgUkaTB2YLTR0I8G1FpiXPr48XXYRX7kQGzsLkNsZcB2B53?=
 =?us-ascii?Q?P1VCUbt5Xo67AFDmH5s+tCX5yhPWHnJQRmUeY5ViY+f406NDCLxrfkE93OLo?=
 =?us-ascii?Q?1qLTXJMvYGtIWm6P3tDTHh98vvosSI/VMW1XOlRqpmnl6G1whqvGUD9AMRaB?=
 =?us-ascii?Q?QDuIanTpa03nqDndpaubkKvnJK+1Ylk3Zl8DSFdyq56FQnBNnxVHoCsLNbAG?=
 =?us-ascii?Q?BlEXLyjznNggz2zciDP8m/VZrradU+aT8+dUewHQg2TTGxKMYxeYXU/KQw+b?=
 =?us-ascii?Q?1fCfXbP85v8BdR2HmfLHeZNWtxaBxgBMXSjlrgfYiBPVqesHIaYEvEOBTI/a?=
 =?us-ascii?Q?uiHaMOyjy7kUrVpYWexqHSkSWBL3tkjsfE5s/E7haOa9s4fPl9WED0yuT0PC?=
 =?us-ascii?Q?PtC2OteK0j+meaCNTo8uG85zrNvdiya8K/vPFoa40l9CZbPSH5kgzhcvSFrU?=
 =?us-ascii?Q?vLQkW9fZTuN6JP7ZVXOt7wPGH3u/COhAmt1x19wVwNaFgQWkT2/d3XPwnFVO?=
 =?us-ascii?Q?t0gQr94wmpWPnWsJaxrwhi4Iuy2ExAwkAEsz+oPXhZwh94NNGk2MFHT57hjg?=
 =?us-ascii?Q?Osjez6P4NhGFpRnSRqzDqUX65ODbc5PlL4jDV3jIGJ+OeNYkJQloo32RBK7L?=
 =?us-ascii?Q?Syv4gT+if7n5UUMoYZwGrjW0lFfQAs0hpF+B/NVUOLfBd7aZRnRciLC4j+iP?=
 =?us-ascii?Q?shB5HuomnM7fzOJa7PMaSg74?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a2e080-fe71-4133-07bb-08d8f6f79e9b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:25.3479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQNhrQvHrns0WKF4+wF6dzQn7ffM7ayS61V2zn4qiEuAtbkBnq+LD2HZoVuSC4dS6u8cBTuh84G7iDAXH+4QPMGL73lvXzp+OPTvhmdpXDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: UsLkXHqnGcE0ObBcWj5_8-xQ-kev909B
X-Proofpoint-GUID: UsLkXHqnGcE0ObBcWj5_8-xQ-kev909B
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is now no need to hold the back_lock when calling iscsi_put_task.
This patch removes the cases we were grabbing it, and syncs up the ref
count naming functions.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c  |  8 ++--
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  2 -
 drivers/scsi/libiscsi.c          | 64 ++++++++++----------------------
 drivers/scsi/qedi/qedi_fw.c      | 11 ++----
 drivers/scsi/qedi/qedi_iscsi.c   |  2 +-
 include/scsi/libiscsi.h          |  3 +-
 6 files changed, 29 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fd62258b1b6d..9f1f8b95a2f7 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -232,7 +232,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 		return SUCCESS;
 	}
 	/* get a task ref till FW processes the req for the ICD used */
-	__iscsi_get_task(abrt_task);
+	iscsi_get_task(abrt_task);
 	abrt_io_task = abrt_task->dd_data;
 	conn = abrt_task->conn;
 	beiscsi_conn = conn->dd_data;
@@ -287,7 +287,7 @@ static bool beiscsi_dev_reset_sc_iter(struct scsi_cmnd *sc, void *data,
 	}
 
 	/* get a task ref till FW processes the req for the ICD used */
-	__iscsi_get_task(task);
+	iscsi_get_task(task);
 	io_task = task->dd_data;
 	/* mark WRB invalid which have been not processed by FW yet */
 	if (is_chip_be2_be3r(phba)) {
@@ -1253,7 +1253,7 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	if (task) {
 		spin_lock(&task->lock);
 		if (!iscsi_task_is_completed(task))
-			__iscsi_get_task(task);
+			iscsi_get_task(task);
 		else
 			task = NULL;
 		spin_unlock(&task->lock);
@@ -1366,7 +1366,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	if (task) {
 		spin_lock(&task->lock);
 		if (!iscsi_task_is_completed(task))
-			__iscsi_get_task(task);
+			iscsi_get_task(task);
 		else
 			task = NULL;
 		spin_unlock(&task->lock);
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index a964e4e81a0c..41a1a325ab01 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1162,10 +1162,8 @@ static void bnx2i_cleanup_task(struct iscsi_task *task)
 	if (task->state == ISCSI_TASK_ABRT_TMF) {
 		bnx2i_send_cmd_cleanup_req(hba, task->dd_data);
 
-		spin_unlock_bh(&conn->session->back_lock);
 		wait_for_completion_timeout(&bnx2i_conn->cmd_cleanup_cmpl,
 				msecs_to_jiffies(ISCSI_CMD_CLEANUP_TIMEOUT));
-		spin_lock_bh(&conn->session->back_lock);
 	}
 	bnx2i_iscsi_unmap_sg_list(task->dd_data);
 }
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 61d73172283e..d4709e20b05c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -486,28 +486,17 @@ static void iscsi_free_task(struct iscsi_task *task)
 	sc->scsi_done(sc);
 }
 
-void __iscsi_get_task(struct iscsi_task *task)
+void iscsi_get_task(struct iscsi_task *task)
 {
 	refcount_inc(&task->refcount);
 }
-EXPORT_SYMBOL_GPL(__iscsi_get_task);
+EXPORT_SYMBOL_GPL(iscsi_get_task);
 
-void __iscsi_put_task(struct iscsi_task *task)
+void iscsi_put_task(struct iscsi_task *task)
 {
 	if (refcount_dec_and_test(&task->refcount))
 		iscsi_free_task(task);
 }
-EXPORT_SYMBOL_GPL(__iscsi_put_task);
-
-void iscsi_put_task(struct iscsi_task *task)
-{
-	struct iscsi_session *session = task->conn->session;
-
-	/* regular RX path uses back_lock */
-	spin_lock_bh(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock_bh(&session->back_lock);
-}
 EXPORT_SYMBOL_GPL(iscsi_put_task);
 
 /**
@@ -536,7 +525,7 @@ static void iscsi_finish_task(struct iscsi_task *task, int state)
 		WRITE_ONCE(conn->ping_task, NULL);
 
 	/* release get from queueing */
-	__iscsi_put_task(task);
+	iscsi_put_task(task);
 }
 
 /**
@@ -587,12 +576,12 @@ static bool cleanup_queued_task(struct iscsi_task *task)
 		 */
 		if (task->state == ISCSI_TASK_RUNNING ||
 		    task->state == ISCSI_TASK_COMPLETED)
-			__iscsi_put_task(task);
+			iscsi_put_task(task);
 	}
 
 	if (conn->task == task) {
 		conn->task = NULL;
-		__iscsi_put_task(task);
+		iscsi_put_task(task);
 	}
 
 	return early_complete;
@@ -788,10 +777,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	return task;
 
 free_task:
-	/* regular RX path uses back_lock */
-	spin_lock(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock(&session->back_lock);
+	iscsi_put_task(task);
 	return NULL;
 }
 
@@ -1156,7 +1142,7 @@ struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
 		if (iscsi_task_is_completed(task))
 			return NULL;
 
-		__iscsi_get_task(task);
+		iscsi_get_task(task);
 		return task;
 	} else {
 		return iscsi_itt_to_ctask(conn, itt);
@@ -1426,7 +1412,7 @@ struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
 		spin_unlock_bh(&task->lock);
 		return NULL;
 	}
-	__iscsi_get_task(task);
+	iscsi_get_task(task);
 	spin_unlock_bh(&task->lock);
 
 	return task;
@@ -1505,11 +1491,9 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 {
 	int rc;
 
-	spin_lock_bh(&conn->session->back_lock);
-
 	if (!conn->task) {
 		/* Take a ref so we can access it after xmit_task() */
-		__iscsi_get_task(task);
+		iscsi_get_task(task);
 	} else {
 		/* Already have a ref from when we failed to send it last call */
 		conn->task = NULL;
@@ -1520,7 +1504,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	 * case a bad target sends a cmd rsp before we have handled the task.
 	 */
 	if (was_requeue)
-		__iscsi_put_task(task);
+		iscsi_put_task(task);
 
 	/*
 	 * Do this after dropping the extra ref because if this was a requeue
@@ -1532,31 +1516,26 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		 * task and get woken up again.
 		 */
 		conn->task = task;
-		spin_unlock_bh(&conn->session->back_lock);
 		return -ENODATA;
 	}
-	spin_unlock_bh(&conn->session->back_lock);
 
 	spin_unlock_bh(&conn->session->frwd_lock);
 	rc = conn->session->tt->xmit_task(task);
-	spin_lock_bh(&conn->session->frwd_lock);
 	if (!rc) {
 		/* done with this task */
 		task->last_xfer = jiffies;
+		iscsi_put_task(task);
 	}
-	/* regular RX path uses back_lock */
-	spin_lock(&conn->session->back_lock);
+
+	spin_lock_bh(&conn->session->frwd_lock);
 	if (rc) {
 		/*
-		 * get an extra ref that is released next time we access it
-		 * as conn->task above.
+		 * Keep ref from above. Will be released next time we access it
+		 * as conn->task.
 		 */
-		__iscsi_get_task(task);
 		conn->task = task;
 	}
 
-	__iscsi_put_task(task);
-	spin_unlock(&conn->session->back_lock);
 	return rc;
 }
 
@@ -1627,10 +1606,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 				  running);
 		list_del_init(&task->running);
 		if (iscsi_prep_mgmt_task(conn, task)) {
-			/* regular RX path uses back_lock */
-			spin_lock_bh(&conn->session->back_lock);
-			__iscsi_put_task(task);
-			spin_unlock_bh(&conn->session->back_lock);
+			iscsi_put_task(task);
 			continue;
 		}
 		rc = iscsi_xmit_task(conn, task, false);
@@ -1999,7 +1975,7 @@ static bool iscsi_sc_iter(struct scsi_cmnd *sc, void *data, bool rsvd)
 		spin_unlock_bh(&task->lock);
 		return true;
 	}
-	__iscsi_get_task(task);
+	iscsi_get_task(task);
 	spin_unlock_bh(&task->lock);
 
 	if (iter_data->lun != -1 && iter_data->lun != task->sc->device->lun) {
@@ -2163,7 +2139,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		spin_unlock(&task->lock);
 		goto done;
 	}
-	__iscsi_get_task(task);
+	iscsi_get_task(task);
 	spin_unlock(&task->lock);
 
 	if (READ_ONCE(session->state) != ISCSI_STATE_LOGGED_IN) {
@@ -2364,7 +2340,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		goto check_done;
 	}
 
-	__iscsi_get_task(task);
+	iscsi_get_task(task);
 	spin_unlock_bh(&task->lock);
 
 	/*
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index de5133be1c4b..53099d560eed 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -706,11 +706,8 @@ static void qedi_mtask_completion(struct qedi_ctx *qedi,
 
 static void qedi_process_nopin_local_cmpl(struct qedi_ctx *qedi,
 					  struct iscsi_cqe_solicited *cqe,
-					  struct iscsi_task *task,
-					  struct qedi_conn *qedi_conn)
+					  struct iscsi_task *task)
 {
-	struct iscsi_conn *conn = qedi_conn->cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
 	struct qedi_cmd *cmd = task->dd_data;
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_UNSOL,
@@ -720,9 +717,7 @@ static void qedi_process_nopin_local_cmpl(struct qedi_ctx *qedi,
 	cmd->state = RESPONSE_RECEIVED;
 	qedi_clear_task_idx(qedi, cmd->task_id);
 
-	spin_lock_bh(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock_bh(&session->back_lock);
+	iscsi_put_task(task);
 }
 
 static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
@@ -904,7 +899,7 @@ void qedi_fp_process_cqes(struct qedi_work *work)
 		if ((nopout_hdr->itt == RESERVED_ITT) &&
 		    (cqe->cqe_solicited.itid != (u16)RESERVED_ITT)) {
 			qedi_process_nopin_local_cmpl(qedi, &cqe->cqe_solicited,
-						      task, q_conn);
+						      task);
 		} else {
 			/* Process other solicited responses */
 			qedi_mtask_completion(qedi, cqe, task, q_conn, que_idx);
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 77f0445c0198..6276f49b6402 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -65,7 +65,7 @@ static int qedi_eh_abort(struct scsi_cmnd *cmd)
 		return SUCCESS;
 	}
 
-	__iscsi_get_task(task);
+	iscsi_get_task(task);
 	spin_unlock_bh(&task->lock);
 
 	qedi_conn = task->conn->dd_data;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 25590b1458ef..8f623de1476b 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -487,8 +487,7 @@ extern struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *, itt_t);
 extern struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *, itt_t);
 extern void iscsi_requeue_task(struct iscsi_task *task);
 extern void iscsi_put_task(struct iscsi_task *task);
-extern void __iscsi_put_task(struct iscsi_task *task);
-extern void __iscsi_get_task(struct iscsi_task *task);
+extern void iscsi_get_task(struct iscsi_task *task);
 extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
 extern int iscsi_complete_task(struct iscsi_conn *conn, struct iscsi_task *task,
-- 
2.25.1

