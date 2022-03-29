Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47AFDC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240421AbiC2SHO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbiC2SHH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:07:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6908B1AA5
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:05:21 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsG7u029601;
        Tue, 29 Mar 2022 18:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=eG31KzurFvdpgGHmmcbUVgjheVT2UqIuniqB6vPPeLw=;
 b=j+WpTBEg1ypNByp3zsrVzMrLE3aT/DoHMpj8oHRBUp94fUT+djhb8GoiPHUPJnVa+6JA
 XJ3pe1fdQUK3KsKxRXpRunRPpHbZT9kmytIZtwAxo+1ThwRpGsOaDVwjP86woGzPedNY
 8Xd4l94ILj7AG+Oq+t9ScQvF0ZuZv2BxZVF36iH9sn2ZYnwvz7/nMWjwi8fvXJeMWfL2
 7MTRKX9eUDLoJ9hfLKfg0KjoXGJSB1xJ6GgDfbdIjl5q4BGhIs5NPWtMmczUofYHQ3a2
 2n9f0lVmRPvnmOd9E4dxXi4I5SDKxA0mULohAJgSZ20sxE5aDGHCcA6RFO0AxdgdfOVw 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1se0fcuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THvFJE048570;
        Tue, 29 Mar 2022 18:03:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3f1v9fhge0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9feVWRvVuqYI2WeTkPyc/w+0VMSP3SPo8SQ27vvCA7JeBEmGoLuTKt3bkngC6/jDvfPrdDH10eolSeUMn+0IjgheNqPCviJyYFY+L2t5qnN7g+9OXwN/mKDml8zX9EDBlr728BzlnhaitFoOKyqbi05Sr7/7Y4H7xCSQ+n8jk6zsUvMsFPpPDNp5T1cmTWzA7GM2s7Kq2PqsRIKPhwxYRfcKX9/3Ggqx/8XDFj3M1RK4x0AW0FKTe3mBl/Bih/MF+I3eWi6z0wf65fNYHcIWeiA1JxiPWOGByIrkztCp41Md5JTESon84Vzy0FpzNf97EQdUMGc7MJyD9ppMRWUmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eG31KzurFvdpgGHmmcbUVgjheVT2UqIuniqB6vPPeLw=;
 b=XekMgrnTH5WvfdklAotjMNjhVgKzf+de4L/JDPFbSdO1FF0nk40bj+DDeRCH+rvgWz6GdHda+MJgcF1WPF1ELb3KewYyI3hUMT6UdDRZm57CJBNtOaDJQiQMx/DaII/BcJpxROwTgT7IEdjNi1+uWYLfuvJvp1fQfL1ixx6tTYtVIj9iVx0LXIPWt1LeJNLu1ZbwuoDoi0+f1W5S7tsclmxPg3l1wwg6GINtQJaGgKb8wjaanktvO6MtEG40jSvQZHWS1OkMQhlrMKLzL/mGw5suLHMiXz5U0bHtZKn1S3ppIdliaDKGfMI40Vmant0sA+fYQvlubBq6IJQC4I1lqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eG31KzurFvdpgGHmmcbUVgjheVT2UqIuniqB6vPPeLw=;
 b=XLluiY2DUq0EpVSovIkvFTVfHN1Rdi8wFyaHNmqK7+TLMsmZ6krkptC5AP2KBVIJyjuRTlXCqDv/wL4NLeLcSJcDw47FmYV2EsXglmrEsxpQEy63m3o+mEOIGySXOPN/n1sGI7GWm+8re/eTLRJgV84yvHa+jDXIaMsUXTXlQ7w=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 01/15] scsi: iscsi: Move iscsi_ep_disconnect
Date:   Tue, 29 Mar 2022 13:03:12 -0500
Message-Id: <20220329180326.5586-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef49574e-0d87-4549-5453-08da11ae7174
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3584266479F291293C8E2911F11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kPdPAd0tEMEiX8mrIghL+GXdswGUOIkyaXEXtbgGyuvaFenUiOLw5ORtDW5kAGjNULo78v5avZV8C7kh1Mbz5yhxGAdyiWxYGdQM9oVpBeZcRAnPvHYl6A1sXFGQdAEICZVEuTdkov0xLKQzUxDBu/2i9biSu3zQ/3R4yPDT3vPr5iHEgqR/f37FRMhhuU4JVljab8iEmPWhaQB5HdXrTQJSqcFox77zLviOtxSmDwtWHOWEjQdYVsAkPUAC5vd7HdMeKu2UdLnIJsMbG1PUNYds/AOqTHktM8fKCUcoqx4sUi+/idHQJFWn+nCNZHoJPbuZiRfHRRItVtZe9D4l74zmNn/2rX2WPM+7Ob45/3J+n62S47NIIvJrbydj0RHWB3ZLZ+0WG2TPpXoY0iBqFZ9/W9ZIAgNv1GO8CkWSJENshXpNFlaQgEk6udBDMgYUnbQBfdKigEn7urYUo7DCubV91rxNSX1Lt+THNn1iuO8hs/tpD2CEzPuSTwddeaAO0+7fzNP1L8GvtPxI5tjvEudmDAKkPDhOlTvkq+tRBdeY4h8tkjcsOeV14KNtUFmT/MDi5wrZ1k2gjckC7C9O4qzN2ieTA3B41FD+ZFn0VQRHcyyZkTZLuh72NrF4zD4P7QwCkrnjNl2RvIWpTL8Myl0kZTxaLpmDghGD6ExXiVQUmOuoFYvYc7pjwSC8YcHh4+3NYKiZ47uOeKIVV+mODg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(316002)(8936002)(8676002)(6512007)(66556008)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(107886003)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RvfvDoP01HmNbNY/FYtSvaGHBw8LUTj+6IegbAms0seC1BM/XthFF9LUbbib?=
 =?us-ascii?Q?gBq8yOTRStHDXkkxEazNLfWmuRfwkFDtEdP5d6FA3Ce32/qwaQaZfrmlw7VE?=
 =?us-ascii?Q?flnTSZg+vp6ZhAMTEkLRBOo2g5PDSVieuDZClIlfqYEVLmMNctir7oizM+WO?=
 =?us-ascii?Q?CjRkPPB4PUKC928JxxDc5zbHGQcinhfDqJgXW/r8NUzEdDywaGV6DO4lkH9y?=
 =?us-ascii?Q?50fIO6QvNc2svexZby5nvsFFdDomJeiD5OaxoOyQGsWKGbDTeTUwYwIMn6H3?=
 =?us-ascii?Q?/eWhO5Ll5Sw9KuEIFLnAyr4lsB9S9UCTAvneVwcOwBH96ioIHjN2dJhuCITP?=
 =?us-ascii?Q?WeGUpsZHTLB/w/2dO9SrXpNb+Z75Pqdk6QEi6HvITmriOeWr4mCwMDOWYq3s?=
 =?us-ascii?Q?FE4I3cTw2p6P+vD+I14bvhxO3QNxqww1K5ZZD+3zvmzimuUP5odNXa25ICdS?=
 =?us-ascii?Q?HqiRAzK8rWU1g2Zg2NL9QFDJuZW3kTlci478abCEjIYP0r5Qs5fDs1gfmFDX?=
 =?us-ascii?Q?s7gmcUOcNVAeF7P9Aon/jUL6Fhp7eYykeDNCZQQdy+qA1EhtvuPwVcdT/gHI?=
 =?us-ascii?Q?FMbUdcqlya8GkNZFeO4rn3OwHBszHDnybAdCHOUnzYsEsXgmg90e06GwLxhB?=
 =?us-ascii?Q?exu11KX+KrbC8mAUauajc93P0JUjqXdAFSG4nZiYJ9aijn9H9VqvDpzUChuJ?=
 =?us-ascii?Q?OUf3XnBMC/m9R0hmYcjrIdtHZW99MyPVCVXA/+0q/4jVVpg0IJsaFuxF63r9?=
 =?us-ascii?Q?Lf5ezvUMBSINhMQa5yaCw0R/fXmX7stkI3T25kxmGQATzs7SnqbqLjRkHln6?=
 =?us-ascii?Q?2+quM0h3rwZS5mtRD+6Fj4LjVlgtjpyNwuRLk8hvGe5subTC0XwSxJmqSl6B?=
 =?us-ascii?Q?5H6M7Jpgji1Eqyxb1K6lgHz9nS0zGcW4IavmkFK+OUTU0oaRfONMholu75fV?=
 =?us-ascii?Q?JUkAchcuCcu7TzKf0hv4JOGschtDo0hLx0pgfT0U8PKG7DyEM6nLCY+y41x8?=
 =?us-ascii?Q?EoaUkjJKlm7KNzYFAjI64I0K0WK//smXu6ys4PYH+nVw2B6tUzqnfPBVBA0V?=
 =?us-ascii?Q?SuJMj1JF0UhID2cZ0sXQSR99Rs98si3kMeZY/qU/6M2oVAXtRBffKtagbY2Y?=
 =?us-ascii?Q?aL/aljqvnOa7t6wrZoccUWwPJebV1GMAy/yGz8dwZLouzRbbwzv723INhQvK?=
 =?us-ascii?Q?aWx5aMF6X2eMcdYwMN12tyMJ/s2RibjrdQ/6Lj0Q8cRnTtpddnuF/kz6hdAy?=
 =?us-ascii?Q?nEVOLY9uV8Rkp2K3eMpeXYBpMGGN84yUcMw59DRV0zpo5TXNcfsIbB8s9opg?=
 =?us-ascii?Q?kfdd1kgKcpT9LEtPiXCmsV7cdayOXFt+bLvD+yDH6fz/WlAfyqL0S4TeH7/B?=
 =?us-ascii?Q?iApycn/dxJGnkYPsN87h8dLRf4lqVretJU8L6uIpgay0aqnKIhYoe+OQUEW1?=
 =?us-ascii?Q?Xt113+ZhmM/pCOktklkJVaNnP/s1YToFqnakqIjyWEX99BaWJNe+pPnUcEaV?=
 =?us-ascii?Q?J93ZrXukOh7U8E6yaxNf4EVhyAHXz2DZcYLxGxVOizhUCT122+9Vms71Q+LG?=
 =?us-ascii?Q?AiyIAtDFv1CKgOtQ0Vr+UypzwhpDjd7hnfLKC7DlJynp1CL2Lu73IkXFBYd4?=
 =?us-ascii?Q?uQ/bQ89TnZm0B9hRmyApwv/b2Cvski/Hwo1HKu936e8EbST/zES72opJtTsR?=
 =?us-ascii?Q?UWNLWJ5odkqYf3jnnrbHrcHCJtA95u0Lez7vRulKLVVCXYIXAtbZC8dZthMy?=
 =?us-ascii?Q?v5VMeSK42IZF8x4aKQ6aD5gqBPmzwSM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef49574e-0d87-4549-5453-08da11ae7174
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:35.3183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvuU2Q23fcrd0QXkVEK3Uogbjync0f+mfIp2BCGcBONhvnmRh6EXpgk2VK++vwq4yEN4ZFGGl0EljDXoeZG+L7IfzbZjtqB46aD9jfmeyQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-ORIG-GUID: Vs0jX2-lmXXngU29BGhsl_PMt64raKQX
X-Proofpoint-GUID: Vs0jX2-lmXXngU29BGhsl_PMt64raKQX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch moves iscsi_ep_disconnect so it can be called earlier in the
next patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 38 ++++++++++++++---------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 27951ea05dd4..4e10457e3ab9 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2217,6 +2217,25 @@ static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn done.\n");
 }
 
+static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
+{
+	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
+	struct iscsi_endpoint *ep;
+
+	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
+	conn->state = ISCSI_CONN_FAILED;
+
+	if (!conn->ep || !session->transport->ep_disconnect)
+		return;
+
+	ep = conn->ep;
+	conn->ep = NULL;
+
+	session->transport->unbind_conn(conn, is_active);
+	session->transport->ep_disconnect(ep);
+	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
+}
+
 static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 			      struct iscsi_uevent *ev)
 {
@@ -2257,25 +2276,6 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 	return 0;
 }
 
-static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
-{
-	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
-	struct iscsi_endpoint *ep;
-
-	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
-	conn->state = ISCSI_CONN_FAILED;
-
-	if (!conn->ep || !session->transport->ep_disconnect)
-		return;
-
-	ep = conn->ep;
-	conn->ep = NULL;
-
-	session->transport->unbind_conn(conn, is_active);
-	session->transport->ep_disconnect(ep);
-	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
-}
-
 static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
 {
 	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
-- 
2.25.1

