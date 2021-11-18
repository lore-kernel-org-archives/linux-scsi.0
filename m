Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259E7C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Nov 2021 08:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1070A61BA1
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Nov 2021 08:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244768AbhKRIwR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 03:52:17 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41178 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244746AbhKRIwO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 03:52:14 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AI7lc1Z009982;
        Thu, 18 Nov 2021 08:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=YQqNGwhtD77XflrKin+JsXVch1yRyos6lH8eB1ThZxU=;
 b=RZ9mDbdd1BFrMOH5Fhpzt9uQg2GeHW36aUX27e/nvD6xscn67swt3mZ/yFnWcQoD+0Bp
 NYSDHj2W45aIrP6v+ir8C4qsXuI9yvjVAopC2lfIJHZE8/VeBaCB3snJYgGCrsDDb90O
 EgwX8k+u+YMKTFEpOKfDgLekeuZabz63Iqh0cQ+q7V7DgZkgmVVhagA/UdwF9kDT6ApA
 YnzB0attnuJ3n9VDttnBRneiHCRC2F3FKQwnuFvbjslhRwxMrpHT7LwDksZhVlSQ5SXF
 q3TtDGS09Zl7dP7WoFndImkmeSLUSEMQzGeDeEIYAlBIgYS6flD4JeM9pIzoKndIIYFl jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd382dweu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 08:49:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AI8f9Pk118492;
        Thu, 18 Nov 2021 08:49:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3020.oracle.com with ESMTP id 3caq4vnjr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 08:49:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oet1E40p7TARB2y4Osc+oB/9ikurLkiP3t/fRLqA5Tm/pYiUE6pM0fb6QAu9mhpFSVf19iy9frPSWMKR5p+IWhd7q0T5bU9aTV17Uco2BdmPfjqSBKYpk+Ai8p+QHAG2jJm2rhhPtN99lTfi6eD1irBB5Cg6GuYMDj7F5atTRFt3p9ZboqTtmlNa6AikTfShTRqwKHrN70ke/JcRKpAM2wyctoaONVzv6kH5oPhXhLLlvgHkOffnJd+C83qrtLftKesdd4wjJt2phuIHqhoFJO3wT7/HkobpbJJWXg2dT0r0WFuBu3rO2oxvBLmBZ9Vzcs0+iiz/F5QVLlxv3T9r/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQqNGwhtD77XflrKin+JsXVch1yRyos6lH8eB1ThZxU=;
 b=hecs2UYrBXzoAyZC1nzfi1mYxUk87Up9QWn92U7oyPSUV9V0ODYvZING+YbbD98vEwt50TF0PMDMS8d2sAK+hAzyPYPB5lrDKEPZZiFcxfq4SbVTOnd1Lk+NGwVFGQZF/Kf6qu5cH5sZXDQlZt0QhdXWvkiIlu/KYZQeMFKPNJFOEDr5VNqCOdZ+foHQYwENXE9mVAVHINf9ptM5qq0IymcpHb8uTvV2ce11TxeDOxdbvyQFiJ1xXNd3jpCWtIotNnSee2tJYKKSTj4pFJhIy7GP8aZFE1whvDBI5uFUC9V3lZhwanh87cEVwBdsJaEASbshNj/T8UbJ86Gt60HYMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQqNGwhtD77XflrKin+JsXVch1yRyos6lH8eB1ThZxU=;
 b=ipP9ZYOv/K8BMcYRuR6kHSfvn5FeomCDUyzM29RFrzc9QlnZwI26XqUw+8cx63MywTlVo7OKMsp4E0DmIP+43d0yo7bZ7DI2HdYZ0spuR9+fwqF1brMtTRg7revSYqfjG/TLq5GaC7M1wgUzt+i/KjNAgepIjMbIgB9UdBrXjSw=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 18 Nov
 2021 08:49:11 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Thu, 18 Nov 2021
 08:49:11 +0000
Date:   Thu, 18 Nov 2021 11:49:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] target/configfs: delete unnecessary checks for NULL
Message-ID: <20211118084900.GA24550@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0083.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::16) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0083.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 08:49:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f642d585-aa7e-4914-3614-08d9aa704a44
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:
X-Microsoft-Antispam-PRVS: <CO1PR10MB475413E791EB61031977404B8E9B9@CO1PR10MB4754.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bObiI/cuN/RK8Hxny4NjBWB29ucqDbPP7jZBKq/0x+9ZO2bzyjRUQJIBFZ9cfxATvpyqDnEV280iT19AiD5gHAT4Qx7ExiXcwpv9ygpWuXcnFx2sxjSW6obfsYyQi3xEb6L1O688DphNlUP6bb+0lbN1nxkh+7lqWOSZzqKHyD1QJ2/LwfowgZk+UkDB1q5aITb9g4YdnZk4IkOXWA3OLmDkoI6rWcSUY7kXGG/IjY11lcnxgXEYRHw6PpW7ynp47D2DlohFTsnWWOxeG0aEv9+Ag2ZtPGD3JgeiNQ24J/bgBzw4GeTocDL+rdojGjE7OkmrelZt8XPelVFTDGyOMgFLRr1gA+RNcYCXYfJUox3uO3QD9rAoIIUnWO1v/kw6oTd78U7/GCXxg309TIBdw2Sm52T9StW6l9nSYv2TdpsCSQHaTOgAPmLwdxOW6aC7F3o1MOT2YJYb1x7tw30PAtM1NrlFLPUpa8QQSQ+kxx+qeI7W2KY28BlkHeXWlmkjUXHGigmmLc9lxZySdwCq8Tc/SGEBdHsltuL1N+oqdoQnfkloSmjyyOCv8NbAwI+CJrrdHg26Mn+KcjyeHjVhjqmXushYCQMmAKEH4uCorMWOCti8xnZdKCzPcRYzERH3BdDL2HVPMq52y6txC5gSrx9/tatE0paoiBm4q5498TBFGUFA5Yxn4v3sT31cm6HUB3ZcQlQxHzS5/CaQzXFCJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(66476007)(66556008)(66946007)(44832011)(956004)(316002)(86362001)(6862004)(83380400001)(450100002)(33716001)(2906002)(4326008)(6636002)(38350700002)(38100700002)(33656002)(508600001)(5660300002)(1076003)(52116002)(8676002)(6496006)(55016002)(9576002)(9686003)(6666004)(26005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zafMunXWLzT4BykOx46kyZfsye+AgBh84yf2xO2dLPspgZIvR8Wvb27p+1P8?=
 =?us-ascii?Q?A4NQUS0g6yBypx0gxEMotjezR9prjJ5m0DwoQs3lnsPjKowXVB+dL3f4UMF8?=
 =?us-ascii?Q?ASWR/RDzZxSXajCah7ZHxfobfOPo0QcAaGYRhvCnlYtYPqRWMHS4b8a7KKG7?=
 =?us-ascii?Q?PTNjXgOPhTdFZvDHZaoJuedE4uWgQWpdA1PgiOBD8lXUhPGnUnKiZ+N8anXW?=
 =?us-ascii?Q?0SGWgKXKsGK4x0w8JqmnFuOWLJqWEhvppeeiDiRsUs7l0nnYSZYupZDFtjlP?=
 =?us-ascii?Q?W6Ju/gLkL3NMQ5cJerS26KUO2cXrPE+kXf6ExNNcQQSzkj2EtTYhAuNFZj6l?=
 =?us-ascii?Q?Xrtz3TO5vIVv3XXnT7vieuki497SnramofW9ZU+NbdG2xOHC+zwWgyY15eTr?=
 =?us-ascii?Q?vhtk0wPP3J0NU3cNB2gTKMAnvlQ8BSXf/Zm/tGImqmOUY7BD13YyitUpnipU?=
 =?us-ascii?Q?vVQz6RRvwVyR6o4eGolEY2TxDYJCO+8ho057no+Hg0f7pSSTZK4XtfHm/v5p?=
 =?us-ascii?Q?KLtSr1IvjXQ24WgOwXn7AXeAByYX3+ng42yecjMhNvGq6ZjF2HQGKjm1mjE0?=
 =?us-ascii?Q?L3Yn1EEgaiUPSW+NHXQs8xTC8X8bA3EQO2yWlybnzJVHUlsBWPmS+H3dKNj7?=
 =?us-ascii?Q?SFQQh7KrYsNVgp8YlMioBTtDIs+qov5aS/v2nS6qya4hgPef1FhPG0WdusgI?=
 =?us-ascii?Q?VUjdWY/8ILEO6dVy5LxEU1gMWnOqcMvPGoZ+8SwVddH3bb1UzDNSU3k9MQyV?=
 =?us-ascii?Q?c1Idi4OU+Whh9UmZRMe1sPrj6G6Mg7eqvrM4Iq4Jfd4MICp+4ZL+AgNp2IEn?=
 =?us-ascii?Q?LXPdiZ+YiLwPpISO90OGdWfpk3/9cH0tyzkYxAb+gHNiJEZT1KqLDJ8iIXTL?=
 =?us-ascii?Q?MNVUzNmu+jIvUl4kFSH/owu3MSQRyvKJ0w4fzEf9CYAjpOfc+LWB46Wiqgvk?=
 =?us-ascii?Q?k4+tas+CcJNj8ZJP2GrwiGp+ITDvJPqf6h4QMRuf/dHozkgle6QlQDHE4pR4?=
 =?us-ascii?Q?ZEHbS0W0kzGZTSK/Xs0hD7BK8kX8omwPCoL9DJ5CgS5SstFSySwCb+RAcIcU?=
 =?us-ascii?Q?sDHA1srOeuioMYcbR8Rpsu/QKllz816Roz6AtgW1CdlxzRH0KKluAbx1XIHf?=
 =?us-ascii?Q?M83LWl80iLtK7Bt7Y8OOSB2hoF+RX8N3fZvwaKEakC7jO8gP597NmUi8pt4v?=
 =?us-ascii?Q?OOGAcG5M/YG1nK3GVvua2oaU6O4oByGnuGbr9YrokwGEivYqsuESkc05IPIt?=
 =?us-ascii?Q?1OS6/yK6SPPPYr6o8Spwx3rng/ElDPLgMbFVYcTnNFntq2spmGnup58zhCgU?=
 =?us-ascii?Q?1rg/KkE0KJnc5ASkFxI1caES6SWcOm/wzddAx/bHKPJSsdPLjgJ0OZIrgqYH?=
 =?us-ascii?Q?+g4w7JYGZw4eY6lgs+MnpumbtB76d0BSi0AbxLB5KmxiA8AtYpUUMI38PwVk?=
 =?us-ascii?Q?uTHiMaT+rziAYtpnFnlV0DiSoXFAdR/AvfsVD4rcHi09qdEIjKuYaQd8Sk30?=
 =?us-ascii?Q?oR/i1+N6XX1bOLOUhRrOxqLGytT6bQFsqMDxvCk2WSB84BOUpMsgBLZNdq2S?=
 =?us-ascii?Q?a2YcSNqjOzFIBFgW/lURDVgaiqg7s5nxm08tR0C4r1FJk/Z2dReJGpm2VUk7?=
 =?us-ascii?Q?aQy8Mbw8jQxjnSduG9jJyiiT07mYIbybNVOW9xZvusK2MyKjhZXs+ePsuqON?=
 =?us-ascii?Q?KzjHzsPxUKwRVfQaoQuErz+wJyQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f642d585-aa7e-4914-3614-08d9aa704a44
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 08:49:11.0018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V/m9xXD2yOXx+uEAsk+U1sdoi62QQw+pjwmRkAWu+9VUFobLyorYQKhHXAwLovVwC24Tgsys3g8tONe4H/0aHsCtygZLFTjvVb7ROqf3VTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4754
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10171 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111180050
X-Proofpoint-ORIG-GUID: rRy8h_FucQnqL4AcZJqYdsPg4Su3lpEC
X-Proofpoint-GUID: rRy8h_FucQnqL4AcZJqYdsPg4Su3lpEC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The "item" pointer is always going to be valid pointer and does not
need to be checked.

But if "item" were NULL then item_to_lun() would not return a NULL, but
instead, the container_of() pointer math would return a value in the
error pointer range.  This confuses static checkers since it looks like
a NULL vs IS_ERR() bug.

Delete the bogus checks.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/target/target_core_fabric_configfs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 0b65de9f2df1..95a88f6224cd 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -520,7 +520,7 @@ static ssize_t target_fabric_port_alua_tg_pt_gp_show(struct config_item *item,
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_show_tg_pt_gp_info(lun, page);
@@ -531,7 +531,7 @@ static ssize_t target_fabric_port_alua_tg_pt_gp_store(struct config_item *item,
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_store_tg_pt_gp_info(lun, page, count);
@@ -542,7 +542,7 @@ static ssize_t target_fabric_port_alua_tg_pt_offline_show(
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_show_offline_bit(lun, page);
@@ -553,7 +553,7 @@ static ssize_t target_fabric_port_alua_tg_pt_offline_store(
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_store_offline_bit(lun, page, count);
@@ -564,7 +564,7 @@ static ssize_t target_fabric_port_alua_tg_pt_status_show(
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_show_secondary_status(lun, page);
@@ -575,7 +575,7 @@ static ssize_t target_fabric_port_alua_tg_pt_status_store(
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_store_secondary_status(lun, page, count);
@@ -586,7 +586,7 @@ static ssize_t target_fabric_port_alua_tg_pt_write_md_show(
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_show_secondary_write_metadata(lun, page);
@@ -597,7 +597,7 @@ static ssize_t target_fabric_port_alua_tg_pt_write_md_store(
 {
 	struct se_lun *lun = item_to_lun(item);
 
-	if (!lun || !lun->lun_se_dev)
+	if (!lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_store_secondary_write_metadata(lun, page, count);
-- 
2.20.1

