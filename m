Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8AE1C43460
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A05606120B
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbhDLAve (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 20:51:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53020 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236191AbhDLAvc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 20:51:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0p2sc018777;
        Mon, 12 Apr 2021 00:51:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=sZtKNpnhKUcmJnY0/M6obBbjXko1kEOYVNmLXouY9SY=;
 b=V3CoXgMhrwLDxYvae32Dv2CwvUlt6ALSUJabpY//XeupYmOhjQnGzsZLNww4okkv5NMa
 1N3IRMltwiYAnA1wV+xdEcmuL5HC3FAFwKlnz1vmtLIH398k7FirRBlaBAeZtrRRtyaU
 iJhnLmizLu3h1Zh+z3InMMhdjLFIFLvOkK+H0RD9G7HczR2yqmhnRuHkBQWNbWBQ9jSH
 kUVR2TG7puU12SstOrh0/qvlTxLhAuNGAi7qmzBi/4dl2pRoOhPnl1BPW6dZOETej8Ko
 zHBxrSd6bUSfmIxc3jl+rDs+LwUUIiwN8VCZPOFoe0JgoV4sf91YygPVVvhB21bTJbUT aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37u3ym9ywh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:51:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0aGvI037388;
        Mon, 12 Apr 2021 00:51:01 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3030.oracle.com with ESMTP id 37unxur477-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:51:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXAAIei9msD1bgnbF0S17MKlTFaGpU34yMyHnmGcfYG+oRdU3YS/a3jMHyKSVdqBjg6Swx64393zbBKkkEcBhDc/nhS+BYAjoxWN9iy4T0KhLF7Mpbdy3qWdmMRJfifNM9rkX6lXSAY91XTOHmkfbOngltghjHeybgNARufIPAiHJaEwoL6YPYUYpzhWmkoT14YIPXYbOxg4cWUtl4r7Zz9i5SWQ3SGnXQVlNcODi8wRtkr0Nyt/IixBAI1ICZtaKEblV60rEcOdGLaEnrQyrNToTbQ2THc4mZdjEigoboUs7rbinkCU2R5YZS6AsI+vxqEE1HBGpvft5e9xf8nDXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZtKNpnhKUcmJnY0/M6obBbjXko1kEOYVNmLXouY9SY=;
 b=GJzZw3h4FIMCFGjJXxPSxryPzVUWKXDKMxiBbXxJlolxC0G74eTvNmeUeuMHxvrqYGs4ybDOOoukvqkeLGyv5UUh0gN+Q0+r5QWxtvEnrej32W4UJ0XJN+iyz4R8UMqACyvCh3XqfXgtXnq07s060BM6QFkrYwf83sGX6RYqZLmEulWj12dPROO4Sa9T7Hs9iAD70+79qg31/mj6v9A0d4msnEGYDOiAOFjDLUuYDcM2Pm2B+Mebg+HHwQ9jmKzy7GjHolUT1C8Anuo8aSYPO5D7JuLJUunkJobwUM5j5VWQHgymRjZqFmWdUNW+PbEwUFGosprBMpNqP5uStrrXxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZtKNpnhKUcmJnY0/M6obBbjXko1kEOYVNmLXouY9SY=;
 b=OtOpLEiEyzESpmyJE89b4bgkAXvjGRp3Tb7aeoM24thEQFfmwzPjB+XlFu9hDZUbD3ICR4Zfcse7ZUeaTapKBGqmitEZKNuVrrzNiarVfwoW2Xm7Bugr3w3FPZxoec7xejyc7pXxulCfkBtH8WxdRBv3mxa3NfxuH/j8xENgNwU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4307.namprd10.prod.outlook.com (2603:10b6:a03:212::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 00:50:59 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Mon, 12 Apr 2021
 00:50:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC v2 7/7] scsi: iscsi_tcp: start socket shutdown during conn stop
Date:   Sun, 11 Apr 2021 19:50:43 -0500
Message-Id: <20210412005043.5121-8-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR06CA0062.namprd06.prod.outlook.com (2603:10b6:5:54::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 00:50:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b8db375-af10-4b89-3c2c-08d8fd4d0a00
X-MS-TrafficTypeDiagnostic: BY5PR10MB4307:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43074E8AC7C2426FE7F27DD7F1709@BY5PR10MB4307.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n4YSzRzFNQ9uQUAdySaZZ/+owY6TFYxxFFWYr0o093VGy+/upAFC//P3lJEZYDEhoyLLGBs5hgw8Hl/5BR3NHHTcHqRUhMwDsk/tgYy99FfBd/MaXaDdW/RQ5OTkyQRZXidG1Qto5O/QJMr/Tmy3J1uikxQL1I+GsbLP+gwfUULDHNPCoF9CybOwJnke9scyFy9Fz1u+yFWVq8RscIBBnmHpVbdTGBnQFA9eFOZpGEY3ZmrP0muvPw5AXfQSq97V1WEaDMgxdwvFGw/jNTZZXnNcDvYtTzuEs7XarUw8XnxIOnhIjwBuvTc1jRA1/zWrqpSlLqBZ6V8SyTgtv7NqcHBoP00s+WaUrww3EkDe7uPpILSTtXoDpn7lcI94iw5otK7+AzhRB7dEyxsRlxOcoCLMW4Zc/kF/S0X4GuB+uVVtsDcexxtxBzHa5k/EYO27Ggp1dCztGfQQNFw3Biukkzx2KEdSjvaQ01xk5VMbcQIwTKY1cdCODleuSCsJ6veyTSEEiwl5pkGot/wXkb2k0HHaPxYnBITcNNdxrPLenw0Y3sLV3sm847MBu4LjvGIxG6U4qMwnbB0T/WmuLUEEBAynvetnLGaWzcjNBFtYj93GZ/SrE4+zUSwfHc8vkSGZIyLpvZWPP1gvvg43iTG6hw40gYje0r1kKbY/2eb2SDEAYVe2x1p2Z/sxASTWbTP+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(26005)(316002)(186003)(16526019)(2906002)(86362001)(83380400001)(1076003)(4326008)(107886003)(956004)(66556008)(478600001)(8676002)(38100700002)(8936002)(69590400012)(2616005)(66946007)(5660300002)(6506007)(6486002)(38350700002)(6512007)(6666004)(36756003)(52116002)(66476007)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6/ar9TEDSOncqWKDQSLN6BmUMIlNPcHWIbX8DoIXCRpDUz7KCQNWeLNiFDOt?=
 =?us-ascii?Q?Lw8SY585B2p/uMeXqSYEkZ7L1kTJaCBC16XRe1i8lqMOmOtmUe7onChvHxfZ?=
 =?us-ascii?Q?z9aDH8XIfhQxF1sJGiUZGjHOFcFGOWslzZ9cejAUguFSnA2iFuGMsLxtfUTD?=
 =?us-ascii?Q?MSc7l/wCkyJdySyhpCiQ16GBPkpgZQwwjNs5bgsP2gPaSU+rsPu8hytJDTdo?=
 =?us-ascii?Q?zbj+vV3Ez4HmYy0fC7v63acVdThkcPd/w7hQp1mS0iuh9TcOeLQicH2+P/37?=
 =?us-ascii?Q?RLOnX2tQJAyPRlPZ6XV11x9TbngCAm0aF5gErlqb6vaPKxPvI1pymr13NOgX?=
 =?us-ascii?Q?3ArTzANWW7RaXrY1N7nLvEUoUwKWVC8u9eHfEudG9ZZPKsoGkP2yOs5LpgDA?=
 =?us-ascii?Q?iSLoHiXEsix/65ikHHIUA0oAgbC8SlPZ35nPl+uG7YAJD7n5mW/jSzJwTV97?=
 =?us-ascii?Q?YUALeezdKpg1Q+arBHPku7D5+3VjosRs/hubLE6Hdabt01NKItEtqcnPbaTO?=
 =?us-ascii?Q?DRzkEhCFCnZlRbu0KwF4Xufug/W6y6D+SDtGlT//eWSgUtx10Gbd7/ctJVUR?=
 =?us-ascii?Q?AtFqn1wXAhX3FQOkWmRmBGi/qFnA+vUgQQYniGgjtCcAsdYm3ClYrPA9QKRi?=
 =?us-ascii?Q?357k18G74FpXlvAjRlrgPsbyuBMgoCuuRUGZ8jm4H/DgJd2BB7geENS/34sK?=
 =?us-ascii?Q?BJUIOz2IXS1x7MwYFuM6eO2MROv/yLIY8HmmwhAMbj3oPcII7AaIQUJ2+6xN?=
 =?us-ascii?Q?RD0ynTL8akFQE04qApjHE6yaSHM8iBb3/kHbab+vkwkNzlcdaRTlcyqnako6?=
 =?us-ascii?Q?Lta8+bde0X9CYg/Xex9v9d28ie0MZ1KgiaYN0IQlHlx+Qz4OirSItgREA3mG?=
 =?us-ascii?Q?uWgvup5XMdr7JkT+76nYoK0TW5reakCs9kx7OUq6gJFp0za0xr+lvw+BGkXe?=
 =?us-ascii?Q?08hnxzam/vkaRBMExtwBmYvTQBp81S7VgR7UkJ5XnYKZdjk8AD0Yird+x+mJ?=
 =?us-ascii?Q?2vkiJR8DpFfWAqoe6smEyYctXqdBKd1ZDsgFVWn+RY/Ca+lwjDy8zp76itYF?=
 =?us-ascii?Q?vyEPbDV6nOsMxdud2ELo6QqKiwhIQbP2pBT/VvqZTuFfK/jxS0Sjma6Vsj80?=
 =?us-ascii?Q?2reE8HEX3nGSkzqh2b+i6yvUh4m3zsDJzJg6mLuGWIKHGtpEY3pdmmB+UADe?=
 =?us-ascii?Q?/+JHnFiRpdOQBzh2FuEnLjldnUpKUQwyZ+f5uxUsajtMh7bQsK3Twrp2QBc2?=
 =?us-ascii?Q?x013gYEsW0k/PjU8SqTI+HNWR418qgKJV0EFMmCZcVKtf9JgTR3x17w5wBeb?=
 =?us-ascii?Q?TyezPac5AKzp8agOFfV/ZCTt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b8db375-af10-4b89-3c2c-08d8fd4d0a00
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 00:50:59.7090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VVFp6KkfaTL8EPQGlo55ulIR/CUhJr5rARJAjbiKpGB5p5Qrb1fDDx9/ti6P68RhoF0uKkfM5usRWAMO2YWfdCNXSBywMIp01Vh+EDnIZU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4307
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120001
X-Proofpoint-GUID: eQoY-t68V8_gnbNjB1CMN2kwz8JOSDu8
X-Proofpoint-ORIG-GUID: eQoY-t68V8_gnbNjB1CMN2kwz8JOSDu8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure the conn socket shutdown starts before we start the timer
to fail commands to upper layers.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 553e95ad6197..1bc37593c88f 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -600,6 +600,12 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 	if (!sock)
 		return;
 
+	/*
+	 * Make sure we start socket shutdown now in case userspace is up
+	 * but delayed in releasing the socket.
+	 */
+	kernel_sock_shutdown(sock, SHUT_RDWR);
+
 	sock_hold(sock->sk);
 	iscsi_sw_tcp_conn_restore_callbacks(conn);
 	sock_put(sock->sk);
-- 
2.25.1

