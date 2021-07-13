Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A75EC07E9A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66ECC611CB
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhGMCAE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 22:00:04 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47260 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbhGMCAE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Jul 2021 22:00:04 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D1ufU1004824;
        Tue, 13 Jul 2021 01:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=yubySPLryvBgM4XUCeM6LCmtwLwmKjDxNWjYmhGc0WE=;
 b=xKKd1Jj0Ixn600AjH2UdNVd/84+Vvpv78T137OWVf2qLJctWsEnMdIjHLgrHiRl2WKDj
 y5jpNJWXmg8VU4DYlDx0lN9E/43WpDmf1kk2HnDO8eQQzvlmhUPHSlnAoM2kSHGYcY2y
 Lu1gKJpE/WNiAvh5ACAhlqu6tIpbKJoarxq1Mj1/q8pz72ytftmJiaTSCq3y7Ecckl1P
 beE10UIazKYEZja68tHNvAJDgIJhE4Knk6QuLNgwmjFOELKgKS6NZpFsaRLgVssdXf+b
 7G1nZ3VeQEl2rk4ERRerfPBsWvfQtrp+jQKSN7DcgbjjFgp3//izWDpQjkrDviFOxons 3Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqm0s7vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:57:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16D1uSnV149755;
        Tue, 13 Jul 2021 01:57:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by userp3030.oracle.com with ESMTP id 39q0p2d056-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:57:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5rV6n6rM639XV66FVq0orXrFIl8WfzhFMb7O38GVO0f1SjTSDkVODXCJBxCxr4YF6HQ7f7suYs24s54QG68HiWCOyxqkU2FzatiBsZyev/6BDg6MLs5g6guyLii5jaF9KC5dgcfRHqLOAxUq7sCf+kGr9lPo1yqu2FyNbWM0Ns0bjrn4f8u7L+ETFKtQFhvrTOuk8H3WpxEasBy1deWxzVJKlcJRMZrgkCiU9TDb6TVSb+Ax+hTP8j9bDpld0DHQYY0X8REX0XnfkauTbkCHfmh8irYBvQqw0XcnxqWW9dpRKqiljbjHJQwfSuXKO6fZPjEO9zrdtn90+iT0q8+pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yubySPLryvBgM4XUCeM6LCmtwLwmKjDxNWjYmhGc0WE=;
 b=DQy4KVCcvbL55NZpjU9en+cWOTRCPX+DwE77M7nx/V7mud53A3EontXJE2zmwIvFVEVIbmI0X6xk1NTegFelPLsQWr8Nwam9OE1ZqdIgL+m99I4ynKsRi80Ik4REde2xxG75xVAEi2+8kZuKYW5fnKefwzBN3nHnFqf5FL4I4Mk78epGJDc8zKI6Am6H6q4x33n2tnOUbfQ+DMfUoUxNqBh0QORCS6NmE6S1ITxmeCVu69fGRlaBbwo4jV0prusRTVn65Gr4bnOSKFsfzlMm87lHhdXUtTw5ImU/bsNWIBigvk7jqAbHhPKxp2zW1BsRSpX9ytoRalGoX4PiJF2yiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yubySPLryvBgM4XUCeM6LCmtwLwmKjDxNWjYmhGc0WE=;
 b=k4gWtMWWTT7jXHRFI93C3YM1Enqe+iVqBCv7NmwchL5f0IE/RbHZpmgvvnmLwrjYJFISF9eGeTDywyxpYeuxlrD2dIL18BCBvXUKQ8ihQt7jxZNs0TCwZbpZsh6mzpcEI+/pDfbxbwpCWN8lc5FPV1NiWoKg4cIehXytSSFxovI=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4519.namprd10.prod.outlook.com (2603:10b6:510:37::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Tue, 13 Jul
 2021 01:57:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%7]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 01:57:08 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.ibm.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        kashyap.desai@broadcom.com, sathya.prakash@broadcom.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3] mpi3mr: Fix W=1 compilation warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bl77563c.fsf@ca-mkp.ca.oracle.com>
References: <20210707081756.20922-1-sreekanth.reddy@broadcom.com>
Date:   Mon, 12 Jul 2021 21:57:05 -0400
In-Reply-To: <20210707081756.20922-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Wed, 7 Jul 2021 13:47:56 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0026.prod.exchangelabs.com (2603:10b6:804:2::36)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN2PR01CA0026.prod.exchangelabs.com (2603:10b6:804:2::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 01:57:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 535300e7-468f-4b60-34de-08d945a1858b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4519:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45196A0F6A29568F7FBED5F98E149@PH0PR10MB4519.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m5+0QgN9kBpmq5n2brq/zmEkIzHzdDxE9T2Wqxhabd0XsfCNeCxeD+yia878KxxIAsvP/dBgdYDckjNGIPYzzk/SmdiznE31SEr6A5Pt/uEBPIeo2m0hXmjKC+cbk9TWgKLWjPLiCEhShR5ptzfQSivievK9iJuqY1UAJovwflEuqNEXqZhIpAGdTZqakBdhnoYi555lJw/6PPwjBsJSEAeXIOB/X+43OYy2ORF4KS1hpJyIzXhf6gmRmhSHlazVia/wU7Mr7qenqfxPkqOK3HKrkEEh8l5YlizRwC0VD4PmwW0d6a/VbPX7g6Kt1K1CS6zWRICHcLF2EjjAUZJ+Y4xXeaAieUWEq1v/hlPBklT+HNjt4XAnZRiraALJ7j6KRlee9isHJBUmQa74W8cRg4mk1i1z+lNcF+Bx8A2WVefrSTxbthWrA+3LhpWsthGtGAE8uExT5ixKwudh1GHhMg3gBsdaNbIefiL4hg/m27yIysQYC/hTZe+HiE/FprB7XuXEPiMJmExkdfLdAOjWFk4A0XF1sdKyexo77AtJ4LzX/IXgHT3aVmyaCU2suLYnN5ew1qCbtbZgFIINj7lVZtD4AENG4gHBlsolrPEXKJt3owpvG1sjcIXd2t5FB2PCaz8006u24dkuOgwsN97VhTj5Nwlf+lM1ZgNMjC2xvO+LOcD0WGSiACWquSk4X1C7RTVMmy42IyDlSLjRMNln6QQQM4LUn2aNuyqg7U6gXco=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(376002)(396003)(39860400002)(478600001)(316002)(36916002)(186003)(7696005)(52116002)(558084003)(38100700002)(38350700002)(2906002)(26005)(8936002)(8676002)(66476007)(4326008)(5660300002)(66946007)(55016002)(6916009)(66556008)(956004)(86362001)(83380400001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gfkXU3lWyEkzNl3e8k7QFHRmhTMR+xYksKCwK0k7ivPgVN73k/t8TwfCt8ro?=
 =?us-ascii?Q?zkUCxoHuIYx5w/fLg8j7qmMvadlIZDmZpZZWbjPsmSVjyshLyLMFcY8Cyxri?=
 =?us-ascii?Q?BlfFCew81vtC5xpNXDC2JlwTe9ngwR5VE0iXU69RKrLldtg+cSldwE/UFSTI?=
 =?us-ascii?Q?ZNtjtPrb2mPvA7i6BX2MP5k7M69hmv/7NBLspOU+wgfj34LW2v+1X9XCjbCw?=
 =?us-ascii?Q?Cj2DIlxv2UfYFkqftSsgvoFWvB18APRreGqvg14W9lIo00v2gyijLCSRFljG?=
 =?us-ascii?Q?HYL93XRTL22rDpB8ol1yk3PRruxgBYIV0ghlphV+rXNF/r5/32rGq1eK4w6a?=
 =?us-ascii?Q?ch6Vg1gGBfS5nqXIirRbsGWAchs84GnBKGZeUTbQCUdy8IKGxN57ARQZ+TgS?=
 =?us-ascii?Q?OpmrvZRx+MQvy5Hdifg3cFwhyeWsgXjJFyGvOwuUVRRtF4XJ+1CUD2/J7moi?=
 =?us-ascii?Q?EnElGyrj/xVHjDkFLy0srdGFu3//pxSFozKyYKrut5fQUEKyb8vmvE+6cYGx?=
 =?us-ascii?Q?BUEHSV3dcBvoxxR+OWjHMS9fDRa3QHQbBZ4pT2mA4mJdcWl5oC9nW90E0bXD?=
 =?us-ascii?Q?YepHsZI/CfHBy0JEUrc//Hfn3n8Km9yDYkghCXOCPdz8XRW19S9S5kTzSMew?=
 =?us-ascii?Q?GOcx30wkyzls6aefdVbfdCKLngLRQxSJB2c7HvcqXMMzAslrqY4XYkrCvgte?=
 =?us-ascii?Q?CADMlLZ5IP5Ieckgnlml21RQY4W1cI5Tj3MsMuS4vwhmmJvFJbAR9TUFHtDS?=
 =?us-ascii?Q?BmEGiRO0iW9T2S2A6zHdeJZ2eqcZM7n2vYJcVikd7/1f/GEmK+XHe3z3byiN?=
 =?us-ascii?Q?F55jkXozyHY+hdXfZKHi+PxujYf98muHe6F7Q6kEghdFni96NkL9tPA/3e06?=
 =?us-ascii?Q?TMkaCuXNQbeeUY4T/0cevAD1EmkbgFBMDDscmU3ISuuhKGye10HgirIVllDk?=
 =?us-ascii?Q?0AOHhAYhbpMvVLa1PQyllAeF6So/+iYeKwBWjlulW1rUeiVTsdQMz1Rm9AKL?=
 =?us-ascii?Q?xHyeTb6YYR2ZChDgZcgSBFk/aj4craOwuJBrZDigH4AvAB6vkXIf5pmceF8k?=
 =?us-ascii?Q?9MS392GH+xefEgzvPTAwfPxaSonhVO56pa1kbPOKMuGVdThWN56b9lVuZHab?=
 =?us-ascii?Q?mT7iI37u8xBU9jJuD+xAS+vUrgSWwGcL9b7aF9ZPU1ojdcQm/ARcw+ZyYhc6?=
 =?us-ascii?Q?3MQ7ddkNjTO9s01wWsc7YFWLLQ24x1QoGA5AGhqlP5pJkXEdDFHyXauGyZ0e?=
 =?us-ascii?Q?2QaznH6CGY6jaMKaIEzq3KwPKQlr+ISgeWUOVAfzs66bgWYvarp8GMZhe8aX?=
 =?us-ascii?Q?iBLnaVhabB5VxMFQT1s+or7E?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 535300e7-468f-4b60-34de-08d945a1858b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 01:57:08.3922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFSA/5NgEcUr4ca+oW3KY58vR6D2MjTHsgv2a1fqH20QYrcuA7kPAFUBrdUI9mspYCVahHTjAIqg/hq295kXVeKm6Jypaa66BsfJBpsubcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130010
X-Proofpoint-GUID: p7oRr2yywPqaqlJAf6yCbpuOVaSknaY5
X-Proofpoint-ORIG-GUID: p7oRr2yywPqaqlJAf6yCbpuOVaSknaY5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Fix for below W=1 compilation warning,
> 'strncpy' output may be truncated copying 16 bytes
>  from a string of length 64

Applied to 5.14/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
