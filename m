Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D110C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3ABA61404
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhEYSUZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44092 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhEYSUR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:17 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEaU6124406;
        Tue, 25 May 2021 18:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ilX5dcSbBylgPZkS5WHSZzC6Y2p79IQNH+ZVqjPKU18=;
 b=d4Q97NmOFtN4O1zJU0FOQjwR3L91JZOYqOM6sQAV5IhiF/W3ljKApy16xJNYmYYnWkqy
 E9CmHI8A7ax52D4Bi57XYT3rDdc/nfVp+Qe0isdDzxldMddOjp2f5qJhauAiVkNnPUIA
 +Z1ME1Xkcueulx7zXU7an7XEyyrXiPGhcLzrgYw1gtsKuYg9FkYMjfmlbfYdBv+Y6ooV
 02JHhVBdvUzlrlra1JkUDbmnYsZtWb5JP2ITE7x2DTZKNAcyA0kk4pzBcqaWL0InMcqi
 1at9bLZBAcNlhWOPhi+BoDcHosQQnaQl+9BBJYDoRw2Ueq/0fBwKK8SSO3+dYGOUZYI+ Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfceyrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIGD3J010875;
        Tue, 25 May 2021 18:18:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3020.oracle.com with ESMTP id 38qbqsggxf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLGuJero1Z8J7TdX2Sr+qPFBsfrShblhnSI9EJAAi41skRGPxqTqiojNo1AvNVmgDEg1eqVd8iJ943DaJ5vyt//XPHf452+36aiyh+wOyfVzqmzoZzxn7vLXJePUHgMfUe0Lst4RdLqQfULMJGTOq2S44dvc2PEPHwRhhZHWHIBHXM6FWjT71AvcFIvQBlbZAASFB3uMqX4B+6MnGgPkV1fHzpRmQgQo+I6ve6/yv+SbDhqRrbNNNLXCWsJ83zU4qaAJswX6KXOcUHvC+uMXJrTEj2U3FcJ5QGu0/p5FgLVY0W9EoDYFfY+4VKgKDcgLlZ1mbtK9Jwap6EaXCWMRKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilX5dcSbBylgPZkS5WHSZzC6Y2p79IQNH+ZVqjPKU18=;
 b=YbYXcpeZuM6FpWPcg5Na2DMklD/R7HXskJ2y3PWt8olZjLYkALgLDyaapcXw12yV+5FHgGSIPHn6wBzkAh70Z0Hpuhw0Jc8qHos06kSfz/vck5VLnv4011z5pSgtYx4CuFwzC4GijmxRsChKM3kLZ830CfwGIV1ai8dNi3IaiYbQrVyUKNNflEF+MmiUJnc9SLaBHtNW/ScoiIEdMBPtZc5XJTWsQaq/D7J7D04anFXpIyv/IXsDpkxsKPfAn/4dLHk1SL0+Q7HwALyOyhk2z2GtO2xREtHRxKCwAfRAQ+lsdtniqDv+fnNhIRmOZrsVCJ+vZqPlWtXJgipGVQlf9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilX5dcSbBylgPZkS5WHSZzC6Y2p79IQNH+ZVqjPKU18=;
 b=shTTBmF7xTuNpL4cv7lKWOjmUEgb0jTDCwouq7LwoTL16O2YxUslplhkGMmZ2ag/0zAVpULnh+MWvvBpNjLN2lFHOUGUqhNVtaw15NHSRSB2tXErE6PXmWrrcaLW7O4VdvMzUcRYFd/W6B7xaYjVHYXguUB0B0kV/OGVmxoJohk=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:37 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 08/28] scsi: iscsi_tcp: Set no linger
Date:   Tue, 25 May 2021 13:18:01 -0500
Message-Id: <20210525181821.7617-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5960a67-9efe-44aa-23c4-08d91fa98402
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB476730D4DFAFF4F747F723A1F1259@SJ0PR10MB4767.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZqj7YxXdNVqKqWdZX2hg1kidjKbEjLiCjRuZpPmvMz115OImLSefQ3RROHuzMeEJ7gjQq2S68L4IK/3R83jlw7XpQUmISLE5jO/x0AD4Kw9tXd5vr/3O4/vfKpxUom82HhU5mLdLwEwI8w7JWbaMCJn6ecAS/99iS4YeI8eBeoQPlEQhTOwl4N+mGRXg6r0qXKBKX9Ld+t3+dzTrinoVVc1igv4xIiC/5V2Yrl9hdHs7cU7O/Qt8txcugJk/P/TXzGz23+b5bOrSCwLGQn5y2sLazFXg67okeWSAsMcaHjpQcDXiwwBFqps/rRPPmJKY7mx1PYLFBZ9HC7XbDwtjGAecidjw3+kiA+N1xBpNdDPYhafa1qz8SaOqE4Q/3ajdlWcGWg3aO/yESVjj7whZ0Px11uCa15JiawVjJ6uc98DOOf5Gew1ZWQDL7GuPLN+LfhOuEpAhFfRYqDCx42G4jKo7/ZM6WtDBYw9Y50csXP8TKymK3AQbTp7jg7qlOA56VKTma5smsaMym4DCPrzxsMDrwkCHng0uZQ7/kHJhFiXkOjGE+DoYrIs51ZDz9K/rvAj7b65kBCo9RWzU0YkM4p6Z+LHwbm0tFHY6RwPlOxB2C54pUjbHYWilujTYfo387R8DKBpIkhWXpULy0PBWknQ9L940HUzJiaVOVfwkf34+pQGzB6mu8ngTOxd0XQb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(38100700002)(83380400001)(6512007)(26005)(1076003)(4326008)(5660300002)(956004)(6486002)(6666004)(2616005)(38350700002)(86362001)(107886003)(36756003)(8676002)(16526019)(8936002)(66476007)(2906002)(66946007)(52116002)(6506007)(316002)(66556008)(478600001)(186003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SGMsCw1CxPJg4mAImcQAcrVG2hpTZGAHtFgoUE5Dvv2k2nkrMv54cYmww2Yn?=
 =?us-ascii?Q?GNKPnYqcrocLIwOnc4Iii0fYnWJeSY+ynsj3sLeMy0Zrvc1Ls8jq2f/wWpmh?=
 =?us-ascii?Q?YP/TB7cr7ZhW1s1icg9qZjNEz2Hb/GbQs68bZRUN1hLpOQpQLUxZwHx9Y5MR?=
 =?us-ascii?Q?OxGxauCZZx4sjkUxN4dWuXckAx4RohXXzt8dYzRfcmPAWkxzd4kPGSxf7pIh?=
 =?us-ascii?Q?Aogz82knf0qLiuBPONFyn0pQYaoj59VL2iByalx2rKGEjRyMe9EhgjTqqipi?=
 =?us-ascii?Q?lOQ77hEacAChOSdpfUjYveJd0JGqkM3z9wSKRJEVAdlx/uD3Wv/+Lq8aWvup?=
 =?us-ascii?Q?wOf9INgqVYPiao0rRVGj/3XWNmRAUQABq9SKdgOCtbkylrJ7AuXyZx00rogg?=
 =?us-ascii?Q?paCnLaEPpv1Ja4ORDrUom8ZMFHqp2e1S9lhiTKuvblhApFO4CFcq2SWnnzgi?=
 =?us-ascii?Q?++SRB+UI2dxh99ThomQnRum4n/oPO4xcOxVCJwAIkqv6OYPuTu0BOBLWWc93?=
 =?us-ascii?Q?bT4Bb40Dzx5uzQuOL1Q4R1IHmvubU26NdS5edIpJSaUZw8Bp7DVuSURAJK0e?=
 =?us-ascii?Q?JruRSu6uB5Jzs9odBQg27/u08M+ddzh4FLu5PTQdf7TGbpQOQ0vqldGEdqlm?=
 =?us-ascii?Q?XMQ2xsCyKYegK8fLSDenqZWpf7uMYzRCCQIpA/jnnIR5DRuqprZFVLWPqFhr?=
 =?us-ascii?Q?9v+bCYMP9EQWGSg7OFp2GRX/MpMw+ZXFezB4AEudXPXWSAkDuEwLxdO0LgBu?=
 =?us-ascii?Q?gjvdA9hB/YR9QhYh9FDaOijXkq6c32G6Jmvgb/yb97RjX3l4TEaFXWhSeUbn?=
 =?us-ascii?Q?3oGo+T+ofysYBRsog2Z9uBGCvg62dS2LTc6PMt7jnX979Gz0HsZ19SkQAad9?=
 =?us-ascii?Q?MZ8WFe2l7CUwT5Jjnite3+eXwMtBxs5drkoqJGsWLlWbXTf2RWCpjZ1F/k9h?=
 =?us-ascii?Q?bpcYW403F5qWcP0t/WLIP+p14wg9AwqJ4F6Ic+VIqd2K2zY0InpGdCiNQAdz?=
 =?us-ascii?Q?dKLRYHG7Lc/rRjnHrkj//NBYOspTT8ag3GJgxIQPFObGTi7mucsv82Lm1/QQ?=
 =?us-ascii?Q?lZ2eb5ts8XOBB1wj0Ju2nUpm2+hSijfL/5caMujNmfF3QW4+bmmFZ1VWIGV9?=
 =?us-ascii?Q?kgeZcg2r1zSkcceCvBbyQtlrxpohpiFFzHws8lvn9NwVFse6/WklUXbCJ3KS?=
 =?us-ascii?Q?cRzjFdfvE+5W0AeZzRx5xDiUk9AW/Kcn892VlkxVxBLy3WvnLK5BnMjayjKH?=
 =?us-ascii?Q?06psQJ1b+MkMVwwyYULOY/Hk+S1bA/FmvSwDgy3IUcSBB6SH6nG4iwWXIwb6?=
 =?us-ascii?Q?+LxrHJ9sjX5HMpFfPj91NN9U?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5960a67-9efe-44aa-23c4-08d91fa98402
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:37.6301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DaFmHgidiRuQ43PvGVoJmYdf0uz/78racQ6Pfqxe6ahcI+qbz6l7k2gSTb2CSfISx0nwzExCM6o9145Dt8PVbHw7xxWIAezjLfAU8iIt5EE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: ox91m0gFclK86v_U4zgCSqsT9d8-j6_y
X-Proofpoint-GUID: ox91m0gFclK86v_U4zgCSqsT9d8-j6_y
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Userspace (open-iscsi based tools at least) sets no linger on the socket
to prevent stale data from being sent. However, with the in kernel cleanup
if userspace is not up the sockfd_put will release the socket without
having set that sockopt.

iscsid sets that opt at socket close time, but it seems ok to set this at
setup time in the kernel for all tools.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index dd33ce0e3737..553e95ad6197 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -689,6 +689,7 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	sk->sk_sndtimeo = 15 * HZ; /* FIXME: make it configurable */
 	sk->sk_allocation = GFP_ATOMIC;
 	sk_set_memalloc(sk);
+	sock_no_linger(sk);
 
 	iscsi_sw_tcp_conn_set_callbacks(conn);
 	tcp_sw_conn->sendpage = tcp_sw_conn->sock->ops->sendpage;
-- 
2.25.1

