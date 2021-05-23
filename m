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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CC9C47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D524611ED
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhEWR7c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51812 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbhEWR7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHuCnm181855;
        Sun, 23 May 2021 17:57:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=2l1DiprDiu38Uih9amqDRzDE3/6lc/j7tTrKNilb6hw=;
 b=yjAqwbTAdfir+P1g6cb+xcZTAkZxyuYFKQ2NrqrihUErCLNWg+AW0QOJXIl2/7/1pFfS
 iGSXEViIVPoyDM1aGPvQgtzappAPpAjhF3eyGbUW29PId0oFY3pH6qVFH407iVOAOtCY
 3s0nkfHda/DqmE8yn/kxAlgDN6nbhaDzGAzmSVdX2N943aYrkA6GkESvKyZuiCr1gOvs
 HhrQ5xTmFTwB9SlGzc9kodDu3AD3uU3Imvb8v+OCb/Ln7qso6GD9iHhxgRTUMKZs42bK
 +b6gBLoSzB+bcnbi+vPFydQSDu0mQWcfkRoAk+JbkqPRW6+O+yhTVmc6q/sVUdiex2tN OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38q3q8ryxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHu0G7119789;
        Sun, 23 May 2021 17:57:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3020.oracle.com with ESMTP id 38qbqqjg5b-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYXE4VKRqjAMVO/oTykOkAmkmUcGoaAkufe3Gm35nxrr7aaKm/3q2nPk23QMv6TVQzUs9Hra8DZzIW0P91oyxrjH9AsVPgCPXQevvFs16KMiEbxFauk0HnTZOcRYsqf5zW26xeQdfP2XskHProxPd3GOKmIEjhsnkPUPEN2BI7SAckcXrOx6ZEWLZSFb3f2vFiq8Bhem/038+OtiT7gBeFoDBf0B/erj8pJncGZo6eTUhNXazxbjLR26XrOWt1zkjkBWyfcHNQ3PwNAKcG52bof94HTTNr7iwZO0i/l4Sf/+v1j9vRUEEazPQBTTL2mZ/vggMizkJuE0d0WmbYdEIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2l1DiprDiu38Uih9amqDRzDE3/6lc/j7tTrKNilb6hw=;
 b=Ny5egt2m2/+ryHkHRrkxCOAnLhOLILGahpUlcRyCipMyugEd83kKKKf5m2AMy4ACaN/0bIb5hzy/sxZ6HjFSVHVBpagGFLzN6o1Y4ptG/NFR1R+ORztPFZM+tBJ2IwRf9HSTBbO6aNBIh28sv7D0C3EWuSwNQyVwXhKttrXJbT8NugMTlMwJ+49JGwMv/55a70GMdZFFcCl6f5ftNXbrGtczJ4YcBVQgrjTfZd+9ER12wv5waYUqlffHyZ8WJbBH2A1L9/T6ieJpwXvj8g5Gyww6c/iBpjVm//lS7Txai5PLX5TqbKJ1mVij7Hx0aZn+cExq9e5skemfTji0A/SukQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2l1DiprDiu38Uih9amqDRzDE3/6lc/j7tTrKNilb6hw=;
 b=qLRFr8cTSZU2hazXMrKAS2aXKIsuaHcN4Yu7ND81G0DKVvPYMM3igufPE3o6y0OM0OqT0hN2p9VbgQapFkKIR2Zim+GEzJB35dmmPzUn3MMRieyepOBsUzsiucduAM+uBwZtMbgMG+m40AmrOBu0ohq4pRushK5n+nV7xDTsP2U=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:57:52 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:57:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/28] scsi: iscsi: Drop suspend calls from ep_disconnect
Date:   Sun, 23 May 2021 12:57:14 -0500
Message-Id: <20210523175739.360324-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:57:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35778202-fc87-4431-b266-08d91e1448cd
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4004557CA36AF99378FEA782F1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3qruSypUYxLytZV3H7FThnCwLT7Hxy22WmhfWmjrsah7zyUTGEa1WL8KhZZ/wMpE+WBA3X6QwMfk39s/Oq2S0HwE0hfarhJQtRdM0YPmueC3ThERfZ8GF60qGv1B9Didg1+x+BOexCsW+ljzBCDx8EPyVA6Hotad/2C4KgF9rObsfqmSl8j0Y2adZql+ahyiBuXmfK77MuvnlHvEggL0jMMNh6zLwrasW5BHUr33up6hYlzEPd55pZy12Kjk3nkD2des7kOAhU/XiUsDPuZjF7d6hWAsXcGVNPpkwbiqP9u8FiPb7qjkn/EkRaqbhPfQuR5JDWRS9gl+2a1qjpsK0nAU0vNyEZMsqKvIbPfvR4iS6hk2wB3PxhawojKAO8nmC35dAQJGL+Fn1N6T1bUx4Qm/1OzIhcpzORcDHK2l+DBqh4rx6mLAfU4BZCmu8lHDPwY/0Pn1P7tA8RU+/TgMFylCyEs08+mcD+q749rOA3ab5PIF0VuhM7r6zHzZevCn7zheIeDsLrjsjsTtFg4zzdARPHoebKYc3XVOeg56thA9zJ2ljgnV3l3k+eko58gZ1j+fb2nDGbSkP9GOzfZToJ35ih3UWiV2bKPOYW1W5+3plXbdCJTLIZA/5zHy/k9BIOfmL6kvv7tcHKMLaCxG5CxYWCEbCY0fcwCngCfx1q0AVl8Sh/CnhXDNOFOzsW65
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(15650500001)(66476007)(66556008)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sqsC/qdYHAU8f0m62yWHoc76rL/QcAt1gBHReIp2jo4QDL/ryHRZQxa8p2oH?=
 =?us-ascii?Q?DM1QmnMLymRG/rxQPNZKHMSGjpy04ah/ccf8DLvV9WwAfvhEYkpVWNuzujKZ?=
 =?us-ascii?Q?e1BWRTjTaOODvVk58r4RPFerQPapDLUIiW1BuFWWxdx9ZclSgtkYnJTtA7hn?=
 =?us-ascii?Q?ojWZxmEcAVt9nte8Zw3LxHd2yT14UV7opSbkB7a0w31ykHl7CBsvvFULB6dI?=
 =?us-ascii?Q?NRMa7UgjB7k1AU0s60SfVC/YIpoAgC9Rj+s+OIllWZQT93pwX+YAYwLO/XcD?=
 =?us-ascii?Q?oL+81EXGFrvo3q7NzVLrG+6GTaqtJ4vHXJv+V5W9A8DaziOkCdENUWwT5QGc?=
 =?us-ascii?Q?de9b7gGKUP71qWHUby+7LtbmwzcOTS0nl4k3PE/6xCQkP8WmE0UkSiyYNUNO?=
 =?us-ascii?Q?/aEtJI6C/9PxAIEUoFQmfEyWcvX/A/hkjYTuvRc/KLfYMV4ltCsenzeut+Ku?=
 =?us-ascii?Q?wXTPzSI/DYx3yeIe9o6fRo4iXEt1d7Y/ZEd5AVVDC4x8bzBZx2RYcCAVTUvr?=
 =?us-ascii?Q?lyjf4k/9u4j1WYfwzQj9nQHumAU1+YIIZxv4iu32bk100eNCkA9Lc3We0jCZ?=
 =?us-ascii?Q?/a8z+mdV5JdXNKJ5uGRBCcMm99rx8eF6tZd2A/EFL3zC6bumKmxA0a+/trsC?=
 =?us-ascii?Q?jHrC/LDAJDRDrTlCpghCbTO5QnbqfGjdardZp8iN7DYmiak0yMl5By2KTxtN?=
 =?us-ascii?Q?g824uhgAF1og07KQpBFo5wi7hzsqo3avQie8C0TqgIi5NM5rFlV+LyeWdXe9?=
 =?us-ascii?Q?gKIk+P9x9CLywccJgVJ9+qt7NQom2Z8me5PTg0mMK57DPbJ+CR9/Tlc303dG?=
 =?us-ascii?Q?/qfRBCd7zYrbbZcq2kviVAk7usFKsxkufU70e/IKGEje2g8WnvoKQ4tsY7zI?=
 =?us-ascii?Q?mAPSyTUksGtH0JYv6MDu1fgufWXqMzo9jcB/V5j2nlEGdMRtljZuX+k+gf1B?=
 =?us-ascii?Q?+LuxAI7IxGsFIxh9AibUi4HDd7e2+wVwk5EjNQLBo8bTfFEuyg7D1Jl7TvUC?=
 =?us-ascii?Q?AkIimT1DEEECAvqHTVNmdwfgwYv4w21XSVfd2jU/ZPzXDv7qToWYcdZtXIk3?=
 =?us-ascii?Q?GoYUA4ROZoGo93NBLWGmpj6JkJXJUNnmQdF/rMqj/7kSUZQe4eu/8IN/eB57?=
 =?us-ascii?Q?FbKQCtbjgMDSGHeBH7fIlz7LiHN8biDMjPzhygru5X4QjJ2OLCh7QIINvXdx?=
 =?us-ascii?Q?Sjh0oniu47cZBVdcr9Id+lEyMTnzUzhRuSyBLENP0vNymZwd+ZOPa4iAZa35?=
 =?us-ascii?Q?Gnb0REnbpRZS/7WlKhAlxSupILnyDnw5aaFWkAi5CfAWN2g605/H4CMuKPgs?=
 =?us-ascii?Q?sUgfWQ5dSQuO0S+VmxYrRSXx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35778202-fc87-4431-b266-08d91e1448cd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:57:52.1094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNTOcLVMEm3VKjc4f3M5KqCd7oSnUG9GH6AoEXUNIq1pEUhrNF3velr/c+o5ZTKDCfZkQN5JfxuXaJvqSPuVRnp8noDq++vua5lZb/cU1pI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
X-Proofpoint-GUID: _Z3ttypqrcvZE014jHUBG0dEvVUKkoSz
X-Proofpoint-ORIG-GUID: _Z3ttypqrcvZE014jHUBG0dEvVUKkoSz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

libiscsi will now suspend the send/tx queue for the drivers so we can drop
it from the drivers ep_disconnect.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 6 ------
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 6 +-----
 drivers/scsi/cxgbi/libcxgbi.c    | 1 -
 drivers/scsi/qedi/qedi_iscsi.c   | 8 ++++----
 4 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 0e935c49b57b..51a7b19bfffe 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1293,7 +1293,6 @@ static int beiscsi_conn_close(struct beiscsi_endpoint *beiscsi_ep)
 void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 {
 	struct beiscsi_endpoint *beiscsi_ep;
-	struct beiscsi_conn *beiscsi_conn;
 	struct beiscsi_hba *phba;
 	uint16_t cri_index;
 
@@ -1312,11 +1311,6 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 		return;
 	}
 
-	if (beiscsi_ep->conn) {
-		beiscsi_conn = beiscsi_ep->conn;
-		iscsi_suspend_queue(beiscsi_conn->conn);
-	}
-
 	if (!beiscsi_hba_is_online(phba)) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 			    "BS_%d : HBA in error 0x%lx\n", phba->state);
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index b6c1da46d582..9a4f4776a78a 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2113,7 +2113,6 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 {
 	struct bnx2i_endpoint *bnx2i_ep;
 	struct bnx2i_conn *bnx2i_conn = NULL;
-	struct iscsi_conn *conn = NULL;
 	struct bnx2i_hba *hba;
 
 	bnx2i_ep = ep->dd_data;
@@ -2126,11 +2125,8 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 		!time_after(jiffies, bnx2i_ep->timestamp + (12 * HZ)))
 		msleep(250);
 
-	if (bnx2i_ep->conn) {
+	if (bnx2i_ep->conn)
 		bnx2i_conn = bnx2i_ep->conn;
-		conn = bnx2i_conn->cls_conn->dd_data;
-		iscsi_suspend_queue(conn);
-	}
 	hba = bnx2i_ep->hba;
 
 	mutex_lock(&hba->net_dev_lock);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index f078b3c4e083..215dd0eb3f48 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2968,7 +2968,6 @@ void cxgbi_ep_disconnect(struct iscsi_endpoint *ep)
 		ep, cep, cconn, csk, csk->state, csk->flags);
 
 	if (cconn && cconn->iconn) {
-		iscsi_suspend_tx(cconn->iconn);
 		write_lock_bh(&csk->callback_lock);
 		cep->csk->user_data = NULL;
 		cconn->cep = NULL;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index ef16537c523c..30dc345b011c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -988,7 +988,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 {
 	struct qedi_endpoint *qedi_ep;
 	struct qedi_conn *qedi_conn = NULL;
-	struct iscsi_conn *conn = NULL;
 	struct qedi_ctx *qedi;
 	int ret = 0;
 	int wait_delay;
@@ -1007,8 +1006,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 
 	if (qedi_ep->conn) {
 		qedi_conn = qedi_ep->conn;
-		conn = qedi_conn->cls_conn->dd_data;
-		iscsi_suspend_queue(conn);
 		abrt_conn = qedi_conn->abrt_conn;
 
 		while (count--)	{
@@ -1621,8 +1618,11 @@ void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
 	struct iscsi_conn *conn = session->leadconn;
 	struct qedi_conn *qedi_conn = conn->dd_data;
 
-	if (iscsi_is_session_online(cls_sess))
+	if (iscsi_is_session_online(cls_sess)) {
+		if (conn)
+			iscsi_suspend_queue(conn);
 		qedi_ep_disconnect(qedi_conn->iscsi_ep);
+	}
 
 	qedi_conn_destroy(qedi_conn->cls_conn);
 
-- 
2.25.1

