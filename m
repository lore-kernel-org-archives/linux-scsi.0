Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADFAFCDB47E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 18:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjJMS0r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 14:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJMS0q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 14:26:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC95B83
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2023 11:26:44 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DIEBYP017421;
        Fri, 13 Oct 2023 18:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=WTcNEhyE6xFroO7NlUzX/NeiduADCSNbnPGWS7aQGL8=;
 b=AprKuBRM5a5THk1hPTkOUIpu0J1dvfNy3POpfwlosI/VkY3pZgh+R95M0PfPhrLVJYzK
 03lMsjqfBIrp9AEeNbj0hkZ9AYiER4NKArLtYuo49WJvt0rY8n1wxCx0eNh7kMT1WtiL
 uuN0GBh5hxQOuTY1ek0wctA/UOjiUOqls3MubAZhSttLq+gR9yXewpSs6zdwt2xCS6oT
 HW+xHa1w4p83jxy0C6JdUAhx6zfU9zWHxaAayKVAZ2klVcD3nMXmwlbWQzspztboGKtw
 oF3O9IDjIjy/hXIIjtyF5dECyagAuyGR4gQezDdsjXc04oDhCUbJzqr4KuVX/oXNfPqz Tg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjxxudkps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 18:26:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DGtbRb006016;
        Fri, 13 Oct 2023 18:26:37 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tptcsr9db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 18:26:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zlk7JMtHwhFhrI4t6SMilvIeEOX9nsojTqr0ZiST/mlN2p1osX/fdVym37mLCU96Z99/DhjGuZH/tQHLkB88ogHfwK/Nf93p6Bsn2danwsG0zQPa3oORCrOAbMQi2/9Tx5Hdihwl01Yb1Tvx8DerWt7HQr+7PI9aZDaG66x5mHOqYnsERI8sYi4BNbBfcnee+4t9RRe49/h/AThWz7KT89mlfGWpqs7udomvU7jZfTQngvSP+lX+gETDj7+UP3EpMMUKE801CHWHVOTAKU9dZ17WKHfEsxIC7zyJSUFNF8WmsEP76+79U5GWkx3Ra6xLUVeYOB8Fsd3N9YsVV2QxVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTcNEhyE6xFroO7NlUzX/NeiduADCSNbnPGWS7aQGL8=;
 b=EiiMZeO4ssD10jiYvjl/b1YdSA5q3TdLs2Dggv6GabCMc8yf5j08uXDSTPCExPaOMWltgtprhUNuo8W9KJR3t/pGy4NPhvFQKcB75Ffbag2W9o6vkwDeH0f4R/rMH0f0kQ3HgJQnoYvE8Us3dNjU8XGka1Ahwx5qA8To3ttl+t4EHOGiPeUb4eboeXC5X15nrubCIaZEyAytKoQZJDaKdsGwwTNlemFapzSW4lF3iemWcQwl3tfvcUG9GcaYM8z+ZFq14B7W/BduDfBhw1/VCx/Aoj0NLhyfxE2CtfRGrBR8LB+KWjCdgz4P8UrLR/vvufuU7WPVpFa9lnvfdVIgZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTcNEhyE6xFroO7NlUzX/NeiduADCSNbnPGWS7aQGL8=;
 b=ytDoVmBjEyZr+IJZo8E5/ogMfkwEXKuyckGwr0i8GJ2l2Sirh5Kv7ckiWUq2RJhDRVjh9BcdR9PD44SJcTmfX+rTNoKOtJOVkd7qoTx47o9A0GQVLPFqCeLVExPanEccXwEkJEBx5FEQlPYl+ZNFH56m1kie4QZowxp5MT8PKCA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5351.namprd10.prod.outlook.com (2603:10b6:408:127::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Fri, 13 Oct
 2023 18:26:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383%4]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 18:26:35 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv5 00/18] scsi: EH rework prep patches, part 1
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lec6l6pj.fsf@ca-mkp.ca.oracle.com>
References: <20231002154328.43718-1-hare@suse.de>
Date:   Fri, 13 Oct 2023 14:26:32 -0400
In-Reply-To: <20231002154328.43718-1-hare@suse.de> (Hannes Reinecke's message
        of "Mon, 2 Oct 2023 17:43:10 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0078.namprd05.prod.outlook.com
 (2603:10b6:a03:332::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB5351:EE_
X-MS-Office365-Filtering-Correlation-Id: 78df1361-da12-414e-1817-08dbcc19ee6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MAYy6x7eFz0BVGqmDEbbJz5sAAJLAYndMMhx9eTa3UMt/la7o+FBm0qmiybbfseKIGNrEnEmbEgBMABzYFyV6hZXEu/wGfx8HmxJPmzYF1Mj2zcvGTdo07VjrIG992uU91RIm2py2qXKzxri9u65rmpJEKB2LyLQB3PlX1H8VKsZaDwfQGK/fAVvQGIZNG6JgtYBTqwNefMQgaKqoXYzexhTntierrDJaQe+chJis1taOUMNaHbVCKxviJJFMGRq1KLnN2+KjLbehlKRVHcMVDqKfXmmIHQXB+MiBbXl27hPSlgs6bz+Z242cAKPO5CVFm1Fh+nYoNCoNU+6hpHqRf1TO9lYWCeNowpjl/ldeuFaHJeoxFz/LLnpKJIo+XFFrJOcBBFUstxOn2UEXaMndwCSzUfw+f1qccXCOtoon6eWrc2w3gYToZZzePqqw4encXG/bVSWeHZ4Z3K0L6LE5gqhOrigX/a/Psq+dsRry7cWiupXmotU/HJbvL2J8mTtc7kzuNy9ap4URjtucWDDxmEjZRav1ZAIswKIcDZsp+4HKoI1UqaJOuCyX+NB9mhp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(39860400002)(396003)(346002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(6512007)(26005)(38100700002)(478600001)(5660300002)(4326008)(8676002)(8936002)(86362001)(4744005)(2906002)(66476007)(41300700001)(54906003)(66556008)(6486002)(316002)(66946007)(6666004)(6916009)(36916002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZU9CN6UeOI/Ll2XoHZWS/h8OO9fGQ2RehLjWgvSNuhBgeqka6z3zGP6D4rHt?=
 =?us-ascii?Q?YJhMmxPISXYQAOWwSUFEHAQ1hYZ6BgiAs+yHs4H3+Uptfcwba9+Ib9PHK6tK?=
 =?us-ascii?Q?cIQuGuUWt0RUotgnlgokxMwWqGhN2ajAjLaiUlrYKMlO0PQNDKF0cOgi+kt3?=
 =?us-ascii?Q?k1SmnvdI+aKSnbRZWxsUOJJBcSWQKThTo1775oRXP5CKmazVnR8NI1WZBkfK?=
 =?us-ascii?Q?MTjAJxFHzIZttMbK7S40w/XNS+0/HgI/jqY5TREfYjAqJFlYMTt8nAReUWA9?=
 =?us-ascii?Q?P9DfmcYNt2FlmIHtKIsnfXbRks3HA2KBhNGpVFXZ0FPtZTdu6uXFNLwOxDn8?=
 =?us-ascii?Q?2KstZcEBOW9vS65dgBiMbHr1MNqC1C79kKTz9gqDGy4Usx6D/4RppG9jmUtk?=
 =?us-ascii?Q?rQSBNLRZJWWsBoCfoOG4wFk/HEqjSs0sfqBxPf9ssjU/M8PUvkKia5zU+HLs?=
 =?us-ascii?Q?Cneaoj6uPXSm2fkeQchJx7ZxbIM0T3iGZxsWykWBMoOi6AlyPVQKWX/kdGg5?=
 =?us-ascii?Q?v0mq2cUA3ko06nwMTQ+feLiQcrA/o7Y1aVyv7/wCN4OzM27BOn3tFhhuupKY?=
 =?us-ascii?Q?5p9Tmtr7lMFnN9BZLVsqVzxd6SUPIN1+7waGqQ+AVWQoNgG7HPrrSNKbDTqo?=
 =?us-ascii?Q?D97SF7ESXhVlmnHcu+cYonpbkkLWRKst+IesHe/EZLr1sjJbiyELLQhyP/Rq?=
 =?us-ascii?Q?bL4kDCr6t0W9q+Z2BgjjTnUvhDWkiuLBqrntG2phUKPH0OZv7RJJiz7BIdw6?=
 =?us-ascii?Q?Br4Qqi7mqJRMkljhsrjSoHpOCcMeeH4fPU/aPneo63Rj5iRoi9HJltQb7Q0B?=
 =?us-ascii?Q?X6CROVbWqs/E4mh3Iw6BukhnuE+NUEm94Xlf6x4aRfD8rKYbRwo6JSOTU9IN?=
 =?us-ascii?Q?6MPq5gfPPXsclmkG9faWKg/eSqRM8sZrf5lHhTbrsThOaP7NdMxDH4w3pSNm?=
 =?us-ascii?Q?IzW98sqyYSuInBjXafrgKlJEsVQEqrIFut7w3ZoFHnMrjpcA4yFao8nuO/GU?=
 =?us-ascii?Q?ItiJJMqwngNEGujnxfzr/y3P4ipcdRpBRu6Zii2wEjOEKYY+c7NyEfv8P3ic?=
 =?us-ascii?Q?ZrlhsyRY5SewQ9iDF9uU1QJ72WRAl5aR9IiwkhQ+hGCfDkvH09Bp560VQIdV?=
 =?us-ascii?Q?qjLnTaC7GdiZvY1i2BfAGucWh7UOHgJDVEwSpMCWrGvoJIg7NTBSURk1m3TY?=
 =?us-ascii?Q?bn6q7DhtQ2o05Ohcscbi8qclfcwlg67qv7WXOFShE2lpD/JcWo9tkCgwMD/2?=
 =?us-ascii?Q?I7XCLElLVLw/pyveo7OUm0lzCEVNeNaTZ8/LEORcnnYKuExNj86SIdqcJgia?=
 =?us-ascii?Q?eOmK3VBXu60WdxwVf29u26Ht11iJiIolxQuofP/713VfbZF9472D8o5ez0Mo?=
 =?us-ascii?Q?t4vudtpS3/DkRBKm2/f4A5ZefSZFoNf7v+WUDtFCrMdJ1mkX4H/JwzlPXmka?=
 =?us-ascii?Q?s2438Iwbv1aB0RjvAbOwCFYalheLavG+DW/DR3CXjrG0+9Y2N12Jbao5bZly?=
 =?us-ascii?Q?RACurE6VnXGBjBYYH6VpRmlAQgE7sYur4hs2w6KYOqmHMxGgLygH2YW5lUbk?=
 =?us-ascii?Q?eBAHZiGEHx6YaWI96i63E8RbxEyuzgb93DLWZARE02gp3u+Hu2RuTHUXs2Ov?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: CpuiXztuPOKUiN55g/+J/O3ymdwDFyrAhu3V7mivJcKgMQWQXZOhpyNIMck28oo2qDCbWY/Hwd2GTu/ZylN5S89EYjj9uVpNERLNf/EYEi8rgvSDfgPfJBOTqq5lzq2LpyxfHj2vRuMPzsqfuWmpzPGmCm6I0dm4sty1fBde23vpJCOCEx8Cvvk8DxhlOmTFMpKUdV2wQ389bRd+M23ScYJrCkO7lnB/S6crmQBJdQaLo/W7D1JgKYMBxFTlrbH3jo69S1YO4jYnD+dMSa19kCevdusfWhTK6adgcYcIfFvImVre8lCXTg/WqXGcC0kRSSM9lwH/L5V2l2v9mp/ZDPZQLCLirAS0s+I++8Z+5sQUjnQCVwmcMqdDNn44/FLTUdVALu3vu3k71QDUoXyPSMrkBuTO7Pnwn75JKiFVznj8NC5VMZ3fH+cVQrgnZA9kc1e4luwDV1GSpZINv291fBTyDqzdCH+Mla97TOQNxUCIiHj7hKtws0NwF7pXRiKhKcoMaZocM/TN00zu0Oase0velSJqri1/HuY3eX99nedovThqricuFd9CBgHysS6HBVmb53aFbpsAO3Gxc8CfEBYWE1+NmTaU4jqT67T86Ex0GdisFJKSww6P8Xkj8YXN6sFgtbpGsCxTWZ6/GNWb5cR5S6JlGy//pFrXLz6TMVtRuWXQm/PT1JKYjrHc8o/2aRTsni/7OP2hbw5Qp06C1CrsH2hmEiu+8ZlU1DuKmCKGFpR7vlrH/jGpzRjNDG+e08G7THZFexmnwh7Aj0jPYMZzJfcdlIDB+7tCyHAyaPdMbLkfr6rK5IYtR7bRDIKhp62qTSV8mIlS1/pKyGC6hSngsln/nkkkqVHgNZAjGio=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78df1361-da12-414e-1817-08dbcc19ee6b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 18:26:35.0313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkMS5nyCUXmvaNQnx4n0NwbHCQ5ALPhzRPYopNNlx2hcEl5n4cV1QysCBasoDIJmnOIJYmhdlrlXs+qsD1ipBNfUzST7SwKjLSvm0g5nf1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5351
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_09,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310130158
X-Proofpoint-GUID: 6Ijf0O0geYJmd_lKmSEuisEOguUuD2ga
X-Proofpoint-ORIG-GUID: 6Ijf0O0geYJmd_lKmSEuisEOguUuD2ga
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> (taking up an old thread:) here's the first batch of patches for my EH
> rework. It modifies the reset callbacks for SCSI drivers such that the
> final conversion to drop the 'struct scsi_cmnd' argument and use the
> entity in question (host, bus, target, device) as the argument to the
> SCSI EH callbacks becomes possible. The first part covers drivers
> which just requires minor tweaks.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
