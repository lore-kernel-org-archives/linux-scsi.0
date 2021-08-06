Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329AEC432BE
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14958611C6
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbhHFEA4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 00:00:56 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14104 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235416AbhHFEAx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 00:00:53 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1763tejO004705;
        Fri, 6 Aug 2021 04:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=EHxbfiXOr8AmuXUao0jGUJigZ9wMFu5N24G/8uV6XxI=;
 b=OqUOAAI+tTM5ujh5kyfiKTedwq28u80vO+VDU0rWCKKcT21jtl8zaJ4X7enCFMRcN/7S
 QUtM0vCKS0xmr+TX0ueXfZc74UltshDtS+LO7hAIKRUn//UgcwNkY9AeY8aJBJ+o9uYG
 9zTMBbrzoUdbQ9+0+UWjdFeMfNSyJjkgqhb3sN/3bQ0WFy3fopr1ERhrX3XDDEGPCU+O
 tqWA/hGq0KtKwp96ZxTMIOgWpdhEMjJXvi+SXH9NHeofxnKBSw4I0hnA5rzphiJZtvCv
 ooWqbAzxJjTMTBhk2oLNfFeeHGhFuWgyW9fsRISHmIYLK+a70/5NOjKrHdWz+ia4OHpB 7Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=EHxbfiXOr8AmuXUao0jGUJigZ9wMFu5N24G/8uV6XxI=;
 b=dnObSKsFmtxpZMBkrgmxQOxrFGf1Vcv9DgEnqzDKKpIOCE188ilS8lWelV78aoMBEl1h
 QxDJ8tOXQaULGetMf+jxppy9hoBdFxsvI/PbbHce0I6Ztgpl8Ul19chXWzQSpM0HhfG+
 EKq5WwBTJS7R+GhK3luZC8Q9Rxfu4Y99a2c7U9hJsxiTdhc1yz3Q5jg9r4Z938vi67Z0
 2DHQw3MLEsBenfj5Db8KsU8UeaR1wdsacIkn9WVg6ZEy0rgfnsv+B0MNq/Bv9cS1pA9y
 pbNcHzbzh1JwzImL1RSK9ncXyQo1Nvkrk0WF7xpa2jepsv0DS0MbjJs8Ofq/va9WRk0y sQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a8p6rgmb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 04:00:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1763thsX153451;
        Fri, 6 Aug 2021 04:00:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3030.oracle.com with ESMTP id 3a4un511hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 04:00:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naQ2q+dJKp2pgfGMT1RlxhuR6n2Q6MNDmPtQvXfQZODTWCfZkLHjkyKsYXDXEdMhVJkBk+ho5l2HX4YwTB2jETVxEZ22X1/QmzE9IUzm2Z7n1JVhpR6ZRzo28Uf1IlQLbOsPOFsHqqPDFsW2gxSrl42yG8oUur271Sa6WES5j2CmWNaFa61u90WgAw3pzEJkoMR6HTUJf/D7t+zswfda0nDhu1ztLq1dWXOPT7en9qYeTB8yEdE//re+09EhErMfi3keqgctpWGyySLgMH/dN2taH4RA3EV+x+X0Enu+N9rObiWc03RO8MA0JLOrvOmhW2F16puih+uJadDXf+U4Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHxbfiXOr8AmuXUao0jGUJigZ9wMFu5N24G/8uV6XxI=;
 b=FNzxZCY8+ksJD+oiEMyX+v8F5h9qjAR20lKJxxCQixx7Niv5dMvk9w31Z64yO8WxsRtop7N4T93q79UVFWmtZbJ4maTZDWXsuJcbCbOxcgwH6hKwF1/TfsykfuVw4b5aJoHd7DBnbZcj6EqhAJ4HHu8wSHayC6eHdvHQe9i/l/2zIM8YAwzAuC7FC5B1f5YUhGwTqt5j4FrfST+NoAT1W8PXJckZ8Z96eayp6frOb7NmFOa/eI5xDspEIrzGA+1zLhrGJ2GNQ4jWFL0DsNGl/uPpg/dL4u45TqRu6zqEreUOS28ixLeJ50EEbvm2yBiZ53ozGAxyBWie1mOvGrXgSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHxbfiXOr8AmuXUao0jGUJigZ9wMFu5N24G/8uV6XxI=;
 b=ChAdOm/9wIbJa90CVw3MyIj/MV1mrrQgTkohSQw4W1iBhE/Se0FpUIGBCPTCS7LGNzkCI4Qp1zLHk95r+wLyCrDJKeGaRoOVedPsmLQRTEyVryEfxNjx+zPJeuwUZBar2txYsA8xLKoO8PI6FRIwFQu5iIfpF2ETLUUShWeJOBc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 6 Aug
 2021 04:00:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 04:00:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH v2 3/5] scsi: mpi3mr: Use the proper SCSI midlayer interfaces for PI
Date:   Fri,  6 Aug 2021 00:00:21 -0400
Message-Id: <20210806040023.5355-4-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806040023.5355-1-martin.petersen@oracle.com>
References: <20210806040023.5355-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0007.namprd06.prod.outlook.com
 (2603:10b6:803:2f::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0601CA0007.namprd06.prod.outlook.com (2603:10b6:803:2f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 04:00:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e5cf2a3-a682-4812-db42-08d9588ebd03
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55159DABF5129E26661498E98EF39@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IeBC1gxlWWlX/+UqP+L8c4LKX80YpUx1L4dT9tmCNIsWFcfMnLtDL1pyMip23XCb97kW9WCwKBIAjDcQB5VSpnC8ShbbW1Ph1iiCOy6iU3+dddfFD9E72dW2Hjo/NxUqIuACnAJq/I0pxK+2SxMvL1xf36VDHm418kp5pvEmR2Xc4M2CY8PYbO85VYORYuoNZMgjrAj6t5eilsbIIXSfDRXAkaYIOvBGmCmvxfVtkoGwKErUE2XCu04GTTq+eAS3+3dFWWVW5F2rqTXd8uQ9LFUImK/VZj/rLUXh8x4B/M0GoVYNJHLVOhk6GZW4xJ/875YPTepAeAOvbIQdOpalrkGRTC1ZJX8dyLbTZ4zJAVtFXfZUfLb4tI/FuQPjPH3BX1z1yLSHTLwmsTfJEvKQ7FQ+v0W/iAmtn53DFYtyBgz0fQPyh6TSqKoxZWfJ5SbAYcAIrxOOJswIq2YJp9CjicoimAPXgbE359rJbBoVuD3lvlbgbEWxjDvJI3BlI1ExtfBxpuRB01Nspy6lKxVaIM6JlMH5Bqwy9MDQHGJnD05tnQq1ju4JbP7YGtZGxAhjOBdboMaxQkBgmYfpL+ocekMrHRYcZXV87tno4MUcR3YTDK3eMWG1Rf9/eDeWZ8xetsNHAUyPR8ZVovbd4HFOjz7WXzewC8deKATFSAMH7YvqTTOFwmCaKme74DeKs3cmWN7sIm3pL0lgqtqgvmGTBaZ7K2EwWP1lrlCTNoQeiZ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(1076003)(8936002)(66946007)(8676002)(186003)(6916009)(4326008)(66476007)(66556008)(26005)(6666004)(83380400001)(38100700002)(508600001)(956004)(316002)(2616005)(36756003)(38350700002)(2906002)(54906003)(7696005)(6486002)(52116002)(5660300002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IKX9g/UUgu1M/YhzQMT36up9hGBrE2CWAptkqTFjbCm2HnKlj0wCnNESJg1G?=
 =?us-ascii?Q?IDP4pvHkEmTUICEkvMTEcbu+o/WtybKwRTHt9luc9txsAof+MsivgVnw/rLL?=
 =?us-ascii?Q?/d49mSMjdyPLSufdwORdQ3qg+FJNoi3EhBVBqdzSczWvvOFwvrWOdvbH1G3O?=
 =?us-ascii?Q?mykGON/efirOHe8g/x+o4Tu2uZz77RJa3WAS3RSbh1JSsTwAeBmHrThlHnh2?=
 =?us-ascii?Q?5/ZzVNPU3Ex8anE8ADJwvBGYoFQJpkjRys7twXIYKh+ZKdpO7Hwp2yDuzPtY?=
 =?us-ascii?Q?lUC82knvn2jPlFZo+ylAttA9pqY+X+u0SqVDRiARuUkQnio7nUKA7ZSFFiTA?=
 =?us-ascii?Q?DeWxLkRTTdOYIOdeO/0d/i4E1l8eoo2fvWPtKhZB4sb/vnt2y/LmblGJEDJn?=
 =?us-ascii?Q?fnAfk5v92v1+qxiGBjgdFx3qb2+UmuKMTx4oO2++BBs+TNHQGvbdyqlWJvHn?=
 =?us-ascii?Q?SNUd64O/BMPCx389QORTCB6ycjPYIoaGyQ/e30VSoVpVHxJ/mpVDECKnbbUm?=
 =?us-ascii?Q?qGG+n1jD33JHCh2VGo1Dy1N9GfMEZF1JSG3xFRCZeBPpC8O7HZPqR+HkZcks?=
 =?us-ascii?Q?w0rtN4Suapl/3ap86JaOodc98IypqDKSU8Ez3YlPg/s0CXnkb+qZDwO90BDg?=
 =?us-ascii?Q?8FvXfytByWwE1wRdtvStjy4D41V+dImhBa9SlRht4IVMRr2jOyytX2IMcEsh?=
 =?us-ascii?Q?TfU6GCW/HhM/Xk06RDRe5q74EwttseVEoelUbXU8e7ojQ5WC64gFrKJNUc2y?=
 =?us-ascii?Q?OLojh1sseGh+evEDTmkgZ1wIA3q4+0VcnRpIPCSf/7o0APaNT9gX31QO8WMu?=
 =?us-ascii?Q?hJzbiQqh6GxWcjYNqsmpg0TT8bb2OJ/OnkkqwST4iJLilEzMAokek2JyTA5U?=
 =?us-ascii?Q?16IoxRCIjULPxG09iCSfL3vBmZeYehGIjSDTt63Vzer7XqiE1gB0nn1pRJum?=
 =?us-ascii?Q?tzoWFQzslhm0DWUBK4UUicrdb7VjW6RUvVdfWW+uMsx08SwL84ktq8tKxRFs?=
 =?us-ascii?Q?yT/Acg+BgKWFK6BNZaESjoA4TfakD5h34jFbYdbJPIu7Zg35dRogGbyiNyrY?=
 =?us-ascii?Q?wi94xC/LHSl0Hph7cKzqul7ihpGsQz4QovEBmRe1Td5P1PKyBtKDBLXOBnXn?=
 =?us-ascii?Q?O0lvzdPkwoQfnxYfpRZBY7Y/DaTOgn6gSdDS4RWKWxbH/rAvzBe4CmiPy++6?=
 =?us-ascii?Q?wB3msq9DZgTRYVRJtx7Ay4xd9TeZXmizLFrAW3eW2h3Dpyc65gaFVFOhmuH2?=
 =?us-ascii?Q?K87r4bjN8eJhRjtQb4bW31z5W2pWmKzl0BPwNTfbvlYA76efc6YE+wX8jiwg?=
 =?us-ascii?Q?pcFuGCPmu7TRZlgFZYmoTXR6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e5cf2a3-a682-4812-db42-08d9588ebd03
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 04:00:33.0906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uzJF7yjjxql7CGynEsdGXcABNmaoM831Rn/0bvrhEKKny/L0NEuIkZgn6XGN8RZjq7Nt3Rd9lll+FEeVQEQ0tggNUjpvbePT/eeumE5p6LA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060024
X-Proofpoint-ORIG-GUID: rD5yl_LYfwz0OuwozvqlpUTUBElRjVYf
X-Proofpoint-GUID: rD5yl_LYfwz0OuwozvqlpUTUBElRjVYf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the SCSI midlayer interfaces to query protection interval, reference
tag, and per-command DIX flags

Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 59 +++++++++++----------------------
 1 file changed, 20 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 24ac7ddec749..3df5507c4768 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1963,7 +1963,6 @@ static void mpi3mr_setup_eedp(struct mpi3mr_ioc *mrioc,
 {
 	u16 eedp_flags = 0;
 	unsigned char prot_op = scsi_get_prot_op(scmd);
-	unsigned char prot_type = scsi_get_prot_type(scmd);
 
 	switch (prot_op) {
 	case SCSI_PROT_NORMAL:
@@ -1983,60 +1982,42 @@ static void mpi3mr_setup_eedp(struct mpi3mr_ioc *mrioc,
 		scsiio_req->msg_flags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
 		break;
 	case SCSI_PROT_READ_PASS:
-		eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK |
-		    MPI3_EEDPFLAGS_CHK_REF_TAG | MPI3_EEDPFLAGS_CHK_APP_TAG |
-		    MPI3_EEDPFLAGS_CHK_GUARD;
+		eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK;
 		scsiio_req->msg_flags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
 		break;
 	case SCSI_PROT_WRITE_PASS:
-		if (scsi_host_get_guard(scmd->device->host)
-		    & SHOST_DIX_GUARD_IP) {
-			eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK_REGEN |
-			    MPI3_EEDPFLAGS_CHK_APP_TAG |
-			    MPI3_EEDPFLAGS_CHK_GUARD |
-			    MPI3_EEDPFLAGS_INCR_PRI_REF_TAG;
+		if (scmd->prot_flags & SCSI_PROT_IP_CHECKSUM) {
+			eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK_REGEN;
 			scsiio_req->sgl[0].eedp.application_tag_translation_mask =
 			    0xffff;
-		} else {
-			eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK |
-			    MPI3_EEDPFLAGS_CHK_REF_TAG |
-			    MPI3_EEDPFLAGS_CHK_APP_TAG |
-			    MPI3_EEDPFLAGS_CHK_GUARD;
-		}
+		} else
+			eedp_flags = MPI3_EEDPFLAGS_EEDP_OP_CHECK;
+
 		scsiio_req->msg_flags |= MPI3_SCSIIO_MSGFLAGS_METASGL_VALID;
 		break;
 	default:
 		return;
 	}
 
-	if (scsi_host_get_guard(scmd->device->host) & SHOST_DIX_GUARD_IP)
+	if (scmd->prot_flags & SCSI_PROT_GUARD_CHECK)
+		eedp_flags |= MPI3_EEDPFLAGS_CHK_GUARD;
+
+	if (scmd->prot_flags & SCSI_PROT_IP_CHECKSUM)
 		eedp_flags |= MPI3_EEDPFLAGS_HOST_GUARD_IP_CHKSUM;
 
-	switch (prot_type) {
-	case SCSI_PROT_DIF_TYPE0:
-		eedp_flags |= MPI3_EEDPFLAGS_INCR_PRI_REF_TAG;
+	if (scmd->prot_flags & SCSI_PROT_REF_CHECK) {
+		eedp_flags |= MPI3_EEDPFLAGS_CHK_REF_TAG |
+			MPI3_EEDPFLAGS_INCR_PRI_REF_TAG;
 		scsiio_req->cdb.eedp32.primary_reference_tag =
-		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
-		break;
-	case SCSI_PROT_DIF_TYPE1:
-	case SCSI_PROT_DIF_TYPE2:
-		eedp_flags |= MPI3_EEDPFLAGS_INCR_PRI_REF_TAG |
-		    MPI3_EEDPFLAGS_ESC_MODE_APPTAG_DISABLE |
-		    MPI3_EEDPFLAGS_CHK_GUARD;
-		scsiio_req->cdb.eedp32.primary_reference_tag =
-		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
-		break;
-	case SCSI_PROT_DIF_TYPE3:
-		eedp_flags |= MPI3_EEDPFLAGS_CHK_GUARD |
-		    MPI3_EEDPFLAGS_ESC_MODE_APPTAG_DISABLE;
-		break;
-
-	default:
-		scsiio_req->msg_flags &= ~(MPI3_SCSIIO_MSGFLAGS_METASGL_VALID);
-		return;
+			cpu_to_be32(scsi_prot_ref_tag(scmd));
 	}
 
-	switch (scmd->device->sector_size) {
+	if (scmd->prot_flags & SCSI_PROT_REF_INCREMENT)
+		eedp_flags |= MPI3_EEDPFLAGS_INCR_PRI_REF_TAG;
+
+	eedp_flags |= MPI3_EEDPFLAGS_ESC_MODE_APPTAG_DISABLE;
+
+	switch (scsi_prot_interval(scmd)) {
 	case 512:
 		scsiio_req->sgl[0].eedp.user_data_size = MPI3_EEDP_UDS_512;
 		break;
-- 
2.32.0

