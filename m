Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED811C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8BA164E84
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhB0RNO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:13:14 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48010 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhB0REn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:04:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGwuoP021458;
        Sat, 27 Feb 2021 17:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=apjPo5XH7dEKoHl7PYYy3A0WZrT0I6GidbxtxtQ0sE0=;
 b=tfDRvkTAuY4WduvgygdIHdKb+1OiCKNcjv4wSJwOm47u3GvFMGmnHICvYnCsPU2h0w22
 c6hkSpPgxMHg4Dz7LdPfsvi+fw4EYDGJjeik4lqdqKzVYsGbzmhKgt/XnW0iaWnSw3C+
 Eo8DTzab3voxK90rTfexZw+QftdaFAK96ACt3e5YNnzQzi/0Ck7M8I1pMaTevfrdNopS
 9aQRWD4dT+Gijm+pBj9+Ct6pAm4s23RjAYhFlXJ3s3YEZlZXZaWSHp4nmhPDkt0j+ysT
 wjQeYKovhA7g9B73ndlu1bniSGhjQ0hjMho3sp9hQRqmAH9QTvDwK8u5I+avqtsL/6im LA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36ybkb0v4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0Mbj173209;
        Sat, 27 Feb 2021 17:00:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 36yddhy8te-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0dHGrTXDxco/hwoHdRqhAwbaVW3gAIJi5MnCF6q6whD4K3aH//KQsOQh8QRq1U6OWFsNvM4y0+oy/jQ+pazVBYOx/tUaisLqSsGLGjGhzMzlSR1SWrRb/zGpkvO0+Y3GePDhP1ibL8BMQwrcw2fAK6iAdspYeMTdwTdabWdtrMhoPd0V3LvHrfgzAqSGLzwRbgbyWAVQDJPtrLBmLB693JnmSH5KrgG09Mly+QOyebd7vFf7QrKUAo2nUGN46k+wVD2M+TiN0/qqRHSXpsgxF+eKXGsBKsdrdgch0OCcY2/Rq2uMe0YFoAdiNt5Y6Ri65U7iKL6+osaLXr2CZglng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apjPo5XH7dEKoHl7PYYy3A0WZrT0I6GidbxtxtQ0sE0=;
 b=kX90BWb1/4ryNOOb5hWjNCObcNjsFxJdfQCdn6F06fqYjcoflJmiDZLOUqOeNYfS4HHXcXwyGbYLNDUuQ6Wfmbf6valGE2EwwvQL8uXy/DwCuKMDWh+ZlkudIIf3GgUBA19Bv5ZdtDiNVOorMGekCgGsWkarK2Qluwv837++7BP7U0guUvep+oPvPbs2LVYE2CaRCEsxUbG0q3ye8jp9cWB4DX4WBkUlhzVYwD0lpcWAZaReJfdPpmPp/s/Xomit3jzYQRhnIxsVOhn9WtouDVvrU5f8CIEBjhQBN1ieWSCQ2648+AdiAHitn5PnreRyTUSsgMaSnwzsz9bk4I6aGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apjPo5XH7dEKoHl7PYYy3A0WZrT0I6GidbxtxtQ0sE0=;
 b=VxJ/eDyUXH/J6/jIDRSVevWv54iyV0A57okVaQphiaaRz1YEQcI2r6K+R6eiXJjG/yVg4q+TsW4MZS2lNlrdGdAfRv/XAvI+Y4zZ2eJsPRnRCinpHtrPdSucvZo/q/ah/5+R8moWQUyaUUSb/5+kSmPDSrSXrm+kVYOXFRd6jVc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB2538.namprd10.prod.outlook.com (2603:10b6:5:b3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 17:00:34 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 21/25] target: fix backend plugging
Date:   Sat, 27 Feb 2021 11:00:02 -0600
Message-Id: <20210227170006.5077-22-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3840b06d-57f8-49af-8518-08d8db41326d
X-MS-TrafficTypeDiagnostic: DM6PR10MB2538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB2538AC36E9E114B237D816FFF19C9@DM6PR10MB2538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGgM3v7X5VsZDhjn7SXLMBVq9qT7ne7RgssOmECCERcHEZc4lgQ8jNgQlg6qygyYJdZREbeEMUm0X7/qY/Hd+rc8YdNLv6HXC6deE+BTdsEm1jGWJKiFyZ+kOD/4lK6Y7fspusVMsNOKDh1ou+B+GdA7DuaxOBk7b8vOYIC9hMo2m+jjyxATdtT5SlyLk+NuL1G+VSkzPaalUDnrFCWjQHaRjEC4Tq7xi21rKkCVYWnRH6NcCxqKur05gBjAK7Tm1QmgocpOOmHHnML0HMojhjJfQjFBs5u+GjtmhxzpLVPqmt9a6rzNz2noeq865WOGGQWzMDLygRZJ29Z9leaCJuCIb85YMDzKTbbeHzVZr8j30SEBmXqL/hzQnpajG6QPahj9+OWBUttb1gIJWIDbeyRYjsj1ncTsTvFFq13Sb7zZeR9+ReEqU9M/w2jVbXVlPbYPRk2hTHMd7Ae/q34RLbd52bpjXQdpqtAPsaFtW1r/fxNklZ65mhVzQouwuNeCCDOChFYnHoKNZFBWRF7xTlxQBsuDdSKLH38gprbS6y+xEnwVhYacTKYYnEOs1E4U3XqrX6ORq+YWH+0vd38gDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(39860400002)(136003)(69590400012)(478600001)(36756003)(6506007)(5660300002)(4326008)(107886003)(83380400001)(316002)(52116002)(6486002)(956004)(2906002)(2616005)(66946007)(6512007)(8676002)(66556008)(66476007)(6666004)(8936002)(16526019)(186003)(86362001)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7x0ih/yGUFAz/CVSjDtQsgmeiAymEzSuhMBm0CEDkKyiSo9NmE3OdU/pxjLL?=
 =?us-ascii?Q?7fDO9FyOuMdzQbVoh5YRZwuIrQu5vtOxXhbUXYg/cyXjT81kNH2qWus6dusT?=
 =?us-ascii?Q?xto2kuHS4cCoNmQ9L0dK8ezSMXg3MTAp14L489N1o4yBKAs+/BvjzZ2xwk3r?=
 =?us-ascii?Q?chevh7vvhR6NL6Epajkow4ji3D4sHFdjj9o4tVdt3AOandWG7OfPkE96ER1z?=
 =?us-ascii?Q?XfLeJKDQSVWTiYe8uCpfiDL2rBbPUZ4DAloDyYe1N+Nnn8ihkJQ3zsGYP9hN?=
 =?us-ascii?Q?UoZ+ODOzV4pWTUynVWbY1Znj2LqyGQUp05ixkTtG17IRF+xCoc5rTWwOSDqh?=
 =?us-ascii?Q?L1rfzzxVQQxTWVoFDX1A/EQ/NrdxYu6Y38E+HKpd8RYm/DztIlKZU3CGWQ9X?=
 =?us-ascii?Q?/2DjntJJ5Qun/G9pv0M3JAc1KJnihcR4qFylATa++xFGPqdfVYB4p9xjPgMn?=
 =?us-ascii?Q?pRz7P7spoAL57y774s3fJLYVya2HMLwmTNFkve8de33LC7NaIDpPM7k0oxAy?=
 =?us-ascii?Q?hgsSjjttbbJkGpsY3knfRJlb94zCvKF1gZKJb4u1G5gyKSKZKlXdFC8sr4o3?=
 =?us-ascii?Q?Sj76FknuRwRh8TPwlcE6SnH1lSSMJNAgJXfZBpyBupHfeWxh1D1aGZgv7SZx?=
 =?us-ascii?Q?t8o8ae566vwKs7ZKybkCRPAuJHjQHhPkty7Y8zk1QkR29UYinJdVHbbTr6Ag?=
 =?us-ascii?Q?cELDqtP0EeraUnxpaOIA+HQY1IXxtSoKuM7ilgg2ZMasoPBsNyxw70snoLRg?=
 =?us-ascii?Q?LaxQwx2jyZIjJMbmLLIAAn+NPCM00yJgxvaD47EMCvtMmpKAzvz5DtWQuamc?=
 =?us-ascii?Q?mDxBsCG1qCLaC0D+fsS9/Vm4uFk3uLYVX9QKiETFw2pWTY2hWvdUxMuZmsBr?=
 =?us-ascii?Q?8utSgN5W1nt+u7Qfsu3DGfZe7daoV5KpIfadCIJMqLVlpai2DoqEGxakhaWY?=
 =?us-ascii?Q?KiwmfDyDNNKna6j9Koc1niwvUPwfVqO85pvsB+Wc07bSSNFVmRCRh+AX9SdR?=
 =?us-ascii?Q?5qa65sUl6/XQ9vpenO9+Gfx1qf8FamQ+KL7eR8LQVSJtbCUZdeg0zr8ZnpWh?=
 =?us-ascii?Q?CJlGVAxxB2l7WoDktUkXYgI5p1bMLSramCoXjuhuNHrpIi2HYh/GIjOOgHpY?=
 =?us-ascii?Q?+8jNFiD9EeBRyroo6b1UzCopdSM+wEvzUf28AlA4+BuhrqOQKrAqQdV8CWGX?=
 =?us-ascii?Q?OsSRMFxsMtveuhgnKOtSSFFQE88ebtlunVKQwGsCslzDKGdQtHfZiZPIt7aT?=
 =?us-ascii?Q?Djtv4JRLZyTn+3KXNtas1vnxiPq5lwMm9JoNQiM6+CxbCJYODF6Wtn1Zpt31?=
 =?us-ascii?Q?TKUoNbCEf269zbnBFhgEVnJq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3840b06d-57f8-49af-8518-08d8db41326d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:34.0199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XwdSLkXhlVjIEDxjsytkmfR9Mxl3C0BJsKR5mOiiRUJvfk0qSL0NdQT0xuPs6uByW6GnIn212DmZvYrgU0hYNbLwQQoA2+s4NS9tW62LYNc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2538
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
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
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com> 
---
 drivers/target/target_core_transport.c | 43 +++++++++++++++++++++++++-
 include/target/target_core_backend.h   |  2 ++
 include/target/target_core_base.h      |  4 +++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dd63f81bd702..18cb00a1ee2f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1805,10 +1805,42 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
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
@@ -1817,8 +1849,17 @@ void target_queued_submit_work(struct work_struct *work)
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

