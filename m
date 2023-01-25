Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C510FC27C76
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 04:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbjAYEFK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 23:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234171AbjAYEEi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 23:04:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28090530FB
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 20:04:21 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OKx6tZ027999;
        Wed, 25 Jan 2023 04:04:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=gPzJpUsMqXNDhxjEizABIBI9PDSkNjc8nd/YNchB/4Q=;
 b=Pg4RGBUunE35x07rgOG42d23qIpNJXJzfzvytz1xtHzxHRvSx8N1NyRgAyuxbJ9JqFMG
 NfdW4AIaFQLT5jSnf4UoMrCbJFH/snUZStdpaXL34XzWx/MQQaLEpdqya7iHYAPM46yi
 fUtimqU2bi+p7MEn369mDAdWfH4Bwv9AeFUNGTtCRb65ICqxJ1FtLvLd36laG4U6WOQc
 c6MxXJ0sMqOZ0EQYym5utI/baj/f+/unfehFUacFaKOVF+LHjWAbDeuBtMv3jMAZHNSo
 z8r05Deo+R29+u/+aWtjbfJslpzNsaNdX7dFMktvkfj+2Izeodaif2EjwR9vHfXKSx+R bw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n88ktxwfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 04:04:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30P0tDsY025241;
        Wed, 25 Jan 2023 04:04:19 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g5dnu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 04:04:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEE7CvpZlflmxQg5rp2SdnKp1shBq/HZoR7kFnZOEsQ6TkLSdHV9kiBEbwp4CJeNIFIePvGEM2ebinoG4QIwpt5tC8EEPGjv6Yf7N3PMkIRVvpmt3dOQqkv0txoe1ICxjXHWYOXsQIMQZl1L0UiZc3wMk0x0l2Bi9vLr6q10BUqh1YTAPMUko94BNMEe412sNJqQmQ2jGI4KWtVy3IFlvN09/YCL3jOt3fLbQyxxNAEDemZsTrwbzj9RePEy3eyRLqo/gkLE+6fG9tBNvJc80xJdEFTogLroWFI5A3ACpD0iliPYKaiEOTzMzaWo1eQ8ZMQfQsIo/ugS0ioYDX6UWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gPzJpUsMqXNDhxjEizABIBI9PDSkNjc8nd/YNchB/4Q=;
 b=DpJ5oYVg4lUhnVf/7wXz7wHloPrYCDn0OJx1qZz2DMPjS+xfYTyMSNANDWsf7oJZIFV703bJ8z0V3S/LtN3XDC9EaxfUYb9IPzaOtP50FFQK1I6Uy2EPvq4w4GxW6V6Y/UtN7ZCaYykHlRH6svSNk02HzRpUVkPNEkmSsuwIor/EqQBGQQSmuA9PKI3g2C2o0oGPUr8mNEPN859ZemvoMGHd1Bp5rqAEOKm6GVqUFzKrW+8NjMwzgYg+NBvkdpbjo4aevcQInWcj2d8uuiNbbfMXnUU1XCyHOleNu0+dTq4W+SpkHrp3ZXYDReVi8IMDdnor/hZCkCCn8Oea/9FHwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPzJpUsMqXNDhxjEizABIBI9PDSkNjc8nd/YNchB/4Q=;
 b=V2EoiRLpK2dbs3FDHUlK+q25bqe9CNjC3MU3+Ug8cyH0gwye7qRkhcqMw0nEInIeKTXw8uVrM/XCyJ0G2yRbg9iiZV2K4mCUfLyUspMrfilaWkNHLSxKW9EWMIbBFNcFk4oE3LKlO3JAjMLMhaopmWLtAN6KOq8wxXkL4gvbAjc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4667.namprd10.prod.outlook.com (2603:10b6:806:111::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Wed, 25 Jan
 2023 04:04:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6043.017; Wed, 25 Jan 2023
 04:04:17 +0000
To:     Brian Bunker <brian@purestorage.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: The PQ=1 saga
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a627l4gn.fsf@ca-mkp.ca.oracle.com>
References: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
        <CB441742-2C22-41A4-95A3-10D251C31F5B@purestorage.com>
Date:   Tue, 24 Jan 2023 23:04:10 -0500
In-Reply-To: <CB441742-2C22-41A4-95A3-10D251C31F5B@purestorage.com> (Brian
        Bunker's message of "Tue, 24 Jan 2023 17:02:16 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0015.namprd11.prod.outlook.com
 (2603:10b6:806:d3::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4667:EE_
X-MS-Office365-Filtering-Correlation-Id: c78afebb-084e-453c-d8a4-08dafe893aab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fKAQFbOIvZ3BTHjv7GhkUqeRbH29yHL6cE4omeOAarziK585KrcZewKmDa50So1fPMLI9fpZudOpSuwX7CW7SCWSwOHY68Fqfdh6KaRRbBFWt2zOzkDGo4ybXYTFn6hiVgoIjsDF+AGkmdWaxKlkMpFq04V89KbksSV7fsA1FhyvsSRY0Cyxt7PUb8YAdNRE1AbbQKcrv7JpgKBrIqBswpGZVH2qRWiokdgm8KrAbp14jkkkFM9IlVCQsPQUvC1sBvkvjhkwjXf5DQf8x4ds6y8bJe2Efxa2GVDdi1K2rpW4rmjcpCBzuwpuqnZa4ZJs78+S8jcIRDCaKB31S0nf6p3BcQoXYNURA64WM4oqOE3leANmxFCWaMA3GfzbWqIbZPZMp4xWpVLKvz4Za04dM/v9gQP/lcwbYoUMBlCi7sc2gxqK9WgZt+95NiS07WsV/E50ocZ2cGyTCinfzjJcXdhco6PkUbUM61xilgEY1y+/1916nxuAwE4Ynzl8UiqqsX8oq6u6P1V8rGwZOryAkuIEbmrlHdyEAXHSwddxTFY6hmORK0IyloQBx4cltaYRPSkPlvCvxwU1yVsAR7krGEpF1tIGN3rc/f7A36FEzw1IewT3cyTEP+/TQH5J5pd6jgSqi7FgBgoBgt7xkME0Rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199018)(36916002)(316002)(478600001)(6666004)(86362001)(6916009)(26005)(6506007)(38100700002)(83380400001)(6512007)(186003)(66556008)(4326008)(66946007)(8676002)(2906002)(5660300002)(6486002)(8936002)(66476007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w7tAd1T8GL0Uli2ONLAdr5l8oG3WU23i0hLT/aWJ2G9PtfyMA/gav7M9Ny38?=
 =?us-ascii?Q?xmZbJQIoEl7UrXKbDg4uqe//zkWjGe0dc11ejBvPT6Hrt6+9IKAJcsFUkPvB?=
 =?us-ascii?Q?DT3e+OAOOIUJ4QpztFH2ihm/cNmvTW1hUe36P54KCdxGZKx8pm/q3Pg7BuZD?=
 =?us-ascii?Q?A7enJO+BmtVGW6Ao9ngjOemH5GbXTZyCuoB9T48paYKSFlv1cchn1FMpG5rR?=
 =?us-ascii?Q?EAmlOR0R2CQEeCBEfvCwlfCY0z5/CZsAMd5MU52d/DAVxw+sKSqG4R9MbDNb?=
 =?us-ascii?Q?3s+2sRxiWADmJmE21m3aJ52HBkzyO18ywc4zAe/+vzUsAgGJp/MmajZk3hm6?=
 =?us-ascii?Q?lWNrTwRdsolGqWSve1xo+LsinggtTr+wtEu55iLJWo+rU2NmsLKh9dsKu8Gk?=
 =?us-ascii?Q?NGeL3U8VgQbeRk3LTmyUbTcCYrPodkHlZGJMYgRGA/2bsXcQ5jPCA61a/jlE?=
 =?us-ascii?Q?BFWrwbbJaLqTW5PeAuHv4WykXKm6we6N+3snzEonHG2mDw4jRwdZRG7ZNPgt?=
 =?us-ascii?Q?xlM8aHgAvasujSLjpoOGg7dr9fPJBKUc2LDS0zVXxJ1cl9b4DHveeW/X3lOc?=
 =?us-ascii?Q?nBU675UipaxxkW/sF8lXvAu4DHtqmCj0o2CuEDsJX264Kw9J2iEuUBvHCXIh?=
 =?us-ascii?Q?Y/sidfYuLNnS6ApCrQiBreWF5qw5DYjsx1gz8Cq2fdAoHqSy5HeRVbTWfsN+?=
 =?us-ascii?Q?LCcfxa65ix5HEYlNOzpuUlZhypwZZRKLn8ix7mRpLNCLpwTMDKgNZxEmSs6L?=
 =?us-ascii?Q?dSPWDX6FWmqF9hZsgmeSHdEz808lmLgq6lQRLNZ4y7pgkYC1gQSudVbeeMzZ?=
 =?us-ascii?Q?Vcxu4lOr9u/pw1GlCSfAfYINPuERZ/la936vrFRUuqZSCLhIEUOmcLhXjoD9?=
 =?us-ascii?Q?j8l3/VuK9n3SIr1zi4P5koI+CcczNOoGScc1W/6lErttfUSgeK5uTHwLdON/?=
 =?us-ascii?Q?YKIzvsK8P3gO4GEik4XOxNEspkg5arjvjBZRosyu4ue4A7P/XlY4XBqRA/yC?=
 =?us-ascii?Q?LkXz8SmnHvUXHF8OwF3lCc26hmlRBdexvmAz/LWAU+fa3xYm42abzdkt2n+U?=
 =?us-ascii?Q?vhZj6vSAF7MgHFmTlCJ0Ey/La1vICcfWvaOC23MT/g8hfPpoPqF+S68pfjmm?=
 =?us-ascii?Q?IVSVqeAJn81Q+a6pb3o+Hibr97zLhjiuUPaOtvJJhYPxotYot/4YCztMQ03A?=
 =?us-ascii?Q?lie29BfsFe8HKXGwuKZH3xPDpvLhiGojHx3qfBn5sOsO5yUVhK1gAjGunkug?=
 =?us-ascii?Q?yDDY2iTJynCVNsgnLaKSs+kBldB8jmgDgNHAJIaV0PlzAvWlVxSkmQ9tDB0F?=
 =?us-ascii?Q?e1oCPg51KZ9U4sPwFTrQkGbEJEPdR8i99F7nVytjk+EGZ3OOgHeAkJDwu8NM?=
 =?us-ascii?Q?fQciCbh7pbuegTQqRLHStN2NZdlU4MyCSA1rnIdHUy9E5nS4k1Xz4WW2svCc?=
 =?us-ascii?Q?8o9BzbqcDh2ONStJGXj9NvJP8AFc0Mp2aJbuW9dSrQAAYSQhJxvkUcm4t8DP?=
 =?us-ascii?Q?ibiMtcB3QumupJ13NH+ttbbVeJ9PuQnxJHZS323//sEjA2xU8mEYiBNoNYnh?=
 =?us-ascii?Q?Nuyl3wyu1HnznA8K1a3wM/GFUWd8mPjML2zF5qOqvsuqdB9WOBdgj9nL3hMA?=
 =?us-ascii?Q?hQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KRJftaFskzNX1whe695O+G3sJSJ6JMvNzINN3HLkNUgM7PHNXs3cvmTkrHD78I0Kf5uvJjlEcQ6tt3JIacohktE+Y/sxnix0ZhthoAKQITflw2yxeMN3x+EVlWW8DQAMN8ymyzUL0It5+MrqIeJSZ9ayR2LRAetlQQ16LJHSJGMwJ+WBLe2cuh8HAI2VhVgsMqEMk60p2I2fFQIztTrNEJhMdqp6xUS6b4hX1kit5kDvmW/cXxn/oP8f2r0pAWdsJ742F1K7w1+UBFLGJyHt1jOzJPkyEefO2sy7trmC7Xp0FxJRLEQPM/fCk2Mx+nJezvdy69YmHZLl5G9zXLLMVl16Jmdi3hROxIh4U3e35ndeuIOuSpfFVw5If9gw5TAlc3OqkNa+E+CpNEJWKWAPs66/A/u9GTWVbsey6+ZEyvAC+51tg5nTEmnuw3URMGru/php/jCs/4AA54dbuJ5BIwkaOPCDG+koJ99/qljexXMYb3CIG6G17vNMR5laYWXcm9roH6Z+1qEPcGJcmtJHNwfAybUUVK32KyAa2GmG779hcqR9uJ5rdfgnR8adHZTo+3jjseQ4kM0/ww4qazmfefs4S3jwmhhhlChTdBRVAcbtxhAd+cH7oxr/7ClcMRZXNSyEYB5QLDGLUgs6y5Eu263s8HdxkPgFU7rDzItA1WoGlEE9z3VVGUdsGFdqLgtlXca6HSa1UOlIv/qgBq0z6dFLd5wKupBOU0s+TqQN3bRxenNJPDmi0kR4Cg8ha3RxY1LNNnAPBTkiJyEXtGqRAl6jvlZ0uSvo+ZopSLSj2VrzuRz5N5Ag7ACedugcrf4e
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c78afebb-084e-453c-d8a4-08dafe893aab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 04:04:17.6380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KB2CxGdNgH2zEbYfHp79CR9WQ8eirfrGb6muiRpJp9GwK6BFbm1gG90yJaCgLDKLiYOMbhw6zl1JLkz6yMdSD9EJXn0yLmaSGEbvvn4aNQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4667
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_01,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=2 spamscore=2 mlxlogscore=175
 malwarescore=0 mlxscore=2 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301250034
X-Proofpoint-GUID: EsBaZHrTWj0Zj7cBelwRlG4Ah9LrFsr7
X-Proofpoint-ORIG-GUID: EsBaZHrTWj0Zj7cBelwRlG4Ah9LrFsr7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Brian,

> For a completely separate reason I would like to see PQ=1 expose the
> sd device.

The host RAID controller case we could probably cover without relying on
PQ=1 at all (we kind-of already do). But there are also storage arrays
out there that rely on PQ=1 to inhibit devices being claimed.
Historically they did this because some other operating systems couldn't
handle a processor device type. So I suspect that keying off of TPGS
alone is probably not sufficient to determine whether PQ=1 should cause
us to attach a ULD or not in your scenario.

> ALUA state transitions from unavailable back to another state does not
> work depending on what state devices are in when they are initially
> discovered.  In the ALUA unavailable state the peripheral qualifier of
> the device should also be set to 001b.

Yep, an unfortunate wrinkle in the spec (although it makes sense).

> This hole makes the unavailable ALUA state unattractive. Allowing the
> peripheral qualifier set to 001b to still create an sd device on
> discovery corrects this hole.

Does your implementation actually support READ CAPACITY etc. in
unavailable state? Otherwise we'd end up with zero-length, read-only
block devices with no logical block size. And we've been down that path
before and that is no fun.

I suspect it would be better to trigger a re-probe of the device when
transitioning out of unavailable state. Most of the logic is already in
place and we reread VPD pages, etc. I believe there are only a few
pieces missing from being able to do a full in-place update.

-- 
Martin K. Petersen	Oracle Linux Engineering
