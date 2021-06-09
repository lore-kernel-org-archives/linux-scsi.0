Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71EFC48BD1
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D118E611BF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbhFIDlm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35378 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236545AbhFIDlh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1592ixkg049263
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=mb/S5VQZGmIDU1fqPzA+lO6nch9lhr2u/nACT+dkCwA=;
 b=ICgqEDbYV8bVvoAoaMfVTkT4/kzPDspyLOoGF1Uyn+iA8kiga9SGvgqXHUgkny6pQvRM
 xYIDLRekBtrHDOjqdymn7yUBML1iWILKiIak4eoYxXWSO8SR/D82eu8e63fgljDrG/EP
 g8XHVlSkbU+Z2idma2Ivk9P4xTXK1VrO99Lmado65XxEM/mapvz+FurUm1x40zdKktYQ
 LW/N4iCEVvyx9qp6j/0sKcHT+A5EbcMSDa0PWDECdoxD0iuxEXshqIx3ZgiAzeb/gyq4
 yspHq7TksaB3BG+kXJK5CZ6mmeUdgbEwJGahq2CN0tPJcEtdO5QYVzNImlGWeumMaw9i HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3900ps7rnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z3ri082718
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:40 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 390k1rhr1d-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnVLtal8oUMvS/Lhewapmv/NzVPSl1RvYnlsRc0YEfhuXQtjwMRDU/dAsbGZTgGf6G7v211RxkeMx6MwrZHdgpRN1hFAl1g4nMNiuhYFs+Ip/d9K1lUwzcsPJCBq+SmXNiZ5g5CHKIBMJSY3GW926NDPWsKnrdi69OcVNpzs+a67/ZkLI6XU2XSFnOZznxMoX19hAys0GXYw8RkjXGTujmEWJHLhEVobxY+cgufbuW9O+UDB7rkKkNay/qoBChLHk7bSMfBHgk+0INNoBbTxUDOYNqmRKqwhzLOkjEI/yeWr+Fi7cO0OdeAuC2Gu9IpSpb3gGqFS5ZEn68ksezyHTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mb/S5VQZGmIDU1fqPzA+lO6nch9lhr2u/nACT+dkCwA=;
 b=ELuzHqFSkXjYs9nb+zavsrBKhyvtkLa/RzoOXQOw/EZgYxLuFV+F0jf+lohCdUYSore/iUIV5OHNoF6wL301yncFYVaG1ByXAlx5oNNzZJ1XhNzVlmpyfpq/EiW2RT6Ayji+TD2CAx0ACRDupZDdWF890v2ZrRSvvHYOcTKPyP+8ckZzNa2c0057rCXpzo4rAzkekMuccUQxMMGMg767lZSpMsXfhdIbt+ZStFZjeFT5sni+n39OlqS2h8xWJDWtGGaMpTeQ5c/N563NH9AbMHjQvI4nJl0OAHK12wuol8Q2i2v6fESr8xrEKOOfMxN6UYwswZ+Qft3phLV2IoGmGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mb/S5VQZGmIDU1fqPzA+lO6nch9lhr2u/nACT+dkCwA=;
 b=FBM1dapE18LUb+nuDAMeMwb76bMV0yexIh41QRDZ9sFw5er940OovLT4gs1cZABaB8vPokEnE3fNJykGmF+RMQAAatWwBC6xbIhYeffyQ4jfhxR7wojRbXDPUJX8ZwGyNXonj2d6ALLU3lnyLNz9AkuDzAjj+PG/+j3Q3z5nBu4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 08/15] scsi: scsi_debug: Remove dump_sector()
Date:   Tue,  8 Jun 2021 23:39:22 -0400
Message-Id: <20210609033929.3815-9-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609033929.3815-1-martin.petersen@oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:806:120::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77c2010c-c8cc-4b1b-eeb5-08d92af83566
X-MS-TrafficTypeDiagnostic: PH0PR10MB4421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4421ACA7035C3BADA1F3FCAF8E369@PH0PR10MB4421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OBZuwjjgT+afJfM6oHIWA2WIRjowJP29/GWGA6bQUCbZtmwLVp/+HqZGbl+uqSzNCHGnRf+YYY1Yrzu98Zl8LICj0TaF5sOg2V1rtyyXae9Zk7o3x3PiaPWRgQjyDprqrUf77T8Uhpmda+/jP+MZoDC/t6gTlRv2HLz/Avt6Rhvws/v5swHEf86alGgu+JDfz+pHqY/QwfTAe+38wFnSLTGt+SqUqPUIZGauzp/6K6Lr1T0coStM2b7OnmY9nO5ZRbKyZJj7a3yHsjBy3v2/sfQGAPFawaQ/a7zE7peS7by+jCpqTnL97/NiNEHwmXXqix5rJnJMJOfUJ5+AaVEzBfkHdyHWjwVkQsBZTF7rwnWVA7zoSpka+CMo4qiFvvGtSV5PqRhctbXZDOHvGGBIDSybw/OILFMnbVIW4hoJKs+kjFe46x13dCvuys4oF0nA0OuDivyBMxXBN32cAKbTn5/wDGCbEP9c4UdEFRCQLmnEl6lFtjaf4GZW6I5pAsLhQ9fgfuRs+e2GBv42PPhq3XFaN+K8ArC+gNkBh5NRciFja8njTJIWEz4oh0AGizB1O55gDDi81Jz6VRkpTkUWIctYEBtQh+8l6OD25WAin5xSLp37HWKng/lihtgallZ2NvU9E+F4w+lur4grxiR8pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(8676002)(956004)(2616005)(8936002)(2906002)(6486002)(107886003)(86362001)(66946007)(52116002)(16526019)(66556008)(6666004)(66476007)(6916009)(83380400001)(478600001)(26005)(186003)(38100700002)(7696005)(38350700002)(1076003)(5660300002)(36756003)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?viCl3k0udLWfvOKzF0q7B13XsWtDCFs1+cdyL6viLfrRtjyz2rgMaDWe3JVc?=
 =?us-ascii?Q?66pvaDJVvIU9gdoPM8/6gYfdGeEE5mN8j7u2NxnjHccqnG1iAAajFQ3OxQJK?=
 =?us-ascii?Q?URPXpzsvSLJcRqX+5ZyEw0WMZESKCJTRk7t/pzPPG6sGjIR9rlIEkO06uGkl?=
 =?us-ascii?Q?IR6vZdGHQXsgmUH6GHikjjIxXf3NUF0+fAtAjNI+QwLRzpFSkBOKe7wBchlA?=
 =?us-ascii?Q?Fco0JrxMVjIOLpD/J+HxjPzCQj8sF8kVEeSZKybBzaiv9lyxBSf3eQzX2rWp?=
 =?us-ascii?Q?4ZL64QNIuieBpa7jtlvfTkTqzYED/RM4slOr0YQ69sgECS0ZJzjpNTmQZVT2?=
 =?us-ascii?Q?oj6ATphXoxABn+az8uN26ZN80koTwslwVU0zNX/VDUsQZX/+PcIYKEsx6nll?=
 =?us-ascii?Q?WIvZZQfBkfmstePMSxTtFQkJ83UYOuQDeRjJ/Mqpb1CCyCyAZc76YqZtfY50?=
 =?us-ascii?Q?R3JUbP45w9O+Wo/ds9VIyyVivAE7Oe0IlJ7ThzZIxjPWhn8aZqMHM5+67PZs?=
 =?us-ascii?Q?GVSg1I4ObI0QrkFZUvYW1nWr/bX+zF4O3Ov7OEqM1cFRgQ3HEkAv0hj6E8Rn?=
 =?us-ascii?Q?pU7rALh1v2wzrea5QZDjLxcDN1iyvWjc8JSIGj6T2irJETdEUkVmzXO73X2U?=
 =?us-ascii?Q?jVJ7VtyprCvfnY6oA1t0I5akMTySClU9GhxYRiDRbtgUPpJ5bqQqmqANEEqM?=
 =?us-ascii?Q?cmghNrn1Yuo1MHMqY7teBFfVopebc3qZITIQ7IqPrWkkP8GB+P6Ru6wRbqyb?=
 =?us-ascii?Q?769BBDssidUN9ajzALbDvWyE9gFGk6kod3tXXzUT7hilqA04n2XtJoNMX1lm?=
 =?us-ascii?Q?uyv5EkycCpuP5OoKEvW4cHS3xuwIiMJhflqvIxRL5+TMUDQheW8ljQxjRJoz?=
 =?us-ascii?Q?TGIuVLwpM2Z4CYqgNfnAIi18yyUTPDRJQY/gMkK/B5cnrgM4BR/xQgD1xibz?=
 =?us-ascii?Q?Obbh02N8QB40X8q7ZR3v05JmpW5CQY55j5jCIrjxJZJj9H1nA08iUCiqCaVC?=
 =?us-ascii?Q?EWfr/3lkbt9qus0EFd82IpGvvQ/dG+68WMJ1Rzn7h/yahrR2EQnetfigItjg?=
 =?us-ascii?Q?u8hqK0GCGc1BUbyVvg+Ayb89sDc3JgmvTFzbNKMq3pROQ3KKHFxg2nxEyiZi?=
 =?us-ascii?Q?iDh7h2HacpD2zHTcnlnD51ssyfylFkdQn5JLvUfDnlDLN54C9Xi5Q9FSc2Np?=
 =?us-ascii?Q?AGt2bAyoDtLB2quUUEAiRg1rlJHeQKx1X9SAJpu0XQxsDWkC9RURvoIbnUBw?=
 =?us-ascii?Q?nirHyVMjBcJ6V2/XkN81+lwawarDGHLiP9wnZawvTIOze9kuApCSgjmyZw2H?=
 =?us-ascii?Q?2uYReJtVePGjtvNfIgFcSMyu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c2010c-c8cc-4b1b-eeb5-08d92af83566
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:38.7363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2jyNtwCJJO5PYXCgN2qKpA6pce35dpemVFh/ENc3ODU/xD6IOB1DAhXi3Iug9TeCXy4yekb2EcC9Nem7Q0/WJ1IikK03PvkPpOk5Cgj+jE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-GUID: UbG9bzXxiXp1mFPiAFnp6U6wJf4rstkU
X-Proofpoint-ORIG-GUID: UbG9bzXxiXp1mFPiAFnp6U6wJf4rstkU
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function used to dump sectors containing protection information
errors was useful during initial development over a decade ago.
However, dump_sector() substantially slows down the system during
testing due to writing an entire sector's worth of data to syslog on
every error.

We now log plenty of information about the nature of detected
protection information errors throughout the stack. Dumping the entire
contents of an offending sector is no longer needed.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_debug.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5b3a20a140f9..9033ab4911ba 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3232,28 +3232,6 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return 0;
 }
 
-static void dump_sector(unsigned char *buf, int len)
-{
-	int i, j, n;
-
-	pr_err(">>> Sector Dump <<<\n");
-	for (i = 0 ; i < len ; i += 16) {
-		char b[128];
-
-		for (j = 0, n = 0; j < 16; j++) {
-			unsigned char c = buf[i+j];
-
-			if (c >= 0x20 && c < 0x7e)
-				n += scnprintf(b + n, sizeof(b) - n,
-					       " %c ", buf[i+j]);
-			else
-				n += scnprintf(b + n, sizeof(b) - n,
-					       "%02x ", buf[i+j]);
-		}
-		pr_err("%04d: %s\n", i, b);
-	}
-}
-
 static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			     unsigned int sectors, u32 ei_lba)
 {
@@ -3300,10 +3278,8 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			daddr = diter.addr + dpage_offset;
 
 			ret = dif_verify(sdt, daddr, sector, ei_lba);
-			if (ret) {
-				dump_sector(daddr, sdebug_sector_size);
+			if (ret)
 				goto out;
-			}
 
 			sector++;
 			ei_lba++;
-- 
2.31.1

