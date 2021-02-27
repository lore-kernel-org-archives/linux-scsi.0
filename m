Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94AEFC43381
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66A8564E85
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhB0RMh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:12:37 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49182 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhB0REn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:04:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGwfQe165588;
        Sat, 27 Feb 2021 17:00:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=AJ9anJ63iBUbfHdEZbe2MC73uDIAPJ7AAhB48FyX79w=;
 b=NEYFHO/itVqSImiAuONJZrUP7tDBfQnJeEC7uRz8T95gQCDIuwtE2aw8QWOZLBNYs3s6
 V0FL35ShwVqhh/5FiKWq2mMM8Ufx91kNrK9cTfyHy/fF7tjY1zvmEy45GPNFr0AQn+rL
 s7hCrtqM1uFlj3CAFJVZ5YPibnFn3v9jskdbASKp26SGdpGiToOg3cGz+8CvivZlBN/U
 zKoU4hVOI3MzogGb51LP8ExkGkq+9uSgaxPOB2sXXGwqoOR+DYOR2JKY6TTfEg1EWbRf
 t+stxzjhLpd/8AUgXuUXN1BY5Eqtt9osJdvZJeUAOCh2F+HxHmb0cBN+34HFCcfS/eyw mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36yeqmrptg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0Mbn173209;
        Sat, 27 Feb 2021 17:00:40 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 36yddhy8te-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAGkRN2yYdqPye5qm2zD49shHnpWtPKy3h4xCoyTa+A6hrp0JW2BZQ93t/siMeMz7mKli2DVDZNe/PAQCWBaUbPyyQ4AlJy93Khkafmtrj+IHFCu8jMmDVihvaNu/61O+DyY7iJJz23FG4zODh4J5LSuSjABLuuViEIox7VAC85+wZhq7HgJFKX3DySlpwUTFM4e1FMURGAV8CNHmZQWY1jDO5O5mJW17y0iZ70dVxKn8cF0DYn8bTtpSqhH6paJiddHlTyjAbE0FZOfidGjJvpZFgznZZYYLLH9eVcKvzKnz7GUz/61XMhatCzZGzMqOPXnUkvqdKWEDfkgXI8I/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJ9anJ63iBUbfHdEZbe2MC73uDIAPJ7AAhB48FyX79w=;
 b=Wux9Lqt9CNSuV8jfglaDBb0cUIZGSwLw0Ww3ZNPVMZr1yVqr8HUEsdBvvZwDfALmY40jsSf2epcHv4YTm3CQtcFeL/a4mElIVS8tplf8u5s1oblaXwKXZzedBH8I2gSwU0tDsamCvA/SLUbQ9H6Zuq4AvSHxkczqNtrXh2UVNogN0BEY8ToCAI/c1yH2h3/n5wI7NzRSJyneAumSUdIih+i9CNRmJ/kjEOC177yBZRD/McJRylQaqg5UKEa8huYHv4IaiSNrdEsC/ZrP48Ze1q2PMCrLd0VvlvxPCv8xx68YaZx4T4Os3q+IDWIMb7MUVQ6kykmjbqVvzvzNZO6G6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJ9anJ63iBUbfHdEZbe2MC73uDIAPJ7AAhB48FyX79w=;
 b=wgNRd0cUFLxgecaqNnXUKNSMCff/3tlYE5FUGeOWFx7RQ5oMxLTv9AyDyqYCcol6lnVlNEPSA7x8lclzNVaoKxoHeTMuadiy+nZErdwK/QNvK4htBk6vUkCxM/mJiCJ/tUB3nRtt5hvhn+F5eoYp5o/YkXHmX2hD1BPLGMpmGHE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB2538.namprd10.prod.outlook.com (2603:10b6:5:b3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 17:00:37 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 25/25] target: make completion affinity configurable
Date:   Sat, 27 Feb 2021 11:00:06 -0600
Message-Id: <20210227170006.5077-26-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bb033a9-2a4e-40ba-1e7b-08d8db41348c
X-MS-TrafficTypeDiagnostic: DM6PR10MB2538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB2538D600C421427BF0BC5028F19C9@DM6PR10MB2538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hybCNWJjxVbj/i81L4h/q8wSaOwmMaC5LKLPA/8PzQlsZK3J6IZMzgIbvJt/PpPF8XSmxJS8Bh3+rj3VXDIZi+ms9TC5fie/RJUOp8R5RmfSQoeQ+/KRZ+woqT1orgUp1nSLoUiI1uBoyTHBljX1uGL4I3vCCply9W62Mwh/83bTvxI/NVVOpom/w1rBd17gwmC7cOPNxh8hgtVea82Jn7acqRkiF/kElvG1P7xHtSRG92baNova7zarwmgqT0iw8IBC0wtXRnMRMbpHS4L3f95LWeDoCk7i/VVWHhGZUmExz5fUMtjF9fd03YMH9+DwmMfKx9KiXVq5m8rb2tk35Lv/s8epMMuk3x1Iyf/hP17uGQElFO5OSq+b/joRLztfiPd2gAtB4FHh5a9CZkpgPjODXiHcOOpUmJi7uEwnByf3TvGSyjaHtR7WBTdMBVKqzckGff9WkJYuEvVdzPXNnGKhE+5uLDT1Nkru2L7sFvXRtOkOQxDrfQkq++x/RJvCeV6ym1R5VIT1+ptXwdf0O0TSBr4SWfaoNmGHVf/clnOPAaSYvBw/mUuDsW5ut9WAYCbVAYlR3kNfDZ2qXcJYLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(39860400002)(136003)(69590400012)(478600001)(36756003)(6506007)(5660300002)(54906003)(4326008)(107886003)(83380400001)(316002)(52116002)(6486002)(956004)(2906002)(2616005)(66946007)(6512007)(8676002)(66556008)(66476007)(6666004)(8936002)(16526019)(186003)(86362001)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Jk3dlGfvoFmif+gDx52/7i8x1UC2K2WqJ9hyY7cRvxPRJSO51B/+V15r/yjj?=
 =?us-ascii?Q?s+g8lTLmab9Ol6lktJLbCOxTN4Ewcxml7cKZmc5j2XORiZfx5AJ2oy0bDu4S?=
 =?us-ascii?Q?XBCTNH+zS+s1XHRFHnDC6Db1nj5C+1pP1O5rMKk4Q3BnjDYToKGE+LZF9w25?=
 =?us-ascii?Q?Lq0MAsh0XH6CQDWyb+6jXoOV1NH4KGiPK4Zxw6C1pAfMvRiFNyol5t5mhuax?=
 =?us-ascii?Q?ber4YFwMSx5JTlVXB6u9z8QJC85fmG2zqz80nO9hKKzH2CJmqPRNhVwDtzkj?=
 =?us-ascii?Q?hR8rfmNjqCqKkHixBj50EsCJu8DRl1AN8BwnaEgzMS2IWrRJ9WTzlaKmw9QA?=
 =?us-ascii?Q?xO/bJI0olg24Dyqvi+A5rmvrwLuJZzivgvBUn8sw+8O+yOJmOvsNg5l0yqMP?=
 =?us-ascii?Q?2q/+Tm59Q41opwEAX4n3/Z0QrB2AooezCOjW/wJEqxj2Nv7lsw++U+cUNxHd?=
 =?us-ascii?Q?y2PS/4EpHzgLb3JOtqXcGZHpLoxLLxYDCxZKecBmg3cYb4bVBoBq7JOGsDsD?=
 =?us-ascii?Q?i/mORn6Ee46ub3UVVqrIS9VBiPmjNLRBpcJnRF3JV+02f7uETJjJdrXe8B/y?=
 =?us-ascii?Q?0UiedsFa3Vfh0ALcLLcvMfzn+l4dM44nTswltP+3ufa36OJbjYbVFHnAYgGs?=
 =?us-ascii?Q?eHKqQevDV5lGRMw+wDIK0cjaiZeovxRRuPPJUCFi0wXW2M7L1xtJLIb9JTF3?=
 =?us-ascii?Q?xg0jTu9sbPdV+SKxOwW0gKFf2yS6siQssezqGi32/tME5We6w1myZD9Jw453?=
 =?us-ascii?Q?eRfjCG/9mBha9jiLmKhxd5W513QGrTzvz1l8fKGwAJLLmjrXW2R+5MOu3ofP?=
 =?us-ascii?Q?MHLpQnjDRaISDwxQsHENAqZzgRqIfTUO2etXoRzT4W7ng5FKuSgAqUSwiNuV?=
 =?us-ascii?Q?WPUXM8EBIcthfb0KjQQHQibH1TSghc3ugrhoz+yeIENEo9hymlLJkaf/upAI?=
 =?us-ascii?Q?47wW096vzo6Fs/9OxoXCJZzfznvEmOg1sQwmE6K+qpvH74MX9cm/ZsRHlMNW?=
 =?us-ascii?Q?uLOOVvGc1JMRccQccDXAaKqm4oS0d532gdoyEE6XwzJkRo38194m8ArfK1gI?=
 =?us-ascii?Q?El+72jX7bCsZ1IlaohWbk0tA+ONOsYoH2U34+PSfd1VDNYdWB1E0SaqBv/Bj?=
 =?us-ascii?Q?8++k3qyKrv8wwTMrl0ZYXQkUZjDEHJ/1GST1oAFQEGjdSVT4//rQVhr4MmuJ?=
 =?us-ascii?Q?TU4O8vpW4wB4oWsm6AMlNZgv35uNP0R+RB+iRIw05mk6BC9qLuEYdEd/Riog?=
 =?us-ascii?Q?VX1yP0zdFkLcyruiBEylPAJYfWoPKc4fyI7fyZiOnSDFoCEWfxzeQ96hJ9py?=
 =?us-ascii?Q?h89rGwWuF7KQjFH081QgJLWE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb033a9-2a4e-40ba-1e7b-08d8db41348c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:37.5489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D5GzWGBMd8+BxnkXtckFdr8OpuxlQLVjqlvwzZMLeRBDykOTLRPTXi0lxWcec2VEa67x1qvqk5FxvTJVikw4qLfanWJ38UAnexQg7dcHe7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2538
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It may not always be best to complete the IO on same CPU as it was
submitted on. This allows userspace to config it.

This has been useful for vhost-scsi where we have a single thread for
submissions and completions. If we force the completion on the
submission cpu we may be adding conflicts with what the user has setup
in the lower levels with settings like the block layer rq_affinity or
the driver's irq or softirq (the network's rps_cpus value) settings.

We may also want to set it up where the vhost thread runs on CPU N
and does it's submissions/completions there, and then have LIO do
it's completion booking on CPU M, but can't config the lower levels
due to issues like using dm-multipath with lots of paths (the path
selector can throw commands all over the system because it's only
aking into account latency/throughput at its level).

The new setting is in
/sys/kernel/config/target/$fabric/$target/param/cmd_completion_affinity

Writing:
-1  -> gives the current default behavior of completing on the submission
CPU.
-2  -> completes the cmd on the CPU the lower layers sent it to us from.
0 > -> complete on the CPU userspace has specified.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/target/target_core_fabric_configfs.c | 58 ++++++++++++++++++++
 drivers/target/target_core_internal.h        |  1 +
 drivers/target/target_core_transport.c       | 11 +++-
 include/target/target_core_base.h            |  9 +++
 4 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index ee85602213f7..fc7edc04ee09 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -892,6 +892,7 @@ static void target_fabric_release_wwn(struct config_item *item)
 	struct target_fabric_configfs *tf = wwn->wwn_tf;
 
 	configfs_remove_default_groups(&wwn->fabric_stat_group);
+	configfs_remove_default_groups(&wwn->param_group);
 	tf->tf_ops->fabric_drop_wwn(wwn);
 }
 
@@ -918,6 +919,57 @@ TF_CIT_SETUP(wwn_fabric_stats, NULL, NULL, NULL);
 
 /* End of tfc_wwn_fabric_stats_cit */
 
+static ssize_t
+target_fabric_wwn_cmd_completion_affinity_show(struct config_item *item,
+					       char *page)
+{
+	struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
+					  param_group);
+	return sprintf(page, "%d\n",
+		       wwn->cmd_compl_affinity == WORK_CPU_UNBOUND ?
+		       SE_COMPL_AFFINITY_CURR_CPU : wwn->cmd_compl_affinity);
+}
+
+static ssize_t
+target_fabric_wwn_cmd_completion_affinity_store(struct config_item *item,
+						const char *page, size_t count)
+{
+	struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
+					  param_group);
+	int compl_val;
+
+	if (kstrtoint(page, 0, &compl_val))
+		return -EINVAL;
+
+	switch (compl_val) {
+	case SE_COMPL_AFFINITY_CPUID:
+		wwn->cmd_compl_affinity = compl_val;
+		break;
+	case SE_COMPL_AFFINITY_CURR_CPU:
+		wwn->cmd_compl_affinity = WORK_CPU_UNBOUND;
+		break;
+	default:
+		if (compl_val < 0 || compl_val >= nr_cpu_ids ||
+		    !cpu_online(compl_val)) {
+			pr_err("Command completion value must be between %d and %d or an online CPU.\n",
+			       SE_COMPL_AFFINITY_CPUID,
+			       SE_COMPL_AFFINITY_CURR_CPU);
+			return -EINVAL;
+		}
+		wwn->cmd_compl_affinity = compl_val;
+	}
+
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
@@ -937,6 +989,7 @@ static struct config_group *target_fabric_make_wwn(
 	if (!wwn || IS_ERR(wwn))
 		return ERR_PTR(-EINVAL);
 
+	wwn->cmd_compl_affinity = SE_COMPL_AFFINITY_CPUID;
 	wwn->wwn_tf = tf;
 
 	config_group_init_type_name(&wwn->wwn_group, name, &tf->tf_tpg_cit);
@@ -945,6 +998,10 @@ static struct config_group *target_fabric_make_wwn(
 			&tf->tf_wwn_fabric_stats_cit);
 	configfs_add_default_group(&wwn->fabric_stat_group, &wwn->wwn_group);
 
+	config_group_init_type_name(&wwn->param_group, "param",
+			&tf->tf_wwn_param_cit);
+	configfs_add_default_group(&wwn->param_group, &wwn->wwn_group);
+
 	if (tf->tf_ops->add_wwn_groups)
 		tf->tf_ops->add_wwn_groups(wwn);
 	return &wwn->wwn_group;
@@ -974,6 +1031,7 @@ int target_fabric_setup_cits(struct target_fabric_configfs *tf)
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
index 18cb00a1ee2f..6b8ccc4bbf2b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -857,7 +857,8 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 /* May be called from interrupt context so must not sleep. */
 void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 {
-	int success;
+	struct se_wwn *wwn = cmd->se_sess->se_tpg->se_tpg_wwn;
+	int success, cpu;
 	unsigned long flags;
 
 	if (target_cmd_interrupted(cmd))
@@ -884,7 +885,13 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 
 	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
 		  target_complete_failure_work);
-	queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
+
+	if (wwn->cmd_compl_affinity == SE_COMPL_AFFINITY_CPUID)
+		cpu = cmd->cpuid;
+	else
+		cpu = wwn->cmd_compl_affinity;
+
+	queue_work_on(cpu, target_completion_wq, &cmd->work);
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b8e0a3250bd0..2a73b6209a15 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -943,11 +943,20 @@ static inline struct se_portal_group *param_to_tpg(struct config_item *item)
 			tpg_param_group);
 }
 
+enum {
+	/* Use se_cmd's cpuid for completion */
+	SE_COMPL_AFFINITY_CPUID		= -1,
+	/* Complete on current CPU */
+	SE_COMPL_AFFINITY_CURR_CPU	= -2,
+};
+
 struct se_wwn {
 	struct target_fabric_configfs *wwn_tf;
 	void			*priv;
 	struct config_group	wwn_group;
 	struct config_group	fabric_stat_group;
+	struct config_group	param_group;
+	int			cmd_compl_affinity;
 };
 
 static inline void atomic_inc_mb(atomic_t *v)
-- 
2.25.1

