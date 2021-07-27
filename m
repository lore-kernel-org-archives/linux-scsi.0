Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F08DC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 03:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 062A861054
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 03:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbhG0CpU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 22:45:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39380 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234763AbhG0CpT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jul 2021 22:45:19 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R3BlbN027708;
        Tue, 27 Jul 2021 03:25:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=DzVeTZwpnj9wGLKS1cXgJoZqXIN29dGI1k+cI+2IzsE=;
 b=xDEbMdlxlmKMGBdreafIERT9ec0WjGl+cP3E5vMIdU39LG6EgugweTE1QGD2O5z2ycRK
 SLEyUr64oi8UtqcNUpA/W1/i61Lk7GDkCicr4VTypVygFtiwFI35neT0fpnoMxDo+s39
 h1kmcXEu4eH28BwZEKXhh3BpZA4kUSo20vpOgTySTOq08JqblghziRoMfYGjGxylpi6N
 S5los7ASlIyaras+yOtYXHnctM8rD+zkeHOh/yNci2hC8U/sv4TkxE8UGcPo0KI65q5V
 wlmhosvQ3mKrPnSewBaJE+FXxnDc5CstYoLcAhAzAVmegX7sGQbx61GhbSHn2RV4nrHp qA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=DzVeTZwpnj9wGLKS1cXgJoZqXIN29dGI1k+cI+2IzsE=;
 b=oqHqo88gyrHoL2ZrI5C+ldA32A8fGi6m2e+IPQ7U2ehx8jmSzu3ffVbWl/s2/3OphNX9
 nmNIY7BIfQsThdeJw7qGUMMTTfgPvxFgwf2NONIgWFvEcMBqVGLGWmQN8w4kiUiTKbFw
 kyP1aZKChzJgPK88f1KQlak4eyMtVrXIPZ4dyz/YyahZ0srJZgjTR2zeQKfoRYj2bwjp
 G9P4TPV3/a8sJf5pe6JXMpLjV0NGbSomADc1o+VTiEtGe5dt/Xls8a3LuoyPVPzOtbZ5
 eiuhD3Ml542DfAemAIdTLXh5Ywq2/hhZcfdxucQefgUPXzjudI+b1hNFANkSTWCLwQOZ Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2356gm3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 03:25:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R3AqWM050591;
        Tue, 27 Jul 2021 03:25:36 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3a23524n4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 03:25:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReoZU7funmTfy4Y57rCsWarEKF7n2VQZNy/ieOFVIY+h0mqMzJr7wVQ2UA55LzMDHYTFr5CCTrX2SUEktDGLo3IbfrStCCkS1rUOIefY1YDl7UNbmFya2FxouWn5LC1INg12+/CgNCxUk8eJecogn46vMVLkWc6sTqMLfwoO1FCfgXocvdvHhmuFM86UK4sWxWDjUC2Q0aXSHF1AvJpjQ5YH17mn3egUea15EGCW1wYBsEPlSK+5l3k/RoIWZtc3+LSM6GPmNhv1f8NNMar0KvwQ/obtUM7QNURBPzm7R1yuXv0E24zsQ4jk19ICWfsBLEFHAoC67BTmZdRxPyf3Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzVeTZwpnj9wGLKS1cXgJoZqXIN29dGI1k+cI+2IzsE=;
 b=jNeyer7m0rgfZwfWGvPTrO6UUmfSseePLizFhxhAWr1vFOPIoISWLQP8V3kGvu3wWcHS6bZLmlKSEviVeRU/6ShKyx9KUa/2JpaksL3jt+2xIF/K7Xtsti9Z/JQRJFptyiSHHPPXqGL9Cy5E/emB4I9Nh00DSUVafhhZZtfa+wST2cz5dM2+T58EesVWZ486xLUazHMEwkw+hfbtWF4qmufi5Mg4Bms8vwoYOrmMnbvIPUg5fFrR+7ojIEbRSRCRqVx+DiZoIc18VmSuEI2CaF8yn/9P8cyKjINvdjv87X6VT+i1qA844A0o4FqrOSpX3PlqI8qorQO1rCRvPIbjIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzVeTZwpnj9wGLKS1cXgJoZqXIN29dGI1k+cI+2IzsE=;
 b=NRTW5uVbHgSjstUBil72/c28Lhqfe/7pAGC/BCZtqnXtUIYJqp5E0oRriWGjuTzoDiCjK6Bkf4UtUNO3R1az+0wFcsrzNMpKOt7jsUK5dzL6m4VvX2IlAeR8b6OnZbFu61J5ZuJbRAQygb7edg9UWZk3uD/PhzQo+hazGCMVt68=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4760.namprd10.prod.outlook.com (2603:10b6:510:3b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Tue, 27 Jul
 2021 03:25:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 03:25:34 +0000
To:     <lijinlin3@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <john.garry@huawei.com>, <bvanassche@acm.org>,
        <yanaijie@huawei.com>, <linfeilong@huawei.com>, <wubo40@huawei.com>
Subject: Re: [PATCH v2] scsi: Fix the issue that the disk capacity set to zero
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135s0qw1w.fsf@ca-mkp.ca.oracle.com>
References: <20210727034455.1494960-1-lijinlin3@huawei.com>
Date:   Mon, 26 Jul 2021 23:25:30 -0400
In-Reply-To: <20210727034455.1494960-1-lijinlin3@huawei.com>
        (lijinlin3@huawei.com's message of "Tue, 27 Jul 2021 11:44:55 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0009.namprd02.prod.outlook.com
 (2603:10b6:803:2b::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0201CA0009.namprd02.prod.outlook.com (2603:10b6:803:2b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Tue, 27 Jul 2021 03:25:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 217a035e-2f2b-421f-ded4-08d950ae31ca
X-MS-TrafficTypeDiagnostic: PH0PR10MB4760:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4760F65C0D544D3028E880CF8EE99@PH0PR10MB4760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /U1QcjTr1hbpiSQlPqL+xPHCyLECOWLCOQS+ADf619dl8XJaI3gxkM7EwYAM9Wgj0rDsoORk+xSFiI79nEFRoC+dZYmSSa6aV9LY5GZ7Qrigpuv7nxqB6X4npL7nOMuCQDFFgDQF64tETfA9tnP8YykCfNjM0qZSWfByB9+r3qRW+hHemlE7o1P8LTQQnHqvZrABwLZwjjGm5FtxwePGl2SFfmzF74KlehY6cOIjoD7mDC/HAtF8iDU6rLipr2kHUWkou4WHfgMcSUss6tM/YZFYEA5udqu9C9gZZYak8zaPRO89u4f1/DZcOUZaQifm+iLQOoT4UcTFLe/zkK8OEBzjeF+MMKm2/o6A5oL/c7okFDtb2boubGrIC4b/0qCJjIhkJPiV6TvJVVMnExxsrCwwnG98MdXAQrHkyQNJOUkYL8e37KLYzHXhtDdxUettro6gn2jcpt4UYiFI9R0+YD3EAIH1lAkxlqr2/zzoHNPm7Cv0q39LKUxRpqfPDUAgEu7vOclTwE8ErVfb9OctvXaezkxh/l2jNhTUcBqwfVaZpd4E9i2RE4W5Cyxax8cXWHskfgc23M4F2A8Zf4mOB8TnfJS7GpufhiH3d5C4TD73y8JmmC3M40G044MZsB6P3xzybyMKIFAudzXBZhQVMXAojRN42pxiERIIwLHcfppeCO/4cKCp2Pmus7yhZked/6hQmIfEccPth4QNQPRLcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(136003)(39860400002)(2906002)(316002)(86362001)(6916009)(54906003)(55016002)(7696005)(186003)(4326008)(5660300002)(52116002)(38100700002)(66946007)(956004)(478600001)(558084003)(8936002)(36916002)(66476007)(66556008)(8676002)(26005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GqwYlFv04EnZJsy/mHd5CGBM1pDZkzcNglltenh23H3vQ5CW0kLzzT6hVl3M?=
 =?us-ascii?Q?DBKvXyKwqFJSl6fQkGZX6ERCgd7RODubWYPtpHOrx0we8xsx9afofrIZRjOa?=
 =?us-ascii?Q?rqSrURoSrnooeHD3WQQVpByaL1kQlig6SRftnWEaH+OdLm/5p5xagp8k7Zeo?=
 =?us-ascii?Q?uUIjL2bsuTkxn0vGquwG2c8ubSBf9xen4qCW/xqcsD7E7XOHSWob6Wc2X9an?=
 =?us-ascii?Q?lC95g2/496NJGLQOTCKUm1VO1hCddwMMwYxGk/Th7EXZ9FvB4cHql02UU8GZ?=
 =?us-ascii?Q?VuaBJjZk2Cgr4hRLbmLDQHwayNO4bqK5lMOmcTAGQVyOnIe8XxDfZS/IQ3fm?=
 =?us-ascii?Q?7eIykKIt4nOfxRg8SxawJ0vNah+8d54k0W+/Wq8Qfaxv8UfskioUuNkcLJXB?=
 =?us-ascii?Q?CLqg1wxPZPTH4M0yNIgieyIx2TTRRDVAlnajtXEqkABb/FJAoQ6PJwEss3OC?=
 =?us-ascii?Q?MHVtv6b3YUA6+Z8dv8PBMW003TZfWPW13pkvro8AcjKg+DeUxOESMHJQFlSA?=
 =?us-ascii?Q?wzj57rZ7PD/Sg81lkq7cumA30cLBYbQCpeDEZ/b08TUGGZGPknRVAvAZB//v?=
 =?us-ascii?Q?7CLxriqXjkEMCckcrrc7cMdL1tPOKqMZRd+U2jsFC5SLXJJM2yKsg3ONFRvw?=
 =?us-ascii?Q?r2Skpxfh/rHpy+bhkak+bwxnuu1WZ2rpJdZQ0oxASL6JgDd2XO+76/a6epR4?=
 =?us-ascii?Q?+xwH66cw+s8qtNzjA0NvheO5aCaMpHzYl9IWa1Rqxh6RjxtQ5DT3lF0TGsVL?=
 =?us-ascii?Q?CcceJnbioeIsZIpfNntHlYY/JUw3Wfu7LmDznzMzGeCr6KIq3b5cDvr9Gz/V?=
 =?us-ascii?Q?rF65lYcRoGvMsf1PtfplDhVCa1Y3fFmuS8sA2ad/M4/8mqd9mKaVuHhgQwb7?=
 =?us-ascii?Q?MyOVyUpeJVQ3pMHOjvBOpdo3vitCrZUxzTJpg8a8whwQ/VvKB40bDKFwnfmY?=
 =?us-ascii?Q?/p718b0/6qOf9SOs7t15R7SzaOnho1ZjUJPNxoLV9Fi69dqH875bBTjO6EbD?=
 =?us-ascii?Q?A88JUyOePCB2TdO9FtwT+fUKZGhj4/Wg0nRgS7ZKGxK78gVqMfUJ1i5FB18Z?=
 =?us-ascii?Q?RXnHCaAf5JhzdyIapMtxnNar6iDCpvCDb18RapweNLcEhibao2C0KvFAOmjM?=
 =?us-ascii?Q?xwHyrirRIOPOqPSn2snNKp5oRQw1stXarfenxSI4OHINGyM6uCisFZ6/zJT8?=
 =?us-ascii?Q?L2/kZTAGzbCbipbXSCJwDCwysC7ZMpD2yJvY89TxqPPEHvpLzthjRyzSZy2K?=
 =?us-ascii?Q?BpiRLCAax6ldid4Xu+OuTxkNE3hhRsLV15Aqo3Es6tejaEOhN3/0DS1q+tTu?=
 =?us-ascii?Q?+1EddOvFllH6MYlCmglh5pue?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 217a035e-2f2b-421f-ded4-08d950ae31ca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 03:25:34.0800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o7+aZWp6pnFh9ZFxGdRhme0aP3nVWpImv3dCQvExTFW/01ypV32WWDU0QbpWwFZ8jpLvyv8Rag4M/pFUqCOFnQPXrdyViiEZIzP5OoBasrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270017
X-Proofpoint-ORIG-GUID: qzk41B7k_IZ3ETr6Pjie7y-3cVFnE7MY
X-Proofpoint-GUID: qzk41B7k_IZ3ETr6Pjie7y-3cVFnE7MY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


lijinlin,

What changed in v2? Please make sure to include a change log after the
"---" separator when you resubmit a patch.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
