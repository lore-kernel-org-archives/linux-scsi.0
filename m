Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58068C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbiC2SKp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237497AbiC2SKd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:10:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644511ADA2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:08:50 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsHUf022149;
        Tue, 29 Mar 2022 18:03:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=nht37n11ALOj7BOTczmd82omX99TfECwasX9h2HpdKs=;
 b=IIn9dDeSoOCxnSjeUPYgvw8tKebAhHo2BSaqBEUJrFvqcosOJDe8iRuyeDkKbROCFM58
 hyZJjo9nW+iO/0gzqNIIu4CORyfqNtPiX7EXLsspEmv/1EJpLYCpsF2UEd+J6mfHQIVF
 nIrOQgjggLxQKFfw1xKcTBgn4mEz8ZOSsIBxpRwZBdoLTgJgfhXUC1pr9BDjm9N29nqw
 nXXjgj+sGLqrTZS4X6U/9sjPz8phC83ZkMWBVIf+5yPGJ+d0r8IkjsOSGfEvzVkG1epp
 zd/2eBhoxzAGwT9s9YCgZrqoyCMoVhg9YbFmA29MYfGWF/klvU75lDQwjKsg9PKWT57x +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1tqb78tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THvFJM048570;
        Tue, 29 Mar 2022 18:03:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3f1v9fhge0-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQN/7bjy6eMU8QES8WXaH2SRcakXNia/x9NMMSWb2Wr2KbyoUAE3eNQKUxEkYJpMwgDHTJ+LCpvpLGVM9Hag3ZlZsSio2md3NYnUaZGnITHsYpu6vbNcHoq2Ri4HxZWqnnwuyK7//YIqNOj0teCBjxOhtn89eKsujAglILlAsztk+ckqRoV99j5maPcW3dIpiJW3AwwA8TF0ZDFzN2QjTv7Y/Llbl+jLf5LZBgsrHQmxiHrM/OmNlX73GlMCdGbnHLbWiUY7STZJG3QbzDBGfQZXGs3Xo13rz6w0YTo8rJ8fru+bb2zBTIXpZ3+n5HpKSkmqwbEGT9z8B/PXEbTPvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nht37n11ALOj7BOTczmd82omX99TfECwasX9h2HpdKs=;
 b=caSYW+Qq74PabbpxcQ6tApib5x2/yvxKUqZDQgI4hCrYZnYR0pzqTByRvqrNqbv4FdlVBay3gWOYTcsz7Gm1d2EOE4BOfwVYDTAB+nK4tGBV0lS6pMUXaEDGnbmTf6q/F/FYGjIDPyci5RyL3uezAA3j9byZqREyp1EstzNIP/mgnxZI0JGWt2PqXzDHFBsXROnc4XwjgG97jxu/3lH9+ipbjpYfa8zsBTujgyp7JHiWHRoG7nTk/bp2HoADyCumKPnPVN42iDHIdcBsCQpIYm146JqQSgzHCctpg8e4RuWhkFIbHI0WUcBdcjtukGXJoVcvFX/AovB1lgsfw+65tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nht37n11ALOj7BOTczmd82omX99TfECwasX9h2HpdKs=;
 b=jyjvgYmZECId2AQLcQmB4l/taYg2EHq3uSvIe8LhrtzXqKvuVXYX5XApk8vnZoUu55X3zV4Ba2kRx20n9cJuMun80GKIHkbHsu3t0oqZRACwkHubBbndjzbJwJ/U5A35w3OcQ/v4FQfSPwAIzeYvdUCO+O8BLxRcI0j+2doaLrI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:39 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 08/15] scsi: iscsi: Run recv path from workqueue
Date:   Tue, 29 Mar 2022 13:03:19 -0500
Message-Id: <20220329180326.5586-9-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: dd5635d2-715b-4c3d-d9a9-08da11ae7380
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3584F4F309D65B5D06ABDCD6F11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ruu4d4l8O2wK6fptoQu/i1++zFT35tN6t32cN6aFYwb9/qTt6iq+0gSFmJtjaUw/HNuqr6ieu1uf/U3fX2T42HHbGmPNJhw2imhYKre/R/qs/06Gws0e+d5j5Ie+7HJKxJhxRVGk6bYJbrJPEEbC/wrNdc1d18PaOfr9CKaJN7kyUup3ZgXk1lbm2svjZi9sJtxscQy3Q5ZRV+vnnTss26rVwk4IKg0M6KsHO2LAT1zMkIQdWybpB7AIv9q/Lvq603PlilmycNehKPISWZ8ojmGsNnFfp7U0m5n0FXsp3Qjq43svYozDwy4Vw94t3GclNjbELl7GWYXwP0xdmXlzBuyZJXBoK2mzsLi1vhVNINigKadku3LzJrLx/NHO2rbV3rsS+xCGjq99KuMBeN7cFiDu7hZomYfFwD+mm6ie+JLm43iq6lms6J3UNzfND6Yp1qp+XJIbbTgkupqr3Jm1BMJSQsn90DiCBJaInalwFSeQNIUQ4g7ezAU6d9L+iFsGOfeXyPh6f5FpVX21ve938e+/Bs5XJNuRBh8CqSwpmb2y4i+MVqEo5IeHDB4JmImKmDJAqeG1vGUYpEHqUine3Cn/5gncN0O/S6yYFt0C+gV5ZFcEYckcVxXxpV1RBm99SKB0AHFqm/I//MyJo1ee4dZMdiQFKFQ2OEKm47EzLG54jsSI6CWsGYp7oqsFKCns7VURFb2dzNUuNFI/momDHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(316002)(8936002)(8676002)(6512007)(66556008)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(107886003)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gOMBfdNEBmxNMhNhJFZB/FbFivI6M1Rc4J14j/I77/+LReKq0rBCtjjAz7RR?=
 =?us-ascii?Q?X5drCZjtyihjcJKLcQDSppYI4Fhv+LfToB3zOK1dExQ4gingSwRywrY8ph8L?=
 =?us-ascii?Q?iNJk33btD1mIYpiIScCAqFbDhMc/uNZzANVD9MhtQHI2WfHk5Qs3WgLoso7i?=
 =?us-ascii?Q?YHKoHrBVWbBNxCzFil6mRPbHEzrtx84nEVVZ072l/0eiURIBJMu2aBoliygq?=
 =?us-ascii?Q?mSVfIUbx064sVoaJxgcpujGQ9LB4vyfquvOIaPS5hbYZXzcvruv8g2XdLOXP?=
 =?us-ascii?Q?CpedOUunn7mTg2WNr3WQYKuPCZFGEoNX05kAmKVEgAkk6mZeZf3YW3XNGf4s?=
 =?us-ascii?Q?q7w/KtVZd/JvzKHylA2M51XjFLFQ4qqSUWoEUDa+P216P8n49iNuy+g2Sy8a?=
 =?us-ascii?Q?o6x2IEOkUYEshFT05u2RioZ3dxR2VNnGfJcszTcYCNgRsrMthnLtgKOYmGPh?=
 =?us-ascii?Q?7wyybe6rKXVyuI98s+4gv5u+StT75cQVgZ+MdtAYGdE9FF6ASFGKftihiost?=
 =?us-ascii?Q?4/DxVzjlrn7XDt6BrfiSo/El4w++GyPnnHQbt4eJfeLo1tXP6oRI0fz/OpHN?=
 =?us-ascii?Q?TKu64L+lThEyuTDwYcCGd/3Jt8gr+fQEFDIU/8qfLz375jXR3xAy2MWJvMYe?=
 =?us-ascii?Q?0MwOCeLVf+CcaziM/FcwE2pgn6WCaRvSUwmkHDYpH8m6dcb+6WGa+d1FTnT/?=
 =?us-ascii?Q?mM6kvugX4SBZfvP14XUo2QRpcXP3J5skz88SHeNVc8a04TKgXQki4pwjnF2C?=
 =?us-ascii?Q?pMrNlzBKuCbfqzF7VZRpsjfZEPh/4c1qKopoguUDal/IPNPRu3NMaB7Sy0/n?=
 =?us-ascii?Q?VcZec9KxNpCiLDUwPVu7EdpWaQql3zU6vZct7i3Vuc84OtEtKuzPej7fu2x+?=
 =?us-ascii?Q?cgHl0w90N60vZW2qtwpm3z7cCQUq10BA3O3oioamhAPXMT9F60EwGve1NDtB?=
 =?us-ascii?Q?NmEbs1cAp2zprLoYii3WwmZMt4pGMa5Uwb+sdRBlRPKl0zAbsfWcx+foLhbt?=
 =?us-ascii?Q?It77/RXa1bK9MTUR7h4BsKFMHJbjxziseyeHbVC7sfunQMQeQYro4SE44AEk?=
 =?us-ascii?Q?Ikrp++TanApvFgcYpM5fpO29NduHM8kxI+Su/xgHJzuhBnbPLzPRGg1Ijq7R?=
 =?us-ascii?Q?EU76tUGkyxNzm2conj5OULpSOtQ2ANTo8aNmcrm2FGum79gg1wCII/TX68D8?=
 =?us-ascii?Q?VcVCOArh6jlWg2WhnpCnYIObocSvvkaRF6zUseHLPaDRFIUG6Mr/ENesju5s?=
 =?us-ascii?Q?NyaPAcqsVCL5r6xHdaxLHLeXOR9lyd+Ud7IisTEWoZQJXEcfP65wHarDjHkk?=
 =?us-ascii?Q?4mUO3E4dZSuA8KzCrb/OR107MJTrWO0T55wrm4X9A6KQ6bEDjEZcGOObtYr+?=
 =?us-ascii?Q?LngZGQrwidSTYLdZ93dEld7PE6hg56b9DXjGR7Decl5Zzub5X/loMvWNqDWX?=
 =?us-ascii?Q?lkFxI3elhuqPPEJjmDDeI2BHLBMpgh9XWGZv8dosvvu/Zo1B+noTA2bbxQYd?=
 =?us-ascii?Q?TKTMqS8PTHX6/Xk52DXJSIz/JnYdipZcHxvmuAeoD6TdBMeg/2f2HMiil6Li?=
 =?us-ascii?Q?meZXDGGOtSJdxVfiuf2Cn7w9hLCMO51OFdEK/F0TFrOwCaqIkr94EK3PFcHg?=
 =?us-ascii?Q?/zc52tAugS08+HM942QEYx5qdJmfsh4INRoUjE5YiVWdoAQg1nRR+PyksEOV?=
 =?us-ascii?Q?7SON0rmDGNl3zvy9heEAhucRimgcBJ8FFjXKz+Fk7HCv5zPCwAwGdBoCVSrd?=
 =?us-ascii?Q?LOmfXh09J7LIj1xC/k85D8QxB3wPTaE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5635d2-715b-4c3d-d9a9-08da11ae7380
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:38.7246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YqRpMrX5wMy6oi/RkzssqAdj5U75AlbX183Aha3dI4ErZcu3ozZgze20aLXF1GR6R55+mgKFH3dpNnsXIzPJPPFXpLzU4v0++zNdVRFK8AQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-GUID: p3bicY8MFFYa5F504BAxsOXyt-005IIf
X-Proofpoint-ORIG-GUID: p3bicY8MFFYa5F504BAxsOXyt-005IIf
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
index c775acc5208d..dfca81d4e3ee 100644
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
@@ -610,6 +644,8 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
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

