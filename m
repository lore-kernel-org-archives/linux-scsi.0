Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1436AC48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F195661184
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbhFSCX6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:23:58 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53226 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230499AbhFSCX5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:23:57 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2B32G027976;
        Sat, 19 Jun 2021 02:21:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=BtxtwIn1qIg3wG1SARKJFucvpNzhOC0xfyH2FdwEQzg=;
 b=bOHSIbLU13VbPtcjbzF2L3MH1/RSdeIFYSuvTuWR0X3YdKBCZqm06csny1RWZSQTSXw0
 9RPt2kJUlve5aZ1BDKTYgNMW+iO3BZuxdhMgK2QKJfIhiIbNvhzYcS63NEOfBEhLc9XD
 NBrUcUX+THTetqjZq5Yt7DvJEult2MCohcOocAfLQxQvi6KJWmdEKyKuAjQKwncvCCbc
 QcPdgBxYU7HdL1V6tMQCTfYXD3A06aGgutJYd/8bnyqbhtJh4Ynuy+y3xKTrUktu8kFV
 gJOh2zFLmPMNGcSr3/5WR44DFWFZUNKjDqx4kP3DBBKEOPl2ZVziCbgfmElc3P/EYmrd Aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3996sn8133-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:21:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J2FPvn181441;
        Sat, 19 Jun 2021 02:21:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by aserp3030.oracle.com with ESMTP id 3996ma1c00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:21:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FaTT8pUALq7NeG5W3eS9LYWm28IQJMKlsfHU14e7gYvxXMFgOQCS88MP3GRoMRWqW/raVypFW73f5jskBF0/uy+Sz7UWQqfmmi+nDWtvT9e+HCesRuD3zq9vjferj+JMZhzGzeeeibmJ5pOfeqVXwi5Uv/Oepyytuon+izbs9N0ba4FWqwSDYJ8UY/dq+9oPIr6YtXFBXSW3onw6Vp9Yyzrsb6vX0skaPEns5+/j7+A1qlhwKGgw/GPk3RcvEl1jFDPQZiOohu2XcQVWG8FbWoGInZfo4ErHhgboWJDmi/XGKJKpLJc8eIf8dAqXXYc8fruA6IMsDowK5LhWYGkIsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtxtwIn1qIg3wG1SARKJFucvpNzhOC0xfyH2FdwEQzg=;
 b=nZpwRgv+uqnEZ3LfoRWuwlWLdeTfQBzrJMsSuKtynhMcna3beAMhBCDZx4xLg9FJoas+jUYq6YJsSFHzXT+INqT1t/UaeidPyzkdmUfs+IdN1Y7Z0ITWNK/ffmjzgqkejeZOybf3kVo4Qc/c39LiI9+A18NUAZA8q3DlZo3IS5E7RtLdOr0VwROPBF31BYPfLqfYH2FlspdUnFd22BuA0u2ZpIysaxlNv9/jWxrPXs49O46YV60H4oFMbsf/a1rGSiHC5ROCyKh51mBuuX5Z5JNYRrV0seiZx/KZVVLetEzaBuxFODxIQzGYBQ4TizhJE2xFKSXHLIT5tO87tXh/yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtxtwIn1qIg3wG1SARKJFucvpNzhOC0xfyH2FdwEQzg=;
 b=KZhOVg8RM8ej8zDvY9Y4lD4xR5YNCGpBbSRfOHvJM8qstRPf53qF/x2Unp2QAmIgeNpdLwJwNWNstraKAtKV0tcRuTBCmFcWR56XetoWvhwViMgmO9SyQ+9IJXCLtwU0pl3hB0B6mF1BQPRQjUOQAfNYIbgFMOkF9pNctcf1Wmo=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1614.namprd10.prod.outlook.com (2603:10b6:301:8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Sat, 19 Jun
 2021 02:21:41 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.021; Sat, 19 Jun 2021
 02:21:41 +0000
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 1/1] scsi: ppa: Switch to use module_parport_driver()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v96azj9w.fsf@ca-mkp.ca.oracle.com>
References: <20210616142540.45676-1-andriy.shevchenko@linux.intel.com>
Date:   Fri, 18 Jun 2021 22:21:36 -0400
In-Reply-To: <20210616142540.45676-1-andriy.shevchenko@linux.intel.com> (Andy
        Shevchenko's message of "Wed, 16 Jun 2021 17:25:40 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0801CA0006.namprd08.prod.outlook.com
 (2603:10b6:803:29::16) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0801CA0006.namprd08.prod.outlook.com (2603:10b6:803:29::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Sat, 19 Jun 2021 02:21:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2918ead-e79e-4356-1f24-08d932c8f963
X-MS-TrafficTypeDiagnostic: MWHPR10MB1614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB16147AC2B8E0FCFD7327B2688E0C9@MWHPR10MB1614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BcI11fj+7AoJ8VILiFc1ylI/hiK1GWEKvzKF1Xp8G1jH+1T5cBk/sWO/F2uQ23GJlDZxg7exhzumLwUHN2mLZPJRlu6QXWV/Wpf2+XC84u/VUGyVGTj8JKQNf07vbma0iqihx36qDfA1QG0gnyxbrdqTDv5/cBuvjdtVRZzEyVyAMlyXqI7JucRNidLRxPSFUsgO/IfzM2NMrdRFVN6WlvtnNmtZMUQIv3wRYawWZzQwvZ7XZGhIRZjzs/7rpkAxK5aA2Xc6iN4DZ+lhH2F6D1iJiVx1YgiivuKTgJQofhUjRLTKHWfv2oEZ6DGskkh7K6L1wOCDzJZNIVScsVhLpWQXfzKwKfGGF7xbFMmBDTNeF40hpR3RwT5h2eSuY4eLy+XX3xCR4/gHlxMRWvS5wM1+2wc0cOtY4Y6KYST8aBuD6eFvEHUG9T0ubEQf/kiGpOA19n/SyJll2vCJPVegvBj701grJc86JcSHUb14hTk89aDmzMJC1oTFSuKI/K7RHwfmAenZ08z9MyR9thGkmRELlf+E8oNt1R1BhpX7qh19V4Mem87k8+e+y6WYPEkVF2xTy6+2OmA+WALffO3io0agpB1wGiiHqganteTlEmXBfa4o1FfZlvrFCnX/awFiBhIS+dvPtuNmZJKpNcDZtzRMnlYdpG2u2LA2yamB0DM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(136003)(396003)(346002)(5660300002)(86362001)(956004)(316002)(8936002)(55016002)(2906002)(8676002)(66556008)(66946007)(478600001)(36916002)(38100700002)(38350700002)(52116002)(7696005)(107886003)(558084003)(186003)(26005)(54906003)(4326008)(16526019)(6666004)(66476007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o8QCO4eaYDoVjbWNox1OonMxDJ3OQor5Ncy+yAI9K3lJwL2PI2DruuEZ+xAS?=
 =?us-ascii?Q?CxNuTwfIn7khBqlMRFBLZFj9TZS9SQEdzzyKdmx5D0WfsYjn1UC0xyYBw2GH?=
 =?us-ascii?Q?6p4GwADMzabwo6XCfHDR3b5oZqyOTsJm4uFYxYaBQvqzJb9V864IGkoPejps?=
 =?us-ascii?Q?dCl4ipDsGZZtueOdnXdUyCEGAjXXXuLJZwQo2xvChYsvZaAvpt0xMQnek+Ym?=
 =?us-ascii?Q?jmXHWcEpUMxL7+pqzun12XxV/BNhB449G0+CKPDXBkBIVnUWErhNlBT+mfYc?=
 =?us-ascii?Q?Os5KuW1UlpMtnD61ylsQsSrNPLnZSxtOORFTuP2Ey1QzswsnUFWvFhDJDOGZ?=
 =?us-ascii?Q?9rSSJzCCntZ3WbSfRwJZCj1T6QEYiad8ciFYliLM54+2uSwYnhamMiYcGUA3?=
 =?us-ascii?Q?occT2BUJtY8zFgd8EYXb/pJszhAsZqWKoCAyaiBXiDzsOOK/B6aFX2JWA3n4?=
 =?us-ascii?Q?Y1lmg52qCC692JFXVH+12Ii3DfXM/A3rcYde8a0OmEv2GfVcbj3wzI+2wqU3?=
 =?us-ascii?Q?JTtVSNaE2c7pA6ryt9/TgBkEG0w+yqUtN9CcmA4vIVaV41LVM1GlTVjXZkTk?=
 =?us-ascii?Q?Fq7CfsOahdcivqLXQFFIP1zkOHGb1dQzWKNo2tPf9nQf6c/D77EwRykHsHgX?=
 =?us-ascii?Q?pcjbUpabBf94edvUWgDdIz5oUJHJDM1m5pUF89sTBUhv+1JsV7+lgKK+D/Ha?=
 =?us-ascii?Q?TCdOYbGQoV0MyzMPmxEZe441pWkF6hiPcB9HXTpp+r3iTA9yBgFHNmDG0FsT?=
 =?us-ascii?Q?igS3naWmuL21VOExSk0IC3cY6R0tjhi9LbLT2mgS+KylyPYiP4eBE69MLqLd?=
 =?us-ascii?Q?es02ddoBp69h9+1tAtqRliqTCRlEUh0pzLwWztMrq150nTVKBfsS7O3vSnhQ?=
 =?us-ascii?Q?bSGI7hsEhbRrpdGDeZWvnG0gdPGdkgwNfnDeoelaUvq6s+U5A8cjhd9ddBQF?=
 =?us-ascii?Q?wwLSuKi2hInvbhTmAVZnZPkQS2kRdmIrM5JqEBP+onzRTKxHm6xBi9da7PFK?=
 =?us-ascii?Q?GVwRiw4YsYvOhlZCJ3xGTH7Wpr39u4nNucC/QGsGeUa04voQWe6qs9DJZZGv?=
 =?us-ascii?Q?1E5Y1dHGK6S1tgefx7s9uo+7xzCn/Yyv7PRMZYavkkqA90B8475m/T7kmEQL?=
 =?us-ascii?Q?MFGXVDQ5P3bQaJKRXhf0ORcFpfycz1pgoSm5ybiB9DrCU4d3LjBVJSCvQsp5?=
 =?us-ascii?Q?yLbtJhYgujpMfFb0m3gc+56yJsIC5eecpkXjzvTmoFlOnGL9Xj/B8s2GEBgK?=
 =?us-ascii?Q?g1dhBGi93bm5LllarTRVxh3FKmybh7W0r2SZaSvz2uqhVowQmuJsMvjmyV2G?=
 =?us-ascii?Q?8r/KmX5jGIJs3CnZpcjAHcZ4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2918ead-e79e-4356-1f24-08d932c8f963
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:21:40.9392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEvcGDYOCuOu5UIzLyYvenJGvcNbj0wLWJjcqgC/xE1Z3A4WKfIp1NTxeocrklPuFIkJdvsImpx9GOyritzbK0URcldtZsK9lSkDyUrLsu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190010
X-Proofpoint-ORIG-GUID: t5bABiMcjgtrqyb_Fbbz99eDXx4mcQKp
X-Proofpoint-GUID: t5bABiMcjgtrqyb_Fbbz99eDXx4mcQKp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Andy,

> Switch to use module_parport_driver() to reduce boilerplate code.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
