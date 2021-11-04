Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501CAC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31D5761157
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbhKDTH5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:07:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20074 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234108AbhKDTHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 15:07:55 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IWMnf027065;
        Thu, 4 Nov 2021 19:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=qSY05G+VH6XojMvrb20ZXD1g2hwA5+AKsJUy8o8qBuY=;
 b=CkAHeV/0Trqh1OKufI0Cn7WfLfuEjVYXAv7IlcYEJwDZCZD1/OKdmsKiuzm175ckeDHn
 ErsP3DixkSfZQj9qtVsZ9SGmJ365wIAmhnrgJVFSM7z9zZXRjXQ/Em5yY5gehMPGjuXm
 k+DCkyk3bvMtvMWaCwMOH+jot6v5xsY4mCtHikFKDoAVlzY5CA1o+OynF8sv/aQvbm6t
 vFVwbj0zTOVUbLDQ80ya1+K/sYlnyNlbDO5cdsVxQK+PP+EeOsLIhW9g8NPB8rjxZlim
 EQ2alooh6woJpO9ZK1YILAr4u9OSgEbtfAZO8bu20fK31FOa28lP622n1rSm//9ooVKu dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mxham4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4J0PId122897;
        Thu, 4 Nov 2021 19:05:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 3c1khxpeas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjNMxZ6NacVNQkA+JIQgiZ/g3YaPaykaRiDGGC9r6C5zIJmDRmPxePe49G89AsOXOGYoMhgiKnLHrPxYZ6f2GtRKNQn7GSPUIqMuc1AsESjOM6Qjq6q+rTCa/GDAtsbcp09UgPKBS917Uqqiy6wVNNb/zn0b93mdh5KN6yNykLltLx/111krLr5og2/i8fwZINEVv1UIgF2zCPM6oWhaSUNSytAm+t3q0hEXW+tVTROQST1b5aKddwL3fzuHt3nYAOGYDdjuFO8l3vIiB1vb8Fpjc3aWKR5diSA3LhOYBe0z7WjGoXGyFFxpa/E56fBCZ7YafYeMBymDxJCJPolfjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSY05G+VH6XojMvrb20ZXD1g2hwA5+AKsJUy8o8qBuY=;
 b=VgE66nfYjsFqHFAO9FXINrrzM+dFyoQN3XpF6EIoDRSGOwdDh3YjCFqV8ZKwWFZIOzHOeg70BTLYbwxvgfPivjv3Akc+tN5PksRJHEN+jnMkzAC/a2uAZEl48REISZKS6hm1CVcgGSjVAWUiydEwKwwdz0IgCDvRXd+kScV2HSOVtkourvNJYstBhEhg/xTAZnTnXR3btYwSuMYNN9Iqkza27UpjVsOoLcJt7c19CXvBpZQkvuisQcIyYRW50eRr6QLiuzojoL+acIDMMMZwnCG0DfiaxGy3bmagDgjD/7AwklRJVbGHpJp+zQ0rx3HKMBb6TJUMIrAX2691WTQYOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSY05G+VH6XojMvrb20ZXD1g2hwA5+AKsJUy8o8qBuY=;
 b=jLkiUi+3FXKwO1nI0a3qn5Ij0lgtpBonsad+M+n4C7iG+OJR+A8FYYUik9sSugnlyUiHs97Khp6RGaCyaStW3XN6uJBMFyDPhPXwsHsr1MYlaM7d3Fvq90CTKEqmtsLhmlnRa1B2moDOSkipCUJIsC+ihkHc7lZmgsy+1ojNbYo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2873.namprd10.prod.outlook.com (2603:10b6:5:63::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Thu, 4 Nov 2021 19:05:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 19:05:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V4 02/12] vhost, vhost-net: add helper to check if vq has work
Date:   Thu,  4 Nov 2021 14:04:52 -0500
Message-Id: <20211104190502.7053-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211104190502.7053-1-michael.christie@oracle.com>
References: <20211104190502.7053-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:4:ad::45) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0080.namprd07.prod.outlook.com (2603:10b6:4:ad::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 19:05:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0185c8d7-8c02-4bd7-fc5e-08d99fc6063e
X-MS-TrafficTypeDiagnostic: DM6PR10MB2873:
X-Microsoft-Antispam-PRVS: <DM6PR10MB287379468A71430D5843E970F18D9@DM6PR10MB2873.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dn94I9GdhfM4nX2k+4Axg1EZQeuOYLnP9A7jPhW127PqBjnO9eRo+bsWhN0cXnV8uUNXNs4RdBHsNrK3EEC8E7aWFXiK+L4LYRyb9VOmoJZ0q89NhJjl81s9sAaG/zqGiUCbOVf93nikw8W5QiSdWQsVtJH8RtIBb8q3iPl0S1PMboHC2rH7bRAEKayhvW+mrf8y/WjM4IamzvI9/1LmxwwTF2j8D3aRueHhHDTMXyzOHzljWTDCyKcInH3nXIbqm9EfiL7KvX3RkIqQkwT3WntceOFNsl/WQG14Py1z5I6Pwzyo0RsgANl5D5fwzqK6zhqaq+KB50NixRq3XsqX1SbqM3t2NmKp8mOMOHnhk03zbgtJAHv2GzEUfFZcJ+yY8QBWq2kplqwqfIUXODyjfBjPbUdaJIbKVEqRJL4EF8hKKWvGckfUU2T6brJ7ZxpQMkyLQlO1SUrWZ8G7/omy7JSJTWRDVEwbaIEyth6BXIfL22HZ5F5uD9tjgTEsZL5dYcC/VcoD/aoopUv5MnLQEKBwXQyot5drGGh6MDbOGGyu2hH0ZrcPqS0YchPFTETTolqYErNqKdsX1UV5t6gGq7JyufphO21VCfhKiYbeLEg4Js1NjmprYszAFzeZ8e/dUMQwBs7t2tjGcHykpjPYLlzpSN8LkQH2vEvgNIi7Z3EXdVl1ribsPJYaicl3ujfQm7Kej/hRPKnraHieVgycGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(8676002)(52116002)(6512007)(66556008)(66476007)(6506007)(26005)(66946007)(38100700002)(38350700002)(4326008)(186003)(36756003)(1076003)(86362001)(8936002)(83380400001)(6666004)(316002)(508600001)(956004)(6486002)(2616005)(2906002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bQLtkYlGuWAwEN/uK5iPE30l3S0DE22FoFVoYj3ssUYXLFl/OHRniqK9veWi?=
 =?us-ascii?Q?c8+H3VoiNk+NUGjYPCg1NnKLXY6ElHA5xhLqLU6Xi0Hq2HO6+a56YUwzcVEt?=
 =?us-ascii?Q?FKLUA479DqDWtJSuAHDjJFnPRqwVrJHSjXqHAlLZymVdNZBPNpdCA8jcyepj?=
 =?us-ascii?Q?LcENauorttGYD1Nrtyt4yMrCWG8eql7EUaNIoL5tbvWBAOyArA8GhuRUqtHz?=
 =?us-ascii?Q?94pbokmsck5q7FCE03lu8eOcD+x6tuUnlW7aL6udn9/xILXc62ekHtRrJpaK?=
 =?us-ascii?Q?Qtnzk/LP2UWOYYalnT5xUOx8d+JUbMlWfEafAy2PZtxXIhw6cFc5JPy+InMd?=
 =?us-ascii?Q?Z1pRugM++aEShr+//dKp2tIAgLbd54m6XTFqKoRlgnX4I7RCysl1ZATY0CvC?=
 =?us-ascii?Q?DkenPkaue1XV7q4lJvK6KOhaQdse3y6uryn5cNhLtnJwfwsvvqU6zSoHzRg0?=
 =?us-ascii?Q?eULHOMti/Sa9C21Vib3lmU9wH4WTegPbLtt/kyU4j23RWUNn7/7uXI5CYL2S?=
 =?us-ascii?Q?vYiAoRYgopyMSk1XvKXP+gWOKj3YpsNInQSCKPeahm/Jqp3bxrxtxqO1Ai4o?=
 =?us-ascii?Q?yZRq7Vny6t2gSRMsBG4y9FTMQhEt0qX73jDtjdKXPC3h9phHmpwCZX8RlYlH?=
 =?us-ascii?Q?EUx2PgYIzNKzb4z7bWtvxLuStccB7yQpkNjNNjngSBIpIccNyIniPzWUkl4o?=
 =?us-ascii?Q?4e8nn9fuYXJfqLNzKtJJv6RPBb5OsF3crbx4RSj1oWhXFywBGc9Sg4ICS2RW?=
 =?us-ascii?Q?5ISup8DaC4It6JJ69K7wQ5INGkeWDx9TxoxzaaTThbagv9TO0FHYn2wRpbVo?=
 =?us-ascii?Q?Es2TLZJUmoPfmC6c4QjnExCzphZTQrsaPYd7YFs67oV2GdzXCTEzo9YBFxBM?=
 =?us-ascii?Q?KXQlEjEKbH7o2YUrFCBE2Tep1AXOgMzPYyEo9eY3pV3Sd45EoC+yvhRb6HRi?=
 =?us-ascii?Q?cchVSHBd2nPydrN+3gnYF0NUjOxlyNipqrqXsvRbdfmgqAmWxgWZ2L7sbwBY?=
 =?us-ascii?Q?JggftvsDG6ibB7a5hTH2uTveC0EOtsUVwcY26JkDPdweDSmJ42CaSM0WdsbM?=
 =?us-ascii?Q?pU/69Opa3odvsQSYCFUpqTkwXC/AA8kx9S9sWZ4THZmOit59MVzyTy/LgjZD?=
 =?us-ascii?Q?fHSvbBS32sTNq3ZMtW9NbnZMFnvsswqUvM6gYadlu64JhBybmrLFS0zPaClt?=
 =?us-ascii?Q?rymILcYpSQQjk0zvJQT98YUBbtfM0TkVZ2lanC9NZ9A3ntT2dXfAZL00Lw5x?=
 =?us-ascii?Q?r/3XMOh9K69ehvF3Vop3HNRI6YM+Ptcy3P/v2laMh8T1zw8ZMD2G9G9W9ukg?=
 =?us-ascii?Q?EteYwgtdY1XdAMHCSvOrCA/uKVkFLI5n8igr1r7YAuof3H+kZwEM3zFco4SG?=
 =?us-ascii?Q?8gWusQ7v0js6Pte4ZsVBgOy/lpTKD7iz03koNR58UcjPstZmU8ZxbWA0lVAx?=
 =?us-ascii?Q?z0KwXGkNOlWSLuOa6pZsInKoK9j1CNG8yJ0XgsaTco1NDEpK3EBUqNNr4GLs?=
 =?us-ascii?Q?gFFEL9A0JHOk/gpdzaZLCVhngHezyHsKRQRfQwB9FAogCxBDB3Jz6a8egqXt?=
 =?us-ascii?Q?eNQ5n6CPuJQvnCntlX2BqM5GySkxg3dv7a+8oYmQ+YRFq5DRmZA1Uif50eTq?=
 =?us-ascii?Q?O2AMQzYpScCZG+yfR0RjWp1/VOcmtdpQRK776Vpy+/GF3c/h4/3D6PYSkp+6?=
 =?us-ascii?Q?LeHp1g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0185c8d7-8c02-4bd7-fc5e-08d99fc6063e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 19:05:10.8277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ou4GCdvsouGRy6QTGLdJAcG+W2QG57hRYefE6Sw9rWrHl+rnIawQWvzYnLrU5Ce3rHJEFkxvCHD+Qdv641BH2uZTzilgUNHxqjCkWEmtJso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2873
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040076
X-Proofpoint-ORIG-GUID: NvnmqcWjjcgYPrd43UOVGraDULB25D-j
X-Proofpoint-GUID: NvnmqcWjjcgYPrd43UOVGraDULB25D-j
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a helper to check if a vq has work pending and converts
vhost-net to use it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/net.c   | 2 +-
 drivers/vhost/vhost.c | 6 +++---
 drivers/vhost/vhost.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 28ef323882fb..6c4b2b2158bb 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -543,7 +543,7 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 	endtime = busy_clock() + busyloop_timeout;
 
 	while (vhost_can_busy_poll(endtime)) {
-		if (vhost_has_work(&net->dev)) {
+		if (vhost_vq_has_work(vq)) {
 			*busyloop_intr = true;
 			break;
 		}
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9b4e7d74dab4..f6bfa1c481df 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -269,11 +269,11 @@ void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 EXPORT_SYMBOL_GPL(vhost_work_queue);
 
 /* A lockless hint for busy polling code to exit the loop */
-bool vhost_has_work(struct vhost_dev *dev)
+bool vhost_vq_has_work(struct vhost_virtqueue *vq)
 {
-	return dev->worker && !llist_empty(&dev->worker->work_list);
+	return vq->worker && !llist_empty(&vq->worker->work_list);
 }
-EXPORT_SYMBOL_GPL(vhost_has_work);
+EXPORT_SYMBOL_GPL(vhost_vq_has_work);
 
 void vhost_poll_queue(struct vhost_poll *poll)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 7ee38b4a2807..37989518a07c 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -50,7 +50,6 @@ struct vhost_poll {
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
-bool vhost_has_work(struct vhost_dev *dev);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 		     __poll_t mask, struct vhost_dev *dev);
@@ -200,6 +199,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
+bool vhost_vq_has_work(struct vhost_virtqueue *vq);
 bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
 int vhost_vq_init_access(struct vhost_virtqueue *);
 int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
-- 
2.25.1

