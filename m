Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D59C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 972DE64E42
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhBJE5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:57:30 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55010 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhBJE43 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4sviT034280;
        Wed, 10 Feb 2021 04:55:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=INTlTQgNJXzj1hRdzb0zN24QAK4cf1rfu3xQgu1jKmI=;
 b=pOXhIBE6GHSOJONlLrjiQ7Xuh1KasdHmjesuxFRYLOQikqiKaRK1rjOFc/+php1+eoO8
 cHIhJFDJq39Q+W+hpneS8oMGg0Xb5cn1ftJAP1bU7BZ73ESMordnmYqmlQHkyThyYWEp
 yfZauxf5vk1rKIaPXl5UCyFg44SW4lnzg+JDF6gEJihR77xPV8RUsmICat3d1+mkzV7F
 mGqO5ULOrtHfIQIqLJp+gh+OKR3tXyTKRT0/sXfNWuP7Hitho4pKgMDTQNQ5EN2HAwUj
 DMMiL+IQV5yYeQkEiOmxJKFh780vSaCK0d5EGHfdmUb+4Eqf0v1bxt+dceNfBU6LiWzB Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36hjhqswse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRBD048727;
        Wed, 10 Feb 2021 04:55:42 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1QWbkDWQb6lshYeFZYJH/pF+4cb+s4yxE6PhYA37iusiobW/4Hihip4oYH19fyx3rogfU8LI0MmHilFGlkcGNgJ3uH4esDCfBQsxThKBPJJ72rnZnOdCQHx/Aa+AZBk6bW23KWm2gFWuWxlT7i1eoYBzhud5mBE3Idv2L7h3TnmO7Umpf2VmTurA5HH31JDsT2tnPldr+tU6kTppYA7fHNbQQ+GbrJPtKCotFxXr/QHwXIQsF73ka5JYu8ycq6KPYZtvDDqoFrrLALKOs0DZG0sdMTKstzMw1Dxi0qqRV/369kWwoWrgWSzQzf4a4e8eixWD4lLO81fDtUaNnpZWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INTlTQgNJXzj1hRdzb0zN24QAK4cf1rfu3xQgu1jKmI=;
 b=hd6KCkbWqwTxopSA57dhqzBzauy6CfYXNxeZOwOAcg1WbDO+kj2NGkTkl3Ohya7ss7k25GJphGcBTRLw+FbOPWDXrZX4IKjC6SJNrVbci2ytH3zN2GuLFdRBjYZIIIFPYOIIvEAE/N/XDUOs+Ncp+4gyeuxxQ69hiSjEpdUUmp/qs9wvGS4Dv3j4BJe0q5YuLDRJ6A63wxAtIlHmNwfhiUJTN26HIGqomTh0NrItwEzTOfSAdeX+jArBMwdihHrblgT4MNMIarBlwMXQfKzEUvMyZihBSGgWSl2qRiLo4sdI687fx3xZDP80GOoB2RhAfnTjeaBib8vGVYBXIcUlfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INTlTQgNJXzj1hRdzb0zN24QAK4cf1rfu3xQgu1jKmI=;
 b=nFhxDzfriAdvUIWkItsAGxvXroTxNQDggo0XcPiCAG0uJQm4yMmc89huHc9d2rq/w4kQgKTCSSw606pBux8WyEKuXbhwcSFeZuRI7lQ8jRsM3Si5GLq7fyrBA0rwqljIdXnD8XCprPbi+HUhfO392Kx9qck2O0Q9dfriNSwUhQc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:39 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:39 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/13] target: replace work per cmd in completion path
Date:   Tue,  9 Feb 2021 22:55:14 -0600
Message-Id: <20210210045516.11180-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210045516.11180-1-michael.christie@oracle.com>
References: <20210210045516.11180-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:610:4c::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aae5134f-afe0-42d7-c2d4-08d8cd801c6c
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3366BDD99F032666F7194296F18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bl6AG5HMM8F4iygqo1Ww6ucbEcwwfaG+BV87Qy5DMG9Bf4Iqgpf/OLcHdZrwdnaFnHUW/NYfKsIn0KKPd1dMcW0b5l9zpttTq4SrbRME7jtUPJrMhGVGgMBzuqbcMvxRNzAJ8+upsn8G4idcoNT37LcEVWAF3+LWtz3sSR/o3SU4fymkHhahVMdW1hBAqAIy8gSZL61LL9KlRxyCYHjgKJmhpsmW4UGFL8tIJV8ZO/gbCj1PvIcdaSvloXQJd66RiH3EwSx54ps6qR+xBKoJNeuUN+bAU883ymafGiUhlbXI/mTUrdRGdDh9Mb9g5Qjny7j3oI6vHoNgMZq5SiLCB38tSpKoMV+zSN+OANRBBG76/DRSIEsKBAx9fiKDFoX1PMMR9EpK6sKpAXP8+nu4UAh8WmNDDxIU0D00f1z7NAc6yuawyJJnwebUcgLnco6rZ2T4lQ6O7wXQl+aGXkWtpv/tXK/q7SfJEu24cXXjKtaLzqadhZTg3LWripDYyHx8cEBEFt8lNm+RCqE8UdtzUBG3Fu/G3DSa0t1MFHjzn1CcqjQlzzEmkbFnANQkwa0ilxRHOwyzB0XuSQHNCMnuTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(86362001)(26005)(5660300002)(478600001)(52116002)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(316002)(66946007)(66556008)(66476007)(6506007)(6666004)(4326008)(8676002)(2906002)(107886003)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6tnSTyq1gankUy/r3XS8CzrhqUJzbqpNapKuCg3rEhcBChx0GOipRUeycosa?=
 =?us-ascii?Q?QLzYmvjqjlnr8/rbdzrKDIFUy2+3MACgWv+QfLFjbLJTXF4cT2LN6+NgboAw?=
 =?us-ascii?Q?EHcjDFhW3IkPmrPAPV42y6XtdCeQQ6S7Nla1+leW5wwPpzsnDzqFxei0eytJ?=
 =?us-ascii?Q?ITwmLtHyUqhoNSUSwBonvdDsYCBW+2tz2+/Gwj87zCe1ym0y2c0BNxIN9jgq?=
 =?us-ascii?Q?X+72FLdT1rivmGMMuoR1RJoTrUTXjhV9QfagVmfa5zlqC+hOXaHKd6iQhOys?=
 =?us-ascii?Q?swWvYe2bW+qwWY6o/FRMIMjps5dG8mN+kPHCDQTg6o1Iiv5aeCqUUNGUbv1t?=
 =?us-ascii?Q?cBGQeRXKHvkk3yMvsm+5CzwHSjakBVu+ap/n6RA93+HbVcd5evyDMiqOjN31?=
 =?us-ascii?Q?6LpdqOcQD2NIp3gCAYPK+fLPuLoxIes0TBuuum5RaFvgT5IapxhSvlQfsxpF?=
 =?us-ascii?Q?FrkOkFUbFN8WGLcooZmIKKuxxT2dK9X9Dx6VDWfN4Al1FsQrIqo9lAYL2A8o?=
 =?us-ascii?Q?cq1+1RnYimIxY1YJaThjJDrLZUnlUFsEWfSImDN5FWKRCnSqwhxBuRelx4lJ?=
 =?us-ascii?Q?+Bxo6dxXeIjvfUdi9bWGhtbdBrv1WSSsgmUQhMa1RA1ljE0cz5VbFFQBVVmv?=
 =?us-ascii?Q?rgECmm4gZBxR//bzKmBBcaeGbdnEAPmReKuacnQJvWuFrXuOrRbS9oMvgKti?=
 =?us-ascii?Q?s7JpqsVpqDYgHj6ENd4cIL9Y1dEBqrnOG8zMEokMCNftRmWI8kF0HV9RbXc7?=
 =?us-ascii?Q?hRHnI3R2CF2XwBmDhgw7wSZ/zHYmJkTg8yb5rPNDlg31F3EmzPejd3OjZG0a?=
 =?us-ascii?Q?Qt8LjU7f6Hul+cAPWewq2aaZAXEjCot8ZHLw43sfKFpT6msvOOPdZM9lHRPg?=
 =?us-ascii?Q?uf9/4jQFa4NqvIGNPmxXT9wTAtRTdNa/zzpv5WA9cp/am/TOgWSWG/OItUnw?=
 =?us-ascii?Q?l2xHrGbh8woIwTicz2wH/+Af1AZh5p3IAFG2KaG/NVAHZbiWhvDR5zIWbFbq?=
 =?us-ascii?Q?hdqPoWNSPOuJLJpp3BxnPOGZrpOqVNVBohBHgHAr9klKeKsWwYP0x9n9Efyn?=
 =?us-ascii?Q?n+VzZRBaGdgmW/78gRAn+UVd9PG6Y6efBcrs2F1rUjkJH4e0IKVpnuV/RGiN?=
 =?us-ascii?Q?n+9VenXmgHp+xsY8mtY5NxRkr3A/SlBcbcK9lcZ8GgiGUUQMrQ2ibqq+8GIz?=
 =?us-ascii?Q?inTdHGYUtJRLw8m8BSXFNvkyGMHyf23E1f26kmIWyx5XrMU/x83/xZwiuV7L?=
 =?us-ascii?Q?BMxSI74PPx3VXXrpza3AQZE1BwOuaC3pb1wPfhlW3R4PmBrqv65spQFqpNWE?=
 =?us-ascii?Q?VEZZoWYH/TeaqVwI2ckvHQfR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aae5134f-afe0-42d7-c2d4-08d8cd801c6c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:39.1421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TAxdmQq60TjP+2cha6gypClyTG4uL+xjZhvxpzxb8vXVd9InRNqXpK9M9UTO4vratAoqorpoeR26rVlVHO5dyOs5aloZzpoN6jLLhD2XILo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Doing a work per cmd can lead to lots of threads being created.
This patch just replaces the completion work per cmd with a per cpu
list. Combined with the first patches this allows tcm loop on top of
initiators like iser to go from around 700K IOPs to 1000K and reduces
the number of threads that get created when the system is under heavy
load and hitting the initiator drivers tagging limits.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c    |   3 +
 drivers/target/target_core_internal.h  |   1 +
 drivers/target/target_core_transport.c | 103 ++++++++++++++-----------
 include/target/target_core_base.h      |   1 +
 4 files changed, 65 insertions(+), 43 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 74d3a4896588..eaa2323843c0 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -743,6 +743,9 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 		init_llist_head(&q->sq.cmd_list);
 		INIT_WORK(&q->sq.work, target_queued_submit_work);
+
+		init_llist_head(&q->cq.cmd_list);
+		INIT_WORK(&q->cq.work, target_queued_compl_work);
 	}
 
 	dev->se_hba = hba;
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 56f841fd7f04..e54d05ae8dfd 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -154,6 +154,7 @@ bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
 void	target_queued_submit_work(struct work_struct *work);
+void	target_queued_compl_work(struct work_struct *work);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c4bc012fc215..039016ab7a77 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -55,7 +55,6 @@ static void transport_complete_task_attr(struct se_cmd *cmd);
 static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason);
 static void transport_handle_queue_full(struct se_cmd *cmd,
 		struct se_device *dev, int err, bool write_pending);
-static void target_complete_ok_work(struct work_struct *work);
 
 int init_se_kmem_caches(void)
 {
@@ -732,14 +731,6 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 		percpu_ref_put(&lun->lun_ref);
 }
 
-static void target_complete_failure_work(struct work_struct *work)
-{
-	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
-
-	transport_generic_request_failure(cmd,
-			TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE);
-}
-
 /*
  * Used when asking transport to copy Sense Data from the underlying
  * Linux/SCSI struct scsi_cmnd
@@ -827,11 +818,20 @@ static void target_handle_abort(struct se_cmd *cmd)
 	transport_cmd_check_stop_to_fabric(cmd);
 }
 
-static void target_abort_work(struct work_struct *work)
+static void target_queue_cmd_work(struct se_cmd_queue *q, struct se_cmd *se_cmd,
+				  int cpu, struct workqueue_struct *wq)
 {
-	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
+	llist_add(&se_cmd->se_cmd_list, &q->cmd_list);
+	queue_work_on(cpu, wq, &q->work);
+}
 
-	target_handle_abort(cmd);
+static void target_queue_cmd_compl(struct se_cmd *se_cmd)
+{
+	struct se_device *se_dev = se_cmd->se_dev;
+	int cpu = se_cmd->cpuid;
+
+	target_queue_cmd_work(&se_dev->queues[cpu].cq, se_cmd, cpu,
+			      target_completion_wq);
 }
 
 static bool target_cmd_interrupted(struct se_cmd *cmd)
@@ -841,8 +841,8 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 	if (cmd->transport_state & CMD_T_ABORTED) {
 		if (cmd->transport_complete_callback)
 			cmd->transport_complete_callback(cmd, false, &post_ret);
-		INIT_WORK(&cmd->work, target_abort_work);
-		queue_work(target_completion_wq, &cmd->work);
+
+		target_queue_cmd_compl(cmd);
 		return true;
 	} else if (cmd->transport_state & CMD_T_STOP) {
 		if (cmd->transport_complete_callback)
@@ -857,7 +857,6 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 /* May be called from interrupt context so must not sleep. */
 void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 {
-	int success;
 	unsigned long flags;
 
 	if (target_cmd_interrupted(cmd))
@@ -866,25 +865,11 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	cmd->scsi_status = scsi_status;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	switch (cmd->scsi_status) {
-	case SAM_STAT_CHECK_CONDITION:
-		if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
-			success = 1;
-		else
-			success = 0;
-		break;
-	default:
-		success = 1;
-		break;
-	}
-
 	cmd->t_state = TRANSPORT_COMPLETE;
 	cmd->transport_state |= (CMD_T_COMPLETE | CMD_T_ACTIVE);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
-		  target_complete_failure_work);
-	queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
+	target_queue_cmd_compl(cmd);
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
@@ -1894,13 +1879,6 @@ void target_queued_submit_work(struct work_struct *work)
 		target_unplug_device(se_plug);
 }
 
-static void target_queue_cmd_work(struct se_cmd_queue *q, struct se_cmd *se_cmd,
-				  int cpu)
-{
-	llist_add(&se_cmd->se_cmd_list, &q->cmd_list);
-	queue_work_on(cpu, target_submission_wq, &q->work);
-}
-
 /**
  * target_queue_cmd_submit - queue the cmd to run on the LIO workqueue
  * @se_cmd: command descriptor to submit
@@ -1955,7 +1933,8 @@ target_queue_cmd_submit(struct se_cmd *se_cmd, struct se_session *se_sess,
 
 	cpu = se_cmd->cpuid;
 	se_dev = se_cmd->se_dev;
-	target_queue_cmd_work(&se_dev->queues[cpu].sq, se_cmd, cpu);
+	target_queue_cmd_work(&se_dev->queues[cpu].sq, se_cmd, cpu,
+			      target_submission_wq);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(target_queue_cmd_submit);
@@ -2058,8 +2037,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 		cmd->transport_complete_callback(cmd, false, &post_ret);
 
 	if (cmd->transport_state & CMD_T_ABORTED) {
-		INIT_WORK(&cmd->work, target_abort_work);
-		queue_work(target_completion_wq, &cmd->work);
+		target_queue_cmd_compl(cmd);
 		return;
 	}
 
@@ -2484,10 +2462,32 @@ static bool target_read_prot_action(struct se_cmd *cmd)
 	return false;
 }
 
-static void target_complete_ok_work(struct work_struct *work)
+static void target_complete_cmd_work(struct se_cmd *cmd)
 {
-	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
-	int ret;
+	int ret, success;
+
+	if (cmd->transport_state & CMD_T_ABORTED) {
+		target_handle_abort(cmd);
+		return;
+	}
+
+	switch (cmd->scsi_status) {
+	case SAM_STAT_CHECK_CONDITION:
+		if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
+			success = 1;
+		else
+			success = 0;
+		break;
+	default:
+		success = 1;
+		break;
+	}
+
+	if (!success) {
+		transport_generic_request_failure(cmd,
+				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+		return;
+	}
 
 	/*
 	 * Check if we need to move delayed/dormant tasks from cmds on the
@@ -2629,6 +2629,23 @@ static void target_complete_ok_work(struct work_struct *work)
 	transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 }
 
+void target_queued_compl_work(struct work_struct *work)
+{
+	struct se_cmd_queue *cq = container_of(work, struct se_cmd_queue,
+					       work);
+	struct se_cmd *se_cmd, *next_cmd;
+	struct llist_node *cmd_list;
+
+	cmd_list = llist_del_all(&cq->cmd_list);
+	if (!cmd_list)
+		/* Previous call took what we were queued to submit */
+		return;
+
+	cmd_list = llist_reverse_order(cmd_list);
+	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list)
+		target_complete_cmd_work(se_cmd);
+}
+
 void target_free_sgl(struct scatterlist *sgl, int nents)
 {
 	sgl_free_n_order(sgl, nents, 0);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b8e0a3250bd0..f2ba7de59da7 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -777,6 +777,7 @@ struct se_device_queue {
 	struct list_head	state_list;
 	spinlock_t		lock;
 	struct se_cmd_queue	sq;
+	struct se_cmd_queue	cq;
 };
 
 struct se_device {
-- 
2.25.1

