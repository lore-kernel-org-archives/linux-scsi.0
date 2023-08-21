Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F36EE49A6
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 20:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjHUUdg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjHUUdd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 16:33:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF16A10D
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 13:33:32 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxlR4024002;
        Mon, 21 Aug 2023 20:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=9LtZpwa4HfeSAtmpxaTNMi2/QJ3bVlHJUTVgxQGtS30=;
 b=3u9fq52UPy3/56T2UvovPE5YSfsq6BUenj/TIu429qko9mviYJaoJd9sJwkoZK+bGHYk
 BH4pkuXOpyCfjtscqfJB41rmV148tnstXclPD1GUnktRnjbzUrRwi5fwE4jJaLLE7BXs
 ysnClPzxETg0dJQylaLMKQQjx/C+x/16SwUVA/k25Cq+odHsdX/CaeVXHh5RM7gnniuq
 Tjz5PJNGZ15LvTrHuFzcQ2AqCjfc7koZCZwO1jlPUoLimGUVKXF6F+52n27PLNq/x7xJ
 K1e6BTWjUz2QSkcOOhCbr7fCNl3l1/GtUeABT1Cd/eTXjIx1mmcL7E0Xz4tT5K1+1qys hw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjnma3s5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 20:33:20 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LJrJdr007978;
        Mon, 21 Aug 2023 20:33:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm63y7us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 20:33:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQekBo51MDLTc/grIfmhJRombQhsCtSF6Th7xD2YkkoXqcG9VytJdUDgdk/O4Ny8GitUmpJOAW7j35XZ/u+ipeU/1pWb71xAZIrgHNBorMp5zSg8WzHQmc7hEBX7/oU5CGk21A7kTUk35QDjOawycf0NXNb3/eUfepSqJAcaDjwz1aPjlivoJNCtlpO5KkpROOV4Pf94oujA7UHLv46yKEFyhw83E6I6OjEKToPurOWsqLVkmi+aO6q/SKo0zwOBid81uVjK1Bchxna17auLH53wO04I+6wWLDTQ6b39bNPr6gQ7/nTorYA3dZPiv2xLW2Kzh8nfb5/eMKrdhs/lhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9LtZpwa4HfeSAtmpxaTNMi2/QJ3bVlHJUTVgxQGtS30=;
 b=KcDmZLwd55qZGbGkhx+GlW2afQR0FWqMVPkEtBkoUNPdmfhkjyJzfeuu17nSJtkJcgeARsMZ1RS7zDStmnGlVtLiUa5g73JmLlGISPPOyeodLzNoHJB1+J9nfdRrBZ40f1dv0qMxlACp1T01Es9i2khvlR4b9dbEgdLyjv14pVwMwnUMw4ecJF4UNZmwq4mMDwUZWdMgqXIbZeFY/wP+skfqsNfuT/YyY3Lb/m031kh5T7hofER9KcF05M1tDqgO8ib65q1oE1niJdsx5PuqcIanNSvv4QB52e8cZBO3MIqzbiIY1tvX56izlwISENCyOFdpzWO8/2LKsDSmn+Q/kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LtZpwa4HfeSAtmpxaTNMi2/QJ3bVlHJUTVgxQGtS30=;
 b=QIKd3jpYQ19YAVmlvwBHYuNErnT9Da8IjanUvRHDyJFDEgRW6+C/TiE/gcz3byWzEZ52wI5S9dTGrAd4nvy7qjYNzYkZGYUBKdmpSELMixp/oVSKudwMkJwqQKEnuDpsx3WVF1Xf5tVPKufmPIDtRxEdZFYHGRGh3mD6GgoLITg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4560.namprd10.prod.outlook.com (2603:10b6:a03:2d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 20:33:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 20:33:16 +0000
To:     Alex Henrie <alexhenrie24@gmail.com>
Cc:     linux-scsi@vger.kernel.org, linux-parport@lists.infradead.org,
        alan@llwyncelyn.cymru
Subject: Re: [PATCH 1/2] scsi: ppa: Fix compilation with PPA_DEBUG=1
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17cpo9lvm.fsf@ca-mkp.ca.oracle.com>
References: <20230807155856.362864-1-alexhenrie24@gmail.com>
Date:   Mon, 21 Aug 2023 16:33:14 -0400
In-Reply-To: <20230807155856.362864-1-alexhenrie24@gmail.com> (Alex Henrie's
        message of "Mon, 7 Aug 2023 09:52:57 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:806:20::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4560:EE_
X-MS-Office365-Filtering-Correlation-Id: bbf3aa0d-9b44-4102-d731-08dba285d97f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vElsx1Fzb9vkrYZRLIbY0HGNM4dKEMg/mRwwSEa0KMSk1zlXd0jpzPc6/qCBhs5fgXwFYP4tGU5Qem+coDIQwCF1YYpHQH1j2iBrL8Ccfwto/6ginKOwJW93mC0UaACP3+QqXpHZEU3mgEiMKQ275TGrpDTA+p74KCzbtZEOLu2r89Yv+ogqZp9sdSMbyJFKSy9XC+2BIJGso2BDC0rfiwuDXEv0vzB4S61TSnNEIJteg/ZrN0xkgP7qyzaADk9pJDkTkAT+AGi256+scmvXJoajErB7ZSaZC9k8NwenvOiHoqyPj6L1KPUm8igHbq03rKxkOrVts37vz0U5deOE9gs2sUBGnLqwI4/FSHajOdrd8xQdr27EeXrDRYJkkPCjwp56YeJWbtmJEGOZil4Dm7K/3kGc16ItA+GXyzzNrKPuZ7B02nXaVHGKnd2M5XhI/a2Z7WN6OuRvJ+abJSlalVKwiea3awU2AZEE3SDLxix6FdS98UoGm3ZOIiZ+rk8FNoLN4f/5w3Y0cUMCAC0s1avyqniqz1qqvTJrVYu7HLqEIXCAOc6kqJUJZV3gZxKE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199024)(1800799009)(186009)(2906002)(6506007)(38100700002)(36916002)(6486002)(558084003)(5660300002)(26005)(86362001)(8676002)(8936002)(4326008)(6512007)(316002)(66476007)(6916009)(66556008)(66946007)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?blfjal1HvcOJyx/bLnsWZIP10Qvexr/yMq3u8A9ubWtn6+5kMpfxXZMfAtRC?=
 =?us-ascii?Q?qZvy6fq+PvegEwkONLURW7pJROHCeaeQYvxvmRCKd/HtFcNDq/HgdFD6378o?=
 =?us-ascii?Q?z9voGU1Tzk5miRbDsWB3loMaRIzTKsKzOmYKewttxYpp/wScES65HgGUkhEb?=
 =?us-ascii?Q?UlgBFy8PsZHr7axBxOqozK7vd+wLJp8H8bGIvKgqaXsjU+4GShkDfrPQWMGD?=
 =?us-ascii?Q?lEKJcrGlUrejxlE3cI1ysEiW5yXAKr41zYEPKAwg4JgVwpSyCmUgirmWy6gt?=
 =?us-ascii?Q?vzHdR+jdXtVJfssQ+Lfqx7aZQOYQ8sIAPO2+99tksRu4+oRoP4uTaoh8tKpn?=
 =?us-ascii?Q?hOr5HYdclGv8KfFK3K+YogK+ZSH0UKnMGCT8E/ypiV3YiEmbiLcpuNpLHwP9?=
 =?us-ascii?Q?jD8EPpamlQowc++BIJcVzob91q9cS6gYaf/K07qF27oZkryzA1Qk2yVI1tYO?=
 =?us-ascii?Q?6o1hEw+RAK26DN4cjlml6cw0DeRIYIszlRvCeqOSk3HO1Zn7lBybr3bG+Odq?=
 =?us-ascii?Q?AztYg4gC6MW0xeef8B5Vu4AN3yKefitjLAzspB55Rz+2FArgi22KVbvrXWdk?=
 =?us-ascii?Q?GAjXnWGa3KsVFDYW9iaMsIyTtgzfJXEcN9jeb4FyEkuxm+++dEGekiM2ViO3?=
 =?us-ascii?Q?Ns3UpZbwFgQ2ELracn4v2qHZXbMTecbuTwBgSF/4oqYK6Hm9jXkR/EsMmcqH?=
 =?us-ascii?Q?RoU8jSHOuyKKzhVX02ZzFaOoQIIgxuZUc2oNvkNJ129KlpgxP5eybdqyr3xh?=
 =?us-ascii?Q?xInforstfRreAHT5vco9m/tFyWpkLDS93VjXQ5qrElXyDPFUsqX6s801mqX+?=
 =?us-ascii?Q?8qqm8sAswTTb0drUIZLh/Ab/yhpZAzoe37964KH2M6eob8yEMWvD0mvyJBEG?=
 =?us-ascii?Q?cH3VrJdTY2+QLRVnrwlfxT2gDIwdiV7k0DlJg6PqvoS1QTg0taBYQvYfCVAQ?=
 =?us-ascii?Q?4t2u0LkQQp9wHVVvlacZ/JhLrEfl5Ys0N4vcab60k54ogcN09PkVJhe4J95A?=
 =?us-ascii?Q?0zCm53+mg5p2QIcze7aXCm9DmvAI6IvGaQytS1AQ2MxzTBVzAryTIU25Uo+n?=
 =?us-ascii?Q?ccvpd9Yu3o382RG2KmOahlCH1PVBq5tqYBN8tJpY4t/U+GqRxtHN6Dj3r0MJ?=
 =?us-ascii?Q?8ImfVM4oLptpzcr4lCr1mtOnrRSIJ7/qJocTseQTM5JvN/5jN9fRo0TZLvA+?=
 =?us-ascii?Q?SI1FwOaxxzAOOOwXg8ZWhaegBtbG17ZpuNkyoAnvWQY5xKefucruPSAWQIo1?=
 =?us-ascii?Q?5oBhvNhbvfID/Uk6w8yTKNjHcJcCTk3+yZKSS1PCdvjdIKRX3DFsb9r5Wu1e?=
 =?us-ascii?Q?fM2GEZqkB3OsHFT1BGrLRrzz7wvf6LLU0tcvaUpd7ZRcsJT0nkXnOevlfH7k?=
 =?us-ascii?Q?oe4HQfd+xXGZJP0Lhs0xBn6GITzqTyZFvwhg/TRvntjYo+2+9bQtxSdtzZxI?=
 =?us-ascii?Q?a0yenDlASv/4e3rHpHcqpcYddWkHvZED14Fz6TvVLIkBuTKUHRpRlqX2Zn/0?=
 =?us-ascii?Q?dFlNhknbdBrPUzTv42W5rWB32NLD2zslzuNNCFiOE8S5y9iPa2SwMSzdZvdH?=
 =?us-ascii?Q?pzEoilIllgtGA0obyEf5L8HS7ojyDP4IH20S1vMMUGMeshI8jyue8LVY5ADE?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rMbaNE5bkeQDAVaRFkzlNugpuTmCUNVB/pDiZIHBcovom7wX1KeKYRkLsu2Vsqq7paRVmNyGbyXQMHRWz1eVNaAHgpNVUHllwreouF72kw0ngPGkTCTabnwJvzkLt//AEiEOBmbUF9SQUiygEFc7X1WV9uL1MiQD6vHmUwnoMKlCTQ6dR5tXKnu+UkolPTsPsr2NLfem9gcN+ZJYQo6Jjy493KHIjD/tjgE85hIXeJpW8TNHEDBAGxtajyHyZiBOC9Lg8pKlB1xwrx+0KznWxTUjaVge3daOSBcSPYwC3e8vtlaidEugjT0DdMs58vIx+e+7jQNEHhwsSlVbgc1K3P/YWSwor60rBkxAoKjCJmxMsOXQIk80VrkH3NLLoFK3PCeE4FLCzQdqJBSLfBCKdv0mE3FSIT/IcJsFygevXI7RDmTpRCnjKXJ+OiJALq+jzZH3f55wEGxuy8IjfipABMhImOsm/6Ug3s9WDRUb46bUkyVEdDSrX9ySBCrrDkCI+TEoIhii6fHEZwGFRq/4aSwNHPaVkKNdEdjg0/y9Cp1t+3nQiJ5Nv9fmZZWjR4tY6/MszLkyDNdMqgbq4wekoCaxr2gxNG8Y8zw+PYg74PXBgWeYZxrriU9fmqcMEM5LD+bIqgd6NqsSX7Hlu7Ch6jD9twVsvZ3PdcjJPIyyBkCrE6daxDK9et1View7IUOLIi2gnAkKmXpvgCBt5/VipRyL3ANxeKMEBf2SipFPRtgSG3iZp4nad28j/6mkByChfjO9ndqKdULLRTihWit8s0kvrqylPGn9iZhK9px6Ha5d0fLhxLPhuh/SIUJLECRBm5hK/1dXr9MVHubL8rbE1vYsaJKgWT/m4eDQ1MZ0yVBVZUZgU5rX1C3WpssSPfAN
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf3aa0d-9b44-4102-d731-08dba285d97f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 20:33:16.7380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TxfZCGeo7cTR8kCLHmfqokcKYi9iqiw+kTQxv/fY41sqlZIG82Nj9OBNFE3W0CgR70Pm6rkGA75HqpPhobMUNqH/0Ev83T520YZljPxQJQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4560
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=940 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308210190
X-Proofpoint-ORIG-GUID: gWO7lHS_TkMfaZbnWKYSRVSKYjYy3--G
X-Proofpoint-GUID: gWO7lHS_TkMfaZbnWKYSRVSKYjYy3--G
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alex,

> Fix a regression introduced in February 2003 in Linux 2.5.61 by a patch
> from Alan Cox titled "fix ppa for new scsi".[1]

Applied patches 1+2 to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
