Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BD8C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B9A661058
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbhHJIrs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 04:47:48 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16104 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236753AbhHJIrl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 04:47:41 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A8f74x022859;
        Tue, 10 Aug 2021 08:47:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=D6/4XNamdWjTbity1K+qAScrAJ+oBnUoeFCUO+yZZic=;
 b=0Vt6vUv6fyiLfdw8gYSftOB0xWSgKJhSmK+IFOrsr9Psm929OoH+8NezAKhCryQTe4bT
 JY78AXF8WSHN4bq0492BDBKVIHRX5ZoI8VAu+oE6MPqbAB39VyIMK5SMLnG/4ajgrVtN
 aIWh1BXsQCLC8C+NYQPW7OwqgnSzJa9bezpWltGTUdRmaJQ1i64U1CDzKVdzUIlFsx1H
 KGua8hWL4td8ub8u/yhfNRbchoBBWEM82xvGEhuYfwuXgUtkfBWzBwp37trYEXwcShyp
 mnmkO0H7CAIrlonz8RulhuWS87tO9qZog6ZIPbJVKjjVK7Lq6EcG9ZfIfILGjLwZLEmO jg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=D6/4XNamdWjTbity1K+qAScrAJ+oBnUoeFCUO+yZZic=;
 b=OPQ6/nEjR/x2ANgnVm3z4AoheEhW8AEEfeZKF9292Qgs1LyxK4N4E0CD5jtSePOUm7jY
 AP0YTAkr//m1L19bqOPaN9mnmf59UG6oeYykSm024zqCtoSudRAvc/8TOjXRe8YD/WnK
 kGWeJdq0S1C7QjJHdrGlURYLaUX56dSnxet6El6EXPO5Ev4aS8AWkEUeN4fWCw5vBoLn
 uDgBzuIrh8PukPvxp/3kPq6+nhgg4rNo5oBsdZGM8Kh1SkXD8ZnyUuvXD67oyTa1Hgot
 +MS+Fm0DBnQfI/senmaWfv8AxjGpREjHfV94IK8nzAQOdDqCSCF0PdhlnWRHgQIwEeO4 jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaqmuuf1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 08:47:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A8eUVS189415;
        Tue, 10 Aug 2021 08:47:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 3aa8qsqmjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 08:47:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lO0M+kfRe5APp+bKpmetEDshS9MZPk4l38ObnBdmAK+y9MdzwgrV8yo3E/O9fRQfiZ5A85W8uwxXaNFwc+ZP1AM6pUqVVB2PCnUfW2t+6sVs0EiJEOlHqUi+JCiHb+DAqJfsDdMAc+8upN3L5J3oPDgToRcLguM6KBF7zfVecAhDan/l5nOtX2d73rzJqsrJqvszFP5WDAWiEAVCZ2v+MDv6ruPyxjgsC/qF3ETQUT9B5psLh/+Z/v1f9w8WjQX9Pym6Nj2VdEKzwpXmG8K8MbI8N1CDk9paDEFJE2L32zdN5Fj2Pki3B9S2WNHiRZa0bo0NypbQ+PgtzCZs3f/FEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6/4XNamdWjTbity1K+qAScrAJ+oBnUoeFCUO+yZZic=;
 b=bFbYUmX06PzHUuGkZe1mOFtsZn96jfbvUIL6AVxHj0WWdbVzE8OdDCn7HRfaSwHAHOHAFaXWIl8ukdeeuS/PFGB4ZJ4NQTM9fKM0ywZR/quxtQucuvnHjgrtDenNRQLsB1LqG/n8DHeHtLD3s9PAAdn3i9tKmGXtEMtLUUGsMcGSYrjnB3hlRBY+26C5WuVEaSMcyhfhotWnpfZaaJ/TqFIuVnVMqUgwlnPH3PbXU7cdAQGw0eCQp5y8yTNzH8xi2UVaZnBqderLfoImqiQs+7PDod9WanfIVTdt2gyjBSppOHwhRjWJywL+/c/SILCINoljLrzLl3lcqmaW/pz9Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6/4XNamdWjTbity1K+qAScrAJ+oBnUoeFCUO+yZZic=;
 b=A722rBnEPgwGpfGIOZH5tyfnJLOIFOeA0kHHZatnvW/OmhYtfY9OfZFJ1mdWXID1NO/UlhpLAtqrlFQNQ1Fw+NLVQGKcywW9oZuhoAzuhMCojjx9PPZotCSynFjjJ5xYy3q89LvhS0/e1fVDxES/AEKiGs0nb85odKXWb9g3Ilc=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1566.namprd10.prod.outlook.com
 (2603:10b6:300:27::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Tue, 10 Aug
 2021 08:47:15 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 08:47:15 +0000
Date:   Tue, 10 Aug 2021 11:47:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ondrej Zary <linux@zary.sk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: pcmcia: fdomain: Fix an error code in probe()
Message-ID: <20210810084700.GC23810@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0124.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (102.222.70.252) by ZR0P278CA0124.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 08:47:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1341bf1-daab-4b86-9f27-08d95bdb73ca
X-MS-TrafficTypeDiagnostic: MWHPR10MB1566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB156610D5BD6BD5DCB3391D8A8EF79@MWHPR10MB1566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8znVZNZ8U0VBfer23ekp2mTXNsSUsVD5LW42SzaPIpoPrsWxSYuX+ELbPxAk317PchACf26gefLVVZ0fSp5DsSY0G7H7/cFu6Oh8ucpkLK3isScjUTLLUqtcTnxjZyvQh5ZfcwkIHrUWZx5L6IVFDlyuriSOCRvrWKthKl0LR/+JsVFxkHKUxKj8PZeCTDGbSE+ocqaawzjeMRj/fSYnjnf7Dwnrqh0BW7LQpQCKPGHQq4hFUHCvTzALdgluGHSuuQG2VVPWz21Q4DSSDGLYE5hKjn5vDXPEFH/isXlTdqhZ4qnvpe3vbE8Xt3rwjB/134d1z7/uXnmQPVpdBuuaqbznqiihy5wCiYZIXtSCTWJTCqCvemlJ1w/BdzViMMSU4PRxGIxLas6xSvYas66MmsBXkxdM/DNa2ZrRii9fkfIpdPOS7sFMqbkx/g7Gyn9mK1KbqkKR1c6XWxsaQMhP9115SscrcIiGp5jGByJ0ZdkP6zyUTDLcJIefgA7mbMHdFDEOrcF0F8ApO3ILaVkvOQbo6pvTryieFCOfJ8VPQzdh72U4gndSnBnccTdje9PE3RB4iGcGr706tv1mec//aVI/vQFX2x18N+Qe4tYpps7KZvu42yr/Tug3XnqxupjTSZnCeSaaSglfp6iqsF0Qmn2otOuGHXRHhN6Wq3Y5N51WPEn6kWVkD3RQPYwonQBW7NDAzt1JVIA0yzUmtgVlkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(346002)(396003)(38350700002)(52116002)(1076003)(55016002)(86362001)(9686003)(478600001)(6496006)(956004)(83380400001)(33716001)(44832011)(26005)(38100700002)(110136005)(6666004)(316002)(4326008)(8936002)(9576002)(66946007)(66476007)(66556008)(2906002)(8676002)(186003)(33656002)(5660300002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gl/b11Cx1HbGs4Ic2QpKIOx8P15QUVG6ODvaEK05KaawD4tnSEDILARcb2mH?=
 =?us-ascii?Q?mHN78Udxs4a74z8li8uUxYJpKPuB8umLAw1su7iibjQC1WBX81SY/kVcrBMT?=
 =?us-ascii?Q?xtQ8g4gk0H5+1kkAYD4TEooVLSksznSYpDgN/lOO/4UM9mU9JRCY8qSaS2UA?=
 =?us-ascii?Q?n7H2kGk4KUD3WP79O4hOvcuWmdnNXM0fiXSCfUHg4rwYe+2B+pcqFkgFOVss?=
 =?us-ascii?Q?0sRh0Vn9jNJ9t83MmkgGdPWspnNCPVfYjBEsnB0iEJFhTpvlun7n5FK7/elC?=
 =?us-ascii?Q?NTD+LGDPX+8rTPXwwQf1r5in38AvZ9f0BHsBM9AWovYRlD/MYOfYO0Q6633K?=
 =?us-ascii?Q?DW3fCwxKi7tma44x/WM+jfNnDaihFKCfObp3HUV6mkOKOPQ0CUCcnTka+Cen?=
 =?us-ascii?Q?7uLmlVEFtotWjNNHjzqLidWFOP+rq5NN0hb5ip8EWzVj1VwslsLuC4uZ/18P?=
 =?us-ascii?Q?LprwDGqwYflbKreho0QIH3M57XhqeKKrRx8q9EGTgrtx34nwLg+RZFXEU+DJ?=
 =?us-ascii?Q?XJ7bbO/fnE0+Yb7u036ILc9mRdBrEXFLXkDKIRA4nTvpwNjpqP4rJZW3GjoK?=
 =?us-ascii?Q?E6CVLmA/T1bV3Ak61N3nQCBIiWGHPmLEU0tMirBZ5GcEsUKslpjyXs96fPT2?=
 =?us-ascii?Q?vHlrFSo1vUiWML9HzPu8N8bzM4Db/7V2eQeDuICBxOb4OzFa65I5JlFVrz7U?=
 =?us-ascii?Q?eg+r1U6KD51zFzDDsJBcu4qRE7XKeOZKeciqNcpl79zHriKvMp/vN1FyzOd8?=
 =?us-ascii?Q?ychR7Wka185orfw5VTgttw5ZrRi7NIv6dQeDK3OND5njV1iyLm92hHzxJGCf?=
 =?us-ascii?Q?KLP+T6Qxfml9/HDtwSIZlrx0UmOnIIUtXMzllg/ybb4I5QsqYEVndc2eHQow?=
 =?us-ascii?Q?Y51txyglVcuMV9ivtrxDRaQTsoOsW3oPNM4sqUWzZk3Osgpp36/RW+1kZ4aL?=
 =?us-ascii?Q?Rq67SUbm6YVFGv2AV6IfnxSy7p/3GY+n2HBee+uXYqkkjKoSTfJmIcD8+K5C?=
 =?us-ascii?Q?eMFXfRlflkv1VUeCma3Tn8C6RcYSAzgw0Me7+kcmIxDgLqUAhy7Tw5Imz61p?=
 =?us-ascii?Q?M+Q+cpKEc9BGcgEE4/RfiodXtJYYgWMNU2tsg9Dm6BmANxlo+t4tuDyhceTm?=
 =?us-ascii?Q?w43kNZ1ktgXGn+NXIxNFBf+uIgUX0aVt890roSAwypVFu1TjtTDlGJj2rhVk?=
 =?us-ascii?Q?vltccR9C7K9PsQR6O1CmcvgzJ7K7a3G/qE3ILBiiydTYJJuRG+VvLZdvcSp6?=
 =?us-ascii?Q?80MzDSt659d+ZTd3uVPQtNxGfDsIguAvfJp00kr4mmocerE06ukuGJVNINFk?=
 =?us-ascii?Q?uO3DcsFWwzi0DQJXKOOSOUWm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1341bf1-daab-4b86-9f27-08d95bdb73ca
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 08:47:15.1488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bBi3t55GsqG6G1ajg8jPrXcMbhwXiHN6h+RDcPgtLWWAzey0hXYVUOdcZumJRLxjDEGj/wMmpRvOf0E1pmtIpZWibmqgd3rQptRO76t/Uo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1566
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100054
X-Proofpoint-GUID: iYWwPKEODgzaph0Di2FALqW7rZxXz6sg
X-Proofpoint-ORIG-GUID: iYWwPKEODgzaph0Di2FALqW7rZxXz6sg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If request_region() fails, the driver should return -EBUSY but this
code accidentally returns success.

Fixes: 8674a8aa2c39 ("scsi: fdomain: Add PCMCIA support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/pcmcia/fdomain_cs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pcmcia/fdomain_cs.c b/drivers/scsi/pcmcia/fdomain_cs.c
index e42acf314d06..33df6a9ba9b5 100644
--- a/drivers/scsi/pcmcia/fdomain_cs.c
+++ b/drivers/scsi/pcmcia/fdomain_cs.c
@@ -45,8 +45,10 @@ static int fdomain_probe(struct pcmcia_device *link)
 		goto fail_disable;
 
 	if (!request_region(link->resource[0]->start, FDOMAIN_REGION_SIZE,
-			    "fdomain_cs"))
+			    "fdomain_cs")) {
+		ret = -EBUSY;
 		goto fail_disable;
+	}
 
 	sh = fdomain_create(link->resource[0]->start, link->irq, 7, &link->dev);
 	if (!sh) {
-- 
2.20.1

