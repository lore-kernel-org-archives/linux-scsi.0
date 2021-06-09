Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55514C48BCF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 19:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D2A8613F9
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 19:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhFIT3S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 15:29:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhFIT3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 15:29:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159JEaoN154542;
        Wed, 9 Jun 2021 19:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=tFDzIFr8XiJYcduCEX/6W4bCyrgzwnFAZLgRZn4rL/E=;
 b=Po81eZcpj+KZvvBReK8CaaeP1YdzDMp+2w8bHxHIlPjInE2i0TzBhrk/fGMLU+NrfspF
 gsFim3rpPW/vZa4oyOSUkM+WiH1hq/Rk9jfQc39nZpg6nSfCZY+++7PE/syE0EUaWjBO
 voZQKVrn2AcAWQqa8bHhnq/A7KnAu1tVG/cvIf4SH3D7xq2y7S0ENvx/eujbq/hFe4dy
 TXCiy77Lqsj+jOAsYZX6hSfy0TWYe+8IaqxMLwiCJrTvA+VuKKsU26lJd78WHy2SdQsJ
 PWzyzgkeMFqrtbMpL/PJjVGwQEeETegY2T30oXhT0zaydFy3kTNP6tFxi10dYg/xMTQB Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3900psa3fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 19:27:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159JEef1130181;
        Wed, 9 Jun 2021 19:27:19 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by aserp3020.oracle.com with ESMTP id 3922wvyqhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 19:27:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdpAbsRimh+w+skOxRVZ8G8CGMqDO+eyuGLRuZWIxXF/uBQ8W/TpseEPl7SxAs6xkI2Tg6ajBdjTm0UvLhbtxvu4pLUlELYLhA6KXzwn5T7hklGUg0wssiZSouBN19lEJ6T4KZAP6/hZb7nHZMP7xR9rWmVApI9goV4UIJd10yCdBui1VkknplgOPUNjyLw5TCX+zHR8U6lREw/4st5zU5Ehu5Fra21Q5lyIcvQlEzf0G3Zh9+Z5QsqrQ8+volyscgMwpcU4HTcwJMED76n/+KxpAsGXzBqYcASNGDBR9LYESFWfRS7KWQ2Zs8yCNmiQ9PpfO+1bAb34l+y6TrIzAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFDzIFr8XiJYcduCEX/6W4bCyrgzwnFAZLgRZn4rL/E=;
 b=i6zFxba0Vyo+bq3WeBtLMXY2Ukfjlx0x2E0C2Q9ZivxqUYiMGZdVrkGI438iGFn6jR3uLKOt5pW0ifT6F43jGSfXR7X2Tp2gw1HxYHlAIRh6YxG1UeowUEDWZunzMOjksvn2POO/wABaRDOpqC/pyH17KL6XH/YfeziKXHwzwsVBGpk3mcH1fYv7jr6llOkiAjBrfMLWMrXHusPOvqzakCzjuT5SMC0dt4xMXBQl3o6/mFiphZCMNvWoVuhQATV2nZSJ8qhVxiMixj7VJidOwn9eq/N8ZWBk75ulfDiyoSZUI52Lwaw2vdwS4GFDFoqZncD780kKcNJQJP7N5HSwzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFDzIFr8XiJYcduCEX/6W4bCyrgzwnFAZLgRZn4rL/E=;
 b=HOJutLRqeJBfGtdN+mnIJ9xMtvZrMgAEz1H0ZltFCJoHh7JHi8CkJ0NAXABAsA8TOLWVG8iRNHhkbACH/P6k810pPTZTCPKGxSCgd8Z3DV/HUr35467u179RtdfFdjb2vMBHzThfynq4VXuwRiAWJOMkO7GgCXGYFVBCeN7LkPg=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3319.namprd10.prod.outlook.com (2603:10b6:a03:150::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.29; Wed, 9 Jun
 2021 19:27:17 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 19:27:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mrangankar@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: qedi: Fix host removal with running sessions
Date:   Wed,  9 Jun 2021 14:27:09 -0500
Message-Id: <20210609192709.5094-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR06CA0047.namprd06.prod.outlook.com
 (2603:10b6:3:5d::33) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR06CA0047.namprd06.prod.outlook.com (2603:10b6:3:5d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 19:27:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66c8d9ae-c3eb-4f0c-b107-08d92b7c97d5
X-MS-TrafficTypeDiagnostic: BYAPR10MB3319:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3319CAC816AF01A4318A5B23F1369@BYAPR10MB3319.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r1pg8X2BfpgROSllh2vfkrVns0+HSxldmanUaljsGOf5xwQmA7x43Fz/rShrg8V3viALvtx2d8hK8mlmCl25f0A6zRDgxP+FTYe0tf3t9Tfju0gXtGOnxJTAeHN2qXbPk5dYVxGqZqedRGX3ovSurZweu8JV+jSc6RrB3NaOrc05eXkPg7LzeABADFueW3rra+GACaX/+KPKi1yW3af2cb9xis18Kx1n4jWn6l4LdH7UhSzo07iA7tiPLdonKZYKDzcUvXIyl6GqYpcL4diOl//mQDFMwuFfAlSoZqOeK2YarAkA+2+uVLOSL/AL8Ks/brJuC8prpRLcFM2f2Y8SZTkqvSimrf5vZAYZWhAfZkD/KMBZ1vv4rYiSIDa1mZtRAK9H5QQCbfN5UlVBmwic/JomqOGDKQVeFRKDj+QZfXaQ9FpQ88fF/7Linb/imgg/wxy9G/WRTN+/IREvum2Rfd9YPfNoSgCsSsVY2EnUJwmoGU+cSiTMzbWhjF1pMpOE339azXokJ2OHLuATYeabcdeaaXBQBN5GaET8vOajkuuq5IZBP+O/J5bXZa7q/kB/GbptrjFC6V3nu+lSHAfNrEZ3lstI0sk0Xs88j5YMIY6a285k5RthMeurqaI1muBgANgJJ9is9qOYx44uDD9q4+oD2W4ryc5dOReGIERsZcegCphOfg2LUv7INjq8CyX+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(366004)(346002)(136003)(66476007)(6506007)(86362001)(2616005)(6512007)(956004)(66946007)(26005)(8676002)(38100700002)(107886003)(4326008)(5660300002)(83380400001)(52116002)(316002)(1076003)(186003)(6666004)(16526019)(478600001)(38350700002)(8936002)(36756003)(66556008)(2906002)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VrSb/KJVVkqLy0CLGbDspdFcyB9hCLUoePfXov4qG/8nJRw/oKbSVcivdtR7?=
 =?us-ascii?Q?T8UNeJ+JWI1yXchE0aJAT1A9SVYejF4i+tMJkM7qgrBCF4HxQzoGg2X+OlDj?=
 =?us-ascii?Q?NZ6LQyc2Ho1q+NlXlKx4BgfVqZuXai2dNolacflir35dVwmDhM57Ax+Yqn70?=
 =?us-ascii?Q?PQEaDHreqea/mjNLR5NPIUMDmIZi/l0vtUHg+O/BXPejXe3jkkIrHubljxs4?=
 =?us-ascii?Q?ZpzXq736VbtzNgpCF6k4DBcF3Q660g0Lx8HtomCSD9dgQ2AmFSx70cAi5ZY4?=
 =?us-ascii?Q?j93A9K8rn9kq1sjXlQIpyzP7vKl0NHrFebCN6D4I0ZXFfBcD21q8ZcOhpVBA?=
 =?us-ascii?Q?BaTOxwPBYbKp68YOd2oEUjV2R+FwkRIoki+41IOneeRqt6CWGYok/T60ypJh?=
 =?us-ascii?Q?LSv2ZmC9cRT2otF40THa36ykdb/By5/xQWFbuXZGvb1YQQVNTS99iaw/6InV?=
 =?us-ascii?Q?VWXm2hhTXEG6f8hGQxliFAuc/OS0DIp9T63CeYZJ5GK/hGXHES+ytIp3wHHI?=
 =?us-ascii?Q?nbGgd39HEqkb8WV4Msv9g8hw+WGNoPjpVKGFq0hK7k+82GU0b8vCufkySabQ?=
 =?us-ascii?Q?mfXG+K0ugdtEtRjOxm+sKKncr29enJS/wCrvdEp4Qv1f0/jKEFV9Csy2JLj4?=
 =?us-ascii?Q?g9RM2wHqfJmhWZ6bSsw+wy0WazW3nkrG+qp5WDGRB686iTf4hR3VY4ZFSf9l?=
 =?us-ascii?Q?+PjtcF8YW4Fi5Lz+3IvAViHqiUXEsA5hV+5ymo1lsokf25Mpz1tZvIPhSJDo?=
 =?us-ascii?Q?k9IhL2it6dXSP6j6/ef3HTMWIeXtBNrGuPrCHrhIe9AXFCKQjwVDlJF0j/qy?=
 =?us-ascii?Q?qswNsNDmO+xqlE0E8U+J3+ymhGXZ3KckofPBfTO1Bl/yjqhDxe8k86V8tz39?=
 =?us-ascii?Q?OAIw9KMuGTfn2CAe+iNx8rDkQn1DaCUiwpbwE7LxjPUTTIjUMFv6zgVAiUYE?=
 =?us-ascii?Q?Xk1G8oaUZsTnlQ7dB23LaV+yNYfby+s/qw3PJ0LWFq0LtVsJRaWM5sUvCMmg?=
 =?us-ascii?Q?/Y6Qng0GHXXK7v7q+K/WQ6XdwgqUWt8KUFnlyZfKorL/QpVL2Y9Q8y5WSCgT?=
 =?us-ascii?Q?TNqJIVHKe9Lgw1mNajYvsYMm8+foFS6VnElRgg36JjbFbhYauugPP+cgMaoI?=
 =?us-ascii?Q?EpHiH5wvvRWx6+Ob8jvlCwYvcU06BkIvld8e7zXyRneZJD9nhVQTU7sPuqbZ?=
 =?us-ascii?Q?WmroBbP6BujeY5lJdWRusttEbDkKtv+xZRSVv6A83VkW5jWnYSVl5cR1Px+X?=
 =?us-ascii?Q?XsXF2ZlLQUgfSJ2UDng2g5aAaDQel2LgPwmAEoMwccUmRlOdOkccIJiMCafN?=
 =?us-ascii?Q?coi0egwI/GTyB9pi28dK6AeB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c8d9ae-c3eb-4f0c-b107-08d92b7c97d5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 19:27:17.4807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bm/tqwoaCTRob+Q8OPHcuNqiUcYHRW3CuglM1g5Ul3CkRWw9mxCEQEtNoWxdtn9RD0A/pARLcyAG0U83b30qkdtKvwh+rjAtx09WSUBD3WY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3319
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090099
X-Proofpoint-GUID: 9n5Vdmkmf98lu7i_MsQ32435mN9i0uww
X-Proofpoint-ORIG-GUID: 9n5Vdmkmf98lu7i_MsQ32435mN9i0uww
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090099
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qedi_clear_session_ctx could race with the in-kernel or userspace driven
recovery/removal and we could access a NULL conn or do a double free.

We should be using iscsi_host_remove to start the removal process from the
driver. It will start the in-kernel recovery and notify userspace that the
driver's scsi_hosts are being removed. iscsid will then drive the session
removal like is done when the logout command is run. When the sessions are
removed, iscsi_host_remove will return so qedi can finish knowing there
are no running sessions and no new sessions will be allowed.

This also fixes an issue where we check for a NULL conn after already
accessing it introduced in commit 27e986289e73 ("scsi: iscsi: Drop suspend
calls from ep_disconnect") by just removing the function completely.

Fixes: 27e986289e73 ("scsi: iscsi: Drop suspend calls from ep_disconnect")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_gbl.h   |  1 -
 drivers/scsi/qedi/qedi_iscsi.c | 17 -----------------
 drivers/scsi/qedi/qedi_main.c  |  7 ++-----
 3 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index fb44a282613e..9f8e8ef405a1 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -72,6 +72,5 @@ void qedi_remove_sysfs_ctx_attr(struct qedi_ctx *qedi);
 void qedi_clearsq(struct qedi_ctx *qedi,
 		  struct qedi_conn *qedi_conn,
 		  struct iscsi_task *task);
-void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess);
 
 #endif
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index bf581ecea897..97f83760da88 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1659,23 +1659,6 @@ void qedi_process_iscsi_error(struct qedi_endpoint *ep,
 		qedi_start_conn_recovery(qedi_conn->qedi, qedi_conn);
 }
 
-void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
-{
-	struct iscsi_session *session = cls_sess->dd_data;
-	struct iscsi_conn *conn = session->leadconn;
-	struct qedi_conn *qedi_conn = conn->dd_data;
-
-	if (iscsi_is_session_online(cls_sess)) {
-		if (conn)
-			iscsi_suspend_queue(conn);
-		qedi_ep_disconnect(qedi_conn->iscsi_ep);
-	}
-
-	qedi_conn_destroy(qedi_conn->cls_conn);
-
-	qedi_session_destroy(cls_sess);
-}
-
 void qedi_process_tcp_error(struct qedi_endpoint *ep,
 			    struct iscsi_eqe_data *data)
 {
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index edf915432704..0b0acb827071 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2417,11 +2417,9 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 	int rval;
 	u16 retry = 10;
 
-	if (mode == QEDI_MODE_SHUTDOWN)
-		iscsi_host_for_each_session(qedi->shost,
-					    qedi_clear_session_ctx);
-
 	if (mode == QEDI_MODE_NORMAL || mode == QEDI_MODE_SHUTDOWN) {
+		iscsi_host_remove(qedi->shost);
+
 		if (qedi->tmf_thread) {
 			flush_workqueue(qedi->tmf_thread);
 			destroy_workqueue(qedi->tmf_thread);
@@ -2482,7 +2480,6 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 		if (qedi->boot_kset)
 			iscsi_boot_destroy_kset(qedi->boot_kset);
 
-		iscsi_host_remove(qedi->shost);
 		iscsi_host_free(qedi->shost);
 	}
 }
-- 
2.25.1

