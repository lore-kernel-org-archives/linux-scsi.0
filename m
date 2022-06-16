Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB477C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379148AbiFPWqU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378914AbiFPWqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:46:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E8962201
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:46:16 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GIjK84032718;
        Thu, 16 Jun 2022 22:46:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=6/hFvvcSwQFADytRccZxOh7jrn8omvxfvFpRKfXzXSQ=;
 b=DSotYXUn57stbDhlfLRZivArely5uL2QkIorlceJnt3PgZYccxD0GaU+1XLUy6cmGUJP
 WwByiQdjMGYPq8Ag3V1Kp7l2SI4ZKrpHMo878el9S96+KlJjILGJ+o6OfigskbALDvgA
 eawNXznYA/qQyzCIavwEBqI3eMHSFbUEaIIZ6Kbz9tCQke7O/5T2cg+cFMQATCIM8aqF
 wyHFmqFIZ0yFy7nHwPrCaIWOQ4m0sRHcBhY4sEt4QzwvnAvvrWbJB0SQmVEGYyqHIhjU
 KCryXHCX9317rX7pW+cMQ3PlA/UJ/CJNprwLOSf19ZgdylkKs0cYHsYQXvcFqVUUOjOh NQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2vmny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMaOYd035621;
        Thu, 16 Jun 2022 22:46:09 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr27dmq4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikfjkWXf+DFmKwaNUtS/5n2v//D+vb6vTA+NU8oLs/NGNIh3IDZcNSKJz53hob3/GW18zjs5IkcYPt4kzFmn1+zqfBs4hISZXo2t9lNFaMYeBzEzAdiHFuSnpBs9T/RgOrRbInO7opbo+rV3xB18R1tw3oRkeHh/+z808AIzhXklK00fkwf4BBoKuzPp0uZdmsyQ37SVYnf+tDISzdZZAVoPPRT6ExCsjr/j1DkIrNGROBc2O1eN/932enppvFgoRCxKOO1SGrYzg/7DU3rPFcvm8fHRaFy1L5du5P2NjUJCzYLo7NKmneCew1Kd6p7nXYViI+2BkMc39uyCuMi9lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/hFvvcSwQFADytRccZxOh7jrn8omvxfvFpRKfXzXSQ=;
 b=bH0LuR+7tbf72yRW/+qeynu29QylnCdsPdheei27UrTJKFK3iqx+ensOHQzRE7NAcnigi+bKcaeWTDmrmpDqrtlEqvLuSyPUzT6G54aw8TFfxaZWRyJ5IdJBuWFRoxCx52zAUaz4NZueHF4yBehC0I7XjoVApmXN1Qk+pZBmWM2eWKCvTt/J0l4RNUaHlvVxXZwxrgyK1irlV+KWzah4DG/dRudXu92euLydcqJeUZM7lhrqRkqBrNpxnp6o1EcXKfaulI5zv4anTa5YBM3BZ+oIS5YBSBoNViC+Pj3BaNIUCY/ptRVeeDUmcB676PH7WuMgG6Ib/M+/mtiyOOtMCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/hFvvcSwQFADytRccZxOh7jrn8omvxfvFpRKfXzXSQ=;
 b=qWSj4bLK6cipOZsjqlFa1twmnii40ilsRSD5D/ERVTiGT8vrngWXsFoYa9Qk01VfKU540ekm9TKLjphI0fHchw9vTORCr3leM+CxWKoT+prclMsWKgqgQgbzmRnmJEhh1y4823LrHtaARxZDu57/qEIr2iCod1sS7RXBFGj83J0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5617.namprd10.prod.outlook.com (2603:10b6:303:148::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Thu, 16 Jun
 2022 22:46:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:46:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/9] scsi: iscsi: Run recv path from workqueue
Date:   Thu, 16 Jun 2022 17:45:51 -0500
Message-Id: <20220616224557.115234-4-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: c3ff3d14-9a05-4da4-bd0a-08da4fea0018
X-MS-TrafficTypeDiagnostic: CO6PR10MB5617:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB561770B62DC0FC1E8A366E35F1AC9@CO6PR10MB5617.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SEOBmaZXnyMFzghpFLrSdWgr8xlDiw76+hg0SgK9iCFNP25pajSB1cuHAcVRj+o3AcBoaCJ8eLdNXXtsdLS6YrmPNqWPNz0n0HOWWQ8skLXoTjWmYrDKXaOcST/GK1cqkj6NV3XH3aMtzt2lEFFT7F+hnxRmQ3DpJ6cF+QIxL110W461ReIFNPOvW0Wj5eKrgYiaXrfVw8ljkmNtnEMaSQUxLL57IzSvwU4TaRA2pS1+01GcHu63Rx1QTGjl5enCbLyWriQ5UXc0BVLbNuknpW8JFaj4njuuzVqzrcU0oMSzengTF2yU3dem0ZgbuKmAJhV+sZ3MJq7valS8uQSifgG0SF8l6GeY8CAMO61QrpEpudFqmR6tEhekWg5ELGb8ZdB5aOBGE3U37zSnbt8sClUSNabZgvZseEJLXvvq7SCwngzAJvEip/tz9YDW4FQyyBVwnXKLh+GaqgiXLUxstflGWvnEzMmHRDMuoBRh8Ol1pV1VlLSICZVSzKkDvm1Plj+Wjpe/X5Exc+60TF0wEvNJsTHfzs42kut65Jy0IaFiEMNkJkx0VbvxZ69NdOP40E0BrWU4HA90NZizdNsVfDO4sjZ9XqQLJ9uCqAM0txfHyIzbtvfmhSv5sx9ZoewKqBsgzGGFH/FJO+cB/lXy+Eob9B5ABDf6IcJ/u6Q4uzzXP4L55cgQ9jReUjfXpTeZ3sOJuzfe32A3dJ7FCJFrow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(83380400001)(2616005)(52116002)(6666004)(66476007)(5660300002)(38350700002)(38100700002)(36756003)(4326008)(6506007)(8936002)(508600001)(6486002)(66556008)(8676002)(6512007)(26005)(186003)(107886003)(1076003)(66946007)(316002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+HhoAfXbZCOfDTwRX5R+3NyqEEvgrHdMD88OiWXgk+C6CJT112/ZGFZyYLK/?=
 =?us-ascii?Q?cAh27MkCFrsFQ8aSiwJ+3rK1yuLcH9mk7cSTKTgxhOg70QNFZs7dyvZ5fvpc?=
 =?us-ascii?Q?/2JJ2t/w4/T13p29PGvYYhvEzwZLCD6/w2CzJ+z5JrfcICTAjImQ9rA7pNv2?=
 =?us-ascii?Q?zaVbICABPHsNktn2GEsie6ppfX2FST3lMvMxfThCy89zdGNjtxUsPk5aO8tv?=
 =?us-ascii?Q?R3kkAAKei6FG4fPQkQ25G1YAxyB93T9ILprRi4gIBbcrSyDGSX5x34mpsELY?=
 =?us-ascii?Q?gs2Jx90FKWs/QmBVOdalDN4cO8C58/56EOGjNJznHUCe1eijnTQdOktfPalE?=
 =?us-ascii?Q?X70PzwZQLRnYjR5yFzGO5l0yuWmyxipl2ToZhr2Pc8ZShKkQJ5T38fdt6NSt?=
 =?us-ascii?Q?fthsSkjKNNUl7rzaJMHc1e2tFjJHyFiCSTwFmM9IenjY8VtPalEpGU0zMr1l?=
 =?us-ascii?Q?QovplYxzRWK5bFy1izV3eFFnEslxDJ7PifC35kbHX9MksoJgJGY2t5q0VPbp?=
 =?us-ascii?Q?UDe8M/xjXyd3WRgqHNGquPK8qCkSUme8QS2hTItcw1SFdxxh05JR2k/p7RLV?=
 =?us-ascii?Q?6Cd6kltl2j2Zmcj3CC+Ro8HAQLHnRKNIkL2M+HwyoxozJ+4hdRtmlaeT09pg?=
 =?us-ascii?Q?mbQIpBwLdV7L9iGPK/5JB7YNgkDmz3U5dwKWiuqRAvxTvpJX67a6vpjrYgW1?=
 =?us-ascii?Q?frkf8Mm3oTSM+pajMPJ3eCsgO7wkOf1pF+Fb9vojXLKJ4FMsAy8/uuT/Ua2l?=
 =?us-ascii?Q?Lnu0bKl3oAo1tCKbZ57DHM8X6M5BImtOPMS4HAlG0s+fF1JfpM9FUs/yu4YJ?=
 =?us-ascii?Q?oh0E7eZ3lUHN3efJ7HKr25lTCdUclfucZDEkzv4Ru7/UCiFgX6TiDBzHjFX/?=
 =?us-ascii?Q?LkvimiMMBAhOjR8bMfbNmTQRZB7F9e7sGe56f+ViR/iLpZk0vshg5m5Fh3rD?=
 =?us-ascii?Q?5rcWGerzw6Jn3sS44g4CKS9PikEaEF1lpQog2qPiko7ZqPoFawj4lxJK+EMe?=
 =?us-ascii?Q?K5s1x8BqCUVN+96OF8OGWkFgUcmt48tRfyRo7wxR1dU6C6idbk8i2CypCRzd?=
 =?us-ascii?Q?Sq9ZFsQ01mP+FcBARXWTA/ikAFLl7mQN9/ahujWydVszzAKGwTShxZLhaec+?=
 =?us-ascii?Q?4KEzwmFQuawBqMF6tmtPH+JAp99WZgaxO+Kk2XHRCXsea+aS/MyqeUJcVHcU?=
 =?us-ascii?Q?rPdmZn543pauyZgnvXvG5nxw95hqosOYw+e7s5cIrLHdaRha5ISvW3SNW4yA?=
 =?us-ascii?Q?Kb0O8qWz76ukGneh3417Bmt38xyYKl4j3DaMuKtizIyZEzauh+Ta6L5MJq36?=
 =?us-ascii?Q?nh7eJAaWYfE8RoWgRouQgsemM1vmeRi88doFmorUO6DaqtVkK1ey8YtHf8AG?=
 =?us-ascii?Q?Kng0OAvX8b3BAo0QjjXKY6LYHzsOSLUpJMENMH76wKHkRbBb3Aj0bgCBxyuE?=
 =?us-ascii?Q?bQv+iWc0IOci+Xhd5i5JD9nxtufsIKUczDGJ78yrjOlve22mMvDLg1ylNEAT?=
 =?us-ascii?Q?hNA9N/7zbDOHIqvww2+iBPPHOrtteA44oEjZwEKake+DuC7jo8QBHsWEZK0b?=
 =?us-ascii?Q?bNBHtdvSGL7nr92mDNe9MdabX1qqJ5pmDnt2UhawO0b30uaeijRMzSCJlxxO?=
 =?us-ascii?Q?KK62dpr2c4VsUVkV6R/TV54RuBu6038fFOXOTRsRP9NrHX/FY5Yc1GP3pQXz?=
 =?us-ascii?Q?JEaTLYWVwagEZ7qxDQ12UR0b52nrpGwAtF6RiddcRcoNWEVLMAXBWTxgXtsi?=
 =?us-ascii?Q?MRUwFPgOfZeL3Cw2/c4kTJulrUTiy8E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ff3d14-9a05-4da4-bd0a-08da4fea0018
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:46:07.0784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nsT4hSjfJdD5jjAKwiM4pe0lK+QwRZaXbyLkZLJeu7SdwkgvY4I2/VOF9F4jwTLtELQD6mpyQm32fxsr0W6DQ3Jfjj5JczTH+LDI+PFT7K8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5617
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160091
X-Proofpoint-GUID: iowBq1gZaB2IBRG6nX8t17toajuuZYx5
X-Proofpoint-ORIG-GUID: iowBq1gZaB2IBRG6nX8t17toajuuZYx5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't always want to run the recv path from the network softirq because
when we have to have multiple sessions sharing the same CPUs, some sessions
can eat up the NAPI softirq budget and affect other sessions or users.

Allow us to queue the recv handling to the iscsi workqueue so we can have
the scheduler/wq code try to balance the work and CPU use across all
sessions' worker threads.

Note: It wasn't the original intent of the change but a nice side effect is
that for some workloads/configs we get a nice performance boost. For a
simple read heavy test:

  fio --direct=1 --filename=/dev/dm-0  --rw=randread --bs=256K
    --ioengine=libaio --iodepth=128 --numjobs=4

where the iscsi threads, fio jobs, and rps_cpus share CPUs we see a 32%
throughput boost. We also see increases for small I/O IOPs tests but it's
not as high.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 65 ++++++++++++++++++++++++++++++++--------
 drivers/scsi/iscsi_tcp.h |  2 ++
 2 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index c775acc5208d..d6d329fbbfcc 100644
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

