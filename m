Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF76AC4332B
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD56D64E88
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhBIMkA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:40:00 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39130 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhBIMjs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CYEdh047856;
        Tue, 9 Feb 2021 12:39:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=u+xiQn5GyXdQkBxVmYnI8zNMC01FeeMnEGS9mCrFlsI=;
 b=IGWiRwAmag8htC30vXBslO5cGvW8qZ9O1S4uJbOQbkufyiYYA19h78qg0PAI9ALyVC7m
 zjdPKnqu9YQn6WXRGyIDoC6GLvQglAie6D6GQDlKU9NlCcPsV6fymqE48RkO7aU9thLI
 P8BbtjGg1umCgBhW8+26Tu+pCJ66pTGGDo2Ze60sIF+1McOYRi4U/hz1wmIQbl74cWNK
 cnQrLQNgg2mN2tYuDonQOcf4SrSfzkVqkCP/IiVRklbnluO9Krmjju3Gr+c0dsOBfK5p
 UW8AXWZz64oZ/YwLD7odoagluFjGMVIDFiYXyPOK5iHUneRjvp+ELimTdPkneKq7otYL KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36hkrmy8c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CaDIK178533;
        Tue, 9 Feb 2021 12:39:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3030.oracle.com with ESMTP id 36j4pnn0cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQoQrmbIqfpvTUTNBjebcHeKkrxErMHK7ZAQ1frc/M1LcNamUz80zMiTe2kmUQiddWBm86PmSpIJdibbzN6avZfPmN84ORBhTe63mfxJUb5iLmLqKig5HpW45Jpzyt7mHi3m5wk6vDBXcnILX41q8SzWiAwtIgD0yLG+GTAwbNjpT3fK8rgXTwNvYsRlrhU/re2gGtxe1F3pAIDkiGpkFNaXk14L8ArzYB4Rcy9AgzOkaVIq4rp0q29tMmH1Yqpq1keO3Ghs3fCtwRMbrGRYXVTamaQn2mHCfBKhD9QSsAYrXfyktrJ/DIp3zubUL5B/BKOi+YaSiqgiYpj6fPk9/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+xiQn5GyXdQkBxVmYnI8zNMC01FeeMnEGS9mCrFlsI=;
 b=WIYaW0FnORRHXtQZImkd7gN/Lfy8oY6UevGBqSXcnSnOLCeuaApT8HM2P4JR+UT7W9YqVzXNj0ioOZur5j4HNFBttHAd+dFFzBYb6GIMVlToKxf1weH4AQ/uMcdC2r+Ye9nmXuFnUOS6pgKCFNvxrEiZKm3zkyS7PR5RUuNGCJvh+e1BhVKIKNi46oAPKjQQG3qFbTpKHGQdha5NTf0Kf1iwYmZW3BWUmppM0sax4T8gkMtK7NMt1t9u+u5L01g5MKTGFQebiRdL73CXFWdFuV+1VM01GGI0Wr913XhYqBv/jesNclxUUkPYNYFP8SOXplnv9PnQKfQC/1rF4AoRKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+xiQn5GyXdQkBxVmYnI8zNMC01FeeMnEGS9mCrFlsI=;
 b=cjBi7/qjSHB471ZHvJiSEtvYtrhu3ocv5XfxkA5p+xySZWU4z4crLjiE8BLQ7t5tLmpYrBQ8LAPH51Y7U8ORr9tx42d/Ec87d2z8qm8VrBAoDWkYfNddUf5JNVZ01fq5bVbb7YMo7ivMFVXv12zK0GagmtJmmM0PFO/B19IwbUs=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:38:59 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:38:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/13] vhost scsi: use lio wq cmd submission helper
Date:   Tue,  9 Feb 2021 06:38:36 -0600
Message-Id: <20210209123845.4856-5-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:38:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c746f92-72c5-4ad0-e89f-08d8ccf7ac1a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB260082803CFDD044284D7495F18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: myEZXt4oc2Y0kFe7u2v8Dsn4foE+L5lhJTnHepPnk/9b1+u2Op4PfzsvYA13xYvrGi4tfn8STFJcQGg03PHZk/OTEwOenmzxgaKQzCbod4X7yphsTtULNaVmjTigyRrXMbU3HBjSsScJUqrC+qKP/BvI7kxq4JJyHbNLv/OSS/9oh/OOuEfELlZt2rJWG8Eos0EISHonnZMVudEOEm7HtLAFIFWPDooRRZm9Bf6RwKLTs1c+SKx3V0DRMZUUe2LeRGiF071c7/d+LKmT5RcPXasLjkZ3ao1TysGBv0zS7rDFKqBD9vzCAn7USbpDZOkYboYDILuYfDsb2+BGz+WLCInCmg95p9z7Un5dGC3h7V/kAZJ0DeX4IZa8XwBYyuWBbvmq39aNoQdcM44EmuTUoys4gAEK8hcs4ojNifmCrNWXGtUu7joCtxM8/W5vhV45K+pdJzZrLCXN8/bdKA8EkHXppBTxojRGKKvIjApkjYzz35pLhR4n9kny/xowCkvds/4j43b+Duv2Ta1G1mtirnqdFFfInZ7hiJGnbSQfNaZtI+mgfuu0VZvOQtynqnwOEyZoK/Pz42ma38G87CQ5hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(4326008)(6666004)(107886003)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?luXGpZeQ9CHR7Nif3aD0tv+VuhNgsRCR0+MwltmY2TC4+uEelnxhEuQDqg6U?=
 =?us-ascii?Q?lPelFHvNgPpR3U7PRVv4ijr5O0reJMznXF1K19ahfCFcB+ByOKKrFhB62vwK?=
 =?us-ascii?Q?4fohEp084wxyaZ+cjsKv2bvXGy8Y+SzIzeeS9i+7DGjJyjYw3G5UN4z9SJNV?=
 =?us-ascii?Q?BMmCfC3O81/ls4m+mxhdy5q/F5enlP6NkLdb06jYMPuG+yrubFkcAoo44fVy?=
 =?us-ascii?Q?/Svjd/LvJjCkk31xdiPpgkl79ikl2oCpv7m1YavqEkN9OAx75y3gXqUfCQ3m?=
 =?us-ascii?Q?zjDY5K0hbyKDmm0zOsex5vB69d6W5zXMvvz1+Gw0EIwNyTMkb08P1oAEZxp0?=
 =?us-ascii?Q?NV0/4GvqpaItMYVYzxjbk7xx5iFxmXBUjAr9cC3UNARlBTQWzKk2IUEZCWVq?=
 =?us-ascii?Q?bdl/+9dNTc/0TyO36Zp2Jm1UD5AKfCZ5unXo2K8F1wQo8b1FZrn3HpmHuBDA?=
 =?us-ascii?Q?TOdo/nZcTJ0zV3UsawtlcRAHRAcYfQ1P5hn+5/dlYgFTZwrf5aZSLLdHgw4S?=
 =?us-ascii?Q?UnRbE70mdtOCfqQz3F2Yh3L/qLJ2NalZtyy62yBR66w/8kbx/ntEC+zzjIgB?=
 =?us-ascii?Q?lgfbJ9RXQYPnvybskxWb2aE6i0pwUxRh6uMy7KtE3Vfci0RO1tGyNGEET1+g?=
 =?us-ascii?Q?3I96g9Eo32pl31Jya23Td4hHfqVPuhmeYZpEBcZt0sJEN+31b/qaHku2Ep8E?=
 =?us-ascii?Q?4XHuret5eTHXL3qlnm6dEKI/DdHjhUf1+oVJA7Sohx0x5YF2GdnnJfOKYLra?=
 =?us-ascii?Q?CmM+vesp1HNqBToSOodE7WOZyDwK0cQuas0HXyX1lcjhWpGqsLkSjVsdbg0U?=
 =?us-ascii?Q?d0DRB853utT9tnSciURvp1fx5xjW91UFoXqN+PFQLeGrGDk3+W54pvAMe6VE?=
 =?us-ascii?Q?F0pNgWT2fkxV76/nLcjVkKHHOpwOvQtJ13UOih5FJIGw09k1bBv+1h2VlLcc?=
 =?us-ascii?Q?dFq6PqCpjFXvKNA4z05JbNzlq09BamJ9nfQ7W1CY5G2xWaNa+jGyg9B7lvTz?=
 =?us-ascii?Q?Ppj5Nex859T359Y7i2jJIQNS7TT2I+VzqNscKNSTR57XojFAUtLlyepMi2Us?=
 =?us-ascii?Q?i3GqIfQj0gx2n66oYJkPijA58i9la2onZJ/l5q5yiPKVti5AXx03WtHPsR0w?=
 =?us-ascii?Q?8pANaJLvRZctaceCKChs+Asr+Gvic9ZWQy/aiNCv4kEsbh2/VX1twnONGjw1?=
 =?us-ascii?Q?A63Nq4OJmhbRxvKR7RiScjIM9ed6aAdy/fU28bTk74a4KK1Rl+Mgu23RzDbf?=
 =?us-ascii?Q?qN6YMe+HF3bfhDxbh+smlz0Dqaa+XxTq+CiMtQxYxRT1Z+BF+pL6G2qNGC+Q?=
 =?us-ascii?Q?6mPWm4fP6UBiu470ArNnRmqp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c746f92-72c5-4ad0-e89f-08d8ccf7ac1a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:38:59.1896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vgYbfa6PEx+HgdbLGEnHpcpMnbhT0s4D8J8HAAfrzWOZM2doEPg+MJuw3oXH37EPnXk9xjBkwi1TI+5W74kudhlw/+sasDUVrxWdkW/Mz5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
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

