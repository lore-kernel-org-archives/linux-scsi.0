Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F7B5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 02:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhLGCzE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:55:04 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45776 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230355AbhLGCzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 21:55:02 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5CPm004499;
        Tue, 7 Dec 2021 02:51:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ZpTkDwAj5vNW70NlD2fHUkhqvz4i7Ob57i5d9YIkoWg=;
 b=BU2d3/fNXXzffBK3mEYwetwJXjbT7ZhEkBrO0pK+CLuBlOCdyH8n1Q0EkPJeT9DjQmwM
 l1VCJQDEtisLJxwhB503qGPtFvyNphzTlGteALb2kgyXCKtoTHeFfuNmFzpQYLzK150U
 5SdCk6z91y/bgz44Z8VZI8NXB2yMB9ImJmWHs61jprj5mUWX4UCRIW70A8DbXngdtQNG
 lTZDr2VgReYi8BKmjlKyiHKW17U/gYIGFLEVk2yPjiiAWnYSjFYfwu+9TodGKhSmOxc3
 qlpbn+PjfHI7X5pHDeaWTE/D4y+AV6IzrHuEiBR7h+cxx9HHpKO1Co1vbXWGwuqpUZYr kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csdfjbwyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B72kglY153019;
        Tue, 7 Dec 2021 02:51:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3cr1sn5w2j-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbUOXP7kXglO0H1CSkpSLJIYy1bmvzRlwzq8aVS6ztJlyOdeHfbsiSAe5oBqVEwJXITI+pYQkUXPeSUPJJK3Jv3TwqP42uLB6XMzW92ENlNV8Mi/fkdIdw7/eTQFIMta2d0E6nwmIfzoHpJyST2HbI+jL1h/P05PKx5LkttyECgruEl6q/BqaWm9ywoM5BKBXtFkrlxwTfSBcLBr1X2/XPNc6AAQI9kTQvEL1WXdjHu7ebLPNJeB/Ml58UWHkjkEbeN+UiDXQRQkdhcBQbTwWWKhzlfBcfEcb150PJfCOBaZbufaD4cdEDVkQFLF+6+sjpQRDvNwQdWCTD6gRWMtjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpTkDwAj5vNW70NlD2fHUkhqvz4i7Ob57i5d9YIkoWg=;
 b=PATHQqs1XYjaVdvI1bZBFfaviXQSDDdudGWJYzHjn+ZDuW1XPHLr6+wkiOLDeJnatH+k0bWy/Ih9oyqcxrJUy6RqDpR2SxJ4/zAOpGBRNe1iBg/7tOwH4NmNyAK5UjN0La6Dv2sjT3qr81AdRjyLuWLxNEaCXrFEOX/AYCyX0i6d1Js5+YUOW3Xl4y5Ahrq8A8lYicoqLIuZ4K/POWKht7+EKhMG7BVtubvNlxt0SSrSZ1jvAlmwLFaqeOjU/dIFKgpuSHOXXS8e2iyziOv7Iskk3rjWicjqAkmVSZdqFWdapsmb8Ja7sNkq43+9EMgu0BJmNLOfNW3nxGcZZcksdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpTkDwAj5vNW70NlD2fHUkhqvz4i7Ob57i5d9YIkoWg=;
 b=UHcQ0ajRshSqf7mc9+yeqkEWYHbVCaunbVZArfYRWXTdiBNPcfAwmBvw3VC01uvevRHlE5rZP9ZODDPQzeZfsU+MqO6tZ6Bw7f92cJpEZitxAgzTXFJ1qB3dUzDMMYLYV/dgXdD3ytDn7k8LZrIhgyYaq/+/Un6jwZsr/rZZEnQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 02:51:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:51:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V5 03/12] vhost: take worker or vq instead of dev for queueing
Date:   Mon,  6 Dec 2021 20:51:08 -0600
Message-Id: <20211207025117.23551-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207025117.23551-1-michael.christie@oracle.com>
References: <20211207025117.23551-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 02:51:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fbc36b5-c2c4-4500-a7ef-08d9b92c766d
X-MS-TrafficTypeDiagnostic: DM6PR10MB4347:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB43474CFAAD3553848C2FA13BF16E9@DM6PR10MB4347.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fKzeTDTt9uZb+HjUCuOT4Ebftdkc7puRHTX3jWMe84ZaiU3xU/g+D2JsU8w3kl7F0hoaUd810FhSW4ujY7M+r4pJKSikWmZJ0rdYxVdZx5YThMUTucQkBbgufbMhWsfIzK0pLfGbo40yKBS/d7GX+M5QcjMOixRcYiTDoyEUQ129cmxWPRE4NF8dZJNA/QKb5xQByOt1Thi+6MxLpclmHze/VD6eLa7t1we51hr82MwCfvH1s2FRKO0A6ytqSF3LdvyMfZgMRo32DR6UcG6aR0AIXmGkZ5FN9X0fheiaYI0x/Ns8+g5F9Kp+yQLkU0LiTOIZ+JJ2Dko85vemB2+wMSJDbWM4RQRHEvlGE6pPu4OFvY9f2bEtsgWaNWeSf3ZFkzZJUtlxsanfny32SVI+9wJeeJqNZaSvM8D0LSeA8sAAumr/fCXZvTeADQD4xJhJFgUaSnpFdSKgtCwzLTF2bd5TYocurIIwfM4W58AoCpErjeL64ope3iUcBZ4VWo+74LnGQzoE17jPLw9+JkPZH9UcVTU+vS0tqIabH6Fw1CT5e0pRgKRj5PKXEXqhtcdUoLSet5mmYk/OUw80aINGjgLXxvZI6SSEa7hBouHkgrhdY0f5gM8wivcqv33ZV39DZkjSLK9jlim3SloKeHyLvLgkQxZ2nddSU61pVD0PdRUq2qaO3E5sYPqV/8AoUz8M8oPiDCbuUtXnSnAmQRwweQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6486002)(956004)(107886003)(83380400001)(4326008)(5660300002)(1076003)(2616005)(508600001)(2906002)(6512007)(86362001)(66946007)(8936002)(6506007)(316002)(36756003)(8676002)(26005)(186003)(66476007)(66556008)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qZQv7PnncDamDfa57EVx8g1/qIK1grZ/6zFz9X2mG/Fs7mLb0xkSvKPwODOa?=
 =?us-ascii?Q?TaUG8aGJvR5tnN/GeQxMtY/kIDRBK6jXLEdWQoYGmw4Pea8Pk7zpFYO6z/B2?=
 =?us-ascii?Q?eMmXBfNtJBPZI0VS08IL12rSoX9pAFHSFHDHu1FyK8PcDRYqAEHsCFdZucFx?=
 =?us-ascii?Q?Q7sxzayrN9T9vnHkMO6/MSVJulFNfT9lftwrmKqMZfPualCHdd5QayyOxJru?=
 =?us-ascii?Q?Wfb8hkDdy69S/spLIvuaIGDTOK9RJMUSJxmF+s9dHkXDQABQaeRg/nnJ049R?=
 =?us-ascii?Q?qcNiQghBNkJuOugzClwxkuBDydQwvijzCtJw3lNFHZjA+g8qUiOpkGsqANPM?=
 =?us-ascii?Q?AEnz8wW6NUAdIZJjvN+jL2vAJM6votCB0IT/hinuOxtQhDEiJAzNPPKHIHDJ?=
 =?us-ascii?Q?RWGcV1yfFUu1Yrcd4ePcGN9UAgwaoi0tRo1vQQPwhwf2U+8xUYRqQglOQFVM?=
 =?us-ascii?Q?QlgtUQPj2G9Hezw4OxstNURxSLfO1pHx6SZzj/0e8/Uy73YFWIdo0gQpD5mg?=
 =?us-ascii?Q?Xm5+tOMYt8d3pYNVZa7QC3QY9dbzpojwdkISoW0oYPE2YHe0x8uonSnJpb8p?=
 =?us-ascii?Q?J98hIQGT/m6VdzquKFL9tsjGqVggGNrnEza27OF4Sxze3BGkC3XMZ+NpKGER?=
 =?us-ascii?Q?FBbowN+Kge60h0KxfU4S1guDwP4shzzfCYgVqTJJrwVnfbtrWaexfNa63uW1?=
 =?us-ascii?Q?3g6FPUdZ19KXwyZj5Jf5v90RyMiNoki8sVhsaCq/mNuzvv7lFBA9ImAdr7vF?=
 =?us-ascii?Q?I5SCeHZHrEAZfZKfAbfs8Ka1CaOsqZjmm66mtzmGPRa6AtThFvhGVTIxn6Lm?=
 =?us-ascii?Q?qWRML+d81J9bDVfOc15WyQUf0T8HcVnLc4ujpXPytHB6s5fEYVVyabhXmzDU?=
 =?us-ascii?Q?H4KYT1xrNxHuzk47dE36vdPFsVX4secS+7AUx9Jf82d5XE0PUhSQ1dFYJvSf?=
 =?us-ascii?Q?HbMuSINzNJUdYvSPUxRnXD35k3X2elYvnCtosUIsAzTyVEIShFRGW40I5xD7?=
 =?us-ascii?Q?vy9lgI5u2WCwvAOo6LXSTSMGvytKQKFnheTCLECrTCO4Nv+bCtlHJyo84wei?=
 =?us-ascii?Q?ODhgwqxf6kgp+Zx1WInqIMjRKw6O7rjIVKqPtujRIKa6GBukRutZj+VbRnhm?=
 =?us-ascii?Q?+XTuBvEB5yhohnFmoQz3r5x4qYS5SnC/LXK1UeAgulFTqZCg+tYAtv9f34tJ?=
 =?us-ascii?Q?K6ZPfdNw3eliSumdQ9TOmEn/c93RnfggNfFzM8BzKF5e6phjgx6LvRGCivrx?=
 =?us-ascii?Q?fYkqjcfmNxM83hT93SoDGqhPvHJtKmjxwPX9wK8qAylVoBL/KviW2r46LGG6?=
 =?us-ascii?Q?+Yk2MdiDtmeRXc5PBaD8VR0RNVFnejRWGqVc1zPZxRhV7PPNmTt4b79eWvfY?=
 =?us-ascii?Q?uqo7/1bzuvnWaBG4QbtqdKwUAyv7s1w2kgVg00ae9PyuvsF1uurXJBqYmKts?=
 =?us-ascii?Q?e9v4cOYl55ATPDPazw+VDFxA/H5La+vwANi+vCW6JeGmqKntxb53eu/0141I?=
 =?us-ascii?Q?pVmuhOJ0K8mr6+Vig8FqwhuzqFi+CTouDmXDRRnY/4M/BYo6itHufBqiV8lV?=
 =?us-ascii?Q?MyIyZ3y1BVtRVqRBOh/svgAuJ17zs1Dk/1tGaStUF0C0Rggw7xyp+rMZPMsX?=
 =?us-ascii?Q?wcAZWYbM5D1am/hy1jUdXIMRZBHR1b3hsBqQgYoNkpKaszdtZ8pGD4bJylRb?=
 =?us-ascii?Q?rwN7/g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fbc36b5-c2c4-4500-a7ef-08d9b92c766d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:51:26.7772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DhZj8z+PVmRnzsbECdH17QIimAPzBfOUtUXTYSzAduhRjnTOJ0mduzSPXEX0kbJQ4963mI6OWrfgVuw0cejHSpp6UaQTgBV8U3LupVr/GeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070016
X-Proofpoint-GUID: aYhxXl4Y7ZSLU8nUEaEce9bBbEkV_6Ec
X-Proofpoint-ORIG-GUID: aYhxXl4Y7ZSLU8nUEaEce9bBbEkV_6Ec
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch has the core work queueing function take a worker for when we
support multiple workers. It also adds a helper that takes a vq during
queueing so modules can control which vq/worker to queue work on.

This temp leaves vhost_work_queue. It will be removed when the drivers
are converted in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 44 +++++++++++++++++++++++++++----------------
 drivers/vhost/vhost.h |  1 +
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 2fe7c2e9f6ad..86192e1658af 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -230,6 +230,34 @@ void vhost_poll_stop(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_stop);
 
+static void vhost_work_queue_on(struct vhost_worker *worker,
+				struct vhost_work *work)
+{
+	if (!worker)
+		return;
+
+	if (!test_and_set_bit(VHOST_WORK_QUEUED, &work->flags)) {
+		/* We can only add the work to the list after we're
+		 * sure it was not in the list.
+		 * test_and_set_bit() implies a memory barrier.
+		 */
+		llist_add(&work->node, &worker->work_list);
+		wake_up_process(worker->task);
+	}
+}
+
+void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
+{
+	vhost_work_queue_on(dev->worker, work);
+}
+EXPORT_SYMBOL_GPL(vhost_work_queue);
+
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
+{
+	vhost_work_queue_on(vq->worker, work);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
+
 void vhost_work_dev_flush(struct vhost_dev *dev)
 {
 	struct vhost_flush_struct flush;
@@ -244,22 +272,6 @@ void vhost_work_dev_flush(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 
-void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
-{
-	if (!dev->worker)
-		return;
-
-	if (!test_and_set_bit(VHOST_WORK_QUEUED, &work->flags)) {
-		/* We can only add the work to the list after we're
-		 * sure it was not in the list.
-		 * test_and_set_bit() implies a memory barrier.
-		 */
-		llist_add(&work->node, &dev->worker->work_list);
-		wake_up_process(dev->worker->task);
-	}
-}
-EXPORT_SYMBOL_GPL(vhost_work_queue);
-
 /* A lockless hint for busy polling code to exit the loop */
 bool vhost_vq_has_work(struct vhost_virtqueue *vq)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index f0f2fb334b13..f5251cf902ce 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -198,6 +198,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 bool vhost_vq_has_work(struct vhost_virtqueue *vq);
 bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
 int vhost_vq_init_access(struct vhost_virtqueue *);
-- 
2.25.1

