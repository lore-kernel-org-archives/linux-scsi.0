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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE21CC4707A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3757611ED
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhEWR7x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38982 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhEWR7s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHtcuk146108;
        Sun, 23 May 2021 17:58:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=j/4EsnZfW0heAm92Pw5JPuZaTL/JoOg54DIcYalCQ4s=;
 b=ZCTILIZOj2zHi/2V2CpvK3WroMygX474E2UrcOzblZckmhWQXx2b0CFyhcAoI/BUfAX6
 497Ux7ECXTwffsxRtqW0L7EJEoXgYyrcC+8TGpXVTR3Df74CWPsRKbGaXVGRRDusCcIp
 P8saNFIpgTInz+NbKodrI1WcDJIp095H80Eh/1BrlRVp9eOt5OLzKizDNLiXphsEVhT3
 rhChubd3VBb8HVx57k/NKDOjrGj9dS4uKerZA0fc+xl3Ckyctm7iuWXRnkF38dpHvZll
 lLhw0i91EdQFc3wG6vujZwDKFRKKk10asbiSSzSoT0K9rvcxz8ZjOGln5sWe6LemAoSC Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38pswn9fqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHubDl161766;
        Sun, 23 May 2021 17:58:14 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3020.oracle.com with ESMTP id 38pss3qbsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jy3qbsz5eU7xCPbwXbk+vpw1Nh9iIp2aFq1iHA7/fgWf3Ze2oO+4v7nlWvt6H51xJ8+FCspi77yVr2yi6tVCqjW4FLO4rTAK9lwvRhjZ4aWl0a4whipqaqcDFQB+ZQkVTeBolzglkqRPLpe+MqEjSsuZo3jTUvpKaGGMe881JC6rvYF5PQ3B7rHqjARDrWMMVZkcWdNn2rnKYF/QiWj/Iw5T8H9fqDjumPO15B+k1XYWwBxQPB/pxaXwyDGBl12ZwegmffcPneZeC/V/ifx7W+jEUBC2bKGV+LI+xKCHWaSZPseYtR5ZyeED9tvGgI2UFhv+4DMDAH9SXuBXwQxLEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/4EsnZfW0heAm92Pw5JPuZaTL/JoOg54DIcYalCQ4s=;
 b=OhoemgBUh35TyA7BOQB6LwuqXVQ3GQBYibTyw9zmzrO3knRafRXXybmWP3xwDU2zGGTtrzICKQQfW4sAgA0jzYBLfcJTH+iWkh70NoLpElXKUM+b4O0BwAMe+DWp7nzmHj03HdWaCwwyR3Aib+JTnJpkjTbT/cez2PHo/inQzACIq2fN8yqAsviAMmtqWWh0qQbVLHVVwDuOVoSBhHpy8tGO0iAMkVqJse5HgKP5bt9DCfqcpXTJOia0ShaBBE7CX9PjCeB7avdG+xg9lMpPmSjLpA9HXB8SMVytzO3OsDKLtucJEPKMy5FmW/7PkD1WhwAMYjJYE805jXJYB0DUZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/4EsnZfW0heAm92Pw5JPuZaTL/JoOg54DIcYalCQ4s=;
 b=XPxVfZ9u3GfmsPaQl47XDMv+tkCeWuaZ567OzPepiEFLxLzvrw9OpTlagzbwMhbeLgOYLdMhaOdgfTXyWvVIe1uRn9C9RAwAxVyOH5kvp0dD8AlZcR97Oz4UUKUeVJD2h26+3TSBnq1X67FWIgpqf59shVabRoqGB6/SP7W497Y=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3239.namprd10.prod.outlook.com (2603:10b6:a03:156::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 17:58:11 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 20/28] scsi: qedi: Fix race during abort timeouts
Date:   Sun, 23 May 2021 12:57:31 -0500
Message-Id: <20210523175739.360324-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 597c08da-dc2f-4044-ff6c-08d91e145404
X-MS-TrafficTypeDiagnostic: BYAPR10MB3239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB323976B10AD3E2B5A2B41557F1279@BYAPR10MB3239.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h5PCCBz1uLyXQuEaBvkHAQiFEIqXdkZVM4VN/oE6E4+yKTfKUIcdf6UYoDQDgjOA4bHAueH6086Z6zAUTVf2UPhIiWSHGs3HQ0s7mjdRqEHExCIEoIZ5mLHmBXrGkU5u0ZvfQN02LdH2xVVufOPJmfvS7cEnq3F8pJJM8GS7VnFe+mlXdh8qP+JV505X92J+wKitbFJFoNVfRUIKaZfzTfda26sgkHqNSFCtZYdSNTAMhIxVikoCJRCMYy0h38PcU1oDoVT+uVj8xgepbyGAYX7GAs591tDW47dWSIBCnzKVArddqd4eKFocXcusGVf+GIxkjhdh3AKUIVH/OGnCWiZ7TcBa6+Rn4zUCyT46D7oMThpH3J2jcsz9Skp8oFQlJFEqujXCiP0Et/z1/Ik46Go8aieMVHdk2UF2JiVuwiiM+M7k0OWhDZvPR2k96LNMrzV4ouu58E8yDNyTzk2GlDlMhErsKAxVuvX7Xo1dueg+NIo98vXMRgnK0cBMLjwWbdmJBrCiJFDI0uKQv7sYtJZZZywUTz8aETfOur/l0VcXew/p0AJJC4a12RQ70FCkOlDghQ4rwYkl7IHmpsCFyrl6hQTGzxwZysXjID68v/515UspD4iOhcWc/7rpokQQAVUCk5tyssyeRViKHH2eFWw0IJTbQKBV1SkCIrDALabAnfVuHy03YQli+7tGejU4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(52116002)(26005)(86362001)(16526019)(6506007)(2906002)(66946007)(66476007)(186003)(478600001)(2616005)(66556008)(8676002)(6666004)(1076003)(38350700002)(38100700002)(83380400001)(36756003)(316002)(8936002)(6512007)(4326008)(956004)(5660300002)(107886003)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pT8vS8KlSCGs8Q4q1Bnz+hqL+EOVJYpDu/gx+cZ7u3/jE7RE1ZMSlyFaskyO?=
 =?us-ascii?Q?Tnr8Cu2cLm5Enn17BkRjHfIDPDWDrkiNsRbRChb7J2SCumkdogxhAJBa1tUz?=
 =?us-ascii?Q?3Tcvswls+SFk5hYGkIo4CHLyjZeaoaJYOTE+9cCDP8jYEUVOQeF9uydMvure?=
 =?us-ascii?Q?1zqX6ri1Ocpxn4exlArXyoAnwaXIbUTjl7vktdn39Pp0vEpU1WsYYy/3kTa+?=
 =?us-ascii?Q?QShLTXYdJiLpIAiLfvPwFyW2ekjFoChHytvAC/TYOQuel6DXbHsWrPFLQF84?=
 =?us-ascii?Q?E7/CFC9P7HFM5LMAIYto21Z4+05Tvb3+3ATYigaNxuJavv3gurzZddNMblaY?=
 =?us-ascii?Q?2J6fTe5WqGTrSDCUEQXCOn9mkxY61s/BYha+a5WlzlZE8HOdJYmbHCUCXgvz?=
 =?us-ascii?Q?E3b+R28C52A1diywugbigqsY8mSTa1bbydvCBD5k5AS7Ro6IJApTo219H1qt?=
 =?us-ascii?Q?dn9CeQAYYyVUru0vvdN/qdR6xzJfzGAklignSrffXvpfpqSTdsX04v27K/17?=
 =?us-ascii?Q?sfAn9Ft4GxT+VxvFmyXvJ/bWgLPmgOKZAQqSwU6tKVjqRD9eaH5LDCJmWCI9?=
 =?us-ascii?Q?iSL0J5A2WqW540uncmBu7Yprbg2I98cpmQPVaLtZcYepxwZlUhVKGiabw6J6?=
 =?us-ascii?Q?wGbOSrG9r+4FuOcJkhUmY8bWTogMDgpBGBMYvz5A3fW+545MYh/76yx1YfJ8?=
 =?us-ascii?Q?YjziYrK2+R8nIK2zvmPUyKhWjKUokLiRzQJywSxNtEdKfiJHETfpk8MIlrN7?=
 =?us-ascii?Q?YjMavP+X1bzxK+atsxqlMqC5gbHhTsqQ1JPCDPMHHSJe1EM52HD+kmZHaqr/?=
 =?us-ascii?Q?G+R2jw5zjhPqvlUGhEtWb5aaBBS9cXjXP3OhoFnHMP9INazWUGE2cInQ7Mqt?=
 =?us-ascii?Q?egFX6vE+7gcS1sixzcmjYqd8RBxOlVIpWnb3qYwxihe3CHc5mQ/6qKPYVI+k?=
 =?us-ascii?Q?ghLjjoqAKkRCOo10Aooy8WKiB1q0parLyGzEAr5sP+XYoAEi5C3W8Lt22xty?=
 =?us-ascii?Q?yuGRhfUci6egHMxQ6lnCxII4sJ7O8tx8VkvalSuURbJt4BvG68Q04ShHuGFK?=
 =?us-ascii?Q?S8E8YKtcff+C+yKdFGDMQibzk4/EiAsJ8/gmnxDv1rhBdxHKt2sCFfZgPw0V?=
 =?us-ascii?Q?YUklKk1MvzOVyrCRmfVhIZi6uQQIkhKN2UNhxP0tASSUsWqM2E1VabFXxv/6?=
 =?us-ascii?Q?7r/ZOQesoZuncqiTFPCyghamiLBJ8CAz0PI85rYhpI5stzOnIKHQZK1dXajm?=
 =?us-ascii?Q?vAyGAHy+kox6jzxWzHGy2g54GlDFGWZ4UpRQV4dIFmbmS0/2joHjHvz+r5Jz?=
 =?us-ascii?Q?y1Xz17RcK7bMFYgMYfueebCt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 597c08da-dc2f-4044-ff6c-08d91e145404
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:10.8628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Mu2Nbqd3TXLHxAOgLTqhAh8R9X7kHEY9DAfh6OigKSLfIJtFq8q/un25XSose8QypZcXwUXTI1NdxeXTxow8y+cYEtXR3Ni0US8X1j6pzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3239
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-GUID: UUrff4AC7GC8t96boG0yOrm459mOSorp
X-Proofpoint-ORIG-GUID: UUrff4AC7GC8t96boG0yOrm459mOSorp
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the SCSI cmd completes after qedi_tmf_work calls iscsi_itt_to_task then
the qedi qedi_cmd->task_id could be freed and used for another cmd. If we
then call qedi_iscsi_cleanup_task with that task_id we will be cleaning up
the wrong cmd.

This patch has us wait to release the task_id until the last put has been
done on the iscsi_task. Because libiscsi grabs a ref to the task when
sending the abort, we know that for the non abort timeout case that the
task_id we are referencing is for the cmd that was supposed to be aborted.

The next patch will fix the case where the abort timesout while we are
running qedi_tmf_work.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 15 ---------------
 drivers/scsi/qedi/qedi_iscsi.c | 20 +++++++++++++++++---
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index cf57b4e49700..c12bb2dd5ff9 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -73,7 +73,6 @@ static void qedi_process_logout_resp(struct qedi_ctx *qedi,
 	spin_unlock(&qedi_conn->list_lock);
 
 	cmd->state = RESPONSE_RECEIVED;
-	qedi_clear_task_idx(qedi, cmd->task_id);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
 
 	spin_unlock(&session->back_lock);
@@ -138,7 +137,6 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 	spin_unlock(&qedi_conn->list_lock);
 
 	cmd->state = RESPONSE_RECEIVED;
-	qedi_clear_task_idx(qedi, cmd->task_id);
 
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr,
 			     qedi_conn->gen_pdu.resp_buf,
@@ -164,13 +162,11 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	iscsi_block_session(session->cls_session);
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
 	if (rval) {
-		qedi_clear_task_idx(qedi, qedi_cmd->task_id);
 		iscsi_unblock_session(session->cls_session);
 		goto exit_tmf_resp;
 	}
 
 	iscsi_unblock_session(session->cls_session);
-	qedi_clear_task_idx(qedi, qedi_cmd->task_id);
 
 	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
@@ -245,8 +241,6 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 		goto unblock_sess;
 	}
 
-	qedi_clear_task_idx(qedi, qedi_cmd->task_id);
-
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
 	kfree(resp_hdr_ptr);
 
@@ -314,7 +308,6 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 		  "Freeing tid=0x%x for cid=0x%x\n",
 		  cmd->task_id, qedi_conn->iscsi_conn_id);
 	cmd->state = RESPONSE_RECEIVED;
-	qedi_clear_task_idx(qedi, cmd->task_id);
 }
 
 static void qedi_get_rq_bdq_buf(struct qedi_ctx *qedi,
@@ -468,7 +461,6 @@ static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
 		}
 
 		spin_unlock(&qedi_conn->list_lock);
-		qedi_clear_task_idx(qedi, cmd->task_id);
 	}
 
 done:
@@ -673,7 +665,6 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 	if (qedi_io_tracing)
 		qedi_trace_io(qedi, task, cmd->task_id, QEDI_IO_TRACE_RSP);
 
-	qedi_clear_task_idx(qedi, cmd->task_id);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
 			     conn->data, datalen);
 error:
@@ -730,7 +721,6 @@ static void qedi_process_nopin_local_cmpl(struct qedi_ctx *qedi,
 		  cqe->itid, cmd->task_id);
 
 	cmd->state = RESPONSE_RECEIVED;
-	qedi_clear_task_idx(qedi, cmd->task_id);
 
 	spin_lock_bh(&session->back_lock);
 	__iscsi_put_task(task);
@@ -748,7 +738,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 	itt_t protoitt = 0;
 	int found = 0;
 	struct qedi_cmd *qedi_cmd = NULL;
-	u32 rtid = 0;
 	u32 iscsi_cid;
 	struct qedi_conn *qedi_conn;
 	struct qedi_cmd *dbg_cmd;
@@ -779,7 +768,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			found = 1;
 			mtask = qedi_cmd->task;
 			tmf_hdr = (struct iscsi_tm *)mtask->hdr;
-			rtid = work->rtid;
 
 			list_del_init(&work->list);
 			kfree(work);
@@ -821,8 +809,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			if (qedi_cmd->state == CLEANUP_WAIT_FAILED)
 				qedi_cmd->state = CLEANUP_RECV;
 
-			qedi_clear_task_idx(qedi_conn->qedi, rtid);
-
 			spin_lock(&qedi_conn->list_lock);
 			if (likely(dbg_cmd->io_cmd_in_list)) {
 				dbg_cmd->io_cmd_in_list = false;
@@ -856,7 +842,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
 			  "Freeing tid=0x%x for cid=0x%x\n",
 			  cqe->itid, qedi_conn->iscsi_conn_id);
-		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
 
 	} else {
 		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 80f8d35b5900..5304a028db0a 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -783,7 +783,6 @@ static int qedi_mtask_xmit(struct iscsi_conn *conn, struct iscsi_task *task)
 	}
 
 	cmd->conn = conn->dd_data;
-	cmd->scsi_cmd = NULL;
 	return qedi_iscsi_send_generic_request(task);
 }
 
@@ -794,6 +793,10 @@ static int qedi_task_xmit(struct iscsi_task *task)
 	struct qedi_cmd *cmd = task->dd_data;
 	struct scsi_cmnd *sc = task->sc;
 
+	/* Clear now so in cleanup_task we know it didn't make it */
+	cmd->scsi_cmd = NULL;
+	cmd->task_id = U16_MAX;
+
 	if (test_bit(QEDI_IN_SHUTDOWN, &qedi_conn->qedi->flags))
 		return -ENODEV;
 
@@ -1391,13 +1394,24 @@ static umode_t qedi_attr_is_visible(int param_type, int param)
 
 static void qedi_cleanup_task(struct iscsi_task *task)
 {
-	if (!task->sc || task->state == ISCSI_TASK_PENDING) {
+	struct qedi_cmd *cmd;
+
+	if (task->state == ISCSI_TASK_PENDING) {
 		QEDI_INFO(NULL, QEDI_LOG_IO, "Returning ref_cnt=%d\n",
 			  refcount_read(&task->refcount));
 		return;
 	}
 
-	qedi_iscsi_unmap_sg_list(task->dd_data);
+	if (task->sc)
+		qedi_iscsi_unmap_sg_list(task->dd_data);
+
+	cmd = task->dd_data;
+	if (cmd->task_id != U16_MAX)
+		qedi_clear_task_idx(iscsi_host_priv(task->conn->session->host),
+				    cmd->task_id);
+
+	cmd->task_id = U16_MAX;
+	cmd->scsi_cmd = NULL;
 }
 
 struct iscsi_transport qedi_iscsi_transport = {
-- 
2.25.1

