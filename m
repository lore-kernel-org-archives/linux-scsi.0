Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED1FC433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF88961360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbhDCXYe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236973AbhDCXYW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NOAgg162573;
        Sat, 3 Apr 2021 23:24:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=hja/OPjlstld1+Z7mdAJEvEkAo3po83aTuaS2zOEyQ0=;
 b=Kfp2ku3r0Z3bhHR3MfDFDXXHwsPtVQLWr3SXX9refo6ogn1MkYiFaTjktJMpXUppWDUJ
 W+MirY42UoPHybyuRS6YXMsFWrJg6+PemSU2EZ1/rUHx1Rc9BhPT+eHZGvZMWKzdMOKD
 gtRo4oKe5u3+l29AHj5aw4FxCgMHIk6K1ca9zL2Q0C8uyDoRUhAVlxQ3I+mpsOD1XS/a
 AV6hamkEoB8pWrWMpQ33QiHuGTQx1b6cCxKHVhYAcJWjcb82UGRe0Ls29iNSU4gNbcD8
 0jPBHylSeEnUUAcKNTNOPcjDWjYeF7ORKx3GqHbqYnnL2VO8ETHX0tJ9d7xWthNhmlID fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37pgam8rpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKte4116979;
        Sat, 3 Apr 2021 23:24:09 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2050.outbound.protection.outlook.com [104.47.45.50])
        by userp3020.oracle.com with ESMTP id 37pfpkbspr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0QqeY/lZ+WkkSz2ZxrEr+FqlGJj6+Abi9p4YRYgpLgtfSZL3Rv7hZXhrFz7+rC3oEvf6tFKFIRK4WjrDyq+zM+7wr4m86GsGsk3PiB+TOmSPVnEf3jaAJ36RaVR0lPbxJabczvhSp7yQvtWk4wzIsCVIRkstGaBidvjWhsU/297SjHA3x2pN+kCoFOaDMNI4xleFdlmykvAH2NNNQoa4f2CAM60BCW7ZD3IGKEoG71BndpzfxZSDEFvTbO1pLxvTKTiGkTfXf7SxdKPE5N/iMXBdwzIBfibj3gnJLWv6kOY72eWbtdDf9vh1j/kG4f5Vg9fCGQfIhZ+t5F9VIiZDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hja/OPjlstld1+Z7mdAJEvEkAo3po83aTuaS2zOEyQ0=;
 b=VaQHMX6FuBUtzb571r2H1XdZUL9C/WCfLw/7RUP1GNUjoT5POQa9tZ2WrE9F3NuO28PWpu5ne3NoPUywiiUb112l0MR1LfTVPQtD5zqlZ2lxhFaafgtPb2fVkT8y07IVMazmQah6/JEjfSVnibm6l8S5rdI68v1ToErpvkfHKzCW3U2nIlRc2Q6vPwZKwxcmN8+Wct35AXOFFyo4LgBdOGUZgZUbbYVit9UAwZI4yzsllCr6tu+FmozBk47JQeoLeOBfeycXdAn32nf4BqzRT76CXnHVafTv6i4bPxeXnYqEStq5Zh+KFPA2LKWLAopTcy6Vo2Vljw437jc43SUanQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hja/OPjlstld1+Z7mdAJEvEkAo3po83aTuaS2zOEyQ0=;
 b=k1gSNRYsBcS5iFK/ksidDgFgwLkZXXfjGd9mHkVsOrZVXa6SrYlapC9cMA4EU6gF8pkyVBP3uMuNieqY8GXXUFGSx7b5DYK6N0/fuWeUkxjr9ACQcRN65wewbAd6gKe79FD1Ans6WmsVOYxbt7cy/niwSiPk1e1E8azeW2QK3rw=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:24:08 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 18/40] scsi: qedi: misc cleanup
Date:   Sat,  3 Apr 2021 18:23:11 -0500
Message-Id: <20210403232333.212927-19-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63b6e604-1f82-4f5f-aeb7-08d8f6f79437
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3526F7E8BFD6EAF468607D8DF1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w2aoVMDrdrmldwDh90yDE2KOfZCyn56Tz0vwXap/2lYsomio7+WFh/2QRN9PRjPKJ+ESLjtbIXKCmfsfL2VlwY8rS+bHeKF0Wgyz+74dBEVzuN85YFyeKpFeF0BnV87KGi2OaMrlh5IeiiMrC2Gi4klJVqZbCfj03IuM0PjUsNteWECVEy5i0i+6Ee9C+br8POsNfXVUUpG8AtPXd0sANJAauUEx4j4R+0uG0THvd3Jwc7FPjtrqE7H4NPHHS9R+CLfVaKfqASEl9NSUCjVtesW3T+cR0ORrFgknZqDp4bzoyaQcbNWi3b6lnzFd3UAhpk2hI1rwZrUMrLriw/Yv69p9a0kSD/fyaRBi4E1Xdoff6nEfiJVHG5bkcxvFBdjg9nffz035BBs5odETkmqpnDwoqT9UaoeQS+QrYSPbkqiSPZLGmC/vJi+gmq7aTVXgT90BUsYRKnPep7vE/FbQXNyKX8QYeOxc0A/hP5Qlx56XjZC8//jYdoFSzJYnAD3q5ZXh5uSaSYykGWTiw4Q9V3eZFPRaOauzxP6EWhw8B8sM6JaE0fC3Rv0kyQ8u8m1yXMcDmyIX9CQUTMRjWtm+DoSUVMqoI8T9zyyey+8YiRB7+2zv0zaUeu8JYZ/0g8VYysHVMrVhtGbBd2ycOYWarXcMfST9xHogkxcENScon2u+RbI+qptgCvyNQbOBhS3AqqFMio+9Gu2arup/lmdM8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(6666004)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ry5ov4Pkh/XjZGGJo/ZSTSYIxrDGCfZ1duAnKz+gxhgY4rnRaQU22hJMQ6qM?=
 =?us-ascii?Q?C2Z/2+bGpIok1WwdsyL9C6boop8iYTND7W0opqIu6gPxYmW3oddQEtCMP9Gk?=
 =?us-ascii?Q?ALJGwSHdPbZVSHeoQHVXQFxu5yGwipAVu/h8qKKxXoJfb7yq1/S3na8aYp3I?=
 =?us-ascii?Q?qMO6+hGBUwXprpt/A/sGaBymWhmY18lYtiPmZZqVfZNfw6mubfEukbO9Ym8c?=
 =?us-ascii?Q?tp+1OeZgwSG+AZ4VP4RN/cnbW1Y0O2PS+EEbZOoLldvq8tZyRtHnMA6HXSHP?=
 =?us-ascii?Q?O9AedNO4yodxOWs8BiYADx0MJGyJER3TTNsb4rxkayduPVh/XcTx0fR5Ce1d?=
 =?us-ascii?Q?U4Z+kQzSoXrykGl4rK4jMOfnALvjCikPd0/8hNsjTYAyHQKtqEnt5cSrTlT8?=
 =?us-ascii?Q?oLIFnO/T+TfY02G4E0LhFwREruvrnT0vcEqVGtDUnJRk5VcgKW13Yb/XyXrc?=
 =?us-ascii?Q?9ioSo0xaGyKERBhzfxz5aoPxrL09TWYBG3Un/1BiwxAM8xcHXAUiXncuw2Tm?=
 =?us-ascii?Q?0U3X74Lif8tmMq/gnrAYFoo0b14T1wDws1Q7K4dO+7fe21jmVXh9xng5Kf5M?=
 =?us-ascii?Q?wQuhLcmqtELaK7mIgoGd49ottIzjkDOYGR4UBmgGQWjjDo1Zd8wMAcO2sFRD?=
 =?us-ascii?Q?7MHqsKsq+EtSML0dJvFdelupGNCwYWEjY4+2EGb1XlCXVHw6byh0qqEYYCV8?=
 =?us-ascii?Q?WsPEJdYyBgXnNnO+BUl9MDvHO42xVK88e8TNUx8i8i6kPEiGE3mziS181xQE?=
 =?us-ascii?Q?i45o/sa33CYjj9FiEELDzILsqFR+I7EaBdNRdjZ+Fn9Tdzv3gECMhFu8XfSj?=
 =?us-ascii?Q?XfkEMUeKcLI4zIiufiJjKPE84Gs3U84hBdgMBpixu0hOphkCC299xj9Mxafv?=
 =?us-ascii?Q?RnR2GkbO92tXADHj0hqI5upwNZpN+yMiAHeJ/MSK6phKn8Mcs/qWWonFNO+3?=
 =?us-ascii?Q?LwfLHnklZKYHN0a5+gOvJZEuNckoVSKuPByC3yoTybkpoE9ANGV029W9x3jj?=
 =?us-ascii?Q?HQl7oc++oIC2SIWWg1Nvrt/Q1gTksdylyhGTufT1WfggcWSCcPtL7qJNqUVr?=
 =?us-ascii?Q?t2+mPUnvfO3hOUBTKbcnSctXWpIy9W+lA6++lUBsi+OJtq/iM6lR67Kv6SC5?=
 =?us-ascii?Q?/UCiehOp30Woce74oupHUOYMcVtKen6YvHmGGAUBuFY4ru9V9/cr8uydo9ll?=
 =?us-ascii?Q?wsROZ6va0Ki7GNhsbngylhpaU55GWP+byHaefTCznK1bRHt434ZpzHVEPPgX?=
 =?us-ascii?Q?2YcMMdt2h7R/9h39MbNjIrDfkHC/jG9uwwFnuCGEIeJ8WHb9F36zmXldnyg2?=
 =?us-ascii?Q?AU3tpTi1Aesxev8+pv9Tv9Fc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b6e604-1f82-4f5f-aeb7-08d8f6f79437
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:07.8606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: txVJJEiD7nUSM5MzqL+TITNdFmJSW/FqM+jm1qI1uoZfYQ+5tsYclH1g9W8gGz46dCyWT4NYeL6LFXtC+YmzyC8mG5GuL71xsdmST0NoRFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: _vEWRJ3Rc4VU6jdM5Ivr6BAGcJ1Rw7oW
X-Proofpoint-GUID: _vEWRJ3Rc4VU6jdM5Ivr6BAGcJ1Rw7oW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove some fields/args that are not used.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 11 +++++------
 drivers/scsi/qedi/qedi_gbl.h   |  3 +--
 drivers/scsi/qedi/qedi_iscsi.h |  2 --
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index d8e10e8d3d08..3357b0ff7dba 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1218,7 +1218,7 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
 			}
 		}
 		qedi_conn->cmd_cleanup_req++;
-		qedi_iscsi_cleanup_task(ctask, true);
+		qedi_iscsi_cleanup_task(ctask);
 
 		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
@@ -1374,15 +1374,14 @@ int qedi_fw_cleanup_cmd(struct iscsi_task *ctask)
 	list_work->rtid = cmd->task_id;
 	list_work->state = QEDI_WORK_SCHEDULED;
 
-	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
-		  "queue tmf work=%p, list node=%p, cid=0x%x\n",
-		  list_work->ptr_tmf_work, list_work, qedi_conn->iscsi_conn_id);
+	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM, "list node=%p, cid=0x%x\n",
+		  list_work, qedi_conn->iscsi_conn_id);
 
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
 	list_add_tail(&list_work->list, &qedi_conn->tmf_work_list);
 	spin_unlock_bh(&qedi_conn->tmf_work_lock);
 
-	qedi_iscsi_cleanup_task(ctask, false);
+	qedi_iscsi_cleanup_task(ctask);
 
 	rval = qedi_wait_for_cleanup_request(qedi, qedi_conn, ctask, &qedi_cmd,
 					     list_work);
@@ -2114,7 +2113,7 @@ int qedi_iscsi_send_ioreq(struct iscsi_task *task)
 	return 0;
 }
 
-int qedi_iscsi_cleanup_task(struct iscsi_task *task, bool mark_cmd_node_deleted)
+int qedi_iscsi_cleanup_task(struct iscsi_task *task)
 {
 	struct iscsi_task_params task_params;
 	struct qedi_endpoint *ep;
diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index a3b72e7ff9d9..098982e6f8a2 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -40,8 +40,7 @@ int qedi_send_iscsi_nopout(struct qedi_conn *qedi_conn,
 int qedi_iscsi_send_ioreq(struct iscsi_task *task);
 int qedi_get_task_idx(struct qedi_ctx *qedi);
 void qedi_clear_task_idx(struct qedi_ctx *qedi, int idx);
-int qedi_iscsi_cleanup_task(struct iscsi_task *task,
-			    bool mark_cmd_node_deleted);
+int qedi_iscsi_cleanup_task(struct iscsi_task *task);
 void qedi_iscsi_unmap_sg_list(struct qedi_cmd *cmd);
 void qedi_update_itt_map(struct qedi_ctx *qedi, u32 tid, u32 proto_itt,
 			 struct qedi_cmd *qedi_cmd);
diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
index 8a96c1fde630..5522df952c30 100644
--- a/drivers/scsi/qedi/qedi_iscsi.h
+++ b/drivers/scsi/qedi/qedi_iscsi.h
@@ -219,8 +219,6 @@ struct qedi_work_map {
 #define QEDI_WORK_QUEUED	1
 #define QEDI_WORK_SCHEDULED	2
 #define QEDI_WORK_EXIT		3
-
-	struct work_struct *ptr_tmf_work;
 };
 
 struct qedi_boot_target {
-- 
2.25.1

