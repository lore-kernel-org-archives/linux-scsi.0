Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F351C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 595306135E
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbhDCXYk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:40 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45050 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbhDCXY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJwJN097218;
        Sat, 3 Apr 2021 23:24:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=TstOIiXBGB9nrKwYHL8XhCb0X1C8or19PXL5jaoy1mI=;
 b=SuqQpynjsG2/0ewuNQM/JUfMylamXMk5GAYntcgaOBio5gqnZNmiVFSdmEwE8l0vPipi
 fLeD7fdALE4T/UlSTNfeIRFCuScplVT78ATCdgyTNYhZMGLUK4J0GY2/goBUs48AQWeR
 iBULo1AfCcUUVYxapUZVsi4b621r0JtCVlCE2GmIsQiKJS92RNw9d7xFyyhLjFNWb9f9
 6mBu4vXG9/3zhNKUzAizGATj7YXolXowHIxlzJiy3r0+OJNA+1fkAT1vphZIkb+IRdRP
 wZ+Kto2I9DyMuHmuLIYYIcKj6SoZqOTqLUX1MjIJ9TwJzeczdkqOw0tJ2qRo0pkyBrrz wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37pdvb8v6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKuMU117114;
        Sat, 3 Apr 2021 23:24:14 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2053.outbound.protection.outlook.com [104.47.45.53])
        by userp3020.oracle.com with ESMTP id 37pfpkbsqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaLkQ93VqbT4+nPET0Y1HWT+H9DV5a2n7OC1h0OR/ZIcls+13CukPC7Go8/0HEP2ioCZl5ZNEbqvx0cKM3t7Yie7Nb61XDVgk6FZNKW0JxvpdMZMZpT196QB74/Ip+jVZPzJRN2Rj0RtGurHTVPCzMJHU19yPadWk3LMkTH8M2bv3n6l21uGryITESsOQfmZ4ON/OMmRW9yPQuqe+CXAFxf1QXZHDi+C4uezG092q2ttdlX1Mjz92GtBxo9gr/ILDaDkdgZb4Al99PIroRZDI0g4seeCePdycxHf5SCuqohcEYi9ruwKkISOr8bNmo0qiFp6I+gNOZlTdE7qz/QkZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TstOIiXBGB9nrKwYHL8XhCb0X1C8or19PXL5jaoy1mI=;
 b=WdUg5uW4VBNIm/Wtbp51LbgluTR8GXXXVr5x6iUVmkpSr846Kbh27jtnyDLXudubWOP9orMuwuRmrQFBR402ayKZrUQ3lZjdT6hDkMM7jB1BFnBcpqihqmLWTasPKx6bcZVbGGsBotK5pXE1O7HcPYP+M2ya2bIlyEc1yY/5DVgX7aWdsuhw15vxql8gA5yypwxy+OpOy8qPTKGNBRqTukpQuw1jbr1O2OMj7fSS6HNgRYYSuRigEEc+cLtgtjsEJh05KopFOyKR0lrC7zeQGZA3vlejIfjvMSmjPDkqwWQJK0ih11kEJnWxcK/1nB594qsTPZgmDGVqNjPqmKYblw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TstOIiXBGB9nrKwYHL8XhCb0X1C8or19PXL5jaoy1mI=;
 b=lEDgIUnXAri7/s64AzocHqvEl4duLc0XKgQe9ARibL5ukhbq5ZFm0bSZ7xQ4AWw4AyJWwiKRk63YUAyCz5xXfntTsRsrwKBlDYyy97ILp2HK8sF59SSb6COPJIM8KpElvUf9Z5XI5uwqS59bQJx4AiGe6Rg4mmsBAttwa5fUJaQ=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:24:11 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 21/40] scsi: iscsi: use blk/scsi-ml mq cmd pre-allocator
Date:   Sat,  3 Apr 2021 18:23:14 -0500
Message-Id: <20210403232333.212927-22-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eacf9f02-01a9-462f-a08f-08d8f6f79698
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB35267259F1F6FA593F32F221F1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ca2q46S5oarfJ3iMjE9O2NwweESBfqic45AZwA1fxff2d3iXkrRLlOdJlW2Po6oKLrVK9ZGmAA5qjzq7t/6SlLaYvId8AFzVWGQqxOlvBFrX39MP6xlEEW+EclPkc28SL3cScTVuJgL1LsIebz6NdBKb+23rBRRt131vAHSZUVPCGF0dENF2NH7k2okiwzUiPvZbRDB2kxhNEfRaBX0+gZszuz0UHNk6wokWEwp8QIC/k/Tt9i4DZh8OBgdwpFhSCs5ylyhecakOnCOShq7dSBChe9RvYIvKU66ImM2eA/+IBezfIdRwjWAIHmj4D0GLd+qJSqeQeJF7qwZlslKPb5KM7T5og7QP6nMMsow/WZK/qP630fcxzM4JzQImk9ObMzY9794LV/ZWeQt2t+RjRdz2iAgDZALPB2LvrGW2gTMunEC4UoTsJqQbNhZ/44++o1wwMDqvbDNjtS39kl/jbzE5Rcbdy6EDotIvwctn/OS0dzwnzOR6iWYe6XK/sRRtQx/JGmg0azOYRS3LW7UdEBIN15UEXfyaOSJfPvBg/7fYFvqRfaSMA7JVKEDwjv4sShkEZF7oYfemZlMYoqfiCHrP/SPKEcxB87J/weksF0kGNtLTFKoxIVcipT+Xwg/lq4ygSi6yN5LK61cUub9sKH/yS+FpF//1Clu/W6V5evtaHApp1iyU/KKmxK+w7aNqFBG8obxb0APoimolVc3gcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(30864003)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nyQJBOtvwwUA5zREAQ7EJWDcMrjCpgnl1zXomiLpDN8XDVtv3XO+JV6jWjkM?=
 =?us-ascii?Q?mk0hLoes+lbSgHM2w3I+aDp4MmcZ8KA8Wj02/6EdH6cPLLQat5l0xWve+ASG?=
 =?us-ascii?Q?Vof344KpiIKy3fXxmTVdRG9I8ODdck6+wbkRi4ZLFaYh2IQtSh8z2cqiRJ0b?=
 =?us-ascii?Q?xEBczDqw0X2BsrEbc/rKtA9jWv9CaiKLd5TssJTPK3cQcI5C/yJYdX3K8mEg?=
 =?us-ascii?Q?sNOJKPYiHp8qpr3MIiBap6UphAHnzURrSLjJ/DRa2Glll5PI088FFpDrhzEI?=
 =?us-ascii?Q?4sbvJl4BHyPof0pN6l7NSRpsZYUltXScGrAkBlcdA9V3gAzs7YaNQPlSwvv6?=
 =?us-ascii?Q?f5uVsGdDKGfwzo8sBrw8CE/BLc2ZYHQY6H/bYBDV2LxQcehUOZPGI9OGiCtL?=
 =?us-ascii?Q?89AIeQjNnnnozgXU4/rQgGg91X8YWnWCdCNjDT/Y8u8/mNQsQpxe8mCp1CtA?=
 =?us-ascii?Q?J0ZyqMQBKyGAvKQWCGWbvK3tpqx49+tfIJN7UmtBpv5VdzaC4TW3WbGmPUf6?=
 =?us-ascii?Q?zMPW1IBaxpZYWfgD9ulARe3CfIPEhSRr0aNZnCUVyQQa5+S/Wu3jVxJGcaH1?=
 =?us-ascii?Q?WHmbtfat/E6W0cloVY29D91TQo5WKZjKQvVTd0iw++l/1F7yBuhOj55Srz0j?=
 =?us-ascii?Q?SUqieEJr8fhKUvflz8W9pcPY6XXenrQgZfiOc/mjbgrf4qjaxCmTMVCdOwvH?=
 =?us-ascii?Q?rtIYAdrxIkmzMccD0dYUJzRPw+nPIDi9QJY+dP+x0Nizn/eQIkBEw2/hPKCd?=
 =?us-ascii?Q?lOTAZcDnqHq99HFylB6W0JL073V8r0m6FVJYkrE36fKaCvlYUJEagTIg26m3?=
 =?us-ascii?Q?4nyEXFp/ohz2azlDx9s7N/e1QThyAd4pPhVhicoWR968wJh51eNySJ2UbuDR?=
 =?us-ascii?Q?KkhWYyX4unZETFB09gG7mi8zJ7MM2yBvqALFp6X9dp0xwJuTl+rt3hDhHuJX?=
 =?us-ascii?Q?Lp0KTkw/Vs90kde9bYEyNApbdlLPa/bcob1FzxZIDU5TiJnGdokZ/8DUDnG1?=
 =?us-ascii?Q?QUcRWnGyw0qlsD1SOqskw7DAHlIyJ09WyAtPkevE68XbvdoFTKkmBRECJdd9?=
 =?us-ascii?Q?NYdUZGjCDvz2XJ+XqoFCL1t0HtqYFDU9K/ZUbClRAdIBR338aS4cmtI8G7hU?=
 =?us-ascii?Q?xkICIIEt31Al7g1PWtChuYr4yoYEyCJv5mfATak5t2Des+O9UD052UQBMcFV?=
 =?us-ascii?Q?q5uyA7/0aZ6xMNduExKea38Thxh69yfwAvYjXyq60C7amFO53YtezaFOVnNe?=
 =?us-ascii?Q?1YTMBy61eV77xY2QKnbevdNEDyRLoyJjJs8jMWqt8GhvQy+P4VZq6zg+692u?=
 =?us-ascii?Q?Dr9dr59PWqLTdi+kqksRoK2v?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eacf9f02-01a9-462f-a08f-08d8f6f79698
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:11.8564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1sKF/weX+fFdT0wvwbz4nZvNpfxiA8RVUOTIvtb6fCR5mFugiYE73mXKHvgQUlffutoJKBuaOiRrh3AWE5sMokeHfq2EzzenZR0Uk6m8XYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-GUID: RsNrYpJS3J_EnyBR9eOulMacEdyqtHNG
X-Proofpoint-ORIG-GUID: RsNrYpJS3J_EnyBR9eOulMacEdyqtHNG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has us use the blk/scsi-ml mq cmd pre-allocator and blk tags for scsi
tasks. We now do not need the back/frwd locks for scsi task allocation.
We still need it for mgmt tasks, but that will be fixed in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxgbi/libcxgbi.c |   2 +-
 drivers/scsi/libiscsi.c       | 151 +++++++++++++++++++---------------
 include/scsi/libiscsi.h       |  46 +++++++----
 3 files changed, 116 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 919451810018..cdaa67fd8c2e 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -366,7 +366,7 @@ int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
 		chba->ndev = cdev->ports[i];
 		chba->shost = shost;
 
-		shost->can_queue = sht->can_queue - ISCSI_MGMT_CMDS_MAX;
+		shost->can_queue = sht->can_queue - ISCSI_INFLIGHT_MGMT_MAX;
 
 		log_debug(1 << CXGBI_DBG_DEV,
 			"cdev 0x%p, p#%d %s: chba 0x%p.\n",
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index cadbe1d19344..46ab51e5a87b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -463,9 +463,9 @@ static void iscsi_free_task(struct iscsi_task *task)
 	if (conn->login_task == task)
 		return;
 
-	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
-
-	if (sc) {
+	if (!sc) {
+		kfifo_in(&session->mgmt_pool.queue, (void *)&task, sizeof(void *));
+	} else {
 		/* SCSI eh reuses commands to verify us */
 		sc->SCp.ptr = NULL;
 		/*
@@ -716,8 +716,8 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-		if (!kfifo_out(&session->cmdpool.queue,
-				 (void*)&task, sizeof(void*)))
+		if (!kfifo_out(&session->mgmt_pool.queue, (void *)&task,
+			       sizeof(void *)))
 			return NULL;
 	}
 	/*
@@ -1118,7 +1118,7 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
 {
 	struct iscsi_session *session = conn->session;
-	int i;
+	uint32_t i;
 
 	if (itt == RESERVED_ITT)
 		return NULL;
@@ -1127,10 +1127,17 @@ struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
 		session->tt->parse_pdu_itt(conn, itt, &i, NULL);
 	else
 		i = get_itt(itt);
-	if (i >= session->cmds_max)
-		return NULL;
 
-	return session->cmds[i];
+	if (i & ISCSI_TASK_TYPE_MGMT) {
+		i &= ~ISCSI_TASK_TYPE_MGMT;
+
+		if (i >= ISCSI_MGMT_CMDS_MAX)
+			return NULL;
+
+		return session->mgmt_cmds[i];
+	} else {
+		return iscsi_itt_to_ctask(conn, itt);
+	}
 }
 EXPORT_SYMBOL_GPL(iscsi_itt_to_task);
 
@@ -1348,12 +1355,6 @@ int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 		return ISCSI_ERR_BAD_ITT;
 	}
 
-	if (i >= session->cmds_max) {
-		iscsi_conn_printk(KERN_ERR, conn,
-				  "received invalid itt index %u (max cmds "
-				   "%u.\n", i, session->cmds_max);
-		return ISCSI_ERR_BAD_ITT;
-	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_verify_itt);
@@ -1369,19 +1370,30 @@ EXPORT_SYMBOL_GPL(iscsi_verify_itt);
  */
 struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
 {
+	struct iscsi_session *session = conn->session;
 	struct iscsi_task *task;
+	struct scsi_cmnd *sc;
+	int tag;
 
 	if (iscsi_verify_itt(conn, itt))
 		return NULL;
 
-	task = iscsi_itt_to_task(conn, itt);
-	if (!task || !task->sc)
+	if (session->tt->parse_pdu_itt)
+		session->tt->parse_pdu_itt(conn, itt, &tag, NULL);
+	else
+		tag = get_itt(itt);
+	sc = scsi_host_find_tag(session->host, tag);
+	if (!sc)
 		return NULL;
 
-	if (task->sc->SCp.phase != conn->session->age) {
+	task = scsi_cmd_priv(sc);
+	if (!task->sc)
+		return NULL;
+
+	if (task->sc->SCp.phase != session->age) {
 		iscsi_session_printk(KERN_ERR, conn->session,
 				  "task's session age %d, expected %d\n",
-				  task->sc->SCp.phase, conn->session->age);
+				  task->sc->SCp.phase, session->age);
 		return NULL;
 	}
 
@@ -1679,19 +1691,16 @@ static void iscsi_xmitworker(struct work_struct *work)
 	} while (rc >= 0 || rc == -EAGAIN);
 }
 
-static inline struct iscsi_task *iscsi_alloc_task(struct iscsi_conn *conn,
-						  struct scsi_cmnd *sc)
+static struct iscsi_task *iscsi_init_scsi_task(struct iscsi_conn *conn,
+					       struct scsi_cmnd *sc)
 {
-	struct iscsi_task *task;
-
-	if (!kfifo_out(&conn->session->cmdpool.queue,
-			 (void *) &task, sizeof(void *)))
-		return NULL;
+	struct iscsi_task *task = scsi_cmd_priv(sc);
 
 	sc->SCp.phase = conn->session->age;
 	sc->SCp.ptr = (char *) task;
 
 	refcount_set(&task->refcount, 1);
+	task->itt = blk_mq_unique_tag(sc->request);
 	task->state = ISCSI_TASK_PENDING;
 	task->conn = conn;
 	task->sc = sc;
@@ -1805,12 +1814,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto reject;
 	}
 
-	task = iscsi_alloc_task(conn, sc);
-	if (!task) {
-		spin_unlock_bh(&session->frwd_lock);
-		reason = FAILURE_OOM;
-		goto reject;
-	}
+	task = iscsi_init_scsi_task(conn, sc);
 
 	if (!ihost->workq) {
 		reason = iscsi_prep_scsi_cmd_pdu(task);
@@ -2745,9 +2749,8 @@ int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
 	if (!total_cmds)
 		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
 	/*
-	 * The iscsi layer needs some tasks for nop handling and tmfs,
-	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
-	 * + 1 command for scsi IO.
+	 * The iscsi layer needs some tasks for nop handling and tmfs, so the
+	 * cmds_max must at least be greater than ISCSI_INFLIGHT_MGMT_MAX
 	 */
 	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
 		printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of two that is at least %d.\n",
@@ -2773,7 +2776,7 @@ int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
 		       requested_cmds_max, total_cmds);
 	}
 
-	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
+	scsi_cmds = total_cmds - ISCSI_INFLIGHT_MGMT_MAX;
 	if (shost->can_queue && scsi_cmds > shost->can_queue) {
 		total_cmds = shost->can_queue;
 
@@ -2799,9 +2802,25 @@ int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev)
 	if (!shost->can_queue)
 		shost->can_queue = ISCSI_DEF_XMIT_CMDS_MAX;
 
+	if (shost->can_queue > ISCSI_TOTAL_CMDS_MAX) {
+		shost_printk(KERN_INFO, shost,
+			     "Requested scsi host can_queue was %u. Limiting to %u\n",
+			     shost->can_queue, ISCSI_TOTAL_CMDS_MAX);
+		shost->can_queue = ISCSI_TOTAL_CMDS_MAX;
+	}
+
 	if (!shost->cmd_per_lun)
 		shost->cmd_per_lun = ISCSI_DEF_CMD_PER_LUN;
 
+	shost->host_tagset = 1;
+	/*
+	 * We currently do not support nr_hw_queues >  1 because the iscsi spec
+	 * itt is limited to 32 bits, and for drivers that support it, libiscsi
+	 * uses some of the bits past BLK_MQ_UNIQUE_TAG_BITS for target sanity
+	 * checks. Plus other drivers/fw can limit the itt to less than 16 bits.
+	 */
+	BUG_ON(shost->nr_hw_queues > 1);
+
 	return scsi_add_host(shost, pdev);
 }
 EXPORT_SYMBOL_GPL(iscsi_host_add);
@@ -2914,9 +2933,11 @@ static void iscsi_host_dec_session_cnt(struct Scsi_Host *shost)
 	scsi_host_put(shost);
 }
 
-static void iscsi_init_task(struct iscsi_task *task)
+static void iscsi_init_task(struct iscsi_task *task, int dd_task_size)
 {
 	task->dd_data = &task[1];
+	if (dd_task_size > 0)
+		memset(task->dd_data, 0, dd_task_size);
 	task->itt = ISCSI_RESERVED_TAG;
 	task->state = ISCSI_TASK_FREE;
 	INIT_LIST_HEAD(&task->running);
@@ -2926,7 +2947,7 @@ int iscsi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 {
 	struct iscsi_task *task = scsi_cmd_priv(sc);
 
-	iscsi_init_task(task);
+	iscsi_init_task(task, shost->hostt->cmd_size - sizeof(*task));
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_init_cmd_priv);
@@ -2945,8 +2966,8 @@ EXPORT_SYMBOL_GPL(iscsi_init_cmd_priv);
  * a session per scsi host.
  *
  * Callers should set cmds_max to the largest total numer (mgmt + scsi) of
- * tasks they support. The iscsi layer reserves ISCSI_MGMT_CMDS_MAX tasks
- * for nop handling and login/logout requests.
+ * tasks they support. The iscsi layer reserves ISCSI_INFLIGHT_MGMT_MAX
+ * tasks for nop handling and login/logout requests.
  */
 struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
@@ -2985,7 +3006,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->lu_reset_timeout = 15;
 	session->abort_timeout = 10;
 	session->scsi_cmds_max = scsi_cmds;
-	session->cmds_max = scsi_cmds + ISCSI_MGMT_CMDS_MAX;
+	session->cmds_max = scsi_cmds + ISCSI_INFLIGHT_MGMT_MAX;
 	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
 	session->exp_cmdsn = initial_cmdsn + 1;
 	session->max_cmdsn = initial_cmdsn + 1;
@@ -2997,21 +3018,18 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	spin_lock_init(&session->frwd_lock);
 	spin_lock_init(&session->back_lock);
 
-	/* initialize SCSI PDU commands pool */
-	if (iscsi_pool_init(&session->cmdpool, session->cmds_max,
-			    (void***)&session->cmds,
+	/* initialize mgmt task pool */
+	if (iscsi_pool_init(&session->mgmt_pool, ISCSI_MGMT_CMDS_MAX,
+			    (void ***)&session->mgmt_cmds,
 			    cmd_task_size + sizeof(struct iscsi_task)))
-		goto cmdpool_alloc_fail;
+		goto mgmt_pool_alloc_fail;
 
 	/* pre-format cmds pool with ITT */
-	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
-		struct iscsi_task *task = session->cmds[cmd_i];
+	for (cmd_i = 0; cmd_i < ISCSI_MGMT_CMDS_MAX; cmd_i++) {
+		struct iscsi_task *task = session->mgmt_cmds[cmd_i];
 
-		if (cmd_task_size)
-			task->dd_data = &task[1];
-		task->itt = cmd_i;
-		task->state = ISCSI_TASK_FREE;
-		INIT_LIST_HEAD(&task->running);
+		iscsi_init_task(task, cmd_task_size);
+		task->itt = cmd_i | ISCSI_TASK_TYPE_MGMT;
 
 		if (iscsit->alloc_task_priv) {
 			if (iscsit->alloc_task_priv(session, task))
@@ -3032,11 +3050,11 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 free_task_priv:
 	for (cmd_i--; cmd_i >= 0; cmd_i--) {
 		if (iscsit->free_task_priv)
-			iscsit->free_task_priv(session, session->cmds[cmd_i]);
+			iscsit->free_task_priv(session, session->mgmt_cmds[cmd_i]);
 	}
 
-	iscsi_pool_free(&session->cmdpool);
-cmdpool_alloc_fail:
+	iscsi_pool_free(&session->mgmt_pool);
+mgmt_pool_alloc_fail:
 	iscsi_free_session(cls_session);
 dec_session_count:
 	iscsi_host_dec_session_cnt(shost);
@@ -3055,13 +3073,13 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	struct Scsi_Host *shost = session->host;
 	int cmd_i;
 
-	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
+	for (cmd_i = 0; cmd_i < ISCSI_MGMT_CMDS_MAX; cmd_i++) {
 		if (session->tt->free_task_priv)
 			session->tt->free_task_priv(session,
-						    session->cmds[cmd_i]);
+						    session->mgmt_cmds[cmd_i]);
 	}
 
-	iscsi_pool_free(&session->cmdpool);
+	iscsi_pool_free(&session->mgmt_pool);
 
 	iscsi_remove_session(cls_session);
 
@@ -3125,9 +3143,8 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 
 	/* allocate login_task used for the login/text sequences */
 	spin_lock_bh(&session->frwd_lock);
-	if (!kfifo_out(&session->cmdpool.queue,
-                         (void*)&conn->login_task,
-			 sizeof(void*))) {
+	if (!kfifo_out(&session->mgmt_pool.queue, (void *)&conn->login_task,
+		       sizeof(void *))) {
 		spin_unlock_bh(&session->frwd_lock);
 		goto login_task_alloc_fail;
 	}
@@ -3145,8 +3162,8 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	return cls_conn;
 
 login_task_data_alloc_fail:
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
-		    sizeof(void*));
+	kfifo_in(&session->mgmt_pool.queue, (void *)&conn->login_task,
+		 sizeof(void *));
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
@@ -3189,8 +3206,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	kfree(conn->local_ipaddr);
 	/* regular RX path uses back_lock */
 	spin_lock_bh(&session->back_lock);
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
-		    sizeof(void*));
+	kfifo_in(&session->mgmt_pool.queue, (void *)&conn->login_task,
+		 sizeof(void *));
 	spin_unlock_bh(&session->back_lock);
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
@@ -3275,8 +3292,8 @@ fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
 	struct iscsi_task *task;
 	int i, state;
 
-	for (i = 0; i < conn->session->cmds_max; i++) {
-		task = conn->session->cmds[i];
+	for (i = 0; i < ISCSI_MGMT_CMDS_MAX; i++) {
+		task = conn->session->mgmt_cmds[i];
 		if (task->sc)
 			continue;
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 8e01beba62f1..7a78f8c5d670 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -35,8 +35,18 @@ struct iscsi_session;
 struct iscsi_nopin;
 struct device;
 
-#define ISCSI_DEF_XMIT_CMDS_MAX	128	/* must be power of 2 */
-#define ISCSI_MGMT_CMDS_MAX	15
+#define ISCSI_DEF_XMIT_CMDS_MAX		128
+/*
+ * Max number of mgmt cmds we will preallocate and add to our mgmt fifo.
+ * This must be a pow of 2 due to the kfifo use.
+ */
+#define ISCSI_MGMT_CMDS_MAX		16
+/*
+ * For userspace compat we must allow at least 16 total cmds, so we have the
+ * the mgmt allocation limit above and this limit is the number of mgmt cmds
+ * that can be running.
+ */
+#define ISCSI_INFLIGHT_MGMT_MAX		15
 
 #define ISCSI_DEF_CMD_PER_LUN	32
 
@@ -55,10 +65,19 @@ enum {
 /* Connection suspend "bit" */
 #define ISCSI_SUSPEND_BIT		1
 
-#define ISCSI_ITT_MASK			0x1fff
-#define ISCSI_TOTAL_CMDS_MAX		4096
-/* this must be a power of two greater than ISCSI_MGMT_CMDS_MAX */
-#define ISCSI_TOTAL_CMDS_MIN		16
+/*
+ * Note:
+ * - bnx2i needs the tag to be <= 0x3fff to fit in its fw req, and has a
+ *   different itt space for scsi and mgmt cmds.
+ * - cxgbi assumes the tag will be at most 0x7fff.
+ * - iser needs the total cmds to be a pow of 2.
+ * - qedi, qla4xxx and be2iscsi ignore or pass through the libiscsi itt.
+ */
+#define ISCSI_ITT_MASK			0x3fff
+#define ISCSI_TOTAL_CMDS_MAX		8192
+/* bit 14 is set for MGMT tasks and cleared for scsi cmds */
+#define ISCSI_TASK_TYPE_MGMT		0x2000
+#define ISCSI_TOTAL_CMDS_MIN		(ISCSI_INFLIGHT_MGMT_MAX + 1)
 #define ISCSI_AGE_SHIFT			28
 #define ISCSI_AGE_MASK			0xf
 
@@ -331,13 +350,10 @@ struct iscsi_session {
 	spinlock_t		frwd_lock;	/* protects queued_cmdsn,  *
 						 * cmdsn, suspend_bit,     *
 						 * leadconn, _stage,       *
-						 * tmf_state and session   *
-						 * resources:              *
-						 * - cmdpool kfifo_out ,   *
-						 * - mgmtpool, queues	   */
+						 * tmf_state and mgmt      *
+						 * queues                  */
 	spinlock_t		back_lock;	/* protects cmdsn_exp      *
-						 * cmdsn_max,              *
-						 * cmdpool kfifo_in        */
+						 * cmdsn_max, mgmt queues  */
 	/*
 	 * frwd_lock must be held when transitioning states, but not needed
 	 * if just checking the state in the scsi-ml or iscsi callouts.
@@ -346,9 +362,9 @@ struct iscsi_session {
 	int			age;		/* counts session re-opens */
 
 	int			scsi_cmds_max; 	/* max scsi commands */
-	int			cmds_max;	/* size of cmds array */
-	struct iscsi_task	**cmds;		/* Original Cmds arr */
-	struct iscsi_pool	cmdpool;	/* PDU's pool */
+	int			cmds_max;	/* Total number of tasks */
+	struct iscsi_task	**mgmt_cmds;
+	struct iscsi_pool	mgmt_pool;	/* mgmt task pool */
 	void			*dd_data;	/* LLD private data */
 };
 
-- 
2.25.1

