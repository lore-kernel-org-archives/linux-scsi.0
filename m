Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937D1C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 668C660FED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbhDJSlX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:41:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52414 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbhDJSlU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:41:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIYpAZ113720;
        Sat, 10 Apr 2021 18:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ZFnlt/kSxHecqTnovIlf6h21S6n0e6BIa46SxHbIA2M=;
 b=ze3mKnRTrXcRZjoog52XwoRvA0IpnIAtB/GgsU2uhgAILCp5WSYCAeso3nSNDhlaF7pP
 6nR18+LyYjU1X3N3WQyDBi2OG0iIaEtG6Apj/4gSbiu9CBfY3svoMfRP4KwXrC3t/TxL
 av6nIyf882K3WUAWw/5j8wGfiNjiosioBSw7+9qA1eUkdjIZ+b2B4Snv3LySo7hipqGR
 7GF667eIw/utbG+Xg10s3RfKVMjEdqlLzhiJVPMnaeUyJdygHXYflFBeaUC56ZcHcWMl
 NIDepmuob31DhXEMDRjrToMeEn0cND0JejfB4T90kyqTr1hO7RjioTahp53FwELrVu95 Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37u3ym8s2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIUZZY190276;
        Sat, 10 Apr 2021 18:40:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 37u3g0fee1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKzuSdsr6KTXqLKR1jQ1m+s2BCGEsh/OcRBKNhDG0IPtpBC0cAO8Yo445XSmkNYiUq8wT7Yqa82OtLZbixwY8fQ5WmOgdyT1lxhYxVRmPVNZmPXj1OSKmTwnDa12c3OElQQtwk6lUwjkpDep7A3aIItGCXxe5Qam6v2LXzuUWAk9q+5C2NdUxrTo7QCIIgvtDS5sLV/0u9cRId5ZG/uns469K0NXu0EMrYLckWqsKbp/08DEadDt9B8WSUJR+k3x/zORf8GbBZ4Is5XsqFHuN5TdGdKjojnHJRXu9JfCw6guRTP75TJfns0e0PgGQuyPauQJ55JFlV58DVVdbKmtRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFnlt/kSxHecqTnovIlf6h21S6n0e6BIa46SxHbIA2M=;
 b=CVwEvTbqwDOJx7mW0foF+eDuc1e3FuWWB8fg2uH6OAjakNlrsNJ8Mf0+0MCwZrOu4pIe1T+d19LQQ7Iz30defFWRCTQbobJo2FXwgZw1BamQY0cph1t75bONARKTIJfGEUW+KqMZwFNohbUPaW4n/+WhQPd2tIQgKtw6TIAriIuVNNAomyy0iDsSdchAkNCnnCaXMq2q+eqg6VDK5NKiCf5IRJgClgoMfREIiNuFA495kOzwwacoRLELUgL6rl09DEV2RiRCt5DcBTn803oEZCJoAWtJylYla+appnzG59yQHtuhXfrZJeAFHzp/C0Q0c4/vuwjehy0s2axWzpdLxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFnlt/kSxHecqTnovIlf6h21S6n0e6BIa46SxHbIA2M=;
 b=CLexTC8SmRfuGGGdX4Hweh/YfXLcg34RQdqh7hu+SPixS8lKQnPRBYlB44qsQika3sMLQNvXwf3hkjmJD8AKTnpKCzCpppqExJTvJDChGGIyHYC+uWBFYRQ7M4wNaBnAcql3oOkQvN987SBMjQvQHEeYz5nSHDrENJRCTUO6Bj4=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:42 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/13] scsi: qedi: make sure tmf works are done before disconnect
Date:   Sat, 10 Apr 2021 13:40:15 -0500
Message-Id: <20210410184016.21603-13-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8492f01-0170-4e86-c4fc-08d8fc502279
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4324D5863E77EBEBB03D4E6CF1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dlT5zzhfOLLwNVfoDBD6Tl9k/Fx5bH8w6OssfzJ9BtUkCTliE14pgpSuzBg6DYHiuUN+KyY6zzoDeCOAhcTIpZGpBg25lpLxGkxXfHl//kyvZ6ZOTCy4LvbHZq3uW4GTSDIVO7geA5+SS4vFstW0WVoSl/R5wS+0PUtOMYNFOZr0elCZVAeIXMAeoUkcbRAK1GW1xpKGXn56JGgsa4NR5oM6TvAAqo5TPH+6B2fFbeatPkNty2IpI8U95uml0ijKQEWGdSl6Cwj24FpooiqKba4/olYKFyPxHIFdmo3JuVDs2eQPMVJa1w0B0fBG60G9etWZc9HxFBSNP1/yJcDM87cjk3uVaJWlewJqBkKQmHhqRXSpj1Tdx6roUF/Dc27698H6GE1XDaYH0dr4KDT+aC3KZU6rIhF1ip6Un70AK75xZmXJVb9vN+q3tDYF/t9d0htJ0jYlBzKK3pRrER9GpdBnC5MpdI3X2uPmOfe2LCc1LOCBekB+a4eqfdBu5MDcyJSR62zh5lt6JAHA0XFS/+EcxSh8dYbPLnBiB7Bof3e5S2LlTwrtWBtBMM2ncXky91MpiQlDoto2t9OlnYdhLBen/y14hPoLgpcFPnaDUtNc/UeEOdhikFNmExUtGgPXQHjmxaJlp/nUpfsXCkfkof3YQUCI+Slkif9ZEi9rk7fiIvud4lMiT8IAb2YkFXcN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(83380400001)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(107886003)(26005)(4326008)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BUaknuyX0oJ5ObIBbU/WYHBj77xOjgW+tvh/sxBAlt8C1KylaDpopOlF/FbA?=
 =?us-ascii?Q?DQ+7v13qDu3iudDdedNh1Jb4qipUkkIts7ja+JvIBZ8pf+KhpMdcLJOfKktS?=
 =?us-ascii?Q?ANz/7/cTwt3GO4m62YIwlzEE1hbyc33ByDZU3+7ItE6CyZlMNeV77m4BRjVy?=
 =?us-ascii?Q?Xg2cq/iDuqVaDGinw5S8eSj4dtLsAsasbsYjqFH+bGgxMdP+VLlEOS7+hBHB?=
 =?us-ascii?Q?RKz+/NWiy+bgr4gZVS1Oe6g8jyi6G96l04lAfdP3a1rHUiIfBL60e4Dky3LJ?=
 =?us-ascii?Q?Qs3W0J73fsAjGG0iH9NBhQRGS2F2wnIu0jqkWOX/2UunBRaJc27ervBqqQ6Y?=
 =?us-ascii?Q?GhrV+1lo1SeeAEnWvS6370Ssi37h8KbT6TlaQG2P9LgSZStqKeAlZTQ5YH3U?=
 =?us-ascii?Q?WGjb77QyTyuc4jDbXgH3a7gBQUDoKqLUJkrnjIPoox3lf5qVULMBXA2UFW45?=
 =?us-ascii?Q?9wiksNADbNylA9vHWrHCOZBoJiKs/Jei9eFTVuh3XEZd27EbherX5HLxUdiN?=
 =?us-ascii?Q?NZYXFC5QXuUcsn31pZYf5lioPYud2f0TdYaRRhQiPEr0GXymfZ92x00xT7WG?=
 =?us-ascii?Q?I6D6PnOytq6DTryfR5AYmossChc457kaYEWOh1DbwVcDRvnOd+M8Xy4BNBYK?=
 =?us-ascii?Q?/h38woPKLrmqKhX4wFPkmS3glm+VEqHgesBwi6D+oTH9C6fTTKg4UaIkZivF?=
 =?us-ascii?Q?5Y9mILo9HZgjsYDgVrUNmVq72iUJF2M41JR8DmLifxYgANtESoGNzaZv97ph?=
 =?us-ascii?Q?Uj1v4xlmCyVN+95lKy7rDzj/Lic0A1b79qqyJDcJi6tLLnWbtuhClTQKxynB?=
 =?us-ascii?Q?ZQRllca2UZIirq2+qJ+6nrW7GN92S0TCJmo3wwPPEjgkzjjrOuK3Po53M/EW?=
 =?us-ascii?Q?dZIPPS99PCJSyPharfXEYmtokk0JLe74FvV2nl9Yb/MAEnwA/n7HATGomjjo?=
 =?us-ascii?Q?AH17WbYWTyLQvJ1+tTEIrpd0Yh3n78j4Z/fE+/WWspIAnIgpG6QJdUJE6yNQ?=
 =?us-ascii?Q?zpBxjaTpH3/pRz01n0hxbbANpKJ6+2zV03bPX+2VpC9ZgxvDUH0JcNfpvqrn?=
 =?us-ascii?Q?khQAr4QjwZdW4fuC3iCXb5ap9ed9nGLpp4LwgSDNvK+CizJ2T5PK6OiieZEx?=
 =?us-ascii?Q?nCentd7cFiTqcWO6Nh0yMl8sQzt/1FSwfVVumcikW046PPVAyptS9iqli05W?=
 =?us-ascii?Q?ZK0ubZ2NQO28nBjXlqwy+d/ypzf738KPGq+9A4OBZFpGc6eUkkHuctOpu0Cw?=
 =?us-ascii?Q?ch5qTxMI1FJvWjv9c87yHaDrwNicx0qlQRFtX+WbBidQhNzevZLfEQpf/scT?=
 =?us-ascii?Q?HcK2DkpjfPnWaZsrby64g+ja?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8492f01-0170-4e86-c4fc-08d8fc502279
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:38.0673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zS3d5VInXCUwlJ+rExJn4f7s8Y+VrolRLU+bcCbsnY2GTT6BNfXM4cQRg85cZgu4k1FNpoQ9ncsxDG9YUH30dEB6vId/2SPicBl8lrDcl4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104100140
X-Proofpoint-GUID: DwDqilCFw4Y_rXjIyemquKqjofPRS065
X-Proofpoint-ORIG-GUID: DwDqilCFw4Y_rXjIyemquKqjofPRS065
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need to make sure that abort and reset completion work has completed
before ep_disconnect returns. After ep_disconnect we can't manipulate
cmds because libiscsi will call conn_stop and take onwership.

We are trying to make sure abort work and reset completion work has
completed before we do the cmd clean up in ep_disconnect. The problem is
that:

1. the work function sets the QEDI_CONN_FW_CLEANUP bit, so if the work
was still pending we would not see the bit set. We need to do this before
the work is queued.

2. If we had multiple works queued then we could break from the loop in
qedi_ep_disconnect early because when abort work 1 completes it could
clear QEDI_CONN_FW_CLEANUP. qedi_ep_disconnect could then see that before
work 2 has run.

3. A tmf reset completion work could run after ep_disconnect starts
cleaning up cmds via qedi_clearsq. ep_disconnect's call to qedi_clearsq
-> qedi_cleanup_all_io would might think it's done cleaning up cmds,
but the reset completion work could still be running. We then return
from ep_disconnect while still doing cleanup.

This replaces the bit with a counter and adds a bool to prevent new
works from starting from the completion path once a ep_disconnect starts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 46 +++++++++++++++++++++-------------
 drivers/scsi/qedi/qedi_iscsi.c | 23 +++++++++++------
 drivers/scsi/qedi/qedi_iscsi.h |  4 +--
 3 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 475cb7823cf1..13dd06915d74 100644
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
@@ -1361,7 +1372,6 @@ static void qedi_abort_work(struct work_struct *work)
 
 	mtask = qedi_cmd->task;
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
-	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 
 	spin_lock_bh(&conn->session->back_lock);
 	ctask = iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
@@ -1427,11 +1437,7 @@ static void qedi_abort_work(struct work_struct *work)
 
 	send_iscsi_tmf(qedi_conn, qedi_cmd->task, ctask);
 
-put_task:
-	iscsi_put_task(ctask);
-clear_cleanup:
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
-	return;
+	goto put_task;
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
@@ -1449,10 +1455,12 @@ static void qedi_abort_work(struct work_struct *work)
 		qedi_conn->active_cmd_count--;
 	}
 	spin_unlock(&qedi_conn->list_lock);
-
+put_task:
 	iscsi_put_task(ctask);
-
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+clear_cleanup:
+	spin_lock(&qedi_conn->tmf_work_lock);
+	qedi_conn->fw_cleanup_works--;
+	spin_unlock(&qedi_conn->tmf_work_lock);
 }
 
 static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask,
@@ -1547,6 +1555,10 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 
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
index 536d6653ef8e..8bbdd45ff2a1 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -592,7 +592,11 @@ static int qedi_conn_start(struct iscsi_cls_conn *cls_conn)
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
@@ -1009,7 +1013,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 	int ret = 0;
 	int wait_delay;
 	int abrt_conn = 0;
-	int count = 10;
 
 	wait_delay = 60 * HZ + DEF_MAX_RT_TIME;
 	qedi_ep = ep->dd_data;
@@ -1027,13 +1030,19 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 		iscsi_suspend_queue(conn);
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

