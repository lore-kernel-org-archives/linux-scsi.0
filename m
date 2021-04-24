Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F88C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7682C61152
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhDXWHP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53558 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbhDXWHK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6QYp124451;
        Sat, 24 Apr 2021 22:06:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Ds8aIWHgDHKWdmQzIG/BSx7pkm84h4tu9i5T2LzU7pE=;
 b=iHBpr8oTAA0x78ue4Ka+Wthk3VcggTamnTdL7WiQcfd6+jd0HfUTvg862dt9KCSL9MjO
 HWU7J8uVzcR9MdDn4nDeYgdg7dIuLXvay0EdRmCkoZzGj8iVEsO/0Z9p1y127vm+jW8A
 XvosEsVKycX4Jw5vdVnIAulpLxQtjHYLdxAI6b5u6iqEZ87P9iruFwWfLeKXd7D4EvHy
 Wqbg1uk39lRrH5HzBk4I+nekNfRd7Ngu4zCfeTT7QS5XQl8xkJ0/9Gsx/Q1d0BzM51rr
 QpS3ZdmbGaXd3bev0KMr9x8S0w5njZUY9Y1mpfMLXgj6s3/idDaWSMl3ZBHddeD+Tc21 Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 384b9n0shk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM65rS182259;
        Sat, 24 Apr 2021 22:06:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 3849cakftw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awfoqroYzQYscg9mWDCPGoraiOO/W7y/yXkTKyhGFv2BmDTajCcUXlE+VdcdZoT9Bjr/uSd21sKRxQm8mzp/v7YpDT5Hguf/DAIOlDRTNAKKJsedZych5t6feiHj34S6oyY/qi1ntVBZMjZQg4wRoGXy6AI7wemUeL/9pyIIqxA4ExJ2Nc7nE444It7eBptVKooasC/PTS9aj+ZD6Sp3ekRLft4gNlBM7bp27bzezmHstqbdwG4E7sQSw4v6J4yCLqH0jnTf0C2nnOegYWigtzK+lZAyYKrsIFn66YHTZO0vTjsDL+NjS4F537MEGihu8OxBWRGxjHYi1w9x4idwwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ds8aIWHgDHKWdmQzIG/BSx7pkm84h4tu9i5T2LzU7pE=;
 b=kal5przgvUd7P3ClUWl49x1Thore90wcOk+xO2BtVkn6eSfrAzteQHGwxJexT8Q8pq51yJp+ht/Jidj1Qax3kgmFLyjE1fG7/RReySXRkcIFseuLgOp9d4BskALJ69Rbg1G+dZ7jT9KFj0r4l3wypNSJUWqJYUJvgb9dIi+jFliRoMlC5EQbkCBPVslZg+Pznak0htiY/sDzvfwi8tpY0wAxv4suomdYsG80I3uhUMw8HgutQ2jztfvwyuA57jpiNqhhnxdGOLPdkbFLsR9Na0UilLZhJGYwCna6tldkdpJI1owigjPg4zmzGL+6LRL4+alYATv5Cbcr9IM+DoOezA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ds8aIWHgDHKWdmQzIG/BSx7pkm84h4tu9i5T2LzU7pE=;
 b=iDxwzmP8j8MoK26xY9LrtSgCgqWrs3UbnCjk5O/iTkUawOg5F/B1mYxJf2WHqQxbd8vT9WGUtk0+lclAdgY57jsxM8KfBMh98AAZNj44yimb80dMbJ532o79+a8heuXyzmnYpf53WEqL+9SgX8I15Heaij+YRC5gu9vJHEE7BCE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:24 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 11/17] scsi: qedi: fix TMF tid allocation
Date:   Sat, 24 Apr 2021 17:05:57 -0500
Message-Id: <20210424220603.123703-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e8135f6-5acf-40da-f367-08d9076d3349
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33173A7DC02E05D27C0E97FAF1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+rMtqNYye2P+WK5XZVHwFnByQsOmaSmKeKv3oGLztZWIaudAttu0usT8HOkgfljrgHlZ/RJWhMfPVfmJaHq6BDw18X6Bd/UnQEx0Z+bfaJhNeqDF2fOdXlMTGGP0yUG+cBKiem9QjuCqt38MPH82PF4su/3O/KnGDiLALRatKgZEZALbacALHB6xiasukfr0YnnuX9yANHxBYK+KYBbcqXqE3Cl/quyyCeG3WpoRe6Jy5fl0QVOeCKpoCLnDGABSjTKxLGW4omLHb5ItQxdefWBpmghyH+7XreIX/YraaceRyD3ofmtuQd82V6TcZ6zofzD6DwNJ7PHof8DC6ZiKUQGZqNR3LOASPlabLXxLzlypN48ibQNRyt4JMgPSL7/kajxxW5bBp+DQ6ncCYBmDwzre7WjVSKRolHeHqY8s8RDDo56fZfm1sSGFJsofI20x/nGlleIveL+t4MZSBtYO4xDsGN8PrXB8x8CISyLa7ngC7y4P72I/F6Ojm4ID4cIpcVjR91NDmX9pGHcP3OApqAijpnRqytWginfEEasY6GqjmTXDC2QS8NYBKvpvPdlcmEzfPOIdRC8lejXydQ0zmcvC2lVikEQ4nAOs1yvaYPbGVJ9jUY62G1eN6tXpIAHG+NIwS7JjeCvB1+brdGXqupoZbPPcBBixO7yzuUIo01fv93JgEb07UFRRGF8ITLT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?awuIgL3q37y7KdEul+CtpZ/1uq1CQSPs96hY4VYmuCLQ/y2cyzo+LcWktKdM?=
 =?us-ascii?Q?PsaN6zcqbradYdWtYXkQToZi2c+NFPbCi5VdNULltr3MQTIq+ipKn8A0IXGo?=
 =?us-ascii?Q?HbgqyLGnnBMpsj358fhTbpjb8majPP9/Ol0nq8Fr2vYHOCNcYqncP8uoBRKq?=
 =?us-ascii?Q?x1tMKmvOFYb548aWZYtnewQ8djNgHTw6vhrPN7Szdb3aCY9OyUgaGnnFTMBV?=
 =?us-ascii?Q?yNSzH4g4PPv6x8QA79tSIEKCUVKt1NZnhKYp+4g9JbmPEaY4rt0mP9mFN6/C?=
 =?us-ascii?Q?Pc3jK6rGrQGr0S4y1ld6AGIXCf/bIkX8xpdgPLD0MsGUNmBXlR6LkHulKlP9?=
 =?us-ascii?Q?XIXacQkXK6s/2VuH0iGeQjFBXZ9ryb9ZvgjRQiwiUM4Fcz8shl1sXOsoWe+k?=
 =?us-ascii?Q?73nZS7pNYcY746B93t2qCVCTCmODZPc4STnIDfqy/sXCnq4ghj38izpWkgEd?=
 =?us-ascii?Q?Eo+s14N5+cxKgzfpK9RMgDm1eSDRluG7cG9taww2Lvi0qZKqtR2HXEV8IyfK?=
 =?us-ascii?Q?YK//86gAJG4c0FfSA/rRGuNKSOD1kXThqFprNJbNFoIVrSGfPBxR6R7pZQhj?=
 =?us-ascii?Q?+L/x+Qtw/cubCy8cA8N/QDTvf6UQNVWleATLccasw7Jp8BGEjUFHqAtDd9pc?=
 =?us-ascii?Q?qjqTXU8TDVvZ2Rt8X78M7r+xH+MC8Fb4uOCiI+EziVr2x+IX45VTvY/boEnv?=
 =?us-ascii?Q?Ab6oZ3+sf4PrMYyIOyEba6QE3nloklocEDvp/Y69sWJW4+JouDkcr3i1kn3m?=
 =?us-ascii?Q?MTMM2jAnSHgh6UWN7s5x4nsyoOI0zQibZYiQiGULGW3yGaw6BhAXyN5VxZZQ?=
 =?us-ascii?Q?S8utSlc1mPP1ODmj0QQi9iyGXvxbsKmUmQW7xdjTQLkDuCZEchLjvkkIg1ko?=
 =?us-ascii?Q?lh9frwdHWt+Y1tzuRIzWIlf3VTKfQ4JmlZBRDiZod1mdbOO1ytuqPu5PUOUs?=
 =?us-ascii?Q?cIt+YDnxnoHvHsvy7YNCc1wJjmiqwzPPQ7NtbmqWR1j8R6ebwYK8QLPdPsa1?=
 =?us-ascii?Q?Gsepg4mUHYruDgAVkROuSjU7AUEed4a3LuoFbblWlM0/NO2KyN2HjJE+uwcr?=
 =?us-ascii?Q?SRb+Mp1BW8AslAmZmPD2isx9+B1DYhRN9Xcge2f8XyIoitzsi5ZBbJupzWh2?=
 =?us-ascii?Q?Ph3TBcnLGhUEaTHz6Q/lvx8mlIsoXlAZkxuWIaHcR254IPCMYmk3upG0+3qa?=
 =?us-ascii?Q?BsIHr3sSQDXgD99GHwFRUdZF2B+MQnInLyXqodhvow2/gp45QXvXOWk7tT2b?=
 =?us-ascii?Q?ByDRmjBF6MaQaDsLlrfTMvf2dUD2ENj6gc83JIa6GMh1PpGJuMcnGBH5xHv6?=
 =?us-ascii?Q?jf7sjYrcEUlVbk0Es0ZWtmh5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e8135f6-5acf-40da-f367-08d9076d3349
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:24.6577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i29CnacMAlUsC4bIQik4LFquFh7IVKcnLDAH3kl/urIefuJHGh0DqvwHN9JtJdJ7cL4XaL5A2//NQSDhiK9S9gLJSKeUikg7FO1vF3br0vY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: Fb1eF7-Tii6PJpv7TkrQVn-ZgZfR3xw1
X-Proofpoint-GUID: Fb1eF7-Tii6PJpv7TkrQVn-ZgZfR3xw1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qedi_iscsi_abort_work and qedi_tmf_work allocates a tid then calls
qedi_send_iscsi_tmf which also allcoates a tid. This removes the tid
allocation from the callers.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 76 ++++++++++------------------------
 drivers/scsi/qedi/qedi_gbl.h   |  3 +-
 drivers/scsi/qedi/qedi_iscsi.c |  2 +-
 3 files changed, 25 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index b53940af4230..b4cbc385d0e3 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -14,8 +14,8 @@
 #include "qedi_fw_iscsi.h"
 #include "qedi_fw_scsi.h"
 
-static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
-			       struct iscsi_task *mtask);
+static int send_iscsi_tmf(struct qedi_conn *qedi_conn,
+			  struct iscsi_task *mtask);
 
 void qedi_iscsi_unmap_sg_list(struct qedi_cmd *cmd)
 {
@@ -1348,7 +1348,7 @@ static int qedi_wait_for_cleanup_request(struct qedi_ctx *qedi,
 	return 0;
 }
 
-static void qedi_tmf_work(struct work_struct *work)
+static void qedi_abort_work(struct work_struct *work)
 {
 	struct qedi_cmd *qedi_cmd =
 		container_of(work, struct qedi_cmd, tmf_work);
@@ -1361,7 +1361,6 @@ static void qedi_tmf_work(struct work_struct *work)
 	struct iscsi_task *ctask;
 	struct iscsi_tm *tmf_hdr;
 	s16 rval = 0;
-	s16 tid = 0;
 
 	mtask = qedi_cmd->task;
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
@@ -1402,6 +1401,7 @@ static void qedi_tmf_work(struct work_struct *work)
 	}
 
 	qedi_cmd->type = TYPEIO;
+	qedi_cmd->state = CLEANUP_WAIT;
 	list_work->qedi_cmd = qedi_cmd;
 	list_work->rtid = cmd->task_id;
 	list_work->state = QEDI_WORK_SCHEDULED;
@@ -1428,15 +1428,7 @@ static void qedi_tmf_work(struct work_struct *work)
 		goto ldel_exit;
 	}
 
-	tid = qedi_get_task_idx(qedi);
-	if (tid == -1) {
-		QEDI_ERR(&qedi->dbg_ctx, "Invalid tid, cid=0x%x\n",
-			 qedi_conn->iscsi_conn_id);
-		goto ldel_exit;
-	}
-
-	qedi_cmd->task_id = tid;
-	qedi_send_iscsi_tmf(qedi_conn, qedi_cmd->task);
+	send_iscsi_tmf(qedi_conn, qedi_cmd->task);
 
 put_task:
 	iscsi_put_task(ctask);
@@ -1466,8 +1458,7 @@ static void qedi_tmf_work(struct work_struct *work)
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 }
 
-static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
-			       struct iscsi_task *mtask)
+static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 {
 	struct iscsi_tmf_request_hdr tmf_pdu_header;
 	struct iscsi_task_params task_params;
@@ -1482,7 +1473,6 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	u32 scsi_lun[2];
 	s16 tid = 0;
 	u16 sq_idx = 0;
-	int rval = 0;
 
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 	qedi_cmd = (struct qedi_cmd *)mtask->dd_data;
@@ -1546,10 +1536,7 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	task_params.sqe = &ep->sq[sq_idx];
 
 	memset(task_params.sqe, 0, sizeof(struct iscsi_wqe));
-	rval = init_initiator_tmf_request_task(&task_params,
-					       &tmf_pdu_header);
-	if (rval)
-		return -1;
+	init_initiator_tmf_request_task(&task_params, &tmf_pdu_header);
 
 	spin_lock(&qedi_conn->list_lock);
 	list_add_tail(&qedi_cmd->io_cmd, &qedi_conn->active_cmd_list);
@@ -1561,47 +1548,30 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	return 0;
 }
 
-int qedi_iscsi_abort_work(struct qedi_conn *qedi_conn,
-			  struct iscsi_task *mtask)
+int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 {
+	struct iscsi_tm *tmf_hdr = (struct iscsi_tm *)mtask->hdr;
+	struct qedi_cmd *qedi_cmd = mtask->dd_data;
 	struct qedi_ctx *qedi = qedi_conn->qedi;
-	struct iscsi_tm *tmf_hdr;
-	struct qedi_cmd *qedi_cmd = (struct qedi_cmd *)mtask->dd_data;
-	s16 tid = 0;
+	int rc = 0;
 
-	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
-	qedi_cmd->task = mtask;
-
-	/* If abort task then schedule the work and return */
-	if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-	    ISCSI_TM_FUNC_ABORT_TASK) {
-		qedi_cmd->state = CLEANUP_WAIT;
-		INIT_WORK(&qedi_cmd->tmf_work, qedi_tmf_work);
+	switch (tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
+	case ISCSI_TM_FUNC_ABORT_TASK:
+		INIT_WORK(&qedi_cmd->tmf_work, qedi_abort_work);
 		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
-
-	} else if (((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-		    ISCSI_TM_FUNC_LOGICAL_UNIT_RESET) ||
-		   ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-		    ISCSI_TM_FUNC_TARGET_WARM_RESET) ||
-		   ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-		    ISCSI_TM_FUNC_TARGET_COLD_RESET)) {
-		tid = qedi_get_task_idx(qedi);
-		if (tid == -1) {
-			QEDI_ERR(&qedi->dbg_ctx, "Invalid tid, cid=0x%x\n",
-				 qedi_conn->iscsi_conn_id);
-			return -1;
-		}
-		qedi_cmd->task_id = tid;
-
-		qedi_send_iscsi_tmf(qedi_conn, qedi_cmd->task);
-
-	} else {
+		break;
+	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
+	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
+	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
+		rc = send_iscsi_tmf(qedi_conn, mtask);
+		break;
+	default:
 		QEDI_ERR(&qedi->dbg_ctx, "Invalid tmf, cid=0x%x\n",
 			 qedi_conn->iscsi_conn_id);
-		return -1;
+		return -EINVAL;
 	}
 
-	return 0;
+	return rc;
 }
 
 int qedi_send_iscsi_text(struct qedi_conn *qedi_conn,
diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 116645c08c71..fb44a282613e 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -31,8 +31,7 @@ int qedi_send_iscsi_login(struct qedi_conn *qedi_conn,
 			  struct iscsi_task *task);
 int qedi_send_iscsi_logout(struct qedi_conn *qedi_conn,
 			   struct iscsi_task *task);
-int qedi_iscsi_abort_work(struct qedi_conn *qedi_conn,
-			  struct iscsi_task *mtask);
+int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask);
 int qedi_send_iscsi_text(struct qedi_conn *qedi_conn,
 			 struct iscsi_task *task);
 int qedi_send_iscsi_nopout(struct qedi_conn *qedi_conn,
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 416202bc4241..0061866614b4 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -742,7 +742,7 @@ static int qedi_iscsi_send_generic_request(struct iscsi_task *task)
 		rc = qedi_send_iscsi_logout(qedi_conn, task);
 		break;
 	case ISCSI_OP_SCSI_TMFUNC:
-		rc = qedi_iscsi_abort_work(qedi_conn, task);
+		rc = qedi_send_iscsi_tmf(qedi_conn, task);
 		break;
 	case ISCSI_OP_TEXT:
 		rc = qedi_send_iscsi_text(qedi_conn, task);
-- 
2.25.1

