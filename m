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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A0DC47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9D88611ED
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhEWSAL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 14:00:11 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46726 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbhEWR7z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHssP0154036;
        Sun, 23 May 2021 17:58:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=4bJhRCqGwJYNcTubNpggQo21ACbthDTKA+4v+JvH81o=;
 b=g5i1amV8QkBpV85GmCzlP7Efvp4tXf/SYECkzD5Vxfma5llEMzom40IAXbLbu5vQkpsx
 CBa0HlZVVO2OF5XNHGFS1R+fxpjAB8kOaBRcnjNAJKrTE78GFw3ZcgYK30TZsrsT0H4Y
 mF2Y8b97jx2xp7ZvgbteCBLI+5Om3AbcDwWPH7hj7vFMxDc5dwe0WOl6sRBl9+W/qmg3
 8yH/lT8mzzKlwT9usK77nZwnvSBURq4yfRrBUFVcbqxcu4/6wy1CIUpCX8mWG/3hSiAr
 mr4yEjgadEuDRDtlN9s1xf6Swzah4tFFnrr0KWRnqxr7HsIT2tnnsqqGeGLVpcM5h34U UQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38pqfc9jaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHsrMh188648;
        Sun, 23 May 2021 17:58:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3030.oracle.com with ESMTP id 38pq2snq5p-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2DPaxcc3acnRjE2PlJnl3Een/1HmVuxe/RA5vI3/M5t9b9LBGOouCcoBoGvzvqtFHp+BbR8Td8PEvgPMINDqS8H57oVQLCB4q5ItMtMIb8OBQhCGW3AtY1ydtfZrUAU7RYzLX1eqtiwMMfgDOBzQVQvQU5/m6AJAa+zuKEZqBZeYLJDSN5xseUrJNg9Ln9sea8+6NR+OxV1Y+TVR6ZiYm3BpS9evbTcl2Tw13BE6WmDO4+nDuLj6MxGVb12IWmkWXScvn2VEsRzM//YQvjwA8dqvwFT2Q4V73xExiC1sT/JXTEH9lbOTAsVd4Ttth3113QBBNL1gbrHVL/3kVm1mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bJhRCqGwJYNcTubNpggQo21ACbthDTKA+4v+JvH81o=;
 b=EF/vdZCXfxPnc/uSj/zqVLeSsSTZMSzF/QqVL8izkatUUOxerdBhTEPwIw7nwNbVlBp6+zAH7ZuKulzfqbJnNQ02nMQZ87QnNPpuTloaclv7w/mTjHJiM81+uGytVLzbd043d4vInjZLulGSg+Uag18SdTL5m7G766mgzJmk3zqXryLT+m5vWf44VQDNA/7Sjlgrjc2lyyTWHkjSkr/8/g8+fMjmkLFtU7EIX2hkoW4ZhDqy42aaqrnpJG7PkGRRPwu5Sq3VgABahONKJXPdkw2dA+l8+0anNaKKPKoFJ56qVyhPlErt3AuGobS99pIrZ5+wkOB7G+Ja95pFLM2cFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bJhRCqGwJYNcTubNpggQo21ACbthDTKA+4v+JvH81o=;
 b=ny5+ANTF8xN2f5rSXMUn6OGgUNITcsJ8+b5slM1ImGcOYYFlT85DQOiNNyEmtpRDQ9zrJKqLup8tUuKc2G34NtfpBF1EgTJSqi7J26DHYqoGNEWYCp7dLfn/eUNaUDuRNDotMiM4EZsf05cE4hZt3OedOWLzaZWVbQ9/tTT3Gbc=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3239.namprd10.prod.outlook.com (2603:10b6:a03:156::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 17:58:19 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 28/28] scsi: qedi: Wake up if cmd_cleanup_req is set
Date:   Sun, 23 May 2021 12:57:39 -0500
Message-Id: <20210523175739.360324-29-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: daab8c3c-dfe8-4023-1645-08d91e145929
X-MS-TrafficTypeDiagnostic: BYAPR10MB3239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB32396419221ECED6CAA45783F1279@BYAPR10MB3239.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NAdN/iK4p8+Yq1W1pmv81hYS1VgOsueUvT/Ex5yk5WtXEvcoR3AK5IT1zbPxcF98E4YRWLHm1QhwwWw1/33wfhVhx9XnjrT2YPuRWDvGkxhBnQ3b2naEUnWv2f2xXENm+WHQekN6i12jJNGaTkzLBdRB0dkDv8WiQNeaD0HUolItQtXUp7Q8iZF49jgpCkvLn1CeT0C9sSRyM/b/E/u5XSPP/71plEzr3oiBSYKnGtj4CeXyUqITCbc9QD1oMwWmSaibX5FPhTcvZqVwuhCMNVPOc8UB+sCEUFxcqqvD1ZjVy4J5tT1265/leqg6YppJMIh3Y2qziIJaJm/a5prybo/3S8QunN9rvTPNdJtsORtMD4qt3E55A2Xjeg9STjSRm7wBnVk7CyVL2dqtwAI4h1pDdBg4PTq4aXWPFIEoIpTX3a/oBnPya+/1q4aM/7HK97NzEy7RCQa63u02vUHRnyS+jcOecNPyi+TW+Uf12Kpfukf3s03fpfDXsT6kwFGddcwo2IjYIdExBWmK0rkK97KWTLoS/nHXqY6eQ7r3QWqUL/9DtxNXLc2H00U9eciea2bkk8QD5Ly+M+nG3hGgM+0qE9lwwzsKW1IHerpl/6X/L8q8G4qg3tKJZ8KgDyniVAwuI4e95yc+MSwtzgWDTP1kwQFXbAg6LM82flPiMDWkb+MG78wi0xdAkCwpB9Sy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(52116002)(26005)(86362001)(16526019)(6506007)(2906002)(66946007)(66476007)(186003)(478600001)(2616005)(66556008)(8676002)(6666004)(1076003)(38350700002)(38100700002)(83380400001)(36756003)(316002)(8936002)(6512007)(4326008)(956004)(5660300002)(107886003)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VUMmFMC6aRjDq1inARC5lSGJBZ/jteWMK9CRbFoH+mf88W7VyaihRmE0P3Ga?=
 =?us-ascii?Q?erTPt6M46P24sW9vUKwo8vxBhaA6QXXgk+UlSToiifaE/GVPKa8RYPce/LPR?=
 =?us-ascii?Q?JlSn8EZ/BbkdDxMI3lbW9Wzbf5ltiJ8hsb4W6VRoFmmkSTe544Zr7vwJZwd8?=
 =?us-ascii?Q?+ANXje91bg8ThcRVAXDWen+B5lc5qsYlmHnSB1ffVcIk7rASHtMBeaps5VPu?=
 =?us-ascii?Q?Urq1QWduKYvIESccxlIlVqf3l7KoI6J/6NAgo8Bys5oQdyn01YVWPNZ4BCMF?=
 =?us-ascii?Q?kl8eFS9htOvD12lQ02ANfLt02V0/5vggFKGgYF5chV0lRpfYVWR0cbzgpm4I?=
 =?us-ascii?Q?+sU6RKhuIcsbGGU4tenvTzkjDlU8ADmV/maSxekNdhTJZegjD1rMsDkJICD5?=
 =?us-ascii?Q?Im4RtiSGnKkTVosiibZI7UTfldWaeIlzQNkCZ9HbpLDDVFzrNjL7YE0rYe0W?=
 =?us-ascii?Q?NfV4l6VzOqdCEGbZSpaMVJmDR0+creXKA+Abs5mucdfpaDq9g/DfSLjxfrLJ?=
 =?us-ascii?Q?DmgTkV/6EqQ0js+N25KukSnLS9k3XqjZXtlAO3UWT/SC2Tu/EAViFQwPwsls?=
 =?us-ascii?Q?rxqy7ZtpL8Wfjbfzhk6gYTPf5n2aQ0Drs98gBXHLYWRkZXrZxts5hK92oqKE?=
 =?us-ascii?Q?inxINWXHWE1DpECxQcCGTgcmb+4+CsO4UDheI/gRtv19FfGk6elGOOjtdLox?=
 =?us-ascii?Q?QStOPMzI40fLyn/5YzJh7jURncK+rHA9nt59csyf4R0yeOn7JOTzLPyzFDqS?=
 =?us-ascii?Q?aLchTO9QkfAO1/N79vdHEaTgK+XWn0HmuICYAGQpqkMgAxvZrlthwKPWKJK0?=
 =?us-ascii?Q?ysZK2XAKPS7Ld988nOqR9jrTtJ7adOw6OySJmueEj4gkM2wbTW+y0s3Nl1j8?=
 =?us-ascii?Q?YqhQ3aJXD8sVEZiic9k8NqVwEXha8ahilST4mudTdI2CmEwWzpms4ghohUCt?=
 =?us-ascii?Q?tRSx31yegdm+EKEabgWDFvYVbVVwt99Ggky8L8TxNSmW3uhd2ujo0IQWopKK?=
 =?us-ascii?Q?X6ePtHLTeIYaKD/tSFatddy1MmrpJXxHiN5X8kMvF1aUgfn32vFz9yXWTQL3?=
 =?us-ascii?Q?rDiJbUU8MgYF28vIqH/djO4f79keTEdB7CsGDYo/BiRmimMjZX5Qci15prx+?=
 =?us-ascii?Q?J0DMeno8taZUuxKK2Ktl6gfkwY+fT3VhnzgywFm2MTYqrYSmPyBFecR6LUSl?=
 =?us-ascii?Q?jNJZTYxRc+6w329eY4oZ7FCoCJK5GV6APgb1pSc9vJcSsj+j59TePY3a7w0Y?=
 =?us-ascii?Q?Lf3Gzg2kSQP36L1eUv9k8toGNnqsGeUbRfjqd7mxBzu5a0iyusNZBKdO9heB?=
 =?us-ascii?Q?I5Q2vHWDrK1L4m7HiNv3s0Fs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daab8c3c-dfe8-4023-1645-08d91e145929
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:19.5249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nm3gNNewqNCgy/J9uqQStQZm9ZgH8y00UniaCrSisbDL/+fc6vao55zlXJAZkK9DGkoirG4mHhaVE7ck+U7p2R4LOKu/AAxCQDoU45gcSz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3239
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
X-Proofpoint-ORIG-GUID: FqaMaZIHBPw5_N6YDfJBy0rIcZ1F4FTE
X-Proofpoint-GUID: FqaMaZIHBPw5_N6YDfJBy0rIcZ1F4FTE
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we got a response then we should always wake up the conn. For both
the cmd_cleanup_req == 0 or cmd_cleanup_req > 0, we shouldn't dig into
iscsi_itt_to_task because we don't know what the upper layers are doing.

We can also remove the qedi_clear_task_idx call here because once we
signal success libiscsi will loop over the affected commands and end
up calling the cleanup_task callout which will release it.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 3de1422ce80b..71333d3c5c86 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -739,7 +739,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 {
 	struct qedi_work_map *work, *work_tmp;
 	u32 proto_itt = cqe->itid;
-	u32 ptmp_itt = 0;
 	itt_t protoitt = 0;
 	int found = 0;
 	struct qedi_cmd *qedi_cmd = NULL;
@@ -821,37 +820,15 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 
 check_cleanup_reqs:
 	if (qedi_conn->cmd_cleanup_req > 0) {
-		spin_lock_bh(&conn->session->back_lock);
-		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
-		protoitt = build_itt(ptmp_itt, conn->session->age);
-		task = iscsi_itt_to_task(conn, protoitt);
-		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
-			  "cleanup io itid=0x%x, protoitt=0x%x, cmd_cleanup_cmpl=%d, cid=0x%x\n",
-			  cqe->itid, protoitt, qedi_conn->cmd_cleanup_cmpl,
-			  qedi_conn->iscsi_conn_id);
-
-		spin_unlock_bh(&conn->session->back_lock);
-		if (!task) {
-			QEDI_NOTICE(&qedi->dbg_ctx,
-				    "task is null, itid=0x%x, cid=0x%x\n",
-				    cqe->itid, qedi_conn->iscsi_conn_id);
-			return;
-		}
-		qedi_conn->cmd_cleanup_cmpl++;
-		wake_up(&qedi_conn->wait_queue);
-
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
 			  "Freeing tid=0x%x for cid=0x%x\n",
 			  cqe->itid, qedi_conn->iscsi_conn_id);
-		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
-
+		qedi_conn->cmd_cleanup_cmpl++;
+		wake_up(&qedi_conn->wait_queue);
 	} else {
-		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
-		protoitt = build_itt(ptmp_itt, conn->session->age);
-		task = iscsi_itt_to_task(conn, protoitt);
 		QEDI_ERR(&qedi->dbg_ctx,
-			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x, task=%p\n",
-			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id, task);
+			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x\n",
+			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id);
 	}
 }
 
-- 
2.25.1

