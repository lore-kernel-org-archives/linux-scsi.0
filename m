Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCA1C43381
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 930D664E6B
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhBLH2S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:28:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59580 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhBLH1u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:27:50 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7Ol88176681;
        Fri, 12 Feb 2021 07:27:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=nmNPczwdrWFQufUfS26xsht2CcTvVrMqQOEoCGgZw3A=;
 b=L691TKSqwFdtKvi9JpXfDGBXjunIXFcTnhZxv1nYKB69MLtOIpofbKGvMigCSw5NxuJj
 hichvfaenQjfRaOzWPVKM/d31/qAEb4v12q8VDNmk+GCNqLQPP5N6cQTtNTPbLYiaj2P
 hiAR6aek1m5J7P8oI6OpCQI2RsuHTevfTjfz9opmnlRXwwT9nqiIBQmArHWzdVqEVjF5
 JKpr/0Q/TNe7TD9llxtm4FMRD7hLixOzD+I7Q6hRjNqZVd6J71jCP7EhHHyKW1zkvYIe
 EJ9uykPJ0crzD540OmAEjnJeNy53nI+2mvSfpO/w1mA7vxushvfgUNd7J27Pzvbnh8hO 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36hgmataw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7OnuP012963;
        Fri, 12 Feb 2021 07:27:01 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3020.oracle.com with ESMTP id 36j4vvcbub-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V306aBJtxRKw/wMxXef3RMQuU313yg4HG9t1sQXyCYcaaHt5SVXfldFyiJGcD7cpLG0OiTZfus9s9TEMRkUl3aNx1TmHuqPCY388xOa7LQhsmMastftTwwGT3vO2DTC36FLRDKCJLF/yBEYcxZtOxsFOAYwTk2Pr/sxdis2xdm2sGnImtUmlPiOID4afCz52r25JczuHlYPeOw8BpJRv2EpuARvZlOsYOCzEfyhWe+UkvQP8XaABasJOVLtqy3VIp6guzz90i4ZhLdMB5sTmjyjlaA9NzLoDHCifL4hcpXBLNLcIWfDcg871GZbpjUqCTHp/l2Nw+cz6ZfYSMRRiLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmNPczwdrWFQufUfS26xsht2CcTvVrMqQOEoCGgZw3A=;
 b=lb057KmilGMj2og+96SGoZcHGh0qgiDUtXnZlKAmbSAvXtPoVfNFGJUwHq/5HP51OoeIP3iBDUXmTXQOTvQDzVx1fY1+vWqZ7fFtv36PWWM26B+ZDHNeSQGbMs9zObtDh7XWiUjvpDRQBDmbKthBpd3LHTfmpBdBPgPNJWucL4qzYGgKSo4UncGVvKsuQT7OxWX+KUydmcr766h7w++h+dW7i9Li00dA5cra9pYyDyYMqWp40w4Itos/SnkLpYH9f4Dz9ALx2FUJk0AG3BEn33Rsv13fGv0RSqQ/mxFJnhl79om0hmjEkwm9nLSPtInkz+76x2jUc9vO5fjPcfHG0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmNPczwdrWFQufUfS26xsht2CcTvVrMqQOEoCGgZw3A=;
 b=er1Qp40+0hT7rtB6YL3NSGLMKh7ETNmPzMaMyfjkAwoXrPpBQZVp4kI9MTnNBymBoFJ2ITf8oW2IZMIlQlVrkJ/c2qbUC3yKi1dh5VdIZY+P4d6VdBH79pF7x5gKI8Cdvj9epluwV/JemafmqNtUKu2k4fUT59t4hliViRR8GjQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:26:59 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:26:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Michael Cyr <mikecyr@linux.ibm.com>
Subject: [PATCH 06/25] ibmvscsi_tgt: Convert to new submission API
Date:   Fri, 12 Feb 2021 01:26:23 -0600
Message-Id: <20210212072642.17520-7-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:26:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcaf64c7-705c-43ec-b5a5-08d8cf279554
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254E823F91EBC4FE9D7B53CF18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6lWnhRLVuqiSMgs14eERzLy48vOQ/lMA5P3if+hbtVSf5GnyM3HfV4+U/hmM9R86tsY0cfP76fNfACgMBamP7xuKKZYraFAGplPNsjSpkkfwgGc2IoUZ09yaqdeoNP+H5E9BB6HPRUkuQYW5OPijVWGWb299zRzrq+52OqIYQ3flB454NxM3Bi5VMAJhSkb7K+GhoCS3AZsL31cOiIH34pReqy1+0bTSlLXIuh+6uCgh6uGwQ30Gdmda6WP/koUwlBHBeEgYigSiAkjoXmHw6DP15MDa9uTO0vmUlOJbQlTgVIvtNfQe0TtYBBOVZTPw+0WZmh2K5bUxMyTziTXYUJM+guJ3yMO3T2UBQN1K3UMDEYcmHHkDuelX9V0j52UuHF/U0ro9EziE33cnZ7yhfxfW52A/ihH44CfBWdsytmidnZFFnCMl4yq2tc95tDrz35O+XtLvS+wP+H1cH0aO0J8cAEVsBkVygdWGkH5tXvzHwvxnwzqxxzeh7iKPuTmbSGbzj1DcPvE+EGTNRr0gGVqQe8Z9vt3WmZkZGVXuXHidKQqN6cnaGC3Cv2M4vbb1Vrvh83r6azA9Cejpb2inbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(26005)(956004)(6666004)(54906003)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ye6xPk6ECEZ/lw1w4LPvX65MOWWFXu97eI1JCycSSsS9B5Lm2ywcnQMUH43a?=
 =?us-ascii?Q?kRe+DvkO/anUSRqd1mCFj2k0FQc1WPgfVSPGeEfe/oHby864DSw5+jEQ4OsP?=
 =?us-ascii?Q?VTc7Ymng07Ux+6W+fgoC8HiFA41nD3TkpFny8/rVqK3aXpTc+u26m+RcQSEa?=
 =?us-ascii?Q?kpZYKM0EgUMuZ/ZKskftoZpDBBPPkou3gTwkMFdkcw1LHtDPsQoVMeU/7Odx?=
 =?us-ascii?Q?T0HURH2XJzs/ooJEkJvyygy+XDI1XwNGDNi3yNjenHrAqP7H974Mm+ARy46y?=
 =?us-ascii?Q?hUAniXSv3KYj/cScLccsY99BtS0UXf5jYzT3iVUXlYg3//rLqzplVukZOfPI?=
 =?us-ascii?Q?Cgwz5PE+HzriRVAU9OUH0RBEYwaWF/R0s8IDsjmnjrIcUo91CZ4iffMiy51z?=
 =?us-ascii?Q?h3XXEM28vGfwPv2A1kU78ZgbepH/g3TA20xKBL1yALRgh/KxxnGz4DoGSspN?=
 =?us-ascii?Q?D/P0/pgNnEStBSYYIfPBqvpAYMNtYJgLH2Jfyy41GA2KynmCB1aIlYUCy1SZ?=
 =?us-ascii?Q?8OKTFUthFdYYd+x6HvfsgYcp2TFPyzZt8LA4EHF6LTyuK7RU/NaxRnmJ0ZnJ?=
 =?us-ascii?Q?j1cg+DPLPWzw44V1dA8Mm+bKn6YK6ENCXqQceLt+UgNlmHqEKawqSa5QTd2h?=
 =?us-ascii?Q?JhxZCpB0T5cGT0TaiVAfYhfVH4KQ8aAl4oDcwKoCQVbZ49T0mzaWb3wtAqSJ?=
 =?us-ascii?Q?Lqxgb48QFknjx99+eUHxtm9/2MoVLlHqey4F3qwk5QaKRTfHJ2GPHZa98DfQ?=
 =?us-ascii?Q?onZusg1M+i7UnKSMco7P9RaSHNqZBmp29Az9w2xCaBVf/Bqqv60lKP/2asxs?=
 =?us-ascii?Q?WgsUuoyXY5BKlu7owog9d+y3BHsRP/VPSvfVotzvjmw/uyvgje3wj8CNwklG?=
 =?us-ascii?Q?+JR6E5eTqdB3xpEPb2Rx31Vm9bFmeO1QBMNlLZ/jCRpm+66vAMyo9DpuIFAJ?=
 =?us-ascii?Q?8Vw+LUzmCPAxqVONBN91y8Jsu37ztQTGG8Ghu0hiX7T61GzCu3M3z7sOP1HI?=
 =?us-ascii?Q?iICDuPIVnf53NxbuVne236MaXs+LwE3jzMVOsZBHZF4TbwKhuEWf0GaPIWSA?=
 =?us-ascii?Q?DxYPBtvH3JqTi0e291Gt7KbFcUYw7ogqVkuxqHjVP4bpb9ynm7Ev0tCkTEQJ?=
 =?us-ascii?Q?GRzqyoVWKHjeuJqNy9bGRH6+wQ3bA2VgBsy2YHMhP5udgccvZdyx10mHoCql?=
 =?us-ascii?Q?RTrlWqeICb6PfPS3I5DC03JnrmV47FMgKaJ+/4lhZAbIWAKYge9UWFFcdhsQ?=
 =?us-ascii?Q?mXZe1mds4VpL/TLoXyDNFJCYE/+bwFEReIDPKf2Vu9YVv14Fo0UcSDD58iYl?=
 =?us-ascii?Q?M6JJ4WnP5eZoXBJJEigBBMff?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcaf64c7-705c-43ec-b5a5-08d8cf279554
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:26:59.0475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JW+Fu24fRXHA5qTmGuamauo9lxGrE5QjkmjNGXaQ+/k10PTevo2TkeHizYX5TX5u9UvfMoGNT9FYw+rhm2I7UhsXgeEZgMaTsSm/XWmtNSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session. It
will never return a failure, so we can remove that code from
the driver.

Cc: Michael Cyr <mikecyr@linux.ibm.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index cc3908c2d2f9..cfc54532402c 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2670,7 +2670,6 @@ static void ibmvscsis_parse_cmd(struct scsi_info *vscsi,
 	u64 data_len = 0;
 	enum dma_data_direction dir;
 	int attr = 0;
-	int rc = 0;
 
 	nexus = vscsi->tport.ibmv_nexus;
 	/*
@@ -2725,17 +2724,9 @@ static void ibmvscsis_parse_cmd(struct scsi_info *vscsi,
 
 	srp->lun.scsi_lun[0] &= 0x3f;
 
-	rc = target_submit_cmd(&cmd->se_cmd, nexus->se_sess, srp->cdb,
-			       cmd->sense_buf, scsilun_to_int(&srp->lun),
-			       data_len, attr, dir, 0);
-	if (rc) {
-		dev_err(&vscsi->dev, "target_submit_cmd failed, rc %d\n", rc);
-		spin_lock_bh(&vscsi->intr_lock);
-		list_del(&cmd->list);
-		ibmvscsis_free_cmd_resources(vscsi, cmd);
-		spin_unlock_bh(&vscsi->intr_lock);
-		goto fail;
-	}
+	target_submit_cmd(&cmd->se_cmd, nexus->se_sess, srp->cdb,
+			  cmd->sense_buf, scsilun_to_int(&srp->lun),
+			  data_len, attr, dir, 0);
 	return;
 
 fail:
-- 
2.25.1

