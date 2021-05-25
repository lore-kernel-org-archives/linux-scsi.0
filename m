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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3604C4707F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9360F61404
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhEYSUd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47116 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbhEYSU0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFh8L053208;
        Tue, 25 May 2021 18:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fmbFLZd9kiQinVQTk7K1kpThqTEVbVxFQglg3R2ObPU=;
 b=oMcUBrTMQpjqul0QQH536fNaxaqhLHYpRL7JlA1vKrhlZpu2BnpsHwb+9moKMCB5FljT
 0/92IdqMKx9oHVaf1c3BTgnzj0mtUOqjUjH6HJoGIjLhJDcA8d+X+OudDaFpSn4hZstP
 g6gBToIYbS+O9Hj+PtvPlSGSIQ1NVd08q5WTWKjpvokmo0ldkQC8g/rmlLCPv5gQhPJG
 65UEkInhRV4dlkLn77vVB2Pl6a9w+rLY/cb3S1mcYs0sAHCNeXjLqh+kqzB4T17ZUPCE
 aASdj07m4rGen54JcM66Ef/ZjF6TSDrlufH61CUauluHdDsTiEHpWx4kHJCL1Jkp8v4m MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38rne42guq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIGDX8010869;
        Tue, 25 May 2021 18:18:48 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by userp3020.oracle.com with ESMTP id 38qbqsgh0g-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhNZbLToBO3RnwCER0XCCiYh5UcOY/opo0SmjG3uSmCwkyGmn7BSDBk4tUCAJUU3Xnq93sW37bRKYX/kL7UznP5bYOXb7GNxEwnXdbxFuo2DOMS+Nb9aXvpolLkPZxiDeWZ77hOfTH35LwlW11dykfgKdPUwEGwWXYwhXOJvdnGl8EofXBlsreBpGFixPbwVWqR1EXJ++wA1JkrvHJ7GS6tkO76q7O+KBk1uauHEEaYnbCf9kzV5Z8rmAF7lOV7fdj9Ix/Rb0UTo2ZaHB6YGsVi17SGU2I6r2p0ZowqVEPBGDmJGsCNYgfNdRuZFGnGu2LI2CAvrYEqP7hc9Wy9WwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmbFLZd9kiQinVQTk7K1kpThqTEVbVxFQglg3R2ObPU=;
 b=ghAF874D6HfrUyKeBcaifeU4VxeLSuVKp2itqnRZK6Isv2fmXtdRmDgcg3RQEEKMWvaqJ64JJgdBSwrMeRtee1aPZrnkmvCqMlpaLqVfe5EqDoF5zMI8V5bcurcX4Lprlwct7ykasly7OLIv9kozla6XuPXvI4oEBzzmT4ucC2TQzfqIw4p9o2cMPQVqiZkHVKpTG651I7TRR1hFpOSgv5IpcFVEHekKsFt/26g/4cXuXNhLyQjoLWL1+nbnOFbVv3Id/SmIQ2GyIubTNYy7Tv1QcESRn1R/hTAHUL7irNZ97DYxi5676t0W6J8IAGDXZw1MGPSqNgJD7jvLvuyjbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmbFLZd9kiQinVQTk7K1kpThqTEVbVxFQglg3R2ObPU=;
 b=k6l64Q4kt/ODoCMGU/qVY+1GAsvQ29MnQK3IwXvoU5xKD6qEjnwnhV5XSBV82bC3R/jAEWGBfDbXtelTAuFnB4EDiC7zugihdV5ql8xyofKQUx09lu9P5Vns/0wzE2fTJY20zHvDYcpj24R3W2jYPFy4ZLkiEqhckyt71IQMl/U=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:47 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 17/28] scsi: iscsi: Hold task ref during TMF timeout handling
Date:   Tue, 25 May 2021 13:18:10 -0500
Message-Id: <20210525181821.7617-18-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eb41ce4-4637-415c-b928-08d91fa989d2
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3891B53AD32666161E6C7C2CF1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fRZq1n70q7FFDOK3ZcCnxV9dYNp6Yaoqrri2AYdL+g6oxLypCSQ/70sc6k8fWRHCdlvf+Zv4MM/bO46DQILkz9RqHSNZyA9wJkl31fG16VnOGKa21tq4Jjk80MN2iwHP0gCTXEAYpp3Nm5NYdAbGiiuZi1pwIIZBn3uF4dCoesu3WZRUtSTosU1KxTdQsF2BufrK9TNGccC1jIMWwOqzAKNbRk8jEg/L4H+mN6InjY5htvZtYySrtPqgA7xcq7fk8DrLTOqqL/1dagASBPBq7r0HSzwxx6FDmd34CfQ1oaCVo4ONJWhF1VYufaKE8LbLN5981FiZbX012E/r+9zixiBy/BqCBzAKILWwFOMZTXw6cbmWvGf5iVeDwaduwifowXzS5u0UVovRT7V3WRYCkJAUFRY85m7rMVbJtdMWiSYSfAfkX1Rcim6fOTeUqufby7S9elx6gsvaQ0kOO+jWXYLOOfVjz4KuKEb86+gCZpTPXGobcn6QvFKOZrL6BkbzVpJ0E8nsLfCBlm6Ktv1vvydCer4mZAZ31pmQBbiYdMbc+lNbGDhV9LifidVFO+CfBvequ1px86ZOdzYAsMrhBf9v1ZUUhumEd5SDV9BPs9yojo/XXlD+fHxLn44UapiMg4NoT9X4ElY8GRygIJEdBodxeNmJnA/rO3TpBV7O6rp0bWK2LVbPwWO8+13QDKR4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?penktxftFt6BbC4NDlra8ZMCtc2/mZ2H60bSHEYzNRPB+YaMQ2umMlgRuWlK?=
 =?us-ascii?Q?4210OPyUGIkUwiYsxoixEDMKcBmDIRvUT3eG5Xohabpc9Omk4SY3982BGTDt?=
 =?us-ascii?Q?JWthQJWI+sEZmXt8nHT1aDREkWzT4r6+9Y9D7W/wxlOCkytK8mXIaTKi97pw?=
 =?us-ascii?Q?nbboooheIDGHcaDKq3sKgo9AjLqDgL2eaQsvH0lmC1jQSrijUBCYbYFXNyYN?=
 =?us-ascii?Q?b88B6uO+rj98isPLwwnBaWSzIr2DxZPLGJLg8cMlXIOr4qZgj8A+eATNMaL2?=
 =?us-ascii?Q?ga0sPAr6r8QXotsgbMY2NsjxM7soIY1vhYm5kFkXrD+MmZp1uM0YK8pwOWiL?=
 =?us-ascii?Q?TXnaZC4klkCVvpdvsTt5fujnJFvrnQ5Rxw9URdcbxeRyBxqKIh4YCM7dgWgN?=
 =?us-ascii?Q?Hlp9jYV6Dyjkde8xG1QSuwKq3xx9XCVSzrS3BdQGhFU1FQKBK1K4kjfdgCnH?=
 =?us-ascii?Q?hO4SoNgadTATviPwtiViGaSuTTfvwrKN8uGaN6y5mbHSIm4v1EWAuKlMRTYg?=
 =?us-ascii?Q?eymugqYRt1qBGq74E963/hYBJnUHF7z6L4bqHdq9N6Mx0Rcy4uXPVZZC/FPW?=
 =?us-ascii?Q?JpodniWwN7fzQfqsVUYp5wyLSdbhlaEd+djGYiALMRURqeOLvjgQ5b83KLgX?=
 =?us-ascii?Q?Rs0S5B+DjtG+iIAVT/7ChHMoAgNwjPc0NAMrIDuncMKIsUKsc8+sULwhDZqv?=
 =?us-ascii?Q?Ax9Ssg81ltaUPqkBcH0QplcdNipLUl7lN/QeRYQzajbPA/EOM21nRhbRqz54?=
 =?us-ascii?Q?A8RqNZ3ePI7bpUSzcsQg7xwYSFxivhCcjBdIDmm5LNXynZKT/aXOUCA7xjO9?=
 =?us-ascii?Q?hqSt55W0GlERZQst5wZz8pV1W2MRxJVPyPoNnJW3a6aloyXGIGRn2cFUp/sg?=
 =?us-ascii?Q?V3wNPz20eOaHQXuqN3E/xwexRSH9IC0mZHtRMDEtHeNGR5bNoUjfSbggtb4I?=
 =?us-ascii?Q?xeeraAc8ZvpZMjNW2vKlFvJ7n7A+jzKlB2eEI5KA1/55zUf/lq1H8uYUT3Em?=
 =?us-ascii?Q?+2uDmmwKC7R8nfLva3IUMNG/O6xpqsc/MxJYZxCtgOEleNdNTMGLaH1neqdD?=
 =?us-ascii?Q?+74Mk8zmZgS3rE3kSTlLJSvjvJRnmEiCpPwPUV+unS+1jH7zAqBzK6JLntMX?=
 =?us-ascii?Q?pVioSpmybADBndVBzDoXQjBZsyyNdk6wGquQ9cs/kiotcuchahYX90q7itdS?=
 =?us-ascii?Q?cq29aoc3lpbSA1BPGIFuofa8EbUfTrTcGr8rkYPrvwSYuud+/gO2X30QRuto?=
 =?us-ascii?Q?gXJ1sAdt5fN1sYrzJs1+Imh+ziQAboInSJkQlPj9Ao8VB9UYTuANKSdO80Pw?=
 =?us-ascii?Q?h/NYDefeVr49Vvzp9uiSle6Z?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb41ce4-4637-415c-b928-08d91fa989d2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:47.3557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mdjN6S2ivU1q21osZKN8DF4auKHuyXywZFfp31P/IxG4c1ytRaxBNhfVlZfA3mLIBNtwMid5HTaioGfEYfRLZ8GwAD49O/7/YOdyQKyi+fs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: pLQ0p_LfeccK1HCw9ExzYNvpfJvHO0qD
X-Proofpoint-GUID: pLQ0p_LfeccK1HCw9ExzYNvpfJvHO0qD
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For aborts, qedi needs to cleanup the FW then send the TMF from a worker
thread. While it's doing these the cmd could complete normally and the TMF
could time out. libiscsi would then complete the iscsi_task which will
call into the driver to cleanup the driver level resources while it still
might be accessing them for the cleanup/abort.

This has iscsi_eh_abort keep the iscsi_task ref if the TMF times out, so
qedi does not have to worry about if the task is being freed while in use
and does not need to get its own ref.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 15 ++++++++++++++-
 include/scsi/libiscsi.h |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8222db4f8fef..e57d6355e7c7 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -573,6 +573,11 @@ static bool cleanup_queued_task(struct iscsi_task *task)
 			__iscsi_put_task(task);
 	}
 
+	if (conn->session->running_aborted_task == task) {
+		conn->session->running_aborted_task = NULL;
+		__iscsi_put_task(task);
+	}
+
 	if (conn->task == task) {
 		conn->task = NULL;
 		__iscsi_put_task(task);
@@ -2334,6 +2339,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		iscsi_start_tx(conn);
 		goto success_unlocked;
 	case TMF_TIMEDOUT:
+		session->running_aborted_task = task;
 		spin_unlock_bh(&session->frwd_lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto failed_unlocked;
@@ -2367,7 +2373,14 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 failed_unlocked:
 	ISCSI_DBG_EH(session, "abort failed [sc %p itt 0x%x]\n", sc,
 		     task ? task->itt : 0);
-	iscsi_put_task(task);
+	/*
+	 * The driver might be accessing the task so hold the ref. The conn
+	 * stop cleanup will drop the ref after ep_disconnect so we know the
+	 * driver's no longer touching the task.
+	 */
+	if (!session->running_aborted_task)
+		iscsi_put_task(task);
+
 	iscsi_put_conn(conn->cls_conn);
 	mutex_unlock(&session->eh_mutex);
 	return FAILED;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 9d7908265afe..4ee233e5a6ff 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -276,6 +276,7 @@ struct iscsi_session {
 	struct iscsi_tm		tmhdr;
 	struct timer_list	tmf_timer;
 	int			tmf_state;	/* see TMF_INITIAL, etc.*/
+	struct iscsi_task	*running_aborted_task;
 
 	/* iSCSI session-wide sequencing */
 	uint32_t		cmdsn;
-- 
2.25.1

