Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4666CC4332E
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11FBB64E45
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhBJE41 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:56:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41000 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhBJE4V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tZSQ139922;
        Wed, 10 Feb 2021 04:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=u+xiQn5GyXdQkBxVmYnI8zNMC01FeeMnEGS9mCrFlsI=;
 b=Xv5m7clWKfGi7y4PVf1b4QCtPcmRnnera27cPL4bne7DaCJMZIfgLJXqqHILRY5956rT
 ykSfsG40tPrJ/7kva8qvdfElPMeJj/TVoTNjuQoHrs6vwbMumf/t/24d+GHvMQBXraDG
 DiK2TJWweTil1JSPFPYssdIdCQ80IKa21a1gVDy6Lxx6MYlRyQXPyYJkFUY/HZ+WrsxE
 d42vXPguLuZOpJnzoSOPKiPkIrA8pbhT1rqdqjH5Kghv6Pg/qI4A2NB1/b5FpUb4/X8b
 78qVES78Jlj5nLQt2YcMpa0Y/12nbtzeXAdlQEk5gbRZLorh5WSNwttjOaO+m+nAwjZI eQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36m4uprdfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRB6048727;
        Wed, 10 Feb 2021 04:55:34 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2ur0JM+Yb2T63gdyV8H/WVNYn95iPSm5kYNY6Y5dFQfdG1zI/KMJlFeACfvV5489597w4A50jIe41jw4Oh9x33gR/yqGyBy2duSbp3+Y/XYf/XNZHS3Cwg6d87avKReC5UqS9WNbnd9RqTVuw8JpE8pXz5bXo9/p1RRFPb8PaTImkGQeWZ7g2xeBA2FMoBUulzmq33TN2RYKjfFgqYiFf7gkt3rtsePe/403Y2dsIILxT6g9iyXx9JN0S22KHQSLx9uBicCbsgenup7cEWumZtkO8g1fMOKc3TxXgGSDBELf9fUdZLWdDNU3lIk8WKo2tV5r3eOtm5tOgD0e7gFLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+xiQn5GyXdQkBxVmYnI8zNMC01FeeMnEGS9mCrFlsI=;
 b=g16n1GsMAbVWwMi2uJKP5FaE5FaRtR1S/uhKQPij+DlD9gsA6HJBFh1hlsMSW+c56hguV2pmSt31Fal9kVn87MiQ1pFKHBm9P+0prG6NPLx4dKbFdTVfu7YU7JzD4E7hDl9R3MTfatxwxZIbK9ubA7vbUZLRrxbYk3/cOpJgDOO8f+CxEhU2zTt8nv5T26ldjT2d6LD3z+/BJmQIv1zJxTYRbpwa8jfaNS141S/TGEhO//D32YT4vvSEqzx9CT80Uy2qdaEmQOMkngKkVXgKH6VH5yaP2+e1ZTtt3nxHOqflXIU3SdMRWNcfSPAhAPxsok3vTlK7oZQFeSNcUISqqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+xiQn5GyXdQkBxVmYnI8zNMC01FeeMnEGS9mCrFlsI=;
 b=jegxvRXDPPTQNbTxEM/TK7uJLwAvH/VSbXl86VTVJ/EoypUE1uKrr7HpvgM2SFWtH8osVLNaIxNpaYRmI4Mxh+aAI0edoN+LY8zYqLAxABKp9HxbSqkJipNVMHavPJ1rMTslG0p4kqJ/28oxgrQWg1/49YUuilW6ThCIEL71Xtk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:30 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/13] vhost scsi: use lio wq cmd submission helper
Date:   Tue,  9 Feb 2021 22:55:07 -0600
Message-Id: <20210210045516.11180-5-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc0862d5-4b87-46d8-1cb3-08d8cd801742
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33660B700F389B0D71F73AF6F18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Aiuth+1DVtYb/u6IL9ynU3ZRErJIRXe4tUf3zoZue/R+w8H3UnPSmRUNBKnHLwS6cLZqfPfxSAoEPVxdrEi+/BH6grVeqn3yyamNWQaVqynQr4lZ7CAVNIDsoberCijkm0YTQgE4ITA/LtpA/zbnbh6PAhx61DqGMQC1m7OQoVleIfGqQtcvDUHwKDYngKbxPa9rZxHqRfJGTt2T6j7NIY8vSe+bUn9U4S4oUCPoTdFmsvKhxtP6K7/sVjostEeWD+ZQiWGI+jJkAR/SRqhffR09wTv8aw1hvZI9pMB/CdSABw3/PmNz0sNYZsz5oPL9X2uR/0kPh3CCGVPQg3uVTOAW6Mqok07rkB14WtH2JBp9Rp/rFwxQwVIMwQKbfdA9DTVmZ8Ob3qhHMXRFtcrRAc0XZ67WDaqstO0JmycCeqit/YRx+nt8kbtT5KMJ1MqON12d9XfJtzwbWKw8KGIO74GxbGhtF6p2dYpTJ29/rlff/zOK088ojikdyg+fxX5vI57EvCk23eirFteBFvtKFNTQMN7BHzyc1EWC1W3nzCPWwlquPSGMatcmFOmyX3TELp8Bp4iOlgYpdUOuDORIxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(86362001)(26005)(5660300002)(478600001)(52116002)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(316002)(66946007)(66556008)(66476007)(6506007)(6666004)(4326008)(8676002)(2906002)(107886003)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CyQ5LWgI4VFlNhtzwCJVYwnkJEXbgv3xKULm2TrmH6t5XTs8gKZPEdejVTGb?=
 =?us-ascii?Q?PIv/xhSCNNYkCrcQ5x/m7eR7qPvKuI73pwgYWXtqO7QJuUYe/adYHsLvz1gN?=
 =?us-ascii?Q?/yXUeJzD8uYzy0/5MkFT0tfONrufgioMX+vywTgKfd/GDfYccbOygZTdtu5d?=
 =?us-ascii?Q?0zjOnZgj+Bxy1QY2K+1YGSj+ALAbnYhQAgT3kTA7WeOqcBbnMCIOx2TymFvI?=
 =?us-ascii?Q?91CVmtQ0r3XXeIuwp4KBbdgpgsZ9oNVpDlbtPYEtnM6xYjkcHjjMxIYlMX3O?=
 =?us-ascii?Q?BWkAYNscXu8fm2lsK97khBPsaVTmp20GmqqTy0lc3rAZgaA+FOkmyd5mi8C8?=
 =?us-ascii?Q?d2l0n3yI2kPgJnyExObMzkGlb3sOxqAhSgAFbwDuwTuKT1Je+7hN77HVQTx4?=
 =?us-ascii?Q?7CiOEYqPQQms6iYSFHG5tmMq0qLX8H5Vsnlvzr9w3pe2bfnKCqd2uJh44nSB?=
 =?us-ascii?Q?kKIlJK8W+e6jhMWEwGbtogev5JeOOqQyZvFEFCIkNatw2OtqG8zKD4Vt/u7+?=
 =?us-ascii?Q?g6/gn6U1vMwczFpDxTpMK+tuUuKr+PcVFUPHwGkugMw5kmOGUSVbaZxYtWGc?=
 =?us-ascii?Q?XHhJsXClKKbNQxq0CxcY5+9/5JxJf1a2SvuE40jtj1Wq9Eo+BRjIRz+fjr16?=
 =?us-ascii?Q?Hnrl+u2Xz+jqGwM72hk5vc3MlLfasDHTx5ashykml13Q3yRZQeLSWaeZQB5I?=
 =?us-ascii?Q?6Jl7NNGNBuvn9sCQo82+M3dMeBzrYguvxANXW2grXY+Suv1W1F6ymyp0oOx0?=
 =?us-ascii?Q?5bn2dsHrS1xYajIO5HlcbDtEQtCIyc987J4MP3QwLUGnjs/C/sIHvQXsbSue?=
 =?us-ascii?Q?MmlSZVptaNgzHO8UR7SPM8DXueSepIwbgtibZsYT7AuKGdjE3bDzGuM4Xd7o?=
 =?us-ascii?Q?55mJSfLNtDBK5MIyW+2KS99ppc5aDxyxY/q+tXeACG3Dh0J6sZw+RrUz5l9r?=
 =?us-ascii?Q?qw5SYfu2rbuE9nccjLiBSqyDHNo6dAXrYGBq/dSBBdJmC/+veTq9B8fXJml1?=
 =?us-ascii?Q?2YicNOvCYFfEUcme2aZEjqM/pW/FP4JC9lXvMmA82IPiQgVLB8g5dVRlVPV2?=
 =?us-ascii?Q?P2AGpsrIbeekhbRijcLgLMIU0zosEH0EshoI9QmKPbIKOlvRt7F9a90BqPxl?=
 =?us-ascii?Q?DepfPVyRPlPkp+viSAAppn98b5uWvgdwI1mZpWbja/OZaHHalCcIuVJ9JeME?=
 =?us-ascii?Q?4XjP5r6XGTUx/WVNk63cHZvoyk7KUtmysJIZdrLVlNlC7cc1FiO+Cx8kWBLh?=
 =?us-ascii?Q?CLmqPf1c1isKRJEKN/yucKlqQiOQc4ESX4rzjAaXGJ0ljclf13KwtGUCoGf/?=
 =?us-ascii?Q?LuJNwgGs6Fy95mrq+zk8bAZe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc0862d5-4b87-46d8-1cb3-08d8cd801742
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:30.4001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzB80ZhoqFt2EleuNMC8vmdm++MavO+Br4BLDY3np5kfDwMH+mpsT2Cz8bVPfsiXnLReyqRHEufmz+tibcG84IDOOHwq2i8cmNwFUhFoMuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert vhost-scsi to use the lio wq cmd submission helper.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/scsi.c | 49 +++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 4ce9f00ae10e..99909c6f3960 100644
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
 	int rc;
 
@@ -805,9 +799,9 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	tv_nexus = cmd->tvc_nexus;
 
 	se_cmd->tag = 0;
-	rc = target_submit_cmd_map_sgls(se_cmd, tv_nexus->tvn_se_sess,
-			cmd->tvc_cdb, &cmd->tvc_sense_buf[0],
-			cmd->tvc_lun, cmd->tvc_exp_data_len,
+	rc = target_queue_cmd_submit(se_cmd, tv_nexus->tvn_se_sess,
+			&cmd->tvc_sense_buf[0], cmd->tvc_lun,
+			cmd->tvc_exp_data_len,
 			vhost_scsi_to_tcm_attr(cmd->tvc_task_attr),
 			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF,
 			sg_ptr, cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
@@ -819,6 +813,14 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	}
 }
 
+static unsigned char *vhost_scsi_get_cdb(struct se_cmd *se_cmd)
+{
+	struct vhost_scsi_cmd *cmd = container_of(se_cmd, struct vhost_scsi_cmd,
+						  tvc_se_cmd);
+
+	return cmd->tvc_cdb;
+}
+
 static void
 vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 			   struct vhost_virtqueue *vq,
@@ -1132,14 +1134,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
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
@@ -2466,6 +2461,7 @@ static const struct target_core_fabric_ops vhost_scsi_ops = {
 	.queue_status			= vhost_scsi_queue_status,
 	.queue_tm_rsp			= vhost_scsi_queue_tm_rsp,
 	.aborted_task			= vhost_scsi_aborted_task,
+	.get_cdb			= vhost_scsi_get_cdb,
 	/*
 	 * Setup callers for generic logic in target_core_fabric_configfs.c
 	 */
@@ -2489,17 +2485,9 @@ static int __init vhost_scsi_init(void)
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
@@ -2509,8 +2497,6 @@ static int __init vhost_scsi_init(void)
 
 out_vhost_scsi_deregister:
 	vhost_scsi_deregister();
-out_destroy_workqueue:
-	destroy_workqueue(vhost_scsi_workqueue);
 out:
 	return ret;
 };
@@ -2519,7 +2505,6 @@ static void vhost_scsi_exit(void)
 {
 	target_unregister_template(&vhost_scsi_ops);
 	vhost_scsi_deregister();
-	destroy_workqueue(vhost_scsi_workqueue);
 };
 
 MODULE_DESCRIPTION("VHOST_SCSI series fabric driver");
-- 
2.25.1

