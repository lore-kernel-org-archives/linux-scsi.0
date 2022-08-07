Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 020E9C19F2A
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Aug 2022 16:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbiHGQ6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Aug 2022 12:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiHGQ6e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Aug 2022 12:58:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71606545
        for <linux-scsi@vger.kernel.org>; Sun,  7 Aug 2022 09:58:33 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 277AhoTT032247;
        Sun, 7 Aug 2022 16:58:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=EDxnLt4PBQd3XF8EAlL3zlxW9fLkIJ8QfR5paJ7zmGY=;
 b=u75BeAyXheCdWFLYFXchWOfpnq8YYU/e6DLpLlT6kdgrLlO8daPJks2QzRAsYTyy4ZCr
 gwOAsz98Rx4N8V5sWFY+wvabnF/hjiPK3+Sb/UPMwooZYh9PrwVqSs+73uhdYCPufuKI
 4SYx/UmN6fg/Kc4ZJRMXC9N3teddg5S5OqCphkt/9caP9aJGmHmA5dbHDRTCO3NndEkL
 sL3+wzbfl7PGoZpaCn8J2NMw62uemIvSKZ2OxD4Sz4Lf9lZC8VtyyYG4O5dxsKHfEBRQ
 3S94qw9HJ/t/zfig7dh4shSGGCigmyCPV+V2EzkxSmnbsBagqyJ8IkFJ//XtscOn7pMS UA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hseqchuyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Aug 2022 16:58:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 277CS1DK035901;
        Sun, 7 Aug 2022 16:58:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hser7ap1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Aug 2022 16:58:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iab8cbzhcGdlm1McgiGf05E51JdCz5SvZK5FFX6qybxfMSfWbFiKO6WpcIZO+neg1CJ5h2B7klThnvt0AZo91SYcTEvXA7c8dhAcA6YTQX3X3GQJmy84gBMEjtTq/hVhH0D7Xmen7jwRjAPCoKaPT4a4gn3V2kSry7rA9vM5OIOAwShQ87fmohKFTBpxgvwaKCgW2cHczuziUKekCgCtcuckcZh3Ymvrr1nyXlpvln5dbBRjs7LZVKva0SO88doO5pvTAQZhC7RFupRYwxfN/K1gTlI50m5q2SdxBLAFTvJgRDd2YMCAqjpRdGNIskkdPBFNQUYLk52ynIeUgjktdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDxnLt4PBQd3XF8EAlL3zlxW9fLkIJ8QfR5paJ7zmGY=;
 b=ju0sX5suyuwswaPYaFtAcAl39xQ+aT9Nt5MERN4FIbMzBuv2qVphM2Fp5mETs2fKc/LWsNUDs7xhw72qYswzFYJC9N+esDnJB+N1MJKLECuJV8Mmy2NjjgiuhaESxAFQoUXBAtMMga87I8r1128w1HGxRTOXEmmBfgoSwmylEnvdvn/jKlMSNSHxjj3SndGNOZN/qepOZU4B1mwoIkYfWpNCTuMDs3ixnr/5A59w/kxurUdWCq3a6Y2pHB8QIkjv99t93xHxecT14DDKdxKuNNpO6pbpYgIZD2vyDYwK2tdI+Mp6kaP7X5FANRS5gfl2qOeGiNtRzcoTAZByMcx+FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDxnLt4PBQd3XF8EAlL3zlxW9fLkIJ8QfR5paJ7zmGY=;
 b=Yq0mNAjwo8OI/OfLz1ZuaTTOcR3BHlDUQZNcTy9Iz/DprZkOy3FKSplBlgV3jyIRWN2ql7s8tIiQ69kBP3Ots0sEg+SrTSqn6Nb55220538lRAtTOet+qoPFQNaSGJTYjrZJ9pUts0IOgzzRRMNzQtQAa2GLDcNTShkVwrPRTIU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Sun, 7 Aug 2022 16:58:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.019; Sun, 7 Aug 2022
 16:58:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lijinlin3@huawei.com, lduncan@suse.com, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH] scsi: iscsi_tcp: Fix null-ptr-deref while calling getpeername
Date:   Sun,  7 Aug 2022 11:58:04 -0500
Message-Id: <20220807165804.8628-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:610:b2::10) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec416cc1-2728-4ab5-b511-08da7895ffe4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YNnqwCPGpFmLN8w6qyu3se//cj+Pysicaxd4OHDRG3FuAcw8A70gQKwM+13sINmXRtdRKQv6Vb1igK1kKiI8GU1RozQnKN+djZNBgiG0NdoultdzVfS1wrz9Z/FN6ufFKs101laolJJbmFIk7LtMCxFAaZNa80Su632RKygCWPtGAGTlcBbeZB6d6n7VtuKKroehAr851YKSf5spYoWcF/ayGbv2SO9B+oj30ppMLg8J3rddEF02YZldO9ZY8Ai7mpaJyUpSWbWVnH36Lk2lRcQPNBLlEEUVQTq7jEmgefmnTthhhjVbhZS3MORt4/5HGSEEkdSbo00rClTPJ/hWk12/Qov7ao6FKFcIoAQUc2+Hc8Im9EUrhB6oF6Rmk183Ms9MPW3lu72roO9ElWXGzGLQ9Rit0LNuHzsRet8Us5POs+aIZTlMD0udXhQOv6HAFS+dkKFNkp36p73moDwtOHC+hy4uFAbkOQ8LPtQRfY1eKmW8MuwEuoFPdEZF0XEocaVk+2EyD71DeymZkyvkBmRx7K8uJwhV7CsxECdO8U/PVv8KPzWOOpHIybi5DjwOkbhwv8ANKXxr4n+1GiGkvDCnTV77b+OmXiY5uyINxI2m0QQc7W8xhwOwnCcSqeIGXqv5nmABNhruk3g7K6XZqnHxvjPQP0UTKS57CfJ/hFlh+2EeMqFs4DVmhlNoOxp8AJ/bpde4T20ECDB+4686g/KBUbqOFpM2MMe89Gu/irk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(346002)(136003)(39860400002)(376002)(4326008)(8936002)(66946007)(66556008)(6486002)(8676002)(5660300002)(186003)(66476007)(316002)(36756003)(478600001)(2616005)(107886003)(1076003)(2906002)(6512007)(26005)(41300700001)(6506007)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dypsAVHdeDuOAHGVxUQk0Dr2x8MjYdYDUzp/x+mGRAFOFWhMbAx+zd5+c1Bu?=
 =?us-ascii?Q?IvR4d4o3y/xhOt2Dy5UtuvR4livzGfyAGFurzIf0cUXJPdc7Ot+JYaZC5mFS?=
 =?us-ascii?Q?4d3cLwdRnMGCQn1pTROib4laJAnHRRnhBPq8FQjMWturJp0ZhHQUdAnf7l/g?=
 =?us-ascii?Q?Z9TYEaqN+Qiyv05mgBYEpXqeEMc1WYQc4F61Dn/2/LtGjFQ7Fl4ETB2V0tSV?=
 =?us-ascii?Q?1sMn9lv/vIG0ibN/HwqJU5Hdeb9rEdh4BQ9bsYlf3Q4h216tJgTcuu/+VZmz?=
 =?us-ascii?Q?ck/B9OtjcFrwec3UmoqaoydkVRL0ZrMfFI5zvHYbhV//68nUX8WR4BORHv+2?=
 =?us-ascii?Q?hn4Rz8UCJ3K/uWRMAEL5Qy+bTYqfzAW4G+IMGX4wLbf/hWAz9LFGT/NGWMhv?=
 =?us-ascii?Q?AB7JGQKQ4jNC9TKoQSuLOTflJp09p+kIb1DuRtlhX0XkJPnCue0vmqd8j4WR?=
 =?us-ascii?Q?aRKjhlj3AB8fJjk5CSfd4Z6Da42LVco2PAZfTIrn7f14JKArj67DbuGC8efI?=
 =?us-ascii?Q?lzkqdF+LF+XiOHWpN9yikq34HFVPWjjir6R7zdxUT8RARz6Z5bOW3aka0br8?=
 =?us-ascii?Q?otuPM9QaGBHRkXRxxRvUaPJYUJCWjOkNsMpJrPfL3/BKVUqvJeu1FL2Mdrsk?=
 =?us-ascii?Q?jcQ1zUc6GaDpyltorGuCuMPdKU94YM/Qmv88zFVrmJ1vDb8xOK6cFTIzfwNz?=
 =?us-ascii?Q?cTlR+hoHJ3RgZl4Mai9Mp9YMSM8L8zObUPTtmq5yBwLtL4tBtt4gGh40WgNI?=
 =?us-ascii?Q?t5C+MldKeYNwDGHEBnPi2tXwzNGiKK03Seef6UVev3pjgwZcvoE/DIfQ+EAC?=
 =?us-ascii?Q?2QVBBu6XdvXzE2UFq42yaH/9rcImRV5L/yE0QOmaRVV2yp2bwYpvWQjo81Qt?=
 =?us-ascii?Q?7jXt2T7EXcZImtZlQl5ni1QxbE4gylhDlxBZB01gmCdW9Z/7Wp1xoo5ni3tq?=
 =?us-ascii?Q?lzqqvb84zCZ38lvquNOqDLwmjacvNZOcLNoN4PlIX5CahVrWzo4qh/nssbGu?=
 =?us-ascii?Q?Q13P8vGWkn2JFpKoEYlhyDmPWC73CrZ189bR1nZZezXXjfPU2AUrUlPGxL6y?=
 =?us-ascii?Q?H5e3Ff9y2Nz1fQ/fxnjXDjNbcoxBiO6W+eoAShKSAtVnuHf16TYvdokB9lY0?=
 =?us-ascii?Q?vtRZpmGkRlEkrVnFyybPeSrBn3q9219VfgOexvd/c5cmZ1SDoUBWg+2kNvGu?=
 =?us-ascii?Q?Mts550nRkbehV7SZaTVXj0nSOW8KuN1z/hvmxfLqV8IEdikhHpLlbyJG3Qcf?=
 =?us-ascii?Q?pe7e7jWdXmiyYrHnQ+W7Q5YyTZ6L/NX0cfZy7tdMTdCcNHjmfNfMkmQOUToP?=
 =?us-ascii?Q?Ea3PgcyS6eG0qyaEMUYmViHWy7M1RGvs6uiW8jwcSH0W1foG1NZBqMs37F6U?=
 =?us-ascii?Q?kcuo/X7Fh+iiW+qc9EeUIVHYpPAMDVKO4ZD7qrgU6J3bu0xICyBOGApy2+US?=
 =?us-ascii?Q?Q0PZbXG/D88H6d/7bN8djJQSKQ0Op17S9dbMmmGwxY3g2oavw26aD8A37ZzU?=
 =?us-ascii?Q?wTi972ovEWbQqol7Ruio/TMwZ4VwdppxWvXosBt81Hwp208EF9s+1SA2BTe1?=
 =?us-ascii?Q?WsSzmXz9JWrBLXigUMNMGZ8xzXzaevnnwkOjHo0LL+Mf+XYUQDt+ozzuflMe?=
 =?us-ascii?Q?TQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec416cc1-2728-4ab5-b511-08da7895ffe4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2022 16:58:06.6703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z3yft6LxXEOs6mRsmhKK1K49BV3+VxPKdzn5k2KaJj9VwFVDru6n9ADZjW4EjfJBiv+e0fNHAJwwRUxe4t3H6K1nXBlFwvEgdHroKHrS4oM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-07_10,2022-08-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208070092
X-Proofpoint-ORIG-GUID: Et4s-3YPcNADyQYgFQ1Jy3ulA-Cm64ta
X-Proofpoint-GUID: Et4s-3YPcNADyQYgFQ1Jy3ulA-Cm64ta
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes a NULL pointer crash that occurs when we are freeing the
socket at the same time we access it via sysfs.

The problem is that:

1. iscsi_sw_tcp_conn_get_param/iscsi_sw_tcp_host_get_param takes the
frwd_lock and does sock_hold() then drops the frwd_lock. sock_hold does a
get on the "struct sock".
2. iscsi_sw_tcp_release_conn does sockfd_put() which does the last put on
the "struct socket" and that does __sock_release which sets the sock->ops
to NULL.
3. iscsi_sw_tcp_conn_get_param/iscsi_sw_tcp_host_get_param then calls
kernel_getpeername which acceses the NULL sock->ops.

Above we do a get on the "struct sock", but we needed a get on the
"struct socket". Originally, we just held the frwd_lock the entire time
but in:

commit bcf3a2953d36 ("scsi: iscsi: iscsi_tcp: Avoid holding spinlock
while calling getpeername()")

we switched to refcount based because the network layer changed and
started taking a mutex in that path.

Instead of trying to maintain multiple refcounts, this just has a use a
mutex for accessing the socket in the interface code paths.

Fixes: bcf3a2953d36 ("scsi: iscsi: iscsi_tcp: Avoid holding spinlock
while calling getpeername()")
Signed-off-by: Mike Christie <michael.christie@oracle.com>

---
 drivers/scsi/iscsi_tcp.c | 56 ++++++++++++++++++++++++++--------------
 drivers/scsi/iscsi_tcp.h |  3 +++
 2 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 29b1bd755afe..6a1c885a1b4a 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -595,6 +595,8 @@ iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
 	INIT_WORK(&conn->recvwork, iscsi_sw_tcp_recv_data_work);
 	tcp_sw_conn->queue_recv = iscsi_recv_from_iscsi_q;
 
+	mutex_init(&tcp_sw_conn->sock_lock);
+
 	tfm = crypto_alloc_ahash("crc32c", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm))
 		goto free_conn;
@@ -629,11 +631,15 @@ iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
 
 static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 {
-	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct socket *sock = tcp_sw_conn->sock;
 
+	/*
+	 * The iscsi transport class will make sure we are not called in
+	 * parallel with start, stop, bind and destroys. However, this can be
+	 * called twice if userspace does a stop then a destroy.
+	 */
 	if (!sock)
 		return;
 
@@ -649,9 +655,9 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 
 	iscsi_suspend_rx(conn);
 
-	spin_lock_bh(&session->frwd_lock);
+	mutex_lock(&tcp_sw_conn->sock_lock);
 	tcp_sw_conn->sock = NULL;
-	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&tcp_sw_conn->sock_lock);
 	sockfd_put(sock);
 }
 
@@ -703,7 +709,6 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 		       struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
 		       int is_leading)
 {
-	struct iscsi_session *session = cls_session->dd_data;
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
@@ -723,10 +728,10 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	if (err)
 		goto free_socket;
 
-	spin_lock_bh(&session->frwd_lock);
+	mutex_lock(&tcp_sw_conn->sock_lock);
 	/* bind iSCSI connection and socket */
 	tcp_sw_conn->sock = sock;
-	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&tcp_sw_conn->sock_lock);
 
 	/* setup Socket parameters */
 	sk = sock->sk;
@@ -763,8 +768,15 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		iscsi_set_param(cls_conn, param, buf, buflen);
+
+		mutex_lock(&tcp_sw_conn->sock_lock);
+		if (!tcp_sw_conn->sock) {
+			mutex_unlock(&tcp_sw_conn->sock_lock);
+			return -ENOTCONN;
+		}
 		tcp_sw_conn->sendpage = conn->datadgst_en ?
 			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
+		mutex_unlock(&tcp_sw_conn->sock_lock);
 		break;
 	case ISCSI_PARAM_MAX_R2T:
 		return iscsi_tcp_set_max_r2t(conn, buf);
@@ -789,14 +801,12 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	case ISCSI_PARAM_CONN_PORT:
 	case ISCSI_PARAM_CONN_ADDRESS:
 	case ISCSI_PARAM_LOCAL_PORT:
-		spin_lock_bh(&conn->session->frwd_lock);
-		if (!tcp_sw_conn || !tcp_sw_conn->sock) {
-			spin_unlock_bh(&conn->session->frwd_lock);
+		mutex_lock(&tcp_sw_conn->sock_lock);
+		sock = tcp_sw_conn->sock;
+		if (!sock) {
+			mutex_unlock(&tcp_sw_conn->sock_lock);
 			return -ENOTCONN;
 		}
-		sock = tcp_sw_conn->sock;
-		sock_hold(sock->sk);
-		spin_unlock_bh(&conn->session->frwd_lock);
 
 		if (param == ISCSI_PARAM_LOCAL_PORT)
 			rc = kernel_getsockname(sock,
@@ -804,7 +814,7 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 		else
 			rc = kernel_getpeername(sock,
 						(struct sockaddr *)&addr);
-		sock_put(sock->sk);
+		mutex_unlock(&tcp_sw_conn->sock_lock);
 		if (rc < 0)
 			return rc;
 
@@ -842,17 +852,25 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 		}
 		tcp_conn = conn->dd_data;
 		tcp_sw_conn = tcp_conn->dd_data;
+		/*
+		 * If the leadconn is bound then setup has completed and destroy
+		 * has not been run yet. Grab a ref to the conn incase a destroy
+		 * starts to run after we drop the fwrd_lock.
+		 */
+		iscsi_get_conn(conn->cls_conn);
+		spin_unlock_bh(&session->frwd_lock);
+
+		mutex_lock(&tcp_sw_conn->sock_lock);
 		sock = tcp_sw_conn->sock;
 		if (!sock) {
-			spin_unlock_bh(&session->frwd_lock);
+			mutex_unlock(&tcp_sw_conn->sock_lock);
+			iscsi_put_conn(conn->cls_conn);
 			return -ENOTCONN;
 		}
-		sock_hold(sock->sk);
-		spin_unlock_bh(&session->frwd_lock);
 
-		rc = kernel_getsockname(sock,
-					(struct sockaddr *)&addr);
-		sock_put(sock->sk);
+		rc = kernel_getsockname(sock, (struct sockaddr *)&addr);
+		mutex_unlock(&tcp_sw_conn->sock_lock);
+		iscsi_put_conn(conn->cls_conn);
 		if (rc < 0)
 			return rc;
 
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 850a018aefb9..230db7d62f67 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -28,6 +28,9 @@ struct iscsi_sw_tcp_send {
 
 struct iscsi_sw_tcp_conn {
 	struct socket		*sock;
+	/* Taken when accessing the sock from the netlink/sysfs interface */
+	struct mutex		sock_lock;
+
 	struct work_struct	recvwork;
 	bool			queue_recv;
 
-- 
2.18.2

