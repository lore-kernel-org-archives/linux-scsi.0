Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F52C2B9F2
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 822476108D
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhEVEnX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:43:23 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55588 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231414AbhEVEnU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 May 2021 00:43:20 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14M4fnn6012174;
        Sat, 22 May 2021 04:41:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=IdzyPmfZCSvd5unw1VN/Q6T2TIKfTfD+ElzEWN9dABk=;
 b=Knuj7k9Yx2koEhfO3eQj2XRwPvCvsBcoJC448bG927clxQ6+N0ZfRz1y6k3IRD5jNPxK
 t2Bx/DS+YilEKKQT3+BhkYI7pUYE1Fepm6nHcVuVKGhKAOme43B3bH3EUYG5JvsFFGpX
 hjuzn71IbgHcSuJv6g6h50GeQyT7tvGJN6k0mOjYXuQICFMiJdipvYKTCIEPCB0O7oA6
 W38NO2kUdK7jpuODmMCmKXi2y4o+QRTa5ixnkA0HCiJJlB8jLomG8bOYVk2Hn3sZeruk
 qzv6kl+M1EcFLBM9CsXk9bPQ0D41k4dGt7dhnDEM3ZrFQhrQ2vWS9u9pPfHneFyy3pE6 /w== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 38prccg1e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:49 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14M4fmpx080080;
        Sat, 22 May 2021 04:41:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 38pq2rp5n5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Os9JMpES8RID3t5A/0Gg0OD5UEfTO4KbXDXqMeh5Oo0KyE94RCB8ewLqsPXQ2j0pJ2sOGe0DAT1YYUf4TxxNk8NkfbgE/O8rtGes7OuXHD6GaQAYVrlnctDOKhsdyUJ1Jc/iGb8+9nrGXGpAuNbpe5NrBBTPLWTopOL/fQta7vvZxQJ/EZ5idXv1Jy0F7vg5blD9MJHVP7toKCn9BqvsY3gRu+mYA6G2+tvI5uVt2cRqY9ahyqB4mbwixKz2xKh03Qs+lDFe3EQTNe3zklzPAbBh99oMZMnba9Rue4OO0xSaCXZka4y3tkZDOSrxuCizGwYgEJV9KHuAvdCCZaNscg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdzyPmfZCSvd5unw1VN/Q6T2TIKfTfD+ElzEWN9dABk=;
 b=kY5Xo3NrgDYj2p/PxzB0LFgOe4K0l3HBV9AeWzMM7NIhig0vQkyGyWq19gy10yFVu1XQjpzNy3wmC1IpLdkqv7mN0Iy1VSNr+ii/ir3L4cX8+tWAZCJpf6/QfeRFsgfWaxCt6I4KQzjU5BUtVgbrgnDVId6926Vclb6d+i2D1EoWvW1c0VYuBFsX4O/qzWA5HwUaHXGW3H5k27AEsCgzL0Wv7AWIgZTs6n1N/bLBYwWBBWjOQcgapS05iFdDbM7tZN8dQXeDsIYyhb7xDim5XYMD7lryiDTGm/KlWKN/2cYfdLolomcVygSz6t6N7rEII//1EXtYLth/sVXopK/2qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdzyPmfZCSvd5unw1VN/Q6T2TIKfTfD+ElzEWN9dABk=;
 b=FAL7aG6Qh6KNbvmrodzI2NenSM85EUFfI8IANv+Rv8fmEN2cSFEY5Po3ztBiTuEztLrnZTYI8E48BoRSEGJm1hURBHPmkNfnHqc1C2uMLDRZZWw4nWsdSoSok4YqDHJGYE07Vgb4hUdy+ojMzWWcTxj6IpNMfxSavxBwTvBjB6Y=
Authentication-Results: sholland.org; dkim=none (message not signed)
 header.d=none;sholland.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4566.namprd10.prod.outlook.com (2603:10b6:510:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Sat, 22 May
 2021 04:41:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:41:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Samuel Holland <samuel@sholland.org>, linux-scsi@vger.kernel.org,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v5 0/3] 3w-9xxx: Endianness fixes
Date:   Sat, 22 May 2021 00:41:36 -0400
Message-Id: <162165846772.5888.15242698782556370743.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210427235915.39211-1-samuel@sholland.org>
References: <20210427235915.39211-1-samuel@sholland.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:806:d3::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0019.namprd11.prod.outlook.com (2603:10b6:806:d3::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Sat, 22 May 2021 04:41:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8df7e71-65f5-416c-d4e9-08d91cdbe748
X-MS-TrafficTypeDiagnostic: PH0PR10MB4566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45664C2AA2A7B498DD848EE18E289@PH0PR10MB4566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ghl1d0eO5/S/iX7MdWsAeYfLRwiTuyKdKUF4/ftWnHtm2EqapocEHAqb2DAUt8mNrUxJg2WSZO/zEMA/Y8ibaB6b5zAFSD+D0WY/mVcMipZOSNhA+7qRCgS2Dhzs+oVmq1H+duOYPMtCsp659yoS+v7wydNmyN7IEsyJOv8hM2Pa0L5Uj3znLtbMmlBQaSL6LtRqvK5TTEQ3OcRHv+1mxO3RpaBRE6pFe/+GL2TR55wHMK4AxjWCr7iolyknzE6L2p4xhdefJozB/+5uQvUKVpWDWe+sSU63pombtNHB2qAGK4EQ8FIlnuE61mlTq0w1QeEbSylOgaeg96EYdRakVxcLqmGN4swxDpy/Xgqg2EHaPdvNxX2lZEoN6ZIaxLl9h1N4jw2KJgTgYFiNLogWs2XpT8w12tP4t4ARaq0mUDVuanMEyI8YyEgHKkQbyB0OKzdA6tzsEuXzMg1iKHJyqGyfb7Rl+3QK7eKbKEwtua7d5aQu8PUpcOTd2YT6bA/4+z2LJTyHXp5kw0LCv7wbuyrlW4zgdBN7sTrsHz0d14yGUXQc4yVEg23VLtbE/ipAEJPP3o/Ki1xEHO6KnDOzXOwlaDKU9Vur6r/yqLK0+rpqsZitIUukY2tRbncEilGfEFQlIgfEfJPNPmpvJYI8rbSfV1n119u+YCM4MmfASSCqlPqMomJMJrVphE4Aa4CwodACoQrP4sFdmWbJUknIDBmCv5seH2NpBANFtMTrTeMs4SaeKbI7x+wGqjtc9fJ4buW+grhHv3ucKWnEcpu3mQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(346002)(376002)(39860400002)(7696005)(956004)(4744005)(2906002)(86362001)(52116002)(6666004)(38100700002)(478600001)(26005)(38350700002)(6486002)(966005)(5660300002)(2616005)(83380400001)(103116003)(16526019)(36756003)(66556008)(316002)(8936002)(110136005)(54906003)(4326008)(186003)(66476007)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eHJwYXZlWVQyRjlXK3k4ZDRuQjJ1bEg1a3dZd3VMeExZNi9XanhnRDhUNnpB?=
 =?utf-8?B?dnJFWXZjY2tiZ2gwcG5xeitCeXRaTjJvUW5Ha3pnbGY3WVVWS250MlBMOWZO?=
 =?utf-8?B?MW5pVEVNMEFQOGVZZmhINGFIY2RKTHNVVWpiZ0J4WEZ2OUt2MzVWZDYxVmk4?=
 =?utf-8?B?R3EwWmQ1MUhINFpzMzBKQmFvckszbUxBTW5rMHV6UzRmQUp5UE5qeWhCM1ov?=
 =?utf-8?B?SVRKQ3Q1MHZvQnc5dUlTSUNnWUJLenNLSXNURkpKNVk2MGc4bHBsam5KUGcy?=
 =?utf-8?B?OFE2MnBVejMxSlN2dllnYWhoNUVydmVDQmNrZDhBN1d0ZzZaT25oSVJsckNM?=
 =?utf-8?B?Z2NFUktDZUZxUkRKSUdFdi9PM2RFYko1TUZyT294WHJGcTlSZFdWZ3hUdVVE?=
 =?utf-8?B?VkY5b3F1OFkvNG5HSXZicm9TU1BLTTVKdmowODZjZGhMdTZ2SFBVczlPMHNT?=
 =?utf-8?B?cnhra3RvVDlwVHQyaXBsSUNlTDhIVWNUbnpRUmVHaHVybTN4bkYyQUIyYzlr?=
 =?utf-8?B?QXpHRW5VTFpscWxvS1RMcnBMSWVueFZrQ1FLT2tZdlBBWlNJcHpqNVBGNVEr?=
 =?utf-8?B?elBRTnRXdzZ4ZW9zTWxMZkhkMHJseng0eW1KOHgrTWo5Y0VLTDlQazdMYlpP?=
 =?utf-8?B?aGlJK1ArSjZXVnJVdWJMUFlLNUY0WWcwd3FKdEI2SmJYQ1h2MHhHL1NNVG9F?=
 =?utf-8?B?MmYreUtHeWJYaVd4OHZ6M0daTEp1dnVJUllvbWVRajB3Z3hxc25tSmVyS2g2?=
 =?utf-8?B?QW1reUNTcUtXd0JRZ3dHYmQrZHQzZndITk9udXR4RnBKMW5Pc2VhNm5sRjFh?=
 =?utf-8?B?b3o4b2J0UHlZc3lYaGl3aVM5enBScTR3aC9PRlVMejIwZk5kNjV4UW1sT1JI?=
 =?utf-8?B?T0hvTlFtSDZBcmlFblAxRkUvYnRFdGlkNFRWSUlYeHdrRHMxR0c2MHVNdWpV?=
 =?utf-8?B?Y09qcFVrczM2NjdOcGkrYzBvd2MzbThab2tyNW1oQjZNZjVIRlc3S1BDdW5R?=
 =?utf-8?B?YzkrYTl6dndZRzZ2NlE1NElXRWdIbVU1VUlMblM5TzBsVlVwVHNxZXpWc2JB?=
 =?utf-8?B?bjBQMkQyOFNZUjh5QWJlOGtaQ0JralZrK29Gd2NUTHROTm1taENPS0Z0YnN3?=
 =?utf-8?B?eDVlYnQ5YUJULzQzMnBvRHM5dmdkQnpJbmR4dlRheUwzT2ZRKzlHZzhRMVly?=
 =?utf-8?B?MkR5MUxxZjRLNTZCZWpvWHV3enp6MHl5NmpwY0c0THlIL3VRQkxIRXAvbURG?=
 =?utf-8?B?YksrY2wxcnhsQkxtRG0vazA3L1hNd0tVcEl4ZnNXTFpZUGZwQVdhRW93WE0w?=
 =?utf-8?B?TzZSR2E1RjBuSWRCMU1SanFlcUdEZWdZbVB3aHFoQkovbUZwSmVMRzRNa0FP?=
 =?utf-8?B?dm5vZlBYcXk3K0dDR2tzc1hqdmJ4OUplWWpYSGIvSkVrZldWTTMwZGtpZ0RQ?=
 =?utf-8?B?V2VuK0ZEVFZ3TFdXL3MvWTJiSFRrZ3JqK1hid1RzUGhFYjVmaW00ejdZMkRi?=
 =?utf-8?B?Ty9KZmh4TnVHd2d3VW02Z3FVenMyakZpMjc5YlBkQkNURW9RRzRHMWpvNTNr?=
 =?utf-8?B?SDQrRGN1bWorbWRETHVpTUFnUGwwZU9XZFFEZWNaWklFYi82V2o2NjhlWUM3?=
 =?utf-8?B?MHVhYTNmZGQxdnQvTGlaMFZZSzdHcXRVODQ4ejFtQnd4TklFVXpjZmYvUFlN?=
 =?utf-8?B?YVArUUZYei8vS3d5TmU1ckhRM1ZhejVjc0JleFhtNGJ6aHZoaWczclRTU1Yv?=
 =?utf-8?Q?HWwQ8Is8LbiJO1g+YIpK7vpAnd3EanBx8S307lT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8df7e71-65f5-416c-d4e9-08d91cdbe748
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:41:45.5412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jPSJGbjZyI6ab7zkNAdyqnvuF4eymFv+u5L+yX0DG+d4mJ8T47BHvQCr+12UTsDLVm3Qz/IqNmpCTnSSElRVVecJZVZFM7JNgpSAas8SkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4566
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-GUID: JO-v750IP-06LTMsrzIoqLjbn3p-V21Y
X-Proofpoint-ORIG-GUID: JO-v750IP-06LTMsrzIoqLjbn3p-V21Y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 27 Apr 2021 18:59:12 -0500, Samuel Holland wrote:

> This series fixes the 3w-9xxx driver in a big-endian configuration.
> 
> I received no comments on v4, but it no longer applies cleanly.
> 
> Changes from v4 to v5:
>   - Rebased on v5.12
> Changes from v3 to v4:
>   - Changed order of parameters to dma_alloc_coherent()
> Changes from v2 to v3:
>   - Add additional patches reducing the use of structure packing
> Changes from v1 to v2:
>   - Include missed header changes
>   - Use local variable instead of byte swapping multiple times
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/3] scsi: 3w-9xxx: Use flexible array members to avoid struct padding
      https://git.kernel.org/mkp/scsi/c/44c5027bb5c8
[2/3] scsi: 3w-9xxx: Reduce scope of structure packing
      https://git.kernel.org/mkp/scsi/c/d133b441488d
[3/3] scsi: 3w-9xxx: Fix endianness issues in command packets
      https://git.kernel.org/mkp/scsi/c/05f7f1b9ee82

-- 
Martin K. Petersen	Oracle Linux Engineering
