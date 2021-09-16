Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D927C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 13:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1214B61212
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 13:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240134AbhIPN1p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 09:27:45 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48892 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240008AbhIPN1o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Sep 2021 09:27:44 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18GDEP99012754;
        Thu, 16 Sep 2021 13:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=6XWuOq/qAXtsLPIVQm08FBFpYq8b1zsrPZfnAyIQ1kI=;
 b=H9mQyVOWsupwxEEccDEWktvLcZU2nu+5TPB/PPZtQwUprc5e+++AY0lnUeqEaIUj/FVs
 eu75rueecCtYI1uI9n8m6dmXL8Z9Vnyk3XMjogMipdN1vo/1SZ71RlXcwN9yFSit3w3G
 AQhtH5uh4xaRgvXWbeHKGbLUaqSa1wvueoJMYDDMzJBTPStQmQhdIsqCCcfkyLFOCHdA
 aPvKJGh7vGMIRaNPzTyYcT1aEVFVuFYTyh7upQXySNRGD3XzjxcH8EKttjPZ0IE+G/vO
 x0HAkxemEBTUGlYpVMg81flspUMIRilZusdG6F7Gnh81aJ52Nu/sjJ4hlFEKniXRc6qq mw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=6XWuOq/qAXtsLPIVQm08FBFpYq8b1zsrPZfnAyIQ1kI=;
 b=OnlRW/9J4Ej3ZOK3Gz0cYSU2wyZpaPzELzx+1Hb/UpUJyUmboe8mk6p71FSTdm0bKXGp
 kzZBAlmLSVbX8SftfitQBEiKXzmoF7pqttu3o0bzGSR8VXbCG5pnnYI+hrdjZyTcr0DX
 I5FOkeIpl1lujvljqDM+VksujGJR54Et7rwdSDzN7IdPZd3Iv2m2kANq/TCOoTUdoNWb
 Bg/i7UjVOBCd0sA72wIaMtKK5I2+O1sgtVBmylH3QaH/gyGJ6VKG5AtCl25KD0PxJFT8
 /mRbKOUGB28e6+8T+78iderFWrgVPrPMt/1ArUTkNVFCw2efcRlLpI6mSu9iyVyvDbAs Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3s74j8dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 13:26:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GDPJsO049810;
        Thu, 16 Sep 2021 13:26:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3030.oracle.com with ESMTP id 3b0hjy83bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 13:26:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ivz/FRIJDMnNJeLGWED4tBqnGYLeDOSkS/ewyx2X/qkO7Fsw2ofYhLV8/SAPY5F2d3xI7163Xl4iLxNJ/CAbLlhA52uch4D5S1GMVu5pUq5EJJzPX3QD6qZPYC/ORVqsL+TgwnvzFgkVkgK0JufFgkbcu0ikJBo6l5NshJIhEB4jCkKtFb+Wj9Fm/FExOCe46Q86NdawtbVUQhX/KXbQgc8BC9PkneHds7JJeQjOaWPSw6diFHUDnusr8hSvzIWYg851W841fkZfgoWEG/ACvgD4ZVSWkFPjcdC18vlVKAKyZMdP2/mJT2JmLr+zNU17Fa3PPoshyDzg/P/C0FnAyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6XWuOq/qAXtsLPIVQm08FBFpYq8b1zsrPZfnAyIQ1kI=;
 b=MUSZiMSQpwxcdx1kZ+QWUzE5IHD5300N+FdvaibC+XV1MM3Z2ecbSwUS4F3qhD6nJKh5JzsNvqrw2acSd1AddiZIbdaBTEAzQ+5futp0VeQ92t2nI4gV/2d5y0WfmS8v6CXwIvlVgYo3mHZPK1UBEUguR4AbffsmjPKv/hnjMBMBGqdwJ3CCtj3fJNz356zN7RL2+oAygRhKgp6u00T/FCxmuY5G5q84Xz2PN3rujSWIBb2ZWt7QRs7G3BwKQJvNdrj5fy5xwbK+D8xV++96R0T71z2gXRGAtnf6PhzUz74GO9mMCB2cwneYvqBSocxak0bcQxBn+y5329vXxLjpRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XWuOq/qAXtsLPIVQm08FBFpYq8b1zsrPZfnAyIQ1kI=;
 b=ccNoPL1PC8rassgbUE6UILnhyTCRY8ldjKPIVUxFDfZwKx2Sme2Ju00W670nkPn0CAQP5/ROSPHoBj4boieU9ketXRfMDc4WZy4nBKraTb4P6nYIGrYuqwWtyslihioLrSiKtyRp1IBi0djjKx+szmgFwQp7eJu06Mx6NHE5tE4=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2399.namprd10.prod.outlook.com
 (2603:10b6:301:30::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Thu, 16 Sep
 2021 13:26:17 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 13:26:17 +0000
Date:   Thu, 16 Sep 2021 16:26:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: clean up mpi3mr_print_ioc_info()
Message-ID: <20210916132605.GF25094@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0015.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::25) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0015.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 13:26:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d71d4799-d2bc-4deb-b96f-08d979159054
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2399:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2399F71D90B46BEDDC3ACA3E8EDC9@MWHPR1001MB2399.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+0aSpjl2W5ncbU/a999vZLm7Fz5xx8jA44Zb760xujjiid0KDwDzeYtORbaleNhnOoSwxNNME/1EyLeIEhiUAHFDdyuV2wSHkXCZxhk/V76iI5qbe14Riico2PaSO8qk/KLFWPUHCk52EUEDBqWzJxeNXA+bNwQNVpgQTJNQngd9JBuisMDSKrIOIT+F3Exeq+nnTY+d1Mlbn2u8RxxrasH/5eS5GDcpPGQc/ELDFWGemaA+ylsdxrCXcYu0Qux+3yyR1/YbMrAYV/vgAUZGvxYez/2IQkea3UWIQ+JCwiPqpOcAsy4RQHNF1jZxP08AzK6sFR6VLymk40WHy1PcoE5FTCCT9K3U4YMxDkG/3ufK8UgGu66bobVYhGxSV3VhXC7ocj33P+uzZTiU2I9J1EKcOf5RI4hPQDUUUrfjpLgwCfr7+46GxT83QZbbMMYhmKCQ48TeB7r0CylpBckj4pi+BRlyCY7qBH+nDQFTeMDePbthgpWmZEe2hn+kPntZlzYtDL/wg/cybQU5mnQm6V7cq2J5oO8zqHtArUWK6zYBDN7YSwcW8uKbP0ZrYi4Zef7g8sCsd727UDa4pP8gxCJJknhaWLeuwpzyo4o1/eTh+k3BEUF/v7kpF296XtZIl0fTAXCj06ixWOU7HrD5XYHcP9ulOfwkl5Y1pCWvuGvGZE85di3xVHUwG+0iGPC+of9CcktHRIHNJWQNuCYX/+tN2tFjMCQnKG11ooWZKo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39860400002)(366004)(396003)(4326008)(2906002)(66476007)(66556008)(478600001)(8676002)(8936002)(33656002)(9576002)(33716001)(38350700002)(38100700002)(6666004)(86362001)(83380400001)(6916009)(44832011)(956004)(6496006)(52116002)(1076003)(316002)(54906003)(186003)(5660300002)(26005)(9686003)(55016002)(66946007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KLFmOmZeB2vu1a1m2aj8AGODkxODCExWJet6GhYt7P+ZLMNki36GYS6PxZ5Y?=
 =?us-ascii?Q?HZheJajG+RSZZOoNhUE9pHGk1icpL/iIbvoRc/IXweDNkwqRa+Zv/PdnGryd?=
 =?us-ascii?Q?10fkGJuU47mFgU0qForIdgHJn7UfPy/p8AC3qZNSAOGKx/SFAnOJzx8mBpCD?=
 =?us-ascii?Q?qoosTZSo1aIlTiiGoBuCHKpCL8nTtB7Ufx7KyLIuAbCY3YENOgQFn2Jm/Ljy?=
 =?us-ascii?Q?8ZxK1AAcOPT8eVMfTYlFrfTv7gP2xB6+Pfm1sRuSPyrxg/G50vt1tvHlpHfi?=
 =?us-ascii?Q?Uza+XyibHVJ+blg8MQefqtRJafmzZQMTipvB8O94wOSNQszHqlsVIqvSQ6nN?=
 =?us-ascii?Q?YhxZJ/6uXjEn72ONvBipNZLT/7jx+cJeUo9+S1HCJLLIl4Za4C+rUAJjj8eu?=
 =?us-ascii?Q?lCeRNzXUCnJWCDy4JCr1y8Z7L01sD3NcYORHi/NmNN11HAiPtK9hfRqlhX7i?=
 =?us-ascii?Q?7rJGQc5LAF5Y+tlzVOUUwAlFdIQTyYd4VdQIuLXzDqN0HCqKHOtRlyOv5IzB?=
 =?us-ascii?Q?sxhbrdhOVELa14s62nj6ZopdPkiqk2gqLFtuAwT7RISt7Mrq0nqSQs2akuiM?=
 =?us-ascii?Q?akF6lzUPF1wyEeqKliFBXeWJYtcxHj516Jtgs4cxt1vaLZPO40QZrFJc+Z1P?=
 =?us-ascii?Q?ZwBHpC0HHXwuMXGQdZlDN7sOSrWTTphEoNw92nuPRNsBeuXfPv2e4B9nx4Z9?=
 =?us-ascii?Q?am3gUaF51gMd+rfsfNnps/l4lQAiNVF4aUNRpvu4uC/2z+9dU3Nuk5Iuu8L1?=
 =?us-ascii?Q?uHxcibW9FdYIHJ9r/mv70lsaOt5IOCfF1WFaaDXYb0pBklaW5LP8qgNk8/K3?=
 =?us-ascii?Q?ZaC6bwhIjRmwpxENNeKUC0KdqEmGX2faKZcCEb38EPYdjuw8VIHqCKdpIdOc?=
 =?us-ascii?Q?l84uUfRCI9XMuLPc2lCvXrDWtT83tYGezWhxxzkbr4seJk1ErFGonIWqW5Yh?=
 =?us-ascii?Q?WhRLsgP4MOx0r0qJaBuZtFiGse0dMevQj4gYCR5DKOPfX58g85Lyic5lSPk4?=
 =?us-ascii?Q?iSPOMXjs5YDmYSxHWZxOXhiZkHwiOb/sQ1faqNaFbrI850BrfRl5l1wZvbPR?=
 =?us-ascii?Q?ckERRJftdwfCrfPXlTGTeJ7B8bpQIbcWpotl5KV3oNhBZyxYhBIJBrF7P7Uf?=
 =?us-ascii?Q?bd9fyIcV5t5VePkT/iAo7rhywAeW8rQmASSK1MR5IqkX1AofCKX0TIv3jPLs?=
 =?us-ascii?Q?L7ZgWlaesi685QB4jlqXhd7KfNXEf4AuH2c3a4tn8cIMSJakRF6+VgdMgGeo?=
 =?us-ascii?Q?Y3ji5L5FplbBJRyLN6g0L5h+i8+S+TcUA3p4KB9zBkwJzQNDZCM5LvZo9raK?=
 =?us-ascii?Q?CvH4Tx8TqY2GDM0ZR57mVnOB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d71d4799-d2bc-4deb-b96f-08d979159054
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 13:26:17.4900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DgylXOzC5bnoHqQuj0EK3Dr/JAEGQUOs+TMkU52P7YcDgdOSPvFeC4SplKlWYdLzEmdFRlxCcpWx59L2AVaKBZu6XA/K8TeOCkpPHqSZkJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2399
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160086
X-Proofpoint-ORIG-GUID: s_ccVTK2ChXOQB6vEt1wKWKEZrApThKS
X-Proofpoint-GUID: s_ccVTK2ChXOQB6vEt1wKWKEZrApThKS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This function is more complicated than necessary.

If we change from scnprintf() to snprintf() that let's us remove the
if bytes_wrote < sizeof(protocol) checks.  Also we can use
bytes_wrote ? "," : "" to print the comma and remove the separate
if statement and the "is_string_nonempty" variable.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 4a8316c6bd41..0c3dc9288b36 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3022,7 +3022,6 @@ mpi3mr_print_ioc_info(struct mpi3mr_ioc *mrioc)
 	char personality[16];
 	char protocol[50] = {0};
 	char capabilities[100] = {0};
-	bool is_string_nonempty = false;
 	struct mpi3mr_compimg_ver *fwver = &mrioc->facts.fw_ver;
 
 	switch (mrioc->facts.personality) {
@@ -3046,34 +3045,21 @@ mpi3mr_print_ioc_info(struct mpi3mr_ioc *mrioc)
 	for (i = 0; i < ARRAY_SIZE(mpi3mr_protocols); i++) {
 		if (mrioc->facts.protocol_flags &
 		    mpi3mr_protocols[i].protocol) {
-			if (is_string_nonempty &&
-			    (bytes_wrote < sizeof(protocol)))
-				bytes_wrote += snprintf(protocol + bytes_wrote,
-				    (sizeof(protocol) - bytes_wrote), ",");
-
-			if (bytes_wrote < sizeof(protocol))
-				bytes_wrote += snprintf(protocol + bytes_wrote,
-				    (sizeof(protocol) - bytes_wrote), "%s",
+			bytes_wrote += snprintf(protocol + bytes_wrote,
+				    sizeof(protocol) - bytes_wrote, "%s%s",
+				    bytes_wrote ? "," : "",
 				    mpi3mr_protocols[i].name);
-			is_string_nonempty = true;
 		}
 	}
 
 	bytes_wrote = 0;
-	is_string_nonempty = false;
 	for (i = 0; i < ARRAY_SIZE(mpi3mr_capabilities); i++) {
 		if (mrioc->facts.protocol_flags &
 		    mpi3mr_capabilities[i].capability) {
-			if (is_string_nonempty &&
-			    (bytes_wrote < sizeof(capabilities)))
-				bytes_wrote += snprintf(capabilities + bytes_wrote,
-				    (sizeof(capabilities) - bytes_wrote), ",");
-
-			if (bytes_wrote < sizeof(capabilities))
-				bytes_wrote += snprintf(capabilities + bytes_wrote,
-				    (sizeof(capabilities) - bytes_wrote), "%s",
+			bytes_wrote += snprintf(capabilities + bytes_wrote,
+				    sizeof(capabilities) - bytes_wrote, "%s%s",
+				    bytes_wrote ? "," : "",
 				    mpi3mr_capabilities[i].name);
-			is_string_nonempty = true;
 		}
 	}
 
-- 
2.20.1

