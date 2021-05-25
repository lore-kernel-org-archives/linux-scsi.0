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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8AA2C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95BB061408
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhEYSUf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44228 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhEYSUa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEtZc124464;
        Tue, 25 May 2021 18:18:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=+0w1tfrNNbWGlaEu3BWp0wm8JnNPsE4tlkR1NshXag0=;
 b=IZ8tT+Np/VVXwLQ4jHDCcno7n9TO+dpM05bjryL3K6se1//QXjl6DiAtl5h9JToRMLRI
 zG1v/zaW5c682yyE3EOKkww8HzWQl24XJBFSlGsm58PvTFOuTWEUjDX59WWASiwGOgjY
 1gBtCkuXxb/V2i+zUC3T/jHl3ure4taZh8MUgO2s3MvpourT4c6kicIfyaW2UVQ6PAyd
 NkLGoudlEftwo+HhmkRq5DXsHig8rUN0c1OlFVKjbrq0R9Mnhq+Gqjh3afGTzDD8XJbO
 Am1tDcLPcac+s/hil/fh4662yFvCmsPGlstjylTLiXGTdSuXv9F4Z3oaszSsSTryhupA Zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38pqfceys0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEulZ166263;
        Tue, 25 May 2021 18:18:53 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3020.oracle.com with ESMTP id 38rehaq64q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DozL/uE+uJmTVUCDrGRDjrZBgrfYgCOkZOkUi4yDWCKmrbphbs8brKDVhTflc+s+7GTl2VF9Kmo39hWR3QMb+LdvD2ZzCF2eK1vvrSU8sUH9D75aWuK0ZGOyEJoMloha8M9yh8mWLANMTeyAsPd9DF7uuTgUQYgY2YPx0cIalcTZkZcSgxIrJYtQ+YZI7Ed5eLko6w1Zx52HcMko4qOvUcIs2hst443FeEz/K75ZoyP4t0pF7rLAW/l8X8ygQHsextaeaqM7dUykxkok658wfFQuPb1iNDG9ZbPdveU4LUlhFXK50vhT1qsMfQiLniOZgSSols+5Abimmh89o4aBAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0w1tfrNNbWGlaEu3BWp0wm8JnNPsE4tlkR1NshXag0=;
 b=IBenmJD1J0svxO/lHp4knwyB7KG+YQOn7/rcv8bx5zUMjZaU8QhWliOU0qszkjxVyXma5tuhq6UBHPWqZAnbvNFfAonQbvzLOYFWyd15yzhpVyqLAaTUS2ayJfICXPA7WV/6LojF8cuPkCqcSlPNNFYUZ0QboJuq1ekNJcyk9QOUyIEFsbQNvPzg8EldEciVBA0HUgCdmPYML0bqEs+NvYIMYeAnZyAxCN/dun44WKZ2hkiEu9cvoqiJ2ym0ndAMC348iUJttgtbHEoi8IYWLbdqTCw58uC8VXF9ri3ExtqhZ7Qq0vlKkZC/xWQFcSX2vD0y5KSSiSZ3SlJncfj+/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0w1tfrNNbWGlaEu3BWp0wm8JnNPsE4tlkR1NshXag0=;
 b=Kv1INxEEBgTM5q2VNGJamo+sG0ErhpX/bQAWAHIQYkNZ98S1dg8GD6UcnSQDBIR8DqLK5r33iVp6fkAyJwyGdJVvZU88CJ/ooEiqcaiY3AeqitX6vNVcbs53emFaAtG7lTjm/CPzwMtA3BlttilBe/pI5C/LQ9mO0xupCivp/4U=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:48 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 18/28] scsi: iscsi: Move pool freeing
Date:   Tue, 25 May 2021 13:18:11 -0500
Message-Id: <20210525181821.7617-19-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac0f62c3-c1db-44ec-f788-08d91fa98a7f
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB389113D8CD526C91DA91D6CCF1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DPWThHLt1ZwD9/Ty2/RryArxGNya2AhH21hwAySgOvky0lLnIoLRn/Gim93ygeldt3ec+JL4+j+I3UCAn2zmGYwWrBBYls1nbYV552OZLWb5aLQPwx6phtUOMmYBvDZMtgh+6gGPC4pJGrTe5MugHL6eLEO7YFG0Qv2nYysrjGWPPNLCXRz384r7m+uWdMQQs9o8qh1DBuCxgbRBoalVhfSdWvJ6V1YpRxHlquvMRn3tBDp66CogaLvkBWkbxwXosjQKcqdt76QMSXKeyLWmGjU9EniPxv3uCzsPBh1pULQzuk2OMDhuiqieP4R2vfy8OUcrizsesHPq2SD1vtHUsOBPIyTdZ9f8WYxOsdCkvXH6XwG75ptLs/ad8989wudYjdg5hjlejJZQ7PD2bxgDaEtz/r5bR5NuaMXQqQHDUVSBtilLBo5rJZD4eL4LlRoY5DscqAB7Ynkj/V7c3LVWvIJXnnNRIojdMWQfCoz7tavdmn+DxnaWErlLG58F/QjUFikB3qRID0Qms29OoQKC6c7QUk1V5PU6eYgirRBoM7k1y+uxmka+z6mW6w0Wh/2FW0aOTJj0jiP1OJBu0CjmJPP42a8bhhYKNXSxUUN0uvAfl0VE8BalRGPw462rpsoxdpM4XxT2kSgsYxOvfc2zSS1AH4Klo27VlJ5QM5WjPg+tnV3pNapp0tL8THDn2QUU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(4744005)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lTWf+r/dQ4CrYNEZBH4EsbKJNW2I/oZyGhJyfyBAgzx7no7W2AjPrtr1iTiW?=
 =?us-ascii?Q?2hFXEWVUTMAMYe5Uk8tniYSaGjNPVSg+tBWJL/umGN9Y5OFy9jAifxn9IXY1?=
 =?us-ascii?Q?DD9KCgIu54ndCgYZT3SJXaZLF+0Uji1FwfxZTUxHp9S6zFiW+vW/vi2tTTVM?=
 =?us-ascii?Q?UMGjn274IKEZwLfUBXv1aSYgz9ZFMDW7ozU4gFB5WS/eB40SMXO/TpROs7um?=
 =?us-ascii?Q?GbqzCe0vJkyu9B4Iz9ePqXzBWHe3LANOpLhHRM8kIc5UPAG+2/KXzirnCIDf?=
 =?us-ascii?Q?inqewONfJClQWcCVLnPLKctP6tyJVY8skJrcLrBdPVGZsGrD5jmh/gavpgZX?=
 =?us-ascii?Q?35fEfZRD+1SSt0Mn3NMixkIm15eLbLF9lrNk6qSSUHSJhKJwbwE32eP5+PT8?=
 =?us-ascii?Q?bp41Z8i2NtYd3FZB7pbPR430jNJUWQIV8UUEYBxn9zfY1E2dBTFuss4YnFuk?=
 =?us-ascii?Q?KmCGThgpqR7eSlgBbgCkKZyE8ud8JZ1ml53uKnmS1KFz07e8WgqoKaM4QVjV?=
 =?us-ascii?Q?vL7VSOCCQ2+eq6Par3HDCtd+0eaoTg5WXyVdX5xMJNFmepDXUjAz0QOmVCyy?=
 =?us-ascii?Q?UBONNORHNAszUEo++3eDpQdG8vAYoUmSyUJkiD8EKqfNoPIBMOLXtgsXJqjA?=
 =?us-ascii?Q?HKWbe+dNgkLW1G6oAdkXfLLdUmB6ibpqniKqKlCM9CRgmCJZhUoqcVTXJXfj?=
 =?us-ascii?Q?NFcWx/nQkPiVviDdpZiPkS9AVL0EO7g+1L6BDQnI2R6viOsN2ZQxEVKthKwJ?=
 =?us-ascii?Q?o8p+96dPuCISEEUTYFRxmenw46PefYO508hvh3ImMVgRJ7s28scoK3lBiU8N?=
 =?us-ascii?Q?jxR053nER5/CCQ1DYCRMqlFhUKolkoSVVII/WJ7NjwhlveWcXKzS4R+gKq4u?=
 =?us-ascii?Q?ovjKrfdsmR3yGVZM3/dJbtT68AroEvXDTKF3fC7buE9rxqsqerx5RUyHPVX3?=
 =?us-ascii?Q?PwCW4Sh8sybbF8OgZV0HXqkXG7zrTx8j8AwqvATwb4ZwhPfjzc0YVkFL4PS8?=
 =?us-ascii?Q?cLUvknAG5QNvhJRn6jlYyQJ8VaIAKSHftPU4WgEElIncZpYLyo07nEh2k1Ry?=
 =?us-ascii?Q?Tuhl7Dd8zYXX+VTcxzv9+AIBG4NT9cbKBGwzK1fA5UzeAwtz1NHVPkvBOI3b?=
 =?us-ascii?Q?LU5tINgE6K+lNqX7CB1ajhN0GMM4n0I5BrKXhzNioeo1DgETa0rAxs6CXLHB?=
 =?us-ascii?Q?BPehhRqHxahft8vIUd7LwpoU1enpZni5mlUJh5urxfxTvDuT7JszW4+RSiZl?=
 =?us-ascii?Q?6VrFpZQeHGzD2ssKgrkIZzh+S0uyXeMer8qYQ0rrk7N/1P7tWN46aF8DAgZS?=
 =?us-ascii?Q?j6aTk7GQbgVnPmMgUPsGJQ4I?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0f62c3-c1db-44ec-f788-08d91fa98a7f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:48.5330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x4LIi3UkZZd3PBxAOoBJuJoy7soBaEpTHcaTtm+iNTLUWDqriQ/jMSl8WvfRrehVY9IwfeiIFOsSF9Itvev9E4ncwlK4J2BXrClZDOossek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: EuaIt5lUyZfjHrgTfOA2r9L_GDrqVJvl
X-Proofpoint-GUID: EuaIt5lUyZfjHrgTfOA2r9L_GDrqVJvl
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This doesn't fix any bugs, but it makes more sense to free the pool after
we have removed the session. At that time we know nothing is touching any
of the session fields, because all devices have been removed and scans are
stopped.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e57d6355e7c7..15630f5f2553 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3001,10 +3001,9 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	struct module *owner = cls_session->transport->owner;
 	struct Scsi_Host *shost = session->host;
 
-	iscsi_pool_free(&session->cmdpool);
-
 	iscsi_remove_session(cls_session);
 
+	iscsi_pool_free(&session->cmdpool);
 	kfree(session->password);
 	kfree(session->password_in);
 	kfree(session->username);
-- 
2.25.1

