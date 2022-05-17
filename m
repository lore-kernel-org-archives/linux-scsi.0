Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 316C6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiEQWZr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiEQWZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED8852E4F
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:13 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKTWN3029120;
        Tue, 17 May 2022 22:25:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=YmtvY3NQ8T8KYEC+iwpe/E5LqmjyPen/J8TytaQ/++U=;
 b=g0azgRdxPRVcc8vPcXkG3DW/ei+0kTWAvIldOUePtr+OhP1t6Jja4UTSV4kXbehgSRsI
 T6DO8mEnQARZiFLafZUy4ZHimx7/jhsdLgV/60oklc21PpSMWg3Kv3U6SPf/GwKv6x6l
 KCTvLU+NuyVkbOeHM8u1kEPrkarRtqifn+zNfr4r18fst1kU/Hn+r/86L2L7jOerZEtU
 cesOXfgIwjN35ik69YdO3X/SR8RdaNvuL2T8PmXK+jX2iX+EsF/qVYiZNk9PBZRlTPSn
 DVPJZhFDq+ozfJgQ1vKAF6zcdVjz500K720cvc/869AoZw8GCRxLAR+QyAqqbfn7FEe9 9A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310qrmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:05 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMP12G008394;
        Tue, 17 May 2022 22:25:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3m138-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mt6rcUFsOLObvha0KOK5tt2BtG4QnL2LY9G2i3zBitnlujKb9cKAwdVcKXBxO1mxFFsOaL6U2Jikms95KaFWMroyva9mvT9gJwMHO1H7cvoLpp2ak+OlLFocj4Uvh0DlMgEKu9MmZvKmQKzeHVHz61UtZlyOqFvHa4kaAqRbb/FcX389N+69ZkVOd74HdfRaXaeugYbh2XqN/vqGISGVU4A1oAsORP0XpNg96Ef4NoijdBLEcNxnEYyj3d0Ojf0BPB/bOM1y5FbxSYbwP8tRlD11R6zaCAEcyApW69OXpC49wl3PRSeFSQcnX34FUP0xm5LLvOHvOBn1JlAiFX5oRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YmtvY3NQ8T8KYEC+iwpe/E5LqmjyPen/J8TytaQ/++U=;
 b=Ifkv+HXLzOIzLFYRmDR9r8+nJ6bX7LKvhxO9yoB7nM81qZEFSBT4rvy857PUmTn/zNTfZeWxkHL+ollsOzVr7dIi8BXG/XolYXSupJeAkcOvwP1GbRnRDp1VIMZ1dkjqj99wjm48Wkw5ETW5poHyxZaCNHQd4+5wxQ+N+ckUdUnhP4g++82PGMta1ULqTdG5M0EOyQzshpq+nWsoFcRfpWrEZKqR+xAsQGWSPWJiYXyZSfTafQAJ7dS2dMa2BfWeh3kLLpKXlKeF3ZyJrZ+JLGrNnbGkarx1l7NOTaJwtEuHJ3T8FZI7sCt6UdBxGAvSLHqunkyT02Tlz7OVemNajQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YmtvY3NQ8T8KYEC+iwpe/E5LqmjyPen/J8TytaQ/++U=;
 b=ZqpSqhf22tTlzyi9DWYgAMT0h4uCqgc4bixqjymo32WCu3fPXYNLKcgXHg74DSOn7AwiPI4e5Ae2jA4FN+1dA8XFX7xgVkt4BdfTUImJ3h1MMlqa8uLgoAxq8beb3M73VRvUFngu6vR4aqEY5yXs50pPYJ+fu2ovpjiW+RwGRZA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:25:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:25:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 07/13] scsi: iscsi: Run recv path from workqueue
Date:   Tue, 17 May 2022 17:24:42 -0500
Message-Id: <20220517222448.25612-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517222448.25612-1-michael.christie@oracle.com>
References: <20220517222448.25612-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 751b0ea1-b339-4dda-9f0c-08da385413e0
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB551767396A42D6F20970397FF1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /oc3LkcqjZUbKs7eV9CNTUFvRxwYP3QV+GidNnlNWKHmpI5I0DvgSCZ4deXST/prGdNa60ZFMbSikuEy1318v+wOCtePHUHKHQt8vdzg1ujKx8RE4YonpOUZRAvLisXhNfAJyw7nJB0WOjSaytw388ttzotGJSgdV7S30lvt7TyKrRAR7k7t58uA1ikGHrsw6Gzbdq8V16bzUFPin9Cuw0wjZ2wA3K5IybLMhlO54Gfr0u+CpcAmJJzBwHKBqW8o4ie/guMiascQ//6NUgwNrrWI4MbsoK329O36fiFXapZe62orftRrFncqn5pfE+GniCieXkewdEh1JAqlKBEaaMuxk6AfO1zKv8cMTPpHLmoKpnukAmZAQh7oCA6d+ng7BwzPQt9PI+WOzAUpKlQC6T9Dmb29DyTfyhc6nErIqSbVlejCBSDIPZnvSEs31WwitudxHhjgUxhK0ij1nBkUgN1IgOH8ailSLPKIshGO/5lRNUmmnpllIAJ9BQYDenLbNTk9wrOO8EHEAAVOCVbZ4FZXU0GVhuuQ628yoBRF9d+YxuQzNqGtWjz4+KOHUKs4kybVfuki3q655NYLuzQ2Z73eNsGC0DnTNdUleRGrVYG72iFeF221CSUJ0UnvEa43wXczRNCKnyNV5kbi3BdnrNg3DeK7/dNqh3+cP1TMviv9262Mjt98zEyA6rigI+UPAm94u541iiFiEFgXix/AUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66556008)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(1076003)(316002)(6486002)(186003)(83380400001)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(107886003)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rzl7MAruzvWt+VFn5wesUuSItIrk9kLoyq+DYQDk3ib8P2CYHI6VwKhcXAb7?=
 =?us-ascii?Q?lwrDtY31EEtyrX/3IJVIkiSXyaLudXt1XGhA5qSzSf/cAs9JfPxG0mdVKOk3?=
 =?us-ascii?Q?VoevnaMRZYX/9S/hSzMwZYdYi+mWy9xAp/jcI28BN31S/rMox3tsa044+9dv?=
 =?us-ascii?Q?fW5oYcTJaNO4lkBnwtgwD6/+YweYS7DFSlajJqtzUJ3QAXR/qaxPD7YsqKk7?=
 =?us-ascii?Q?DqqUTn1aFEJLrGY2tZC/DLYwQjnFQuRz6IFdPgqIZeAJnXq4oioUSilVjIaB?=
 =?us-ascii?Q?lucLNIWeor8i2ZYys18AXlzE+aImk1IKGs/nRec6MF4w9t1dKYvymj31fLMM?=
 =?us-ascii?Q?fNB78AQGAa8l/XaU3UntfRSPZODEE+CQY+D0bNgHbCNpWOAYNPUTMAl5KpdU?=
 =?us-ascii?Q?klm9c9Tv8HB0OUrz0G8ykhb+0ds4CopyTEGy9zhC81Kk4uZ5sPGD0buxGuf9?=
 =?us-ascii?Q?BZ5rH03WYCRpqSXyCWCmWjTyVPRwljpZC3xe9nKmIk/y7sM0dmFsCH7ftBSF?=
 =?us-ascii?Q?GsU1J1SHe5wzCkgZJoLGiXW9xYjt+K7BPTAZJAIpSBwY1s/0xkaz7dbbeImA?=
 =?us-ascii?Q?LuF0lek41WFJ5qJD+rXChOLiOHrqKfkNFjKnfzpFLEYdjiBXUV37JCZ++Lmk?=
 =?us-ascii?Q?q3wmcHgM7fxbXqCKCrsq3GVAsPN3FR0/uHknIuFra//fhQJyVyjUiPjcOeRJ?=
 =?us-ascii?Q?Slxt+n6ZqBjawPT7KJ8ui2q6W6nnDrGJtDAanE7373jmMtfS0l2A8hG9D/tE?=
 =?us-ascii?Q?h4iRtAn3aCZsxMDAcgGXskIpnH87jkPPDGdK4sCjNxU8JYXE4gJG1T3MrEm9?=
 =?us-ascii?Q?RX2DBxivhwfhrQtDKDtcAXTV2Oji+chW/5ICqQNpA0w6WmXb1xRyqbPDPRPD?=
 =?us-ascii?Q?+sUeSOCN2bWrHCGUvhg4c5N28wheeWKyQzaN2klbwrb/uGHsGp8x6VlMgqTR?=
 =?us-ascii?Q?+UHo73pwp11OyYOKgIrklYABCiSpcg8cHagfrBN2ZVnLZQgsFL1tOooFDuGv?=
 =?us-ascii?Q?LZ1HULOH1pFWn4CBYnz1rTyUp2YvGWT9AdEHWbFYxWm4PDpjvOu8lxnxEw3U?=
 =?us-ascii?Q?4FdwRVdU2q1iD7sMj6kdvUzhdo5CXRyw4qTanSi9cynozfxylZG+9Dxi6JOq?=
 =?us-ascii?Q?hlIXktf8riecPotqb181JIFzOX787W8KtdXof9mzhViRIn1I8gN20w8YGcK9?=
 =?us-ascii?Q?uH5gTqpAV/cMhCsUVs0l4uZ8wVTgF1tL0Mss9qe9YEhuz/BXl0s6GjqgnWoM?=
 =?us-ascii?Q?92CjhoOqmqFEv5rTi3xufJSRTTY09a6lN9pvdae0gOTNVxKFI3ddQacyVEz2?=
 =?us-ascii?Q?7Xsv4JKTop1NOEgNMTyUFq0ODqAYgVEKjpG2CPNwGvZbvrT7q2NYAbPvkYKt?=
 =?us-ascii?Q?zDTA7oW5bElPDpVFAKLJprd59ccowfILCLK51Yq6DBkWOBTeh3CS2DyCc2Nl?=
 =?us-ascii?Q?mODsSObU3aoOAe7VgXZmpaB3eyOG45Hw19nrc5PDm+jteFTCZrCzmiWq6Erf?=
 =?us-ascii?Q?FoRBhDuV2timtZbBZcPPSPQ16svYLynPmpiiKRENMc7Ny+XWu36Jkjnhf34k?=
 =?us-ascii?Q?DFJssrp0mJ58QOeBKFLVd9eF4PRuYRGtwfT522E1LXpjb7uGjXFs+KEkIde6?=
 =?us-ascii?Q?ZgA7jV7kCKFpOVvWKAM3FL4pPp0D7RLD7ePQDu88S9AN0wHPiYF2KymFp7EX?=
 =?us-ascii?Q?9kk63DyR9JMeANDvHNzuQXMz6XKKfTaoEbQQnG6DaRQ+dftKgePm+yY0Um0S?=
 =?us-ascii?Q?CWJfsbIn5qU5R7J3Lu6pVfq1IbB9qWk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 751b0ea1-b339-4dda-9f0c-08da385413e0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:24:59.1523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m4Tv+jijKi74nAYpxt7EKR2Hxwe+OSvru6TGtzBlW4Z5w3dZgZfw7PS6FoP8LYYF3Svg3uRBb5dlHB7/nsiGWCY6BGFXY9UoSiJESwUYVNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170130
X-Proofpoint-ORIG-GUID: VT5zhrjgF0DixOew_YPPxtLkNSdgJJ5D
X-Proofpoint-GUID: VT5zhrjgF0DixOew_YPPxtLkNSdgJJ5D
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

