Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67AFC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE23D64E65
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhBLHbm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:31:42 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60586 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhBLHaA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:30:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7Ov9A176822;
        Fri, 12 Feb 2021 07:27:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=C8+cdTPDKRcoXR+WyGc/w4I0aeNtYx+XJrKdZwce5U8=;
 b=eA3ZUp2qc9ay06W6xWlyirSLLAWYF04J27CmEGbS0NQGGwZLy306FKnISrQTCL3k5gND
 TWlR6wwTd2PU7MpG6uXztST73KhvyXmja5l1Nc0J6UH2HQooepqqyL+RFICjDurKOEGt
 g0zKDFs6YbKpAtIrjvq10L2SKAK4fvQfHWug9/I8vM2M/pud0XTDQ03KxG8z4m5UqlRF
 wajlm6QNYB71lfgtdmUGMjshS8Xb29tTWeK7AFI7K2yNvUk02jbS/GXSQtJHxCCQyYvA
 3of1JmqGC8NvKc6+ponddyBsqogLzkR7KT0xZAmFAzr7f8WW4oAC0C62B8mrnXotEmqw YQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36hgmataw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7Q9BV090048;
        Fri, 12 Feb 2021 07:27:11 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by aserp3030.oracle.com with ESMTP id 36j4psn5st-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nscgNV93LqgrZTJmR/do4tg4A695e7k2YRxgm2Mc5h8/uV3Y5tggnOudYY8ZplAosLqNDvsottDwQuGBEi9txJcTCc/OrCy0AUan0BttWx738cBAHPMud4sCAfwPjI+OfivniCrPKRmjm25k/QiJsPJGb4RVpJfiIe2maDoWff+5UlzSZHZMwOGKk9ZOcQq5c5KHkjLdwZAABJ8Nio7drZOfiKOQHoZl113owXrwPL2L+Hnu0j0X7u2iRz9TewuyOvYtZ2/VsRDA5p8/FdB+cyJcBrDHbB6z8RV+sYHO4Y6QaQuYGn2tcDZi3TYBjpF2UdgKcP8EvIRp9KQq+6oBGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8+cdTPDKRcoXR+WyGc/w4I0aeNtYx+XJrKdZwce5U8=;
 b=fYGcY7PL7t2PL6K9NgCOQ9KqmaQhrmhAyC76oPWQ5cFnQJeWwiqUmqIThrHjJvf142hDs1opAyIQN4eiG1Q+XLBjlCf2YceE5zuqDLdeSaMlo+G9lIprhQJ+3Wez2H4psRtsd7wi34nODQyO8GtQKCjOeDfounn49UEE8ChWqZM3l5Ai3KFemLBLJZ/AQNT4NP7H4i7rqQtEeGSQ+5p6C/NP6S7oJjkEf+5igJuVoHNmFKjA7PAHdZ6NUiDvIPKtHWPL2bX6PSye6cPQ4bZIXZmxLSGPdIgCKpgyF6rr+U33uXgCfXF1X52+zY/9g3WyIy/JynDaYflIuTSEDbnTUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8+cdTPDKRcoXR+WyGc/w4I0aeNtYx+XJrKdZwce5U8=;
 b=D1gvzbfCim9npFXReuegWz5cZ/dQB3oz6G+86FpW155Rzi/Rs+DFqxPGI27woM18DZKMSSfzBjZUnf/nDmaeht5njaXksA7XiWzglg4CDDdlxfM6ibCITvsv9a4tA410JZObJ2a31u+w+CHUrKasUjc9QL6nGqL64RUIz49MXso=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:10 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 17/25] vhost scsi: use lio wq cmd submission helper
Date:   Fri, 12 Feb 2021 01:26:34 -0600
Message-Id: <20210212072642.17520-18-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 135a3ca7-0d8f-4e42-2888-08d8cf279be8
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254429C53DBDF51027A0311F18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ARYsssfHnsk2UWdntGZ8Bm8mqQnB3LpfTSzADOOMdzYeqy5kdLBsiO11J8aJtMz1U7dGAkK5NLF1/KMAzCWEBzfSKWC/+m6U6DmExxCwNq4edVtxgLvxq0X7DowWjaAk9bv29El6qY/4DnEzJChZwNDCMksjCBugmf34HgDY4oirL/Z/00V2d+ykejoCp+5HrHKBT6ZuzVWFwnN6TJ3lliMz9dc8zwM7qjdaU+WhzYXACri9lo6c2nF/Wp9dFiEuxxGRbjuAagxkFOAm4ZBsYz6643lDcue1JsVI1TtRnxxTY9Z41xt2V7GxU5294jkii88v0GJfybJtkLJuK2cBr4B2FNtP4alirGLMe+PIu5r6WbTH8pz2LVow7EXLC6RgfgyCD4aXewnK0lPwZOLQQBuxvnu4TFPJWn5r1JGafjtH6IwUKMq/OQmu7QqejeTR0JI5AaO2nItDf91YDrhR2sB5aDE2/wSZikQQM2fgwlDfjXx3aP4SgXF5arpXGf7aHuVxfP6q2PhIcVyjLaEr+7LdBhMB+0ogDGB2lD3z5JZ84KZcr7NHcQBTTnECwd9fl+BKu0yGqxIaiRN8b3ByYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(107886003)(26005)(956004)(6666004)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SKxq18jC+2RMhBcLAxFwGwA5wZd4jncV5tzP5vqch+kXUiAMr52JVApnhhQ0?=
 =?us-ascii?Q?xvkF5kYhjh5huZTYIO0Cle7C0Fdv7+htk/d7bsGUc2kCxWmBDIsFzOXBpTDJ?=
 =?us-ascii?Q?ppkeKqUNxz8pu0BcrWEfBSsuja2pn+03yIhcIW+WaCTLR7bvuGfs5YJh80I4?=
 =?us-ascii?Q?bNEEoYtHZxcB9JrFIT1CTERJaNxruGU3PkCY4Sk2KycCza3MdRagnjYjFD4a?=
 =?us-ascii?Q?HEfhHfpX94/oR3stN9nBC74aIDWJ3YmFpu+QvvhtLPW9ht21yJGWzsxc/7jQ?=
 =?us-ascii?Q?n3aOn+l5NoukOUGWF8V26UYmxnlAzhkkBcSq4d9OJN8mNkp4RrBt/Jcdj6c4?=
 =?us-ascii?Q?Bpv6POmT9ndK5fFkchJLZeHFeCrwa39ZpV33pFRYKy19l2s7uHPXI9gtBVlg?=
 =?us-ascii?Q?vc+zCGbu1fSFqGCzWHt1uHs+qP+qrcvTfVx9SMlH+OMDi5fa9QFvIkoH72A7?=
 =?us-ascii?Q?uc7L4zsPfK31a9lcG98lbKokXW4ZF7TWzhHHO7FFa7Gc1zGQEgoiEL0/X/7r?=
 =?us-ascii?Q?lGZm5lkyT9vn1FBgJFmtk2cBhFb8LzBcxiTobx0ron8bNPZ6dQz6Km4O7k3E?=
 =?us-ascii?Q?RFtr0bNO1uZYZNuVKXHrqbRiq9J1BRcHhWxj6IU7EYCy1/mqoM6h83YgTSjf?=
 =?us-ascii?Q?SLBwGF/9IW/EbnUBHcjw+SafnANJdNs/qmOwICPWdlLv786zieemm5mMcKrx?=
 =?us-ascii?Q?aovWRjGJPQjUmlh4EIUKCQLymxDlNlST2OqdI3dAhqcHthMcoTD2z4qobDxg?=
 =?us-ascii?Q?LnNJ5SnxtZ+H5L5DoIZe5nKKiIVWD8erhReNs5rkc6Qy1YXkTvMa2ntDmChx?=
 =?us-ascii?Q?JqnZLY5opI7pAi62ELAXzTjTjGDpqFDlDpuzuxTZgcKnAS23IgqfyzEMHokT?=
 =?us-ascii?Q?gz2vNapQxC4KkHPqIoUJ6w0Bv294PROVXAe8skeXnQmSlMox6nvhetAWCd86?=
 =?us-ascii?Q?xzK5bvMsdB+82g4pdKRvqeUVoEtAYt7gzIKWiOzBUr0/dQC6KSqj7rks9Rrk?=
 =?us-ascii?Q?JBbGKbdvltZelHAibHrQuLD0JltAXJQnxtMHmZ5D2mYsFlG6gCoNKzj7CCQC?=
 =?us-ascii?Q?576gVkV8+MQFBXl7bJP9hNH+f00D+VHf0Dwf2UplL3elk4Bh7rLa61UsdshB?=
 =?us-ascii?Q?fhR7VutO8M3mNfI9JzFXwI3Zoe9Ipc0bLJLlZ4tPLXrHepIdSEa5tqbbtSl6?=
 =?us-ascii?Q?AfrVVkDccKc9CVpc76o6VKR+E83jzomPP12i+/s8cvNSWv/dSBZtt7TXmXmf?=
 =?us-ascii?Q?/Hp8KseLQIhSECoyZfSNRPXrOYqLZ6fE055I9PUsYvk5sZEy2O+22wD9/2iU?=
 =?us-ascii?Q?P6TxdfknZCUY+Ef8Y/DXF56y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 135a3ca7-0d8f-4e42-2888-08d8cf279be8
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:10.0911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gIqiR8JuUQke4l7Ej1FlHn8eqjOA0HFp9iI4dzD8fPP2lqnd3UrI4yyIg9W5kVMa7ASS0rz0p+TXAuitI/Q72Iy1kEIZtoiVFgTW420WTy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert vhost-scsi to use the lio wq cmd submission helper.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---

V4:
MST and Stefan, I dropped your signed off's for this patch
because it has changed. It's really close to what you saw before
but I was not sure, so do be safe I removed them.


 drivers/vhost/scsi.c | 36 ++++++------------------------------
 1 file changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 93f5631b469c..f3448e542965 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -85,7 +85,7 @@ struct vhost_scsi_cmd {
 	/* The number of scatterlists associated with this cmd */
 	u32 tvc_sgl_count;
 	u32 tvc_prot_sgl_count;
-	/* Saved unpacked SCSI LUN for vhost_scsi_submission_work() */
+	/* Saved unpacked SCSI LUN for vhost_scsi_target_queue_cmd() */
 	u32 tvc_lun;
 	/* Pointer to the SGL formatted memory from virtio-scsi */
 	struct scatterlist *tvc_sgl;
@@ -101,8 +101,6 @@ struct vhost_scsi_cmd {
 	struct vhost_scsi_nexus *tvc_nexus;
 	/* The TCM I/O descriptor that is accessed via container_of() */
 	struct se_cmd tvc_se_cmd;
-	/* work item used for cmwq dispatch to vhost_scsi_submission_work() */
-	struct work_struct work;
 	/* Copy of the incoming SCSI command descriptor block (CDB) */
 	unsigned char tvc_cdb[VHOST_SCSI_MAX_CDB_SIZE];
 	/* Sense buffer that will be mapped into outgoing status */
@@ -240,8 +238,6 @@ struct vhost_scsi_ctx {
 	struct iov_iter out_iter;
 };
 
-static struct workqueue_struct *vhost_scsi_workqueue;
-
 /* Global spinlock to protect vhost_scsi TPG list for vhost IOCTL access */
 static DEFINE_MUTEX(vhost_scsi_mutex);
 static LIST_HEAD(vhost_scsi_list);
@@ -782,12 +778,10 @@ static int vhost_scsi_to_tcm_attr(int attr)
 	return TCM_SIMPLE_TAG;
 }
 
-static void vhost_scsi_submission_work(struct work_struct *work)
+static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
 {
-	struct vhost_scsi_cmd *cmd =
-		container_of(work, struct vhost_scsi_cmd, work);
-	struct vhost_scsi_nexus *tv_nexus;
 	struct se_cmd *se_cmd = &cmd->tvc_se_cmd;
+	struct vhost_scsi_nexus *tv_nexus;
 	struct scatterlist *sg_ptr, *sg_prot_ptr = NULL;
 
 	/* FIXME: BIDI operation */
@@ -814,7 +808,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 			       cmd->tvc_prot_sgl_count, GFP_KERNEL))
 		return;
 
-	target_submit(se_cmd);
+	target_queue_submission(se_cmd);
 }
 
 static void
@@ -1130,14 +1124,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 * vhost_scsi_queue_data_in() and vhost_scsi_queue_status()
 		 */
 		cmd->tvc_vq_desc = vc.head;
-		/*
-		 * Dispatch cmd descriptor for cmwq execution in process
-		 * context provided by vhost_scsi_workqueue.  This also ensures
-		 * cmd is executed on the same kworker CPU as this vhost
-		 * thread to gain positive L2 cache locality effects.
-		 */
-		INIT_WORK(&cmd->work, vhost_scsi_submission_work);
-		queue_work(vhost_scsi_workqueue, &cmd->work);
+		vhost_scsi_target_queue_cmd(cmd);
 		ret = 0;
 err:
 		/*
@@ -2487,17 +2474,9 @@ static int __init vhost_scsi_init(void)
 		" on "UTS_RELEASE"\n", VHOST_SCSI_VERSION, utsname()->sysname,
 		utsname()->machine);
 
-	/*
-	 * Use our own dedicated workqueue for submitting I/O into
-	 * target core to avoid contention within system_wq.
-	 */
-	vhost_scsi_workqueue = alloc_workqueue("vhost_scsi", 0, 0);
-	if (!vhost_scsi_workqueue)
-		goto out;
-
 	ret = vhost_scsi_register();
 	if (ret < 0)
-		goto out_destroy_workqueue;
+		goto out;
 
 	ret = target_register_template(&vhost_scsi_ops);
 	if (ret < 0)
@@ -2507,8 +2486,6 @@ static int __init vhost_scsi_init(void)
 
 out_vhost_scsi_deregister:
 	vhost_scsi_deregister();
-out_destroy_workqueue:
-	destroy_workqueue(vhost_scsi_workqueue);
 out:
 	return ret;
 };
@@ -2517,7 +2494,6 @@ static void vhost_scsi_exit(void)
 {
 	target_unregister_template(&vhost_scsi_ops);
 	vhost_scsi_deregister();
-	destroy_workqueue(vhost_scsi_workqueue);
 };
 
 MODULE_DESCRIPTION("VHOST_SCSI series fabric driver");
-- 
2.25.1

