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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD99DC4707F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C7FA6140E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhEYSUi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44258 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbhEYSUe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:34 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIF657124670;
        Tue, 25 May 2021 18:18:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=j/4EsnZfW0heAm92Pw5JPuZaTL/JoOg54DIcYalCQ4s=;
 b=bgCU8Vh53VMgd5FpxLOv5h6fefvsGUZ7Qbg5c9Vwo19dCRtJaJu74E6y1BZPURmO5+vU
 BZIgZo3GaQ7cKaCOW5UEQKJeUMD7SmczFBzFRSRuJ07Mqv2m2FcKXKOcn2JxdkGnhSyk
 nwrNKeLTRH0ZtCpe7pHeHE8KwApUgNGi9hMFUbna6GBm0mWRIjP2dnIjVVd+LGHOJZBc
 5sQHfU3QdJmfhRapnK/SKOlFoPtHmV7WrZvqKymZTMipzn4utTSaQjaTm0ZvUt7VFooq
 Gi8oOFC+Gj91zQli3mQlpZqwrxRhz8lO0n6fWU9usw5aHdmTpluPWInWKobHsfQLHNZ3 SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38pqfceys6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEulh166263;
        Tue, 25 May 2021 18:18:56 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3020.oracle.com with ESMTP id 38rehaq64q-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wa6Zf0n9csw/GZ9KW0ZRYSdmZ6XmqjNF59gZ6G5wm8AJzjXwMGVCGVjpz2AUHfPnI8Mq0b9OvZJbGWL3sAqHiyfCqhsCQMazegzDYP+rW6ivvjC2Zoq//jnEKXllmheWGmEEkpvXlWam7+PVfTH7BCJA3kvH7g3SZiO22uioJYbn0rwJ+e4qgR/F5n+EYDvEn7HaktbFKO2BXD5R2njfk2JjzkSeaHeGXDbbP9MJzshGx7+rYZMR1FXLLlk3xzy7ugQ/XmlxYNebRYtFCm/ThZyKOHci/UJhU+tBZLnWO82OL8Ku+ExCnTBS0QOyK02dlqsm/dCsbrw6ZYD+TvWIZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/4EsnZfW0heAm92Pw5JPuZaTL/JoOg54DIcYalCQ4s=;
 b=BoNIU1KNaPLWwN+4wDMXTao93Ery/oDPolPd6vroG7l3f5b5YPK4nzLs3Xpt9Dh6yNDgxMaByzHVQlOQPz4quHPXdGvRyp+ETm3ErV0QJ5MF8WENlUs/X032DgXAzijUJn6shFgDdfl26P8KoZMvzXm45TH85GjymLq7IJ4KBnDCJ4ffBuUlUGEM7HA+OfPSJIcUyKud0jqqHDxFTf7WCqYrR9Lz3X0mq7TBbvcBNS8w7EPdp5iGEq5Craki39H/L/AB+tqUyeUIIkNuBjHQaEni/eDegdniIoTIryIR07RMFcvCWs6zwQDFX4NQqGJc8SsqsYT2FEu1zYiAJQu/hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/4EsnZfW0heAm92Pw5JPuZaTL/JoOg54DIcYalCQ4s=;
 b=q3D8WxRg4DLDjjZmSPBfAoGjChkUDWnyBFdHf0+NXiGyITQ5sumMImoMeyv227m70TSPwyDjkQt/EhxdCE4fQ1dNr5bC2prSbGIThhupm9UkrzCIuwGLi2ub6Xz4i0/BakCCuXYk8+0GBwZX6oM/lhHlryJuJCyp+OdmleR06zU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:50 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 20/28] scsi: qedi: Fix race during abort timeouts
Date:   Tue, 25 May 2021 13:18:13 -0500
Message-Id: <20210525181821.7617-21-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0be358c-6e37-44f8-d8aa-08d91fa98bd0
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB38916D0473233602E5512933F1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SvgBEsO8RYyhX4Z4uN0cumgU0P5ts/qMr1j0Eu7tnz5yhpHsRWmBlIikIHrK3bUGdownvsxEiljTMF8eVc9mCada/YAqRuEXK7EOSzU5QVHYywPYtgzCAMIBlEbPtd1vvxkW9eCLDV2YS7GKq1/W4jekrtTYXah/bv5zzpoS0vByCVZJTLSqr+Ly9zA09muBc68m4Qjhio5aHrv0xv6+8izF/KWMe9XWfp4z5c96KnVIg2iC4F89ENpHw+ouYNiXm/Ratvjs0a/5R0ornZsKuOJSKfqUo+In8OrNxA3pU7bOtVl28kUhDPBTJUONM2TW7b9O2ogh1hMODSsTOt2d+nSaw8SNPfv35yfxmGhF3LRsbQvVYZ0/EMV5voGTfxf9qnHTa+YkeP6jHS6Sdb8B+oiJEV62cBLifY2oEbft5/Vu/B5aoR3xDzv6a1nI/OZf/a9zp8yqrNaaVkyL/EoXdsXdrqyVEZjKdT3znYgXHgG0Dgq7ppB1cKVykkzHXrymkrSnkV97kajaEvJWzommWwPoPvmvf6vMReO1VR+hjbbKUrLyEZQlb5T8AfRKJBRDvRkR43hT1atrjw+N5gMzU1yazgfVOjLEI8xiLoB1zJz468b4glxdXT7siEZsHHiTpZjEt0+h6xuxYPiuL6qT7ZiZ3yJaIaje+SgC6Fs2HWAurmJax7llG8UWMFS42jV/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?U6qrMII3HvNxrlHVEyrwdahRtczphxR1+t8nSGT9frne+Yh8YlwTEXscCpuN?=
 =?us-ascii?Q?H/9Ea/DEL3X4wnJB8TrT5CSOwLiHZ/9wCObQfjSUv7mKbff9ahDSr/W0pnt/?=
 =?us-ascii?Q?aXEbfhso4Xuq8z1RGnkbTms1qWkq9pllewHX4bp04mS8judUl6mkQka5Wih4?=
 =?us-ascii?Q?z8mL5qv4dPjagic8ojTa/U3zYLGnDRv2nTzBMYxt7JM2eXLMkph1CYqu72Ho?=
 =?us-ascii?Q?oVzPH7XonTjwp4xnhKcQMOGARXWzh+zb/TnwC3lc9aS1/qYSyr/T4kfPMB1P?=
 =?us-ascii?Q?0N8r0wfmX+RDoX6AqmmpZZxbHZERpGsnO4hLJR14lNNB31P8+ffcwFtAJ1tI?=
 =?us-ascii?Q?uZpJL6qLxT5BlRTEg7COd+C4JFYStA5DgacCWG0zcbXvTPPuqKBiM26ngllo?=
 =?us-ascii?Q?RQnA4dKMNsxusFxcw0VdC/e2AH7tNk1DQHH6Occ0NGojWlMttbeZmzYo0GkI?=
 =?us-ascii?Q?F3f4nTV+1QsHNvRgi0XOEMc2+fu9ObMrYkLITT73bGrSgz5P24zXNJr/dzwV?=
 =?us-ascii?Q?za/YlA5xjINEMFeXvsqDb+YK9JNGmBldiM3yZ9iSb4VlZ8bSoLv6yKMAoDgK?=
 =?us-ascii?Q?upFIofXZPWWLs5nJMfH970im9L1d+cgNvPd2Eb31qfR/bdIL26/l+3WdzFYp?=
 =?us-ascii?Q?S2RNaaVU1LAMPvE3U4Bth/bBWmQRrECMKfIlpiatUKhsuiNKsv34IOpb/bWb?=
 =?us-ascii?Q?hD8o5/ePrFF9iAYZmHr2QIajGtTFi7idHOW2VXTXCqVyoarBSBEXC1AG7DJd?=
 =?us-ascii?Q?m9t2yFA9nDh/d0J4pUuKtD8cbUhGvWe4khk7/M27dEb3XxaIoCQwZA46+DQC?=
 =?us-ascii?Q?GFPiCnJry9QcQkJV73C0h25owe3mX7WoNZ0xtd2N/NN1nXNGp0pHEFJWsSdf?=
 =?us-ascii?Q?IBEOLoGiUi0opzC90sFm+7pvQnI5wuGCkjN6lXBvdIbd95rIq28lMNWo2spp?=
 =?us-ascii?Q?Sd0IJZdS/1pY0qsisrGUWKLa66RkBHDmjtDSVOVFaYiNpTIGfRgOVi8NL8PI?=
 =?us-ascii?Q?tcCJt49JEgZysI6E15HQshT5xV4f1nVRBS+H07/dKcCOc9/h/Nl5yC3tw/yk?=
 =?us-ascii?Q?e4ZxIy3o+UE2RudpNRgyRJ5sAvfHQnoJ6cOB8CH0vRk95HIoZRdbxKzyaZqS?=
 =?us-ascii?Q?Fgx7x2fNyb8md528/tsRwRDO+bty56bd5yvvkl5HzTtA59ZUniVWYYmXcts+?=
 =?us-ascii?Q?5yF8WKTPN0um9YhoTFxeCLegejazbX+i8kdeYmNIw+pXp/FMDfETxc5TqTuH?=
 =?us-ascii?Q?hJE20Q10Z4p1s6TsxrgujmWVgT79g1KKr8lhy74JadbKC6rveuSfVTX8jzjs?=
 =?us-ascii?Q?+eaiWi3ScoNROBfscv4J5ogf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0be358c-6e37-44f8-d8aa-08d91fa98bd0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:50.6699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tK6gkXbMD+WBn6lDsRy7B0sFF5Cc8Vvhv2bonxO+lng5unQ2O2wxqy7Ay1oFWVDUB9y8z8GCUMi+BbRotY6aIGc7u+N8aDgjy39wcRcbCv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: pWZzclpLr0XQGDxZjXTk0LtyFbip1yqK
X-Proofpoint-GUID: pWZzclpLr0XQGDxZjXTk0LtyFbip1yqK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
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

