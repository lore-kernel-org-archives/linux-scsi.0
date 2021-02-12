Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83950C43381
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5529164E65
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhBLHck (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:32:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38400 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbhBLHaH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:30:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7QP6W143145;
        Fri, 12 Feb 2021 07:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=mPXo06X4W85AeXegWWjF7yJgVmVCDbvA6sxjbWjsI+M=;
 b=io94zVX2S+zZynf5ItVY4FitEjrxPyAzWAgAKAt7SNnP/qPMj1aU4Q3Pppm5j5jhuq/W
 f8t53ZZ8lntiGKgzR52zYEkqLaRdh3T3aL33I25gAuH6kDreRewNhuT2NM7QnZmy0+vI
 wguC1CjM6ccTH/qBYsA58jrf2a3/RMEpO06STHD6u8u4ManplfWJkyUjVxHqUClgSlWM
 MVRZ1GgOyG+PlgKNWCbsArZy9o9BMMzW22URB65Ea+kxlA/LH1qaifC9uxXKnTcU1Rdl
 w6n35hb6kR6IygAHirWCEaxaZiL9+HsNKkNbjhAtZ9IvbtE6J7Cte3t4dIT94oGjVK15 WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36m4uq0qmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7PZdX022757;
        Fri, 12 Feb 2021 07:27:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3020.oracle.com with ESMTP id 36j5155aeq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0GVI9GMiRSgiqSHsqB5iX4DgAHP9wFcZnyZzLTjopIRjTpuQJd4s6FbvAdtuz5jvLbKo91WBMtyPUE+DFXVDFYzFBjR62eCDb/YxUocMbPzVOD4vgb29pP5qlUUGLEzxmF/qWGAB8N7cDy3tnUXCaIUJxRx3JI8rlgsgb+ThnVpq2Obn5lPOWLrmavSKM0/FmTrO9m364lB5HUEdVoCDnF3RmpR+Qmwh+d2rE2aSNDrkVMq/Pfqh8J32sQIHWb/RjeF6jtYQ8+1+J/J/4i+xGib/jP9DN9J7/2jucvOs15K1mzfbnTzYU3WykZag2TRMH3VICFEPVpUloTjJGHP7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPXo06X4W85AeXegWWjF7yJgVmVCDbvA6sxjbWjsI+M=;
 b=gEyYqMnJ1ZCPVVyiO38+gqDNIYNh52VuL+ED8XUlwgUm/tl18DBIV2kz+fE3kFoFjPZkgQdknvs6lFuphpqymQNnI8nCkQZxFKStdFrRQBgpfoHLKRadeSmVTUzwoJx2KgUNzVfalXDryn3Nxv+Snh8as4exx3T+Wn19LkWyWVbOMiTYkq2cWgy4OTSDhee0qmDvAa0okqehlq0EZ6eqV18gvwJWgBisvKGvzoN8WTe1p4G1dHAsEv8OVF5GONjaxcUJhRHg39CusQMFy6v+5aUgeR8CxSewt6VXT5J1gbMmgDdrl905HmpK0XPPCkLlo7P8NjzhaFjmj+VzhB+1nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPXo06X4W85AeXegWWjF7yJgVmVCDbvA6sxjbWjsI+M=;
 b=bpTD9clxdrGF9HxCQB7bef4UHo0BVYUkGuWBrXiWbogPvX3ZjjXwplkhMYPVaqXEhw36f7FJNNHCxbYibRfXZTXxVhl316eOWTaTnMXylSqpBhxEIvsAUtzEKCu0vOGuNeL6WhT2ubASxfj8b+dLCuCw0tFQnyxxyQe9zBev2gY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN6PR10MB1940.namprd10.prod.outlook.com (2603:10b6:404:ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Fri, 12 Feb
 2021 07:27:18 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:18 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 25/25] target: make completion affinity configurable
Date:   Fri, 12 Feb 2021 01:26:42 -0600
Message-Id: <20210212072642.17520-26-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85defd71-741a-4f23-fab2-08d8cf27a094
X-MS-TrafficTypeDiagnostic: BN6PR10MB1940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR10MB1940ECA1A314312C8D0744FBF18B9@BN6PR10MB1940.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S+kty8AYSwqW5WQw1SsM2BI/kh3H7B2L859A8pksMUuEUzOG3wc4UJ5Su3zwGbZRmRes9HEuiglzsk4IaW+PXj1RCFyozEaY4BBogurmk0rhpf998GdIGCFFa+bkQtO+DFfGCVLS3TMHbAd888EuAUtNsjlIqcL5fl5+6XhFRnVaa1cMXvDQozNoZxhCoCcJWkCdP4odqiKsWceeKSh2qWFVtpLGp74LQ82U2+UcVD+Wu2blK2/q8rFbFCOQh/Dpf6w9GP0cfzwSb9qaC4DSiKQ/yclqJ97dOw3wTO8ROOGXYiyHpkbhpKsZHFAVBU8HmqbiFfnVJ7ECrum65M5N+w3W+A9P9s4GP0rUgRmyFm02o0wsjZLI51wWSR+SZDBRINUNbXJgZxjos38gfB8D7vLQP9cyp+qJ1a7rvxPupBrZkojxvHXsEYTTHRpXKxco7HY9Ni72YtmFKInVAF9NhLH/1YS26vWxW7FkyOrzk2IKnQJc8S9HvUpMXBR9nq0d+MbcJOYKzwk+u2ysXZX4LzUIEwuhhGhGe2+AmcACpg3wV8Rg8jA39LqGve5k4Q1pMeO7m/NR1O25VDKfEL3cqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(66476007)(66556008)(69590400011)(6506007)(4326008)(1076003)(2906002)(5660300002)(86362001)(66946007)(2616005)(26005)(8936002)(6666004)(478600001)(83380400001)(52116002)(186003)(16526019)(36756003)(956004)(6512007)(8676002)(6486002)(316002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?unz0NiM4ff4lB7Efr5Z6c5XNRvxkoGD+3knqWV063kW4tQ8v1iEZEzO1FHLe?=
 =?us-ascii?Q?cuHwISZO77B2+DjQXkfP4N7RFCL143t+yc0kgs8Iu4tY3nIMfZ9YmKTr+vch?=
 =?us-ascii?Q?jBExsdfHcG1Yd9Hs98hRETm62mf5FkYG7dTwgwgkuZOyD4Chpo2YnRdxTvbO?=
 =?us-ascii?Q?kvEljGG6z+cNyDcnoNLaJ73tVV9/14F25WAb1YeXa6FUZLYZWG3mJ0G4Wn6e?=
 =?us-ascii?Q?0CdPV7dquMY4/jGHlVRcpwTZQup9IEEc5nbxTsVx++pGeG1/P9a+pvPMTTWh?=
 =?us-ascii?Q?lX/TTo6zf+ORClDuZgkv73N6dFlnPeyg0pwlpn4WXKTNxI03Qi96hWa/wnmc?=
 =?us-ascii?Q?JJd6E9pAu/V0Qys1/vl5q6g/fpx8SNQYLz2W3ApY3cwb2KKve9qRIPTlK9Lr?=
 =?us-ascii?Q?ARkhh9elubkykpizVW6Dxum5v5z45+2joHcbksXjTc5I1fWvDh2I/C+PqRGZ?=
 =?us-ascii?Q?eyEK1X+vvQaBmdBO3hX8U/B262aeqc2NyrHqUGvN8CKW1BiEAkZ00dqeAC7p?=
 =?us-ascii?Q?emeZxWFtkvuYpA2DlmTPjHDq16ed5fauLsgZvqKezT4mQyX0g59D5BQLzOUP?=
 =?us-ascii?Q?bO3dw1szbnlvRzSHeWkufr4d3ETd3IwYGHfZFy7Qf8fh9mjxp/2kEXMxgQb6?=
 =?us-ascii?Q?yBKEVlwIX1HCpHPxf7Kb8jZ+3VPQN5X1SvifE8VacAeRCwdygyIR5FskB9AO?=
 =?us-ascii?Q?J7exk7mVclJ03qXoQt8kksSiCZAAmKQyEz/XZXtyogU/DbRqXEnGN8lyFuFS?=
 =?us-ascii?Q?o9+7+pTKar7u/0vb6RkDiudTY0Y11HUP+OHP/SNbGM0+qPOBpBmxiP5ZsV3V?=
 =?us-ascii?Q?n7/MfT/jO3qeTyZ6sQd3FRJsvSQOAFlLZ5Da1n97w6B3tkczFhsj4r3GnCM1?=
 =?us-ascii?Q?SbQDheGPGssc0zKHdx23rycGBNyQ9iNDRM2i0IFNpU8wnlNTJSsMdIDiMIkO?=
 =?us-ascii?Q?CpA0rMqJZSd+squJs7S+x2ThyjP6VD7lSu4lKk7auEL0us3EDJwk8e60bhOQ?=
 =?us-ascii?Q?yv9GjD+3/lTb8c7XuKNAZsCPzuxMyNqQnw5TnfPqUmDjzBCwOYXpfYUe4tmp?=
 =?us-ascii?Q?Bj60NrJWRYTU3WEry2Z+nYCycmjcWWK6oatL6hZHeUN547sUYT6EaWprpmoI?=
 =?us-ascii?Q?WuO/LA8Ngfu7OZglOS5fVZ63iqWkqLTBDJrE59obzdKjdHbEJt5w23/jvzWf?=
 =?us-ascii?Q?UbhZP5OeyS5cbIVID6cPqvXWUosCK3SV1L+ovh/Xx3f9R82UUP7fG2Jp3yjp?=
 =?us-ascii?Q?zKFx6cVUiCA/6L5wGGAzY3cAoUiCFx6PeI2SaFz67FGTNlg17kgASmyVyVm0?=
 =?us-ascii?Q?vZTd0+zccrSDwj1X8wsmKt4P?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85defd71-741a-4f23-fab2-08d8cf27a094
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:17.9686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8jyhg9who/lt2xyVgWlqT06gYhygIkhvxm9VTYed4V/J5GmeKQEJPTmra4pV4oPP0BQLkyE/NWgswqUvWC6uwPBbeVMVPqCWGx+SKV1ZNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1940
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
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
---

Note: Christoph, in basically the previous version of this patch
which had vhost-scsi hard coding the behavior you asked if we could
set cmd->cpuid to the WORK UNBOUND value. I could not do this because
code uses the cmd->cpuid to access per cpu structs.


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
index 45bb5253461a..cf3d916dd612 100644
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

