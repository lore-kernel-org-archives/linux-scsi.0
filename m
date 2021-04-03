Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECA7C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03BE661361
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbhDCXY1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49772 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbhDCXYQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NMCZS161763;
        Sat, 3 Apr 2021 23:24:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=1JwGlMMx/7GZe06clootYOICZGarTrVac4e4b5MrrEo=;
 b=ZgHKyuEcqqqJOTiSFXdqr8TPIU5ttT5mxCyxFX57DsEqmKakGdtnPIqNJfxCf0gQOCYl
 HOnjCHY+AzHjTB53ABbDmRHW1NEAsumQATTU/vzrJ0j1sIdtiM4R77mVw7OCoVdLqHVY
 71ZiCRVRUY96hPrm1lQkjFEBPfE9VQyQVsfiFIHFxEqUr6mtJecS9vN9/qD97cOJigG9
 oMo/bVtxKfRvl6ZIDYQ6N7RrSO3fwmBYAlQvf+i3sC/Pp9TwaJUh5c5lFnCNsn0Bcd9P
 jGa5DzDxiP2SqWKf1B8iERKm1Ze7E5zx0Ib9hV7UDUEUZ5S8nE3wIN0WC/HG+f1cIGqJ vA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37pgam8rpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKsHU116809;
        Sat, 3 Apr 2021 23:24:04 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2050.outbound.protection.outlook.com [104.47.45.50])
        by userp3020.oracle.com with ESMTP id 37pfpkbsnv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aO5U+i6E/qQ7UhbWtWn2gONyCdKEZOuiZKE2nW+4lUnYGT7BcN3X7HSVPjQgGDVtNIux22/K3t89sE7rSGWEtR9KzGHY/ergKhWvCOi5ZdKN1JhOr90R81rtrpNDy1q3iUO+EGFkFHFQIs4ClydGq7EJNUAytQrJBQ7DUNkHNU7oiIpm6mvVYymRwr1Q+F58dqcTNmfPMekfLtoKLEqY+3ex8Kga0gw3dAdmitzFVTN1y8hsmWhxHitvZL1SgyejtMuAUNKeDR2eS1ytxcJJFeWUOTRvpeOXdjwSOT78oxMlBdETsJNWaaNyvAOM+BvGbvoUW9ZWelTcYUW+af86Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JwGlMMx/7GZe06clootYOICZGarTrVac4e4b5MrrEo=;
 b=fa4OaZe9SCGrDMhWnh6InHgEFD452Jwa1Xx32Cl02aS5BMAMh1Zc5zJVrUzcEmVPBob2w+f2gQJxa6v6ao7RrB9IRQfPwDAtNMEkoVhT/t4heEs/7t+Cq7eAqnHuTlPGk1DHDlbon1MnwuHXqsUb9e+9qC8ooFKR5GYiOlg4bY6E7diGc23JHG5INJH8L59djYOSTAsPVaPgYX4sOG6WCVd7Vr+2FxIkJWIAYA9NcghYdbHErN769E3HX+M/gMKyyJAMQpOfmlyYPkXCajCLz44/LAa+q5XR45lgQVEr+5i8CBtxm8ir8WNivpWz050RpdVB7JipBX1IBughoXGnKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JwGlMMx/7GZe06clootYOICZGarTrVac4e4b5MrrEo=;
 b=D2h65H18q0OrivOgl7JL6srxv3ow2PDLbxB6St3zHLC+PkXsk8x8nm5ELMnonY1XWAfs4BNh9eofOWiQxKrnmFXSBK4GbKsoHLbtCLr1Q7xwwR6AEPLWTGsu5xe4ccUFVuqHH70q/JAXduy5PMgpmw4hj+5BqBUEUL0QiuPvHD4=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:24:02 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 14/40] scsi: libiscsi rename iscsi_complete_task
Date:   Sat,  3 Apr 2021 18:23:07 -0500
Message-Id: <20210403232333.212927-15-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3293236a-8979-4356-1e8a-08d8f6f79131
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB35269D42291E2120A23582AAF1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0HpJoeu0ohtDIWQqgMFmnPylTlme5JgJoTjs50NZUeIWmc8Q/VuKW/mf5wxX7bm9vKZUaNxDu/42csEWkRrGq5NPX+obDdrQO2Rg+xJ4Kv+AwyB52C047PHMePgnsJ7UKVvrfI6hyWlfMNoYNTJ4r6cTB2mTApTPagjPGgI1t0928mbOnayrcZi+qkH3FVJ60JEHoakzR2An/UY3sCrf9qcKPs4BZjKpCAQEkr+QWF8wZu6Y3PDhYaDXkTIQlewrvmL2Q2gn6jvXo/7B5uUNliebOxKSNMzv9qlIYVphciaY1DfHL65Pfa1frUL/f0kwhJ0JYCGLPIwXtpdhSulVenVk76rExSuEfCp6ggwogo65nBxG8bDzq1y12nHAIkqXz/FTTUSMeRlrtUrT2wt+RcDPfpCq1fJ8ZYrWtNtEQC9QKom518E4YwiBr5/IsGH0xgwwYlDQb9X8szJcd0PYfKnZsQSqZV94AjCp51ZlOqvjCqYCTuoqfKGHug8yB0GLtuCTjrBoT60Nvx+9Q7K8AWXfTvrjJgLYywwhHYFVkouNbByASONoTi7Xtw0VuO8YUDuZGkV2yoLdZAcvdkDaAimbVdcPmOIj/7V3OEvGP35LDs2M0Ddfo5ZDXfB6dIF24XGGTYdYFEnEj2Fg/T0tTD2QzdSctULR0ffbTx6VmLdbtoxth7cUkkKffSuC55pYYDYNZ/D/CTAS+xXJndFswQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S2JSgxX7fwDKqLzp+9woSP/zHm6I5EhEE4r6foNvwmfc2UZ1ziZbv5lrFFiw?=
 =?us-ascii?Q?WG+GX6Gpv7nMmuWAxTiJ76bf9gdltpAtbPDl/NeCPs2F05U6UIOb62WhL57C?=
 =?us-ascii?Q?8xCv6PLHqA3J8XowpmeNJzTq/0HyqK9MHzILEqjfxYYMpTzu1RVNl0km5qh8?=
 =?us-ascii?Q?sBMIPy5DQG53s6n2dZpOpWY2WSKxrmTafBZRnw9/hy4MxkqlcD2xY+UeTEW+?=
 =?us-ascii?Q?1Oso+kRxy3kh+uNkLebLONZ75uipvTlYIb+IBNLfn6T2RIYLfC2anUPMLDXw?=
 =?us-ascii?Q?j/bgYnqSHnQOabsYwbACPLvfXbsYLCF8ulLW5wJD1KMONnFYgs9JHy3vS5uX?=
 =?us-ascii?Q?2+2jqfU+0IbKBsrRaf+pnCFtfBsrOl5ThhfzTZiUvBQwOTYjLDVZB04y9AAl?=
 =?us-ascii?Q?uAJdsaGwJ3k27i/WRc2WXP4t3ydaNTZUF733NGp8foKpSQ/pPGiyeGAotA/I?=
 =?us-ascii?Q?z0OGJ3p9wX/aSM8vzuMVvomm7qHE3mt2keyA3FKeR/YjSxNPQSqmor1hOcvz?=
 =?us-ascii?Q?xLzr/Ult8yyIGaiA7hTVcLJMBsPjjlu0GndGG0K759l+Lx5lGgXEXnypkXTR?=
 =?us-ascii?Q?IPipNJ3lS0WCeULio9KpFai5z0FzNHQqCY0jjA4GKhhp0+vwHXTRvy9iFgeT?=
 =?us-ascii?Q?UR7pYcQpv0TdKfcUjHpdTEL8kv6QAQ+9vKZxvcYaumgbjwr32OeG5i445p6t?=
 =?us-ascii?Q?inQem1LtyAjeIFFBRfzk9ZINH+JapIeCtro2dN60Zh4d5sbAGBwvaWsWZG6/?=
 =?us-ascii?Q?HP+/9GFDCkYBH7pSq2XuBRMWVlOX1dNf/cupHxNQt3nCqi/e2JJxo1NsqAtm?=
 =?us-ascii?Q?AFZG2NWwxBhRE+JtMMkvaSHFbr9R5NqPt2iKyWcyWnKVGbWNyeM6CmzUjRD7?=
 =?us-ascii?Q?hmXb+LIk4+yPmNXghStloFAZcHUA6qF2GgvPCkM03WrDlMA959yIW6LnYhZn?=
 =?us-ascii?Q?pALqCdd/55kvSW8qOdTn8Nkp3uRavLB+IxP50tH9jYkomzfgRIQtKUSezzAx?=
 =?us-ascii?Q?sULFUSZvBVbJg5HGcPWLoJ3WT8CLTepRxAqKD5S0EqEcscDAaNziay4WHlyP?=
 =?us-ascii?Q?Q0qd40QnggagzDo4QbEV1K2pd/J+hQsvyfQJp2JCvP4eYztLohhmHUWqQuGl?=
 =?us-ascii?Q?Q2vmx8qmY6uleiXbLnveCc6je2hemGNLUQ1iAXjLTVDpNs/QJq6JqZaAG7rm?=
 =?us-ascii?Q?fEi5xZk3Jno8R0MfMDP6xyjyIMEbCsWWauQTMwvB6clvDdAMd8ZX/XNNEPDq?=
 =?us-ascii?Q?TLrcjn4WH2Kx9znOMARUFkaUvbrBctwZDaSH/sqkbXaeLXS0sthQy8KO8B/6?=
 =?us-ascii?Q?FGCiYj2nuIgX3gHSEe9FPsF1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3293236a-8979-4356-1e8a-08d8f6f79131
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:02.7784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7L2qYLoRRxzh+jxRsxqO4CCeF4IahZes4frXFY2lHLWNoGhKUYvfma/b1jaD8P33kQoeIuiDRMNcAbA8gQZzvbP8Nht/qp08WmrkIbEglxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: wqEdgqFIWotZ7RBIdJQNsa642oOWBuqs
X-Proofpoint-GUID: wqEdgqFIWotZ7RBIdJQNsa642oOWBuqs
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch adds a helper that allows drivers like be2iscsi and qedi to
complete a iscsi_task and a iscsi_hdr struct that was setup by libscsi and
the driver. This allows drivers that do not use the libiscsi itt to fake
it.

To match the naming of the other exported completion functions this patch
renames iscsi_complete_task to iscsi_finish_task so we can use the
iscsi_complete prefix for the new function, iscsi_complete_task, to match
iscsi_complete_pdu which is exported for completing pdus.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8a9a9f5801e3..768b6cefd067 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -502,13 +502,13 @@ void iscsi_put_task(struct iscsi_task *task)
 EXPORT_SYMBOL_GPL(iscsi_put_task);
 
 /**
- * iscsi_complete_task - finish a task
+ * iscsi_finish_task - finish a task
  * @task: iscsi cmd task
  * @state: state to complete task with
  *
  * Must be called with session back_lock.
  */
-static void iscsi_complete_task(struct iscsi_task *task, int state)
+static void iscsi_finish_task(struct iscsi_task *task, int state)
 {
 	struct iscsi_conn *conn = task->conn;
 
@@ -550,7 +550,7 @@ void iscsi_complete_scsi_task(struct iscsi_task *task,
 
 	conn->last_recv = jiffies;
 	__iscsi_update_cmdsn(conn->session, exp_cmdsn, max_cmdsn);
-	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	iscsi_finish_task(task, ISCSI_TASK_COMPLETED);
 }
 EXPORT_SYMBOL_GPL(iscsi_complete_scsi_task);
 
@@ -621,7 +621,7 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	sc = task->sc;
 	sc->result = err << 16;
 	scsi_set_resid(sc, scsi_bufflen(sc));
-	iscsi_complete_task(task, state);
+	iscsi_finish_task(task, state);
 	spin_unlock_bh(&conn->session->back_lock);
 }
 
@@ -893,7 +893,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	ISCSI_DBG_SESSION(session, "cmd rsp done [sc %p res %d itt 0x%x]\n",
 			  sc, sc->result, task->itt);
 	conn->scsirsp_pdus_cnt++;
-	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	iscsi_finish_task(task, ISCSI_TASK_COMPLETED);
 }
 
 /**
@@ -934,7 +934,7 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			  "[sc %p res %d itt 0x%x]\n",
 			  sc, sc->result, task->itt);
 	conn->scsirsp_pdus_cnt++;
-	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	iscsi_finish_task(task, ISCSI_TASK_COMPLETED);
 }
 
 static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
@@ -1018,7 +1018,7 @@ static int iscsi_nop_out_rsp(struct iscsi_task *task,
 			rc = ISCSI_ERR_CONN_FAILED;
 	} else
 		mod_timer(&conn->transport_timer, jiffies + conn->recv_timeout);
-	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	iscsi_finish_task(task, ISCSI_TASK_COMPLETED);
 	return rc;
 }
 
@@ -1258,7 +1258,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		}
 
 		iscsi_tmf_rsp(conn, hdr);
-		iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+		iscsi_finish_task(task, ISCSI_TASK_COMPLETED);
 		break;
 	case ISCSI_OP_NOOP_IN:
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
@@ -1281,7 +1281,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 recv_pdu:
 	if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
 		rc = ISCSI_ERR_CONN_FAILED;
-	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	iscsi_finish_task(task, ISCSI_TASK_COMPLETED);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
@@ -1813,7 +1813,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	spin_unlock_bh(&session->frwd_lock);
 
 	spin_lock_bh(&session->back_lock);
-	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
+	iscsi_finish_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
 reject:
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
@@ -1824,7 +1824,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	spin_unlock_bh(&session->frwd_lock);
 
 	spin_lock_bh(&session->back_lock);
-	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
+	iscsi_finish_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
 fault:
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
@@ -3268,7 +3268,7 @@ fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
 		state = ISCSI_TASK_ABRT_SESS_RECOV;
 		if (task->state == ISCSI_TASK_PENDING)
 			state = ISCSI_TASK_COMPLETED;
-		iscsi_complete_task(task, state);
+		iscsi_finish_task(task, state);
 		spin_unlock_bh(&session->back_lock);
 	}
 }
-- 
2.25.1

