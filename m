Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 508F4C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A61264EB8
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhBIMkQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:40:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42494 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhBIMjz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CZS4I008786;
        Tue, 9 Feb 2021 12:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=cGlYDZEw8p3YrWD264K2nbK0C8Xegrsr3k+uwkZIpcA=;
 b=f+GqMoELucM1ftVYrL1ll4i1cXxS1TKQWxEKDBePCOG0bIckAl+73VvipbIlyq6XM7ba
 0cEuyrG5mTCBNE3PTyx4txmIkvm/lExi+e0kAq4zMMe6kICOiehhe6L7a+XL8tT6kzUf
 Or1xMFQgxO65yAgNngYlek6GliBpxYv26ehV1WhG6eut2FuOLBYYya9ZEdf/T6WaciWA
 7+jWH6fbUzEGQiJna+bd/9TaAfImMaB+uDtI69sbfYVl3ecoshUoI1SwvPsTKhQGGQaA
 LtDxpYmWgf5hm5rhxdvM4jCC/STSar7mxWVLdGmlALnCK7fVHfpTfxDLCjX71V51x5aQ Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36hk2kfajf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CaDIO178533;
        Tue, 9 Feb 2021 12:39:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3030.oracle.com with ESMTP id 36j4pnn0cr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PV7N/ra6vekW8MmtVhvdxUzv/0gqxHhOJBR2G5L++cfJNwPzmFEmbLvINFiKcofv8pi1q7D5RNJz5L7ZekGh3e5uQPESleYqEgqd7+/kKLPMLuWUuBkOjYZxH99AgLPVrx8J0ALdXV05PID7PhZm6SENvTe6Em6P0cD8wuKPkX6p5iptLyF+Pu0sajf1EKYc3RiN9COOpeaMiOfwiJmKZl4VVqXQQZD/1bHIiSRDsA2GIiihDzM2vokgygPEFBeG/ltkha51PFAGUjqH6CXmj7hmVv2XFmpV9dmt0r+dquuPt8tJAJJqxiViuAlmHIz8WvZJ717gTsMOKbDc84LWWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGlYDZEw8p3YrWD264K2nbK0C8Xegrsr3k+uwkZIpcA=;
 b=IflDQc6MHdDYT+ajy5CvceHJL5kDtAig+ijKcoeyIhJvBIm25+r7O7ta9NWnW1stlvjXjGDEDmS5mo/6Qd3DbqabXUx6w0tPvaq9lK0PA3J242hYVa6TAiKP4dPsJCyt5QEjTpLIHzYDhH+3JQkg/7IAZbNCgS0K29h+7d+xK1xiZS+N7/y26DDQmPulPQcL0AA7ghKfFFs2TC0lQuIdNIvF6KvwUtUpgFnw4JN5cEwFK/qILpcYZ1/+W5rOyX4evC+BnjVJu+8F0J34IfpyEuiEYdAOPjvRaPe4gw9X+bd+i65mKsK5ssUwTGRykFrp808Zm6U3O3uOVddWRWDEKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGlYDZEw8p3YrWD264K2nbK0C8Xegrsr3k+uwkZIpcA=;
 b=Ix1eFSZoLrtm+qCJX4g3lhtTInqnKRuS6Pk8hfYZKUGapXti62FfqPgZHZfqwlAjk3Lv3ZiJDaniJbBsorc/wUDbLcaurVjkPQRqDZjxxvvjKaIwzRchx+KU9p+JFycr+quvyy71fyL/QADQ2U2ywPdn/Blrdud9jPOsCjJLqc0=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:39:01 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:39:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/13] tcm loop: use lio wq cmd submission helper
Date:   Tue,  9 Feb 2021 06:38:38 -0600
Message-Id: <20210209123845.4856-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209123845.4856-1-michael.christie@oracle.com>
References: <20210209123845.4856-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:610:59::17) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:39:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8708b622-0164-4ded-b582-08d8ccf7ad8e
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2600C7C823478D62C3F798CCF18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0z2DkV6LxD8K+1ej4hwzOiAiuT1NAAM/6acFv/iKJjhOqtxS05dYHWkPvSau3jvOEC2KrsqpHBgbbe1jDRTdR6UQg9xPSpzqr1lazbECiepRKiMq5bQ1a2sjmPGQyPpUmMBmOQBLemupljX2Us0jmUMI8vcj4S8x46y59N85GL40mDRII9284smKlzxvSAWxwQQalgf65EZQQufymngXxiISw0b/I3lEGptI3xcek2DYkAUIxJMk/17wI3RQPgi2zCe0lU9S+43rWhnqqfPnkB4jGbwAtjgQvoXKAWPiMvaMXsIi457Rt3sS8Q+4dIeeF9j9UE8ZEvvqFGVOzMxmaoGGmbqNVI2mpbBDczcYkSYsEopeWp6QzJlpXAhN9O1+H4VHwIFgqaN64Rp87Qi0qs16eyzJQfTybef1wt8ySP034ZRzr5OVda4NojaaGfCh1o2lImoZiNtZrbPtvXucTkF8Sn8Ln3YFXEJZdrmZ7ltkwhlCjJcEGTo8B0FvBsWpFGp6crbbwr8NnsmOv3a8ge4zVwJS7YxQA7ViZLtxhhDh5wkTC7IcsoKAnioS2Y3LsMvikgM3V47nN0R3K1Z/OA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(4326008)(6666004)(107886003)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?P+FjAD95DCQxxaNTwP8fKGMLR1cj0sQTdsu4lyBu4nY9hJKq6BMUc8DfM1IU?=
 =?us-ascii?Q?p1M4jHDps3XdMH6XMrhatWxpKJBizblRQTcg6IfwI2tX0saQHbR8HQaLsuBi?=
 =?us-ascii?Q?OEOFobTtzBAOyJKMdJoG4sEhEOPN9jGZ+c0qPAcYi+sc5jBd9EVgZglhWilC?=
 =?us-ascii?Q?4RgWpTkB0sy50GxC6OK00dMSVob4nCkm+2g/fzUDNTRr+ES9YXKXYNdtzdMq?=
 =?us-ascii?Q?QQNCngNunVfMhuHhKjEFRKjgEoCF3oqrbGxXe8TNcnrrEpryaGs3qlOQi0XD?=
 =?us-ascii?Q?cyAp7vXHhYOpg6YdWssfRN8iDMur2YVoLsL9jI1f+rYoLzBWHuUxoN7qq4V8?=
 =?us-ascii?Q?5GI3xJKNt0xkhp9leKAkrTy7JNc4qauZKFwi2wt0cFxdkSrHNdMZRxkqTXCw?=
 =?us-ascii?Q?9iE8e40I08DWzSuA932H4CQ2nUjA1abymdOec4wAIIHzZVRL+SS+ZXkqp+s8?=
 =?us-ascii?Q?SfWEtXhtpvp9Xulgf/TBXj1G5hjORD2KhVKAf2Ic4Z1QkLK72EmFsqQ//m5y?=
 =?us-ascii?Q?jRgW2aDts7fCMtdtCVWALDdZ5Thxm53ETRPeBY4y1puzIZkQK/YHrinNRHUG?=
 =?us-ascii?Q?7mzBIeN8izLzYZ0p9tXd2l0KoNYkcgM9eaL6+vxOpB8R/THNQ99WBgyNCtJJ?=
 =?us-ascii?Q?0BbtMM4+4roonpmP7L6bEWvU+pnf5nUywb1gauag2sJWN9ybO3VVrSD6ADmD?=
 =?us-ascii?Q?DXyjd1RTmGBm83v0Zv4suTQMuTY2bCw4na46T2WXb8LMY7ZXPGk0DYRjTQId?=
 =?us-ascii?Q?E2Mxeug5ZkO3TAjfmmT35RSBber165E/bv/H8h5707q/+r17hQ4VcIW5ozng?=
 =?us-ascii?Q?raFSymRhdxBcFQqUgbFLA0CueSaexpYAiuD8Hv1Wv3B2wIqm5h+K41LvKHPd?=
 =?us-ascii?Q?Ac1FLK+e7KhadRKHwGqAflEC1eq4326h0tz9cVsPaFw5ooFqi7gubW2DqsTG?=
 =?us-ascii?Q?GxBimBYuGYVwIepkbvJeJF2E1eOYgqH4qXXbV0u4nin4Rib+rbLyfPwsh4pw?=
 =?us-ascii?Q?uaQc/g8DyGtLmr3kRWUZMDfncMv6z/pxBwx08pZFcxpwY/rtlvKYzUcGz7Cx?=
 =?us-ascii?Q?qy6cy83LOP8i9dO+nagPFcW1glQ73IGCM50VMdBQaD8jzZaPc4DxCIj7J3aI?=
 =?us-ascii?Q?wmo6PB7BUnw0ot8cJ17jfzHxt4lgju5GC8ioaB4asTEKTfoya3ef8VRNTzqc?=
 =?us-ascii?Q?Ww8GWYAwTHMpBxk6Gpmv52DwdJyBUtq5zHiDK9pBbWzqZTNMGk37vIiopfSH?=
 =?us-ascii?Q?bsaF4teGrSHcwTRQ7z6/s/2L7PfZHsWWfP/JuhoblhQJsadUjnTHnC586+T2?=
 =?us-ascii?Q?ITSXq1pe1zFuCCJ8cTHpipr2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8708b622-0164-4ded-b582-08d8ccf7ad8e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:39:01.5393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FGOA7iM4c/rq+oKNfwj0HRD/HZlB71xzlI+VQHGs3+xyeicG3T+/GGJNyavHm7DY+ia3XDqgQyCEb1oDWRYB32BguHaFAvkHsyLnhH3/uS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert loop to use the lio wq cmd submission helper.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/loopback/tcm_loop.c | 34 +++++++++++++++++-------------
 drivers/target/loopback/tcm_loop.h |  1 -
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 274826a2b0bd..3642f381067e 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -39,7 +39,6 @@
 
 #define to_tcm_loop_hba(hba)	container_of(hba, struct tcm_loop_hba, dev)
 
-static struct workqueue_struct *tcm_loop_workqueue;
 static struct kmem_cache *tcm_loop_cmd_cache;
 
 static int tcm_loop_hba_no_cnt;
@@ -106,10 +105,16 @@ static struct device_driver tcm_loop_driverfs = {
  */
 static struct device *tcm_loop_primary;
 
-static void tcm_loop_submission_work(struct work_struct *work)
+static unsigned char *tcm_loop_get_cdb(struct se_cmd *se_cmd)
+{
+	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd, struct tcm_loop_cmd,
+						   tl_se_cmd);
+
+	return tl_cmd->sc->cmnd;
+}
+
+static void tcm_loop_target_queue_cmd(struct tcm_loop_cmd *tl_cmd)
 {
-	struct tcm_loop_cmd *tl_cmd =
-		container_of(work, struct tcm_loop_cmd, work);
 	struct se_cmd *se_cmd = &tl_cmd->tl_se_cmd;
 	struct scsi_cmnd *sc = tl_cmd->sc;
 	struct tcm_loop_nexus *tl_nexus;
@@ -155,7 +160,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	}
 
 	se_cmd->tag = tl_cmd->sc_cmd_tag;
-	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
+	rc = target_queue_cmd_submit(se_cmd, tl_nexus->se_sess,
 			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
 			transfer_length, TCM_SIMPLE_TAG,
 			sc->sc_data_direction, 0,
@@ -179,6 +184,11 @@ static void tcm_loop_submission_work(struct work_struct *work)
 static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 {
 	struct tcm_loop_cmd *tl_cmd = scsi_cmd_priv(sc);
+	struct tcm_loop_hba *tl_hba;
+	struct tcm_loop_tpg *tl_tpg;
+
+	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
+	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
 
 	pr_debug("%s() %d:%d:%d:%llu got CDB: 0x%02x scsi_buf_len: %u\n",
 		 __func__, sc->device->host->host_no, sc->device->id,
@@ -188,8 +198,8 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 	memset(tl_cmd, 0, sizeof(*tl_cmd));
 	tl_cmd->sc = sc;
 	tl_cmd->sc_cmd_tag = sc->request->tag;
-	INIT_WORK(&tl_cmd->work, tcm_loop_submission_work);
-	queue_work(tcm_loop_workqueue, &tl_cmd->work);
+
+	tcm_loop_target_queue_cmd(tl_cmd);
 	return 0;
 }
 
@@ -1146,6 +1156,7 @@ static const struct target_core_fabric_ops loop_ops = {
 	.queue_status			= tcm_loop_queue_status,
 	.queue_tm_rsp			= tcm_loop_queue_tm_rsp,
 	.aborted_task			= tcm_loop_aborted_task,
+	.get_cdb			= tcm_loop_get_cdb,
 	.fabric_make_wwn		= tcm_loop_make_scsi_hba,
 	.fabric_drop_wwn		= tcm_loop_drop_scsi_hba,
 	.fabric_make_tpg		= tcm_loop_make_naa_tpg,
@@ -1161,17 +1172,13 @@ static int __init tcm_loop_fabric_init(void)
 {
 	int ret = -ENOMEM;
 
-	tcm_loop_workqueue = alloc_workqueue("tcm_loop", 0, 0);
-	if (!tcm_loop_workqueue)
-		goto out;
-
 	tcm_loop_cmd_cache = kmem_cache_create("tcm_loop_cmd_cache",
 				sizeof(struct tcm_loop_cmd),
 				__alignof__(struct tcm_loop_cmd),
 				0, NULL);
 	if (!tcm_loop_cmd_cache) {
 		pr_debug("kmem_cache_create() for tcm_loop_cmd_cache failed\n");
-		goto out_destroy_workqueue;
+		goto out;
 	}
 
 	ret = tcm_loop_alloc_core_bus();
@@ -1188,8 +1195,6 @@ static int __init tcm_loop_fabric_init(void)
 	tcm_loop_release_core_bus();
 out_destroy_cache:
 	kmem_cache_destroy(tcm_loop_cmd_cache);
-out_destroy_workqueue:
-	destroy_workqueue(tcm_loop_workqueue);
 out:
 	return ret;
 }
@@ -1199,7 +1204,6 @@ static void __exit tcm_loop_fabric_exit(void)
 	target_unregister_template(&loop_ops);
 	tcm_loop_release_core_bus();
 	kmem_cache_destroy(tcm_loop_cmd_cache);
-	destroy_workqueue(tcm_loop_workqueue);
 }
 
 MODULE_DESCRIPTION("TCM loopback virtual Linux/SCSI fabric module");
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index d3110909a213..437663b3905c 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -16,7 +16,6 @@ struct tcm_loop_cmd {
 	struct scsi_cmnd *sc;
 	/* The TCM I/O descriptor that is accessed via container_of() */
 	struct se_cmd tl_se_cmd;
-	struct work_struct work;
 	struct completion tmr_done;
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char tl_sense_buf[TRANSPORT_SENSE_BUFFER];
-- 
2.25.1

