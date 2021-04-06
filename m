Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA30BC43462
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B71260FE6
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243654AbhDFExp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:53:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53286 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243648AbhDFExo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 00:53:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364oPZ8076350;
        Tue, 6 Apr 2021 04:53:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=d0r+9erFquJpUqzddcwAQ05ZmDwHtH0rkzwPB5uxfMA=;
 b=sDvngHFK4MD7MT5VlVRBQn7cWY6YRw+ylNcfPEAX7/ekxDYp/6fPsNO/1ON+xaALrAq+
 ZnosozM8ewS8NkybGE45IGhthPPUcQZ0SBbEz59rxdzsYixMqLu2ab2VKy2yL2o3/RNd
 QZ04uQZr0dnSiYFvIxX+jI/ZLoILvaK14F2MldDPJEL4A2dzoDAbbrF6Sltx/qQoeAzY
 2Gcxpve3vSrVN5SWuQiWrnnFvaJr1zEmFKaKA0Fk0klLa2QFp1qRXsUMGtvM/gUEUB5H
 cCxLGDg4JIjm5VndDxc/pxA/eMKVZ3KmEfrjbzZ0W9crI5FIJExzUBzCSKP1Zp2rQ+Xp RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37qfuxbbu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:53:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364pDrg029184;
        Tue, 6 Apr 2021 04:53:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3020.oracle.com with ESMTP id 37q2px1s3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:53:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqN/um9jraKWQQbzaHMrlZMGoXlGlZWoURg7SEHI8K+hVM3mcFF5mOiwfiCT0Yo9jGttwZXuVhAJXtHiUrh7R6aB1WH8R5mFtQJ11Jzr5TEBkqqK0sxQ/2rtjb4GGU/qHSHhnECRIcxiyNXk+LFimtvmBZrCik7kuG+sy/9pCgSjsXBY0mJFzRUj+BFmTFyZlWYGw4S5fKE4GpCIm6KxIy/cLvFKUTKWKrj/4hOrpIbtWHW2luGH7eGu55vtN/oI+DaBCfUOd9FkkO/9epDhYKhtfWkHnnMDDAL+xKuZKiwGijkeXfBoWJIR12xO224I0qBGH6fCemkYiFaNJgOgsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0r+9erFquJpUqzddcwAQ05ZmDwHtH0rkzwPB5uxfMA=;
 b=K90ZUNL840ncoqx05h3JHiAQ84GVMBcgvDQbayXCNZNnR23sPopY9Zoy/7uTdq7g2mf7cHtzGQdI9bqyAT7YPIjLr9B8bHoqjPL+krzvZpf4+toaJHe9D/b+RoVPy3SbSs8ylxoI8aXuKi8wTrXnPJ3AHuwJ96clxqNGWtArOPOH9lyx1bmu67V2+RJMP97enaRW2VCpiB3/Q2OH+ops3aSCbB2lAt49jj44KsYlGKspmhLqpPiCHe8H9ULhoJLDudkiiUDFPPhC8/hjQoxzHDQLxTSAMc/ipxkeZMjhbpqCfErxvNXXW0ZM/A2ieCK3D3nYGRHN8aFleOyw2NdUwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0r+9erFquJpUqzddcwAQ05ZmDwHtH0rkzwPB5uxfMA=;
 b=T/JPcLIN9sOLY0qSxMV52fVW7j0wSAznSxPLptCyYmr4ktFTZDjlFflFDB5ipxQFbDahIvi1V5jyg1jdS13g+Lr9aEDMT7xa5WZTAJ2j92aa6GYhteGJZqjl+FDVgsKKNkL40p3TsCswV93vtKDyz1o2HJNCKStJkFZAH3dq8Rs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 04:53:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 04:53:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH][next] scsi: mptlan: Replace one-element array with flexible-array member
Date:   Tue,  6 Apr 2021 00:53:22 -0400
Message-Id: <161768454092.32082.2593948568576658600.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324233344.GA99059@embeddedor>
References: <20210324233344.GA99059@embeddedor>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0193.namprd04.prod.outlook.com
 (2603:10b6:806:126::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0193.namprd04.prod.outlook.com (2603:10b6:806:126::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Tue, 6 Apr 2021 04:53:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 829e3329-016d-4120-5ffd-08d8f8b7ed84
X-MS-TrafficTypeDiagnostic: PH0PR10MB4407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44079DD2D1711B05C23201198E769@PH0PR10MB4407.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l+vOgIw6NeZcsChS+mY3VWL59/6cbAXvumk5KEY8tpnov4G+0P9f1FqbPhWgZ8IqnRv8l2XsxoHzAxfYKG6rL8uCcCmX75rtz1//F2+2s/b5BsXjzRBQ5CpinBMzPi7CbP7B0PkJ3zBwDNME7HxOAQHIiqsmElLHBy3Yg2P+HZQ936UmsE0WqxQqVsrLBFCqUK+n7eukrojbUoNzjhMo4oJCCTPgDMs65qDj6b3T781vm44WwtEkMewfr7ddNaFzWR9VlWY8jkKHwkMkBSsobkichAOi5WVDkc0dW1BThivlCh25Bxqx5TGQeaXzlhKEuSgx7PzJd0aSi7HCHeSOssc0ag1zWyqfgy8ZiQZ4a0n8e94ODGLzfJmcpzkxWbCQH8+wD9KxfxLmXs9o8M5D5ZwopWyAV5FiG8o+xXg60m+lhgepqQ/qAdt47Mi22iEy53l6zUjLVXEwij/CaLXJU+yXiu0DI1syvSOeQU4JNs+0NhREdDINKa69sraM2/ZXpBFdRYAHVv6FbENZVJXjj7Pew0Ke1BHSwu9RdOJVaYH0vQdX3wr0IWhN9YqMYAm9wAmWNfX6qSqc4hgP4OuYgq1hhQI4Z2ezIuxvSewDY7rSwincYAdLALdrT/Fg9UXGXyFVm8fWdktv5eSNQRpdU2m1EPim2Cze+rAucwsPGzJQJTKXY+TP9c7TgoZKgcROi8LhPz8uydjlIF2JDJ0WQWK5t0KMl/7URiDAuMJCPyb1FE61GfAlGOhsfBN6bkkq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(52116002)(8936002)(6486002)(7696005)(66946007)(66476007)(186003)(478600001)(86362001)(966005)(8676002)(4326008)(66556008)(956004)(2616005)(6666004)(26005)(16526019)(4744005)(36756003)(110136005)(316002)(2906002)(38100700001)(103116003)(5660300002)(38350700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YmpFZjlNWVJDRnQwT0FuNXZtcmJCMkVvVE9OZnNFSkNwV1FrckFwWlR0d3JD?=
 =?utf-8?B?MmtDNkQ1alpNZ2gvamhRSUIreEkzTDVDclcxTWZoNVV2ZVdqaE5vaVpXV0pZ?=
 =?utf-8?B?cWhFN1g0bWFldW5pRXBEcWNvWFB3a0RqVmc2K1VOVzJ1eHFEc3Q3ZHBTRk5W?=
 =?utf-8?B?ZlFYN3lvM3FvS0h1S2FqWjU1TTdXQ3lmNjNSeUsxcW5NY2hRZkNZWGtEVVFt?=
 =?utf-8?B?OWZCQlJUMUdMWGdRalh2Qm9kTzY4bHo1RTdlWVU4OEIrVG5Ba3hFbFI2cFMv?=
 =?utf-8?B?ZWNtcnVoRGZ4Q29XNllrTGpmZHFTUUpQVnR4dkNCV2VYaWhYdzgrc3M1Sko2?=
 =?utf-8?B?RGR5SkJQNDgvTW5lTGJ2L0REYnRHS2RyaHk5OHplLzVOdE92UGorT3kyQVYy?=
 =?utf-8?B?VXB2RkMyUlF2NjRXaU1PMWtjbmdZY2k3TEZ5bUZXL3VFOUI1d3lSR1NpbjdW?=
 =?utf-8?B?TVY4aHAyb21BaXg5NG10MFNvOTVvR1p1ZVY0K3pDb0o4UU5uempsVDE5ckZT?=
 =?utf-8?B?S3cwekZxc1R6K1FzQ0J2N0p5NDczNCtsQllJSkNLclNRNkxYV1lWYjVoVzl1?=
 =?utf-8?B?WTFwMzJxdFY4ZFgzdk9VN1NWRHZ6RXp4bmZYWWdmNVdjZWZDSkhyVzdubm56?=
 =?utf-8?B?WEZVMkNraUs1aDZmNHVoSS9SdDNrVG02SVF1a045OHcxUm5tZDJMbkx4WTRa?=
 =?utf-8?B?QXE5UlpPZFV2cC9WZHRhQXRRVWl6SWhhNHZNODhuSUt3eDIyM1RzSjl0TDB1?=
 =?utf-8?B?RTB6ZHZNQUNEelhjTSt5T2NVd2s0UlVlS1BJN3Bnbm51VW9HNFhJZXNVeVFz?=
 =?utf-8?B?QWlHR3V3Mk9qNFM5c2dmUmdudlFrbGxPOGNBOXc0akRDUTZIS1FPRXpoaGhk?=
 =?utf-8?B?QnJFWjFub0VUK3pRQ1JBZjdVVkRzMWtKRFM1MU9kYmo4YWV5bm9yeEQzd1ph?=
 =?utf-8?B?TkRuT1U0VmVidGxCZTBCL2hMaUZWcWRxOHMyYjZkZHFsNTg4SngrL0g3SjIy?=
 =?utf-8?B?OXo3Z3pxNWduMnJaUHlXWUIvbTdQK2Vva2JVSWk3aTR6Y3RkU0FLdmoyR1pT?=
 =?utf-8?B?am8wMng0alpTTElwRXhzUXJRVHBGUDk1d3J2UTBiSkhUY2xXbkU0TjRSTTVk?=
 =?utf-8?B?QWQ4dUpXejBUYVZORGNoNHdENldxNVlpdlNCcTNJRTI5Mkc1bVdsWHlHaE1R?=
 =?utf-8?B?a2xFM2d5cS8zYy9OWUc1alFpK2dQSzBVSFlFVTQxQmxRU08rQmJKUU9pUSth?=
 =?utf-8?B?N2toVUFnS29lcDBSQ2s0c2J0NGZ4ZmhjV1hwTjdNaE9VVThxYlZjSVp3c1hZ?=
 =?utf-8?B?ZENQN3BhK1ZSdDhkb3A2OFRnUUJJbW1HajkxUkxYR011ekJBL1lvTFRmdFpF?=
 =?utf-8?B?YS9JUlRMeDdwbmoySmhQSEkwMnQ0WThWSkJFZ2JKZEFMeUk3cHg0L1llc0ZS?=
 =?utf-8?B?VlFOTnlFRnlSeEdsbU1sZytMb2dZMC9QUmNxNE0vTHRKSTVGTlRSN3VzWW9O?=
 =?utf-8?B?amVoOXFYanU0ZDk1T3MwNU1PbVhma2Rack1QaXpBRDY1cWVkZXo4cjNoTzY3?=
 =?utf-8?B?WUkvVDQ0Tmk5M2hyK1pydVVaU2tDdVBYTWxjelRMR0gwV3l1OWlUaDBSb0pG?=
 =?utf-8?B?WE1SQ2ZJVENFeWUySUMydm1uYjAvYVNEUjJqMHV2djFkYmtJQ3ZXcS9iZk12?=
 =?utf-8?B?QjlmKythZW1taGEvakh2bnNDUE5JWGU1MEgyYURUOXJWaVgxbkdjUWlJcFYy?=
 =?utf-8?Q?ombgjiYtmB69oXbTmGC4q6wYQ7qpK65RWIghmN8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 829e3329-016d-4120-5ffd-08d8f8b7ed84
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 04:53:32.2366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bm8/BCjINwK1g8lPogYUuPDXMq42IpoR6pUt5SJkIY81g1WWFfF+xuL4+zB7hkqLMo3Al2gRNZ0P6n21ZSkTR8/wFq4pLi7eFgy4CzkoBWE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=841 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
X-Proofpoint-GUID: iQujPsoqPwDjVIzdHY2eB6CsRWqnq96B
X-Proofpoint-ORIG-GUID: iQujPsoqPwDjVIzdHY2eB6CsRWqnq96B
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 malwarescore=0
 suspectscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 24 Mar 2021 18:33:44 -0500, Gustavo A. R. Silva wrote:

> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code according to the use of a flexible-array member in
> struct _SGE_TRANSACTION32 instead of one-element array.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: mptlan: Replace one-element array with flexible-array member
      https://git.kernel.org/mkp/scsi/c/4e2e619f3c9e

-- 
Martin K. Petersen	Oracle Linux Engineering
