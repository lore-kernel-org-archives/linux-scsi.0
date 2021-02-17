Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66787C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3809D64E42
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhBQUff (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:35:35 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54322 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbhBQUb7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKOLnd017508;
        Wed, 17 Feb 2021 20:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=k0100Ow5cTQn4ff5qY3Xp95n20Gv8m4lPJsH8o+ExZ8=;
 b=NKUruawp9wX9LZnBwbG5LNu8XwesZu1FYu4DAGGLCTJFvgyKCF+fnnRi1S7NpQBJBnxS
 kTNmqmapYxv7X0YUW62rLQ4K8un7nieDS7SDpEtpsPf2RsTWt0xPO4ovzTu0TQctlBZO
 ljhgXCybk5jDRV/Ckdi1J+RRlNFNTB/AokHnu0fZCWtYA+H8NNZvIsceMH7gCNRbr/cu
 PeHUL5/dMZ9P156oFfhEL6aYd1met55tWwXPumSq87iDXtkCbPlWKt03qs58fuT8WaBF
 W7sIb7SA0lKN2kcGueaubBFLk24f5R71YMG5gZnb9rSK9wP66/FWV3a5cGlGxWHIxSll Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36p49bbwyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:29:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQO7b004171;
        Wed, 17 Feb 2021 20:29:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3030.oracle.com with ESMTP id 36prbpwx9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:29:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKt9sTl3yKoKwBZe/j4S+AhZAiuih0Htupvm1+d3BUq8O3sYEiOi6veJ7SRGWNNw74gPQVbCdymF1qVl7vazl3qnVmts771izZaYJ4c483hfC8wDssauHlu8sOj33lj2GzfVWfSrP4AX4ZJHHumXZmvCUsH3ZfEpvkCf5uD3LTVErVfzOC4kivNBu1uuTrom2pKhHF45iaJrj3E9hsgrGtwkBMlcI4G5h2w/ZcHCBOzlZxViYxbRpKO8ntlz2pwGAR1Z5S+wY8loSxbTLjbqG0oH2TUm//vOauc6770vHNPmUR7YdzM2HySpAnbIFDnO2dHehxDQQwEj90NUeuWBxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0100Ow5cTQn4ff5qY3Xp95n20Gv8m4lPJsH8o+ExZ8=;
 b=jcmjboy4oRw7Ns2Z1AZyOdCZBi9GkGT+YjCERu5Dmk34EUBD5FKEJse037HYM0FuhJugSRl9IxbKxk1y+8Kdf0xRziDQbY9R3I38XSqx6kvtimLPxPX3Eq5RdHqAJ88bExWjxCo7kOEUPLsla8LRjy0Jp4y7ostwvpbID2qw/wuFDCT17ypp9EPuVRyRuZscZKzo0qCCuqgUIhTNvpk649TJDEdltM1+h5fMwmISUYJfYHDVunv1QA98oSQ91rZQ5eSaPPRw21X1RcTHbOiYNQEuWgulDLnVocbKxsU6/ltTfeXRUcNCxy4RLZp20X4eNsz3HcfCBXcTYCgdNR8HhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0100Ow5cTQn4ff5qY3Xp95n20Gv8m4lPJsH8o+ExZ8=;
 b=EqjTFaVVq7bU6ALUuItA/f/ARgXiWGs5ELINQqyNpHJdTOmpd61R2YI35nf9E0Rbu12rUUqlWzWcrPG3afzBqqfSRQj/He9vHsLhVmQU/sf6+zjr5oXpct+JCFAKMTn/2Muo3EclpYXj4tTA0ngm2o7a5S7pFc+SYyhQLMab8rc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3940.namprd10.prod.outlook.com (2603:10b6:a03:1f6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 20:29:07 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:29:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 25/25] target: make completion affinity configurable
Date:   Wed, 17 Feb 2021 14:28:11 -0600
Message-Id: <20210217202811.5575-26-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217202811.5575-1-michael.christie@oracle.com>
References: <20210217202811.5575-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:29:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ed24043-6a33-4bfa-f020-08d8d382acaf
X-MS-TrafficTypeDiagnostic: BY5PR10MB3940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3940B8DBA1AAA9BA7559A681F1869@BY5PR10MB3940.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KtHBLDHzLxjTt422mcjtaXmdL8ps6aOLgzGOad3AU41Rfc+2lj8afeVoLjIJnhQv/BRUuBK/D661jAm9xsYKRsqKlRWXyQ2BX4Bx2zSxN5COojFOZYtOT1FKQ12MOOPojyDOAMk3fsZG9wT9gresxtwLmAlaHUwkCFJd7syVy1m+7LaDo5WA9LZtUC0+7E800igy3RhaQOd/4hMPGeuxE/7luanQsAESY9wc8wRwJ/5LCzmphB28YHvwRv84BSweR4xQEHghINe7GFo6UZU9PJgFSn25c9Pu1blf3i58WEUVrzIBEEV4cr9hsxJJBTDogfSookTf5LrJmH49X1xTAMXv8Gt62autUO8wMTHE3E5Oin7dMw6Qat0igSNlXbKxydSWGXPgTpsGtAJbUDqkj0IgadsnB8rLlLcOHj6bW29uWWwI5xv6T3wO8eXQlrIFqpzzVlKDti7C1gkpUwjlsLQhyscyio7a8cnU8Eh7luPQMTriaRUcP+I1reF5bta3iQeD4yGrLKwEu9i9nntVGHIo8+JpW0v3SiBzftSEFtagPu6Y3ctRi8tGRkqBtTJElYuMHEpz2voVlyIhJyA0RQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(2906002)(6486002)(956004)(86362001)(478600001)(1076003)(54906003)(69590400012)(52116002)(316002)(6512007)(4326008)(8676002)(83380400001)(66476007)(6666004)(6506007)(8936002)(66946007)(66556008)(2616005)(36756003)(5660300002)(26005)(186003)(16526019)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0s7GnYAsDXHtbHE/KSKQjQrx/OKjCEvX1NloieFZegWV7ZP39KnF+Wk1PGMx?=
 =?us-ascii?Q?736x0cC1W4n9XwpWx7GJtQ9RxazekiUoiACt/bYiQJkSIZEIUrdoAatbM6ew?=
 =?us-ascii?Q?50yRNN8fL1J+URz1dsjnaLg3Sa+7qObESMRx6mFuSoEr7/vB4FZ8lbKVhKq7?=
 =?us-ascii?Q?sChbMASqk2o+M7c71Rk76OwnAlzGJLyBnHrEh35C6IqpMBVPpB8IYkq4a/XO?=
 =?us-ascii?Q?tGXs5abBjP+yFPV98JLoHp6eQtNOBSs36YXvhzoWxBGVugivA6NS6UzkMRM5?=
 =?us-ascii?Q?avE6MQQ6KTzcfj4yb3PY0BKv7V4wJGCe9kgm19y/+5fOhL4rzvXfHvJLNXp8?=
 =?us-ascii?Q?sOeJef2S3OIhkOBq6P9kWJLcOPY4IVNKVIXPqZmOAUYLzwiX2S2y3srnlO5M?=
 =?us-ascii?Q?eAPaI4aU9E946BNykTnsPUntEGNqtZV+Pq0sgkscMI8Tv6K/m8rz4STZ2kOI?=
 =?us-ascii?Q?ifXvfM4LB5H2wo+sZ8SoMjv/JYx6oJ0w8OqcMZkwgyAGcdSQ6XjN6/BINF9G?=
 =?us-ascii?Q?Q3UHrCE44IicuLYBQOBg6pztySfaPvJnMVoG2V3cTougWvLPOVoxrkd7rf/3?=
 =?us-ascii?Q?k3XPXdo0BDhicIDpqMqyuNo996uxprNw8++D1MaOUcASV8YRilxxTGik/b4a?=
 =?us-ascii?Q?cZO0xOE0inoD9GPUVxhESV6L6FPFDO0HomNTMPMvS+kmjrLLEVbza19v1JhJ?=
 =?us-ascii?Q?8hYyErHX9irUSyV+2YgePaLwjLhHVDHVU8Le3shcB+qAwVYkEPE/W6zyRxM3?=
 =?us-ascii?Q?9TfgIFzJr0R/dIy0GztfoiDpRUEFzDGRPj2ulOx4Fb8VoWfxnM02G6+H/n3c?=
 =?us-ascii?Q?xTd7mw+2m+luTukIJ/Uk5QrA6YnUiaRSMRU/JA0RGAK7jrQknmJDN5OBt62j?=
 =?us-ascii?Q?ATZM9vtCXpw9oSMu3V5GRXbbxDTBAZHf382cOXqd6zfChL4pcmdYvZwDyw11?=
 =?us-ascii?Q?DxA3XBp8eDyM6HInTWVbMHW+lWtsQp5JO89KJ/Iy+Y+QoeGhhG49+ZCIfheb?=
 =?us-ascii?Q?cPnU6cedcbF9dH6RKZeXWPfTL/P3ZKFCYsKfBXOo+fWv3P5HJI46Vm9gNDVY?=
 =?us-ascii?Q?ReGA68scNfN+I9CbmM8SYiRvdw2cAppt0irJM15xlu+HeGbeyetJgluiF2NW?=
 =?us-ascii?Q?YWYvws00xstCkiJz3yPo2ad3beK3sCKFyteVP3NTj+zIhaHOtmMcrQGfK+1h?=
 =?us-ascii?Q?nV2YrugTKFROclC1Wz1TWgA1hLzR1tvv8tGUTjWnLoY29H46PLRcLoxs/axU?=
 =?us-ascii?Q?QNIzJ1Nc6WHrdAnAkBPbhQVPXQRQRwKTdSrrRSIBk30NDaGjeg8TwhDmRczE?=
 =?us-ascii?Q?TmeQi08rX/VCIslZ95aUwOYV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed24043-6a33-4bfa-f020-08d8d382acaf
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:29:07.1794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I+KHnP/dJpms2UJDVJaodxHXy3P8DAvfCGf1Qjcs1e6AogrZY6ZC2RNcz8FWAxO2dS9MWdmQFlc6i/BlSM260BHmf/JgUG4C31anfEg62Ks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3940
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It may not always be best to complete the IO on same CPU as it was
submitted on. This allows userspace to config it.

It's useful for vhost-scsi which has the single thread for submissions
and completions. Forcing the completion on the submission cpu is not
always the best thing to do since the thread could be running
on a different CPU now, and it conflicts with what the user has setup
in the lower levels with settings like the block layer rq_affinity
or for network block devices what the user has setup on their nic.

The new setting is in
/sys/kernel/config/target/$fabric/$target/param/cmd_completion_affinity

Writing 0 gives the current default behavior of completing on
the submission CPU. 1 completes the cmd on the CPU the lower layers
sent it to us from.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/target/target_core_fabric_configfs.c | 49 ++++++++++++++++++++
 drivers/target/target_core_internal.h        |  1 +
 drivers/target/target_core_transport.c       |  9 +++-
 include/target/target_core_base.h            |  7 +++
 4 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index ee85602213f7..7ab27580758a 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -892,6 +892,7 @@ static void target_fabric_release_wwn(struct config_item *item)
 	struct target_fabric_configfs *tf = wwn->wwn_tf;
 
 	configfs_remove_default_groups(&wwn->fabric_stat_group);
+	configfs_remove_default_groups(&wwn->param_group);
 	tf->tf_ops->fabric_drop_wwn(wwn);
 }
 
@@ -918,6 +919,49 @@ TF_CIT_SETUP(wwn_fabric_stats, NULL, NULL, NULL);
 
 /* End of tfc_wwn_fabric_stats_cit */
 
+static ssize_t
+target_fabric_wwn_cmd_completion_affinity_show(struct config_item *item,
+					       char *page)
+{
+	struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
+					  param_group);
+	return sprintf(page, "%u\n", wwn->cmd_compl_affinity);
+}
+
+static ssize_t
+target_fabric_wwn_cmd_completion_affinity_store(struct config_item *item,
+						const char *page, size_t count)
+{
+	struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
+					  param_group);
+	u8 compl_val;
+
+	if (kstrtou8(page, 0, &compl_val))
+		return -EINVAL;
+
+	switch (compl_val) {
+	case SE_COMPL_AFFINITY_CPUID:
+	case SE_COMPL_AFFINITY_CURR_CPU:
+		wwn->cmd_compl_affinity = compl_val;
+		break;
+	default:
+		pr_err("Command completion value must be between %d and %d\n",
+		       SE_COMPL_AFFINITY_CPUID, SE_COMPL_AFFINITY_CURR_CPU);
+		return -EINVAL;
+	}
+
+	wwn->cmd_compl_affinity = compl_val;
+	return count;
+}
+CONFIGFS_ATTR(target_fabric_wwn_, cmd_completion_affinity);
+
+static struct configfs_attribute *target_fabric_wwn_param_attrs[] = {
+	&target_fabric_wwn_attr_cmd_completion_affinity,
+	NULL,
+};
+
+TF_CIT_SETUP(wwn_param, NULL, NULL, target_fabric_wwn_param_attrs);
+
 /* Start of tfc_wwn_cit */
 
 static struct config_group *target_fabric_make_wwn(
@@ -945,6 +989,10 @@ static struct config_group *target_fabric_make_wwn(
 			&tf->tf_wwn_fabric_stats_cit);
 	configfs_add_default_group(&wwn->fabric_stat_group, &wwn->wwn_group);
 
+	config_group_init_type_name(&wwn->param_group, "param",
+			&tf->tf_wwn_param_cit);
+	configfs_add_default_group(&wwn->param_group, &wwn->wwn_group);
+
 	if (tf->tf_ops->add_wwn_groups)
 		tf->tf_ops->add_wwn_groups(wwn);
 	return &wwn->wwn_group;
@@ -974,6 +1022,7 @@ int target_fabric_setup_cits(struct target_fabric_configfs *tf)
 	target_fabric_setup_discovery_cit(tf);
 	target_fabric_setup_wwn_cit(tf);
 	target_fabric_setup_wwn_fabric_stats_cit(tf);
+	target_fabric_setup_wwn_param_cit(tf);
 	target_fabric_setup_tpg_cit(tf);
 	target_fabric_setup_tpg_base_cit(tf);
 	target_fabric_setup_tpg_port_cit(tf);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 56f841fd7f04..a343bcfa2180 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -34,6 +34,7 @@ struct target_fabric_configfs {
 	struct config_item_type tf_discovery_cit;
 	struct config_item_type	tf_wwn_cit;
 	struct config_item_type tf_wwn_fabric_stats_cit;
+	struct config_item_type tf_wwn_param_cit;
 	struct config_item_type tf_tpg_cit;
 	struct config_item_type tf_tpg_base_cit;
 	struct config_item_type tf_tpg_lun_cit;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 18cb00a1ee2f..16d1fce86d7f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -857,7 +857,8 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 /* May be called from interrupt context so must not sleep. */
 void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 {
-	int success;
+	struct se_wwn *wwn = cmd->se_sess->se_tpg->se_tpg_wwn;
+	int success, cpu = WORK_CPU_UNBOUND;
 	unsigned long flags;
 
 	if (target_cmd_interrupted(cmd))
@@ -884,7 +885,11 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 
 	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
 		  target_complete_failure_work);
-	queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
+
+	if (wwn->cmd_compl_affinity == SE_COMPL_AFFINITY_CPUID)
+		cpu = cmd->cpuid;
+
+	queue_work_on(cpu, target_completion_wq, &cmd->work);
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b8e0a3250bd0..4ed385537301 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -943,11 +943,18 @@ static inline struct se_portal_group *param_to_tpg(struct config_item *item)
 			tpg_param_group);
 }
 
+enum {
+	SE_COMPL_AFFINITY_CPUID,	/* Use se_cmd's cpuid for completion */
+	SE_COMPL_AFFINITY_CURR_CPU,	/* Complete on current CPU */
+};
+
 struct se_wwn {
 	struct target_fabric_configfs *wwn_tf;
 	void			*priv;
 	struct config_group	wwn_group;
 	struct config_group	fabric_stat_group;
+	struct config_group	param_group;
+	u8			cmd_compl_affinity;
 };
 
 static inline void atomic_inc_mb(atomic_t *v)
-- 
2.25.1

