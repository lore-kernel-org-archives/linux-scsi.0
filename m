Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3CC7C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D66DF6117A
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbhDPCFo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46630 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238026AbhDPCFb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G24euW178941;
        Fri, 16 Apr 2021 02:05:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fRYGTHpZJ3XTRR9QPr8fTErL1ynm/Sj5S20NNA14Y6I=;
 b=rDT0s4sU9MOQPzcimmsHZin6muHhVqeaS03JhPN7k1gLwLBB/DD9qlzSlBVsusrQ8gMP
 A7AWccsPxDsl3jQYN0KKE1eyMIUbtSfGubz2VXU6NO1+LYoYMEF/w8pZqObFJN9DyARt
 FY0WB3oHD3bsP2781KkOA+iX0q0joNC6SbaR7FjHn9R0gPH8b1XGJQMYmq0oKuEayB7/
 j+K3zMwClDut2Ahum+HHVAZm+xD1jE6FB6GGRIUJFXbuGwmPIKpPOOfReUymeSbBOzAf
 sh0wt7D2iEvxPqp/KqflRIl6Wl1d8Ms7Gkh18Qj0fO7qqIWXMVSHNE9k+LHzH/gQTUH2 Hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37u3ymqn0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xoQv008624;
        Fri, 16 Apr 2021 02:05:00 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3020.oracle.com with ESMTP id 37unx3snyv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5Z0tJidwn8RIb4WbPMssd8PMa2bmGLwbvB4yjwxoEWqNF2sXl/6AJdlDv1IOy+QrRJCQSL3uUQkzLZyH+6D6KbamqiB/vshdf6vqpzvB2ofjtou8UGhp+/r3FONonuD/HKRQISS5xVk9CwqdW/wszUKFUonNp6wvOawHN7ldSlvPs0jdvR8rwRhcqIjdzRQ7Gp6+VAHAqai0pXOr0oAYriW7PY9UlU9N/R2ckRcapCdbx89fsgrGfWqZhNWNdFLWjCOEL6CBjb5RX1ytyNDJzBC5H2k1y6aYzWUhCwsa7AqYx+a9ddOUZP5EVn4ZUqnlNdnZq37hmva1cGLz3qx+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fRYGTHpZJ3XTRR9QPr8fTErL1ynm/Sj5S20NNA14Y6I=;
 b=dioYZEWkEu+KscP+s41VLqHC2W3hGP6idLKzPsNih5WH2j//4rsLeOOh4g2S2w5LH+WYJPWDkWwoCWMw/Up9/xPMey7tJoSpxNK2J07Cspc9przN5YEUKbrttGqNxQ65sbPwxJOBgkoxlzac8XkOF3ec+dR8LmSBEBgNjnjVBL0dx60RzJhkbemmiLRVL0D/G3K+iWCySLoUX/ulTRInuR4LYsOLDRtEflkP1Uffz9jjNP6AvH0yJysY0ivJqtHCK5BZ7OG0VoUZl7mGWwi6qAdUc1m/svW2D5NZJ5JXfhRhXknYAZ1mSBCbsAE44K4ot7tOQrDS+z7ApLDa8jF9Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fRYGTHpZJ3XTRR9QPr8fTErL1ynm/Sj5S20NNA14Y6I=;
 b=nF+GhxljwE2IMi0jL9v1xTlYRPdKNxXYcu7S1kXtJTOlg47+T/4nSW1pFOTNAS7PdKgFK8OT/TEGHkjwbN+cQdadKCV5DR1CNMo8SlBjwS5vbQe/tb0mpymmylQVFpALKHJ0gB4W7+XF9ejjF+LKxt7U6YqcKm7pFmi2SyH48JE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2421.namprd10.prod.outlook.com (2603:10b6:a02:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 16 Apr
 2021 02:04:59 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:04:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 09/17] scsi: qedi: fix race during abort timeouts
Date:   Thu, 15 Apr 2021 21:04:32 -0500
Message-Id: <20210416020440.259271-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416020440.259271-1-michael.christie@oracle.com>
References: <20210416020440.259271-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::41) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:04:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8e81fa7-1b8f-4942-86de-08d9007c09aa
X-MS-TrafficTypeDiagnostic: BYAPR10MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB24215685F62E987FA331C0DBF14C9@BYAPR10MB2421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XeP0VGZzY/BLnUD997BpLdwzsimjhVIj+g4Lr5/pIl/L7mfI7OCiCy5EPtxQR8zm3JFSQPdkYuNqwXPAxTvFSFNHbT9noCSpZ+acq9I37gxJ6/txVcRUGVzc9Ec7g3cqCubGwom4akao70hXyuiZBHsSAxbU1oNPhP2seUWvYcpqx3hcLZK0kP8SdCgcATXRlVyJDbf7vndz04D/gO0DWqKfAySe29MPnkqRiEY+T6x+rfErPmtCGvMiCFfV3DL+kVBSUfHEYuOoeJZqkeC5XowD4Qovv5ZQZDT3/bfxAliyaAPJvwCBBWyfEuSfb9pj2Uovefyx2+CjjXARqTWcw/a1TYF5ddVq8q3k79nWI4pRMolPudq9bJZOSuikLDq37ZQzHu5ZKMp1ypIUJ69EtkcgOE/13Ndm3Oji14pOj+fT2q54ypif/ZnW9wgLFLMdfC08FHD884upR5JVsMK5xeDPcfrJdIdUN9OAoe+OsKPeXvQZJX7hsa/bXioEygLDBwemsnDahNGc2IVqz86a1WIE8oJnq4+XLTyPN1AdM8cvCO9ZWnw8TL/qs8EyvcBoxn+EBIIdKj1KrVYVPLNHn3+qd+XVLxUehbrUX9JJnUPVOo91JD2LD0LcPAdAo09wfHn+7cRtIpFTCO20T33C+ve8nfQ5Cyi83+m4Oa8tNRS8oVBckvibnNHsImjg4cA9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(186003)(69590400012)(16526019)(5660300002)(1076003)(6666004)(36756003)(26005)(107886003)(83380400001)(4326008)(52116002)(2906002)(6486002)(2616005)(6512007)(956004)(8936002)(8676002)(316002)(478600001)(66556008)(38350700002)(66476007)(6506007)(38100700002)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Rz0tI9xI1MrJLCjeEDD0/C5Gh02c+RMIX03nUD/cZVInQZy5aq3CWWgmTI+U?=
 =?us-ascii?Q?sR8oqNmxC0JVutkIb1usz402IA2FJH1tnP8qpC4+2RORMJXcgj/8XqMNNH/m?=
 =?us-ascii?Q?kYGX5sY2eF4U8bqRdD58jX8v05JXUl2qe+vDwv4TfJDiHESZwdNXvPXeFRqN?=
 =?us-ascii?Q?5E7kiv/XdB0F94Kc3VRfk1415kBzyP2XnhkRIFuYqUnqcvBR+KiJimlZtq7Z?=
 =?us-ascii?Q?wHp2NqzWt+ra+3dgRM4qWZ6YrUEM1Oz938IL8sji32RVdP8BSCTCzqWd6b2d?=
 =?us-ascii?Q?/HxFbZZo0KKl2/sRwb/1W74iZxklbc+hwdpI4CGanAeyJGb/05GKWqZ4N7f2?=
 =?us-ascii?Q?1VfVAVgx+xhduHoV1Yn/jxpQl7lDvy4PnXSjFzvND5SHUg0IA4qDuE+25ruU?=
 =?us-ascii?Q?gieqiJ/WWBHozgSPnkCko1yALKP7rfvzpjCWLc6OcCSlqo4QkVXf12TZQMaa?=
 =?us-ascii?Q?EDwPcP2nuNC1TvjuBPWr41zcUeW/mfsxo5KE6QgS4WAkBG9xYM9hNAd6mFrY?=
 =?us-ascii?Q?RkCvqPBWFUzM4JigRPQRMiG2haixdhQPhDh/WFoncbQiMJxKdYc54K9Lc7+l?=
 =?us-ascii?Q?FlDY/C7J22hkUi897BQ/+H4xHdJoOOmpV+/oAXoOtS90rkr5mhVTBaZZFR0M?=
 =?us-ascii?Q?axaI4ZQH39o+IcwE/VwIgvC6EkDxuipXgl6JchbkxWrWVWbIVUgj/eq4l29N?=
 =?us-ascii?Q?DQzlDiR6wNumgVMlYwh5OdMlvIPjQw6CXsI2YDPLER4exA1nD0mKt4wk3YuU?=
 =?us-ascii?Q?3kRL1oY7uYaKwEtc3eMrm13Oe6+d+M8klHfH6vFjha12b6UXdN2V4xXgbLrn?=
 =?us-ascii?Q?F3X/GzCIREyKpY4qMTlGbw07BrjAdHtIYOJ4NtVqembx/11Ecp0kbrkFDLR7?=
 =?us-ascii?Q?oQFA/NUOXpn1WmxUH1HMiKXkz362jgZqX5AyTb8iVHCUR+/3Y7F7bs9Yn09L?=
 =?us-ascii?Q?crrHE3pwXcEAnE2MCtT5pYwyKWeD4r9U6uBr9ELf+8Z1yxMUDS94ESJ+fZlG?=
 =?us-ascii?Q?H8Dvg5MkNY/eD+OOS5Bxj8Wcl9CPSEo5eiwGQuzL2ldOkcAG51MVyRwrH971?=
 =?us-ascii?Q?CUa6d4vN3KYB/Yp8RkefP8cNQ5JQVU3AAgCjIOhwPxVrwQOot01HEl5AXMmr?=
 =?us-ascii?Q?/Zh3jpoVZA5PNHkonfY+kpLM1/JPSMEHJH9Uj94w7FZ+Lz5s4ks6B240Db6J?=
 =?us-ascii?Q?8D2Lq69lKiBurNnurpfebDLAmW+fPkGdcswCaagjbpMZb5ffsiaZdIY10Dco?=
 =?us-ascii?Q?fTHlPq0mm612JXyEd39s4+ishHiCPokqyjbrC0ZypVZza0MTfOTnLliBw2a8?=
 =?us-ascii?Q?Moa08hGJSzi+bNArRZXODu4c?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e81fa7-1b8f-4942-86de-08d9007c09aa
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:04:58.9999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xJ+2OEL7znQIJ/aI4WCbJW8/oGig50qizhj9VsYjU6ttLdh7i5BSQJwqmC4NP3XJaiokdJM1pE6nUSPkG7giA8vSue/xs/gaQKLXIFebVSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-GUID: uMfKw61JrbU98X1FuyUz2cDV85c102qn
X-Proofpoint-ORIG-GUID: uMfKw61JrbU98X1FuyUz2cDV85c102qn
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160015
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

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
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
index 30dc345b011c..416202bc4241 100644
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
+	cmd->task_id = U16_MAX;
+
 	if (test_bit(QEDI_IN_SHUTDOWN, &qedi_conn->qedi->flags))
 		return -ENODEV;
 
@@ -1380,13 +1383,24 @@ static umode_t qedi_attr_is_visible(int param_type, int param)
 
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

