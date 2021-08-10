Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA65AC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 992E560ED8
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhHJIwp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 04:52:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:51702 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238433AbhHJIwe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 04:52:34 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A8pjed018651;
        Tue, 10 Aug 2021 08:52:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=zKc/ptGddB1Y/sWFbxPtx9U+Yr9Os8V0kD85p4GH/d8=;
 b=FVoC99Q3qVwhs6VLv7+nY2/I8W001789U/WXCztnhnTo4l6a6ZtWI84cJD0GRJtxYfae
 QsIg9dZEcIjuVabn0eactuEBsPL/K1+uH/pwSzfxWyyN3GnPh0aA+vf7dUkkWdcANBVu
 Leh4VixVMr83wcs9hXSm4XFtwCTkgKTrrNXUg5d8Dq56pyJnmf30KnH2Pn57HQ6KzLTq
 +scgFcpUW/pAb51t5VdtYOXCzQ9aJ3HeWMCQreU0E7TFmyJpW0GhIUV7S+4AKzuwrGea
 TkZ3po3PQY0AUfCqDhnMg7+f5CsA9GMIWD5va9ZysX5kYqL+MUuxihAaV5wCeDnaFnSz 0A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2020-01-29; bh=zKc/ptGddB1Y/sWFbxPtx9U+Yr9Os8V0kD85p4GH/d8=;
 b=I22nFj7f2A9Kqh2jKsryzO0wTMERJcKQaxpHw5sUp6cnsgZxifoA/HZ/7d20BNh7Mkbp
 Ot6gpLu6Gx22+GyuVQFOlEyV43DkfN2FCGuVdoGfWnuxs/Rh22OFcJfC9WZIRP5A7OJf
 n7JtC4/wQ6YTKdnYq0HIsO5ZuxVn7zS+MVrhrFrFiZ1pw09j3QYnLlZdNcgPhYFSACtN
 VuXV2YAtX6L8XsBEbCQSSBknqwg8IqM0VCAu+oSUCzHwEjYr6YNHrtCwQjhIJHwXvNK3
 sL76R4zupIx6goHkUhjFXB2ON6uLmH+8Ysg9asPJ63PE0YsN2j/qKdPi0LL7IIfyadMr QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aav18kfjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 08:52:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A8oL05148421;
        Tue, 10 Aug 2021 08:52:05 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by aserp3020.oracle.com with ESMTP id 3a9vv4bk9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 08:52:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPR9Lfq5iDLEWmPVZreYYTokvuSr2avmCqVmd4jWxifWYzz5oifw9eDWkmcTTE6lBHqR19inI0XtECc/olnwyj3YyLXuVOr0pBdxB23HcMbk/AsctOIRehAw8MJoyBDa4XGxBShV2jjQJg5fnQHeTNKmg2WEaR5365IETtBi2xWaBKRTxN2QDsHjtxsr3HIjViKbBY5CsrciCC8oVlp13fLai5/QTiZabYlYs2rlaY7ZLZ1nUDE8Y0eNofRPwTfJ6qFmqcfPwDI2g5M/h7gZE7CbAue2h0ymGp/KCv990mDYe3ZZpB/RpTVFb59H9r1tZfqUR0B/zwT/aZJJtZLZvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKc/ptGddB1Y/sWFbxPtx9U+Yr9Os8V0kD85p4GH/d8=;
 b=fy793SMtnFt9FTNsBehgQBDpVaYSbBD8KXuh6Lq2zu4ho9XBZFn81XC3vwGm3tcKRV6QYw7hYiOE0BMcdwlNBBu/8n+E5Xkbus7arUdtKYdH22LY2N52YZUf2h0AZVcf4fSl10FUxdXb1AJY5PmwOLHOh9dkD32cMIlxm9ynyoKjeiE5xobUflXllpr3tZ6ltNlGTF0qryDPTLq2//cFJU3o6ABpOMAekjVwYADe2gjI047HHXTsA0VgIUBJ8G9QVFRWHFvCqEnY6OPMqMUFU6v7+RZ47fCw9jbvHnRjEPHakug0fmkvcRh1watoflNs3iI4JKv3rXr9cpPK1irkzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKc/ptGddB1Y/sWFbxPtx9U+Yr9Os8V0kD85p4GH/d8=;
 b=BHmemvpckanIxYBoTCwCkaZ49jK3sRctaLINSEnni9LFs298ss25ohGxIptd3bmLDOWA8tfrDPFlgUpHk/SWEqAOh5nhJJekf9VhAS8SUTB7wY3UEBqGsl4D8EbLwxIIuPIywhBpM6B7ReLFYlflRwsz2F2TC0pqrtTCZ9gWka8=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1886.namprd10.prod.outlook.com
 (2603:10b6:300:10e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Tue, 10 Aug
 2021 08:52:03 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 08:52:03 +0000
Date:   Tue, 10 Aug 2021 11:51:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saurav Kashyap <skashyap@marvell.com>,
        Dupuis Chad <chad.dupuis@cavium.com>
Cc:     Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] scsi: qedf: fix error codes in qedf_alloc_global_queues()
Message-ID: <20210810085023.GA23998@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810084753.GD23810@kili>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0086.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (102.222.70.252) by ZR0P278CA0086.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 08:51:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3212b2ba-0033-4c48-b33a-08d95bdc1fea
X-MS-TrafficTypeDiagnostic: MWHPR10MB1886:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB18869A69E57DFBB07D13D5A28EF79@MWHPR10MB1886.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rUTxpp/gtthJh9XbgQpVKTOUOh8wn3JCfGsT/RZCIOR0M0uFKqLV9ljvBoSVh/plAEstDUBJcn7g8bl7Ok600G85gEklcY0+YNk6qGvqjmtKcuuxO8wWLxVul7UGzcc2ngkZwMKXssROGilOQ3350pQcrPl1/Hh/545F3bUGHKDHw0QhBph7YYDhmBYJkyJCclpjFXWsmTdA16Z+9gFL4qVTepVh/JnELAOyj/dqohHkA5rgqLEotaMDqIT1xidYu+3LSUJRkirLHP74q74B1pBrnfPFW9bq6zXY8gSNuQXWjDGamYtnGuC4haMjD/VI3SRPConUVwmQqcW6iiYj9c31xHqvjE9F2IhTTWVeSDmA60dUIe/yMHbF2ds/lDUUaCFGmIiEr8vUMxXy2tEwdN+8AICPodHrpTUrwcMQXIL+6MBnD2WotXpM+L5PnquqTsTGc3ZmRn6NiGI4M3MDlvBUxdp7xooaJTwKRs5xbUlB1omjqyDN7/OSf+uRVJY/s+e8GryzpNQH0SSuzu+W18JAGjub/BzpItgd6nEXR53R4a27bgHBIqQDg7F4FJjO2gdBBLE/d5ynK82Q5DbBlMHwZLaO9KHxsJ5JCPXyoEaT/pL43uu8Tra64KvtZwEYMfqKTtAw3j2yHQ83SWWg8V4ogMXOBiGfX2Lce+CrDrikgN+sN2xeGE/9qw91PABtTm4sKTgBy6PWiQy5kcyhEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(9686003)(55016002)(44832011)(86362001)(110136005)(66946007)(83380400001)(9576002)(4326008)(8936002)(1076003)(316002)(8676002)(66556008)(33716001)(66476007)(52116002)(38350700002)(6666004)(26005)(186003)(6496006)(508600001)(54906003)(956004)(5660300002)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dXHnok4A4fA/sNoMNeMQ2mprcpCNbFUA0OZHbc/Z09JMXkuOvt0LyJGyzXZt?=
 =?us-ascii?Q?sOiC0+ymzhHnCg0kO0vokTcj45AJQt3+iyxILvJCGw0k/UXq0iPtf8iZ4oik?=
 =?us-ascii?Q?tuY9OWLk5o0y5w38r3cBbJwUVCCHWCh8oxEfLn7WzDY0nxgjn3dm5f2PUhIO?=
 =?us-ascii?Q?dJipL/vtQYQqYZAiOop7OrwNRwTa2JEHar2fErJRGGL+BM9y/nstpLkfxIhR?=
 =?us-ascii?Q?ox9wbz21qcPfh+u+nkeCamvDiWdnT/t0obJ5EqBslXF9I8uNJtXQuRADcCcB?=
 =?us-ascii?Q?tKbNCPG17/qlHn7qnv3NAGwExBASRt8kOAOWEQSOCnLxsbRcKVXW5Y7CdquV?=
 =?us-ascii?Q?drIBjWEDctHv0GVmEHtOAOSOHrZRyK9egu8HXB22OGMCFq8Lj+ZK4jNdyz5N?=
 =?us-ascii?Q?HBUUTxSKKKKyCzuIEHJ9k35aOFcRzQuez97wIdNDT5aXmBUjZ6DAnL2QK0jz?=
 =?us-ascii?Q?4VjOCc+Zx2sCHDy/7WADZEQWUK9EaQ3OGMSu+L54hPkIy5fur4IhvMtXIxPJ?=
 =?us-ascii?Q?kJIDrMdEOzo7lwn1kNQI2qEdu/9GLC1IDHgHVpFRSbEMucWq0vcFuZrRb4kS?=
 =?us-ascii?Q?gko25XmRXg5LwE9YSO/Y7293SVDNz/f0vp6sX7a+cH81bP68WuLG/NWf3AOi?=
 =?us-ascii?Q?HGxXW7zYsCbnEMnu1PZH8yrbTPf+afU4ffoumpJv+8xhJGg1xYdCNgAHh4BJ?=
 =?us-ascii?Q?pE+E+LtT5TenDinAlloyEECpF2J1l7LpVWdcYy9uI9tzrG5ilQ3b+/eZxIYh?=
 =?us-ascii?Q?L6qCZ7PdrFvEFr12WaVT3ZzxcteAwjznsJI3mZBK8txAt/4UqPtHBoKhmIhA?=
 =?us-ascii?Q?ZvpSt16N+uW6r9ASPuxRL80xiVM2lhJRArv1u+fZIH5zf0lVHecWyAzaCe5/?=
 =?us-ascii?Q?NhdQ4qZkmfDMyrAd9+INwsqlvaNBUMoSu9+j0UGDPMwaS5OmlsSEtnMEjbAy?=
 =?us-ascii?Q?ZvV11OVtLzuTsfzSUAgU7ohmwoKxpOc3KxSkaOFmKJBIY0ETo+OR/NEt97Qn?=
 =?us-ascii?Q?vqwI87hDs22O1RPBNtxOBtNk5V7wbFzSLHOV4sxfk1mKIPEh40khO8k7WKjq?=
 =?us-ascii?Q?pr70u+L1mMC1ekc7vot9SrSpjQoG+vIyEWHjZEzeiJ9TntyoLECk1jHpRUnt?=
 =?us-ascii?Q?KdPDIoYlE2tgSsNgKck1C7gZX8lyeoy17jSZKUhqK/iuCYHsD1vviITwNbat?=
 =?us-ascii?Q?aXhpzo3OsDnYgkd0pn2YbNUu5fyeNRdIBcQjtH6wZblDJQ9EMVMHVs/eoktB?=
 =?us-ascii?Q?eE23NBMW8r29XmRSgrKOYwiqTK41Ywjfdq4Tc3FZ1RH+ioB1MnG8egtaDjMu?=
 =?us-ascii?Q?rAa105gb4B+1SQexIZ0nF+BF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3212b2ba-0033-4c48-b33a-08d95bdc1fea
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 08:52:03.8332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OqW0HRMz2GrW2RSFzfA4Y4OlG2vzJ9Gzrjp6fuafFa29eGoWd1DTUThmgDAf+eKrGszu7zJywYwG+YoFmcJvWdPLAMfNEhC2Cz9Z0ZaQFUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1886
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100055
X-Proofpoint-ORIG-GUID: vkFEYFfmO9EYeBoKDzhBdmYrHY09ecl4
X-Proofpoint-GUID: vkFEYFfmO9EYeBoKDzhBdmYrHY09ecl4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This driver has some left over "return 1" on failure style code mixed
with "return negative error codes" style code.  The caller doesn't care
so we should just convert everything to return negative error codes.

Then there was a problem that there were two variables used to store
error codes which just resulted in confusion.  If qedf_alloc_bdq()
returned a negative error code, we accidentally returned success instead
of propagating the error code.  So get rid of the "rc" variable and use
"status" every where.

Also remove the "status = 0" initialization so that these sorts of bugs
will be detected by the compiler in the future.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/qedf/qedf_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 85f41abcb56c..42d0d941dba5 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3004,7 +3004,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 {
 	u32 *list;
 	int i;
-	int status = 0, rc;
+	int status;
 	u32 *pbl;
 	dma_addr_t page;
 	int num_pages;
@@ -3016,7 +3016,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 	 */
 	if (!qedf->num_queues) {
 		QEDF_ERR(&(qedf->dbg_ctx), "No MSI-X vectors available!\n");
-		return 1;
+		return -ENOMEM;
 	}
 
 	/*
@@ -3024,7 +3024,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 	 * addresses of our queues
 	 */
 	if (!qedf->p_cpuq) {
-		status = 1;
+		status = -EINVAL;
 		QEDF_ERR(&qedf->dbg_ctx, "p_cpuq is NULL.\n");
 		goto mem_alloc_failure;
 	}
@@ -3040,8 +3040,8 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 		   "qedf->global_queues=%p.\n", qedf->global_queues);
 
 	/* Allocate DMA coherent buffers for BDQ */
-	rc = qedf_alloc_bdq(qedf);
-	if (rc) {
+	status = qedf_alloc_bdq(qedf);
+	if (status) {
 		QEDF_ERR(&qedf->dbg_ctx, "Unable to allocate bdq.\n");
 		goto mem_alloc_failure;
 	}
-- 
2.20.1

