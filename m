Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD108C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A084361360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbhDCXY4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:56 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45106 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237010AbhDCXYg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJwJO097218;
        Sat, 3 Apr 2021 23:24:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ovwEHoEg3xXbEepx/O5huMTk8CmXmNzVgX6wYqLv3Is=;
 b=VmOPo1TjkTZQcTLsIRDNH9s3ldfBuz1YyPyfgCbreyZFvCN4L60Ui4uNfuigtmy8t9Sd
 HSZp45U35HWwrSJJJj/YQUwe52FTnDhJ2uYVLwEXjGdLhvJG+/0lwKu/Tc8+2XigEKfx
 HKt2mgozikXCBUDESXU8uAyv3T912wGx33lFSvUPZDhrPxeh1MX2ZNIwtzfK2LJOvMHb
 5TRynlh1OIUTOi5t2nANAw8e3R0Ucpy1C4zcoMMA1XgegMcsgjzWdHPrBXIPcK5a9hBf
 Uq/oYpGx7XhNH9LkfuerfXfNPqrdudAgjbIXeXcTr6qlxPzr1DS0ArIFpyY1cOT6kCAf Mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37pdvb8v6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NL7JW130245;
        Sat, 3 Apr 2021 23:24:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3020.oracle.com with ESMTP id 37pg61huc2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WR2S+G1hE3Z8tIl1rhKR4T2PpaUsXhdE9qrB70OYXpVDaiNa+WnKF43kw0PAyF0GLKpnXzYmTqEcI2FV8NDZ4Auz2wacH6H6cGa4PXXYoC4SqyYqpK0uenGNYvCNIWcithfvBUeKm4Kala9stZ8mwc3zVoX1BMYDevfwG14kEorHMa6w7YKEkznO9TdSj4Dcumav54y71d2vZMwp/MfASW8QeETYXlooG+tXy8019jLuTKtGXvur6UFty+DQebwb8K3OiKGhJIyu66I2nHZ2FagNb6oZdA8pwNvh+4B7HN8jFlp3EJGQaIDouqEdWbQFHXXIHpJaipd8IRujurpXTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovwEHoEg3xXbEepx/O5huMTk8CmXmNzVgX6wYqLv3Is=;
 b=efCrU+vV36Wui9QgvrGhWnPRtV0kF+f5U8dm4q2tHad2ZXym6qDUFsJ6klLp2MKuFu4Y7n8ehXGzkYUctUsveN4OjG//9SRGTfhvNbWteErLMaEgEcy8bj3pf80/Rs8yR2SF78SIGcgmNqZmjPl9jrfDuQzxrQMRH3iIpF/qwuNYpuCwyD/5qWLTPka1VXBPa9MG2h56uIfjwJPihX+5CvQ17DU0QJJMcH9d3QebaGposIWfPooCeO5wZOj60HpPyT46ww+Vmhf0FXo6YlHkO+znZY4TlA1O8wO/63pkpw9R6w/1ID9D0EY+KFs5B1tgEJn9Waspc+JJujNpuKaVMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovwEHoEg3xXbEepx/O5huMTk8CmXmNzVgX6wYqLv3Is=;
 b=aAuRPkGsKqiRM4SfNAGuLsrtIthE8pf43oxeBqHcy2qZlo48SrmH1s+hHqwkeSfFLX59nxNCpwKbHk+IppTYq0txyUhyTpS5M9KgoBq1ffOCNxyYiL77ediGEJF1kzIWCclCc1819XMkpGYHvzOJ9aXfZSVFypz/h+oKV/oBgm4=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:21 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 28/40] scsi: be2iscsi: replace back_lock with task lock during eh
Date:   Sat,  3 Apr 2021 18:23:21 -0500
Message-Id: <20210403232333.212927-29-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cfbe897-9cae-48ed-8d74-08d8f6f79c16
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431073CA44374B55774F5BCF1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8NZzIuOLGjLKfJAfiTCx51I+Ony0al3Ai1jgKtA2gxDmrNiiZ7a0RiljuPNGGD3pSCw8auLQhWzHQkwy7pZL0NDAtDvA08y5gdwLe0qbgzHC0G2xwlLOZ59311LT2c86CVZM13lm9QeobJWAzLalvwxWF7JqPWvhAPWNzVbMTkCYXRGAbW9+/1C8ggbVd9awgKtL63Ikt0NYRzXZHTPHRKkPz6zkyX1Rl45ktyXJ3lYvIYAswrdUHdwHDqGbhxEH76Z4kzFLCnd/25gJCvDalJ3523ZNdzX+zIW9nwUhB7TwCvsYN3A255FvtPx7S82rWTXEA62QJ7pxOyieFyEBPNryLZIotZomK+OR3F5YeUq7zkN4M2tYUIJv93yGt+I3+zakeSDht+5JV3Z/WquOXUj8uL+dYvAb0rM4QUTYDt9i0P1u/s0BIm5WNOyDFEaZXHCPunT5lDiKruMEf6n8xsL1pf7WNmHd1zCjX9m9CNkSQeBail09E5YQM6P3ZeMqUafXTMFLVxuoQWtwo1hoIjnOjrwTMUyccXupRhgPn4BoJk42R7Ll8rjVp6VPu+TLrI0BpHMtPi5rKKv9UWIS0u1j8rhfmHS2gUjNXkXWMmyvaATQ2kOFKGfop0188Q7Bj0EzD/99XoxtpPSBrScuDmaXSL55y5NTzeAtuNSOHjtRiPyQ2gdRUJH4zVq6zQqOWbKYHmVsZ001TbmxwGGShA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(376002)(136003)(38100700001)(69590400012)(316002)(7416002)(478600001)(2616005)(921005)(4326008)(66476007)(6506007)(66556008)(86362001)(2906002)(6512007)(107886003)(956004)(186003)(8676002)(6666004)(8936002)(6486002)(52116002)(36756003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5X4RCeAmwlrd3g2+3RASTmdlJ1F4CO3k9M9ixPLltY2OBA8o1aCR0ezZvLRX?=
 =?us-ascii?Q?pgbF1VanvuS1hrXtzVhe0fQh6mSHnXKVAx0igLoscD/7u3X8iKo/qtsulmR+?=
 =?us-ascii?Q?1046NTM/BVhROu46/qgzjvZRG2T4PzahyGcVZbongW0RPMAOcIyVq3H7XiBY?=
 =?us-ascii?Q?Nn8v2zwmvaPNTuXUfrd+vakEDw8yCuFCuUULTaXE0puQkcocUtThhLGI5fFx?=
 =?us-ascii?Q?mA2LVrw4aT8AYEP83rWX9jH7DUiDAQoWS+2s4Z5TCbG43MPRRIPoxDeQ3Ikw?=
 =?us-ascii?Q?qePDkDkDXLJtxCmPjz3V8Q/Ie5vq/UwASuFHgP5XBHckCEmtCa8Ygps20+1R?=
 =?us-ascii?Q?YuDMm9b7Td1/WWok3APTpzJm1mRn35RzZke5WTDpnHFmddHaLqgi6JfMta6M?=
 =?us-ascii?Q?Or5NoWIRv9I0xnr3E4QMFgWlxWDXRif8YTeMwOpx8QFH6VEGcpCzG4H1IuCI?=
 =?us-ascii?Q?kXQQVwcLJ3DGG4n3CWbh5xvr0wu41/ksPeesb5tWOzmnqR+P5hP8Dpuspqpx?=
 =?us-ascii?Q?b5KZOQiw/G6tqtwS+Xeznx0dD+pU09OpB5ajk6/LFNws8pnwH51VyICn4Y3W?=
 =?us-ascii?Q?T0AGi3QYD/IZOKTHEIztx40oI79nf6kuHc4n0w98AKP1baIc0fO7ZBxLmGKe?=
 =?us-ascii?Q?egF4xXUGDtpcPNHGU6bvRRD7j9OXnFbE2/PZptCXYG007WI0FEUfO3Q9wTDZ?=
 =?us-ascii?Q?brDekeW7oj93D2jyLiO4aJq2wnPjs8wHhJnqAsODWwPEXphXyxf+cdRExqAO?=
 =?us-ascii?Q?el/bUtQW06Xqp/m4METqOxUZm1X8En2su92q9QSe60o1ZpJJSVMVLB9Qbgoa?=
 =?us-ascii?Q?oK2dYgwIasFeLulriQmKCHWYoo2aur/FgdjdRY/P9haePfAoUtEteNZ9v5Py?=
 =?us-ascii?Q?UVLtnlCEcFnUobwj72YymTmmvIVcAdxyZDkdZ46Gqrb9iGu/a3pj6pqFLzN6?=
 =?us-ascii?Q?cnRKP48S87K1CsMbfsHQB+diD5VY2+j36+qTm5Y0QbCcfcUNewqhdYvg+3kf?=
 =?us-ascii?Q?W4b67ReOAibw01Lzh7ZASHzMFCJkjPtfgiyX/s7Cof8vgQzEt5TZ3mSU/CkH?=
 =?us-ascii?Q?yjLUjWnEcUpSfxsSYQl+xtPykEPBBRsUNvsp4sbOhjLuJ2KPucEJ0oCUJRwm?=
 =?us-ascii?Q?IoowTlr8bDz4nyZ21GmT9AuG3v/94dEDWrCh+w3L6yaRPM0lYLQZXA86cgau?=
 =?us-ascii?Q?OqrylKgskqSzo0am3xS4ke+58BaQXvEyJv025ftFSbvYmc4c9l0CwGU0u0Mh?=
 =?us-ascii?Q?8HPakkZPb2uwe0K5aTp5gl+gXaLnqQXcfIVx8IQHcchDlCIR+SM1haGMOuvK?=
 =?us-ascii?Q?ZBAXOr/NBCOBr3qJVhQ0T0TT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cfbe897-9cae-48ed-8d74-08d8f6f79c16
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:21.0543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lz9XWT3W3w1QNFabacYyAxm242osAxCNQRpA67NlrszfsEY6PveDrWiypNfb78RVgCFbd2EdxfFP+399aH6AHbFtGxljdU6ArbICe9VtCOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-GUID: Qw6_GYoChyhiYxyq1pebEuWJwGC7igFz
X-Proofpoint-ORIG-GUID: Qw6_GYoChyhiYxyq1pebEuWJwGC7igFz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This replaces the back_lock with the per task lock for when we were
checking the task->state/task->sc/SCp.ptr during error handling.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 4181769d7303..da5ede4ef7f4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -216,24 +216,19 @@ static char const *cqe_desc[] = {
 
 static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 {
-	struct iscsi_cls_session *cls_session;
 	struct beiscsi_io_task *abrt_io_task;
 	struct beiscsi_conn *beiscsi_conn;
-	struct iscsi_session *session;
 	struct invldt_cmd_tbl inv_tbl;
 	struct iscsi_task *abrt_task;
 	struct beiscsi_hba *phba;
 	struct iscsi_conn *conn;
 	int rc;
 
-	cls_session = starget_to_session(scsi_target(sc->device));
-	session = cls_session->dd_data;
-
 	/* check if we raced, task just got cleaned up under us */
-	spin_lock_bh(&session->back_lock);
 	abrt_task = scsi_cmd_priv(sc);
-	if (!abrt_task->sc) {
-		spin_unlock_bh(&session->back_lock);
+	spin_lock_bh(&abrt_task->lock);
+	if (!abrt_task->sc || iscsi_task_is_completed(abrt_task)) {
+		spin_unlock_bh(&abrt_task->lock);
 		return SUCCESS;
 	}
 	/* get a task ref till FW processes the req for the ICD used */
@@ -252,7 +247,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	}
 	inv_tbl.cid = beiscsi_conn->beiscsi_conn_cid;
 	inv_tbl.icd = abrt_io_task->psgl_handle->sgl_index;
-	spin_unlock_bh(&session->back_lock);
+	spin_unlock_bh(&abrt_task->lock);
 
 	rc = beiscsi_mgmt_invalidate_icds(phba, &inv_tbl, 1);
 	iscsi_put_task(abrt_task);
@@ -274,7 +269,7 @@ struct beiscsi_invldt_cmd_tbl {
 static bool beiscsi_dev_reset_sc_iter(struct scsi_cmnd *sc, void *data,
 				      bool rsvd)
 {
-	struct iscsi_task *task = (struct iscsi_task *)sc->SCp.ptr;
+	struct iscsi_task *task = scsi_cmd_priv(sc);
 	struct iscsi_sc_iter_data *iter_data = data;
 	struct beiscsi_invldt_cmd_tbl *inv_tbl = iter_data->data;
 	struct beiscsi_conn *beiscsi_conn = iter_data->conn->dd_data;
-- 
2.25.1

