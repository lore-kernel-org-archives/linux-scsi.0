Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85878C4707F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CC9161404
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhEYSVC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:21:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56034 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbhEYSUn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIG1sA074924;
        Tue, 25 May 2021 18:19:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=XHUZVJZLbKxexs2JQozxMaBq5DpLnfmYpG19Op+JHuI=;
 b=BllpPgKjrsVT/RVx90295xaL6G1QoJrQwBXIAmICP9u273MIqZxVmusRwvMvEkwcGO5r
 HQkLWiWLE1+7Il+uptUWMnh4QzXsAz4625D7sRJa/xovq0LrUT5uEZjND1oCczX9JtzG
 CileUJ0U3WjTjR0BcVla600q5gSbwGdR5inH0ohCZdWkqftrxxeF07Bmvz0ZDDT+lYkx
 SS1SRw/2nYqkkBCwZeWS7k8Z9KtLqpdqHYCkyOPD2RvDAu5+vjSEzNggQADDC1mRYI/E
 xcKWP4+kPTqfYcgG9dqDB75qt4BWuieFIiQrxSKKc3AWQoS4YyHRD7Oq6JVHBvYOnzKs hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38ptkp6vmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:19:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFGMp104688;
        Tue, 25 May 2021 18:19:04 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by userp3030.oracle.com with ESMTP id 38pq2ufk67-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:19:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnwFDB+XHJ0o9gvLofJZ426ZrJE2/Pb6MADv6DQnXvJjmmY7g7bGdNSUUe5tLRS/30fuhJfiWyDDGTXozoxI8CPgeDydgrCbcPm806sGgDQVjGJBRFyJJ6pUCwHpvUu6st/ByG5sN8KTJaQKfg1b3klJOurmtJ1uZzJ8aPg3DFrs0g8Vl7a66CXIWcttZNS6fEY0ER4TWHYa2E8uN66f94XNvxMZIuo5X4HTf1i5B4HctjZTeOokg+193CSI1hZj9TCrds4pARBD1YY0Uj9WswOTKUPUrnd77srbiOg4B54YRGgDfoHRXFsSwyx8njDKtCUZNaw2pg2bPrqsbfvqDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHUZVJZLbKxexs2JQozxMaBq5DpLnfmYpG19Op+JHuI=;
 b=QTlb/z99WcsC4SxDH9QT4LGPFw1xGgTXomJQCyXKss2TWUHvFqPsesZVlR+sXm2/E4ysCDDOT/q+VEuj6Jpp+WK6lcysdQJp1Txv7c5weiJ8vqMxI0VIdbQqgkEEPe2sSKdb4baE0M9iKt/nlEGMGoNWwPAWNm///fnw9M51iDs/dOUD1xgP1csDFvR4t8BbhShTXOv2pV1do7itJDnSyJZYPDVV3UPclxPviNeAT5VFxP0QjfjEExS/U/SZVGLg1bw83AF9q/TgROVerB5lDli258zJcvmW+hmxuzYekuSZcT+FSQCh4W7yqFrqAsODMTMyMxD3DU1HC6T2smXUsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHUZVJZLbKxexs2JQozxMaBq5DpLnfmYpG19Op+JHuI=;
 b=dhX08iOW9Rj6h5caiF25MoJuR/KV4sns/g2QkmuKeMbaSKRWxV9BOxY+N5MRrR2s35H7st3WtaxM4+VLxaQTpLyayXa/YQvQp4CptQ2qC0TnnLRUGm1DIKq2CNJj1iZFwXFSbrDMBMvgCnEEKTY0Na3mMmH6mWFLRntMWcPiJQE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:58 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 27/28] scsi: qedi: Complete TMF works before disconnect
Date:   Tue, 25 May 2021 13:18:20 -0500
Message-Id: <20210525181821.7617-28-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee1ba30e-e010-4653-1a48-08d91fa99069
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3891511855A7C1F99404B43BF1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 30nisDwybucBnCReXQfh9DZSPaQWV/luDbW2nWXckPrltvavsLUYXMsvAFR8VpbWup7mdOY05xP+kd2mgDX1caDtjDxPdyHDvvZ4bxWV9S92slmmKfYAkgvOZFj64RtgoU7Qtn/ccsgR3ktukhntS9sA79a63j4KSPAx+PEpR/KFCIXI/5c2EH69uJiE685j69qa1uqSPUVc8Dre1VHC2A1/qrgw0eWwTOy795poji93iPBW2PRkDnRi6xG6OO3Cb/ZEDhFi8lfgxQzRhUOa/nrIt9TvxCkOHxYHCN4Wt+emGAjlXZNKmuo8ajDfwaEnpebJF8K1zv2s5nXc7Tj1NXqXEDTuBxNudKGnRYZCfDgNC+r3Z6hIziUApwVa3PBERVaAPTRdN31PHf8/3YtGFEfCPZPx3RRTdw4hf5nc6tqOoTEqNHIu03EduWH5QFfQKGV1XMYyBRBUpvFiUddGxQLARRv4b47O2DPwi2gbUtx3ewbQamaTz8bZ3ml5XrUtR5P62a0ghY1giJe2ACnWOkcdqJaRTbQR5KhrfN7Lx7B5vjUPmX+qUXuqmZGdqk6eUbZ9J6TBkXPLz1ChCzv0voXir7nmCqm9Ddyn7lPpBlBI1Bf5XaMwQadrd1ORZlfSV9bfHXGN6oTwDE8Rqn5r3c+intY79+IVEXVOAY0fdIIMSr7d+D9+uPRO7XpPyZpF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?w0FGI/pkyrY5DqD4MugUhi0znK9JtRjVLX552oCR1sVSohjpHkb0ucFEWLLQ?=
 =?us-ascii?Q?pvl0fvd5Ri7nALwRHDx1RFjYZe8xRREdwICVbPkOTgODUPNZs0V2EtVmeRDG?=
 =?us-ascii?Q?X3vTgPqy1nYC84AkQGrBey2xio/FtkvfLMRGnWQPWRxwDdPlZNsLu+gvUScm?=
 =?us-ascii?Q?zHqJIoQ/CXa/GZoDReuEM/1o8CElYPqOQCgEWIxJN1cnam0wRxEGlmkwV9hK?=
 =?us-ascii?Q?eFHgm1f7M63zta6ODdgqLvI3okOERCpeGVJ7sGKpk/+qR/ZxOzjvnSXQfgon?=
 =?us-ascii?Q?m2QQlHy3/6Xp+9LlvH/5FFhlCNqNfVBKRDU325rthnyQJXiCd9vOHvdtjRXw?=
 =?us-ascii?Q?K/CJM3FvZOXZiBVTOGp9GCygd/i7f1aB9fTzt+Fq22wrU2PHrHn+76FxUyKa?=
 =?us-ascii?Q?DtTk8sy8YHkXd6mtRtBBpB8bguUoIUzYaBTUqXs/U5RmFxLmp9Mew4uXQYrk?=
 =?us-ascii?Q?PX1ZKWGcz7pfB2iKd6/x7R0eATOcFUKw9Ccj7PCNNNf595SqDeVS8Xz96+fF?=
 =?us-ascii?Q?hdmi5xue7H5mMhm7YYw+xk02pClr6GI1+AS36Qtxc595G/puofm/4Y8l+9nC?=
 =?us-ascii?Q?1P4Q4L1jLnfnz1ZCfw1SM4rstq97eQBmn8aa5lgZkyKUcFkTkaGMQa8/H5sg?=
 =?us-ascii?Q?srpBzqAcwjZFr05ZBlfwxWnhTlzdkgQ928agRF+VSSz/Im+akZ++I9sOaJ9m?=
 =?us-ascii?Q?jKOJJsDb0b25RBNwedzTYfA96yRq8+SiO0kWIEueJfULsk/gwRysjFrUZKyB?=
 =?us-ascii?Q?zVyAZOR2BP3ySxmv70oFzmIG0oR7PeBTNqiFdHeILUit0Y1T6aY/NtP6hibP?=
 =?us-ascii?Q?t7DfZ9sjGrVwcp60lMjBqm8CsJqCa+yI170wNcgkDwJAvk77ybhwH8Ry2UwS?=
 =?us-ascii?Q?8nBrx1+EQGYVohnmKa4pDcegWHjJlf46nA5KtsiVe02+cPW1tlupyvch5TLn?=
 =?us-ascii?Q?Zc+Z4yxp1eZpqsm6E0GRzBT/EAt8BObilcOegH4kFalVyIiIi3s6WLPSAlJn?=
 =?us-ascii?Q?NfRcWZXSjvkG4Hf2SRI2WI355H35noZ0dVpA7eluYsLuzblZ8YM7vjbnc2+N?=
 =?us-ascii?Q?1omqfLUFB91jiSr/H5hdCetUVFnWLHrbhlkpHbKqiqW6vsh/W82pOEK5HWMm?=
 =?us-ascii?Q?7FV2ukAt6I/vQEukPm55cUETm+7aTBnAnJ/9ZvRugU94dLi15vaIxAEyjzY8?=
 =?us-ascii?Q?jbSRku/0vCt7AkIpPeTj/kVn3/yI+PwfA6rrtiw0YIf4tDmALflY/Au4jFg+?=
 =?us-ascii?Q?nNhnYxLHrSD/p5xT1HN2Ksg4AY3rpc0hC6pIXQn4X87HbftiIlyWhQf6aFGy?=
 =?us-ascii?Q?kzJAYJ4XJuj4ErQHTSiy9fSJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee1ba30e-e010-4653-1a48-08d91fa99069
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:58.3966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghbR7l2tvWNWHcjYTTl2RWfhfash10oDnpHjCJmv8mmctDOyxPcqkW/t68HIKkTUNWLy3yvxd4VkjqzYSBflb4z3EnXkwFdRYPpd1pVLs/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-GUID: d5_2ivffnFRa1vxRJMXDkJk-zUeNzXDY
X-Proofpoint-ORIG-GUID: d5_2ivffnFRa1vxRJMXDkJk-zUeNzXDY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need to make sure that abort and reset completion work has completed
before ep_disconnect returns. After ep_disconnect we can't manipulate
cmds because libiscsi will call conn_stop and take onwership.

We are trying to make sure abort work and reset completion work has
completed before we do the cmd clean up in ep_disconnect. The problem is
that:

1. the work function sets the QEDI_CONN_FW_CLEANUP bit, so if the work was
still pending we would not see the bit set. We need to do this before the
work is queued.

2. If we had multiple works queued then we could break from the loop in
qedi_ep_disconnect early because when abort work 1 completes it could
clear QEDI_CONN_FW_CLEANUP. qedi_ep_disconnect could then see that before
work 2 has run.

3. A TMF reset completion work could run after ep_disconnect starts
cleaning up cmds via qedi_clearsq. ep_disconnect's call to qedi_clearsq
-> qedi_cleanup_all_io would might think it's done cleaning up cmds, but
the reset completion work could still be running. We then return from
ep_disconnect while still doing cleanup.

This replaces the bit with a counter to track the number of queued TMF
works, and adds a bool to prevent new works from starting from the
completion path once a ep_disconnect starts.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 42 ++++++++++++++++++++++------------
 drivers/scsi/qedi/qedi_iscsi.c | 23 +++++++++++++------
 drivers/scsi/qedi/qedi_iscsi.h |  4 ++--
 3 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 4ee1ce1dcdef..3de1422ce80b 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -156,7 +156,6 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	struct iscsi_tm_rsp *resp_hdr_ptr;
 	int rval = 0;
 
-	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	resp_hdr_ptr =  (struct iscsi_tm_rsp *)qedi_cmd->tmf_resp_buf;
 
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
@@ -169,7 +168,10 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 
 exit_tmf_resp:
 	kfree(resp_hdr_ptr);
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+
+	spin_lock(&qedi_conn->tmf_work_lock);
+	qedi_conn->fw_cleanup_works--;
+	spin_unlock(&qedi_conn->tmf_work_lock);
 }
 
 static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
@@ -225,16 +227,25 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 	}
 	spin_unlock(&qedi_conn->list_lock);
 
-	if (((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-	      ISCSI_TM_FUNC_LOGICAL_UNIT_RESET) ||
-	    ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-	      ISCSI_TM_FUNC_TARGET_WARM_RESET) ||
-	    ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-	      ISCSI_TM_FUNC_TARGET_COLD_RESET)) {
+	spin_lock(&qedi_conn->tmf_work_lock);
+	switch (tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
+	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
+	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
+	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
+		if (qedi_conn->ep_disconnect_starting) {
+			/* Session is down so ep_disconnect will clean up */
+			spin_unlock(&qedi_conn->tmf_work_lock);
+			goto unblock_sess;
+		}
+
+		qedi_conn->fw_cleanup_works++;
+		spin_unlock(&qedi_conn->tmf_work_lock);
+
 		INIT_WORK(&qedi_cmd->tmf_work, qedi_tmf_resp_work);
 		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
 		goto unblock_sess;
 	}
+	spin_unlock(&qedi_conn->tmf_work_lock);
 
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
 	kfree(resp_hdr_ptr);
@@ -1359,7 +1370,6 @@ static void qedi_abort_work(struct work_struct *work)
 
 	mtask = qedi_cmd->task;
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
-	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 
 	spin_lock_bh(&conn->session->back_lock);
 	ctask = iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
@@ -1429,10 +1439,7 @@ static void qedi_abort_work(struct work_struct *work)
 
 send_tmf:
 	send_iscsi_tmf(qedi_conn, qedi_cmd->task, ctask);
-
-clear_cleanup:
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
-	return;
+	goto clear_cleanup;
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
@@ -1451,7 +1458,10 @@ static void qedi_abort_work(struct work_struct *work)
 	}
 	spin_unlock(&qedi_conn->list_lock);
 
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+clear_cleanup:
+	spin_lock(&qedi_conn->tmf_work_lock);
+	qedi_conn->fw_cleanup_works--;
+	spin_unlock(&qedi_conn->tmf_work_lock);
 }
 
 static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask,
@@ -1546,6 +1556,10 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 
 	switch (tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
 	case ISCSI_TM_FUNC_ABORT_TASK:
+		spin_lock(&qedi_conn->tmf_work_lock);
+		qedi_conn->fw_cleanup_works++;
+		spin_unlock(&qedi_conn->tmf_work_lock);
+
 		INIT_WORK(&qedi_cmd->tmf_work, qedi_abort_work);
 		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
 		break;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index ddb47784eb4a..bf581ecea897 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -603,7 +603,11 @@ static int qedi_conn_start(struct iscsi_cls_conn *cls_conn)
 		goto start_err;
 	}
 
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+	spin_lock(&qedi_conn->tmf_work_lock);
+	qedi_conn->fw_cleanup_works = 0;
+	qedi_conn->ep_disconnect_starting = false;
+	spin_unlock(&qedi_conn->tmf_work_lock);
+
 	qedi_conn->abrt_conn = 0;
 
 	rval = iscsi_conn_start(cls_conn);
@@ -1019,7 +1023,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 	int ret = 0;
 	int wait_delay;
 	int abrt_conn = 0;
-	int count = 10;
 
 	wait_delay = 60 * HZ + DEF_MAX_RT_TIME;
 	qedi_ep = ep->dd_data;
@@ -1035,13 +1038,19 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 		qedi_conn = qedi_ep->conn;
 		abrt_conn = qedi_conn->abrt_conn;
 
-		while (count--)	{
-			if (!test_bit(QEDI_CONN_FW_CLEANUP,
-				      &qedi_conn->flags)) {
-				break;
-			}
+		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+			  "cid=0x%x qedi_ep=%p waiting for %d tmfs\n",
+			  qedi_ep->iscsi_cid, qedi_ep,
+			  qedi_conn->fw_cleanup_works);
+
+		spin_lock(&qedi_conn->tmf_work_lock);
+		qedi_conn->ep_disconnect_starting = true;
+		while (qedi_conn->fw_cleanup_works > 0) {
+			spin_unlock(&qedi_conn->tmf_work_lock);
 			msleep(1000);
+			spin_lock(&qedi_conn->tmf_work_lock);
 		}
+		spin_unlock(&qedi_conn->tmf_work_lock);
 
 		if (test_bit(QEDI_IN_RECOVERY, &qedi->flags)) {
 			if (qedi_do_not_recover) {
diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
index 68ef519f5480..758735209e15 100644
--- a/drivers/scsi/qedi/qedi_iscsi.h
+++ b/drivers/scsi/qedi/qedi_iscsi.h
@@ -169,8 +169,8 @@ struct qedi_conn {
 	struct list_head tmf_work_list;
 	wait_queue_head_t wait_queue;
 	spinlock_t tmf_work_lock;	/* tmf work lock */
-	unsigned long flags;
-#define QEDI_CONN_FW_CLEANUP	1
+	bool ep_disconnect_starting;
+	int fw_cleanup_works;
 };
 
 struct qedi_cmd {
-- 
2.25.1

