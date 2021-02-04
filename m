Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7727DC4332E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4461864F53
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbhBDLhl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:37:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235905AbhBDLgT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 06:36:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BYXuX072776;
        Thu, 4 Feb 2021 11:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Z0p4kvWJPsQosC4i9Tc+WKZWQItTH4hwsAE0GdTYAgo=;
 b=FSRby1kI0usjZLUVkJbhgTM/V7UvbM+guWft9zKiBIhO9cYi7suIqnnq/wa9OjWEhtGj
 98/hw8tBwoFyFVd6tztL9/ApuxwQtLQVB0YHK75D1ZySvHhgbbnB1CWMSxK0wpU2se9G
 6gTSo1yHECcPDZYj5hko3g7rvQZIvDf3qI2eNVu1PN8hLIXsac1vP19y09FMXm9pdIwc
 LrGmETSwSqVJq2/kJ12nQjgNq6drdyUfPU029J3/vjHvW/Wx93AkiBEjyJoCXJLl1OXc
 mJopwJ6Wx1zAcSG/4yl+jDiuBnmvGGf1vjXtnKzw7X7aTWtazrl/6CRAfIwv6o+oRzNs rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36cxvr7h0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BZ5jl187745;
        Thu, 4 Feb 2021 11:35:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3020.oracle.com with ESMTP id 36dhc2jep9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrJzGdSgz3AdX9dpCkSNYpBL3wbqkavF7ZjyJBLyzI7OTmdG5VZ6HYKxlk1ckB5Fy9SLGvanh8Cf3oHOaB6krVwNU8/uRMMuVeLFxogb++aQPFu29+xtNJemgfNSugNOLDTnohw3kwaZyZfsg3sM4n1QA8LrBV6xQFYc8y67rxD/JOX33dWKMpn9o5n6Jm8mnHSHbCwHkBF4eiaGFDk9Y2Qt/7WUxaAY6ppiNmOOBLSH3Q0DZY88y+hyuSnJqHDo/F9KzehcCYK0HCnvxj6mjyaJhSI7bIAB3i7oNJmak9rqWjzmQfzEsNwiQBEGlZnBzwpJuQ6tW0Ww4PFN97d/uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0p4kvWJPsQosC4i9Tc+WKZWQItTH4hwsAE0GdTYAgo=;
 b=DXggHWHHNA9Ixhg6BDP+7ohT8bS/xMkIckPTbgMto0gUyCaNsGFe/7WtilE5ulxKHnyh0XGfsl8f7OZTZbY9BdvsF3/aN6kFeVF7Oi2UePf4p9iiol652UfR9kuU6cSwYWwV+6TSJ135HORPOSxJlTK6wOOxEY5vDs3xKQq1PnkAhEU456EE0P915C4sqT0AF+UPL1mhKRSTnXr4+fqTrh/NXTKEC4moE+86kfrU9Hu9DoPtN2lvRyLsYMhz5cZVATxXlgSCbp13gvmoxDKBnGtw6X2PNnmpscDpOw8GB6VJk5zQDr7t45hzo8Qr6ifRuARjX8lB1o88V0tRWVEXsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0p4kvWJPsQosC4i9Tc+WKZWQItTH4hwsAE0GdTYAgo=;
 b=j92NTyGDltZsb+kj3FRL8C1TfyZtoxPoG1UcOlu0wFEyMRtFgaTPwpRgz4G6q0ifP3dBw70wdjPpUxp5ANEDJwVfWwodUv57GC36u0oI+h2czWU50ybsJKmUFzL22hrkZSH1sCNY7rrZqfwFf7jqr5m2Y51jlxsbA3Fbxi16cvA=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 11:35:29 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 11:35:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/11] vhost scsi: use lio wq cmd submission helper
Date:   Thu,  4 Feb 2021 05:35:07 -0600
Message-Id: <20210204113513.93204-6-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 11:35:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c744f9ec-dc5d-47ac-e015-08d8c900f93d
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4480491B5BD305FB8107AE5EF1B39@SJ0PR10MB4480.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bED/HuIseJaChlefo4mGM7Hb8MoVNopztnjmOFBXjbhQ2QoH+fi6MloRW3dHPMQ6yFmdcUUc6klVwJLNG5x/wdKf2G4hl9Lz8+vrCzdCYKTL8wTuMuNK4EFI7094Og2IlOFn9peq/f83NwZ+8rkgd2Czlep0F/9rWycsYZ3z0WYPyNNhYUYbDAerWYHLLzvEkYbZGeLS/ne2GAlq4uhw4yi8mQbNwXGYYB9HjA396NtyO5sFh3lBwrKYng5NiTqiIuHM5mk/+hVei5cLsVWi8Tu1bsVO+5MO0xIISyLE8vwJscxRH+1j3iiHDozsnoVdx8Loh18Vy3mkwh3WGBPhKlS4pvoUOAONKTZHlrZCLUcKJ7fCxL5HtsH0VbFMJn80ZNwnqLr7IKOG3ib/fLeZ8OFy8qtp+lFo0Vdad75OyF3VrRlCWiMfZsZ2TvnvqQRckYegxOM2b1UeqBoM1hTeLPntNAnvL9IRi4AB92x7jcu9kA4mG5WauEuADpaApNNZakyfA5xm6wbysgA1EJnAaon8QOanYRYWArTy2Dvfu7CBLqcTIcnE9EvpzWd+U8pqFa2JzZM8JG0ggwOFmkPCwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(52116002)(66946007)(66476007)(66556008)(26005)(6512007)(478600001)(16526019)(6486002)(8676002)(107886003)(8936002)(4326008)(186003)(2906002)(6506007)(5660300002)(6666004)(2616005)(1076003)(956004)(316002)(36756003)(86362001)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ItUqFDueIC9HW5MLURUk5d9PTJPvjf4LezMooFc7C+HtSfYBVXKUCy4A5+LM?=
 =?us-ascii?Q?ulTA08p8+eVPWQnMJyZALhKBXBMNuTIBJ7ggMPxbVn8TGOFQV5zqsV+dIrH2?=
 =?us-ascii?Q?i4pCJdzdpOd/knkUTijA+qCoSurEXfqxDcWSeZxaW9QSrEV9XzwHhyZDivBu?=
 =?us-ascii?Q?2TYh/yb0laVBVu4ck6eYFDtWLq2s+q58vCMGXEwJSDvtraT1GX32FTBpd5hx?=
 =?us-ascii?Q?wtoM3Gvny1We7dzi77LG4G798ECCDlvTA7Dx/niaSQn9btQ0NUIPX5Xm163L?=
 =?us-ascii?Q?h1la5H1opcJQWOlx/59ARWZ5io8WRBZOpSAgmTqOou+BfK8Fs7wbF1fPDrrv?=
 =?us-ascii?Q?JpcBmAh6BXxT07cM+07R1/NbZYwIRub2jF6XpypGMJE5TjaUFr0O0libFby0?=
 =?us-ascii?Q?1IKzzyqCnQoEnj8S05z+/IIZ8voNhJdwOiWVNCUlXoeOrRsbhToM5rNjFwN8?=
 =?us-ascii?Q?h+1JJTgKe69/sHIXXZEKac9XpWVCMUlYKNiIL5yZClO5zZIuY++gB9XQbLSD?=
 =?us-ascii?Q?Om2RW0ULN9n46k11LHNpeuAOwRYOBfafp47tO/n4Hx4/2K4q3DvVO/f7VSdw?=
 =?us-ascii?Q?q6m3J2Fo1g7GJOWKMrHgTjsDIFLxH1V6NDCZLQz+uQlnm6FxT5EbIjLNFa+i?=
 =?us-ascii?Q?W+pq1FLumU/gUuwe8puo7fu6DcjMS47qUKB5MugQkovC7hTeac1Itb4WY+nY?=
 =?us-ascii?Q?qy1IXy+bzFMYr9hDLUc54OeQ8JKxmTCWunbAHRz013g5R1ynYM1xvCyz5DxX?=
 =?us-ascii?Q?fxAlL21Rn8pVf4SdYgcXOJtFEG68M+V8ysGCEw5vAVpiu7g8nRy2+RE7o8wt?=
 =?us-ascii?Q?StIrYn8C+O+0RjoUzHB1G+OR6zdvgLNNgWvPc5SOyBPJvaFjyskaN6cRZIQ1?=
 =?us-ascii?Q?bzavBJCBqZFPiz8KN2TmTqfdatjAQ15Bf5egCkhPnlvOPUUE/PruReIkRrVg?=
 =?us-ascii?Q?wrP7n9so5rlxt31DgAj/jGfDZS0nDhYtm5vAfOe9uN58mgd/TcpQCEHJlFva?=
 =?us-ascii?Q?+a5nzdmmJ0xeykI+McOpQsvRwhSfibmKaIS2C26ENOWxgZe05s/7Y4i/NGQa?=
 =?us-ascii?Q?m5vj6iqzsujvc3OPOIfXfeA5i1lZV46tDWQL4IahcajW/JfRYvoYxNvnBDHQ?=
 =?us-ascii?Q?XzrrD52/5FLrUu9uqL4HJPcfwc5oJsFVeRRkAaB/mMS2bOSQ6mbUamausCC6?=
 =?us-ascii?Q?bbCPVZ3CgEsCqlWzFlOHs6gdV+UayKfxD+GaA6ZVQWQzT4eAcMEWggBxRCOI?=
 =?us-ascii?Q?vPGHY2FMikd1IB2xnTWy3JBFK779Umj2Kvsnr3krxn51akF1US/mVNuPkhtn?=
 =?us-ascii?Q?aE2dlbb4z0ck2+hy/4ohbiSh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c744f9ec-dc5d-47ac-e015-08d8c900f93d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:35:29.4308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TRUAb4WXVYp1RV5/VPi1b+kj8Wm5Z3BJoqcTf6V8YiEpKomL00KEU0gGC5BFcT8vV//U217Mt9ifiZiuQ2dDEYO1n6c2aVIX9MYESvR+Syo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert vhost-scsi to use the lio wq cmd submission helper.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 4ce9f00ae10e..aacad9e222ff 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -85,7 +85,7 @@ struct vhost_scsi_cmd {
 	/* The number of scatterlists associated with this cmd */
 	u32 tvc_sgl_count;
 	u32 tvc_prot_sgl_count;
-	/* Saved unpacked SCSI LUN for vhost_scsi_submission_work() */
+	/* Saved unpacked SCSI LUN for vhost_scsi_submit_queued_cmd() */
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
@@ -782,12 +778,11 @@ static int vhost_scsi_to_tcm_attr(int attr)
 	return TCM_SIMPLE_TAG;
 }
 
-static void vhost_scsi_submission_work(struct work_struct *work)
+static void vhost_scsi_submit_queued_cmd(struct se_cmd *se_cmd)
 {
 	struct vhost_scsi_cmd *cmd =
-		container_of(work, struct vhost_scsi_cmd, work);
+		container_of(se_cmd, struct vhost_scsi_cmd, tvc_se_cmd);
 	struct vhost_scsi_nexus *tv_nexus;
-	struct se_cmd *se_cmd = &cmd->tvc_se_cmd;
 	struct scatterlist *sg_ptr, *sg_prot_ptr = NULL;
 	int rc;
 
@@ -1132,14 +1127,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
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
+		target_queue_cmd_submit(tpg->tpg_nexus->tvn_se_sess,
+					&cmd->tvc_se_cmd);
 		ret = 0;
 err:
 		/*
@@ -2466,6 +2455,7 @@ static const struct target_core_fabric_ops vhost_scsi_ops = {
 	.queue_status			= vhost_scsi_queue_status,
 	.queue_tm_rsp			= vhost_scsi_queue_tm_rsp,
 	.aborted_task			= vhost_scsi_aborted_task,
+	.submit_queued_cmd		= vhost_scsi_submit_queued_cmd,
 	/*
 	 * Setup callers for generic logic in target_core_fabric_configfs.c
 	 */
@@ -2489,17 +2479,9 @@ static int __init vhost_scsi_init(void)
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
@@ -2509,8 +2491,6 @@ static int __init vhost_scsi_init(void)
 
 out_vhost_scsi_deregister:
 	vhost_scsi_deregister();
-out_destroy_workqueue:
-	destroy_workqueue(vhost_scsi_workqueue);
 out:
 	return ret;
 };
@@ -2519,7 +2499,6 @@ static void vhost_scsi_exit(void)
 {
 	target_unregister_template(&vhost_scsi_ops);
 	vhost_scsi_deregister();
-	destroy_workqueue(vhost_scsi_workqueue);
 };
 
 MODULE_DESCRIPTION("VHOST_SCSI series fabric driver");
-- 
2.25.1

