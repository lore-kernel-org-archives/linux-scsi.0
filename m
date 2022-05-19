Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EC6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbiESAgR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiESAfi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:35:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9436E195793
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:37 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMIlnQ007800;
        Thu, 19 May 2022 00:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=YmtvY3NQ8T8KYEC+iwpe/E5LqmjyPen/J8TytaQ/++U=;
 b=uTkhxwFoO9E/hu3wwM6rErjeWJXuylhTGezbVAAcOSagRDSmVwuCJ6DUsjb0L83bg/AR
 mpV2sX5eo2zw8cox+jscGgynx6zHoEGW0a2vpn2OPM8rVKhb/o3+6i/mOMHq2/4VMqNr
 8jM0WqM3z8Tby02Ei6bzCL0MQHisojp8zdf2Hc7A3HG6PxKcpX/5/5NfXH0qY4mU2qCd
 tNJH8U8U3CPixLSQq1aV3AXI1DZBzdwYGYi8m1FldjclUjRMOg+0o4qnSR5gn+HwWFLF
 rNp3olkKioYWeHvAYvpCrHtPQvpEd2ApMOVRhZdyih04NId9WjoF+rpIA/KeGe/JndVe 8A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucajj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0V4VC015306;
        Thu, 19 May 2022 00:35:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v4s0u2-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bs7Ww9TGItoRcrbqf6KKbQQU5C7ijVKFg+iUmWFq8PzYMIr0UY0OO3ugHnH9Nkul3zJRHXUI19NhR0SzK30eeAhdIzCKJ1I2O1VbbxDkdbFjuTiQBIkX0AJ2eLIGXeU6arjWFWfeZpO3KcntwwxJfCAuatL6QdngVxRfm6VmZp5BhdtP0Jx5lzqFSNs66UM4N2oSefZ+OeAObsuXH5uYGrvMrUWo5Z+fstSsnf6r9P7M+6zTmK72AzVebkCw9B3gBtewjgmfeF7K2PykOGDd5G+LnqmIwWmNI8CBa3IkY0OVtyIXIXlKOiNsdYQLX2rQFHFl266+PP9uV+cEsgIPXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YmtvY3NQ8T8KYEC+iwpe/E5LqmjyPen/J8TytaQ/++U=;
 b=Feob1fAS109ZrN4R+ORhyaXfIhX2P2IamNvhzSJ3EHOhIA+Mx0ebgP4ybCCo96/mz2PjkxW7hqcYblOcuI5vsR7KrN73Jru/n5JNVOxhjHHKI7jvqOA2k9zhJ7YklfSvFRVm6PJvfCR/bt7hJ0k5xavDEdVOzMmzFNDSX2k+dIR6n2WKzzmXM2P8oQFY6KNRgyb4cYGgInLwWGiernRGi9m1WGRBd1DgGkePdKJdSXorJHi5ez+iGwxzRMHDopZwQJM5ZyT9sS444th+q4Iff6Y+7rBvYV3IzpEEUj1IB7iNOvOW+rkvwLcBetqQDeaA0OV4xgOSGMEGXs6KRj/Rjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YmtvY3NQ8T8KYEC+iwpe/E5LqmjyPen/J8TytaQ/++U=;
 b=YVnDJeJ7toCrm/WVDld5K8XdRiAtDVxLY6a1K6lOI7MSbA41aU5v5Eee50cvMABCt4b0Lgrq3OitOIuOU5g+UPc83Qh5bQC4ouPkiiRVgP8s7TTOaMrgqmRON41JW+JNXUwWfU81qceQwVrJMmp9AlItygAUhyk+9wTOvCJ5++Q=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 07/13] scsi: iscsi: Run recv path from workqueue
Date:   Wed, 18 May 2022 19:35:12 -0500
Message-Id: <20220519003518.34187-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519003518.34187-1-michael.christie@oracle.com>
References: <20220519003518.34187-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fde9a266-1860-44fb-fbcb-08da392f7960
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB30205BF169417F58CA4E7DA4F1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wSpvXSF7zz5CvX9zfKSNaoE8ZWyPPOi0Py5lIdLgHiJccTCdqaAxE+kO50hWDzmN9zHHz61SQ2UYfCY5kAiCV/BA/9dvIWVSFrIPhTlmiKD2ZkiidZX+WfIanNExYkcpAt6P/kNrwHe7BwmFdzlZcRWdlXxcoBk0wXGczqKMZtyAdy7y/AQJ/REb24WCPLZRzvUTSPgtfdIjVZCGyKQKDLv8Tk67Z+XehYMb5KfpG/htK4Fm6q/63bpMfQV/fV82MsLCa4miiV3dSYIXYX4Q7HnqZNQNU2cDS5ELCxjvjmBe4a3wjS0DTCQfXpZoRNTKPQ7ZZhWBIliejVTxOC5fUuAmDl6TwOJE2AtT3u0zqqD+rfRH5e2SZNImo0LTrXhE7fZB+4TcpXM+bIh0cQVaHhmilG3d5xnAjmPdVIsqsT7XW+/5YjcX4wR94VaR1gZNJ9wxp1g2xGsdS5+PDzex/AVMsokTLf0/OHSA7LIW4DvAyILqC+TiWiSielnohp6NXqaq6zc5+ZJiDmy4gewR090N/Tmg2C254CqTheb7B6bp4rAiMVPPlQLKrFjg0YpfNxggoXmNsxt/jUrC+IGDJq0Se8ZWr+NTN9ku8CP+rRDmf/IOuEG+wQcB3FkPcVRCS0n3ALIaacnUwxd0B2MJ5xe1rK/miPm5JTHWky2e1+7cJRCxNo0lc+nRZ4WUzUc2JzEKN4RTkFz2ohXEqInUog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(186003)(66556008)(1076003)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(107886003)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(4326008)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PXnBA49HTzfEaFVDz26q95JSv1FArUa2NZtLSYcprmWKnnFbCu5URxd02fBd?=
 =?us-ascii?Q?pt0S3z58PxPLZmvQhpLMwHxZv3y76SViVTbbzPWlZPvIrcdjqd4XsKt4rDsM?=
 =?us-ascii?Q?Da5iwrzolrHYk50N7nz4vRvSXc8824LPMK5ol7vrNUPPjaE3FF42Dq5TonSS?=
 =?us-ascii?Q?Npvan26Vo3pawr/J0hpmKRx4Dk7hOYWr/G5xI9cAM9N8/orDrWKh0Xff8aGm?=
 =?us-ascii?Q?E0IOSwCTCAbrY2py3vstYSwxoaZDqfOYB7rsW7iSmGKh7pzJgR1F364cHWRV?=
 =?us-ascii?Q?2ZaZdFDDp5UwvsvrO8UvpXI7HktvD8PWF8fFyY3BX77irWso1SQ46chdySvm?=
 =?us-ascii?Q?vylgcCN4US/b8f4Qn6vfHrOBJIKp8YCgZ6Vyr74Q+7FavaPS7mw0JEtL6LA0?=
 =?us-ascii?Q?1C9BfTV/itZPcc0w7GCL+l8t+90scw/MsZFK9mfyPEMpDLJNS6E3ElFUT5rj?=
 =?us-ascii?Q?Yq6RUgeDzu1VP7aFq3VqGFpkxMxFpMRDfnuXMy6bMun+dui/Q/0szfveGxXX?=
 =?us-ascii?Q?nLc0plp/yN0fwmqMbUwHzzv5oCv17EQRQhxOfHonrbw7VthlhcjKtMzS4/8b?=
 =?us-ascii?Q?I5FXXnBUIKYksOVs8Q8p7pnq4FCQSrzaQEnDCgbxa/gC9PxkcvQ40ll7SJKy?=
 =?us-ascii?Q?VIhbf6ZrG/Vjecd+B2AOxWD3Dsi7vbxwcczNWf0o94BBNPairdqMT/5KDhtA?=
 =?us-ascii?Q?oHRsbVZ5izXed2gfYXdVvVp0+dJF/2NPk01GvzXWRRn0ckgSoyZDlToVocMm?=
 =?us-ascii?Q?lUxJrdm6FiPnrz2OEmJ6BgZcGimMLXIGNXjgxg/nncBrb4YCEqWy8sAoBg+N?=
 =?us-ascii?Q?OYYJW3dlCM5pBxUoMPv0KikmyrLSqr8oQRI2Y6wYfE1P/ep5W3rbCZk/5iqD?=
 =?us-ascii?Q?BoRMvZRGp40Rx2GQiP6sWwvC7e9jUBZwLZBRL2ZrfbXzZ92baaFgrebgDNPT?=
 =?us-ascii?Q?ExdezIjbmp25+DJcSjgCvUh/vnWOqXa7wbvT9xHhNTufSuZVeoZAUWZLhBaO?=
 =?us-ascii?Q?ivrvz8R6VEXFkONznMDK8QET95PSAiF7k7aKpS5jYORBMtkPyterR64gNUhS?=
 =?us-ascii?Q?JSBHSLcdr0bWNGOubWGuTS/rzVBTAWZcrYT9yXbjH8GkiCM77Rv6XOq3Aq99?=
 =?us-ascii?Q?//IL8nTxzyJAXT8Z3wVCTpkjm1q2aKOqcv6y2N3wq/WlPdJngmkXoxqBa8OU?=
 =?us-ascii?Q?qKRXJGI7s+ani8CIs/C1F7lsvCj2kj4j2bHguUxCrrrLFzvVwt40Avp7eVYs?=
 =?us-ascii?Q?AeX+DczduP0CvwoMULN1B2Ii+gXA/2flrzvSpXIBmIwNwXtOW/NovaXMWHMD?=
 =?us-ascii?Q?i2I7Ej15iWjDfLHmUgSkiGK/2jQYLL32QOU9emzg3ct40Fz3Ai1b/r/yhtqJ?=
 =?us-ascii?Q?kmn53TUTZzsMGE7gGbjcgyL2jKSKYhaUmnQLZyznSZ9tlxph+RGVfkZrw/Vj?=
 =?us-ascii?Q?yEwR4SVfKx84qwK46ilLfEyUs6n9GZO0dORIRtLoKJ0SHgBkBOu0rMAVT5hQ?=
 =?us-ascii?Q?oL1zZZ8zpL4kR6NBIHiTcUFKQJwHB0/XHtwlveBAuxm1IuK6BNPX3y0sQ6sc?=
 =?us-ascii?Q?gg9PcAMOGQw644yPvcwJdZ3TSQDdjBEXMq0aQBXBm4KIR9gi85RU0YUVW7BW?=
 =?us-ascii?Q?4HG26vQVQ1ngOY1yd1xq/yjvEwfiUGDNR747UTPK6hmfigchwFfMpqfDK7IS?=
 =?us-ascii?Q?Z72j4UdrQ23AjC9b6JvNUScSfKKCD2A07K4pjk/wxXkCg/M2SKUbGSB4lrYz?=
 =?us-ascii?Q?5i35JxTRVXsMLi5Qk7wjTx5JgSELxoY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fde9a266-1860-44fb-fbcb-08da392f7960
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:29.0241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: upZPGZvGgJPAujqRQ0KFraY21fdZU1G/orOsSbDPk+5CnxbqtZgdQLxHbT49d0gWX5toSQxK3UQU6nTAxEMEyrCbeKncU0zCsAIKmYgnGMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190002
X-Proofpoint-GUID: UF5_A3FAmgMClRRfv_uadKm7MWwIqXhS
X-Proofpoint-ORIG-GUID: UF5_A3FAmgMClRRfv_uadKm7MWwIqXhS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't always want to run the recv path from the network softirq
because when we have to have multiple sessions sharing the same CPUs some
sessions can eat up the napi softirq budget and affect other sessions or
users. This patch allows us to queue the recv handling to the iscsi
workqueue so we can have the scheduler/wq code try to balance the work and
CPU use across all sessions's  worker threads.

Note: It wasn't the original intent of the patch but a nice side effect is
that for some workloads/configs we get a nice perf boost. For a simple
read heavy test:

fio --direct=1 --filename=/dev/dm-0  --rw=randread --bs=256K
--ioengine=libaio --iodepth=128 --numjobs=4

where the iscsi threads, fio jobs and rps_cpus share CPUs we see a 32%
throughput boost. We also see increases for small IO IOPs tests but it's
not as high.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 65 ++++++++++++++++++++++++++++++++--------
 drivers/scsi/iscsi_tcp.h |  2 ++
 2 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index da1dc345b873..10d7f2b7dd0e 100644
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
 
@@ -276,6 +308,9 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 		if (segment->total_copied + segment->size < segment->total_size)
 			flags |= MSG_MORE;
 
+		if (tcp_sw_conn->queue_recv)
+			flags |= MSG_DONTWAIT;
+
 		/* Use sendpage if we can; else fall back to sendmsg */
 		if (!segment->data) {
 			sg = segment->sg;
@@ -557,6 +592,8 @@ iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
 	conn = cls_conn->dd_data;
 	tcp_conn = conn->dd_data;
 	tcp_sw_conn = tcp_conn->dd_data;
+	INIT_WORK(&conn->recvwork, iscsi_sw_tcp_recv_data_work);
+	tcp_sw_conn->queue_recv = iscsi_recv_from_iscsi_q;
 
 	tfm = crypto_alloc_ahash("crc32c", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm))
@@ -610,6 +647,8 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 	iscsi_sw_tcp_conn_restore_callbacks(conn);
 	sock_put(sock->sk);
 
+	iscsi_suspend_rx(conn);
+
 	spin_lock_bh(&session->frwd_lock);
 	tcp_sw_conn->sock = NULL;
 	spin_unlock_bh(&session->frwd_lock);
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

