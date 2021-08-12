Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6A6C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 15:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92586610A8
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 15:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbhHLPKu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 11:10:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16290 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235052AbhHLPKt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Aug 2021 11:10:49 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CF73Bo011398
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 15:10:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : cc :
 subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=pMEUiaEUSukLI9Yubrt8ohMIUJhR7TDwdY3J+cHlRKI=;
 b=GF2Z3vZglPopT/dqR4eF2LpLRMIgbeINtgBJx6Z6rotrJwbUZDdbtv8+Jos5zjtVSQlP
 o9E/ni/Ty6M6w5nIN0ii12nI03MvK8EbJLws8d3ZDjDbe8KANNl4mF+ln3h45V6U85Oj
 e7qLSC5VTh7CrNOuvr9uND82q6jiZCje5EX8Vl02+WWwLQqcmZ+RX32S7303bcJiSI+L
 P3M8xnDpI331At0dEe6quq51GczHtNERBypTH7uW9cb2aJSf5oQtrKVEPNDoYQ3szxBd
 eBroqagfv4E29aXcRzxI/izjTSS/TRPMEPFvB4q+CKKnGdyUoxi1QV0tSOu4E166JScf VA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : cc :
 subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=pMEUiaEUSukLI9Yubrt8ohMIUJhR7TDwdY3J+cHlRKI=;
 b=u8gkJibOaehlGgkjK5n38/0yMaY/KIcSEX7PBFV9PXZ2K6KI9VCc1qvSAWX+gUjw1WOH
 fqWGynu2uJXXwnkX8N7Vvg7qEHnCadfh+cuBZxdHiswjQbwxhewsZr98dHdamaKPPSZ3
 Rwbginz/LC4I52Y/Y1AtlDsJotvF3yZmTW2fo4f+5/+Wq+byejz05j36QEEMpCSFDwRN
 tAxKEfsQq/XN6RJQyjPwaKM2OWLZeU63teHnc2bXLhJLm1ZkLjLMKfs8yU8c0nbR+Jbq
 dvH6UsYxOG/35sSIVu9sLPgrSRFy/hnPsZIQiVMR6x/RgHWN5+4aosRB6tWvKdGJPU6i Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aceudu4sb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 15:10:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17CFAGDc094559
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 15:10:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by userp3030.oracle.com with ESMTP id 3abjw8rpy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 15:10:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSOWxRphQnUrvQxQNuFFONkrNegOm+EWZBIate/9ctp3rYO5CUT8PxmrT2cYh3rkOq5WCuGx20oIxaVlNceG2hVpir77QM9wdoxkcP+F4zrWHiUk3NFCzsneBOBrhHIFPdwrF6Lc3z8z+lZ7VbkqTYtaSz+TY3kbV/CGNEsD91iVMvIlhXy/RAXiHXt9/zjlCSGzFEhCrDP9VUUajhKDTb8AvTMvi1BTmR7jLd1e+JqZAJIiJYU29zqHO1UGqPA0lZoI5D5g3u47cm0n0Uyqfi9sx1VXrbiILTQ5950+Ahek/49WfOKlV3p/gYH765rP2xya7/LthY194016Zxx5ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMEUiaEUSukLI9Yubrt8ohMIUJhR7TDwdY3J+cHlRKI=;
 b=dbqSTFe18heafmkrVRGtLH2GCsdk7ynGH4Qxu4mYsOnhmPWaFvhcBonqLgfmjRTk7E3Wp9lN87ntTCsATzsdcSSNg1rzs5IzJaz5+qNkegaEThztv7SFUl9B7qZgVWN9iGTwjequqVX4tR6yvc+WgJrxYb5BZHWsp3Nok/MySzgpRY4gMQ7wgQ3D3/QfQ8RHKn+Uo9CfDUmpJkueArvMYJXCSqx+smWzedC8UQnjgUn6jWECTzrzT74aQSdbgCDZnd7+IQ7kd9N795jG2pTf2Hc/swI7fNJSb2jmfPNinwtL5BqqdzOO7iiq3RMiMqeXG+/Yv7l4B779a1mmyl37CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMEUiaEUSukLI9Yubrt8ohMIUJhR7TDwdY3J+cHlRKI=;
 b=HK22kTHpBT5fln/d2z8GQA7Oz4OBykqpnsdh4sv45B7TnL7iIMQpjYYhKy7BIDZgz6eNHmdxLECbS9+I65s0oQFEV1Uix3Y8z+Th5mraUZeuWd8EuuTSUXWu7SHI4gI42LZp217FeHLT2R3SFuSbU4E/Sb5J1dSRpsbz5iAKB2k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1359.namprd10.prod.outlook.com
 (2603:10b6:300:1f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Thu, 12 Aug
 2021 15:10:04 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4415.016; Thu, 12 Aug 2021
 15:10:04 +0000
Date:   Thu, 12 Aug 2021 18:09:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] cross-tree: phase out dma_zalloc_coherent()
Message-ID: <20210812150954.GA18943@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: LO4P123CA0429.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::20) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (2a02:6900:8208:1848::11d1) by LO4P123CA0429.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18b::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Thu, 12 Aug 2021 15:10:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd223e44-e4eb-4ea7-f98f-08d95da34362
X-MS-TrafficTypeDiagnostic: MWHPR10MB1359:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB135981A32B34970802518ECB8EF99@MWHPR10MB1359.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kQQx3WWTMTTERJdLgqSLQSazzSVTDL99fverO4iAHt9TDQbmguafL5fWiUmxqjcZm5zEYJ1GHX+3PT/wZAFZqwmOox9z9m23DfGvswmwn67wPDOhhqqzunmPg2BPwXa0Xp7ZdEtwTZmmwPx3uoMVcGCjCeXkP0W7/oI8igrUkiI5NOMT6k6swrOCJ8urHIThCSbkrObBC8pW+ub+HgTk7c5jyRTob0dWGwqgjkYgZdRzsfAuv0Vv/ZSzTj2S1WynapR/EBacvUwD2pszofrP9EJ39wtN6fvaM/TizgY3CGB/FGDPg5JjP46sykZRxR3k65rxANx0O8vmZBtvTv+q1WmNINK9HN0fJQ+E+KgrS3hAMC1sUvbRAgFdKcBE31NqEEy+rTEkH7zzJte2jAHhNgw7frqd+jr0Sjb7XP64pS0AoA3r4SMTGyRavkDzitiC+afJEdP+jQJ4CuJmDl5fbl/BitbI225LZbM8+eIecCHxAbQWzFRxhMpXeOGGEM0uIWdUtyze16CBYX/LzwyEJy0uQUHjXpO66IdlwZxM6UVzoo6j+eizG9RcUbp/+uwkF9B2RNHdXwnVEp6oSHwFn0E7NFuRCEfFl95wReTpS9NGcXhOJRvgSgvT1Ra5hSoZRZM0VzPZq+t7EcUV0SkwXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(396003)(39860400002)(186003)(55016002)(5660300002)(9686003)(316002)(6666004)(478600001)(33716001)(1076003)(86362001)(66946007)(66556008)(44832011)(9576002)(66476007)(8676002)(2906002)(83380400001)(38100700002)(4326008)(8936002)(52116002)(6496006)(33656002)(109986005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kPnpSl4s/PDmVV+uCrSoHZRrXDX+u+IqQUFsQ1fesmhj/1bVejNbr1GPh07p?=
 =?us-ascii?Q?b/K4j1oiYGpVgM4zrjpFJHf1Bbm8CZGJT128unds3+k4VPWGMGBWFpc0jzcM?=
 =?us-ascii?Q?Z6C6PZmcEAF5T4/ggqxoOnjz1caD4crfwIjtD9mFJur4/pK4VSqNv6eSckMR?=
 =?us-ascii?Q?hWuWJOpSw1ig7wk26P0b2eKdDB2QxZ0fLydE6cfui4L02LT9BcIktAfTxZRb?=
 =?us-ascii?Q?LH4e2+FeCFcdVlS+ZtC6d1ZnMd7NHvMer9IqbMK7m0+ZdPrGlj2eUwbNUWGA?=
 =?us-ascii?Q?tTkt3JNql0NEhrI2ZTe/sfzTh+K3c8BFFKvduOPPutDCmTE+WNJQrVU4KCJz?=
 =?us-ascii?Q?UatK8uSPE8S5d0EAsqJ0BJjnXowVLLRvH5gpp2nXGoDMOV5LrcTpslR+Hjbe?=
 =?us-ascii?Q?YBtv+yaWBAKNZqMiexKtIyC6i/haIaxUYynyPgKuRpRBJWUIU6U01pWI1MDi?=
 =?us-ascii?Q?MyZacB4A+jtgLC4p4bPPO/3kyg66uhvArNpUHEL8vgZKm2wkdvJ4DjrFkQXM?=
 =?us-ascii?Q?CZd3OfF6Qch9wNx4f3XIJ7bgA12K43vPhci+POBXrGjUcaSqOH6pTAioHBec?=
 =?us-ascii?Q?YH4GQhCBrCJIjUhZFQjSvq2B0+RkO2W/5ibf/0LZCeONVSnebRpbKceB73E7?=
 =?us-ascii?Q?mMTOBptYWcSqvqlffwLAbudNH+oc1c0EjLIHEm1qeRa8G2rjKlSsit2V9Qnj?=
 =?us-ascii?Q?ypJ4UW7fJ1rLmANIFjveqMiAQZI41t6iiPyZvvhMf1C1tVzqcwEREQDurT6+?=
 =?us-ascii?Q?KCHMrRck0+xlZjJSA8fgiEYwo0Ghapry/ZYaTC+9DRc+evtgbePWpu5D3E08?=
 =?us-ascii?Q?fmxVzZ6kuulnRj6ARnYD0lQAG8G8dSr92L57yy9b+SGhlwp0VsHTW35cSBfh?=
 =?us-ascii?Q?M6hNQSwfa/Git3gnt7UVglgh//Y5BLHZXsaMkRevtrpJYfdTAi5RBzeW2kZu?=
 =?us-ascii?Q?amxxtYw6jFObdOBt2Ylpo7d/8DO9/WkOGdNRAuSNBHg7wLp5LAd6NHF3rR2h?=
 =?us-ascii?Q?jO8kMRDBIbuoskRmzQaDNO2ndf/hPxLJQEm1AnQo1XrXgSgiY6BSYiA/+ESz?=
 =?us-ascii?Q?H2bmMqtEuBLz4SbmPPDtqMtoXlva6YbGcP7rl4mmNcvSvrZ8q76oc5MuvdTR?=
 =?us-ascii?Q?SaaiPvSYKnEGlhdF190Vhy/OmqM+lp9yFzBxP+g+zadbTbbGSyc+zuejDg33?=
 =?us-ascii?Q?jftaf26gs35FUygTIP0Bn+BRh0LqIEmgyXf8dSouRuzOMTe5rGZLi7VD7SQz?=
 =?us-ascii?Q?JVQiDiB32tz+uHEZfU1LEIZAsv/ILdQFm25ss+tHA+M230jfoqkGIDj5pWzk?=
 =?us-ascii?Q?uGt/IRsmHeyq3ePvYW0WqWswxxuQjkNWLqy+K6ZV4XLPRQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd223e44-e4eb-4ea7-f98f-08d95da34362
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 15:10:04.2937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qVojWvnWZ2mbTGf6o4Jv//Gl1gYiIpEkPjR6UF/hTwzaYdEJCrQx9CUZ35KjCPmaV8IIqlrGRXpwKfpwqU0yO9nQcHDZMqR946BASRQFHbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1359
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=790
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120099
X-Proofpoint-ORIG-GUID: vsZEPvEwe0fkHRiG71Jv7Fj5ZakawwPt
X-Proofpoint-GUID: vsZEPvEwe0fkHRiG71Jv7Fj5ZakawwPt
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ancient code leads to this static checker warning:

	drivers/scsi/mvumi.c:130 mvumi_alloc_mem_resource()
	warn: sleeping in atomic context

drivers/scsi/mvumi.c
    106 static struct mvumi_res *mvumi_alloc_mem_resource(struct mvumi_hba *mhba,
    107 				enum resource_type type, unsigned int size)
    108 {
    109 	struct mvumi_res *res = kzalloc(sizeof(*res), GFP_ATOMIC);
                                                              ^^^^^^^^^^
These allocations are atomic.

    110 
    111 	if (!res) {
    112 		dev_err(&mhba->pdev->dev,
    113 			"Failed to allocate memory for resource manager.\n");
    114 		return NULL;
    115 	}
    116 
    117 	switch (type) {
    118 	case RESOURCE_CACHED_MEMORY:
    119 		res->virt_addr = kzalloc(size, GFP_ATOMIC);
                                                       ^^^^^^^^^^

    120 		if (!res->virt_addr) {
    121 			dev_err(&mhba->pdev->dev,
    122 				"unable to allocate memory,size = %d.\n", size);
    123 			kfree(res);
    124 			return NULL;
    125 		}
    126 		break;
    127 
    128 	case RESOURCE_UNCACHED_MEMORY:
    129 		size = round_up(size, 8);
--> 130 		res->virt_addr = dma_alloc_coherent(&mhba->pdev->dev, size,
    131 						    &res->bus_addr,
    132 						    GFP_KERNEL);
                                                            ^^^^^^^^^^
Should this be as well?  The call tree is:

mvumi_isr_handler() <- disables preempt
-> mvumi_handshake()
   -> mvumi_init_data()
      -> mvumi_alloc_mem_resource()

    133 		if (!res->virt_addr) {
    134 			dev_err(&mhba->pdev->dev,
    135 					"unable to allocate consistent mem,"
    136 							"size = %d.\n", size);
    137 			kfree(res);
    138 			return NULL;
    139 		}
    140 		break;
    141 
    142 	default:
    143 		dev_err(&mhba->pdev->dev, "unknown resource type %d.\n", type);
    144 		kfree(res);
    145 		return NULL;
    146 	}
    147 
    148 	res->type = type;
    149 	res->size = size;
    150 	INIT_LIST_HEAD(&res->entry);
    151 	list_add_tail(&res->entry, &mhba->res_list);
    152 
    153 	return res;
    154 }

regards,
dan carpenter
