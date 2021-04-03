Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBEF2C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C54E26135E
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbhDCXYa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49802 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236958AbhDCXYV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJwpR160162;
        Sat, 3 Apr 2021 23:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=yJopOwKim0rn89DI/dAF4YiJvfQ3U7OAae29XlHOGWw=;
 b=ju9Wj9f/Sc0EBUAx8MYzSXFE5D4G5jQvfbO99OuD5zixd/4DazFlloSey2VZcWQBjcnp
 8/ef0PB5H/bsnuXbmLk8GWyw9KJa0HDgXPr/KCWpC2r3AXo3eRkD30Sll4q7zdSRwP4o
 GolWwQygvJ916UuZdotpUCk+FNydOQCf9TgEbLk38v0IdnXwkutn78Xq5PbU1zDNCR4z
 BtBBtU1LVOuYwTV+vyDQbDKVo07I5EBUXtV//TLnCJF/u4gXzEwfl878fAgN1cLH3AoA
 703ps7ZmtLo9YJdjU+3Gwhz5AC1gcopI6On6qHlZxT5yS16VAsL1BdlZ8epApuSVEkle kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37pgam8rpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKte2116979;
        Sat, 3 Apr 2021 23:24:08 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2050.outbound.protection.outlook.com [104.47.45.50])
        by userp3020.oracle.com with ESMTP id 37pfpkbspr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YwSnaIOTcRsemdV2D+KeSfVx7t8AKdQecqV/TfS88Z4yZ+Msrzenu/d4gf/iG5x5tvvWF48Klp6fa2oBA6EaSh/bKL+Ei0hYEgBw06NuEA/p8/te9/yozbr/ROwEpQctxKS4MXujwGAwnf+61DSDe1c02M+QeiMGHXQbnQlnBKEhEmma7cx+SpfMdjLYClUEeUN8G0WvIEu4SYz1v3IW/ZWfo41lJwblKCeZBDlB2g0kHseOlt6ld55kHrUlCv4QSXpsgDaiIsh8C0X6eddY82K7q6Tjk95huoy+/JsRZNpMxI97kThRhCAd5IQgSZH++xsZwlgS5v1GFBMHipo7nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJopOwKim0rn89DI/dAF4YiJvfQ3U7OAae29XlHOGWw=;
 b=W5VGdUfXQN65FDcKaDclW2uTHQqjrYgrieZ1/gVgQG4MjNfEvyuE9URg56Qhe8P5E0WToUhMNpJzxUXp+x1UWKAndyGEnM9eUhvokus548Xdi+0DgcoaI0BZrtmMcZJix5czs1OxGS1uRrSL57htjJJHDx4ROFru0KIQIDIaB57B39PfO3qaXzY9S5XNp/dRHepIUtnJ6DV5ow1DrWiFmd2ADGDwjsbnrhHDrJFciiyS3wvueLTOvJaPTDGz8uBhv6KyEh2L0U6mmbU4uLoqgJLDCcm7y0eluwn6nsxh2g0LM+y9KnNWJJs8VRp8qrTVIZPhBn6Lb19zOASzfwmc4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJopOwKim0rn89DI/dAF4YiJvfQ3U7OAae29XlHOGWw=;
 b=MHWeM341jMLscy9mLPGzFhJVw41EzBz/X19urfps+EJxXR6EI8WQMG1c8nmFV//xDznUWEaBZh85stOS6c7YmZJu4zMKog9kIn5tBpp8W1rc0q5mYOD3nQFvkWR59LxIbyGWSw/4m5FewFKHQv/AWfEJ8WfPnFv9yTZn5r6YXFE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:24:05 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 16/40] scsi: be2iscsi: switch to iscsi_complete_task
Date:   Sat,  3 Apr 2021 18:23:09 -0500
Message-Id: <20210403232333.212927-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fad1c277-82da-4d17-aa1e-08d8f6f792b0
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3526769D85E10532F355A11DF1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jz1LuixpQ+NsnjG2DhhE8EyFHHiqo3YLrp1QlW5lWRGvSSRhsuSWOzYBSgTVHc+PKovfDZOWlZIWu2pxNcmrS32zFVWUCgLRii0Gq6uTWmB3rLbeX49pmvlFPwZafsovcLSYTCSBuF9yltWCrGzXW9J4y2fusEjlQBKAIcabJ1Kzrg6HpMkS2I5mRP3ROjHjejGSj2358I4Hzq1WgUxKYVQWnNOD4sIiODe0hkGVwLexbPIwZQHoqOuiKbxzelJDlqZcGjbUsnfWee+XpZokeYl+dw01djLdy++piMbqTrNJ0klGbxENn++FvTikZHNayz+fNKeCPgiL+L+Etobhvb5X/QlIlSyuQH6gwFAD7cMHFpZigpynY6OfsRhgsm2jv/UPY1WH82lV2AlaBu7l7qPNMvPqGqig7GzUvNLndDmfthfOBBANlPkuY9JcqpCVXQFbnLQWpWlXgJ0D0e/npzDwz5iu3gk6oDuxNlFcrUnWGlR6Z4tHPtpPfSf/JFxz0+qhhlLhlPwNBeRI2zuNzbwTUUqckZ6Ck06sr10nVLO3h+vDJ0lX4VhJQp3JSBG7wkMsUhTsXPzAhfaL+8ZTs/W8Uua2CZj8cN4IROnRmrFX/yWi6WnAX8bl2mj48p8yorewr4JByjXYrXxa0tLhsYbST0okialpjZeRmWGvm748zKCmYFVN3es4cObp0oqozSK7DJCZExUfpm4I71V/Cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?keA0SAEQ1LOCn0FxWm6JhP0H8edHqujYizbRrzwja61NRkpoOGPzS2tOL5BH?=
 =?us-ascii?Q?EFbzUFSpl53x3KrMk2NpXWhDBNqcqYplBqHhpL7e4Uv56czZUswIvKXxOE+w?=
 =?us-ascii?Q?fs4YUvXagELr9LxMWQ96yhUzid183/65UJEOOLiexI8KcKFOwT1dPbhOQ3Se?=
 =?us-ascii?Q?c8DXBVm0dq4aY5ouk9KfTv4OiJtPrRKsGxyLNysThr4tv1/GpL1LMUFgALUk?=
 =?us-ascii?Q?Dct1mOiV0l0SAi1mpnNsarmNrz+K/6HIlqDFOiw9/l7+9YLtq1dfPjFiCNa3?=
 =?us-ascii?Q?b6CdfwLVSDPPHtJgPgDubVFeUXXb0FjBuBr33L3hNFEBCVzxcqg3JqZlQoyc?=
 =?us-ascii?Q?qlYZfFKMJagJeTeJg3dCwsGi7sof8nmMA3nAjl9Es2j0LfMhjDZwJ8g0HKWi?=
 =?us-ascii?Q?CUQwfxNDJg3O6rWYIc8EouLPeaBwK8AlBt5iuqLQTt741K7XmMothiRRmLLZ?=
 =?us-ascii?Q?3xiVOELLlXQSJzcH4eGq74V6wPlsAFAlVmAE/Zfg/pLAj/x7x8sidd9v2avg?=
 =?us-ascii?Q?BUFn3llkerHL0eHw2mh0ote+vdTd7GCh4es8zWCR6rFyfnMYwH/E87ABgTFX?=
 =?us-ascii?Q?V9SIMBzj3bYLKC5RkyfaWmGQ2qgNmN8WYjASDMxo+fjbd++x/fFTWXMIbqdm?=
 =?us-ascii?Q?knPu6suVu3TKD7Az3ca+Koauw9Do837DXK2C1LbdTZase2xfgrJTF2xXI6sr?=
 =?us-ascii?Q?UZmqvmK3nEBNyTP2v+0gyamovoHrRx2UW0dN9PmUFwnrDZ0OlKTLdg3H9dry?=
 =?us-ascii?Q?MBN4bj90CUMTj+mphZ+kqez7uCwjyqX7N5E7WykYLojloSWrrUtrH3I+yo+x?=
 =?us-ascii?Q?Jpye/AOMblY9+QOErxn7ktyJ68AifBMfITNwTr5M9POBe3N0Pcn6/Sm3oFjO?=
 =?us-ascii?Q?i5YS7B/fth4KbwxIL/zOW9QzhlvmZRHFiXPyd1tPHjCa02wBqtOQldi+VJJ6?=
 =?us-ascii?Q?qVBZZGGv5BHRhhHX/PAyx9mQKvsAXAEToNxaqomMaKy+M74YdKFHpB9eBYjc?=
 =?us-ascii?Q?KN7JKK6Xg9cXqcSJZCRnVL9TTsfnp1/C2/64EVUBurJ/+9JX6YC8vTHm8u6K?=
 =?us-ascii?Q?TgMqcTUnRotOYkqy72jd9Y+zrPz+OrXUnzUTIt3cHDjNfKgD03hDBkMEsJSB?=
 =?us-ascii?Q?ubTdWvqncPCAIynZ4Kd5xEW1M2gyshDrS9jWSg/eN5PcH/GYiPIuqYVIluLk?=
 =?us-ascii?Q?7xH5NOKzzk0eQ1ehMbzdXvcrvpImcdQFCRpeFc3va+Ub+TLTxBI423G1NxOQ?=
 =?us-ascii?Q?vMwQekPQUODsFbjp6OTz0evK/+w9fj3H5nOBdNFOOgGeGDDSIG98NYnp6qaA?=
 =?us-ascii?Q?LuJ21PWuNwweQf84p8SJZm+5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fad1c277-82da-4d17-aa1e-08d8f6f792b0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:05.3440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qnqDN6Qe2HUeYySv+bJ9DjjWeAEk5yw/8bWbcUV7VSi2ueYqofldDlaFsxfVBA1wMeLPY3r4OrqMFbopGOJg1JWyplDNyd4WAMHxv7RgkqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: B-Q-_mbzJbJyhcBUOvWaijJ8g2Bu_Syp
X-Proofpoint-GUID: B-Q-_mbzJbJyhcBUOvWaijJ8g2Bu_Syp
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has be2iscsi use iscsi_complete_task. It then does not need to do any
itt hacks and can completely ignore the libiscsi itt.

Note: parse_pdu_itt is now just used to tell libiscsi we don't use it's itt.
In a future patchset this will be removed.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c | 30 ++++++++----------------------
 drivers/scsi/be2iscsi/be_main.h |  1 -
 2 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 4d4e3d606e25..99eae2add8da 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1187,7 +1187,6 @@ be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 		    struct common_sol_cqe *csol_cqe)
 {
 	struct iscsi_logout_rsp *hdr;
-	struct beiscsi_io_task *io_task = task->dd_data;
 	struct iscsi_conn *conn = beiscsi_conn->conn;
 
 	hdr = (struct iscsi_logout_rsp *)task->hdr;
@@ -1204,8 +1203,7 @@ be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 	hdr->dlength[1] = 0;
 	hdr->dlength[2] = 0;
 	hdr->hlength = 0;
-	hdr->itt = io_task->libiscsi_itt;
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+	iscsi_complete_task(conn, task, (struct iscsi_hdr *)hdr, NULL, 0);
 }
 
 static void
@@ -1215,7 +1213,6 @@ be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
 {
 	struct iscsi_tm_rsp *hdr;
 	struct iscsi_conn *conn = beiscsi_conn->conn;
-	struct beiscsi_io_task *io_task = task->dd_data;
 
 	hdr = (struct iscsi_tm_rsp *)task->hdr;
 	hdr->opcode = ISCSI_OP_SCSI_TMFUNC_RSP;
@@ -1224,9 +1221,7 @@ be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
 	hdr->exp_cmdsn = cpu_to_be32(csol_cqe->exp_cmdsn);
 	hdr->max_cmdsn = cpu_to_be32(csol_cqe->exp_cmdsn +
 				     csol_cqe->cmd_wnd - 1);
-
-	hdr->itt = io_task->libiscsi_itt;
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+	iscsi_complete_task(conn, task, (struct iscsi_hdr *)hdr, NULL, 0);
 }
 
 static void
@@ -1271,7 +1266,6 @@ be_complete_nopin_resp(struct beiscsi_conn *beiscsi_conn,
 {
 	struct iscsi_nopin *hdr;
 	struct iscsi_conn *conn = beiscsi_conn->conn;
-	struct beiscsi_io_task *io_task = task->dd_data;
 
 	hdr = (struct iscsi_nopin *)task->hdr;
 	hdr->flags = csol_cqe->i_flags;
@@ -1280,8 +1274,7 @@ be_complete_nopin_resp(struct beiscsi_conn *beiscsi_conn,
 				     csol_cqe->cmd_wnd - 1);
 
 	hdr->opcode = ISCSI_OP_NOOP_IN;
-	hdr->itt = io_task->libiscsi_itt;
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+	iscsi_complete_task(conn, task, (struct iscsi_hdr *)hdr, NULL, 0);
 }
 
 static void adapter_get_sol_cqe(struct beiscsi_hba *phba,
@@ -1426,9 +1419,7 @@ beiscsi_complete_pdu(struct beiscsi_conn *beiscsi_conn,
 {
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
 	struct iscsi_conn *conn = beiscsi_conn->conn;
-	struct beiscsi_io_task *io_task;
-	struct iscsi_hdr *login_hdr;
-	struct iscsi_task *task;
+	struct iscsi_task *task = NULL;
 	u8 code;
 
 	code = AMAP_GET_BITS(struct amap_pdu_base, opcode, phdr);
@@ -1449,9 +1440,6 @@ beiscsi_complete_pdu(struct beiscsi_conn *beiscsi_conn,
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
 		task = conn->login_task;
-		io_task = task->dd_data;
-		login_hdr = (struct iscsi_hdr *)phdr;
-		login_hdr->itt = io_task->libiscsi_itt;
 		break;
 	default:
 		beiscsi_log(phba, KERN_WARNING,
@@ -1460,7 +1448,7 @@ beiscsi_complete_pdu(struct beiscsi_conn *beiscsi_conn,
 			    code);
 		return 1;
 	}
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)phdr, pdata, dlen);
+	iscsi_complete_task(conn, task, (struct iscsi_hdr *)phdr, pdata, dlen);
 	return 0;
 }
 
@@ -4384,8 +4372,7 @@ static void beiscsi_parse_pdu(struct iscsi_conn *conn, itt_t itt,
  *
  * This is called with the session lock held. It will allocate
  * the wrb and sgl if needed for the command. And it will prep
- * the pdu's itt. beiscsi_parse_pdu will later translate
- * the pdu itt to the libiscsi task itt.
+ * the pdu's itt.
  */
 static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 {
@@ -4405,7 +4392,6 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	if (!io_task->cmd_bhs)
 		return -ENOMEM;
 	io_task->bhs_pa.u.a64.address = paddr;
-	io_task->libiscsi_itt = (itt_t)task->itt;
 	io_task->conn = beiscsi_conn;
 
 	task->hdr = (struct iscsi_hdr *)&io_task->cmd_bhs->iscsi_hdr;
@@ -4803,9 +4789,9 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_IO | BEISCSI_LOG_ISCSI,
 			    "BM_%d : scsi_dma_map Failed "
-			    "Driver_ITT : 0x%x ITT : 0x%x Xferlen : 0x%x\n",
+			    "Driver_ITT : 0x%x Xferlen : 0x%x\n",
 			    be32_to_cpu(io_task->cmd_bhs->iscsi_hdr.itt),
-			    io_task->libiscsi_itt, scsi_bufflen(sc));
+			    scsi_bufflen(sc));
 
 		return num_sg;
 	}
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 98977c0700f1..ccfdec3ccf21 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -461,7 +461,6 @@ struct beiscsi_io_task {
 	struct scsi_cmnd *scsi_cmnd;
 	int num_sg;
 	struct hwi_wrb_context *pwrb_context;
-	itt_t libiscsi_itt;
 	struct be_cmd_bhs *cmd_bhs;
 	struct be_bus_address bhs_pa;
 	unsigned short bhs_len;
-- 
2.25.1

