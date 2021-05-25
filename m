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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8134FC47084
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AB6B613FA
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhEYSUb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55902 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbhEYSUW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFn4x074900;
        Tue, 25 May 2021 18:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=DjfzNR8K4fLJb/SKLgb8FxU5tf8aYf7eghQQdlkLlQg=;
 b=UtCkMVmFsfEyxudhIuU2rVWPiANYRH3CMnY8OVYxLs8o5Hbks/e8zQVuAADaEeHDSTi9
 G6aoQLS+2zzE77MAWPnT0D/dp24KrcIH29nmVb+YZSqMDYIVxoOVKIr0usYpGAhNnP9t
 3/sgLeRfI73+jEDBKhHr6cF1buSxkzQPMmCG1XILxlPigpiLdFDLEcpGuwo21mWTNym0
 n+sVIR0mX4eQxq86dmotsc02dHvsFlaLTI76AtlpYEkY0W7cu7UCn6c3eXAZd5S3YUF8
 agum0AHcuSOZAxy48iqyzfAyBUIzB1g/PUFgBXIhhY6Y40YZKi7w/4Qui1TaNSf3p/io xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ptkp6vkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIGD0n010935;
        Tue, 25 May 2021 18:18:42 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by userp3020.oracle.com with ESMTP id 38qbqsggy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VaSapR/aScU80EqvrnJQK5DYP6fGzXgao6CzzUZYQ/zwBtCD8jQ6isoCxqV5VHcagEUN1Qj5KSe4hk4IHtqgi8LYi7PWAKWqVK9iJ2otB05x42uCM6ugTQ7/S1iMwNR1UPUJ75ZyD3R5YdPsuTYDiQiXhaflB5Nl47SY0+3fCGTsquFEBH5XvEcvGwha+0DB/+bSjMRKClIuAoUjDcRI4kVcmgSE1A/EDzqbPtkLIk/aM+wPkrk1k3dNWWTG3qqBongInucCaaty3Bd/550rFWGwetKO+gWOgxCiZ5x0tslN/dPEEMrS/gn640ygrA6No0nBlYpqHeP4bfdOWPW78A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjfzNR8K4fLJb/SKLgb8FxU5tf8aYf7eghQQdlkLlQg=;
 b=nR7kftBQTtq35rLVQ9lXNO3KTsV+zKEJa+ukFXeLXrLikZHxc7lwM/YKEBNcO2AqSg2OHn7yygJVfFM3Ppl+hibQtv4OXHGKGEmnTfiKbsNpmFUIV9/bVT88c7rVS64qMRdGXgt29hrKexevI4mH/x7Y3+JaneTksQ7r7KJQD5Lp2utQ8ICw0Kh4cVosjiKGWRv3WsJGSrzgxC9mHkjtppoeyAt+rTUHG8ZF6wHuy6uynV83Ks7T4Zt+HSd+59GIL2H0NNW7ZjcgZVXrSOXGCZqcj3PuiWf9IG+Hr4Db+7liXD2VagZgi28/rBw5BkBc6tQhfeOTyqP+FL7LCg7LTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjfzNR8K4fLJb/SKLgb8FxU5tf8aYf7eghQQdlkLlQg=;
 b=su5gpUSGEaa0S6VwdzFgdPtTcDxsccoPqAhw18IIHnpM8dsgsA0XYtqaj7K6wGL/QL+mvc0mUiK/Au1EF3G64CrzhlgK0cW2/+qSESZfRpgbOYRVtFVgrRTC40jVvfhLBeAyp4wH+uoqfIu0efm478ExLI0cUt43prUAj59TVdU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:39 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:39 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 10/28] scsi: iscsi: Add iscsi_cls_conn refcount helpers
Date:   Tue, 25 May 2021 13:18:03 -0500
Message-Id: <20210525181821.7617-11-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f07f3ba-bf0c-48b1-606d-08d91fa9854d
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB38918377B7F9610BCA9AF362F1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0WEdpxy1kVLdteZP/0m0pJC2mo3plY/ImV0Lx6HdUbo65ZYukoceUsbqRYVMm6kT3KJ4o/bmg2gwhNKNc6a5sE7d4zyjUEoqdJi07w0nxAwjW1l0KOGJmuH9eybXQJ7SAyCbUKzX+68q224hrrFi7lxtxFvHGpE7VdaiIv1lpeJ2WqUwamMGK43zxljF9bz7j44KXR0LMzMYZpqt2zAsHDjHRW+TTXOVmcKTVfTIMw9oWWGwwnFC21MfkRVNbYzM1u6YQGZs0ZEyOz13k+T1t+F7PLQ/VGVkb7upox8ePO6t44S6T8lBsMXeNvBRp2ILgIe4mQVoXK4a9fpRTC7kesPgYDISo2+2prkZP60IBwL/CpMG+QNPm3NJkAcWxnQRCMZ5hmRHD0hg9i/9WdjB/zHAJdSjwnTVBxRDROU7hOtCmcMzpP02kkK28Mt3KiWUToryAwlHkYEqdlnaE8RtARPcoYm9pZAv7PEIToGvwRXme5hK5CgYRZhlIsHlaxvHVyJdFBPdWXsr5/6aBXnunWUzyw76jhwlhDDICSiRPTy+bGqUckPsw+7mZFCFgiUBWhxz22QtIwBbfsgUyex2gzH2M0X+Nf5OrdswBt1n7jEtT2n9lYQUz9jpuQPWBbzy7snEiBvKP6IskL3sKkmTkEFbFjKfPuZdwOuX4kDVrfdEqXUIkHV0YqRl7qAaXOXL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?X02L08aevO0WLgclmsa39kMNn2oMW8EQbzzd/kUmX/74W2c3SevYGQHeQZCY?=
 =?us-ascii?Q?AkzauQjTDTMSdyBjLwiS9eft6SzAHokzliuIeawLY8stAMRsflA8/aSxpuU2?=
 =?us-ascii?Q?1vNG5TUeCS8M7U9R/VybD4xvrRSz6UNxAA0VR5x/rph2VNqqO9F0LVN0UF1A?=
 =?us-ascii?Q?SWKHm7C24kvb8n7OYGC8dtPeJL8fhmXMS8qr5Snc9ViJONnzYfrb5wVx+CLU?=
 =?us-ascii?Q?GDAb2XkuEjDh9w5Ziz385LATGfLQdc+IX2OTn26wjVqWQOsuUcUq/yPbDKEc?=
 =?us-ascii?Q?JkYWBn8Eey7iUUEbwLULoGeDzfTLwy8pCZd5TEVExhR6VjdEfsVC/R12zziT?=
 =?us-ascii?Q?Al1GIfuc4cl+Uibk5xaio9KNxS5xQX99nOvuIPXstdeTMy2sntXalad83OBH?=
 =?us-ascii?Q?8gsGxzWqRxaa1HXwv0pVI5pnwhcdtYmbpNoiiXi9OSyFY/M7z3uMWAPr4QPk?=
 =?us-ascii?Q?6xoPkceyXxeGehTnB+H3uP6AylwgtwJtFzjkThqKUz7zYK54VQIrDK2Ltmxg?=
 =?us-ascii?Q?Jn2YV+PKWNMl/YoOHnuEBhF8kzZ7ztINiUQEtY3Y27gy4k9PQ/dM/fk54WZy?=
 =?us-ascii?Q?+lNBh/LMIpND2SvQV4Zw0mqQ558ppHFi4dGrtmUtAewnavm6enOr0ScW4CW+?=
 =?us-ascii?Q?tktZvHwsxqFWAIGqTcXcVSTqzVYFPr5aaLMPq1O/BNsIRxfoJ+zZvFGDjqzg?=
 =?us-ascii?Q?VYcjAbPYsJgfffmHi2lp0mXcMVzZfticXsIpYmp4EvyBJZlFAt+SVqRxuflR?=
 =?us-ascii?Q?knu9mfmdvEE0fgaiMIVlFrbm6h7Pdgw9AfA4usl3lxLZizW3A3EUaW9jg7St?=
 =?us-ascii?Q?U/MzpCyx6drCjMpPvpamKGaZfcOd6LOA2QNEv4JjD8v2cdlJaC9FQnRMu+T/?=
 =?us-ascii?Q?/8p/JwhZ3JT+y5m6En/xaG6oVAVdP5Rg4pfHBYo8wdcYtsuHxkPnEmXab1Ww?=
 =?us-ascii?Q?CGHah3BwdqzPqMgar3Y1txm5/h76KUQippClpXIt6BxT357ggG1SqXcJoQe8?=
 =?us-ascii?Q?7AvlYpSgP/4dIO/KYRt4Q3YUGHZNxgD1Qc5cRJPRYpsi1PY23dxWUWqOnT9d?=
 =?us-ascii?Q?Y90BP5R2yRi2Sz0zzQchh2siJKYFEmsOBR8XlEEowPts796jaqICPYETw2H7?=
 =?us-ascii?Q?KppYYeEYRhZt8M3CFHAvfqvlzr0cVDF2caK1gKTHJVajdrxBQBHt6A04/FuI?=
 =?us-ascii?Q?LrzTD5tb7hj0/jetHaREzBYuWpKsPJJ2cqoEgFFvJMGwygrPSE1+reVmutlW?=
 =?us-ascii?Q?RpAQKoHWXdh4WhpRYLMsm55OTykTB7ttgAMYB9L4FO3/OUC7BCaJIIwFbSA5?=
 =?us-ascii?Q?2jn+ZbMW0YajccKdsd1RzKcf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f07f3ba-bf0c-48b1-606d-08d91fa9854d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:39.7529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P06JWbiLDZy1+tjfq0oQc3VDog3I+ONmBCsjN2bNq9x7NtgrWTswTef6k+jwjv4yY49JPDCUOmg4+SuQ3rjkP9F3t3qlQDbMo8XNoaDfBY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-GUID: UpqcciDhtmhc3FWmCxJH_2qPskAEeb7n
X-Proofpoint-ORIG-GUID: UpqcciDhtmhc3FWmCxJH_2qPskAEeb7n
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are a couple places where we could free the iscsi_cls_conn while
it's still in use. This adds some helpers to get/put a refcount on the
struct and converts an exiting user. The next patches will then use the
helpers to fix 2 bugs in the eh code.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c             |  7 ++-----
 drivers/scsi/scsi_transport_iscsi.c | 12 ++++++++++++
 include/scsi/scsi_transport_iscsi.h |  2 ++
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 2aaf83678654..ab39d7f65bbb 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1361,7 +1361,6 @@ void iscsi_session_failure(struct iscsi_session *session,
 			   enum iscsi_err err)
 {
 	struct iscsi_conn *conn;
-	struct device *dev;
 
 	spin_lock_bh(&session->frwd_lock);
 	conn = session->leadconn;
@@ -1370,10 +1369,8 @@ void iscsi_session_failure(struct iscsi_session *session,
 		return;
 	}
 
-	dev = get_device(&conn->cls_conn->dev);
+	iscsi_get_conn(conn->cls_conn);
 	spin_unlock_bh(&session->frwd_lock);
-	if (!dev)
-	        return;
 	/*
 	 * if the host is being removed bypass the connection
 	 * recovery initialization because we are going to kill
@@ -1383,7 +1380,7 @@ void iscsi_session_failure(struct iscsi_session *session,
 		iscsi_conn_error_event(conn->cls_conn, err);
 	else
 		iscsi_conn_failure(conn, err);
-	put_device(dev);
+	iscsi_put_conn(conn->cls_conn);
 }
 EXPORT_SYMBOL_GPL(iscsi_session_failure);
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b8a93e607891..909134b9c313 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2457,6 +2457,18 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_conn);
 
+void iscsi_put_conn(struct iscsi_cls_conn *conn)
+{
+	put_device(&conn->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_put_conn);
+
+void iscsi_get_conn(struct iscsi_cls_conn *conn)
+{
+	get_device(&conn->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_get_conn);
+
 /*
  * iscsi interface functions
  */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 3974329d4d02..c5d7810fd792 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -443,6 +443,8 @@ extern void iscsi_remove_session(struct iscsi_cls_session *session);
 extern void iscsi_free_session(struct iscsi_cls_session *session);
 extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
 						int dd_size, uint32_t cid);
+extern void iscsi_put_conn(struct iscsi_cls_conn *conn);
+extern void iscsi_get_conn(struct iscsi_cls_conn *conn);
 extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
 extern void iscsi_unblock_session(struct iscsi_cls_session *session);
 extern void iscsi_block_session(struct iscsi_cls_session *session);
-- 
2.25.1

