Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D3BFC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 May 2022 01:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbiERBLZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 21:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbiERBLK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 21:11:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E366950075
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 18:11:08 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKTWl8029120;
        Wed, 18 May 2022 01:11:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Ies1oDkXgqV/tOnxweIxaZHxNZwm2EcCMpAwxzGrkFw=;
 b=RXVhGl0ExnBmXF1p+io4KfJhx9cCar0C45HLY9hPh1bv4p4GeiK8Xx8dMK4Na1EqPv5U
 Y64Mpfbp6Ho+YbnG9JBsGNE/JmhDvq3OeNV8XFYrk5/fK0m2XAYh2DeW+iidCzl1fch2
 2y7iUCAUW5grGyRpaFOGmxTmkbsorcAIK5Z9qMI7utURGPLZ6msuVL8VLXZ4O7kAxG/T
 0AjL9C//wn1QespwK3FHNlc2umZRJw0reDIQGNAbn5LDuJXBdcNuIXS8KkeNPvnATzMM
 yriHian0kl+5+SHUFoXPOXXVbLaWeWNeAbc7EZvc6yp82NKizbDTzoyRxeXpvkNMRYNJ Uw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310qxxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 01:11:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I19wTa024470;
        Wed, 18 May 2022 01:11:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v97xnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 01:11:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOAoa+auevIU47dH+txXuTv9W5Ahwgq8TN695+SvahOAV+uEs2ufs6PbXPmFIEG0q5x9ieWFcLuNxtnu1vkgQNWkWVd9qg2bzs/zEegmdziki119HNwNaKh8z1g3o/fC8J1MB90Vt4YguVzTKMQst5UX70WYc6iKI8byLSDffAGkzM0POAlryBKvQhnU8YnAMaiGUihSmJ7GaEeWy4Pcdy+KfEpTpIQaTepHVqdIF8d3YcbaF7EHCC/YjXbv3kYZiri5a4MGfDx3M5MpfNGcNchSCU2z11WvUq8zsZEtQXQ4tfru1Sz9oQd25eMgVkc53RMCQnxgz2P+xhSZaJmh4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ies1oDkXgqV/tOnxweIxaZHxNZwm2EcCMpAwxzGrkFw=;
 b=ac/fJ+JnvASZ6jZccxReyXOb2AFyBxL4HEYQyugBXaNgCdl9zeg4vTHXs+pYholR8jOTdbeo1f28POjWy/gsTM4t0SWAg/zYCm6hoaAfESqejOGCNzSMG0YHJ+ynqDisN4jvQkRRRt+spG/xNiTCqZJwOlXMZDZSRd6BHoh3qe2dBqjAjyWpOBh1afTaX6dLdpN2QWTdPLWFPPCLF3WF3ggenoio2MfZbSB2EvVykUcXHjN9GgR46WqbESRBcquSN+5EzVnxIjt6Q2w6Td/JPr02c+/FmXm5nWGtLyQAOBMXzKIjrPzeSEu9XYe6SbPz65my9BnKYDy62MGICZpUaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ies1oDkXgqV/tOnxweIxaZHxNZwm2EcCMpAwxzGrkFw=;
 b=njgPyyJ7gO+dLld+wc36ojA4CcF9V7vQea+rGAa7sWMNfF5RtrAsQvZ5xXCeCNxGouenkpIXm2OPIrrtvmB3ae1GMT89q3Q/28Mdp1AQqVwgQFoPiVweJepHHiGU7azQaRcUxDZKpT8b8zRqwDAi/r6r8r6fozo/flmrYFgaG3A=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB3482.namprd10.prod.outlook.com (2603:10b6:5:17f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Wed, 18 May
 2022 01:11:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 01:11:04 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v2 0/2] mpi3mr: Add shost & device sysfs attributes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee0rodb9.fsf@ca-mkp.ca.oracle.com>
References: <20220517115310.13062-1-sreekanth.reddy@broadcom.com>
Date:   Tue, 17 May 2022 21:11:01 -0400
In-Reply-To: <20220517115310.13062-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Tue, 17 May 2022 17:23:08 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0083.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ddaafbd-9eeb-415b-bb83-08da386b4770
X-MS-TrafficTypeDiagnostic: DM6PR10MB3482:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3482BA61D27EAD3E72D340048ED19@DM6PR10MB3482.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p9U5xzbtvsbZv9nqDZRtk9cDce0w65me8HQ/cZOh9NDo0ORb6Lc82MVSHRmPgDTHjb2fe2v7zZ3MAi1xdEtBgi/PVgF504QVjwdQBlcNBCzM9aj4bgEq3pCJ6tRU/0rvIMDbciogccG0inXOtBi9+icjBMq/QEkBDjexUk+oJksNsR6O0V68tnCYxKmY3JlucLdLBGvWE0hZzBdX69+sPTczboJmY927kQ23voxrHmQ1grAHGG+MuZumsYq95RiMV9XwToavLAKIEEtgHqHstuM5tvGdY0EgQb/iqyyesBrmiK4vErIDje9RKZ9oxllToTt8WPfPAyTblMnpCx7zkRDYhaOQrTBGUn0Z9mk4kMiokKyPw2mUoHBBe6Eezun2ja/IPtTkLpjQZ6PHoW8o6sARMp6E1/q+ZpVsD923aW6pWK+QaelZw/oWzabTuRxBpP8M0PZKsq6G9mazu+nP4xn+zRc3J7uCNtPkRHYHmn3VBRWBWygf1jaK3qjPQS8ltdZQVWbkMryUxn7EEwvN0m+uLQxZz/SNbFHV1eYF68CGFUMFjntLNNckE5b4rco3IC2FvbHELkFJqnExvUw5LqudWvf/N5P0du+Aig+RLu2zKlBJeqWC5Yzq1VPqtGQkzPaatIu5zt+6eJ32rtZHL3R5ISaa1FfzGi2R2yGluFhlHD1/FF9ref8zh274JEwhYhlN5Z98Hm0Ur4UIbALFITlPJCe0KwfkEZVKk6kRaZE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(186003)(6512007)(107886003)(66946007)(66556008)(26005)(52116002)(36916002)(38100700002)(316002)(6666004)(8936002)(86362001)(6486002)(5660300002)(8676002)(66476007)(2906002)(4326008)(558084003)(38350700002)(6506007)(508600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BECMxR9VgxqL/5D+Z00E9Er66M8NGA9EsHi8VqjOc0X46ob0F1upsI6lJLLC?=
 =?us-ascii?Q?Wjn7ubfkhGkUHgELvmh70Z017gEbzFOpWx/FJdZKi2WSk7Whz240qr1Bafcs?=
 =?us-ascii?Q?30IpM1SRF3T9iqSg3cIX8aOX9sJz21FERpEtguljfZ6b41i+vZV/BIY0Jzrf?=
 =?us-ascii?Q?8yWNXQSdmv8a2OpfwgUbJ2v9GdfoK6zP8f8UpkJSGVOKimluxe9XoGDLZ+du?=
 =?us-ascii?Q?FWW32sFv33gSNdHC4zYLOfNEbh+bZPFAXpEQzRl/H3exavAN4F4cVnlD1zKM?=
 =?us-ascii?Q?QlMuDcrOddnXAXO2dvYrE/E+gLe061eOK8yfdjNSnuKzX1NXspPXuY1oYaOv?=
 =?us-ascii?Q?r4gqWZn+fYqjsj8V2Rg4G6JjeDckYr6oLDNQbEU5tVQuF3ETSP/0+yLCalv1?=
 =?us-ascii?Q?ws01S8kfCWETrAeCIYhko2Kl6aJVfcF1IjFxI7oHMc+0Fud2ex8gqMyRkNDi?=
 =?us-ascii?Q?D0WSAfW/sMgJyFBR6dgTnWTGnFBSktbunkEdao4HNchQ241MneFjQVKbbv0V?=
 =?us-ascii?Q?WyWS25N2NRlFIzAe+dGGfRsr2JRPJ6ywzF+fDu2sSrAvUf+msflMg4kTohXB?=
 =?us-ascii?Q?0SVuuoANDUBuUPF7CucUD2uUimxtRlwIFnAceB5OuE8+uNWKqq6qrYVL75/O?=
 =?us-ascii?Q?gCVgq/m4LaILVzetlkW29Yzbj0zJR5QaAPJhAdnxqmYzKXoVkQDB+pphJp+7?=
 =?us-ascii?Q?l1TV13xCmOMopI+vE9Gi0tOO6JVMj3zP+maaOW9GNT5XRrGp4leI3mijB8WD?=
 =?us-ascii?Q?j5Sv5DxPFmarnhLqJyCnyMX7B5ouvB7xsBiXjXNy7DLShJ0Thha3nRMGJPX/?=
 =?us-ascii?Q?152A/2iCJagsTpldHBin+c7PIkhwU3nzeWySqXXXXSnGmN6/Ja5pDMkm8sPF?=
 =?us-ascii?Q?SwLvf4KK4DIEYukZd/Y2qoQ+ZXUSx2RFUCqj8MpXah/XPWECeKKjfP1huBKz?=
 =?us-ascii?Q?6FD8mWalTFn+lMECNtcK+9Jfz2io+EPi/YZlOGyr7d7PzUT4GoSws8BoOLf7?=
 =?us-ascii?Q?6xWVkSLMcGCU761+4+/UvFeIpxxDv5mQjXgMO7hhOOK/PY2rS4eaQg7mK25q?=
 =?us-ascii?Q?aQ8uORao729DCoX0K1lv1jsSL76+2uvN79ytVvxfJM9WaD8dqtsZ8zMEdFmA?=
 =?us-ascii?Q?Tz/ntRHZ8GFgk1QhRrzQdLAfFM35ITiUWWxTFoEM+49yE7eJJ52T1uI2PRLV?=
 =?us-ascii?Q?ThLqDrS/fQnBFUnZMEhCAR6k1lNCzyJnsSq0jlK35y8xlOWwaGozpaOLykcc?=
 =?us-ascii?Q?OPafrS0mqtzHvFzNVbfAqSHdSYLZbaSFLg9I1VO/DkTUz+ZE3DRqnbMZg/jV?=
 =?us-ascii?Q?U1i52TEgh+gL9EKJeh0Tf9itNyKGq10cfAr8DH27GXqDOgheEKYkYpGdQRdO?=
 =?us-ascii?Q?rVL7NDsRJgsAp8PIQl2UHfHIkoRXU232+OVjcd2SxdpXzzDGZFqxiUGM9eeh?=
 =?us-ascii?Q?VZb+JbaajvAPU6+2NGk44o40g9gS3BKi9d5yy3Gg6Mweox2iKNdAw8mzztP7?=
 =?us-ascii?Q?4ICWnxptHH+9pdsL0DDME2+20B3aKHqjkZP8QdTw2hv3QRpD/40dNcKpp3O6?=
 =?us-ascii?Q?oAgWlC0DCsSvdY8OW1gOVcz/UGDqkWsP0AzFJK/3nUtii6ZoCpHEiPE2dyBy?=
 =?us-ascii?Q?fNetxC/wGSQknl9/TseJsHkIdgoY/6zjlrjbModIcDp1cUjKYy7ASGel2e8h?=
 =?us-ascii?Q?bVu/1rCIXXr06Mtqv5zjxCBzcq1WC/GtMCkgLBhphCCKt9Piz8hsX9iXsLCm?=
 =?us-ascii?Q?HS9mhOO115N2wleboBiAqRJXGHmiMNE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ddaafbd-9eeb-415b-bb83-08da386b4770
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 01:11:03.9292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ARhXr+NHnGhfricgrhpzDUWqIfNz+dXBw0wIo5B/fKS0zC/iQQASGlOmhErkRjG2MxNETpcBQljYXG+b+VKk2CVcjIug++E885VyC/zyVpc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3482
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=726 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205180006
X-Proofpoint-ORIG-GUID: Q_cRa7Ec8YXYAuVP1ChSzeJoAabBSzSz
X-Proofpoint-GUID: Q_cRa7Ec8YXYAuVP1ChSzeJoAabBSzSz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Added shost & device related sysfs attributes

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
