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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC73BC47081
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0CAD6117A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhEWR7a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:30 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46498 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhEWR73 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:29 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHt06x154060;
        Sun, 23 May 2021 17:57:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=iA6uNZnaiKkDglyIdBApqOkWpWD0i1ZY/hgDyC5w8j4=;
 b=up8sKzZjoVG1DnXX6gmwg2saGfH+eiBuOBZmHX4Oy5Gqb1vSkKHvTCRO1z0E/m6ZvqYL
 XoofDXIkfpicMd70qpClqH0XtomCh+DZ+N3eQOQxS9BpuuN9VobsDlpnuDW8Il8xrOlS
 wwQvw6NpWbyKKz0q6h8PwrBFaR/xvFarQ4J2qSePIpwLZDeODFABfKZkVNMjxoDCNRVn
 pJTJr5WZrWAih3Pro+wh4pXguwnO2o0iaa6PPkPeRJnbTKXXgRV+maPS0hVDUXi3p1PL
 wpCF5fXvn2gQLL9JdrU+/yeL9UTMLOEW3SVQBGDgToNCxeyF95HHUc2+YuGwLYSaFJQg aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfc9ja5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHu0G6119789;
        Sun, 23 May 2021 17:57:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3020.oracle.com with ESMTP id 38qbqqjg5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1clrdh1YVRG7zf/1FbK7MOuB1OFdXEagdt7ktGJ39VZGIxbEwHczHQ+5WSj+xCKot4MLJDl0nxRAX6OlCHEzwjZW4d5RK/WYC60Y0VdsqqAc5jSYtZlLQ8pV9SqRdCaFuj2buznqM9AJJ1P9BSyD6ERQb0bvh9ITP/Ec1qS/xboW9KimhXv0xoQz9n9qMXQSvkefJWBxBiiwUYyEL956tZW8ASMLW+OLnIvvgHtAWSUGQ3MvOsVt4hJlPAxEG70kLIHZFyEWhvAjZMGwK+cEmgG9N9bmgBFwtpVcTP+Dsn5cmdYnCq3xy9QJwojiw+TGpMesavgtCAEH6jHiqlzmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iA6uNZnaiKkDglyIdBApqOkWpWD0i1ZY/hgDyC5w8j4=;
 b=kTfAqzIZUMe0Q5b4J6VHok5J8m19//A/9g2ZOuLj5tL01dWuEhAlOkIiFZGt60Mici0WBIFzn3Bfr7gpK2eOFpwGVp6cgO3OT0to1hUgIKjt+Pb02cliw63+Z70TT+9MFqDIyevCX6Bp7qdQHK4KnFGB9ZNCKsc2jGqgU+AKFIrmhblhacqeh00uwkoHPte+h3sjuoGoQ2pAbW4JBTmz3AY5BtfeH0jjWYYwEfapfl7E7Q945TT5VRU3onoknt37ZgEq/R0+EwEyolpISU4utB1WFrNqczLYPp43IDk1Zle+8vMbwzi0aYcK5Y4PWkm4+9TloCug0tj2QYohwCtuSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iA6uNZnaiKkDglyIdBApqOkWpWD0i1ZY/hgDyC5w8j4=;
 b=qM+xa2ldim8B9x10SruYzoYQCO7USdGTQnMv/DK5Jun9cTMYDO3BLZ/oXwObIijkQ7VWto+GE9fRpHSXlvW1Q0sLdZbLCJHZpQyg2iAagaHW0haQnEcXFdxZQoBdnQFRgRqvtjvIMl+ydUwkHSNpWGXMCo+A6qn9tDgxKzYVOO8=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:57:51 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:57:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/28] scsi: iscsi: Stop queueing during ep_disconnect
Date:   Sun, 23 May 2021 12:57:13 -0500
Message-Id: <20210523175739.360324-3-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:57:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37dc5bce-c7eb-4d9d-40a7-08d91e14481d
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4004B53F8D640818034BF36DF1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K1fpkDmx8ZdjaxDXVCyGgcz3pZW4Jvl9/SDhuHxaxEBAAxNxDGz4uLN09Vtdi5aWHA/0zya1W9QBg/qw3bBftPPjDwsY9MZImTz2S3KOl5GnvU+3T/D/YRr0lZzUYmWkmS7Nblh+E5QQ7PwfV761gw+VWt3dsEjNr+2J1fLJ5YKbvblang5+1drJ2Cc7wXKns16DtzISrsiyEYrXu0VsD6YnBBVycEczBrj6yS9kAfe0zQm8i2bbKA9CrS/vdTHsrEQrfmCibCBbW/rzurOPxT9jF+LNVLZkwv5R1NI7Z/hetJE4qrHA51JvA0whh/0PqfJs64iW8y4rORxaoxFYauB/vuJj+8CgfCS6j8hY5NHwNJXOGK1WcFah55PRlGKGSryaA8nO2GEP8r1gORjS7fLDVlHLU6OX53bqd5TWBqxYHdpdJ9AVszuAAnq/bwfQjgqlzp3djGnQleyejN+OrJaA6gUqKEtVQ3KBjx7BT8BtUHJ1Ovb7Fx92vY+2JKFq5kLytV1jUxs75d8EE+gDOXM8ufflePqxuOnc+00KkANsrbJZnXvpoAEc8tzQhTN8fPyZoE9bA2OtkmjzHo9nSvNgcOhM76QF2r55okzv21VqLeOWTeCCxi0wpClTnaQgA98NPYXEM82ZPou/r4meK2sK5SzgYzlg4xvzlt/834Ddp67AjZ1LH4uC/MQdgBX4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(30864003)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MEsjnqiKJXMwQJA4vl7l0jz1hcYK/+X/SyGgLC15piAYDqeG1bVyPfTgmW2B?=
 =?us-ascii?Q?N5veVOI0a/rjMfrKJPhKV8ARAhON7149s0zdTFDJDpVShD3UnHxLH1nXxLGy?=
 =?us-ascii?Q?vBcbNlOE6nayySzkmH6afFu8UNQmhPA90i94J+L5gn9yQrrgc7rsIU8vl3GO?=
 =?us-ascii?Q?zkq2vAfKFnHwO5w47Ux0vo258qZpAgAeU9JUPcDrq4kZWPMfOtGg7gKSkfei?=
 =?us-ascii?Q?/ptSyqfhj2O2qtiAu0H+f2brdUb8BT09M2Kg9rH11F4nT+RUceNoNp8QaPuF?=
 =?us-ascii?Q?91OkczB/V/pfpLTHiTHOUJyvRBFYnhE8+eB0Gxh8fSbtDz6M8p9Z+4oTPi2T?=
 =?us-ascii?Q?kbuZ++LMFkJfM8Z1YeRyHFez/CCoEKmPPOlR2uPBtoTKkEAilHwsUU6V6WRs?=
 =?us-ascii?Q?x0L5+LI+u0bfkB8MNL67eVZqS7aPQTmNOo9gjqmVWc8jPBSrkY62TrtmBzta?=
 =?us-ascii?Q?TIEOyxYhCtSQudL0vmouj3f5mjsz++zcWp125hpQ5zmc0OPkDWHyZIePFoOw?=
 =?us-ascii?Q?Fsr/N31BO2C4tlVvMbfu9pvK/OV4cfiHzSy24cTFXr/n97f9cLSHeFyzJHUP?=
 =?us-ascii?Q?b5vzLSdcjk3I0yiAlNsDPrT9opb4+1zF9zVwyCpWjDsJzGrf/MNso7pcp+m/?=
 =?us-ascii?Q?HWIBuPg5mzE3qW33TjTs+W+JEopPvmpcMTQkiSDlH/UN5DsgDRcUomYF9Vgj?=
 =?us-ascii?Q?RxWIQZfVqPXAsTd7NUy3ahQil/5yCbTXyxXCHM0AHhnUPX5+y46hEYtILsDf?=
 =?us-ascii?Q?lbRMguSzGBQAJu60uEI1GjtqrPUL6YjgmD3ERulASMLUZDikHlJPAgbBTd7n?=
 =?us-ascii?Q?525+3vKuFx94+2A8VVC2ythuK6xO/nZ01R2zD6OfIj+kacFd3QrMuQhLdvpG?=
 =?us-ascii?Q?Qxokzm4oHXsyAki+Ap1Hnjo2XoyTRCfAm/Wau+5GVNl3+LJah2wDMf1Z4PJb?=
 =?us-ascii?Q?oVuCxYDAP7sAPaCR/8i/BP9nYl45Q+2Lsgb95kOW/LqEN8YBnYJCQIHWVm1v?=
 =?us-ascii?Q?tCntv3Hd2lBmw+XwTzuBLbQf0HnOWATYsab5DX8nlYgAEMdb9u2lOqvZt6ri?=
 =?us-ascii?Q?rrGZqDeFQX5XjfJTHl4ZWTvDI5VkqUEjMmYy8ye9ao1x4dI2D/jl3+4oDY8g?=
 =?us-ascii?Q?dbUhwFlrRCxiVMYJUxZXP//fkxCnOZsSUDSrCjBOCtZy6oA7CYiyrovYSenD?=
 =?us-ascii?Q?ow9nPxSDHRV7BafyQyUU56DH6eAnE11CmVYx+yVtbGLvH6sUXt5NGVqdKZSq?=
 =?us-ascii?Q?LuhKlDp1wLMR6I00fby6Jh1FKA6ds8MYqqZrgCZtVqs5akcbG/HghU9L0qQw?=
 =?us-ascii?Q?ZFm3jN+d+F9z1F8qfTL65U3d?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37dc5bce-c7eb-4d9d-40a7-08d91e14481d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:57:50.9620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5uQpw2xSpenKJQZvT6sPTp7+Bc+4uhfjqQUSBT5cRU+QUbMvzuN/AFM0izPpLNJmI3O5AYjUVINqtn0Tu8jdfdWscFDA3mqN4oJ6p+1jRW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
X-Proofpoint-ORIG-GUID: pdhQKhDGF-e5Zns3KV1QR3-MTUBOAkW8
X-Proofpoint-GUID: pdhQKhDGF-e5Zns3KV1QR3-MTUBOAkW8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During ep_disconnect we have been doing iscsi_suspend_tx/queue to block
new IO but every driver except cxgbi and iscsi_tcp can still get IO from
__iscsi_conn_send_pdu if we haven't called iscsi_conn_failure before
ep_disconnect. This could happen if we were terminating the session, and
the logout timed out before it was even sent to libiscsi.

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
 drivers/scsi/libiscsi.c                  | 70 +++++++++++++++++++++---
 drivers/scsi/qedi/qedi_iscsi.c           |  1 +
 drivers/scsi/qla4xxx/ql4_os.c            |  1 +
 drivers/scsi/scsi_transport_iscsi.c      | 10 +++-
 include/scsi/libiscsi.h                  |  1 +
 include/scsi/scsi_transport_iscsi.h      |  1 +
 11 files changed, 78 insertions(+), 11 deletions(-)

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
index 22cf7f4b8d8c..27c4f1598f76 100644
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
index 203f938fca7e..f949a4e00783 100644
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
index 4834219497ee..2aaf83678654 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1387,23 +1387,32 @@ void iscsi_session_failure(struct iscsi_session *session,
 }
 EXPORT_SYMBOL_GPL(iscsi_session_failure);
 
-void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
+static bool iscsi_set_conn_failed(struct iscsi_conn *conn)
 {
 	struct iscsi_session *session = conn->session;
 
-	spin_lock_bh(&session->frwd_lock);
-	if (session->state == ISCSI_STATE_FAILED) {
-		spin_unlock_bh(&session->frwd_lock);
-		return;
-	}
+	if (session->state == ISCSI_STATE_FAILED)
+		return false;
 
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
-	spin_unlock_bh(&session->frwd_lock);
 
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-	iscsi_conn_error_event(conn->cls_conn, err);
+	return true;
+}
+
+void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
+{
+	struct iscsi_session *session = conn->session;
+	bool needs_evt;
+
+	spin_lock_bh(&session->frwd_lock);
+	needs_evt = iscsi_set_conn_failed(conn);
+	spin_unlock_bh(&session->frwd_lock);
+
+	if (needs_evt)
+		iscsi_conn_error_event(conn->cls_conn, err);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
 
@@ -2180,6 +2189,51 @@ static void iscsi_check_transport_timeouts(struct timer_list *t)
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
index ad3afe30f617..74d0d1bc208d 100644
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

