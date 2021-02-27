Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E67C4332D
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1698764E84
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhB0RKt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:10:49 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49102 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhB0REG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:04:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGxMMA178300;
        Sat, 27 Feb 2021 17:00:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=itSJG6yjR1UHZhPl78ExO6tKSVBINoJd8hEnckxtsAo=;
 b=XTvQJBOCUIaUsKyGalG/LQ0inF71AkHDIYPGCFuNMF+VU00j4z+R6Q+j9lZR/0uK9xdW
 M0QQLvp8IeamdhN4hS28DFabcGhfnSetJfWu44FblmSdYsecpYw68ITyMQ/aUBDu07Zw
 52VnMVbiHou9GQ14zgjnbgBOffexcSP/S9qm2B+u/oivVJrJNGoumcCS+Rrz5Gw37gS3
 LsrIuuZAmcKJp6VXSs/FfNBbIZ5WHaDYpbzmiS93cHfdhb4Z+LZ5aeBbZh5L/usAURWb
 HYHMZC8f+1zf+dWc3uQg2ft5bqcyD6cLPl2zcMBwCIng6dcVMTfXD8eHVYyl09vXe6RS MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36yeqmrpta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0MBO173116;
        Sat, 27 Feb 2021 17:00:33 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by userp3020.oracle.com with ESMTP id 36yddhy8rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XN049TZupGvms0XYSEUc+82JHDzEJqCON3Od+IT8gWkNTBKI2bKZeBXijVDbcK11+FQp/TRG9w9HhXJOzsVQD1CkkDjsk/qDd6v/XZqUYAksaIvudN0WIjUBG4SNutHXVbMbs/p4u+kKNGbRZAFOcqyyUd1lKUOoyS96J/snESN2LjyFSYgXqPdUmcSKDx97Tc0sp5+vQogZV4ObFBsNIAYe01j18dhFASA2V1b/woHzo5zCv4bkC8zmKSR4WPuEzHzglFLSD1pTLtLZkPKLbwoKRpML5WaTMGyo4bZOZ+pkfMlHja0MzIUgGXGLBzckXIgZrjAJ0lTWZXc/GdOiRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itSJG6yjR1UHZhPl78ExO6tKSVBINoJd8hEnckxtsAo=;
 b=h0Pc+f1No9rY2ZYd+g2YvGFOgrPUcaX3j41hNSsD3myqjH1fds/Gkl8XY5WD0z2yOHgWrWT0+NTa22QNwvVmYF6n7c4g7oug3l/yXyLDMZ2vkB/nK+jsdvvp8C9MqB4UTM5AWybUIEoP+nFzRn5SbJGZk5/r0fGcKZ/fR/X1ANgBmbPKW7SjFJ/2NYPZXOTZ8xGT6PCUnhYvA4I9QAOSH1fUdM3xJV58bHJayde3B5aNJNceFS2QUlkSfzZtvSCIOQ6PuUtZGzcYIBlI9POSZOV6lxctVbDC5F/aii6rXpE/SyLhiZHaH+UMZc56b5unLiKvHG1rAHHivORt5/g9Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itSJG6yjR1UHZhPl78ExO6tKSVBINoJd8hEnckxtsAo=;
 b=ewf8IN31nl2LgtfueOKbG5t2CvCmEGthghjwrwosRgA7YXgeT5J+X1jd0WL2Sq0GaT6+6zPn14Z08cq6KjEQ3IoMf6wl6LN69X47Y1fq30S7fbPFGVAln3KRdujo7wINhBzMeZlEqtQ/I1tMhi0oXnfX9ycB9hXnWRH6SH1CsAM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:30 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 17/25] vhost scsi: use lio wq cmd submission helper
Date:   Sat, 27 Feb 2021 10:59:58 -0600
Message-Id: <20210227170006.5077-18-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 979a728a-eada-4302-23fb-08d8db413050
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3499692F6CFA53704B7E481EF19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OGe0DcZ45wYle6oZNpuOs+1OSkmiQGxqvEVBJ7UVEsZk0zGb04oVY0l3+ZGcOiWr21icT9RLTU3gZrClDt3ujvqIs+Ue+L93KUWePn93fL2/c8q3HSDKBBXJI2sRrHc92Lvg4xTMWRh6ntQ5kuUo0ZpYMv/Hjf/5n6ZjNDXZQZvjUKalC4pLFnHSabz2NuVIsIJt9z0pX8B9rAtESRbRJiJwvJ7l0Usp7HtIwmgDjZEOKNcIYdRHYI5KXmGrppmCskVL2BI9n1oOKXlx/5/mrCtujNxgapTDJFIKEcj1Hcv/eK1lpFMXyIwzi/gZ87BySe3LRCKZMQzWYKOwKKLDLcwUW6LOJISIjQnuS6XTIBANchEYTBkPyYKCrUj8T5OewjO9ZKzx+2UVy/XfYD/ehnB/KJXy3jIglLgMSW8RGlNtFtm6foAXwzAObaBGkvOVwwqW925K4uhZOnMWokYnCFIenYaLE5zQMcoIuBQpTERfzO1EkDyydKX33F7Q7h1G/NNP1rciXXp5+ti0eJNFa5y2ISpnKczTxwcS1u04tVj/4e0gylTpCamNRbGsm/42IIt6YancuLsyrhXQ1z7LWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QhqDRXcMQT+u+OX0vnbRUXO+4vpR2c2V4id2mz5JrvU+BWGHn2YoGA26UCcr?=
 =?us-ascii?Q?5iJBmzm3DXjQQSiX0YNjeZB7gJOxu8PlqGGEMEzNgR3hypnPpFsh2I4aPm/R?=
 =?us-ascii?Q?kFkMmzWse5t6mdHhRy0uEs3TGLJV5bUeS3DoCP6E0fBG/1srPcYq/fQ7Ivmu?=
 =?us-ascii?Q?ZOsjqM9kpU5aPLSuXorird39MYRmeny/QhoZkkfqn7hYHD75gUZbIKVfkbh2?=
 =?us-ascii?Q?LiA+4F5HtEZUi4UQdKmmOIzcJUHM0ncM1/36DP+4XMcgJ7mCtrHVd8PlsZhX?=
 =?us-ascii?Q?XptPCl7wEjZKWcGRUzMgk1CNVU5xuEARZj6tmalf0LD0BxpfkATt3cWdby1i?=
 =?us-ascii?Q?Ed2IjKUnvQSx1+qTU/1ajECbwvJQiEvtsFhT4CSYsu0J7tHl7fHFUaWl0blK?=
 =?us-ascii?Q?eINC9wiGGWQHFILv+QEXjZnu01aGAV07X5RFDAjkwtXLgXgh746pCqbE+sKs?=
 =?us-ascii?Q?Hkz+yhZ87NZlfogCJ74L2KMwYga6feaixlSoTfLPdP1tTI7YGOdDn9OWtQVe?=
 =?us-ascii?Q?T0orEm3jqPRVbey2SeebxlDkN58eFSM9zh6uoxrhCTUhG3PQFDoDCd2eomTI?=
 =?us-ascii?Q?HhqUU53NLO6RhuEJ54jKPv3C7fTvNSkaQNQCs8BjZ7I79BRFVwSnFmZwhDqM?=
 =?us-ascii?Q?TD7M+dA4j7wGvv12pnvqYtvZanByx6b+Tz9raI3J16kn4ACxCXQvkizJ8r6H?=
 =?us-ascii?Q?oN0SsfN46FmmMSx5Lrn32XNSKz5jWLoSDfylgQifH05DmE1+TcOTZNbOhXL/?=
 =?us-ascii?Q?UzSbazO8PTlPqNRIGYAEIwQOh0Lb3W0hHBvxHL9QEhfaakh30ZvrSFjsW3Lu?=
 =?us-ascii?Q?Y/Ihx3eYaSjgwoBKl7NZORUX8LjMq4PBya9IWARoxrzY5x62W5wSTngbk68M?=
 =?us-ascii?Q?F1KAowoHgPlBxvzZ8wSEG3UfxuRFjbAqiorB6NqbE7D2cJ9cg95iPPAI8qwQ?=
 =?us-ascii?Q?mlbMV2Lv8liRDOwfBBih7n6FvbCekTClFBT+7HatUxO3/jDUgqhHPCMXoG5d?=
 =?us-ascii?Q?A2LxokvLZnSJCaij+KNHf8MEY+lPn3+x8noYKXHXvOVZ1UqJ1QH2ADLpiceg?=
 =?us-ascii?Q?IxxRdt8Hz3Wseb8d+rxerrsxZeG3XTXgGRvlnoSXoFnaUm7LMwkWcZB0HDMn?=
 =?us-ascii?Q?Ik+DohJimVWoJ6OZQ1irCG1/rNUmzl2skJtUsUdYm34mSBQYU9D6JJq/bQSF?=
 =?us-ascii?Q?2l6Eq4rC5UjgE8d/LGS3iXBs7+SZ2TJqxBT0jA+krrioFK7375XBJgu7opMa?=
 =?us-ascii?Q?UX9lqyUgEIERD/YXwo6HUrZTB/9FMwN1hg4yiyX059HR/ynkG+/Pnkc+N43L?=
 =?us-ascii?Q?GjYfqA0rOmhukK0RKPj9UdjC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 979a728a-eada-4302-23fb-08d8db413050
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:30.4619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EhCHarP+LzX/OI6liY9UCFNY9t3iiI47UoOZUk/uMf3OeniwFoaJdBamVSbGacrtPUJs2B5+FoBnm7wgWrOvL/w4sHhdzmw9HROFYP0kODY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
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

Convert vhost-scsi to use the lio wq cmd submission helper.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
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

