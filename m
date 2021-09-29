Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D4FC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 02:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 412D96128E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 02:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243795AbhI2CsH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 22:48:07 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:65380 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243763AbhI2CsG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 22:48:06 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T211KI008632;
        Wed, 29 Sep 2021 02:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=L9xqR4VutLml4twP2ovK+QnNiISVsCYSw+7Q/GzwDR8=;
 b=kdVkym4JhOV+M71YvMHS6/qV8CmsiUCWFIuKPMFKsjhCUPx0D1dvHp3F09CYHIT/Fw0G
 Z3stlgUoKHsMoVKLAX3QVGinOywDD0/IgE6GETzhSXDXtogfXpRFgZWcsXR0hZsuHknS
 vq1hnfa3AI8A4+1OowFYnjm/LvE/ShB4yHiLBsQm5z8mLutOs4RCTQyhaNoxhJzd3UNk
 p+eHls/lOIM0gdcCxhqx5JXDBJ2BatcYiy1Sr514w1yM9UVkYb0KqAKG1urMlVVdQHiZ
 KoGZ/vZyQaQ7eDZZrmVZXmn/TU1FQAcqYqvlvO6jXCHjxFMJoTWJF8YquGm44oxAxzeB ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbh6nv3x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 02:46:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T2ewBj114298;
        Wed, 29 Sep 2021 02:46:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 3bc4k8m1rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 02:46:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7Buiqih/Hl39JaODCqKM1vBO3+7KRitesbjuOt+t/AN3YQvLyy2fNuWyopGoNYm/+NvhzpAR0hu5G9bs6+yDxf77ZiJ7WXTSUNR8IZ5qicfKho5XSjwauaogeTXoDnEfpFcrpwaL6IQ2ecZuguKCj+RnXyMWQCDpfFD2B7hSWAMGDGddIu54Y2UW34WZF1teRy+GZtxCivuWJF8udsxgOyz2JI252zpTuQFBsTvX6GAhjptKYJvzZHv1GCRA/ocAG2sh73ah8bIeufpowUaVcWMGFAlvJdAsHdQQAU0umDgly5hl1/b5hCgZ4FhpDf2AV0DpqHCUMh0kvekn8lJxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=L9xqR4VutLml4twP2ovK+QnNiISVsCYSw+7Q/GzwDR8=;
 b=OpMds3tuEnR/DrOLHC4B545N3IEKgQ20rCcJbTG3v+AdPx1w6ToRCmly9zsP0pCKKNVhKVc15oOoBlqGxmy2qr6tVcuuYtHzXwOHhK7AyUO6mNCTeYOVgu2oL5ZwOiyag1YQCSC4ajeE6Sx0MQIJgiuc01x+9xjF8p6QA9TsZR/zJLr+lEOlxfOBRie4KWrR7MRKPDZBfiD4Zu91AYUHy9fSby/+tgZGN3ITZi2X4BfAVwsVP6D93vrjxepRzSlINaJlSTUYsTyHjFF7Gtbe7/7sosZ9fYJXaM2/farLr7ZpPZdPZAGuwcPrBcmEXfgbayUn2CsMGnOOV+FIj/P4Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9xqR4VutLml4twP2ovK+QnNiISVsCYSw+7Q/GzwDR8=;
 b=TjUQDY1zxVgciLrzD8OYRCwGBrBeCXtjIJWzaLMFO6xKxUAuG2v1ATmrJYpzQDtEKL/mFf3rwIRrYG7n/pRqy9bw4XH66ooAY0YmOnbBN8vJ0l7KKjKdLknaq1hOBFezSYy6ru0qDNg3qk85hmXUfGj2htffxgkHNpHgkhyr+kg=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5436.namprd10.prod.outlook.com (2603:10b6:510:e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Wed, 29 Sep
 2021 02:46:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 02:46:11 +0000
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: ufs: exynos: unify naming
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czosgkuy.fsf@ca-mkp.ca.oracle.com>
References: <20210924132658.109814-1-krzysztof.kozlowski@canonical.com>
        <20210924132658.109814-2-krzysztof.kozlowski@canonical.com>
Date:   Tue, 28 Sep 2021 22:46:09 -0400
In-Reply-To: <20210924132658.109814-2-krzysztof.kozlowski@canonical.com>
        (Krzysztof Kozlowski's message of "Fri, 24 Sep 2021 15:26:58 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0021.prod.exchangelabs.com (2603:10b6:804:2::31)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.46) by SN2PR01CA0021.prod.exchangelabs.com (2603:10b6:804:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 02:46:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00959295-6452-4f9e-fbca-08d982f34c0a
X-MS-TrafficTypeDiagnostic: PH0PR10MB5436:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54369BF51C4799EF2DE843E58EA99@PH0PR10MB5436.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PVEHSHRlUWeNZZ4Zq2fxT4RRFaps0yezRbEJNeMBxeYnCK53RdeKDkeswQpRMIv+28yScVOtOJvbBfafrIBBpCEgbgVNcVTCUcCDlXw3ZgytcMPmWd3QcsbvbbjvgfEtDKXJqx16YcQYuARtbRaurYcdrMIUD326mIZC6V9K2QeOQM/TI7IOpQk9+pXuZ1uBU1x24VkYevKISbVmPUB/XZTZQzsdi4OqtoMPRlAAUftNe4glkEq9X622Ky+LpmbvSvWFoUuEt+UAfhehxChDxt8t/emK63nHCU2Spsql53uFrWbxox2PefUJIzC6irlotMOuG71mvj9Vkg6qSbj+f3NTzQ2AcDETGy7OVcgNmkDrzPpxt+sERtmnwBGz6HDXHslk5gLzCjNLTCPTDvDHFnXFECjWsDN/XyIsgWWhmyqPZDBbwAh1hP9WPzwyAz47FvU9mJAVKH+8fDr6RMWlB2j+UbzPxlUEf3FOVGUjBS7JyEKaxtsV4ic7h7pC/nJkaZ7dpby1DjV5gU+jTQvkgWo3TiibYmFr8Zydfmc1CzTgeq5v47b2bWub6LvDaDI/mAsgEcz/MjLc1uEjbKujlilVNSge0G5LSwDK80ucpIbuWsfp0Rff+iRzi9UliEkR5ks+olzpcuxzrnmxGDOG4xwdk4/MP8bpHOvFHcwjFyZYInn2XGp9aiLKH6f0NplfQMAarSD80cAh+fuXT+PqvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(558084003)(7416002)(5660300002)(956004)(508600001)(36916002)(4326008)(26005)(66556008)(66476007)(7696005)(8936002)(52116002)(8676002)(66946007)(55016002)(6916009)(186003)(54906003)(2906002)(38100700002)(38350700002)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pxHM7dUXMrg54x/kLBh+abyKFZlYPqnB8ntb7EWQ5/Tz+aqnBEPlxuFB1V1k?=
 =?us-ascii?Q?2ES8AiELhhLP4NqT3aljK6pLy/CWtVtl47KoFYyNFW5F+l8p88GHDNQ7IE9j?=
 =?us-ascii?Q?buGp8ZJW9B+7XKQmcBSy4hUg08qywMZWWtbQ2Eu8xoRnob9HIuwv7MeRjXsL?=
 =?us-ascii?Q?FSFWfLN8QwmrZH2s579Cvf8eSIOWjKAKS0dtVA0rJRKM9HykE1cK28TuOOvL?=
 =?us-ascii?Q?Qxfm1sSmEsG0JH0WKOEbPllAgF9zas9Xn55pa7O+XCROeb/TcB24TxTZVYrC?=
 =?us-ascii?Q?pOF385jqUUQwqJCZ1luCrchpYZTQzglf6K84OIIerE9bRPY6p1/5G6rzc5++?=
 =?us-ascii?Q?7SkWtyYXLLkMwQjh3ED6WHK/KLljkl7RDTuq0tKBsOsWP1n4zSPVVYjSHXgR?=
 =?us-ascii?Q?0ov6tqMGfNpTPQbgAzbpQ2/BKXqOapxZf2f75Ek0aZ3jqTH2oil2BZeHN76z?=
 =?us-ascii?Q?wYTYPhTYb/hpbeD+frB3HKosNHfhxxjfcCbvvpBgiTpxg6gzZmEp69h5C1F5?=
 =?us-ascii?Q?GVlhx7s5MvfxQkupJOc7KqYsHlNo3on/l6yZ1NoywFTl6Ks8vGFnAVimjYMX?=
 =?us-ascii?Q?3i46rIu6vgETwDh6a3GP1EOHWeyM+g++Op7TUirZAT5vIWA2g3k2RwyL5Fkt?=
 =?us-ascii?Q?aGH5exo39quAqRm/RAzXeoHhirJMzFWusT4LaTj+fnB6BoDm5Em0EKetGT84?=
 =?us-ascii?Q?z4yLJol3zhgxSSc7pvvnEQ13rdpOZd+3KdyfgEAgGc95wvfluUdsoF362Yqy?=
 =?us-ascii?Q?m3aFLcpnfPsbQbvLEWk5RAvACV3iJScf2RJlE14W7gYuxCnR8/1vcVwHF3M0?=
 =?us-ascii?Q?1ULB2M0Uj70BflXM/nlpWD3LT+7/u8CrIohJIoOUA+UfFEs2V7mk8nf5IF6L?=
 =?us-ascii?Q?zUW6mnDVjU+rDpKQvikx95hNvCBJXqUPZ7o6Q8tJhIzCayS9qTdrZyBjSLFb?=
 =?us-ascii?Q?FtOWRATQZrO+QecMfyn7QOskkctlszUKkFYleRKMbDFbWSqQu7kBFMqgl1fG?=
 =?us-ascii?Q?fvN5yeQjLKZbfTaWSFqyQWy46xMBvh2zA7niNslKWOokoBbYTa/SvAi99G+i?=
 =?us-ascii?Q?e7PNl/NFbLPe+yAXBVvT6WQuGsUCmSdAl0PB1DcIvj8jnVJndKHaQcuJrU/C?=
 =?us-ascii?Q?MjtIaff6XyXk1FyXoaMUg3Uxrs8rG5WPw2mJ8FVLESF27/rIGAzZ+iAbV5SD?=
 =?us-ascii?Q?F7fBlfORlzEV/B5VOlu/kqRj3zQDvRdcgXD5PCsjvLnBS8Z/8qIeLZDj01F6?=
 =?us-ascii?Q?UPNPW+DXrRagCXFGv1mlz535zpDQD2MYNSCc9wsMWHxmK4Whh2oMBACOkhbz?=
 =?us-ascii?Q?UhEbd6k9VDsE+fo86SwILzdX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00959295-6452-4f9e-fbca-08d982f34c0a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 02:46:11.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cjnW/HsrHq6uG4/rbIXVs9klApJj77V9juDikh2TjPGhqJndaoquMdai7r6kppXnqe9/VgsrISZpaElTkZHv9eywIN3/ujkVgyjNdRf2ipI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5436
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290013
X-Proofpoint-ORIG-GUID: xwWCDHIS502JbJU9ex_23_iw1LqLoZER
X-Proofpoint-GUID: xwWCDHIS502JbJU9ex_23_iw1LqLoZER
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Krzysztof,

> We use everywhere "Samsung" and "Exynos", not the uppercase versions.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
