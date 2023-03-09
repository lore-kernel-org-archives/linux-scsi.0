Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B71C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjCIWe0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbjCIWeG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:34:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E57AF6396;
        Thu,  9 Mar 2023 14:33:51 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Lx526004314;
        Thu, 9 Mar 2023 22:33:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=COOGaSJHS4hYOkODWDBoMb2KgN+Wg4WHbiKbSajnJZ8=;
 b=QSJkgWyoEac1oZB5frqgnooZDZz4ihZtLe3z3Im55/o0btj3NYKlAmnjk6qIC4Y2U+ZU
 R0mgDs+IawkvBKFQ7ZhEe+YH31lMHk1OMp0PP0UbUhcpZNL/D5DramaS9N2nSdvphMO/
 DpimPtPGmQQnaeVkPWI6JM9QKrCjYvPzx70BqROpHJQt3x6veqwcEnwEhHTv3zTbA49+
 Q65NCoWmzcTge1+qiILahoyKKinUXYUFGQ466D3JgTonG1D+CHDoX/pyRotav6KGeXYL
 LDyCbAXM04/4VB7Z43qGiray1TjXULxLozAtks/fL21r1X0dZRMhWllXY3VVa+YYG8sJ CA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn98bq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329ME6Me015564;
        Thu, 9 Mar 2023 22:33:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fepe5yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBV6btduCs7uZpPwnPKaHMTn6+LzNr9qTztH9chsC5zpxPdFkwQyXME5wSQATVO1X7/X7QLdshVhlY1+Yj0n/75RVJa0Mwoclev1ZqC9ZqGjRvkKpnXmmHxnMPuEiCR1WcdmRGXAsg2wMDEw9wCwLOHPY+n/sEStYyikNrkLoWjeOKhRBsJfQ2TcIktkNxbAKL96hgZKYAPRaekzxmj7RxBDf2T0VCgxDfqpAqs7nOvniaTyk1OI2BQK200WklYVj3SiSPgVw+TeiJc9sUNjoG2Oj2UwV3XEdeeYTh8A+/PxUehTNB6Gh6QO3NvjOg1Boz4tXtUkSYgdO/eiOBNwPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COOGaSJHS4hYOkODWDBoMb2KgN+Wg4WHbiKbSajnJZ8=;
 b=RUhAteSB/lwru9zkxnyb/7e/vjNFgIpwj0t0wwjdbdw52BAK2x0AUVTq5cXgYK5TqBCgxPnhYd1dJya7kkiaeScOR6KV0CYfMUZZawWXi15/tOCJXfMplDqHWlijA6ai5CjiEyIyF2rF+pnkRV9OPPR4vKnS+LSnIs2igwIRNYqRjd9bM0BEjzlAVzBRK4o/tTHYRYeb99/5N5+7hqBIw5ZRHEVf4BYOR6pWKQGcHUCZbhuYv8hp3JfNAWAdN7yn/AvZSBnLs2nU0jMD3knp0q0XZIRwSwVx8VYw47Cb1aVrNz1ewa5OXVQ7aUAB62Gu3Cl1Eaif6BKyHVc9vr1WyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COOGaSJHS4hYOkODWDBoMb2KgN+Wg4WHbiKbSajnJZ8=;
 b=pTZ4bOk2yC6YqZa080XzS+VRpcgsZ8qyNIrA8irQ2h5yEM1Tx2jUZK31v010qcU9TB8s+PI6pF6CCuUs/qKIQcgaqGKveqHHoCLJ02A845KY//YDJoqz0Enu0dYb4oKcTVW4ZrP/DDgNGrH3b8DB8R3LVfdJvjtL+xVgMfK82LQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6782.namprd10.prod.outlook.com (2603:10b6:208:42a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19; Thu, 9 Mar 2023 22:33:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 17/18] scsi: target: Remove sess_cmd_lock
Date:   Thu,  9 Mar 2023 16:33:11 -0600
Message-Id: <20230309223312.94595-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:5:40::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6782:EE_
X-MS-Office365-Filtering-Correlation-Id: 5570ba8d-4521-4d84-f94a-08db20ee54bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AZHHJtYh+1akpDCp5BfHnScI0MJqjtyjPELemMZL25pWdmr0nbyfiQ0llPB/ImAJCt4zoNkl6b0jjvTj1jBEs4R0m1KaNE7KTtLQ7AK7j0ft/BdxLOvmeQZ/Q5M+LSnGxB6eVrR7O3lYu9WXeI8FzCJp8v9XYTu3OMM0hLyZKtIUAezCltVpeAELZjjrAJLAXsryZbv3W8ARFuBgxgcDo24ISbJxEpiJENGFFg1rx8fqn6FKgsGj0vSOTFb976GxDSgTI9UeHoWhEWLyUagfL7ji4sEhSsDDlQKjCzlKnHDBTWY/1+YD3CzzNCdd2o5OC/1IbS0P8M00wQ1u+TkHtUkvokJvTFE3rwgNrt9mxKl/ZVzlUIMn0OZqrp7+7sojHumMAcVMkCe1+Bc7kTDEHunJdpX45PPhgYDbU0xNcj8p4AZLOiUbf3qhDKHF0thdjZCiX/PB73ZatiUz63VoZWboUrV7+CyByAiOKZzKMtdkB1XUItZYnVaoPG1NvybndewffrXndMsvJ0jig8IhBQoWRsO3Ud56AaHL0cJLhq/GmTs3MGAPl7Bsj4dh/BkHa3kVYxPOMuEo51apjrU071Aeb9dUKFHL1wo0Y6TeV/VWaJ3J8XOE4vciwX8s488PwKOkkECrKMKYggl2+lgmBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199018)(83380400001)(36756003)(478600001)(316002)(38100700002)(6486002)(2616005)(107886003)(6506007)(1076003)(6666004)(6512007)(186003)(26005)(5660300002)(66556008)(66946007)(8676002)(2906002)(41300700001)(66476007)(8936002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9lYjqWdDYOMcl9l639X8V93hNr4VjMl66vFMeIx4bImEFk2ubbjfh6sU50nV?=
 =?us-ascii?Q?kOH8f+yJqyNI4fZN4DbYQ5u9Ly55e/NHOyfIBwlAuLh2wBhRgCVVvLBIrvqJ?=
 =?us-ascii?Q?Rdqzg0l4rzjCQn2+fQuqxOmWgBv4BbIQCp067BkvOJSHaye3YKR8qSwQomZ/?=
 =?us-ascii?Q?bILE/pfCzYHJHh2gKD5n93Mj0H7d52Y2/K4ps4s5gZx7C1K9voTuk2pvg9Ji?=
 =?us-ascii?Q?ieZCY1u+6Cz6oFfgyXCDfLDVrno/bYH0Oq7+X8uUsy1FVKXPnAqwL6yBrU4w?=
 =?us-ascii?Q?soqyPIP2KvWP0dWvVm/lcWvoo52F5BKsn9zZH63YGxZKjMWA71XLGTsXCH8/?=
 =?us-ascii?Q?JiQTqnywPKId+FCdNWtPT8rKoumB35JxfNUnQYIyJVvGENBJnL8VX4/sMsBC?=
 =?us-ascii?Q?IFIfKS+PvSy4x8b5TMPW04CFDd54Of4BVZt3VMADRONErjc6KLVbUf/VOoVb?=
 =?us-ascii?Q?EKfrV9ckt631moijCvvqqZYeM0MTDfhMUzxEsoaYXYJ6oiCtYFrIn+ehZZe8?=
 =?us-ascii?Q?bLlEbeUgvY20Omj8wvPf/RniAJku0saIZUEmBgoBtPYgnAXHFOYF1mAd51MW?=
 =?us-ascii?Q?HJzozxdNBW04XiBewWyCmvWpNP/gksOWMRdTni3u6gCw64OMyfKt6KFyueMF?=
 =?us-ascii?Q?EK0kxK9+4VuDWTLyXBzRkZEvovacUW98GIMw15QnPMT4s2Aul7b+zxqSGUB3?=
 =?us-ascii?Q?siJ8FXEsIQXOjm+cYTgQaVYIh0HLLGtYheY37QNf/rt2xYg5E4rAzTr06bUY?=
 =?us-ascii?Q?hljWmulOb0/J4+lHWecWpGRv4dFJFY2leJ4Z4oA4r1dRHA+L8wTK2+4cw2n+?=
 =?us-ascii?Q?aAV2XNFU1YLbTUx+lm95X1PyvEmZ0cwT1m1/+LV6xhT7Hgy2Ti8ANVP3Urv+?=
 =?us-ascii?Q?BkcKRdbtE5myYo6Ys0ao5PlAVVU5Danxx46rLJnE0fS15E5l40J8WvDYXMXZ?=
 =?us-ascii?Q?D7e0KLFb7CB9ykSSQl+Iyv7jiHB3Soi9UiO+z9QnB8fd4uEeZQrfyJaYPvEw?=
 =?us-ascii?Q?1gULIIMc56Brp7vn+/0fu+lw06SQKlVjuy6oJmeXF9QkaoeWqYUlK1E+1QfT?=
 =?us-ascii?Q?bwLj+8D49bllXT9VGOlMRMveo68XUMg7lNfTto/nX7TIoq6HNhpYNC3KAS1e?=
 =?us-ascii?Q?DZF2Kg+daPILhqTKwXJUyEN0dc4Dtb9BlrUWPRPpHxxNkja/3KDSoN3N1Uck?=
 =?us-ascii?Q?uMoFsNmqZmz8hJjxr9B31ifcYi8UIGsGfafvdbUpp+V4aYlYyWhMGPcovGSY?=
 =?us-ascii?Q?eiawZo6NgJDBfZbVki5e4NXNNLjp0yF8HXKY7CKvEj7J2mcvtRecQpPWK/NZ?=
 =?us-ascii?Q?CV79fG6L4Po9vN5iBkgNsaUxxztmNxEKaedqeHMJFfk+NyERyFz4CzpryJ0I?=
 =?us-ascii?Q?8C7Bstila/i/2T0QEXotKuPlrVwWX0BZD0huiP+x0IAW2MHFxfUa9/OZ2A/G?=
 =?us-ascii?Q?rCP8bAKcSObCN+22dDJF1KSJvUR5um3B7MxB/j3Kg/PQ8XwGf+NC2iK3sziT?=
 =?us-ascii?Q?lGsaOYRVhnSvOZ+o26Dhm9eiXZ3CKOR1wPgPchzC5SI2PrWKfB3vF0GngjcU?=
 =?us-ascii?Q?80VeUz49h0A0aKKQ2wge++BuklaSpWrbzA+bQlu0ONQCStyCSXjg35vg+nyg?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: QxBu/7Pq0+Kt3GJar9Y1wlz5Y3MG5NAKLXvDVksM4iUhtJZN0LyjAzyjIMdg7akYeVaaCDQWEqtzI0gHKhao6U7cWFjoiYMH5OKp6YCBPxaiQgRpVXOsjH6qML+Va2t39UQzZzRklOzrWuClB1RXGbKlV6vBI7jf13BwqnZJmfqA08zdBuGeivy6xjJxb9tWY0cyhzyTE+SeoDOOOS8rW3MKzncyN83IE/TaZDWlatDnWLpfDnzz+KvdOF4lstUYOXRBE7sTJb8aqQGWQQmiTRPLGaTqijly8vsjcjSQXF5pUj8aQbIztn6k4fBEwmUWfjycYGvMIsgDG/2Oni/qfn+VWKsqmlXxHAqXG4qhc21d5jC1uLCDLHsYnhgY18v87CdCE8vyrogFoNMetTGlsXpl2ganMXpZoC8YBNByKff0FMmCm27ubQ14ZEm4kHT+AvPy2qe+WJYeJ3RwgnEtpomTqmxzHIpqY9t8NOBa2kPad3YHjzHmOoEjom1ItQG3pH3OM1pPvvaSlhPzCGjPZadwA2DWUR7s2+Qjdd8dAtc3cjDVkf9xPQEbslKThYJ9PPEKfkjHkw228ihJ6SCukCh1TA9jgz2Ie7S0x72u/wK4Hj6TQyz/Nn4Uve5NgMSaNXwNM1zuR9yI72wdNvrjNQ7cmq99yrmFbCcIIqQM/81eQqdQzQDssxWmumaaPOH8YuUJBI/uGkc+aBPAKSo0xE8m0k6hSyilre6vbYV9URSwyyMq+t06EtdZFrYwZ/UrxaF49vLa9ZQuPKWy3wQn2+G7h0vDpHjffvJgwDFV3vLEkUcusNTZmZzBHmMc2GYPIwXQPL2DlnpaD8n0tWmYECR2WqGluipj6lxWdaX2AzzG2DZGgwFdU4DFs9uptUVn
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5570ba8d-4521-4d84-f94a-08db20ee54bf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:40.0323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPIQsUB0eoZmiLvlohHWyYK2q2DZ/Bc7M7QmVNwN8H8ukqmOPw3c5OYoSsBBjQOcBp9RpSHv2X6Vc1stKMGBdCr7Yf+v/mkbn6bhEAOr0zw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-GUID: b0yH3IS-LLtPkJ3pvd1kS651WN_BxEVy
X-Proofpoint-ORIG-GUID: b0yH3IS-LLtPkJ3pvd1kS651WN_BxEVy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We used to ue the sess_cmd_lock to grab a ref to the se_cmd and add it to
the se_cmd_list if the session was not being stopped. And if the cmd was
being completed while __target_check_io_state was being run then we held
the lock while taking a ref because we were looping over the se_cmd_list
and because we didn't remove the cmd from the list until after the last
ref was released in target_release_cmd_kref.

In:

Commit 6f55b06f9b07 ("scsi: target: Drop sess_cmd_lock from I/O path")

we switched from the sess list and lock use to the per cpu session
cmd_count, so the lock was no longer needed, but it didn't get removed
from __target_check_io_state. This patch removes the last target uses of
sess_cmd_lock.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_tmr.c       | 11 -----------
 drivers/target/target_core_transport.c |  1 -
 include/target/target_core_base.h      |  1 -
 3 files changed, 13 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 88d2a7839876..6fa037ffc119 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -71,10 +71,6 @@ static int target_check_cdb_and_preempt(struct list_head *list,
 static bool __target_check_io_state(struct se_cmd *se_cmd,
 				    struct se_session *tmr_sess, bool tas)
 {
-	struct se_session *sess = se_cmd->se_sess;
-
-	lockdep_assert_held(&sess->sess_cmd_lock);
-
 	/*
 	 * If command already reached CMD_T_COMPLETE state within
 	 * target_complete_cmd() or CMD_T_FABRIC_STOP due to shutdown,
@@ -137,9 +133,7 @@ void core_tmr_abort_task(
 			pr_err("ABORT_TASK: Found referenced %s task_tag: %llu\n",
 			       se_cmd->se_tfo->fabric_name, ref_tag);
 
-			spin_lock(&se_sess->sess_cmd_lock);
 			rc = __target_check_io_state(se_cmd, se_sess, 0);
-			spin_unlock(&se_sess->sess_cmd_lock);
 			if (!rc)
 				continue;
 
@@ -206,10 +200,7 @@ static void core_tmr_drain_tmr_list(
 		if (WARN_ON_ONCE(!sess))
 			continue;
 
-		spin_lock(&sess->sess_cmd_lock);
 		rc = __target_check_io_state(cmd, sess, 0);
-		spin_unlock(&sess->sess_cmd_lock);
-
 		if (!rc) {
 			printk("LUN_RESET TMR: non-zero kref_get_unless_zero\n");
 			continue;
@@ -310,9 +301,7 @@ static void core_tmr_drain_state_list(
 			if (WARN_ON_ONCE(!sess))
 				continue;
 
-			spin_lock(&sess->sess_cmd_lock);
 			rc = __target_check_io_state(cmd, tmr_sess, tas);
-			spin_unlock(&sess->sess_cmd_lock);
 			if (!rc)
 				continue;
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 692104325b38..c260cb60f5cb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -277,7 +277,6 @@ void transport_init_session(struct se_session *se_sess)
 {
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
-	spin_lock_init(&se_sess->sess_cmd_lock);
 }
 EXPORT_SYMBOL(transport_init_session);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 0a5b51f8e5e8..845db96f50dd 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -636,7 +636,6 @@ struct se_session {
 	void			*fabric_sess_ptr;
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
-	spinlock_t		sess_cmd_lock;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
 	struct target_cmd_counter *cmd_cnt;
-- 
2.31.1

