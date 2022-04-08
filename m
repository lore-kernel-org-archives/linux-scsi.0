Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E56DDC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 00:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbiDHAQB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiDHAPo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 20:15:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA28108BC0
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 17:13:42 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237JfC2N006378;
        Fri, 8 Apr 2022 00:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=JrvoyWrh80SL1vhsbW87cv8RLeiaK7QZCpEjyGWQQX0=;
 b=koGMi79QjmOiRAvSnNN4LxvLH9iGdbZxgs3bT/oclvoTRHNEp2PZ61Z2LXJUQjJxWcr6
 KzgOcaPxnwsyVuPDN/eaBwM7cVeNzQvl5XODZgMaltczuXDbj1hkilzR+R7NfC9YzNPl
 GECA+pKs1iuCmZczjAiVnFV6xFoYNVYjQFWiKFIcrc3jQr4lLQEkRXreFS1nupuTqE+8
 A/S7cKGHHhkSESUHSKT3vTgGbHHkfLcDeRS3wY0gwQX4UlnLeY4cGZejQsjltGJ7A9on
 yFD3+lF21VnoxiFBZBLGD8WUwkRTysiPyx8Z0V9nDglzsDvRsmjFbnccAK+TKq6QiKJr OQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31nh89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237NFHE4013838;
        Fri, 8 Apr 2022 00:13:28 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97tu11q5-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/zLUIUK0hwS4cYAtx69CtfTCPCx6DRqM1yGacS+jIlr3yyB1iPd8Oe5+8etWqVa/0vFehS6FJjb8j18m7HvxEZmgqsVU4mQ+pFPqFHwvT4f5TqHEk1ZJ+D6AMq8Rt2XDHpEQmzi3VqjbDaMlzFi6av2MW3+qzQ8vswutNX6G6mfuvgq/wgCdwlc4BXwekhj9qhzlTTpksDCNIuy6JbJaRaPmcgm9kAFR8oRSCSrIaP49BHRn0sfHBHxPDUDohWkCzGb0J5Rfbff2mQ+24y80L60UJK9no/bzedBBJXQyu6QB3NX6/cLkSDkACMPSmMaDReeohumWuIxzufxVwI84g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrvoyWrh80SL1vhsbW87cv8RLeiaK7QZCpEjyGWQQX0=;
 b=nlz70Nms0oSYETDiZAArikYaQq6pM+8tMkNz4O994OXhN0xfs/y4c/ZObnRXpFYdDJ4FysthyeBFeUf3QZbsO12JFPMRCaj4y255pi7nZDVclRjrju3RTRVS7HeBzl3OPNNQBIzIiPifE9lXUuCHYKs+T+v0KgyOjXp7i19TEhl8U1ie0TltTFm87KQxirF/dBGBaCrKbPtWL7K4o5gObcG8woCxl3Q+UvxG/98GwFdmc95uSsavhbwYHk3D+9hUXg8gsSaw+PrSoW58u833/iWoMexMqfkfzQptv7sJXTFXguVjJ85AUgInGXmP01xlhqhW71+cj5GBuHpW7IVM0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JrvoyWrh80SL1vhsbW87cv8RLeiaK7QZCpEjyGWQQX0=;
 b=gGi+V7APRXgZ2Nspk1ZAh1mTcYv0C7K2wdpWwrdICWlqP5alL+4XlY3aU4nMaYkXLdZUtqsbvNq+8Ldn7us+2pjervXmbHF5ti2qimx5a/XRzeQJUG/RjXmWsomvNZl9H0aUyLQZp6tp+nCve2up3x3RdyLQGG8SfqpRfGxQP1I=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5550.namprd10.prod.outlook.com (2603:10b6:a03:3d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Fri, 8 Apr 2022 00:13:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 00:13:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     skashyap@marvell.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/10] scsi: iscsi: Fix conn cleanup and stop race during iscsid restart
Date:   Thu,  7 Apr 2022 19:13:09 -0500
Message-Id: <20220408001314.5014-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408001314.5014-1-michael.christie@oracle.com>
References: <20220408001314.5014-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4919646a-e390-4783-a88b-08da18f49945
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5550:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5550436BBD16907FE0A75A38F1E99@SJ0PR10MB5550.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VbeN6fWusIwSJVdauJHb7MeavW3iK886OKptK0YUzobDbWymxzS3x22wkYBqdIFyT1gyXlTWqVte1DvxV1VaaKm5dgnC3199/guJWYac/500dpRs6LwEP6ImNMt7oreVwHo67tRELgQbi6szyFK2iVIHarwJeFp1sHri354qEd8eG0GmGfqExyxd+rfiP/Pxjmvj4ybO4edlfSP3O/HTCXMSes6mJmFvNQe4mI6vTZEU7WySd6S1NsRkM2ZDvTt+wXZ8aL7/E/LiHKbtmBi9gS+ZiB6yiHN9hmdwqfmSGCNGRoUgkW2VDVGDTUZU7Vgf3aCtlVCDkqgH3woi3XQ8fPMYGglhZ6x+oH0wATeRqPsOR3rS8irIZG6cZDNfwMtDjs5CBcLCraloL609Qt5tInj0WL9umkedQaqwkAZqK5ck/lUFSVsQpp8ssHFfprXzioyVTrV8Bnjm+3ACgBBOcrGtLgGgcfRyPuY7Oe7skxBWaC1Jjj3TXmvsWR/stUnLz3q14Ni5Ja9yne+I08d/bmuyn5Dh+jKBnO6d3QfI/BzpnZ+MVf/kt3xCt9TPoMZ2TorJjsQdtQ0PGyotw1PSKUjcoQknsPsd/x3JRBLCUQu/pO3pwvBMz4c7MCP9WUU5glFfFL7ByhXfRzMr5fZsKoZpOL39z9aXr1oSwPETeq+Q7zLj3hat/5SaX9JSGxG4CNhy4Pe7Xp3xATFCVFJAbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(186003)(83380400001)(6486002)(86362001)(316002)(2616005)(6512007)(5660300002)(6666004)(107886003)(36756003)(38350700002)(508600001)(38100700002)(4326008)(52116002)(66556008)(2906002)(66946007)(26005)(66476007)(1076003)(8676002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QJQdargWKHkfmYXLaEKH+A+WZwgfyH+STEU2d6qojtOLnK83etXqfCKhCN0c?=
 =?us-ascii?Q?sVtrQg01uZhXw6K/5oTIvzWlJqcAIP6SH/FxnU97ZAWzQuMdPWrHNgu5hzII?=
 =?us-ascii?Q?u2Ww+rhDd52aOrRl5rq1YuH27aq2+YDKsvCiWUEXDN0zcXlOSN6iahVMoXJj?=
 =?us-ascii?Q?AP+laatUkBfE3oSXeijoB0NgaYdsOO6SYcQ2ecuzfojJchfP0ViQ9pSuh7m6?=
 =?us-ascii?Q?n9Rnh4tGe5LHQDqG9hbL3yG6LD6LyRC0wvK79+g+8R9KrKeVk7FOoxv5I292?=
 =?us-ascii?Q?Gvpf0S+9TK9BvE2i5rjD5dEVhjG1jPI88bOgNc4jn01PXiTNeHIBb8No628a?=
 =?us-ascii?Q?BbX8kcaaUgdrjQ28tIU2j98j20iI9s5fVqn1+uE4rdTNRs+1sEVCCHcbtYZt?=
 =?us-ascii?Q?NojD/DueSRpQgr4prLmyMkEII2CGYfuSjoQ+7Ao2tKRN7HDlI5hw4Pl0K4us?=
 =?us-ascii?Q?lGcVhzxRx4/vwC43sZctJp3W/IgEj5RDAEAwaD0foaAh42LR6vZihmDVk5iE?=
 =?us-ascii?Q?RAiyUW4PO+v3PgT8NNVbRiYEoq5TN8PpphCiLGEVXS2c+TjFOj7amZqZ8k/I?=
 =?us-ascii?Q?I/Rv7pYe8hH/YkOFQVtv2A9BqaJ35evdP7h+xG8lYdE65nwvTmsb8hkCYF6j?=
 =?us-ascii?Q?0V8kDwfqVHUMiDQenxZVYn8cDaIeplyp31taWvIUBMCcGPUjaIIOP6i3uxrO?=
 =?us-ascii?Q?y3FuW9MqWTrN5l2QVTPxQLZuP6G+vPgr4AnE1oodS/qGNOIXo9oaP97iF50v?=
 =?us-ascii?Q?+kjwtyLEsAsGaouQlRjWtmal2OX3M+vfY/N6dgU+gkB9BNmvhPX7FKhwJtjX?=
 =?us-ascii?Q?Ybkg3itbv0+iAVW5ZcBgx+XBq0ZabqD/LmwKviChomW386QtvHrsiohe9d3J?=
 =?us-ascii?Q?YQq6XLf6+Aef9Aeqv9ALTT0a0zQOeOifLyfGaVMtjV/FRNqus15edBvXe7L8?=
 =?us-ascii?Q?m6EuiiDC3MzaT1P9OZvnmqpccKNqWsOojDnKN1bAbxr2ejQMcxYWao1qHpnb?=
 =?us-ascii?Q?XfxDnk1fcEbAuxJODzFGoNp/O1RnuWinuw9b5eLg0JOhhO3yPhZn/dSeSavq?=
 =?us-ascii?Q?8qPAF68fhGV+BENOMqLSObZZ4UFIcg3XqrGmsgFpiFjSViC36UWIiKty9TiN?=
 =?us-ascii?Q?fU6E3corqr+tWU6f5V1DFybR2OH40ZoTmAyidtIsh9kAKo/duKk6XMgQ7jLe?=
 =?us-ascii?Q?6WZhlPIYEbP1BwTa+f9FKJftsa/K4ewIBKS0uZlVwgwVYSIPq/LAlXu+N0ob?=
 =?us-ascii?Q?vt/AhzDcrJ9jk3NiaPKpuFuOVHPJXmjktQHDk2xiiOwaQiAkNvocilUwxMkP?=
 =?us-ascii?Q?weaLddNysSH6HRBG3aBVq3fmoSQCBpPDpY1I3M0LZ6/oreBWMdpYib958cbA?=
 =?us-ascii?Q?q+wiVCkZ3AQ+CqOzL8hj4f/5V3m/oa8avj+FlnZ6rfsq1uGhGAP+JWv+AFAD?=
 =?us-ascii?Q?8X/kd2iViWrwImu8NfTL2dVuMkg+ghCRhrPTMLV81o8y/6P6j/PHIOiJijcM?=
 =?us-ascii?Q?d6SCYaV0S/VuTAbGLbb5tuTh81X23EKH/B+6U8sOguACWEUsXwZ6l6EoKXFw?=
 =?us-ascii?Q?VBz1Twh+G7C+HIQem8Ce2QKjc0cBsIjoFnCh9ljvI933LpZ/Panbg96HTxdK?=
 =?us-ascii?Q?TfLDCvW3kVaSAKPwnSsF0caVAV7t4JQq1cJ8ukvIwY+UDUiVexQoeygwK+zn?=
 =?us-ascii?Q?TOQ74lkXrTi1FJtdqJgyhmg23gib/lE08fauaDlTw3IWArNzAghT5zGkWA7a?=
 =?us-ascii?Q?GFc3taeFhAXtee7Hr1PZQbFJ38Cmp+M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4919646a-e390-4783-a88b-08da18f49945
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 00:13:25.0631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mOUOnnWatgjBt4v0phR9W0RaLpcwzkqA0vFEzv/mkJfAsDKufvTAmo2qmj2Sa4fKtjvU4NRZjTPcKrrnzmV7I06ICSdYxzzsPO4MzDAnyI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5550
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070064
X-Proofpoint-GUID: n3uG5Giw-qmXBkzFTspq6B0Zcjp-inGP
X-Proofpoint-ORIG-GUID: n3uG5Giw-qmXBkzFTspq6B0Zcjp-inGP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If iscsid is doing a stop_conn at the same time the kernel is starting
error recovery we can hit a race that allows the cleanup work to run on
a valid connection. In the race, iscsi_if_stop_conn sees the cleanup bit
set, but it calls flush_work on the clean_work before
iscsi_conn_error_event has queued it. The flush then returns before the
queueing and so the cleanup_work can run later and disconnect/stop a conn
while it's in a connected state.

The patch:

Commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
kernel space")

added the late stop_conn call bug originally, and the patch:

Commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")

attempted to fix it but only fixed the normal EH case and left the above
race for the iscsid restart case. For the normal EH case we don't hit the
race because we only signal userspace to start recovery after we have done
the queueing, so the flush will always catch the queued work or see it
completed.

For iscsid restart cases like boot, we can hit the race because iscsid
will call down to the kernel before the kernel has signaled any error, so
both code paths can be running at the same time. This adds a lock around
the setting of the cleanup bit and queueing so they happen together.

Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
kernel space")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 17 +++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f200da049f3b..63a4f0c022fd 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2240,9 +2240,12 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
 					 bool is_active)
 {
 	/* Check if this was a conn error and the kernel took ownership */
+	spin_lock_irq(&conn->lock);
 	if (!test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		spin_unlock_irq(&conn->lock);
 		iscsi_ep_disconnect(conn, is_active);
 	} else {
+		spin_unlock_irq(&conn->lock);
 		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
 		mutex_unlock(&conn->ep_mutex);
 
@@ -2289,9 +2292,12 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 		/*
 		 * Figure out if it was the kernel or userspace initiating this.
 		 */
+		spin_lock_irq(&conn->lock);
 		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+			spin_unlock_irq(&conn->lock);
 			iscsi_stop_conn(conn, flag);
 		} else {
+			spin_unlock_irq(&conn->lock);
 			ISCSI_DBG_TRANS_CONN(conn,
 					     "flush kernel conn cleanup.\n");
 			flush_work(&conn->cleanup_work);
@@ -2300,7 +2306,9 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 		 * Only clear for recovery to avoid extra cleanup runs during
 		 * termination.
 		 */
+		spin_lock_irq(&conn->lock);
 		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
+		spin_unlock_irq(&conn->lock);
 	}
 	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
 	return 0;
@@ -2321,7 +2329,9 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
 	 */
 	if (conn->state != ISCSI_CONN_BOUND && conn->state != ISCSI_CONN_UP) {
 		ISCSI_DBG_TRANS_CONN(conn, "Got error while conn is already failed. Ignoring.\n");
+		spin_lock_irq(&conn->lock);
 		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
+		spin_unlock_irq(&conn->lock);
 		mutex_unlock(&conn->ep_mutex);
 		return;
 	}
@@ -2376,6 +2386,7 @@ iscsi_alloc_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 		conn->dd_data = &conn[1];
 
 	mutex_init(&conn->ep_mutex);
+	spin_lock_init(&conn->lock);
 	INIT_LIST_HEAD(&conn->conn_list);
 	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
 	conn->transport = transport;
@@ -2578,9 +2589,12 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
 	int len = nlmsg_total_size(sizeof(*ev));
+	unsigned long flags;
 
+	spin_lock_irqsave(&conn->lock, flags);
 	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
 		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
+	spin_unlock_irqrestore(&conn->lock, flags);
 
 	priv = iscsi_if_transport_lookup(conn->transport);
 	if (!priv)
@@ -3723,11 +3737,14 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 		return -EINVAL;
 
 	mutex_lock(&conn->ep_mutex);
+	spin_lock_irq(&conn->lock);
 	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		spin_unlock_irq(&conn->lock);
 		mutex_unlock(&conn->ep_mutex);
 		ev->r.retcode = -ENOTCONN;
 		return 0;
 	}
+	spin_unlock_irq(&conn->lock);
 
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_BIND_CONN:
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index fdd486047404..9acb8422f680 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -211,6 +211,8 @@ struct iscsi_cls_conn {
 	struct mutex ep_mutex;
 	struct iscsi_endpoint *ep;
 
+	/* Used when accessing flags and queueing work. */
+	spinlock_t lock;
 	unsigned long flags;
 	struct work_struct cleanup_work;
 
-- 
2.25.1

