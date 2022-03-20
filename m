Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D099C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244510AbiCTAqA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244487AbiCTApn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 20:45:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B62A241A0D
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 17:44:22 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22JEMfp9000642;
        Sun, 20 Mar 2022 00:44:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=qoz0WTZo0L6VOmeBwUesT20UpbkpbtYLtoMnuf/71PM=;
 b=ElEBDE4ljhlcy3kIYR3vYcryEhTFiGVrjFr9j2H54u7/gHcigGSMyAZzZLvKFIeCe7pC
 Z6iOKq/1LIU5zC/0qWcEm0izOfi+5T6eLVxv45KwHjVnJngY2j5WphkSa3NFsD315ot+
 JdbsUVIcI+FjZn55LN4HBw0O/AiyB8uAdliZBFoFPk5JS8ApkaQ04BvJnclFtAmrnE47
 +XiXiN6NZjj5+EfpSixlxMJYmB4oERaGj+nQRBuNzFVjxTqmRslRdIKPLRmLn4vF9PQT
 aRSA0Cmt6X5zatqhuWUO1ZYD/ZRm7rRTMJJzGJRRXUNjVoF+N+WDefg2aJp2qDKS8xpM jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew72a8vrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K0ffak137063;
        Sun, 20 Mar 2022 00:44:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3ew8mg6mq1-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRmi9Jz8to4ch8VgDfoJmyjpICqjxr54769k+GgGGGDnpcCBxD8UTEnIqat2HDimz1jQjK918rS7JeTOyFqK2+n9Pa2ncaLOICNj4sot1cBxlnK1zX7xse8u6nM1AtHdI4nIbPtYMQrbMsWcC48xsjVqTvnPCAblyO5uuTT0WoFHPJNM9hxnc/tFQc60cd3ae6RIywm2TY4cmtu4pO84Jsd+S12uvhjlAZ+eW39WblAOOKLsmG/gmiRVuA68r3NozKBmR6TXGLFkO8CaNXcMgo7OZm1hjV8spFqGKGfMNpQC+LQSCUGQmy/wpPNHlufm1GZQ1Fm9I3sykNafi8e2GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qoz0WTZo0L6VOmeBwUesT20UpbkpbtYLtoMnuf/71PM=;
 b=TQXSWFchIOAdzqL0gQ1UXqW8Nwym45z0baF2+OtyHp7apqiGtFGl6NHqpTjJ7ciwkLVasOQk9t0rjWgk4jKRzc6eW7Mucp4142iogZOQYKKbu1R2D2CL+8RMZuzXLUvV0jIxzTEVxFAG+eDOnK8TpEsBCYV+jRduG8/cY71xWU2eCgcZ5lv69agN2RiPjeI6RZKr8kZRh3U4N114MChs9fezUlGrLGoAkZeyXS/V529pbmDTwvedm3BGw7VJ7qh1SfJcz8sKucb8F9srHrZfvlKWFpAHgrtxhon2BZgBtp8k32ado5rZI7kwr0xOTjgVKyry2sCvV0XnUSo4Ao9ImA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qoz0WTZo0L6VOmeBwUesT20UpbkpbtYLtoMnuf/71PM=;
 b=xUxCpo6D7ekiTc50bWzcf7RpDTOFZ01U2m51ud9AHjKIuNhLrskK5KwR1uHvqOIpd5bmtFwkL2HQ4EEwhvS8yETXpJkJaoe0kEQ0sEx789Es6fYjMNhGcGNodQ1IEcAv3z1uaHIyrqC+jE0BY0SX8sbtiUAA0wTSZbs//fHOkPs=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3992.namprd10.prod.outlook.com (2603:10b6:610:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 00:44:14 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f%11]) with mapi id 15.20.5081.022; Sun, 20 Mar
 2022 00:44:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 05/12] scsi: iscsi: Run recv path from workqueue
Date:   Sat, 19 Mar 2022 19:43:55 -0500
Message-Id: <20220320004402.6707-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220320004402.6707-1-michael.christie@oracle.com>
References: <20220320004402.6707-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0065.namprd18.prod.outlook.com
 (2603:10b6:3:22::27) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f1a6e8a-63d7-43b6-c7a6-08da0a0ac1b7
X-MS-TrafficTypeDiagnostic: CH2PR10MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3992B2B0C492F0DD6671A09AF1159@CH2PR10MB3992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KX4sS/n/iJKqtAEvR7QU4bLyU6RQ10L+DDq3f/oh8nbMIWp3v7GqwI2IbDY+NgZMVO53O1PsE/fRLI6ji9D1bY94tcJyY53bevFRf33sqP5tFLeMBAQbmsHJUMw1K0kINo6rYJeGe4wb2UuS867pP1f1ir+nOjZSmV2aPA5fUIL4pMSFWVTanPqtn22yXx29WYidQD9x7PPpGXhIcw2pv7VVaP96MlSVE5MgAQ1aLyjFx4jBdXutmPAkIefO9UahJ7mae5vhZSRmAIu8SYtKti6RtLx4FwO6wzJgAcVVt3BOUODCLwqSO1YFC3EWrd+iNz9uFCBH6ya7/Tp248QrSMbhH/KI8x/niZAgoeJEx8ZgZizM2is4bqeJjGDvLYhlf8nwHWvVoixlCoRUgp339b8SSrpx0F0G5MiXuzrRvDlRWlcLcF56kIRLSXq5NVzhHZGLi5UR+vHTuEIY8pauERxl6UEnj5wfW4k4sKbKNTyY87/D2PpKx+/9jCcCaFnyniQoXj6jc2a4m80N08jSn8DXEmwTiJm2H7//e6tlHG/+QZMEeQ7cexv9QUVy9FI+SLqIh2IWXszrA6aYFIfmUbteqmh2VduwktA5drvDPQiJXOh6qDHZ2ZwWdU/iSAlKx9cumhGlSvz35XTSXJHVdgkRyVioGgrr+yiw0jfdJRXwFXhO5XfiRf1WAO8tev5aPjMBCgrBcIOxkkyrFdiPNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(83380400001)(5660300002)(6486002)(6506007)(6512007)(6666004)(107886003)(36756003)(26005)(186003)(1076003)(2616005)(8936002)(316002)(2906002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RoPtP05H5cg9vyCUvxbPhRjd9B3Rmk1lfZvy9eKgk+brAMBNNb187duBshCv?=
 =?us-ascii?Q?tlltD+Uz08f9vdfRZzOpRczDfQLeZdMzhiW7v4oRG9wwQ+m1h19k7Mewba5z?=
 =?us-ascii?Q?2R7SVwghy/QkciqeJmZ+6gauYFth4ptBjbUfOQLJ4aKdsOXoFpzyxkkKp3TY?=
 =?us-ascii?Q?zxdqvDMaEZw7Okt240l49NZ2UhyJQsmY+OtJqOiHVeg3Aabuyt6urJ3pDszV?=
 =?us-ascii?Q?0oh15FYD3Wxr9u0SXGIMAsNs97Hwf/w3yXFDduHpA36pgy5zaWY6jjRWRGX8?=
 =?us-ascii?Q?O2XoMKdjgs6BDxodFN+SbBFWd7rnCsz8zy7ZTMNkXcyhV1UKKDzPdx6jti3D?=
 =?us-ascii?Q?MSMvM6rTD9TkHf8vW1lXSxfTbWs6t0z48Ncr93PidKQlb9cm+0QNZFUSMBM5?=
 =?us-ascii?Q?0hxBmG7pVKOWIfDANLRqhGljYZwPYvyY1U44VSy8ctgOzgVs4ztdIa6LJI06?=
 =?us-ascii?Q?dvpHg4tmRTpszSri30VR86tGTQJQkyMARStx9S0uUJiYqFqDw0bZcdxnK5dp?=
 =?us-ascii?Q?wKYgYTBRGYZuYxR4UIvlNsD7Gq7XmxJ0uzvKkA3GaSwjdNl/mopptnPU1fp+?=
 =?us-ascii?Q?oNwekXhhRG9DEJlf2nYnDnyNIFpk/+URUscC6XuVY16D5BhIAU93O2QYZKjL?=
 =?us-ascii?Q?Fx3qRjXZ7azeZLoTSReY8E5pnNa30hC+JRtd60ZfZhnuIvtZf1ac1qXYX8me?=
 =?us-ascii?Q?pgqPJcLyZvVyVkC8Oq5lgqWtD+jELzG3QE5l7p0cfqLQ6QZ74zoAcRv7eJz4?=
 =?us-ascii?Q?tUSp4yKUqrOc6AZTycgZfh+RIpl5qm6nMHo7Do+A8FF3HB6udXmOFiYumVZS?=
 =?us-ascii?Q?uaK+tFBj5bWbFn4zuG4Bl9Z7hLhbilb7v2PI+6CeMf8Ubrd5s/RAJXasytFS?=
 =?us-ascii?Q?u9akG9PN1ffh8gx1zhtsDzqaKPiFP7WUKX3/U2dKCYB1qu2hlP2eRz2ghiLu?=
 =?us-ascii?Q?wvBdiBtlIMD8sas7xzwlzREjLM2y3CWUTqE+R3e96Vx8EgqsxRifeW3Eyfiv?=
 =?us-ascii?Q?OjFWB9NMDfDqM94LnGrSc1H1AA5LUMQk7kxp1jMlP5aHhFQcDxYCGQYg6xc/?=
 =?us-ascii?Q?Ck/oL7rbWl1TiEXDvtNsqchz8zRjD9veXVWeVp2zykjetmagJH0H3xJtT5Ah?=
 =?us-ascii?Q?Kd9DCv5RPwMHtQnRCGhg9YWUojnaW1K7qmNjho2OMotInjrCD1bjkauAJYkR?=
 =?us-ascii?Q?3DhRA1ULy9r6RNcpSecGoLaZJq+7sT+W+pfMYsKkG/UFuw+zUwMB//pSzObZ?=
 =?us-ascii?Q?DGtuKNpW8S/eg9GF0meftQwrlml19i9og587oTtVPiClIuwugUYymqjClpzn?=
 =?us-ascii?Q?cvocF6WfA9BCQm1ESUxqWN4WboTvUUH3vKv29Ak98PWFOQNj9aKhCGz0SUGn?=
 =?us-ascii?Q?USdOsC7w9atFr0DbBbaGD/jaeOoArU6G//vN5IJ6PiH6sbk5hAKoOyC0LhyO?=
 =?us-ascii?Q?RI0j4fGsa3bHX50gwiUP4Y0MZJYHsXvVRHqXNlsM5jF1m4f3e00FzA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f1a6e8a-63d7-43b6-c7a6-08da0a0ac1b7
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 00:44:14.4375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B9z9vG4Y0AZsDr3ONtlzwN1PQ6Ly9raNnr8bZlinQyeObQvOovL5Wwz0IE+JuY/iW3eok384gvvJMbIz20h+B4I47TBQnSf7kn9miHtrPZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200003
X-Proofpoint-GUID: xkR6m9Rh8Pumdkcwt0OmoqNSkIhO-fQV
X-Proofpoint-ORIG-GUID: xkR6m9Rh8Pumdkcwt0OmoqNSkIhO-fQV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't always want to run the recv path from the network softirq
because when we have to have multiple sessions sharing the same CPUs some
sessions can eat up the napi softirq budget and affect other sessions or
users. This patch allows us to queue the recv handling to the iscsi
workqueue so we can have the scheduler/wq code try to balance the work and
CPU use across all sessions's  worker threads.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 62 +++++++++++++++++++++++++++++++---------
 drivers/scsi/iscsi_tcp.h |  2 ++
 2 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index f274a86d2ec0..4e467918f4e2 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -52,6 +52,10 @@ static struct iscsi_transport iscsi_sw_tcp_transport;
 static unsigned int iscsi_max_lun = ~0;
 module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 
+static bool iscsi_recv_from_iscsi_q;
+module_param_named(recv_from_iscsi_q, iscsi_recv_from_iscsi_q, bool, 0644);
+MODULE_PARM_DESC(recv_from_iscsi_q, "Set to true to read iSCSI data/headers from the iscsi_q workqueue. The default is false which will perform reads from the network softirq context.");
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
+	tcp_sw_conn->queue_recv = iscsi_recv_from_iscsi_q;
 
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

