Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC44C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F97761408
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhEYSUU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44056 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhEYSUM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEaUA124412;
        Tue, 25 May 2021 18:18:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=LTahofXaYinObVRiw++DtKpb2JOGiS6YLPmcQ9nYYIs=;
 b=VACVO4cckYYFIm1VzFtHrMth7HE3NrNJUtRo+gVpdC1qS+lXHTLbUaQN/27nJu3nP1Yp
 +E5YjCBDl/YNfG8U6geimZy/f1fEpyJMq6V3+ht/3NchjN0lHBaqKmr6Cf11QhwLU4bq
 Rc6iwcdAWifex6uNupvuszOxkyZUACKgLoBPEfqvVDupW10riyMPl4gpGHaezs0V+ato
 Lj6nNzOhDK8/qQddfZHRLJnutAE5mZCYoWjHLOk8xcMtejHq/863P9VeN7auVuNR2JzD
 0BoeMceuqh7oiRFsbv63bwx+EW9TzJepiDbXdxUGIVSvPo7/4dJvzIcIKdTGD6eWGx9h sQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38pqfceyra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEtPu166079;
        Tue, 25 May 2021 18:18:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 38rehaq4xw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MoUx36kPXoSe9IexUCXU5r3P4XUR7op37M7h40TqFOoC09o/kjB8HUXe4llmZp0PE/ULKx1iP/akpGPslcGl9Q6AH8Nwj8Q6fJ2nU9M+k9H4orOO+KMg2pv15yshpxO+NZ1EHutTPg2+8WUQz7x8wxyA7gjIlJBA10ni1YPj5W7NBztH0huk0PEK9KKxZEN8s0qWixGYD86/nBLmdWopHl1djW7sqJRwACyW9vuib8WtIxS9GrVqP4LBpG4aGcOAET/47GNGcsOGRIP6vj5Cv1sSuuK38A5O+jRsmXofrNkaXM8tWiXrNSHJYh4dLFiQKzIZBtYMf3K3UjMyGVFKoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTahofXaYinObVRiw++DtKpb2JOGiS6YLPmcQ9nYYIs=;
 b=HsNaJmJahXajHC67KOeL3O9CQz3wJxJTVB6EsHdb7VJhKZ9YeTtKFxFL75KsU+mriLratETBCOAIdnex1q3ioZuTZnuDDwEBJtLxY40AImetA3SyOVJgq1xWFSbR7K8pSah6H9HptMCkuu0Ez2k4+5dyaILylR/QMNAy1BNQ19gRGUqIxAwCEy8qpWwn1nRkwZhZ63UfvEpPSDi1rR6r0T7i6itzhKgDFlsYCxamjsyMDzwes6qPGiouEtiRue/QIoRAeYRt6hfZFU0yeEAfpzvdDAPVflxT0VtK3X9/4xzxM73YUf15A1jJHGQYYVl0HY4vVgsvT1+6X7B/EE7AZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTahofXaYinObVRiw++DtKpb2JOGiS6YLPmcQ9nYYIs=;
 b=Tgw4QiYwxgGD0OlAEJpLbc87PDON1FbhiDnEpuUJSGFO33iIu91SSWQQV3iy5t2oU7WFTAXhFq06WiUZWJ4Pxh4gct3SSJPz6gsi+F5jsSnfxaxLkepHl3QALSft4BuGfxNNGoPk9KicygV0RJPifx7t5rJcn+I85K8SRF456Ds=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:33 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 04/28] scsi: iscsi: Force immediate failure during shutdown
Date:   Tue, 25 May 2021 13:17:57 -0500
Message-Id: <20210525181821.7617-5-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee7856ab-4a4a-4d69-1dc0-08d91fa98187
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47673F2860F090B19841BF47F1259@SJ0PR10MB4767.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Os41WPj24Zsx/9nqzKy1mFunBC+qIRBnv9uzfQL2PB3t1AtOUb6ZM7P87xu+TEKxe7OQDWsbhOlBpCTvYDSxbVIHt81RVlk9vhTAVt5wUljjptVD46wa0nrbX6h7/6SPf8m9+meCypV6llWej01WwuwMrTA9cigb1tii6LkAZxLTqJskXnskD00wKx9ZUm7FV33tKYyk18ownS8G37HyJZjYImr3HDYcAdtT/foRJkkqDQAgFdyO8BTQwZkANkDhCpAMKX6SnKuJnmgxf433R/w2jgeabPMp9EIUVEuc1exMiBEn+ZRRRgfV41WRgrZSYa9NLX0lrZgL5cIIIY6zee6D9dgoFTv43sH+3kOLFXGb33vYHhTXlJgrFq5bHu5Hge9EvHeep+Y8Uhbgz/3unQJtsQHGxqjeDC9tXAEWgwMwD1quq2SeHLr0RAiT36WBw6ELQQsMj3UahgVytlNO/hFvv6Njj+d4ZlYEJjbe+PsdAsfojFxZnBRJ0ozgLt9+1FBJ1FxvP3IiEi9+yQNoxes6/TZ31prigzcYsW2pJqrel4YKqZYJkw/TX5lgxqqPywWeR701BStBXU7Y784OvhbsKqAhb1DokM+Jj6yYAtIMFkP6gPo6KIEK1GK4DpFI/1L9idIlFazQd+pegcXbXsZfPk+b9mvtP7oQ05g/JWOncodo+w1Q3xU7aL0bPJRseTDhrYEIsymQLO3rgVikrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(38100700002)(83380400001)(6512007)(26005)(1076003)(4326008)(5660300002)(956004)(6486002)(6666004)(2616005)(38350700002)(86362001)(107886003)(36756003)(8676002)(16526019)(8936002)(66476007)(2906002)(66946007)(52116002)(6506007)(316002)(66556008)(478600001)(186003)(69590400013)(14773001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zj0N614fA59CfClGvvRs4LA1dSDTNq1q5V6hebWL0z5HXtnx0KO1A229KCzp?=
 =?us-ascii?Q?gm6db/liG/DahL9yzcomer0KiUVxgEs1FOCxU/EboglqIX4R9Bopaw3380zD?=
 =?us-ascii?Q?uk0mNfb4iIiNSM8690/MoOzpzvGLdfypBJNA7188z0w++/vp/wNIDR6V5SCN?=
 =?us-ascii?Q?k3VlqM/TQ8dDtGu7V9JSmbS44ORjVtve3YKyyV7FTRWp8JWbyfmtlWD4i4Te?=
 =?us-ascii?Q?tC3aKDnV7BNBoKT7qIaEZCo6gu3QfL469k8MpJZeySzjn/Ri9iWgO0lmPLWu?=
 =?us-ascii?Q?BxUyhewJ9wJ8SQsd4Udo4C5dpsqOvb610tOdcwvPylEaaiNJ+avnQqa+OJJR?=
 =?us-ascii?Q?2v5/g1oHVMkcyzC78Hj7gdS4SIS+WxunmaxWYM+hhccTsWnn59P4hJhYbhpp?=
 =?us-ascii?Q?zPw0yitdjfd5qtKCw39uvno+PoH/R31O/Jkd2dxgAuHKIIyMnwns0HliU54e?=
 =?us-ascii?Q?h8DMJgKc+9SL2AWRcYbusFr1OxBBKlDlhpsQOpViaf7pa5v0tviDbGrVlRE9?=
 =?us-ascii?Q?VYqLkh9OfumA2vBVs9ynRJeRvfuJ0ScxOK3bDuUDxi+n/FFoCdwtv5ahNmqd?=
 =?us-ascii?Q?rKm2Os3/g4shbWK86N3e3T+zZchih13VNkwgQbB+JW8w6oGeduWlZXQx2lNW?=
 =?us-ascii?Q?5KlxQXTt26TLrVwMc6SUYwqfF2Vp3chdirPu4ZUsFcgNEk5xRZSW/rq8XwUQ?=
 =?us-ascii?Q?HSvcy+pq7CWtlOWMjhRlxYJd1txvZEvKyZ/cDA1+mBw6Y/+XgUFN32jjiOjV?=
 =?us-ascii?Q?uhuudMt7e/1DuX8YsL6yUURln8Jrersdp53+tDNGHC9ulFo/bGPaD7ccB0Uk?=
 =?us-ascii?Q?+SoKiME8ZtUIV0WlkBFOxsvOEDcih7fM8T7aXYMMP2eTFim0Y2Jo8JDfTPU+?=
 =?us-ascii?Q?9QFsvb1bCcPXoidCTMy32xYhLnBQaerbt69JsdtK49V1l4gvyu0opSjXgMTn?=
 =?us-ascii?Q?XUqsxKaDKZy6UFJ5fwJ8mg0ohSg8yWYMdD4bqAIeoH6kbQME4failc0plOjA?=
 =?us-ascii?Q?L4xBTzDZ0WkajSVqoe4sTMfqi0CgHL5Gw3AlRIQWuJ415PR/BpjmF9XL5AkF?=
 =?us-ascii?Q?Wuh9Rz+Em4loi/Yd54CKjn9o140Eb2A32V5vExLz2HcINFC1CdHDwNPEhvyS?=
 =?us-ascii?Q?H4oCEpNVAEPZ6OAckHShQGSIj5C5IzLdwwVmcioITItDxUSS0ocoL7pumvXC?=
 =?us-ascii?Q?8hv9HEHXVhtUyNhgFafC1ED8vQUF4qSLeL0HeaQd7Uu4oZ3Y9VP6LVCfm7Yv?=
 =?us-ascii?Q?hv5xMsh+UyKm0ghaHZK3+trvj0DXDnVgDPKPSPyV9tXwq5dlnIR1GYfSq9m0?=
 =?us-ascii?Q?ExLaAnCaqE7Yq9Wcg1NW4wQY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee7856ab-4a4a-4d69-1dc0-08d91fa98187
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:33.3965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D/hp9scTPvADELRZ2d6aPUaI3zdWOx3XtofXHr/IhDKI2fxa1L9mjwUb6ETC1kh17G+20jpgQtjfJQ4+n9x385twgCsS24dxYUXxfmKdG+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: WdWj3zt3NBKM58DzxZL5fr2QpT_EKaPZ
X-Proofpoint-GUID: WdWj3zt3NBKM58DzxZL5fr2QpT_EKaPZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the system is not up, we can just fail immediately since iscsid is not
going to ever answer our netlink events. We are already setting the
recovery_tmo to 0, but by passing stop_conn STOP_CONN_TERM we never will
block the session and start the recovery timer, because for that flag
userspace will do the unbind and destroy events which would remove the
devices and wake up and kill the eh.

Since the conn is dead and the system is going dowm this just has us use
STOP_CONN_RECOVER with recovery_tmo=0 so we fail immediately. However, if
the user has set the recovery_tmo=-1 we let the system hang like they
requested since they might have used that setting for specific reasons
(one known reason is for buggy cluster software).

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 82491343e94a..d134156d67f0 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2513,11 +2513,17 @@ static void stop_conn_work_fn(struct work_struct *work)
 		session = iscsi_session_lookup(sid);
 		if (session) {
 			if (system_state != SYSTEM_RUNNING) {
-				session->recovery_tmo = 0;
-				iscsi_if_stop_conn(conn, STOP_CONN_TERM);
-			} else {
-				iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
+				/*
+				 * If the user has set up for the session to
+				 * never timeout then hang like they wanted.
+				 * For all other cases fail right away since
+				 * userspace is not going to relogin.
+				 */
+				if (session->recovery_tmo > 0)
+					session->recovery_tmo = 0;
 			}
+
+			iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
 		}
 
 		list_del_init(&conn->conn_list_err);
-- 
2.25.1

