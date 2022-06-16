Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472E7C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379153AbiFPWqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379159AbiFPWqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:46:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2F462137
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:46:21 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GIhsOq032716;
        Thu, 16 Jun 2022 22:46:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Xco2W5MJOgBU8hzidLJwRHIPwv+I6e5HUYyqcUlR5Y4=;
 b=jT4Ew1TyQZEhOnuoYX9E+cBg9uhN2NLlsmRsaalkYBCe2PrvoFYrHbjcFzYZBrTrkbV/
 vH8uGADbPB5R9yCeA3XcNS8KGCqTAmu5A2Yi3YygfIPvmjAU85lLNrvwHzN8YGbxy4Pl
 mtlSI8q3I78AFL+eAD+k0Bb9O2Ec+2/MIWSgVVTaiP2oGfZIsnKRKX7UPeH2VO1cdv8N
 0aT0BjVXqXeYjsjj1U1DqPf5oKtB0aCsvrP9DVqDxQ2NG6LcGDVyeb3kXE9SZ2d0AdF7
 GiN75vu9PvG07HyCNOIdaMaqay2qgoFCMnXbS+pJPg5qpzhi0LMkY0XtAwKzEQS3mBef kQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2vmp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMaPd5035724;
        Thu, 16 Jun 2022 22:46:14 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr27dmqw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FweuNskDkhOK7raEmWjspiljmewJX4M8pMkOd9yW50mR/avIsbyeE+ffOrNg0P2Q3pGFEmkMcDlmZZ30rJykp5z40FV5R1dPaCrG89ToDDul/KHZj3PBchXNra3r1uVU3V5NM3AcupaxopiogHN8VfJ1p99z2LkYhHQPBrhaRQJL7+evVYtQX0m/QSBETrt+Rj720xjQA1M80uer64TxED68Ni7GdbsZ8K2SbvJaMJfpH5P7Pi9jESAscwEZSuS7N7Qx2o700aitevRUFNCHO614R8kLXsRcHh5ILWfS7jmFF3t/XUXV8XfJOVK19edGdf2Wwzm7gZI/MMOil1OW2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xco2W5MJOgBU8hzidLJwRHIPwv+I6e5HUYyqcUlR5Y4=;
 b=al/WfHOxYA6Jt9/N8gU4ahL9vHY+uRnD6VWHI9Z1+AxKXQ3dQj9y4tUaN6eR5fuBcODief2H/Bw9NIYRd5RSC1mT08o/eIM9Jh4Bhf/Cdi3EMm2k3UHiDQUtksVZlf7s4CO8Nd6gEw4T/RUsbJqa8XuuQv4/aIQPy5Wd4Z59H7+pW8jM/XyhftJhn21ejpvgcWbq5H8QFTrRobxG1ZrL7nh0rEl74+mHBP9KYSkgZHvlnOJ3QO2MKQpkebFekgycSnjMXHuI6q7ncVmiJgXV2PSx5OhjZYog7OIV54buwAA67TjyHQs6KBDnt/YSgbMZo3hCCk9f7E8pviu1dAQJyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xco2W5MJOgBU8hzidLJwRHIPwv+I6e5HUYyqcUlR5Y4=;
 b=WZBBnhVL77RzhnX3a3zutX4Cm+y7ZINF2S1edshMGXW+V4tY14SGuyW5QwIXTaRZMJu0d0kdnLTj/WcTShgdNN1JAJGoo8XHyD1L5fS2lWPwZayQ6LBKNUN3l344agfLuTLwbWnsj0V6AXYivZygE3aofVVN0fGPJZVMsd6dMek=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5617.namprd10.prod.outlook.com (2603:10b6:303:148::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Thu, 16 Jun
 2022 22:46:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:46:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 9/9] scsi: libiscsi: Improve conn_send_pdu API
Date:   Thu, 16 Jun 2022 17:45:57 -0500
Message-Id: <20220616224557.115234-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616224557.115234-1-michael.christie@oracle.com>
References: <20220616224557.115234-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28732989-deb9-4715-1a93-08da4fea02ad
X-MS-TrafficTypeDiagnostic: CO6PR10MB5617:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5617A31CDBD7C784CE6CAF34F1AC9@CO6PR10MB5617.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yWNgs8mHvBvU3SdXoi9mLNDePNNiMC2jSb69kfss7NgNied6DI9n9u8lJ3bQOu+mLYPYlifBUY3eaKIsaG866Tg2Rg49A0GqVHQnJjNc5O4XCXlWTGFoFqKB9iWrNYuYxF6t4TUwXHQOzADWj308I7CWCSCvFpiunQigFkSGhGBsE8B9lEq5/7pRFiXX9kZ0MB2/jj4NUlFVX3omsRydOXk5ISHx34DB+aaBSc9AAkeAZnqUdOLz+WiFjpmf0HHccn3TIM+OsU51juJiWcE0betbJb4vwaUnbsn+gDJFNl/2Df1v17edE0YuibAqwUtcAqPJGH4T4OTqES/MDO57ioYJ8/pqJRVPOdrKrEWwvB6O6Wm6x6Q4fOlza+lhhMsMJnVQAIWsQRBzok9pAFJ6CdndRq9+DkhiI1jQgLo2W4cgYfo9P15mON0kXoqucwi5aWhNGv6yRM4laX+4DVTQgWFk/3JRagCPtcSzDJyqhAKN8LOGI54Q5yF68kSCaTbkjTVm3dDum4baTKtyxWEEeHKwZ5uO4YfExsyTLDdC2CcPX5nNGdpxB3WMAUUCbDI8yxEnN+e8dQUXSCUoAmsHJrG0mpVGGuLR4TZ5Xr5BtY+blrqP2uR2R9AeioJMZqLPaNOJK76cp6MNqP0c4KlngCNpL7huQpjE1MdrB3DaRmYIKigRP3sEs1R2IT7DbBE1GhHEFpPOkBVN15zH5JVwrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(83380400001)(2616005)(52116002)(6666004)(66476007)(5660300002)(38350700002)(38100700002)(36756003)(4326008)(6506007)(8936002)(508600001)(6486002)(66556008)(8676002)(6512007)(26005)(186003)(107886003)(1076003)(66946007)(316002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H9F9mTy+ne+64WgXQpXxAXr15oDOCitdzZ4D21cZbQ9dqa0KvcUrnwqXbzPA?=
 =?us-ascii?Q?UVM1gRgCBhFuA/Ux09HMZnj/0tiRIppCv8zp0pAznjryyicNpKbev/06u4zQ?=
 =?us-ascii?Q?8kCaefILZByZjMegMB87zd6nWWuKur2fiFhZfhKI5YEXj4d0sSkMgQXcZaR5?=
 =?us-ascii?Q?HF7gqOtJaER5U15x+JcZc3//as4I+LzubkhL8Cpm5BA6RO3PVnx2zhUEvIJl?=
 =?us-ascii?Q?N89T69KKZhNotuT4YFgKtuz6hhUBzVj9wp13Q2aI97hYCiczzQSwI5xnJdPL?=
 =?us-ascii?Q?sd9zYSEhV7RCemF4mX/gra7VKkuAvCFms1NZVnkmLGLox9x9a+u+J7GfqE0X?=
 =?us-ascii?Q?Q7UcfjbEzFP+VsGq08XpaquxchTC6mHzKN2djg8GAMs2mhqvpskufafUxVLY?=
 =?us-ascii?Q?gTwvBfjOffnvg/FnvgWqeq4O/OjTZ+l8exulwFqBMv4QQOfsHmFdXBHii1pT?=
 =?us-ascii?Q?wbn3GqPLSD9XBp9poULHYT4i2CQa00K+iVDhtr0QJk+CKdgX49B3bWWz8rvR?=
 =?us-ascii?Q?e69LmMNZ2Brj9xW/c02yZqfAmXlxsVA27P6aFW+Mks7C/VhYfWl0/C5lCgdF?=
 =?us-ascii?Q?xm61ydfUqY7XX/XRd4PDyTEvJpwiS9GAlIUD5basiX1wVjRCEk9yuQJPdiMt?=
 =?us-ascii?Q?ZF6lfgYZHKPPPu+gNeAKQUg7qzroHAy6AHK9qw+/73Swb4WAxblo5fIzQJac?=
 =?us-ascii?Q?HjxIisqNxIKWUOaZwcoYLTJNBOizqGDqfd8cwkmcjkqPOwlKjE266xHiWv2O?=
 =?us-ascii?Q?0NgqZw5BrgLab+fGgsW89g9dkoy5zw/WsgqEK4+t4yFgp9QYuRxRvT2nsaa6?=
 =?us-ascii?Q?Ef/dcb9IIB3Xg0g5NPkHjUSH/0T9MV5cyb5A4S2KHA5d8tfGynLXdlzw3xxd?=
 =?us-ascii?Q?sAytUPdYn0/HWZ6zW+O8Tgkf+77KOreg6xBCfhrmo5dqK6ycWYnPbpXuMtKC?=
 =?us-ascii?Q?Hfs3legoXuoWhAOcMK/T6qZhWA68nPfjZSKI5ekxHJTLGgI0nW1UuDm+bjm3?=
 =?us-ascii?Q?7j8VjwqGRekLQ+h8IeGiWQC+5r8/f2TsjsIlTm/Zp3+G/wJ94fspLjZ1ljsG?=
 =?us-ascii?Q?b3nCT1rQoVYcwvncnl0IQUECBdUwIf/xCCGFmILEEMaaAXy1V/+EB4yN3tov?=
 =?us-ascii?Q?hERdy679AIDfLghVAza5DLsrV8cyNLDCsIzxTmF6RpL0YlFZlsc1osGKTSdK?=
 =?us-ascii?Q?+a4UQP1VtzMWLQYvaYYo/CU3IFcwJkzuyp1P/jD5sZhRb+cnxO73Li6AhQAZ?=
 =?us-ascii?Q?D2n7JQ3uivAgCWsO5iQUJqiaV0QXuhD2fhptOIt7ws+tJYiQAjpcGWOTJDb8?=
 =?us-ascii?Q?/hGFIVG7dgNtNSeAIUAw/iXOxjv7bWoI+rRHzSV3W+wP2iTx3tHu3DsH52el?=
 =?us-ascii?Q?4vGTHC69JncNOPDf6b1TL19fbCW59PmR2JE55SbnlY6vF8QauabKnL90RDqk?=
 =?us-ascii?Q?Ym7V79rbbMsWsa0Doy5nraDy76t/+EycuGFrZuw3/EeWpL03XfY+EjnG8T2x?=
 =?us-ascii?Q?CVza5ev+e9QWYEdix7T7gAwTIH+D587LBkwiwtOs3ZZ/CoshWjmrRgsG/jM1?=
 =?us-ascii?Q?74od/yY84i0Svqtgech81ITI4uT9g0L1oJNE3WGBoAWVylQVrrDWNFKTQUVt?=
 =?us-ascii?Q?x8fTjNkJdxi7N2OO73RoMaTjdeUglGTmFx6GG5sSnceUjgTu1iKOGGflcMVv?=
 =?us-ascii?Q?M2Q/ubuFumqJR/K4MTeRpDyMVYIeKuqM5skqEwgWy6vbYWtf1PXuPx7UELEM?=
 =?us-ascii?Q?BnRz1bJpji4DiaKNvrWuFbFZjIw98W8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28732989-deb9-4715-1a93-08da4fea02ad
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:46:11.4686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CC5HhuV5uKsDT/ja6RgCvXWu1erMdK0XuUp1z+QbC/DHln+pkBXMeUOzgN4MurTlrid0EifXmE95UOjr9pqGzy7sL6XxI7O55KOdZDL8Flw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5617
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160091
X-Proofpoint-GUID: 6wLV9jW7H-ETRm4u60Vfm2TqqNwqI7pP
X-Proofpoint-ORIG-GUID: 6wLV9jW7H-ETRm4u60Vfm2TqqNwqI7pP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The conn_send_pdu API is evil in that it returns a pointer to an
iscsi_task, but that task might have been freed already so you can't touch
it. This patch splits the task allocation and transmission, so functions
like iscsi_send_nopout() can access the task before its sent and do
whatever bookkeeping is needed before it is sent.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 85 ++++++++++++++++++++++++++++++-----------
 include/scsi/libiscsi.h |  3 --
 2 files changed, 62 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index da292761995f..b06ebbfe5de3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -695,12 +695,18 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	return 0;
 }
 
+/**
+ * iscsi_alloc_mgmt_task - allocate and setup a mgmt task.
+ * @conn: iscsi conn that the task will be sent on.
+ * @hdr: iscsi pdu that will be sent.
+ * @data: buffer for data segment if needed.
+ * @data_size: length of data in bytes.
+ */
 static struct iscsi_task *
-__iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+iscsi_alloc_mgmt_task(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		      char *data, uint32_t data_size)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_host *ihost = shost_priv(session->host);
 	uint8_t opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 	struct iscsi_task *task;
 	itt_t itt;
@@ -781,28 +787,57 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 						   task->conn->session->age);
 	}
 
-	if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
-		WRITE_ONCE(conn->ping_task, task);
+	return task;
+
+free_task:
+	iscsi_put_task(task);
+	return NULL;
+}
+
+/**
+ * iscsi_send_mgmt_task - Send task created with iscsi_alloc_mgmt_task.
+ * @task: iscsi task to send.
+ *
+ * On failure this returns a non-zero error code, and the driver must free
+ * the task with iscsi_put_task;
+ */
+static int iscsi_send_mgmt_task(struct iscsi_task *task)
+{
+	struct iscsi_conn *conn = task->conn;
+	struct iscsi_session *session = conn->session;
+	struct iscsi_host *ihost = shost_priv(conn->session->host);
+	int rc = 0;
 
 	if (!ihost->workq) {
-		if (iscsi_prep_mgmt_task(conn, task))
-			goto free_task;
+		rc = iscsi_prep_mgmt_task(conn, task);
+		if (rc)
+			return rc;
 
-		if (session->tt->xmit_task(task))
-			goto free_task;
+		rc = session->tt->xmit_task(task);
+		if (rc)
+			return rc;
 	} else {
 		list_add_tail(&task->running, &conn->mgmtqueue);
 		iscsi_conn_queue_xmit(conn);
 	}
 
-	return task;
+	return 0;
+}
 
-free_task:
-	/* regular RX path uses back_lock */
-	spin_lock(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock(&session->back_lock);
-	return NULL;
+static int __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+				 char *data, uint32_t data_size)
+{
+	struct iscsi_task *task;
+	int rc;
+
+	task = iscsi_alloc_mgmt_task(conn, hdr, data, data_size);
+	if (!task)
+		return -ENOMEM;
+
+	rc = iscsi_send_mgmt_task(task);
+	if (rc)
+		iscsi_put_task(task);
+	return rc;
 }
 
 int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
@@ -813,7 +848,7 @@ int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
 	int err = 0;
 
 	spin_lock_bh(&session->frwd_lock);
-	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
+	if (__iscsi_conn_send_pdu(conn, hdr, data, data_size))
 		err = -EPERM;
 	spin_unlock_bh(&session->frwd_lock);
 	return err;
@@ -986,7 +1021,6 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	if (!rhdr) {
 		if (READ_ONCE(conn->ping_task))
 			return -EINVAL;
-		WRITE_ONCE(conn->ping_task, INVALID_SCSI_TASK);
 	}
 
 	memset(&hdr, 0, sizeof(struct iscsi_nopout));
@@ -1000,10 +1034,18 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	} else
 		hdr.ttt = RESERVED_ITT;
 
-	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
-	if (!task) {
+	task = iscsi_alloc_mgmt_task(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
+	if (!task)
+		return -ENOMEM;
+
+	if (!rhdr)
+		WRITE_ONCE(conn->ping_task, task);
+
+	if (iscsi_send_mgmt_task(task)) {
 		if (!rhdr)
 			WRITE_ONCE(conn->ping_task, NULL);
+		iscsi_put_task(task);
+
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
 		return -EIO;
 	} else if (!rhdr) {
@@ -1874,11 +1916,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	__must_hold(&session->frwd_lock)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_task *task;
 
-	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
-				      NULL, 0);
-	if (!task) {
+	if (__iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0)) {
 		spin_unlock_bh(&session->frwd_lock);
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send TMF.\n");
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index cf7dfd61860f..b41b95655210 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -135,9 +135,6 @@ struct iscsi_task {
 	void			*dd_data;	/* driver/transport data */
 };
 
-/* invalid scsi_task pointer */
-#define	INVALID_SCSI_TASK	(struct iscsi_task *)-1l
-
 static inline int iscsi_task_has_unsol_data(struct iscsi_task *task)
 {
 	return task->unsol_r2t.data_length > task->unsol_r2t.sent;
-- 
2.25.1

