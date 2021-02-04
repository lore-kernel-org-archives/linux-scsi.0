Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27108C433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC4D964F7C
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbhBDLhj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:37:39 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54354 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbhBDLgT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 06:36:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BXcLu123054;
        Thu, 4 Feb 2021 11:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ffy4bpgrlTcrpZiC6UPE4q+MkX+KHRubtnCayUI06Ns=;
 b=KCxupqKRtB2frU+dp5EJtyQZvh53WrlyRjAjLX1AzlMng1XasDsPdY5MHGuVI6TqeMkh
 LyOGKpAEERWgwzXw65KczJpfTJz52QJHVGD6EoyvgIngyJrlnbknjyznD8qa3kYzhH/G
 rbJ83DPrgB2dkWW0B5YYON0ti7aoEkQ3SM2zR6NW/xBNLR7ep97WggYrCWyJI4RIXz/s
 awcLqndxyRUFEnO5FdOpi1QsJVes+lZjWrvnZe6YHYMCKZknzl96PB4kV/Qdn1DOKH7x
 oIxXT0Wodd5PkMCsmosX27gid3Ktt2Vom56W9jibJWJoUnYwlXzNb+TFYt0dIBkEksij cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36cvyb4xrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BZ5jk187745;
        Thu, 4 Feb 2021 11:35:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3020.oracle.com with ESMTP id 36dhc2jep9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSC5aTcuQ3NH4s3MHmKqubWs25HvaC2wtbv/M0yGbHshBAGnihDfyiG646SZUJh71JEXkrrt6OpHIxZD016DnEWQXH8MPbXg2F/DYWU9LcMzOBJ8Xessr044Va+TkWB+EDND/PuvyTs1319X6PoFULDL0RH2HtIFg8BsmaqKlZGBuA6reyfwV1DkvFp2qNA3KTh5QijS7ucQw/h6eJIWM32t+B1AIXvHcfzY/iiOhPT8G1hKIq0FFBfKVSDBGIIJlHtO9IWL0Up4NzhEplrHybr9gI1igHk0CBeZM+kU5Fvg/9+cWlbILN8auoCiff/GsrfH7gmdkR3r/ZlhoG7jWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffy4bpgrlTcrpZiC6UPE4q+MkX+KHRubtnCayUI06Ns=;
 b=ZJ0FBvUS//5Hvt+DU/oJLu0Ets/urc8irAeYGUtwcKI+gwq3iYZl/jpycVXNsT8dLC3Swoa0zQClI71EvgKeJJ+asLzoK4+qR/UNXefFRoPhDXGM0j8GvV9Ij0Q4LRE//Qh81b5cB5OzMPNpDV7U40WCeDwpGBolaahTt1KC0i0h0rF1/kSL7ZhAeURtz/kBzEw8ceqlToLv/2kbaCo9j5O+TDmEzkZQ9p9TXCjHzMqFrnOBRpHzsktWlGLPDt4jXcKvq0PswdULH/O5McORWT3JCrYX0KVhO3qzPOPfUWvvXNFDqPu7gcaL31kTzO6sTKhgfki5SldMjpvbUw2FZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffy4bpgrlTcrpZiC6UPE4q+MkX+KHRubtnCayUI06Ns=;
 b=VD6rNMBNJVsVGl1dv0Pb+sD8n5US+q83mgg0JbutMgRH6SVny/ZHybzNI26dA4crFzcgT5wFPm06hPQQ+pxWbTgOgDDM7wW1bRszSVwOs4YYsxk2bXNB0Uau5LVnc5z8uFU+GYrMqI46wO9+fw28C43LstwoucfuiSLe6L5uny4=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 11:35:28 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 11:35:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/11] tcm loop: use lio wq cmd submission helper
Date:   Thu,  4 Feb 2021 05:35:06 -0600
Message-Id: <20210204113513.93204-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204113513.93204-1-michael.christie@oracle.com>
References: <20210204113513.93204-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:610:cc::29) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 11:35:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58a7e1e9-869c-46a3-a695-08d8c900f88e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44807B409D10BAA1BB2E2ABDF1B39@SJ0PR10MB4480.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uQXgiW+ObgknjzFrJOare6an7rwwJCix1vk1NVbuY3rMSQuC+eigFgEiU4v3mcC1G5PQZsLLPfQ9E1OaqovnVUsCPkeTp4i7mftU22iKPDkRkt/tFLrWFbsUqtQDOPVo3P+eLdqtONSIPSZ1pMRVR5W4a/EqaJC0eMDrlNk/OQYuvX4sO5F0gaTlaKkzKW6rhzSHhbSANF5HELgBjddtxMe3YTPdxTHt7RFmdh04GdNBA7AxIWnfcRy85fEulBGe9P34hjPKB4JdxQNitWjDmO+05ZnqnXQ+4VRPfOS1V+ff8Zv5QgXWRXHPYULyfHt8gdnBEMqBK7DI2j5F00f9qyAGy9t/IeMxRN3RZlLsQXXibkIFmhKQUo+If5zoRgx30WeVCK6U0EEUDU120kAATRiQIU2YQjoGkFMYhrr4R2bOA7HFp6y4ouInzdg9qM2dhqEZJGY5JASsG80UzoqB9QCnNR2VjQlSS/vpn6YGMbp73AHoT/u9/iX79Bpy9fcngx3yibhPf1bwW04EKU778Rg+mXp2tR9TQ9rOY+ph8nhSq5FRIRlCGI+NUSNv66KEplT4VOtQQZBexQiJyZ2AHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(52116002)(66946007)(66476007)(66556008)(26005)(6512007)(478600001)(16526019)(6486002)(8676002)(107886003)(8936002)(4326008)(186003)(2906002)(6506007)(5660300002)(6666004)(2616005)(1076003)(956004)(316002)(36756003)(86362001)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Gp4s5c7+X8LT6Uzf/0zn5kfxNGgeJjEs8fhMLrd3FvOU3vorxP+HQ9ZtKzxX?=
 =?us-ascii?Q?ZjqyFXH0NCnp18gjJ7RcohgD8/cWXcNnJ1qt/2QCOuIrZdjFKitlVdsEK7aH?=
 =?us-ascii?Q?TEjI3SbOCIPh+8MXGwBqWXeJEqeF74J7MIxG9CO2fh1K6bvGXyybb5fRD+J2?=
 =?us-ascii?Q?DTLvxbntRGWMff7tzy0MHJpYbZrtYTipwZ7wkB13yz6YEEW/QA45fVMwXG5I?=
 =?us-ascii?Q?zjYjGjYJBAtsebcb4DfLX4l0exYWkFYcQaGxMoWTXkLYAclextG64d2mFDTi?=
 =?us-ascii?Q?6BuBg9an0FkLW0mL0TJa6AVr6NxlorJAr3L4aDomCtliubMt9LiN4TP4Sphf?=
 =?us-ascii?Q?jKFeLy3beqqtf4X9izd+upZvlp6auCkHma358WLw5QbZpF0hQz07bjCnp90k?=
 =?us-ascii?Q?DXj5+dZlGBmH4A+sXcVXBqAsjKeHoXUwyud5H46ILBYiKMjuxH5h3VpA208t?=
 =?us-ascii?Q?H8zUTxn8I2uUqwfpOyB4IorhZ8Xaa/+g4C18+5nUnTvR/Y80yBgdfxg6TOUL?=
 =?us-ascii?Q?FKvFDeUz5R9M7jl5C6EZS8eCN24NkofM5MNC5QvvoN+ZLIyKg5TckjHkboCU?=
 =?us-ascii?Q?QLrdxlDp4heq9S8SzZN83BwGv3GrFfsUJLvQXyorGZI2nVVA53dHE6Qjf96k?=
 =?us-ascii?Q?NuibvrbGiKIsNy+I8kr3CF94WQhrxqhJ65g4OvClkgs7rPMarickzdxroZOT?=
 =?us-ascii?Q?UuZ0pK69ahsJrrfkRTqrUBA4o2EPU5q5ZeAGDxoP9dHrBebvvouvPZFMHCYU?=
 =?us-ascii?Q?q+dV0lexOe10YCiGdmgRyjJxvir+rUze3G/SE8s4D4HnnF0BHzLb7P/Gxn4K?=
 =?us-ascii?Q?mLd9T/nEwBF3EAF+QyKXEssUc3NXKbX8Qh1Msstd1bBvW4JhkfJcQnKtVe3K?=
 =?us-ascii?Q?83Rz65Zu+XZywOQnJooAr2QVQLqZKZWCaE6ruOYHKUR4gnuwN9K1iQCIZz0Y?=
 =?us-ascii?Q?0CwOywPh3KXnBIVysF+wtYRZD/7/LRYUBBjewqTR3Z2yOfXxaCFvbWExDErk?=
 =?us-ascii?Q?3B/quSs7AvtwzApbF3VsJG4+TRiqDuaI+Gm3TEj4HQ87IKLsu8GPRtuH7uls?=
 =?us-ascii?Q?us+w28UMM43bxqvxveFyruXNALTSTzQoWk7l/y12bN2b0EBAmDscE23Ye/X6?=
 =?us-ascii?Q?+hWf/jsYMi4q8v2wTH4E9zISWqCgqSNrguq6K1Ag+f1dYy1VYIASBY7ylh0H?=
 =?us-ascii?Q?TiQUA8kd06jET3arnG9NpRkAej/xUpx1cqqvCweGa0L2CnfjpHnn6snTjcZV?=
 =?us-ascii?Q?tl7VAXZ2RawVPvle+saBSDRumK1huXU+BTVQ49+SLVmCjpMmYWNyr5wUw2ei?=
 =?us-ascii?Q?NobEdd0MDkdWOmiAosFpwyjK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58a7e1e9-869c-46a3-a695-08d8c900f88e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:35:28.1695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yzQNtnswciFxKqx1ra7nHxn29Xxoqvk4AmGl7gqDL1CdpLXFdmqqPTiU6It0ethJ3/aIpV8+nb77J0anOV9rzl0pg9X5Vi1mbXLKbXIuWNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040073
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert loop to use the lio wq cmd submission helper.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/loopback/tcm_loop.c | 25 +++++++++++--------------
 drivers/target/loopback/tcm_loop.h |  1 -
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 274826a2b0bd..8dc45165d33b 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -39,7 +39,6 @@
 
 #define to_tcm_loop_hba(hba)	container_of(hba, struct tcm_loop_hba, dev)
 
-static struct workqueue_struct *tcm_loop_workqueue;
 static struct kmem_cache *tcm_loop_cmd_cache;
 
 static int tcm_loop_hba_no_cnt;
@@ -106,11 +105,10 @@ static struct device_driver tcm_loop_driverfs = {
  */
 static struct device *tcm_loop_primary;
 
-static void tcm_loop_submission_work(struct work_struct *work)
+static void tcm_loop_submit_queued_cmd(struct se_cmd *se_cmd)
 {
 	struct tcm_loop_cmd *tl_cmd =
-		container_of(work, struct tcm_loop_cmd, work);
-	struct se_cmd *se_cmd = &tl_cmd->tl_se_cmd;
+		container_of(se_cmd, struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
 	struct tcm_loop_nexus *tl_nexus;
 	struct tcm_loop_hba *tl_hba;
@@ -179,6 +177,11 @@ static void tcm_loop_submission_work(struct work_struct *work)
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
@@ -188,8 +191,8 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 	memset(tl_cmd, 0, sizeof(*tl_cmd));
 	tl_cmd->sc = sc;
 	tl_cmd->sc_cmd_tag = sc->request->tag;
-	INIT_WORK(&tl_cmd->work, tcm_loop_submission_work);
-	queue_work(tcm_loop_workqueue, &tl_cmd->work);
+
+	target_queue_cmd_submit(tl_tpg->tl_nexus->se_sess, &tl_cmd->tl_se_cmd);
 	return 0;
 }
 
@@ -1146,6 +1149,7 @@ static const struct target_core_fabric_ops loop_ops = {
 	.queue_status			= tcm_loop_queue_status,
 	.queue_tm_rsp			= tcm_loop_queue_tm_rsp,
 	.aborted_task			= tcm_loop_aborted_task,
+	.submit_queued_cmd		= tcm_loop_submit_queued_cmd,
 	.fabric_make_wwn		= tcm_loop_make_scsi_hba,
 	.fabric_drop_wwn		= tcm_loop_drop_scsi_hba,
 	.fabric_make_tpg		= tcm_loop_make_naa_tpg,
@@ -1161,17 +1165,13 @@ static int __init tcm_loop_fabric_init(void)
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
@@ -1188,8 +1188,6 @@ static int __init tcm_loop_fabric_init(void)
 	tcm_loop_release_core_bus();
 out_destroy_cache:
 	kmem_cache_destroy(tcm_loop_cmd_cache);
-out_destroy_workqueue:
-	destroy_workqueue(tcm_loop_workqueue);
 out:
 	return ret;
 }
@@ -1199,7 +1197,6 @@ static void __exit tcm_loop_fabric_exit(void)
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

