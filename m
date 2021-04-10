Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EAABC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20E98610A2
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbhDJSkz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:40:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52240 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbhDJSky (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:40:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIcwXk115945;
        Sat, 10 Apr 2021 18:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=E7Or41uLBhq+9RTDzkM0COwGM+NEajx1LYKN83pyq5w=;
 b=yeFksY49HeuGam9q2mrUYJywTk5X4JO0K8h/4TYZHj4izGgj4RIeFnB+IfBi5COcq4Gv
 pZhannkbA//WIC6MZnOmSwwfxOnC90xMTGXxVTV6nevh+mfNjopQOJJoYTUPDsxZf/K0
 OsnECRjzoXp3MI6Q/ViZrtyMW8k2l51u7aCVSNL0jhDm+1n6YJj/vaI/mgR/qK1h2UT+
 K5pb3j5Vu7XwTYS7/fa9g22/uvaaaw4IFJQweqVgpOJXiupwOvA8nrjTq0GlafQRk975
 SQ+6VevLoqPSq/EEtrO+lai8NaZTe4/CtTMMpuGWNOIvs8PIVw1xgPawBIQIUHxlNCn1 ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37u3ym8s2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIUY3r190235;
        Sat, 10 Apr 2021 18:40:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by aserp3030.oracle.com with ESMTP id 37u3g0feb5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/Mxk0GiNy/wrMJLOGbL8YYTR1/s8gQH1A+iN/KQayiu2GCGLx5hrKhlQPOa9PfQlt0C9HWUnP+y0PXsm8yceyXNNLk8t1JFCPHJW7rFl82at4nY0Y1TLx0apGxxj8xy1BBrz8lg9in5JyYwH8unWbYsPHUitqdE2Sc1KB1hA39I4y62ohCiI8+biGhdJHyNEeXXIq8ALmTykFPybfcXLvBIuIj+Ii9m1g8budNHgcvlZShb4GP1o7SeyTAtCXhumYUA2LmpU6PzPSPzjio2o0llHQv3QyiITk0rZHbeYSvjjsByx5z0GYuGcpxtZV9RXqi1JFKEmscCSV7CfBEbwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7Or41uLBhq+9RTDzkM0COwGM+NEajx1LYKN83pyq5w=;
 b=T/CLoITrdJg7xygNjtASN58uep+vyiQcu2zTx6GCd2O7fGkv5jeqjPjHVKSrTHCs/lmvUkzAMKXiMCr1qbwC87FmBatzWygkAFUoEAcpvjN9uQjSnLzitXEIy5yc2TZSnFAcqaCojX0/7yWO/wpnBXeA2IAK7oKA5rswZ9/A6xepE6WK/ACPOyQhHuTMD0zKtbpL08kG4k/SFeBVHz3uxUPuFd/FLqcLPmiD1jDla579+xdlYtACNKHLQ2d6xQ1t/kz9C9OkIt2x/dsshKL4SM0HFgisBykMu7sc0V/X5nti0XEfPKhtNRoniU7We/DPXk5WaeaMi7WUb9um+KR5kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7Or41uLBhq+9RTDzkM0COwGM+NEajx1LYKN83pyq5w=;
 b=Z5M6RGn0VTOAAe6d1ADeQkiJjc6Ebc7h42knBykctMNpA+AtLHfAtYG4BWWenhqqGiu38vG2hzvZl/ZHtOHcPGJ8IcX5QqmYXQVNJVBJ3WeX7XILS5KGn6lKUSkdu4l6RfTUl1WYUPBH0M9+pe1TUZM4fpCo+QzrU38H5Q/gKZE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:30 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/13] scsi: qedi: fix abort vs cmd re-use race
Date:   Sat, 10 Apr 2021 13:40:07 -0500
Message-Id: <20210410184016.21603-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210410184016.21603-1-michael.christie@oracle.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR15CA0036.namprd15.prod.outlook.com
 (2603:10b6:4:4b::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5633fd4-41fd-4df5-9dda-08d8fc501dbc
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43245CEE8BA211FC23FF2E18F1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MCPJRNwKMbUt25APV5XC4uFvqvYDhZtfDrs19hbpU31JuVq42p+Oyf18szNP1DqeTAaGXWEY0A7dAMIaV+J4PB6CENBgLyx1tDpomUQ+4fcb7iV0hR6325vgrqdVK97SHk/nipBz+EyWGJj2tvFkZXyrfGXj4qp3vWggslWk68sWd3Ml7NTi0Bx/uP6PISAbhIx6G0JoOApPfoWI4F7cZHIb0vWW64LznInOSeCuKuv4B3RX/KAQurR1UnBAAUyQS3eMzz/S7Btjo9a3LyXgOv2FEKouZxFniX0asYgl+vpmGzncTYKjDkvC3Q4X2Jv/HFYT0JeDk0sQ5iuiI+4xvpd0UyXSTNQsL2BHkZ2spxOy5Yjd6QB5HAEVb3FNCf3J0yu2I5GgKhRRDhcjceiwDaj4NuNbl7X1MLwB6+3yzF3DhU+5AfiyjV8Tjlenmr8adrn2qvU2H7JXC3mtiHChOpnyFdwH5y6egLXy036YjbWXb8+f+6S0ShDDGu6pFPXvGDPcsHE+H80wSWu2xOK8OtuRX9CIa6jf+7rtzfs7ixC5kE29Y0zo0m2pqWtUhHNRcXuAx3rc/FtgqJsUt02VPJCM+y1HAy0hl/9Nn7p7zbZBzL3xspnBNUSqJ1+5+Pzqhf4X90wOWrdRDI6oBDdDO3fofMECgUHFlCEw4Gl0enUsc6e4lkMynm0gmtG0tiIg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(83380400001)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(107886003)(26005)(4326008)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XiD8FFaBHoYpyCbhmOykgLRIhvh1RzgUZF2YCvJXxfMD5Pjhh2vr3Ol88TYC?=
 =?us-ascii?Q?7mJV+zOLwdHPVjKc2anHmt1ZFGdz4UeWdrQyOOC3EQE52io9EP1fMrYmjJO4?=
 =?us-ascii?Q?IayBBitqGeOd4s4vk+i4YQehSr4faygrzTlysMW0OJzhBcvItPBS5dN7CRzu?=
 =?us-ascii?Q?h7y7CJPTGYdH2OPFXybVlLp5BO8huzJYe4BixRsVJiLuHpAZVC+7997zCgmv?=
 =?us-ascii?Q?n0l9m72rNBnocOOJ7dpxXcADRP/M3NnPrkfC0n51tYmp9qbuGsQbdost1QwZ?=
 =?us-ascii?Q?tQOZmMNo7Db7XG35Ve4f5A4i1wD48yHX4RltgVxOBSip4eDwVp8xMiUHTksO?=
 =?us-ascii?Q?bxKfXw9E2TveagFCZgUVxCo5grclaKP9qrpk6sVQKWtunxgakTBlcNDWqJdT?=
 =?us-ascii?Q?Rg7HEnZbsxu/FjefIom0btmeKZOQvBbgP6JcM4935ygBmtjjge8h34cu0jpu?=
 =?us-ascii?Q?F5OT/FhX3t07ckEKwKd/Ct/Khf4NXCORn0QsBbv8YbLgtF1gcku36bY1LJwY?=
 =?us-ascii?Q?5gR8IU0u/Spm+x4SOTLhXU4oqQ+yvXjX2fC67HMazYXYNI9hkywzSjp7Y7UG?=
 =?us-ascii?Q?0z4K9Mf1b7BRdzmF7VAYRPlQkWUXVTriJgcD9yIfvOSgedT9ZjfHpCQyZSCm?=
 =?us-ascii?Q?YlvWZeWMs6PVEDOyt1/7/XeB7CQ0rVQXmvbwcRa9ya+gqvNldiplbFrgto6/?=
 =?us-ascii?Q?BmtKiOuvacSOiPGd1pQ7yRHhZfNWZY6x15WrKsDe1raWVNwxzvaI3yBsbfVb?=
 =?us-ascii?Q?3pVI5C0zs3OKEh8G5Mr3hz5QiRSgvYB4EcSa5NUMf7nOWlz2yY0VV8o5pstu?=
 =?us-ascii?Q?nI02X3oBVTuShzWhQACXpFI9kiQMRmmuPDjObwSXii+aefdqrskp0rox7Mjw?=
 =?us-ascii?Q?9LFff0dzn/C99QSob/GrFdePuQN5NCSnhn3fUH6KLXinhlqJxFz0Wz05Aki6?=
 =?us-ascii?Q?XDDsxO7r9Zprtp5E86X2pYN8OtfzG3XCmJHBMrxjmt5kAWtRd8XeU48nDY/n?=
 =?us-ascii?Q?u2lxx0SW7hNMZSvCWucql3Zj4dRPHGFR+iRX60Dkh2QKJMqAA51FsIgIXt3Z?=
 =?us-ascii?Q?LvVgxDMqjAV0mZZY6/L9iZH+difNvZKffmmBfhFxHZ3PvbGGekj+mynTzIV5?=
 =?us-ascii?Q?UgScYhu59Y0Aup1Ezx967+tThEymJDFp7+TGQ6QlFRm+EfYxZyLXFvGcSvwd?=
 =?us-ascii?Q?9NYncmGBbkodfsZK8/DrnRczQk8W4UjzkkqsanPQFzYaLQdlyAeL/hzrt/VS?=
 =?us-ascii?Q?pPy1aMe+lml0GFrldzon4DqTp+srUwB0yac+IaPw3lkZhihLogB1w2ETL/eq?=
 =?us-ascii?Q?Z2jgvGO38J/0CFCJwFSn0EKq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5633fd4-41fd-4df5-9dda-08d8fc501dbc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:30.1837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pqqe/gSIbkhYWTOw/pDXjF+eT7yYorB/23KxcHTjn8wW/uHDbJOZtmpLC2MKWRWhkP3yOhtowkB/R+XI04NSEH8zhAZOPr9l7nrQFIF0ZzI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104100140
X-Proofpoint-GUID: 9QqwfmGpJxuewRHWvOYwU99iTJBT_75E
X-Proofpoint-ORIG-GUID: 9QqwfmGpJxuewRHWvOYwU99iTJBT_75E
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the scsi cmd completes after qedi_tmf_work calls iscsi_itt_to_task
then the qedi qedi_cmd->task_id could be freed and used for another
cmd. If we then call qedi_iscsi_cleanup_task with that task_id we will
be cleaning up the wrong cmd.

This patch has us wait to release the task_id until the last put has been
done on the iscsi_task. Because libiscsi grabs a ref to the task when
sending the abort, we know that for the non abort timeout case that the
task_id we are referencing is for the cmd that was supposed to be aborted.

The next patch will fix the case where the abort timesout while we are
running qedi_tmf_work.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 13 -------------
 drivers/scsi/qedi/qedi_iscsi.c | 20 +++++++++++++++++---
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index cf57b4e49700..ad4357e4c15d 100644
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
@@ -821,8 +811,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			if (qedi_cmd->state == CLEANUP_WAIT_FAILED)
 				qedi_cmd->state = CLEANUP_RECV;
 
-			qedi_clear_task_idx(qedi_conn->qedi, rtid);
-
 			spin_lock(&qedi_conn->list_lock);
 			if (likely(dbg_cmd->io_cmd_in_list)) {
 				dbg_cmd->io_cmd_in_list = false;
@@ -856,7 +844,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
 			  "Freeing tid=0x%x for cid=0x%x\n",
 			  cqe->itid, qedi_conn->iscsi_conn_id);
-		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
 
 	} else {
 		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 08c05403cd72..d1da34a938da 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -772,7 +772,6 @@ static int qedi_mtask_xmit(struct iscsi_conn *conn, struct iscsi_task *task)
 	}
 
 	cmd->conn = conn->dd_data;
-	cmd->scsi_cmd = NULL;
 	return qedi_iscsi_send_generic_request(task);
 }
 
@@ -783,6 +782,10 @@ static int qedi_task_xmit(struct iscsi_task *task)
 	struct qedi_cmd *cmd = task->dd_data;
 	struct scsi_cmnd *sc = task->sc;
 
+	/* Clear now so in cleanup_task we know it didn't make it */
+	cmd->scsi_cmd = NULL;
+	cmd->task_id = -1;
+
 	if (test_bit(QEDI_IN_SHUTDOWN, &qedi_conn->qedi->flags))
 		return -ENODEV;
 
@@ -1383,13 +1386,24 @@ static umode_t qedi_attr_is_visible(int param_type, int param)
 
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
+	if (cmd->task_id != -1)
+		qedi_clear_task_idx(iscsi_host_priv(task->conn->session->host),
+				    cmd->task_id);
+
+	cmd->task_id = -1;
+	cmd->scsi_cmd = NULL;
 }
 
 struct iscsi_transport qedi_iscsi_transport = {
-- 
2.25.1

