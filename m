Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9000C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B750D64E45
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhBJE4y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:56:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39126 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhBJE4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4rirU025870;
        Wed, 10 Feb 2021 04:55:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=AgZj8k0aWTTZX1bk7z8LxElakEjStW0VF4gymLtLLEE=;
 b=lcWl8uPXHCeYpNzg2LfzDYPDHu/yoCQCP8FbtKSmOXn78IydWhX49NFBy4uyUmGXvxeO
 JsFgsr7uAtNVVMGQagV+U09dSZMOtgpU3qYzjknwfoCWSRVAF9drRGL9fQOKk1w5LxvC
 rorq638fGOj0W6GDkftTPybOvN/4h4TejcM6VnKQAhejDJ7omuVSsxoktjG2lLw8LJuh
 kepIoP4aP4jrny0Hw8EqmsFJeNiBJ+EFHYNlUX2FzNz0KcbKmwMZ0/AM/vuLerZldjoc
 StElzd+z8fu9m1M/dvuBZX/NVyDPmEYmXyM9/Q1nutKBd/wzmemeXcFbs1v7G3DCjK8R DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36hkrn1uag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRB5048727;
        Wed, 10 Feb 2021 04:55:33 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3KyU5tDlstpvlwvPT6bd3k4LzA/vKAfAXc4CPGafcIR7Y1fHiwhwHduJRrZl6ApdwXmrYBPOp8y38eMnP2b2Y/+9Px58ZcAZlSPk29oNE/OXdtoePd3erO9cP+c41SzSW2CMrFXPSyx65wXJJv/YL4UAKGfrbyznJBSe3e9lJ1clJekml/Jfqg4w7Y+hwm+SYpiCf2gu7KxDQ1V1hvMmdpkEhVi+UBqR5G1B8WwouZhqc07dzS3DY2djI8sivSozFhJ/QeIM75ss3t2jW6/rpT2i77NM4Q/rMHKtlGk4aOXtp2w+Q1HHDBvMDkHkT6pHLT98diJsLfpSqrE+29zTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgZj8k0aWTTZX1bk7z8LxElakEjStW0VF4gymLtLLEE=;
 b=MBkeW98w8SMUn53n9Hv7IYKIdArQBfh82YjujQabZ1PB4A2/WFlm+6mBYknnfgL6/Fl7DhR8pWn6swxGqHeHmV4Iedfo6s7tbsq8BWtTRPqNFjHT+hORpZ0vyLnFlNCene7uYeuH21UIZfS2dbgAAncqS89OXj+nwSDVMnuerQox+elgCZkUxvA1HdkMHcvlfQ3DwZeaMlQt5BQWx6C7DPpX0A0WM7SNQqgrUbdTqR0GOT/4RHV45hOhepUPRjXpIJTlxaQrdf4AL7AUfdI6BQnOcAHPbT0sTtu98KMmhd4x+5MIFyCkJBqwb8OPrzFpKd24cHSB63k7ql0YGs4l9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgZj8k0aWTTZX1bk7z8LxElakEjStW0VF4gymLtLLEE=;
 b=s0DE1xYlOXEK83OiOUZ3e0fMXhRjY8fWzUc6vl5cFlVTDWq4a2I2NGoId05ZhPt3pE5sudeKuBshzOcUK0zifjnzJr0G32NAfA7w/1RWEX0m3O2HVopgV9K2JAazrfx3hIIIsrmBuLDnSjei3FoXC4cQQqGp+LZipzEXWM0L5tA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:29 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/13] target: add workqueue based cmd submission
Date:   Tue,  9 Feb 2021 22:55:06 -0600
Message-Id: <20210210045516.11180-4-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02500bef-84ae-433c-5128-08d8cd80167c
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33662E06960971AB37FB3DC0F18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hQhbphxf8V+wGEGSfanD/slFAEGMu0z1xrpkFoEyKJ3TeayzDgLyWWJpTE1CIPeaLcqvu4mN9KaL/iPdGpCNOmlacn+7d2kYuh69GaZ6lQAeLs8puFpfebjkrEJgEbbZ55HNXmM5uaQAVRoRiWl5GkbiHik44pRYXNvG7D/+LhNiOKA1Qx/wA5KOwk+mNPiSFv6TMulrNZQosGe7J+MllTD7medxgikJEjVDhnjD5pTy72wRlArGXtNNGM9ePgZ6UzS1XtZXMT+yLPVRn4hz2cq4OdnFPN8aGHYUG9ORxT/d03DKEsULlq80f1v2bo2Ye2M6RzV/SfX0DYuIXajsT2I0QZWgJT9HnH8pJthcdeIoJF6p+hDHtWcNeWhsJMct3X6Ksak+zHMAbO2E8IduEgONiLGX+s/rllUemXeitQMy1X9tGMC2RUWabbCCkL6jpGuLnKHHkgTkZwwQGhdp0WFd0vLxdRVOUEya8AjLeXnpiEo8lJmhs4xpmepUUa6rArWi971EjHZW79KbblmRa5+YSGrFVd6D7VD2rFCylICp4Q1FlVkAUZpXXoBzmnTbkGbzPIzUpsEeDCCmy81EUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(86362001)(26005)(5660300002)(478600001)(52116002)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(316002)(66946007)(66556008)(66476007)(6506007)(6666004)(4326008)(8676002)(2906002)(107886003)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?r+qtuWsAGKXopZ2WYxfvShVmfaaBop7TSYG8Uk1SNZ+ajEF3ISTG61BoN6xh?=
 =?us-ascii?Q?fImDupi96JQS/C7FuYDHIo+4/us1XkT7nuHoFml/BI2mvSrgiHOjVtAterxZ?=
 =?us-ascii?Q?ers+KZv+eEfw4hSu3JHg3jnMrRNYJj8q0QmL4Beq5Pk7niMRiDdC7jRyKYR6?=
 =?us-ascii?Q?a3kj5frmOP6/7xIavFVo5iUn9UVPRKzi168bynEjSsbv+IPjNcxCeebOj2D/?=
 =?us-ascii?Q?R1Iezpe84drIMJsD5SFnspFKcBi+jX9purkte9YTti+QenWzfbOJ+6s4SGJd?=
 =?us-ascii?Q?NqCVZD4YGm+io5ed4GTUTZeiAcl0Co31sZ3MC+DvJRtr4pXImSLmDyZ375hk?=
 =?us-ascii?Q?zILLeiycrY8rkq+VVETXLIZ3m9nIL3UrdipWrc64F2QSW0SVIU3q7NAkPfEQ?=
 =?us-ascii?Q?JOPBaUN6vGyRnZzTF7pNJu1j+lcPqLA4/BWnexYxrJP2NCjwBYL1muIp4+KP?=
 =?us-ascii?Q?xXSHxerjVg1d5YOxEYnSqIqcudqUdxr7IrgMHVxyGfvoYguGOC6GoomKQNWe?=
 =?us-ascii?Q?PXDdwDkLxJi96ks3RJp5uBGfWYqmKxhDyShjmn7krQw03GIX+ES7CKCbv8bA?=
 =?us-ascii?Q?MEdrqEKaaw4a4jCNDDDY7uoH0RpL2lGJr+5+l+PRDaxFY2N/tkdYjldMOeQg?=
 =?us-ascii?Q?/k6nl+E+bmjpnEx7WAfRTKVtFb6csg7XCageHw3zy/hEMNaaec86Rjsm5fwB?=
 =?us-ascii?Q?a6UiahvhE43vFOB/wr3+zIyetJNBSTvKYu7kpkn7qPj/6eefxnZGNg80WU8F?=
 =?us-ascii?Q?gTy1WG+WG/ltpP4uERERHx1h61WzaHhz2tkITqLBqk9RmHzZMYse7P1zRxwI?=
 =?us-ascii?Q?dXX1u8TVlgo/GI9JJLeuzoXebeF9ed+507lGA81XcXF5k8jSa68OCbTihPcj?=
 =?us-ascii?Q?+rb8ACH+7NUvwpTr2AZYV0maSl3/uqABmOKQYGp3FRO5WWcO8qX3ftkkBq64?=
 =?us-ascii?Q?NEdt2aCruf5i6m+C96F/EIi43SOm3Lhot1AVxcD/3iBqZ3PPtjw8NsLIUYSu?=
 =?us-ascii?Q?vwolhlluZtnBwTwFxdIFWEyU7k7FcHygGeuCRqyijFbtg7fFj48eUjXQYPSK?=
 =?us-ascii?Q?HC9/AUO5ESMUdGZP/eUTtQmKY9nYmA0ZHOkKFh2omxq78i0A5AvzPqxVMTk1?=
 =?us-ascii?Q?Wa2x184cOb+Pa6zXSQ9l0LLsiIeDbhHX0ddTPimbmYnDfRdYhJCalrlKYViy?=
 =?us-ascii?Q?WwQ9Gt6hgvdgJVDwoIEmvJwkPyOHOvVexTPA5nIBsaRqOM4Wcj4WwWGEnw3B?=
 =?us-ascii?Q?ctZFpcbCHI+rU/fc3c6m1kumL1UD0qdUVTWAsoOGgZvO36jUY+lILYLdVLrO?=
 =?us-ascii?Q?r3nzVjQyXBiGJjUMiRypwwE8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02500bef-84ae-433c-5128-08d8cd80167c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:29.2387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pn6Qkad61USh/HhiFjp3XmwfCpw1VHSElBDXimE1esB/W3avcr5+OaNSCXuDalaJFHbGbXEEWWrzYrk/fdPscOFHVvUtCnYVXhBExDxXmR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

loop and vhost-scsi do their target cmd submission from driver
workqueues. This allows them to avoid an issue where the backend may
block waiting for resources like tags/requests, mem/locks, etc
and that ends up blocking their entire submission path and for the
case of vhost-scsi both the submission and completion path.

This patch adds a helper drivers can use to submit from a lio
workqueue. This code will then be extended in the next patches to
fix the plugging of backend devices.

Note: I'm only converting vhost/loop initially, but the workqueue
based submission will work for other drivers and have similar
benefits where the main target loops will not end up blocking one
some backend resource. I'll port others when I have more time to
test as I think we might want to make it configurable for some
drivers.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c    | 10 ++-
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c | 95 +++++++++++++++++++++++++-
 include/target/target_core_base.h      |  8 ++-
 include/target/target_core_fabric.h    |  7 ++
 5 files changed, 117 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7787c527aad3..74d3a4896588 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -735,8 +735,14 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	dev->queue_cnt = nr_cpu_ids;
 	for (i = 0; i < dev->queue_cnt; i++) {
-		INIT_LIST_HEAD(&dev->queues[i].state_list);
-		spin_lock_init(&dev->queues[i].lock);
+		struct se_device_queue *q;
+
+		q = &dev->queues[i];
+		INIT_LIST_HEAD(&q->state_list);
+		spin_lock_init(&q->lock);
+
+		init_llist_head(&q->sq.cmd_list);
+		INIT_WORK(&q->sq.work, target_queued_submit_work);
 	}
 
 	dev->se_hba = hba;
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index e7b3c6e5d574..56f841fd7f04 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -153,6 +153,7 @@ void	target_qf_do_work(struct work_struct *work);
 bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
+void	target_queued_submit_work(struct work_struct *work);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f19b4b81e3b9..5f33730e3d27 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -41,6 +41,7 @@
 #include <trace/events/target.h>
 
 static struct workqueue_struct *target_completion_wq;
+static struct workqueue_struct *target_submission_wq;
 static struct kmem_cache *se_sess_cache;
 struct kmem_cache *se_ua_cache;
 struct kmem_cache *t10_pr_reg_cache;
@@ -129,8 +130,15 @@ int init_se_kmem_caches(void)
 	if (!target_completion_wq)
 		goto out_free_lba_map_mem_cache;
 
+	target_submission_wq = alloc_workqueue("target_submission",
+					       WQ_MEM_RECLAIM, 0);
+	if (!target_submission_wq)
+		goto out_free_completion_wq;
+
 	return 0;
 
+out_free_completion_wq:
+	destroy_workqueue(target_completion_wq);
 out_free_lba_map_mem_cache:
 	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
 out_free_lba_map_cache:
@@ -153,6 +161,7 @@ int init_se_kmem_caches(void)
 
 void release_se_kmem_caches(void)
 {
+	destroy_workqueue(target_submission_wq);
 	destroy_workqueue(target_completion_wq);
 	kmem_cache_destroy(se_sess_cache);
 	kmem_cache_destroy(se_ua_cache);
@@ -1380,7 +1389,6 @@ void transport_init_se_cmd(
 {
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_qf_node);
-	INIT_LIST_HEAD(&cmd->se_cmd_list);
 	INIT_LIST_HEAD(&cmd->state_list);
 	init_completion(&cmd->t_transport_stop_comp);
 	cmd->free_compl = NULL;
@@ -1827,6 +1835,91 @@ int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 }
 EXPORT_SYMBOL(target_submit_cmd);
 
+void target_queued_submit_work(struct work_struct *work)
+{
+	struct se_cmd_queue *sq = container_of(work, struct se_cmd_queue, work);
+	struct se_cmd *se_cmd, *next_cmd;
+	struct llist_node *cmd_list;
+	unsigned char *cdb;
+
+	cmd_list = llist_del_all(&sq->cmd_list);
+	if (!cmd_list)
+		/* Previous call took what we were queued to submit */
+		return;
+
+	cmd_list = llist_reverse_order(cmd_list);
+	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list) {
+		cdb = se_cmd->se_tfo->get_cdb(se_cmd);
+		target_submit(se_cmd, cdb);
+	}
+}
+
+static void target_queue_cmd_work(struct se_cmd_queue *q, struct se_cmd *se_cmd,
+				  int cpu)
+{
+	llist_add(&se_cmd->se_cmd_list, &q->cmd_list);
+	queue_work_on(cpu, target_submission_wq, &q->work);
+}
+
+/**
+ * target_queue_cmd_submit - queue the cmd to run on the LIO workqueue
+ * @se_cmd: command descriptor to submit
+ * @se_sess: associated se_sess for endpoint
+ * @sense: pointer to SCSI sense buffer
+ * @unpacked_lun: unpacked LUN to reference for struct se_lun
+ * @data_length: fabric expected data transfer length
+ * @task_attr: SAM task attribute
+ * @data_dir: DMA data direction
+ * @flags: flags for command submission from target_sc_flags_tables
+ * @sgl: struct scatterlist memory for unidirectional mapping
+ * @sgl_count: scatterlist count for unidirectional mapping
+ * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
+ * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
+ * @sgl_prot: struct scatterlist memory protection information
+ * @sgl_prot_count: scatterlist count for protection information
+ *
+ * Task tags are supported if the caller has set @se_cmd->tag.
+ *
+ * Returns non zero to signal active I/O shutdown failure.  All other
+ * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
+ * but still return zero here.
+ *
+ * This may only be called from interrupt context if the caller's
+ * queue_status and release_cmd callouts do not block.
+ *
+ * This assumes internal allocation of fabric payload buffer by target-core.
+ *
+ * Callers must implement the target_core_fabric_ops->get_cdb callback.
+ */
+int
+target_queue_cmd_submit(struct se_cmd *se_cmd, struct se_session *se_sess,
+			unsigned char *sense, u64 unpacked_lun, u32 data_length,
+			int task_attr, int data_dir, int flags,
+			struct scatterlist *sgl, u32 sgl_count,
+			struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+			struct scatterlist *sgl_prot, u32 sgl_prot_count)
+{
+	struct se_device *se_dev;
+	int cpu, ret;
+
+	BUG_ON(!se_sess->se_tpg->se_tpg_tfo->get_cdb);
+
+	ret = target_submit_prep(se_cmd, se_sess, sense, unpacked_lun,
+				 data_length, task_attr, data_dir, flags,
+				 sgl, sgl_count, sgl_bidi, sgl_bidi_count,
+				 sgl_prot, sgl_prot_count);
+	if (ret < 0)
+		return ret;
+	else if (ret > 0)
+		return 0;
+
+	cpu = se_cmd->cpuid;
+	se_dev = se_cmd->se_dev;
+	target_queue_cmd_work(&se_dev->queues[cpu].sq, se_cmd, cpu);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(target_queue_cmd_submit);
+
 static void target_complete_tmr_failure(struct work_struct *work)
 {
 	struct se_cmd *se_cmd = container_of(work, struct se_cmd, work);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 63dd12124139..815de4c97230 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -487,7 +487,7 @@ struct se_cmd {
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
 	struct se_tmr_req	*se_tmr_req;
-	struct list_head	se_cmd_list;
+	struct llist_node	se_cmd_list;
 	struct completion	*free_compl;
 	struct completion	*abrt_compl;
 	const struct target_core_fabric_ops *se_tfo;
@@ -764,9 +764,15 @@ struct se_dev_stat_grps {
 	struct config_group scsi_lu_group;
 };
 
+struct se_cmd_queue {
+	struct llist_head	cmd_list;
+	struct work_struct	work;
+};
+
 struct se_device_queue {
 	struct list_head	state_list;
 	spinlock_t		lock;
+	struct se_cmd_queue	sq;
 };
 
 struct se_device {
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index d60a3eb7517a..d7b54f3e04da 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -80,6 +80,7 @@ struct target_core_fabric_ops {
 	int (*queue_status)(struct se_cmd *);
 	void (*queue_tm_rsp)(struct se_cmd *);
 	void (*aborted_task)(struct se_cmd *);
+	unsigned char *(*get_cdb)(struct se_cmd *);
 	/*
 	 * fabric module calls for target_core_fabric_configfs.c
 	 */
@@ -160,6 +161,12 @@ int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
 		struct scatterlist *, u32);
 int	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u64, u32, int, int, int);
+int	target_queue_cmd_submit(struct se_cmd *se_cmd, struct se_session *se_sess,
+		unsigned char *sense, u64 unpacked_lun, u32 data_length,
+		int task_attr, int data_dir, int flags, struct scatterlist *sgl,
+		u32 sgl_count, struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+		struct scatterlist *sgl_prot, u32 sgl_prot_count);
+
 int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun,
 		void *fabric_tmr_ptr, unsigned char tm_type,
-- 
2.25.1

