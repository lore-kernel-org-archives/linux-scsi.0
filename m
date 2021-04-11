Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B253EC433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CE49611CE
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhDKH4f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 03:56:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60022 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbhDKH4b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 03:56:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7o2em179536;
        Sun, 11 Apr 2021 07:56:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=O6WU8eAW/GJr5OBTDdGJcCpauGfVJdyaQ3bf28O92DM=;
 b=eZeuV9UN0NNi02yvNs9m0zIGwjKTS4e7cF2roySjol9DxtJ++coaAyo4/yVPqpijsn+5
 ttvPYZgvcaUBetlHzYiHKljwpGIPjbMgNdEpebOUGFG62QFZqWlmBck9dX537tTKQ647
 2s0bGf+NTc0Qx80a8ySn+Y2XofdBZSWtIc1xxwWGa374p/NQlyjOQ0Eg3qQLjRNWio4C
 7vJRVie1l3+AT8+Hw4ttzcvGNL/PpSYK1qEmzGu5dT849A4hkEB7byRgUpBTjIN0AMNP
 4t7yEDOfql5GzYLEKlmbfQuZws1YeTjoon3w5Yseci1vjW1qfqiSGmd9inubxndFdqBs XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37u3er9am2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:56:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7tK7U052414;
        Sun, 11 Apr 2021 07:56:02 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by userp3020.oracle.com with ESMTP id 37unsprjdy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:56:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQ/Q5iVZuhtMvbxuxmtkw8/b03ovx+eJ+8Tz4abFEZCgmEmdeGEbYkzn7YBLfcKUvBja0LqOD7m4esnk8Dy4gCvAq0yl31efgjof2NTTwqPZxOjEwgFUMy+ByiLog8XkuWFNb+snRjIIiGOv+bWmXP4Ptbtg7qTHmOCOkUx86RhzKdZmWUopVu8KVDt6czPAdowA7JcrjGIOx7vv+zSicUI6qa7JaQyYw3B9EWsMGiAtRlbWHHm9zws6Lx7Yr1JMneBbsnYe6pX3n+SKM+wZQcDzU5ZP1D4TLhonLk+nmckrYyb61Al/h5+WS8MBXBLe8/XiS/TdB7Jp5qYZHmz9bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6WU8eAW/GJr5OBTDdGJcCpauGfVJdyaQ3bf28O92DM=;
 b=m2xP+1+OWK1F4rDjTnQK2ZcnBRz4FCuPpPiEb0xNYtGxjdVbttJxecBMqMzQAr0uPlP0xVpPp3FVKkwRfCRB49BWgFHYdEVntCckkALdMXcijSaYHOHCiU3db4cLIDUmOdu294/u/xATzN34aWI63vZ4G5pMR6cHZxeBT9wZKLVlciUzi/dXquGEG1Ft/egIqGPdFLFpBC7E1/ZS5ApkEGGDn+aSkwHk85KY/sY1CwdB0Pi2ktG2rOsh00krRTK9No7CRwvl18qB+B+5/dcifeHiJzwSDJRAdRTGWJGjFqlbOWL5e8mdxmLfvWxIR04Tkmaftv1cmOHAl97pOLaU1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6WU8eAW/GJr5OBTDdGJcCpauGfVJdyaQ3bf28O92DM=;
 b=lmz3HoOwkwZYZwQ8p9lYPeEbcPWvXZ+5vdh3invowAKyZKRY/WQquB6shLVfLcRkKmKDmewPc1sRiWn435m5GxlnontcIh/rllwVJkstH5+w5Jz7nM+0RMuJj803Bq2m61U7rMx+Y5UN4tJyTFDKxtX1xb2WdIvR5PvCFHM+QQE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3842.namprd10.prod.outlook.com (2603:10b6:a03:1f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Sun, 11 Apr
 2021 07:56:00 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sun, 11 Apr 2021
 07:56:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC 7/7] scsi: iscsi_tcp: set no linger
Date:   Sun, 11 Apr 2021 02:55:45 -0500
Message-Id: <20210411075545.27866-8-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR18CA0010.namprd18.prod.outlook.com (2603:10b6:5:15b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Sun, 11 Apr 2021 07:55:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 502a4c4c-0b6a-4a60-00c3-08d8fcbf3f60
X-MS-TrafficTypeDiagnostic: BY5PR10MB3842:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB38421C5003DA49B540BF4577F1719@BY5PR10MB3842.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pEGwPhtJzIiQC2q77PxPfaQ9lLCbWP3OU9MoTlMmAX+SdXXVWFpvIauRj0X3rW/7WpKDG+PvUdas7CfTsv1t/+rEtHOG9friSGbzZchVPx4sXr599G5sFa0t0GDceG0BtgTMlerdWO+XEsMHy3qeLbYVZer+fj5Qmn7DFRq3AjPDalYhBfdI9ZBZDPr/c6+V2uHO3A0mt9oVn5ab1Mcf2QgVlNlsfPfY5KBFVESReCUbB6ipkTytLmwMCi/ysdDsJmFZInC+ar9N6JyPpiZCJCW/Gy51/EmoPe2j4QExA4AFL8HXEVLG0Fnlwy6KxBupcDz3HAKe+2XywJTA4fQQuLoI+aTrF6TS6iSZwVZcnLzdnZoDbubkOlJuVemPsPOuP9JF9qHCjc3A/OoA/Mf8MJutMBenZXfAltBpLymPBworBNFlPirfwESkMxg6yhxVpm4sLQAYk7glEJacHpYwFccnNsJgC0FYRO0Ndcdd8iUVKDmcsvSx69wErjQIXJPSSeKOd+mFaG80mVxQX4QGUlSGnXpr4ixDkCcm/WafeP34z3LxgLRVBjCee986QgPwKHGCKAhvg90knMdUpeHz9R4X3idzFsmNXJcY9220FB1OxfSbBYwaYLw9vxp4niAjtGkuYMjNtk0JqSut17Bp1P4P5wSoKEKO+OtavzRNMTQUjHX4kFRG/uYK03/+/6A5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(8936002)(16526019)(6486002)(316002)(66476007)(6506007)(956004)(2906002)(8676002)(2616005)(26005)(5660300002)(6666004)(86362001)(38350700002)(52116002)(38100700002)(69590400012)(186003)(66946007)(1076003)(83380400001)(36756003)(6512007)(107886003)(478600001)(4326008)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?n+p4PuSXPdITnbTGIncmdlXTjEx7wkwnGDjchJPY/R9WW7bfcMSBf7dFpXSB?=
 =?us-ascii?Q?fMk9y3tkkx/qWkvcpaH5/rIKdVb68zdnz08iaeT0XysyS+FuYCbWZDRh52HK?=
 =?us-ascii?Q?Zmm7+ibpqbrHIrKXA554yvKlNwzCzl0UIRQieLjkifVmUC1umVyysm8TZWuQ?=
 =?us-ascii?Q?PAHfT50jeuTIwCzXThAaPx4z2w2g707pDefOd0GZ9ZIEHuXSQzBK2t9vvFZx?=
 =?us-ascii?Q?8zSS81kTPi3YaTxSGMGXbw4LWBO29+YbICYCM0GOrXi1BlAr/IY8diH7X3h5?=
 =?us-ascii?Q?FfXbUb+2ptrnvSK7MXUbOGfH96ez/qXRZiYGqfj6DLB2+7sB4+E+TgTHAHst?=
 =?us-ascii?Q?jo7JUVw9Hhq0ObcKNO2Xo0I5klYKo1YNbWZfQ4+8YbFTHcZtou1mpOsOpwqB?=
 =?us-ascii?Q?1B/4gpDunriB9hIBOcfTWs9SRVYmXt5U1aMerKBVys+1kYuRTpfUX6jJYuYK?=
 =?us-ascii?Q?0198dgOVSW1R/gx99sVpJKezseKT8EjgfqpkkI37VbCpg3s9VUdOlct0s4XO?=
 =?us-ascii?Q?uYwEGCQFySK3nRjNnHAeHkztMG+w42YZ3mQhsksgbnVR54f+ieCyVsJjGSV7?=
 =?us-ascii?Q?pSnILyL+Poox2bIIZNZIquBqQtwIVST1Zz0uqEN9xHuLPuyt+rJq2iVQbNwQ?=
 =?us-ascii?Q?oMCz7Ay+XKKT4tyYfuenrN1OSwoSupacq+HU+0c8k2uw7QWrtmY92qIiHSHd?=
 =?us-ascii?Q?vASSSSLVns2sKTUjXHLnAeYLt8LC8D1HBRvZ1REoJ4Z03uDuYqYSogU9eKMY?=
 =?us-ascii?Q?yfecLOeTyFbrc4gIRs47asMNrQQMpi3Z0us4F9N85etWz6AhkfRLy+u9Xvgb?=
 =?us-ascii?Q?RlomyY2QFRAXt3MgElDw9yo/F9zjPB7zbehfJuJ6YmJhLX4QICruZe95fGHB?=
 =?us-ascii?Q?GCwaXBItEAz9k/BIyimhKQDJRMexfKwqrdIn9gkyVB6wv309ynicUEt/PlLR?=
 =?us-ascii?Q?7fFPuqNfKcJqMrDH607GYD7BTONXF9in+i2Hk0zxfMjZcueVVYwIXdsfmlwB?=
 =?us-ascii?Q?36+vNMRxKEFcMmi7tXdwJTgzEAL4MCQyPqDExWLxSPCC14+cAfcaDpz6tBHk?=
 =?us-ascii?Q?khordxO75OCZH+5viq+jLdm/GiixXoQT5YhPECuNG4UTRPUYkiHfEL5TpxYh?=
 =?us-ascii?Q?srQniM1wi7EE/lVZEJoHfFx+sPlVUyzApzqnTmlYme6pY5t8VQxKCfI6vHCf?=
 =?us-ascii?Q?3M4AmIhpL7Kxlyz71gRTlsJV0AEyrFStf19XojTJb1FvTql5e6h/uzKNWKXY?=
 =?us-ascii?Q?Rt98MRTJovX03QknhMRc+CpxbZJb4EoyxwuXl2gMab017P5QVDaz8qhrXTlY?=
 =?us-ascii?Q?LbipIeaJUQ8uivuln2TVnMCU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 502a4c4c-0b6a-4a60-00c3-08d8fcbf3f60
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 07:56:00.7573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Exs0xUIjkPZ6U3EUbIPYM7DnvOpxUBPonWLTROOUL8URemMsu16LVdltOIzflyH7ir9ak8nHbkhEOpPoxXsBWuHU+JCEhTrI/hppctCY2UQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3842
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110060
X-Proofpoint-ORIG-GUID: Ou4Eew35rtLCWKoPzZaBtVrfAOMxAI6x
X-Proofpoint-GUID: Ou4Eew35rtLCWKoPzZaBtVrfAOMxAI6x
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104110059
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Userspace (open-iscsi based tools at least) sets no linger on the socket
to prevent stale data from being sent. However, with the in kernel cleanup
if userspace is not up the sockfd_put will release the socket without
having set that sockopt.

iscsid sets that opt at socket close time, but it seems ok to set this at
setup time in the kernel for all tools. And, if we are only doing the in
kernel cleanup initially because iscsid is down that sockopt gets used.

Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
kernel space")
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

