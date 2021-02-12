Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982D7C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 660E664E65
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhBLHcN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:32:13 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38364 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbhBLHaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:30:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7PcMd142684;
        Fri, 12 Feb 2021 07:27:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=3YwrrI48piCWmPGHNGt2oLCbfb2qcf+tlmtt1i6T680=;
 b=O0inMzozyteLK6fSMMYskxVroY6jxC2FPPww4721v6peBFddLMfX3da+2uaSlxhQ06Qq
 VaxVCD6agm8vDjZhIt3+s6aUg7vMComv3MQ0gA2iKu+dYtSSMwXq2A7Kty7xKaYZiTP8
 zXzIosAtUQdbSguJZ1IHT/97wAu78IPuxmH4AtFur2hHloCup4ojVMosxdGuWOC6wrPp
 AnxFzT9f7cubx6bXi36Xpwr3hP5wphuZRIjcCGWN1lHdcQ+Q+LNGEULKM9ZcZrJhTkxA
 P8g154DXhB4JoEGY4VG9C6S6mdlp52hiEgXra9IO8khmBGN6WuDTChQMAO1WpzGjxaB7 qA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36m4uq0qmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7QA0V090287;
        Fri, 12 Feb 2021 07:27:16 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by aserp3030.oracle.com with ESMTP id 36j4psn5w4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGepODoIjOvRP3w1/O3DjQ6p7LMA2ra3MjzjmPEuIsQO4b6Bq4CDSlBlBKUZ1f6O4gdYNRbPmZV6gJCQwiO05BwuyvRTxp8peNZDuNdP53ZfZrfQSSDJmf92edFnjoa2R3ufHpelTJGDKA95Ha8WSjrQwqNah7qMpMusvNTQK8NVwrDmzU2+ocnOaoNzQ8/PyXJY2HVS8IHMx6f9XebncgOXLK6pCEdUbmGgBxdX92JD6q8WZYCKVh6USGue3WZDPq+TUdd2jKu8xkGIvMsYDIkobgjeESN3c19LADmMpfqJNu8avz6J0if3pkylF8r1nlyYUqXDy+18AVoaP98N+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YwrrI48piCWmPGHNGt2oLCbfb2qcf+tlmtt1i6T680=;
 b=GpSHtt5h41N6ot3Zh1/MOud3d15WWHoWZAOAElmOrutB6k2m0iTBdKg3odIBaXsOkfLubHWc8K8HuSc+BK0AQzstrU3Y0GkjMx+X+tpTODYmRwplBw5hstBxuefYAxdaBTzZ95MAWogm6yovN2Nd91992NsIJw25TYMF5HpKXQuKSi58MDzLVZ3gvYVheGywriKmsb2OBdY0nrDyeSjMh730jzOxZr+rIcYkhUX/iNCh3//kWmgyF2ciETs1+1cSGPs3sGrxflXrzwSRy9ypzVdrh1NrOvnk/TU8e1VFpPdRf+esmd7bxGd0MCXkHyWD4AF6E0S0lqb+9DvuMcFfrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YwrrI48piCWmPGHNGt2oLCbfb2qcf+tlmtt1i6T680=;
 b=dwMw3rv3ge6ct3yQbJOFb8w1SJFDzJNaDJImBsKCX2nhvjY0qj2sL8ddzPd5ABh17J+8G8li7nU+TbYgfnWMjshwMKCE5w7k1Ox/xuMjlEEiO6nqjC/i4DqIA8EPxvvdGIlXJj/tFIzQE8mD0rmAuPkygRingSLczWPsTioq7wQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:14 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 21/25] target: fix backend plugging
Date:   Fri, 12 Feb 2021 01:26:38 -0600
Message-Id: <20210212072642.17520-22-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffd2f892-d1ef-4dea-c9ee-08d8cf279e3f
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB525419A3DB220B1FA2398D88F18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: or9ksZJ6440hp3BruX7ICh2UYH38LQk2UAOnKKWNnRNqvhClyXiqtoC/UbbApPUSDxCzf0qWt/4MYYmbSJmv5kRM3jngVmMyjTIyw/vwupbvT3lLqii5AiwwMRjDtGDkLZG29LzONNZGuyrh+UlWvS1yIm0n38/A94vMxf2obYcEJL9IVsoJhLR8BlF9pl/melgUqi+gjhu78gbVKI1oXrZiYy/BFuP60y5iC5olH7FJDDP0c6sJHsw5kjl6gvrsj9Gp/ubM97QOS8aVE75Qr+qZl2DgzXUtWDhXEOSyk0A5OK39nbsseyP56H/rbuwdlC1qxyiyqbYirFICIsLm7uyZHtpvgpFMI0fn7+eMeCA1+DVHq1qX4q8eW2it+VDrgfWqeEllNVOEOlpOyPnj9+V/ks52nw6hYcbJYzdZSKHB6u/AHLtdi8Tsf1j1bWPGrswHWQ0ACMKyWnzEyKaXcVPvGKIPCFkejALH0HNtapbqJ8mNrZRXwOJgNyn70Mv5m0Hm0Mzjp/cxet8Kle1bbjgnkFYBPteiBi1A2bFZuEM5vB45qQqv+yUWnO1WgIokQdCLx9hVBbhyZxQ4UCA+bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(107886003)(26005)(956004)(6666004)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+jDzY+8ds7f4nWEWKVgtYWZ9fDunJ9Rt2rvjw0cn2tDnK7f6WaNa96Xz4ViE?=
 =?us-ascii?Q?BkUydPXt1N6VRiuKvCHMsXL6LH9y4wwLz6j21xdqIN0Lh5iLkAyyt3ysvFpn?=
 =?us-ascii?Q?HrghDF2N++G7TwNw8J/d2JiIRrNyYux7A7HpjaqdATMG23SNg/OxhvTo/Lvg?=
 =?us-ascii?Q?2wQ/WQcFEJjoJK5LpfWAPQSwRvraNRT4be8FAtFNRN/G4mROgw6AWJO8biej?=
 =?us-ascii?Q?qiMxRarWfpM23ZeDlnivnJGEGYTyPpX71YPzS6HVT3hM5RAoa6hYUWFhk9+C?=
 =?us-ascii?Q?dTkP2oSzuOvDrC46AqcyneFoS/860P/U/hp6rc3gbW7/mvRzdQnYGbRsHL2C?=
 =?us-ascii?Q?AUc28odwPn4fazi2RTPaFNoGsuMZL4mllJHquJghTQ4H5cVvxcGFVB6vMG6+?=
 =?us-ascii?Q?9R3SCqNVSxeqsSJvZlctTTM8/Bfrncd3oidScI7p7hWa//zMhi+H4lCF1vO5?=
 =?us-ascii?Q?sbWFTuN1evtxpt89JZzoflXPgf2ZAAmjZDHArocuRd1a9DzvZOVwZ12quw3f?=
 =?us-ascii?Q?UXZdd0279NQSJMM+6LudABkUpOutNTZtlq8G9XwUrIEyAOEnnH8LHn3eByxp?=
 =?us-ascii?Q?PWW5/fvJGW9VoVk5xB9DaSF22fPUtNlhT9WcaxoR0Bo70Bgu09YxJgS5pihp?=
 =?us-ascii?Q?cMl9Diut22JET3boG6gG+EIG9QAFRZDQatfttvA83XiMX5mRf/GzrQoRWeDA?=
 =?us-ascii?Q?1xyQTodokJns4as5IgGCkNstjq/zd3yGlb2p2PP7v1WQZA2Vc7ZMScP408hP?=
 =?us-ascii?Q?iFqZtivrHGH3CGZagjWKvn4Cp18AylaxyyYBRHptwzncpZrSpbJ0YCM8pEyF?=
 =?us-ascii?Q?S+W3fCe5QVO0tTfByqkokZJzDW+XECGgZ1WRXg/RD6sOoVr+CTOZFy49XKSH?=
 =?us-ascii?Q?bFxga2M2y7/NwIFSH5NNzlPGowXfqMCwA7Ch85aAV21jEm+ABjzNMT7LjzvI?=
 =?us-ascii?Q?CLnTS9BOVMoo4iO8vqiVqn4hdDJaPOvCN/SuZzvVgUvexFwUnKn3SmM5JzGT?=
 =?us-ascii?Q?/iKMPCvY6fU6llNpb+W4ntbMy4w++TXS+PANqHMkNo+Ps71fi4d/dmHkdhqJ?=
 =?us-ascii?Q?lUqLt3dRMdObhXueUYInZYebKmxt805FxliIRB1HnuHCP5H75qqwlyxzMwhm?=
 =?us-ascii?Q?gZEkUHubqQNQf6MNYfz6xkGn6m1rKXoalukxB1WMPQ9CG0Rw/3qcquMpRoqC?=
 =?us-ascii?Q?8kwRvlluA/d0667ugJAU4VGEd0eqI2/w6qy8Dt25XQ5pBBr3FrL/wvcpS4vQ?=
 =?us-ascii?Q?Tu2lGmwVqBjCIs1wmUj3CnQxs6Xce30BSUtDKCBORQ4geSUnONtMfjopi/Lp?=
 =?us-ascii?Q?+AHX7nMZz/5Cryk49FVLf2eJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffd2f892-d1ef-4dea-c9ee-08d8cf279e3f
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:14.0129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mUOeK3ISzpWovoxN4PZ1sQcikhEw5Fxf6NVJQyg+ayCyx9PFA1f1NltjkwcZ/ErO8UhF5g96YBe5ThEnmY1Dv0oMU6fA7aMz75PdfMNEZBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_core_iblock is plugging and unplugging on every command and this
is causing perf issues for drivers that prefer batched cmds. With the
last patches we can now take multiple cmds from a fabric driver queue
and then pass them down the backend drivers in a batch. This patch adds
this support by adding 2 callouts to the backend for plugging and
unplugging the device. The next 2 patches add support for iblock and
tcmu device plugging.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 43 +++++++++++++++++++++++++-
 include/target/target_core_backend.h   |  2 ++
 include/target/target_core_base.h      |  4 +++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d782d3a0f9d5..45bb5253461a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1796,10 +1796,42 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 }
 EXPORT_SYMBOL(target_submit_cmd);
 
+
+static struct se_dev_plug *target_plug_device(struct se_device *se_dev)
+{
+	struct se_dev_plug *se_plug;
+
+	if (!se_dev->transport->plug_device)
+		return NULL;
+
+	se_plug = se_dev->transport->plug_device(se_dev);
+	if (!se_plug)
+		return NULL;
+
+	se_plug->se_dev = se_dev;
+	/*
+	 * We have a ref to the lun at this point, but the cmds could
+	 * complete before we unplug, so grab a ref to the se_device so we
+	 * can call back into the backend.
+	 */
+	config_group_get(&se_dev->dev_group);
+	return se_plug;
+}
+
+static void target_unplug_device(struct se_dev_plug *se_plug)
+{
+	struct se_device *se_dev = se_plug->se_dev;
+
+	se_dev->transport->unplug_device(se_plug);
+	config_group_put(&se_dev->dev_group);
+}
+
 void target_queued_submit_work(struct work_struct *work)
 {
 	struct se_cmd_queue *sq = container_of(work, struct se_cmd_queue, work);
 	struct se_cmd *se_cmd, *next_cmd;
+	struct se_dev_plug *se_plug = NULL;
+	struct se_device *se_dev = NULL;
 	struct llist_node *cmd_list;
 
 	cmd_list = llist_del_all(&sq->cmd_list);
@@ -1808,8 +1840,17 @@ void target_queued_submit_work(struct work_struct *work)
 		return;
 
 	cmd_list = llist_reverse_order(cmd_list);
-	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list)
+	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list) {
+		if (!se_dev) {
+			se_dev = se_cmd->se_dev;
+			se_plug = target_plug_device(se_dev);
+		}
+
 		target_submit(se_cmd);
+	}
+
+	if (se_plug)
+		target_unplug_device(se_plug);
 }
 
 /**
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 6336780d83a7..aa5f83e55501 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -34,6 +34,8 @@ struct target_backend_ops {
 	int (*configure_device)(struct se_device *);
 	void (*destroy_device)(struct se_device *);
 	void (*free_device)(struct se_device *device);
+	struct se_dev_plug *(*plug_device)(struct se_device *se_dev);
+	void (*unplug_device)(struct se_dev_plug *se_plug);
 
 	ssize_t (*set_configfs_dev_params)(struct se_device *,
 					   const char *, ssize_t);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 5e6703ca102d..b8e0a3250bd0 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -769,6 +769,10 @@ struct se_cmd_queue {
 	struct work_struct	work;
 };
 
+struct se_dev_plug {
+	struct se_device	*se_dev;
+};
+
 struct se_device_queue {
 	struct list_head	state_list;
 	spinlock_t		lock;
-- 
2.25.1

