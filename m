Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A982C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4298611BF
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhDXWHF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53490 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhDXWHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6J90124436;
        Sat, 24 Apr 2021 22:06:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=IYPZjOJFOM65SKaWIGXna60ujW74rVUhyFbX0xopRWg=;
 b=ZfHcUmB9F5eTkH5DongPyXvg9M7yc/Xuf1FwUMysGpA2FKPy28vpiF0sDuvRBRvwpBOl
 zbEcU4GZaxkTavmlJO+XZrCvRFZhZ/9WZBA7FHBKhJAYRsxfEcH6QYGNBR7EVY/grk7y
 aXrSpt5Z3jcjXRIV8M3QfsoPUn9Tsdxc17EKq0536G2t8QDohDKu6xrMncERhhHYvVNE
 /RnU/d4rikKq+nwbgApWi/Em4EZfEex0fEwIbo4vk7oxXyFuncocxVWLQt65VPlneKRe
 benHV3jaX+lgkNacJKi156nJEobQEwyZbB8iOFA4J3YNTdQ3wpZ2bSEMyA7DqGP3TGWK Qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 384b9n0shh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6Cae045579;
        Sat, 24 Apr 2021 22:06:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3020.oracle.com with ESMTP id 384anj7ut9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCqFQ8j/dmi65Qc5paspr2SChmU7f+7m68BufE0MfPQGZd49tXaDyAH61aavNPU7OIeMrzjtPNsClkO94pDvIpt0QMD5LLUCDLvDCFlp4MEywQ1xvwqI6fDDEQz3oo9HxgXWF9KJdwqEvwmCo+SjRyjVQar032AL4aT2X/71Y9Wxb8DMlJCYD4Qhxeelszvk0oejxANueAaQdWDFzO4HVnF3kM6MQTE0/fXnvtY1XuOlaHd07E2YSVU1CLVCooj0tHXibREwkRYG/76lIXAmXufp/SPG9JDn9GK8esztkHjH2xsRlasWjWggxlgvVJ4YUwsK2Q/cQkOMfBx+C9WPXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYPZjOJFOM65SKaWIGXna60ujW74rVUhyFbX0xopRWg=;
 b=bx321mqQTSa/Y1Wt0rabOo45Zpfn2353QC/LRJcMsofWBiBNMgHjLhLsJoX66HOsua3qVlyYbbAzIksEVhFpenVfPaiz0MLZQFmKe2PjAWAJ3VCpAEM13KYZ/Opyn+mlnJr1RtVz47EUg9aM9hZ3GPTmV4nO6LgEq3endq8ROuHILnVFESi3lGipZoI5hiZkGDKnwNWUIknnE+iEgskkNgg9IvpQ/Lorsayib4hHKbMyY568HCugMf1FGlPnQY+mw46T1zHfk8WtSQGYznODHa7390W9fE6X7mpf04xEcWosvvw0xZFUbu9l0ky21TtriMpHZ1cRwsHyQpQdxmW9sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYPZjOJFOM65SKaWIGXna60ujW74rVUhyFbX0xopRWg=;
 b=iqVTFbkSyWojRG6Kv19dmx+SXo5V2qRxqqcuMOQ6dJSqCBIXYIYmPGeynHrsZFoWUAYM4lUh+jsYKU5uchI7rZCWgyO1A9mFoukcNY31Ctul7zPz784TEe+D/SURL/T25O4CIXKmBcm9MQvfWyg9Cz8AIOWMeqmGtLyDdODEqls=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:16 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 03/17] scsi: iscsi: stop queueing during ep_disconnect
Date:   Sat, 24 Apr 2021 17:05:49 -0500
Message-Id: <20210424220603.123703-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53a00176-1e92-49ab-9826-08d9076d2e0f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33178AE4B3C884D447A23123F1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gNrpVJGlXX2R82s5jCNunIB/B7STmSlhJF4EIbe+IrcDQHkjz9NhUXJlxpN4gNeObAWDBDbLfoapoM501BGHns+vdWEv8YwzLefDWcS/TBw3FG1A+u1vsshGw/GKe99xddP13uPzvP+Yg32AHvpXuFxjunVUrSap7FI1hbm5mZ21WIlZ1B/AmEU2EL8HbxzaH9JNPkisIQpW06g0OupzOFUWGlzTtVQTeJphnwvpDN8asYkU7FkSVozxo2NcaZrARTl/s6uuiAuqt/02RnDqT/vihXeQqIMEUvgXOjCWExPDJBC7uOMpktbRmOoNUgRMrfW8LWgpF3lOhfFi7GX/gfiALQ8Iln3qgQ8i2s2f2H9yWb+h3HwK8ycvtt225Ga/TOTKtlqe8A+bqlxbOdoj6+Tm2pZ0UJeyjIzkXFiigsGqrkheprVzvkWlmeZJ3cAiGyO5O/OXbE13bomE2Hi6CLGRX7s1gQeYbQNsY89bwUUEyJ8L9MTwnfEwiRwme0D0aECkwq+J2FInLLkgGASPm4O90Pqu5i+z/4QajyvDNqA0BwdMDktjwArIxQgANmxoLS39ko/NyR+0kgDXXceepbQ0oGN2F6qnjx/Fsn/vxccIRgfhqNItAtO1wzXJyxhPYdRxz+9FrPwRANFrgt1NPXm2CMZ+WZISuXtfW/wgEimsyPnb8QWTm92AXsEEDcWb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(30864003)(16526019)(316002)(6512007)(8676002)(956004)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5i/+lLRTXXQL6k4iLYG/LYNE0a+5u9TmWnHo16e0bF8P0e+02VlPZAzXPFcT?=
 =?us-ascii?Q?TI2pPq5g80nV4a0JFvROYnOkIJr/Xpr65VFkU1i08NHT1DpgjzZz7+k4j0Yd?=
 =?us-ascii?Q?e11gXWXVnQaJjXcDDM4Q3fhrYxG0K3ykA0D///cOtShSjSGKl/srVjfO3NU3?=
 =?us-ascii?Q?Dj3dRvTXJgTTgV2A+fAI+oLMsQNuc7ojpRSkD6GfRXHdI+EcklA34252cJ2/?=
 =?us-ascii?Q?mxlUWd6a385LHdovZjVwciW1rYyCk+1RDXvf4tAi4ydAtXx4O6KMJy2hNTlW?=
 =?us-ascii?Q?CcgL82bPyBWeLXCAafcHmlHAtQHVKnlCIB8ZBtiy7ivla32iRsp9CeCKMsDy?=
 =?us-ascii?Q?rsuBD5sUwYaA28ZIeluNhD2cVysZNvCFLV/r9NjAFUaytOlvl1gUEWxHWX+Y?=
 =?us-ascii?Q?Nn7bTriZbf3WmzqgdygmMtXh/HGYNrmzgVHXbK3dAPOPfSUikkqOq+Vf1K9x?=
 =?us-ascii?Q?IPF/+ZHq16LppA1QjqT/OCGtdoZDQL6+b9ipfiCLlmeS6+cEwgDBEyiZ8BtA?=
 =?us-ascii?Q?uBApWYX1agKPeztY2g0wtbUeNsHBG4MFH70wGN4iCIxEFfiYIzzTyX0aYpk3?=
 =?us-ascii?Q?0lhhpLpPTiUlBSR76veoUuMZIU33Seizcs2yUJcocjzCzST8R3Hp6QpIpJkq?=
 =?us-ascii?Q?NlS2cKAYocCl3qBkXpf0a0ouNOM0YsK154/Oqmej5sC9Gvw7MRnmBNNQ7evd?=
 =?us-ascii?Q?hw91u2WVc1Dudcu0B6/F6kV655EygV+jzRmuiokTIRKHVNM/hedNoWe1zSCi?=
 =?us-ascii?Q?3dJpQQre18COub9Iqq/FYWj+QfKx1s5UQUTt2nlhONJiL0AILN2jPipjR3jD?=
 =?us-ascii?Q?eQM6lAVOQJsnZ8rs2BMz++J3kizRlXgRWSo5y2Tr+c3/6ivws8DfdZc0ngGS?=
 =?us-ascii?Q?gqPQK0puhZKx1ks2m9A1S3H2dKTtcSVsftlPyl4zcfAFO60G00F7kzK1OSse?=
 =?us-ascii?Q?nT8evFsoPxwwRvZXraPJAJo8MbqjSL0lQFfP34Cqwmjq9EJ9JOkX46EYz83p?=
 =?us-ascii?Q?FvNXuQHgU+4okQAJctTNH4lv7Xyh/P/P+vuNIBbNcrtqw4EUoO0AaZDDdKRf?=
 =?us-ascii?Q?zPWbGjtFqR1OWyNOJg92tTI1bYqvNQciDNh63g5lAio8PFMCUZ18uGu1QMk6?=
 =?us-ascii?Q?QPLQQahYoQD41gwdaFpV0KsIWw5Drg+1yOJhVKoG/iMzXhce+0P22ts1/G7Z?=
 =?us-ascii?Q?9kV6kxTf1LM5jUl4ag6niI39DkBsDo4sREMQUysQiDlCIaJ+m9L/n4W3Zn6w?=
 =?us-ascii?Q?OXskJwc2yNdDMPV8z6Carf6CCcEl65TIct0AG1B5KyXJv5rVPHm3OzxMw9/+?=
 =?us-ascii?Q?S+Tf0ndlTn7RwL1noOYO4W2x?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a00176-1e92-49ab-9826-08d9076d2e0f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:15.8587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +8YlYytj2Nk9U+9fxBA/gGz0/alSWYISLnvrhRorrKHV32skvgy2oRQVf9CdYAYdKYpHrc1p6cGZuczhU+O+kOmqvAHfcPS/2oz/csk8kxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: Ve2iehIzg0IqgWyLUwnCd_fpwHWsp1y2
X-Proofpoint-GUID: Ve2iehIzg0IqgWyLUwnCd_fpwHWsp1y2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During ep_disconnect we have been doing iscsi_suspend_tx/queue to block
new IO but every driver except cxgbi and iscsi_tcp can still get IO from
__iscsi_conn_send_pdu if we haven't called iscsi_conn_failure before
ep_disconnect. This could happen if we were terminating the session, and
the logout timedout before it was even sent to libiscsi.

This patch fixes the issue by adding a helper which reverses the bind_conn
call that allows new IO to be queued. Drivers implementing ep_disconnect
can use this to make sure new IO is not queued to them when handling the
disconnect.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
 drivers/scsi/be2iscsi/be_main.c          |  1 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |  1 +
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  1 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  1 +
 drivers/scsi/libiscsi.c                  | 63 +++++++++++++++++++++---
 drivers/scsi/qedi/qedi_iscsi.c           |  1 +
 drivers/scsi/qla4xxx/ql4_os.c            |  1 +
 drivers/scsi/scsi_transport_iscsi.c      | 10 ++--
 include/scsi/libiscsi.h                  |  1 +
 include/scsi/scsi_transport_iscsi.h      |  1 +
 11 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 8fcaa1136f2c..6baebcb6d14d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -1002,6 +1002,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	/* connection management */
 	.create_conn            = iscsi_iser_conn_create,
 	.bind_conn              = iscsi_iser_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.destroy_conn           = iscsi_conn_teardown,
 	.attr_is_visible	= iser_attr_is_visible,
 	.set_param              = iscsi_iser_set_param,
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 90fcddb76f46..e9658a67d9da 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5809,6 +5809,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.destroy_session = beiscsi_session_destroy,
 	.create_conn = beiscsi_conn_create,
 	.bind_conn = beiscsi_conn_bind,
+	.unbind_conn = iscsi_conn_unbind,
 	.destroy_conn = iscsi_conn_teardown,
 	.attr_is_visible = beiscsi_attr_is_visible,
 	.set_iface_param = beiscsi_iface_set_param,
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1e6d8f62ea3c..b6c1da46d582 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2276,6 +2276,7 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 	.destroy_session	= bnx2i_session_destroy,
 	.create_conn		= bnx2i_conn_create,
 	.bind_conn		= bnx2i_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.destroy_conn		= bnx2i_conn_destroy,
 	.attr_is_visible	= bnx2i_attr_is_visible,
 	.set_param		= iscsi_set_param,
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 37d99357120f..edcd3fab6973 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -117,6 +117,7 @@ static struct iscsi_transport cxgb3i_iscsi_transport = {
 	/* connection management */
 	.create_conn	= cxgbi_create_conn,
 	.bind_conn	= cxgbi_bind_conn,
+	.unbind_conn	= iscsi_conn_unbind,
 	.destroy_conn	= iscsi_tcp_conn_teardown,
 	.start_conn	= iscsi_conn_start,
 	.stop_conn	= iscsi_conn_stop,
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 2c3491528d42..efb3e2b3398e 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -134,6 +134,7 @@ static struct iscsi_transport cxgb4i_iscsi_transport = {
 	/* connection management */
 	.create_conn	= cxgbi_create_conn,
 	.bind_conn		= cxgbi_bind_conn,
+	.unbind_conn	= iscsi_conn_unbind,
 	.destroy_conn	= iscsi_tcp_conn_teardown,
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_conn_stop,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 80305b70298d..0f2b5f8718ca 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1387,22 +1387,28 @@ void iscsi_session_failure(struct iscsi_session *session,
 }
 EXPORT_SYMBOL_GPL(iscsi_session_failure);
 
-void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
+static void iscsi_set_conn_failed(struct iscsi_conn *conn)
 {
 	struct iscsi_session *session = conn->session;
 
-	spin_lock_bh(&session->frwd_lock);
-	if (session->state == ISCSI_STATE_FAILED) {
-		spin_unlock_bh(&session->frwd_lock);
+	if (session->state == ISCSI_STATE_FAILED)
 		return;
-	}
 
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
-	spin_unlock_bh(&session->frwd_lock);
 
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+}
+
+void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
+{
+	struct iscsi_session *session = conn->session;
+
+	spin_lock_bh(&session->frwd_lock);
+	iscsi_set_conn_failed(conn);
+	spin_unlock_bh(&session->frwd_lock);
+
 	iscsi_conn_error_event(conn->cls_conn, err);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
@@ -2222,6 +2228,51 @@ static void iscsi_check_transport_timeouts(struct timer_list *t)
 	spin_unlock(&session->frwd_lock);
 }
 
+/**
+ * iscsi_conn_unbind - prevent queueing to conn.
+ * @cls_conn: iscsi conn ep is bound to.
+ * @is_active: is the conn in use for boot or is this for EH/termination
+ *
+ * This must be called by drivers implementing the ep_disconnect callout.
+ * It disables queueing to the connection from libiscsi in preparation for
+ * an ep_disconnect call.
+ */
+void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn, bool is_active)
+{
+	struct iscsi_session *session;
+	struct iscsi_conn *conn;
+
+	if (!cls_conn)
+		return;
+
+	conn = cls_conn->dd_data;
+	session = conn->session;
+	/*
+	 * Wait for iscsi_eh calls to exit. We don't wait for the tmf to
+	 * complete or timeout. The caller just wants to know what's running
+	 * is everything that needs to be cleaned up, and no cmds will be
+	 * queued.
+	 */
+	mutex_lock(&session->eh_mutex);
+
+	iscsi_suspend_queue(conn);
+	iscsi_suspend_tx(conn);
+
+	spin_lock_bh(&session->frwd_lock);
+	if (!is_active) {
+		/*
+		 * if logout timed out before userspace could even send a PDU
+		 * the state might still be in ISCSI_STATE_LOGGED_IN and
+		 * allowing new cmds and TMFs.
+		 */
+		if (session->state == ISCSI_STATE_LOGGED_IN)
+			iscsi_set_conn_failed(conn);
+	}
+	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&session->eh_mutex);
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_unbind);
+
 static void iscsi_prep_abort_task_pdu(struct iscsi_task *task,
 				      struct iscsi_tm *hdr)
 {
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 08c05403cd72..ef16537c523c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1401,6 +1401,7 @@ struct iscsi_transport qedi_iscsi_transport = {
 	.destroy_session = qedi_session_destroy,
 	.create_conn = qedi_conn_create,
 	.bind_conn = qedi_conn_bind,
+	.unbind_conn = iscsi_conn_unbind,
 	.start_conn = qedi_conn_start,
 	.stop_conn = iscsi_conn_stop,
 	.destroy_conn = qedi_conn_destroy,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 7bd9a4a04ad5..ff663cb330c2 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -259,6 +259,7 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.start_conn             = qla4xxx_conn_start,
 	.create_conn            = qla4xxx_conn_create,
 	.bind_conn              = qla4xxx_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.stop_conn              = iscsi_conn_stop,
 	.destroy_conn           = qla4xxx_conn_destroy,
 	.set_param              = iscsi_set_param,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 441f0152193f..82491343e94a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2964,7 +2964,7 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 }
 
 static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
-				  u64 ep_handle)
+				  u64 ep_handle, bool is_active)
 {
 	struct iscsi_cls_conn *conn;
 	struct iscsi_endpoint *ep;
@@ -2981,6 +2981,8 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
 		conn->state = ISCSI_CONN_FAILED;
+
+		transport->unbind_conn(conn, is_active);
 	}
 
 	transport->ep_disconnect(ep);
@@ -3012,7 +3014,8 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 		rc = iscsi_if_ep_disconnect(transport,
-					    ev->u.ep_disconnect.ep_handle);
+					    ev->u.ep_disconnect.ep_handle,
+					    false);
 		break;
 	}
 	return rc;
@@ -3737,7 +3740,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
 
 		if (conn && conn->ep)
-			iscsi_if_ep_disconnect(transport, conn->ep->id);
+			iscsi_if_ep_disconnect(transport, conn->ep->id, true);
 
 		if (!session || !conn) {
 			err = -EINVAL;
@@ -4656,6 +4659,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	int err;
 
 	BUG_ON(!tt);
+	WARN_ON(tt->ep_disconnect && !tt->unbind_conn);
 
 	priv = iscsi_if_transport_lookup(tt);
 	if (priv)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 8c6d358a8abc..13d413a0b8b6 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -431,6 +431,7 @@ extern int iscsi_conn_start(struct iscsi_cls_conn *);
 extern void iscsi_conn_stop(struct iscsi_cls_conn *, int);
 extern int iscsi_conn_bind(struct iscsi_cls_session *, struct iscsi_cls_conn *,
 			   int);
+extern void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn, bool is_active);
 extern void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err);
 extern void iscsi_session_failure(struct iscsi_session *session,
 				  enum iscsi_err err);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index fc5a39839b4b..8874016b3c9a 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -82,6 +82,7 @@ struct iscsi_transport {
 	void (*destroy_session) (struct iscsi_cls_session *session);
 	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
 				uint32_t cid);
+	void (*unbind_conn) (struct iscsi_cls_conn *conn, bool is_active);
 	int (*bind_conn) (struct iscsi_cls_session *session,
 			  struct iscsi_cls_conn *cls_conn,
 			  uint64_t transport_eph, int is_leading);
-- 
2.25.1

