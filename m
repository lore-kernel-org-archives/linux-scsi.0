Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F0FC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E17CB6120A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbhDLAvd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 20:51:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50474 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbhDLAvb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 20:51:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0nfRp072820;
        Mon, 12 Apr 2021 00:51:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=r7lGCJ9gQ3/dwuXbOcD8imlS9kd14qZ2OmO7vMUWvBw=;
 b=HKcogu7YQiYjDA1WsOu4I3boKIQ34iVg2P3JViMNZ1tz/3gcvR1O00YCJZLeJzfHtyUQ
 a2of96PlQRbJ+dJpgbwqgjxB/c/A5LbLHofZmsmN6WhbFhw9KO0c+M5yroFvcyaFqFSw
 sUeuxmKpSiMeuPweT8zoiUpb4q/N4HVV+uPzs097tIBjBGflXReJtyrWRFherbeTmUlG
 sSwQwRu8boskYnMqTnmpCNsjycWLgi92Kn7HmOmkIup+MEhUWxWK4djhJ7YipzJKhQIA
 0fACaAVqUIjIqhGC8MnIRIuMLqX0Y2tZkGhs4I93DsK74CD8GM27eT2LKKS5AcKQTsMQ CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37u4nn9ypm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:51:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0aGvH037388;
        Mon, 12 Apr 2021 00:51:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3030.oracle.com with ESMTP id 37unxur477-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:51:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3Am1PIYbs5n+Rt0v03VTIxmreWwnNr3PzsUslcLL+35VL/BpZGi1pQfZ5G1AunzuM5ZEyJ5pX3hhiE5DbiTnqdX7OVKZACwxOYbZptlt9s09SfMw38KD5f6ctpWnyNZbrlGpp43ogxjJyeyGQgsH+ZErrKSF1Gj6bR4uqQTUm7Lgmt8m3QkyjOtO0mPqBsGkl10S/TW98A9EU0k92n+j7MvCSMunX0X5f2B/2TQwO0f9VQU6kwHVgLgPbo0RffJcCQkEDjmP1ljR2u/K+uUTfNogKtbqra9J2aEzqqqmYveHgVI8m8Ku720nYoTg3IUaGuRcGh/zWWSTCXW52B9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7lGCJ9gQ3/dwuXbOcD8imlS9kd14qZ2OmO7vMUWvBw=;
 b=YGFjQDgYw9EeH+O/P+4UzwIYokZBFAkRMxM7PWSLrGWKy9rNXfrCJrC0cCgdIoI4p4E7FC0bE6p3UxZzjQPa3INvlMgbCmXFm6gqcXmhAAGY5bVADN8jWMs7LiE8aYA+mdPYOMHx/bbsJ3RHPOlVrbeoaw46mZDm8Zvp8x+I8HljOqM/oBdqTL0F4BNw9uwMByJr95TXLfXn2lzirEE1EIsbqrg/E+iqVWG95yb3xrjiIpZK+Cva9HmugbIgiBAwSpm89KRb4t5psQpv4hx31jIRdja7OF1vR9dha4vwJpc2KNO4uZ7nVLazXlGA0luhyT15O8Z5zVgMJZ7Wr2Sq9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7lGCJ9gQ3/dwuXbOcD8imlS9kd14qZ2OmO7vMUWvBw=;
 b=SlB77GEbTQsl7m3K7q3oSPaCVo9uiu9gfRZlNduYznTPZZT5SNymmhC8WgCB+gAsekZjKCZk4gkgoah0o8zyPHGGjkRCpPlIA3rydkv3AGPfZKD1lqbtRQHMr/0gNpKB9UXyPYtMy0ysJHUkUvR5cgOAmW/hT0dpyDmXSmK1PeU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4307.namprd10.prod.outlook.com (2603:10b6:a03:212::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 00:50:58 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Mon, 12 Apr 2021
 00:50:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC v2 6/7] scsi: iscsi_tcp: set no linger
Date:   Sun, 11 Apr 2021 19:50:42 -0500
Message-Id: <20210412005043.5121-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412005043.5121-1-michael.christie@oracle.com>
References: <20210412005043.5121-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR06CA0062.namprd06.prod.outlook.com
 (2603:10b6:5:54::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR06CA0062.namprd06.prod.outlook.com (2603:10b6:5:54::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 00:50:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a220f3f-6829-43de-24a0-08d8fd4d095c
X-MS-TrafficTypeDiagnostic: BY5PR10MB4307:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43070E41428911129C05D4FAF1709@BY5PR10MB4307.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4YD3OpamTGA2QAsTsxMKAm1xTJyoel8Z8LAZymudKn1ETDfrYHdYYe4DgwW60cXoTnuZEZlYxGhmjfL/8VN5b3ZG6AAfL2Z8Bkk5d0+Cv2iDgsj2qbJ3HHWuOIMe1IXhasQEbAY5g5c6XAcysx0wBCCTUMIUqbRXAaZz9HvywlqGcBx3Tp2ni1vCXwPpNI6ycjC67E+Mrl/DN1/pLv3NV0zdcWPyy4qYXFqTBN4wN0b51MPCTMdpJ5Jccsn+jXbkpZ7ykU8QH3Uffs67i0TREwKirK5CJpJGmFqN4npqLhgLT5W8m5GTXcLxyykntq0APsTJxeTO63DD1/ycIFFzpuNtKUmyV2ywYCLOJIK2qKJs2H9JvPJN0UGgfT4Sqf0rQCDBwDpzWb64osJpoTa5xtgw1ST6HiWBel9QO4VdxSkQpZ6eLrPXEQOPtSwTBP+AzsVIiL9HK1lQMh0iv46d2g1yDAxLZo9NuxfB1F8XuSSIAHObx20bmGIzdHYZOCNQ+55csFa46Hty5kohjGdLuftq4qjSuhz7G2uLVApllMoXb+3+U9BU4oqq6sEIPQ3gMh7OY7jLi/1U/jaV58GP+sdfCrkqZoCAO5kLag8VSHs+QYhagYkB68LntendjiItKU4aIjWUwmMH+UOCALk+7xzplYKzJmKU68wUOF3QydW42JFF2C1XIjvWjvQw4/6v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(26005)(316002)(186003)(16526019)(2906002)(86362001)(83380400001)(1076003)(4326008)(107886003)(956004)(66556008)(478600001)(8676002)(38100700002)(8936002)(69590400012)(2616005)(66946007)(5660300002)(6506007)(6486002)(38350700002)(6512007)(6666004)(36756003)(52116002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?v6uRFHMtvDpGg1wBWorPnLRtMrnb6MOoov6qgaE7A6FdUg1YmYwQIQ9716Ah?=
 =?us-ascii?Q?G3dGMST3hlmIRq4V6uzCGCUuquxem6uVrgPHPGDXAs1qBBkx/1lbtjaJ/vZu?=
 =?us-ascii?Q?O2k9dFlRILKwokZxUtRZcmrL8/LQNABeTWRB//lwPHwcXETsIWRfCN5ocEtW?=
 =?us-ascii?Q?q0VKrDaz3+reK+XjVrcPqZY1YDj3Ux5z6LT+Bdn2rlwCG5iIH64ZTlIfzJEA?=
 =?us-ascii?Q?i/dbC69TjVrUd2UJaEHVp7IDpr8xKiJA1md4iwJeahRWH5fFJXH9bnluJW0P?=
 =?us-ascii?Q?yv55NBZw6Xajq6T3cMauhB67DzGZO+ltI2ZcJs0fUovTHEVOv+NzdvhGmzqE?=
 =?us-ascii?Q?n2vHTHPpWXnv0K2ulB++8s7QP24+MpnHPohrdQ2QZ2lSC5s4ZfSb8JwgIWed?=
 =?us-ascii?Q?63MfKjnMJOyDcYMIABnvaQFqQT6oeEdHk2Yu5DReUWa3FpCRo1ZetOmMeLqe?=
 =?us-ascii?Q?N1o33iEvnm/DMATnnTLtwPoJnNtZyqknNrImyhJG+lKqKRUrq+CDVzGrRisF?=
 =?us-ascii?Q?3d4ubzxFCSTTjPuMTacaTMGggs8bAEp/NrHDKMsU9B6IeewuNUrr/BT+lFF9?=
 =?us-ascii?Q?vFjcZBPcA1+ILfPhW1LDeiWbO7hmkMDb6pF/aBUYCbKYyrSnrZukMQbOn1B9?=
 =?us-ascii?Q?hEJBs0JYJSu4B2nTHE0uyCK09uJ55GOUSPCifZGJHFE8KfhU5A80mQmtavnk?=
 =?us-ascii?Q?3POcXX0mCDU5t9kQxH2aZ50EaSZ47KaKM2WxcJPIeGg5TcM1KUpIIeFmizQY?=
 =?us-ascii?Q?dgzrNPpm3T8vgE0e2h94j3iA12PNeMSb8fm5l+B578yvODWLJ/cMaaQ8H+S+?=
 =?us-ascii?Q?OTAfDhYc0KIZjvKpUwUlEUEjG29u/iKd+5pwMSNfAVXlhJWwwWyVwU+EryH1?=
 =?us-ascii?Q?S1mfDyhQTNJbB3vIbnxTcNQHI5+L2OrM0sY61t3mysXdeHvjlS6KlMyELSgp?=
 =?us-ascii?Q?WxRS8Z5+CoUE/JC2vE7K1nlOyOkvpzOGMn5t5S+GRTysCRzX+PF197KD4bXr?=
 =?us-ascii?Q?7+8rZksBUSQXkP+kZ7TWhUUy/b0j/9eGuEf2tyYdUYKC/y/h4LTXBsW1jA3Z?=
 =?us-ascii?Q?UtfMSqnOQ6Z72Ovjki5paet+WQBGCNG0C0AiKwnD6KjNaLu5g6HsKDzwQsEz?=
 =?us-ascii?Q?6bRr9eHMQBH6rd6HFJeQhePW3RUnaxQWFnPMny4Tg0ksMp3dDqAzrTdHpG3w?=
 =?us-ascii?Q?11/Uc3/p9YT2htch+pPE5Wubq7Qt8aqcDcnz+ZGzTLOK3YJ3sajsoqhuWqWx?=
 =?us-ascii?Q?wv+u1eknqNMB0bYGTDD3GogZiuFbeXWVuGtNejsLJFUx93Kgt96Tr1OMvBal?=
 =?us-ascii?Q?huvvIlL6dnIpPw1R+2rU1No9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a220f3f-6829-43de-24a0-08d8fd4d095c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 00:50:58.6196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tZ3jRBVy3EOw6EwGOUUWckyxP3FOqgp08QTLnUE1zFsbF7V2Ar/eR5gMnep9IVNI943i9MrPMfV4FBZIcyhWVz8r68a/74aBrqOO5ehKc+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4307
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120001
X-Proofpoint-ORIG-GUID: PTgZFlMiCakx8zdJB0oLQJzdbNOEKi4U
X-Proofpoint-GUID: PTgZFlMiCakx8zdJB0oLQJzdbNOEKi4U
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120001
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

