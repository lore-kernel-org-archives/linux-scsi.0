Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C850C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6409B611CE
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhDKH4c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 03:56:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33508 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbhDKH4a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 03:56:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7o2Ha044069;
        Sun, 11 Apr 2021 07:56:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=W2lYpb7y6ya5D8LbWo7OmUde00ED7kFeyWaNlmOK44k=;
 b=YiQUE6USe8tRNscFDLdYH+r6joKn+hA0xMpQQ4ra5MfzpNwu8WRYWnb6ZTJfau6DYkDU
 D6/7yxIRsEguYX8K8O21mYbYsSSSUA+KttHMUOpLT+HsxRfXLxDD3ks3Wl3E/+zYgIHz
 fMDRFToVxo5qCQ+zKE94GcNjJVIa2e70i/lEJC7EBAfg7npiU5XzehiUe/vsLvweJYpk
 rldQ4OjtrERy34ouWkw9KGQWLXOK5ATsbzEFZUz1dqL0mpTvLuQUj7fYIlv22ySGXm1S
 eimiDRt2Q7Q4KBM9hshOFy3B9zMuPLibMipsBz1cMA6xttHNwPxGPp/R3oCY17dGQjP9 7A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37u3ym99sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:56:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7tK7T052414;
        Sun, 11 Apr 2021 07:56:01 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by userp3020.oracle.com with ESMTP id 37unsprjdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:56:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmgKsxMmE52swOsq0qssM2SMxihmaE+IVHhUQixe6cNI8QQyksEXji2IizRgCYRtJ/wmtvND1vDylLoyEzMvL5aboF6zWD2+TVfzpYIurR1hTTqwe2BW/KmwdraBs1K7BG8uOB3+x2CUBLdeZN4gLBquFeuSatDE1pnegui+hYvSLSxrc0tereTv7d8ZohCxquUJSbURRMq8cuYsLMYILwk46/Rp1p/d8aCAjfCiMor9NnE2UazQK3gW4Grzr17cbVwoTUIFLXvrlT3J440M+uc/PbH3IDurCiKTzIVp8tdk/bsP+YQNud2GfwRxyt0D5yrAaZWT8i7PqdaU7PuDcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2lYpb7y6ya5D8LbWo7OmUde00ED7kFeyWaNlmOK44k=;
 b=NwnguIP+JA91xpoWDqppZH1BKZpf5csPUqwFY1zcPQgWbtg8PB75juHPdMtL2BBqNbe2EhpKei7xstBTHF4w+vsrct+EF/lynsI5aCOocQ0uN1FWSjW57JnrUIEd90tcCsYU8LQ8Vt1xXKJZ/P9bveygULcRfw53mxl+EFdZ+uwbE++lPf76g8CiP6AFrQ66gGRMJodFPYTdUahzb/FjiIioPH/JiUNYBAVnrvv1Djqwvm8p1p8+xk8WjFqEy+3ZxQPYR091tJoPQI+tAfY3L06jMpjCcEvg48F2VaR7i1zRD04hfLXF9Ohof/6iXk25myiITw+OOv03nF+RcrwVlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2lYpb7y6ya5D8LbWo7OmUde00ED7kFeyWaNlmOK44k=;
 b=TwyWIvsU8/oa2ZI/QI6yczzavJhwGV6AIYS3nzxGHzNO2O0A78PBj4PcI3b/UCKyh2CUU+pckqrQbBAwhA0WcI6ID54kQPqQL8hVLRSgK0C3ps+IziHb1TGq5DHd9lqfQrX882kx4HdK8JfUgNOmXafJR4PCYNQJIIg4gmjik+0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3842.namprd10.prod.outlook.com (2603:10b6:a03:1f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Sun, 11 Apr
 2021 07:55:59 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sun, 11 Apr 2021
 07:55:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC 6/7] scsi: iscsi: remove conn_mutex
Date:   Sun, 11 Apr 2021 02:55:44 -0500
Message-Id: <20210411075545.27866-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411075545.27866-1-michael.christie@oracle.com>
References: <20210411075545.27866-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR18CA0010.namprd18.prod.outlook.com
 (2603:10b6:5:15b::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR18CA0010.namprd18.prod.outlook.com (2603:10b6:5:15b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Sun, 11 Apr 2021 07:55:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96e56dbc-617e-4e88-3b29-08d8fcbf3ec3
X-MS-TrafficTypeDiagnostic: BY5PR10MB3842:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3842DCE54DA8ECAD67902CD0F1719@BY5PR10MB3842.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:83;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ucnBXdkEypZPmwecjPgujsowM/ziJ0znBg2nhJHz2wQptkVGvYoWJC5Npwr8rXnK0o6Or59/T7iFe0vVd/5V6qL2+8BMhMYP/l9+TSZyV9eVqYKUZ3aoNkFfnXN96SImY8MnNVX9IUESaMpWsWx/6QIoyJR4A9gEsk2FK9KAJdTC/4JvlN/efou4fgPWHwMhC6p7yX4F7X/dNiX9cywNP91h+zmOfW3IdbCl4EX1Rj3uR5hTL4xvBvwxeZxP965x1cd08clTJbs1OLTGehznKq3y0HHm0WN5Z66N3up3kB4OkK9DwM+speoZwOd7XQ6R2myJymQlgVK1Zmt0lVyE2HMKfkwk6TS9xMQUeaCywkHfk9Tdbr6j15zK9Kagqx57t7a5AecOe32aNxWn4vYbHPh/yrfXIxlkZ7eMfbit9ZL2Ph1jQo23qatT6kPp9XyZ/0KOcvZTQutcHyvLww++jtRWJZpnmdbd5/na4Chevahk+2pIBWTTtSqIYEGFag5rFQ6MYtn1YFAceDkO6VIffkr9z4FAayb//JCOgidgUYlzLw2nlbwfPYVcbyUQ/W9lB7WVwj89AJ7OHPrysWn+VtdQC4U3QP0HBkPN57H7FZNGXAnUEe+Absp6nnFeK61F/8kL6RwLrY9uTvc0SgDhMzlmNC3w/GDF7rmNBBLCVbTx20f9eDcPoAXzpK6Qx6EF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(8936002)(16526019)(6486002)(316002)(66476007)(6506007)(956004)(2906002)(8676002)(2616005)(26005)(5660300002)(6666004)(86362001)(38350700002)(52116002)(38100700002)(69590400012)(186003)(66946007)(1076003)(83380400001)(36756003)(6512007)(107886003)(478600001)(4326008)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?l8Yxff90uH4m23ssbR5FiLQpvv4W79WpVksbVeQZN5TFPqIrBax6vAPGW7Hh?=
 =?us-ascii?Q?7AXig0IEiG3SjzaZMKL4RHhXMJWIXLmd3lxmgtmd6fb0RUdx4J815XefA4V4?=
 =?us-ascii?Q?AHeHscTtNxBcrCeuPjjIt2kMk4OtFIJMxU2T4xKearrxfHFCapQ415ZQsFE1?=
 =?us-ascii?Q?/3IM5WlblgBflq3NooWUttlXivHhXpCFxAnAklzdE3+8aWJLu3t0jRs4xiSI?=
 =?us-ascii?Q?Roj2P4r6W6mchfeU8uOHZYXTHGMkieVxVXx1yKV5uyclzNXWHr+FlQkIoi/o?=
 =?us-ascii?Q?ngefrwD1kcvXIR6HI2uxrx3lb4QRW08v5cNcyxw/Jnt73r/hXt+glDjh9rhn?=
 =?us-ascii?Q?v5tGo3qeLfXNcIDTCdCf0zKSUc8H7rk4bw2S3cA/BJcpxJ5AQPcOKjiT3oxS?=
 =?us-ascii?Q?VVWwS4zxr6bwwBFst0ZahlHa/aukkSvH0BBuZbXT/ynMUuwUpMQ/0lxR2n12?=
 =?us-ascii?Q?PXZT/x1nvOqhxLdhvVwVH7u4yxv5+WuB7StmYVZkePeejnYenZs4YHHWsyN6?=
 =?us-ascii?Q?W1tjYQc4yOKfYQ09J0fOnoFi6+pzz1el8H+ADi0P5PsFDTK6t8CUDZw8FlPY?=
 =?us-ascii?Q?VmVvee4JyH8ORQK+MjL8iCa1+FKaVDNOGwXJJPzIU8wLA57xUNMZNzRRyxFJ?=
 =?us-ascii?Q?cMcFo2sCv5fxpKce7rgl2z1qX/x1KGSDvKUzmk4/WlwvmPOTeOaude/LT4uJ?=
 =?us-ascii?Q?DYHeCPHIqhXz1XmVC7u9rxdYrqVcgG6lV/oV+ONABsgZbeIVXUvqOr1ghfX/?=
 =?us-ascii?Q?VbXcOpgYduc0xSastFzAq5gnxDutiJM9Ffazr1TjiyDK5aS7qBl77jcHKp5k?=
 =?us-ascii?Q?kbxwJ4n/CGfWOkn18m/dPPv+rYwWFncQBEqUq7DXizb5W7cLzGMTJPvW144f?=
 =?us-ascii?Q?Hs4KvjLbifHWB35X98xYvnz4/zSjxNYMLwFZ5hp4fWleZQNlfrkB3az+w6LS?=
 =?us-ascii?Q?SI1PApWZ7gxdUvo4UfF5MVlw2SPY2J8ktyuzl2pLzjUvJgFXX64pzhHFXmM2?=
 =?us-ascii?Q?+t3UBKod+6h3lnkQ/sJ9uztqgS5Oh+GUBuXbfAGQPFuSgAp7a36I4gQv9RVj?=
 =?us-ascii?Q?lL8dslqZnZKO0vyIhEkJFMK02QpeGZiyU/5JU2AysJ/8s8yPfcEsoL9hpAh5?=
 =?us-ascii?Q?qz1sNZLbQgKgmEMg4eMSwzofNmoty0emJlMnm7NnrQTBmlaujEQP4qbLipLo?=
 =?us-ascii?Q?oQ/pJHQXyJkPMQm+NdBblLaf0zzPrIYQUL5BiGiyWTIk7eAT7T17NMIujKRS?=
 =?us-ascii?Q?4O5OAaApDQyQRP0/XC/eY2PqnfZW7E6MlSiyUgjPjIUrwt/tlWsDhf4BwJCD?=
 =?us-ascii?Q?YipeqJvVbzXUebMe4gEOXulN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e56dbc-617e-4e88-3b29-08d8fcbf3ec3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 07:55:59.6859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y0wLkxcZE9CtnmVr4gwQ7bCCi/Mx1Y/5EMd14U7W78/6r5ZiG4R6Y6zvpfd6muwpNdkZpuZ0CcdylTVbSjCQ4Fyke25HYv4AgC8r/hd4M8c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3842
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110060
X-Proofpoint-GUID: H3OP8MWBHy9mxsuTo7lofIv_7mDqKfKy
X-Proofpoint-ORIG-GUID: H3OP8MWBHy9mxsuTo7lofIv_7mDqKfKy
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104110059
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't need the conn mutex now because conn stop and ep_disconnect wait
for kernel conn_stop/ep_disconnects.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index da9fce1dceeb..ed69449166ae 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1619,12 +1619,6 @@ static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
 static struct sock *nls;
 static DEFINE_MUTEX(rx_queue_mutex);
 
-/*
- * conn_mutex protects the {start,bind,stop,destroy}_conn from racing
- * against the kernel stop_connection recovery mechanism
- */
-static DEFINE_MUTEX(conn_mutex);
-
 static LIST_HEAD(sesslist);
 static DEFINE_SPINLOCK(sesslock);
 static LIST_HEAD(connlist);
@@ -2886,11 +2880,8 @@ iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev
 
 	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
 
-	mutex_lock(&conn_mutex);
 	if (transport->destroy_conn)
 		transport->destroy_conn(conn);
-	mutex_unlock(&conn_mutex);
-
 	return 0;
 }
 
@@ -3773,13 +3764,11 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 			break;
 		}
 
-		mutex_lock(&conn_mutex);
 		ev->r.retcode =	transport->bind_conn(session, conn,
 						ev->u.b_conn.transport_eph,
 						ev->u.b_conn.is_leading);
 		if (!ev->r.retcode)
 			conn->state = ISCSI_CONN_BOUND;
-		mutex_unlock(&conn_mutex);
 
 		if (ev->r.retcode || !transport->ep_connect)
 			break;
@@ -3802,11 +3791,9 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 	case ISCSI_UEVENT_START_CONN:
 		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
 		if (conn) {
-			mutex_lock(&conn_mutex);
 			ev->r.retcode = transport->start_conn(conn);
 			if (!ev->r.retcode)
 				conn->state = ISCSI_CONN_UP;
-			mutex_unlock(&conn_mutex);
 		}
 		else
 			err = -EINVAL;
@@ -3829,14 +3816,11 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 
 		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
 		if (conn) {
-			mutex_lock(&conn_mutex);
 			ev->r.retcode =	transport->send_pdu(conn,
 				(struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
 				(char*)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
 				ev->u.send_pdu.data_size);
-			mutex_unlock(&conn_mutex);
-		}
-		else
+		} else
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_GET_STATS:
-- 
2.25.1

