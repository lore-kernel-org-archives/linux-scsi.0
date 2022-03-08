Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C7EC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240337AbiCHA3M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiCHA3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:29:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43CC2612F
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:28:10 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227LG1LV002100;
        Tue, 8 Mar 2022 00:28:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Log4L3cI5wHMa7yoYDFDa8MG7Kmyb9ISM/Q3uyn51sg=;
 b=MEMeXjnqkhddsYTb5BVuPr07ungQnvS+Joei1Uo5JBOWPMvy3McfFY7It2JzI+Uogfhu
 bk46nmXx1vabz6BUmT6MY90Ng+bLPUzEQmdTRIYOGLUPB5dAKn2OIIvKjwyOvE3ODN3+
 Yo/sL3Xsf2cqY8XDBJrFoNYX8L5EkBETSD2s6YBLmaeC1eneRVZZq1yCpzVnzMElxNqR
 K2nssb7s/ljjgaOQC0qkhSnA9dNhmX5W06kD7vHXx5TyfHRX26KS8+48K8mCOYKUdb0V
 Cn8DBjDUnHwgEBSdvw8YoqRbDZ9YcWWEjz0g8G7c14ReSDCgef5FLhELUpK6ZdhMe3UK NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsdgkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280AJ9C134548;
        Tue, 8 Mar 2022 00:28:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3030.oracle.com with ESMTP id 3ekvyu3hrq-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORcHoyk+hJcSWC2nbqYFlRw8XozEDODs/8qZyAd1SUJdYDbhl9TJDTl5b4yHIGsqwylHrVpp6Lk3j/AeLMWmA/Ms7f6b0ToROEDYV9nhhnOwhTQElXg1ipquTfGbl1v5Wg4KON1R5HLfdkCGu78Sr4+dpEd+AXK0cySo5CqV6PSmDYDsjKRfU8R2Ww3sjqHK3kCg5IWNWH1J1icekeIWzK0DBvInFvazq6gBSEKDDwXFXEmob/Zi3+9x23Fe6JkH8tHs9FbHCKIoFH9QNQOdhIQYNj7mWnXB4rRA9y/QDU0bXwWEw9n3NECKhF02IO0+mgy6XYORGI/g7aASN4ajqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Log4L3cI5wHMa7yoYDFDa8MG7Kmyb9ISM/Q3uyn51sg=;
 b=bAj8YkRx9OyKt8lYW6aG/vy+IL2UhLcPLFh5H6hwTcfy7A0//j1ERsEgiUCL8p4CE0l5p9qD6NEsuVv6d5RaqGlThCAuzooiTPXxl17zAKprd4JaVr7D5cJR+3sFHEPAEAtvt81ntVtj8tWLFtlXrvYkf189mFfcwGtJpqg/q+Nhz861s9FtoI5jBToRkKwCl2S6r2E3RpqgdcpHo4nByyIqaC0LBy4aFOmXL7H+4xar7OI/tMZM3oK2dGDYvVeW4EYKQ519hbUsYAHki4/yXC/YMZNatHjDtkuillXa0y8XZjBIaSb33Ut49h8BBfPlxJBoXlLaq9sfACLSewALUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Log4L3cI5wHMa7yoYDFDa8MG7Kmyb9ISM/Q3uyn51sg=;
 b=ShXrsQB1pOVlE+W/4XGuEoP1TljSuiz+kgYJe8GwZTR/T+Kvn/CN5SG8R8TP34lfBUzWMgYTQh9H6o+REYBrasndqm8jlZXRwujBmZdPeshw5UtD2SWhs71KETuh2dn55BgQMt+3CP/ud1CsNKBn+LyYJO7LC9e/OWfvX7q31XY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4361.namprd10.prod.outlook.com (2603:10b6:5:211::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Tue, 8 Mar 2022 00:27:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:27:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/12] scsi: iscsi: Run recv path from workqueue
Date:   Mon,  7 Mar 2022 18:27:40 -0600
Message-Id: <20220308002747.122682-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308002747.122682-1-michael.christie@oracle.com>
References: <20220308002747.122682-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e93234d4-d15c-4f5e-f690-08da009a7eec
X-MS-TrafficTypeDiagnostic: DM6PR10MB4361:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4361E5040E199DDE0082D171F1099@DM6PR10MB4361.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S4rDL+pC/dUrYPU9Dp4Bf+oOVO5LSpBZgjfBYtxSfIcyuipwcxliQ8Aga6YXps+eKQXZPHiBBPA3sIn0ummWSu+luk4o55up1jssXePFzG+k2y45tB1iQJxoYsHosmr+r0qbqQXeWXuB2zCoPETAcC+wbkbSKQluqwT0QkAPgY0XIU826/RK2aHMWOxIHPiJZUAQhn3T9xTXEWNi9maWHvSuoKwVVh/NXoSm67OqEldWj70CWRHbjIkUhkooYRT/V8SZg1y0t2InbOl9CDjs9OtWOSzYo337BNRM9OHytKpNEcFuyDJc8porkKa9r1C4U1DNseaauHO5S5i4SEKwnc6TFxN2Mifut17nC8XHGeAIDAIcJqz3hYgp0Kif8Mut1786MdfwocJ8Hr3b6nrnWXTlP8AFXxofXZjGxliBChE2kYDnHNhsu+h+OkiVKxV33u68g2tLZhDwGPLKOCvgstWuhPB0cfoM3iNp//PuceMi76dT2zVVt5O0uhiGAOTzXAkf0Cw937WyR+lbkWG+83UvPSVtxJoBUeCFp9zu3wCi6KkVKDg3GVmDk+cP8wm3bSfH8eB70rCmasN/pcRdQgtk0z8kdgQnzU7SBFCuyQxvFdnTOL4YU/CuONjWIDThMUyWnaiBfiiGI9xWKgoJ8lYsA1TXMIJPpUoKK/zJaShFDBGDyZUBOTfBCoVKNGVbYO7Eyso/LY5ZzWZ3pvQ91g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(508600001)(6666004)(107886003)(1076003)(186003)(52116002)(86362001)(6486002)(6512007)(83380400001)(6506007)(2616005)(8936002)(5660300002)(38100700002)(66946007)(8676002)(4326008)(66556008)(66476007)(36756003)(2906002)(38350700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Ht11u6O7EupATrT3y6of6NBcnkyoyuTJYvsOyETST2ycZlCKAm4kYQizJIB?=
 =?us-ascii?Q?0mOpz2BP3e2aYu7uAA1Q4K5jHBTtgja7jieZcfMWr1sx1qy2izXRzJ9VDMcW?=
 =?us-ascii?Q?LOauM5BKVV53i0uT/rCNoIHgPULrbVk5icRLpplH7EgOEVj+8+TTP3MxC34g?=
 =?us-ascii?Q?Ui9QILUdyEqqEotnIf7N8IXniBqwtLR3fHJAElavFA7zYqKXaap0uirFnKfX?=
 =?us-ascii?Q?S0Lr0RCbP+onJCEJ8wniM5crXceg49VFPX3izNEGOauuNyYg3jDwRbTNc9LL?=
 =?us-ascii?Q?u2+9DlQXyIerR5Oknvwm6sWYi/x3oAdADKFzepkp8WO8VwcK+0Cs02ush1jX?=
 =?us-ascii?Q?xB6CZD/6SGhsvTSiIEMa7wQ5sLJWz4PHYBGNSOwoGXUD7iZ8Vnd6G1yw2Qr3?=
 =?us-ascii?Q?b0Jt1A0ZYSTu3CUqyi+pqM/1YERUitYE/WC66BG9+u7o1JFknLV6Gx3OnG1e?=
 =?us-ascii?Q?9V/hRu1hJ45UF/flrXNMhluADYN9YFn09q+XJ5jwQIG25lHpMufvaH0/8hLq?=
 =?us-ascii?Q?6YHPZjeTChkQTlNYveNmtRy2VnY4HEe8wvqLbjUdYHWicqFQ7Bn9FXIgjnsU?=
 =?us-ascii?Q?s3t6bTfiLzfbiiVS2KzqRUl2eFRnS/UUobolQ7yGQjH2PkVOZZ3+Iaq4YJ6k?=
 =?us-ascii?Q?QZWNJcCnd0RIqIy5zbmSwi1j/N0Sd18LmQDefpbUJk8QmDCDjm9jZfEXrGCU?=
 =?us-ascii?Q?lVsd9c3XCtLoxaxGTV8UJXAZdWBNcNZJsdSrf/4jrN34S+fwMoc2KNvCV0Kr?=
 =?us-ascii?Q?czKbllF2QLhjGFmPjkfGcz8YN6l5UMO49vBuYRMsy/mJAJG26ASa8VqHtUgS?=
 =?us-ascii?Q?LKG7dDdQ406ESre7ypzBHieuttYWzZj70GbglavyNHMgPCwm12dkPRDUEekr?=
 =?us-ascii?Q?+xUr2Ya6CVoNAcM2a3ycUwcTIRTroyVqhr6qlFjBgNFbPIX1wLAkU0HgEiaZ?=
 =?us-ascii?Q?/OMPyt0HGbhbA5+GmY8m4lEPuh3UwxmRnBLt62m1IM16GGQUhuHkHq2iBIzu?=
 =?us-ascii?Q?MeO0Zxq9q3j0d4+mGlVXA8Ncj5HqNXf5I91Of0wQjJmQ6+w4z29yIGF12+JC?=
 =?us-ascii?Q?S7ITwFxgXl+paEOVqyAdmc02CXVjaA8XV/1cGAmf7BGJ7KsdbF+rSUF35iT/?=
 =?us-ascii?Q?o5MgPQBnO7uXrqTNgD8O2mWa7LEqjj36U3XHvZuFztrk4c42z+dwPP+JIwpL?=
 =?us-ascii?Q?Iux81Vz6/LsZsIDK5Bs0HNKPloIUXCRzq4hMuLvTdRRu/jhXOsM6Z3UUavxC?=
 =?us-ascii?Q?Nuez/kk0n0ybC+XH13YI6XRMB6gj3oydwpKQt6Tvjp+bIT0YAa3DW5LlamfJ?=
 =?us-ascii?Q?C7i76e4N/c89ck8g5x+98+bGUrpYd9mSgvmkVg9sHdmZFlX/fe6/656SvY7A?=
 =?us-ascii?Q?X/Liewf/W0yw7jYBcYgsd/xh7KGPGPz/GvazSfSDbeTUojwD8tOD59vXYSkF?=
 =?us-ascii?Q?DPJVve8nV8s2P3mXJ9XDlzdy0DM5zAnzpkwYHBS+MsGtNsqL6HpWYX4Gyo7C?=
 =?us-ascii?Q?ajzIYNs8Th7gc9vjYSorCEwTv9xgK9LWj+2vMrPNrwWLlzt0HPsHySZaO+gY?=
 =?us-ascii?Q?mdNfAJc6miqlBJ+chJ98FkjxgmUgpD2xuS/rqWa+v77AjoqpJ7q+/94cW94N?=
 =?us-ascii?Q?Ol/X6tAQaxYPwKXlq+/00YqNp/U/qJSt7Nu46QFI+oyGg5ChdPDKfByEBl0v?=
 =?us-ascii?Q?/LMtHw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e93234d4-d15c-4f5e-f690-08da009a7eec
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:27:58.1862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jdub1T+xo7zDuzBARQeLEK8XFHxaAjCu/Ak7fXeLtW5qPDOgz9ST9FQ1xugL+zWRdlNgP9HcequtWVWaT+jjy+bQcTN+705txRrSHhAOjyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4361
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070121
X-Proofpoint-GUID: FNBE27SbEsMoaSBq1kJgkj5ibUVxl4pd
X-Proofpoint-ORIG-GUID: FNBE27SbEsMoaSBq1kJgkj5ibUVxl4pd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't always want to run the recv path from the network softirq
because when we have to have multiple sessions sharing the same CPUs some
sessions can eat up the napi softirq budget and affect other sessions or
users. This patch allows us to queue the recv handling to the iscsi
workqueue so we can have the scheduler/wq code try to balance the work and
CPU use across all sessions's  worker threads.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 62 +++++++++++++++++++++++++++++++---------
 drivers/scsi/iscsi_tcp.h |  2 ++
 2 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index f274a86d2ec0..261599938fc9 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -52,6 +52,10 @@ static struct iscsi_transport iscsi_sw_tcp_transport;
 static unsigned int iscsi_max_lun = ~0;
 module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 
+static bool iscsi_use_recv_wq;
+module_param_named(use_recv_wq, iscsi_use_recv_wq, bool, 0644);
+MODULE_PARM_DESC(use_recv_wq, "Set to true to read iSCSI data/headers from the iscsi_q workqueue. The default is false which will perform reads from the network softirq context.");
+
 static int iscsi_sw_tcp_dbg;
 module_param_named(debug_iscsi_tcp, iscsi_sw_tcp_dbg, int,
 		   S_IRUGO | S_IWUSR);
@@ -122,20 +126,13 @@ static inline int iscsi_sw_sk_state_check(struct sock *sk)
 	return 0;
 }
 
-static void iscsi_sw_tcp_data_ready(struct sock *sk)
+static void iscsi_sw_tcp_recv_data(struct iscsi_conn *conn)
 {
-	struct iscsi_conn *conn;
-	struct iscsi_tcp_conn *tcp_conn;
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
+	struct sock *sk = tcp_sw_conn->sock->sk;
 	read_descriptor_t rd_desc;
 
-	read_lock_bh(&sk->sk_callback_lock);
-	conn = sk->sk_user_data;
-	if (!conn) {
-		read_unlock_bh(&sk->sk_callback_lock);
-		return;
-	}
-	tcp_conn = conn->dd_data;
-
 	/*
 	 * Use rd_desc to pass 'conn' to iscsi_tcp_recv.
 	 * We set count to 1 because we want the network layer to
@@ -144,13 +141,48 @@ static void iscsi_sw_tcp_data_ready(struct sock *sk)
 	 */
 	rd_desc.arg.data = conn;
 	rd_desc.count = 1;
-	tcp_read_sock(sk, &rd_desc, iscsi_sw_tcp_recv);
 
-	iscsi_sw_sk_state_check(sk);
+	tcp_read_sock(sk, &rd_desc, iscsi_sw_tcp_recv);
 
 	/* If we had to (atomically) map a highmem page,
 	 * unmap it now. */
 	iscsi_tcp_segment_unmap(&tcp_conn->in.segment);
+
+	iscsi_sw_sk_state_check(sk);
+}
+
+static void iscsi_sw_tcp_recv_data_work(struct work_struct *work)
+{
+	struct iscsi_conn *conn = container_of(work, struct iscsi_conn,
+					       recvwork);
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
+	struct sock *sk = tcp_sw_conn->sock->sk;
+
+	lock_sock(sk);
+	iscsi_sw_tcp_recv_data(conn);
+	release_sock(sk);
+}
+
+static void iscsi_sw_tcp_data_ready(struct sock *sk)
+{
+	struct iscsi_sw_tcp_conn *tcp_sw_conn;
+	struct iscsi_tcp_conn *tcp_conn;
+	struct iscsi_conn *conn;
+
+	read_lock_bh(&sk->sk_callback_lock);
+	conn = sk->sk_user_data;
+	if (!conn) {
+		read_unlock_bh(&sk->sk_callback_lock);
+		return;
+	}
+	tcp_conn = conn->dd_data;
+	tcp_sw_conn = tcp_conn->dd_data;
+
+	if (tcp_sw_conn->queue_recv)
+		iscsi_conn_queue_recv(conn);
+	else
+		iscsi_sw_tcp_recv_data(conn);
 	read_unlock_bh(&sk->sk_callback_lock);
 }
 
@@ -557,6 +589,8 @@ iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
 	conn = cls_conn->dd_data;
 	tcp_conn = conn->dd_data;
 	tcp_sw_conn = tcp_conn->dd_data;
+	INIT_WORK(&conn->recvwork, iscsi_sw_tcp_recv_data_work);
+	tcp_sw_conn->queue_recv = iscsi_use_recv_wq;
 
 	tfm = crypto_alloc_ahash("crc32c", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm))
@@ -606,6 +640,8 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 	 */
 	kernel_sock_shutdown(sock, SHUT_RDWR);
 
+	iscsi_suspend_rx(conn);
+
 	sock_hold(sock->sk);
 	iscsi_sw_tcp_conn_restore_callbacks(conn);
 	sock_put(sock->sk);
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 791453195099..850a018aefb9 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -28,6 +28,8 @@ struct iscsi_sw_tcp_send {
 
 struct iscsi_sw_tcp_conn {
 	struct socket		*sock;
+	struct work_struct	recvwork;
+	bool			queue_recv;
 
 	struct iscsi_sw_tcp_send out;
 	/* old values for socket callbacks */
-- 
2.25.1

