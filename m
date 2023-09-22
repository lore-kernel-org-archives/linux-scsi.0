Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04508E7D0BB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 01:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjIVBmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjIVBmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 21:42:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A98F1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 18:42:30 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIsTmI005986;
        Fri, 22 Sep 2023 01:42:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=4oZv0xlpM+lzjPhEYhlyuuDnfY7RqQdFvqly/TaARrU=;
 b=XjFESo3GedRFBle+V6sCCsm/6bSKne4utk89xgZUlWtW2Bq0awVZSc5DvxKIQHY6bzeP
 cR1DyuLXyvQWofOGfe/lbA/tSZsrfX2pn+bVzdSSM0dFQNvQcDAVGXIs3wE7IBdT+onv
 GUd3Nx2TYRLgnlhJzkiesHml88PhFmMKGWu/gkYeDlCdcJfb0Wu+y1fGr3+jpusES3rr
 JjCfVDPZI8xZ4gccgUYiGEGMjnxFMRbHqOQyMeIDBqyJ7HP61pN4I4zsXj49PmveKmxm
 jW4JaEIUh2Nq0sYKwLUWhnC9J+qM/e4oSyQx6/19F1ErQg9DMSh/Li1OUtaLMRHUIlbP GA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsv0kvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:42:23 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMddZc040653;
        Fri, 22 Sep 2023 01:42:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t8u19cgpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:42:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXd5xBF8OPkTVbyaL4ehWnpy3XEEEN6wzpDMAOTRp05hafBbgQGqKCML8v/tpWfMN/Wgb0l93moLcpFMwaS8AQvkfAdgDsP+QnYH0y00NnLiOFuL33XEPo/n7jiHHKXH/BZfj2TB2P7gNf5c6BMRKcfZKx6md1J2jE5SyjdQzqtA9lQUXXuzD32NNE0RDJ5VclhoPSxSrM0SzbuI30B396QPtX2/uhGxM3FmiuV9XS7mIpSRJghxGOHQ/Kn9qerOyX3FWMfkLYbf/7VVMwX4mMmNIGTQjNu8oKSbhMwFQG9q4okATol9jWTn2j0Xj9C/UBw1/ZU93AGXOHg9lrJjhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4oZv0xlpM+lzjPhEYhlyuuDnfY7RqQdFvqly/TaARrU=;
 b=Yi1iOyZpGC2CcbFfZpBYow5Fv3nWIySjA46tcEm75RsH+3HlIh9YFUj07Wn5g6xDgWIr8w0REuypFWGiPTrLRgniSA6Sdt8drK0J1SuMWKvingN91M18jq81vbZ4uAAGfdxO3350r7cZ4FKEl/3px/YaAwy+6Ogf8tc9W0uo7Yjmjx2Wpdh84lpuhhakTe0W7d8gPeI9cl1nXi6u6HL2027EZjGQu0svaQ3+UIH+dbx4yUwOcxrPOvyEpabJB5t03mZTsVKPjjpQ4/BPLorxMW4isPbHEeh/6itdKv/GwM9evo/95HCzEMIi3NCbhNDzdQIanxEXiGnIOv2wwvjhtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4oZv0xlpM+lzjPhEYhlyuuDnfY7RqQdFvqly/TaARrU=;
 b=OQOwnVFu3Wx2jDJV50PUP5ReRWcqad31hXBT7IMITXVQb+GscNKAUbH1uBcMFracaFG41A7ekE1pEJbXqY7f2By5ggsnUNFQY+deshUwAdVRQ7IxBrdLI7j9QdIcwULAInZnSNZfTjZ3Sdnuqnu2hW7g9pwZWQSX+5UkIBV18YE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW6PR10MB7592.namprd10.prod.outlook.com (2603:10b6:303:242::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Fri, 22 Sep
 2023 01:42:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 01:42:20 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>
Subject: Re: [PATCH v2 00/10] scsi: pm8001: Bug fix and cleanup
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wmwj3ry2.fsf@ca-mkp.ca.oracle.com>
References: <20230911232745.325149-1-dlemoal@kernel.org>
Date:   Thu, 21 Sep 2023 21:42:14 -0400
In-Reply-To: <20230911232745.325149-1-dlemoal@kernel.org> (Damien Le Moal's
        message of "Tue, 12 Sep 2023 08:27:35 +0900")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0585.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW6PR10MB7592:EE_
X-MS-Office365-Filtering-Correlation-Id: a3935b79-8a0a-4599-21a5-08dbbb0d291a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t9E91vhyle0s5eGXHrtodG6lKrcnAbLquaAl+7yIJvm/va3CfFtTbYm82f1NLEO2iCEt9QEv/Cp0Yb1kwFBqw8I5z0ZE8v86VenOon9LZQZZI1w+7joWnnFnWLjK7U2ePNKUQ6waAiGxDnpFvTJ2eAyk7NhRR7jiqpU4cGHpdsR9aJeWqBMHjFjnV3VE3usEnuC5qxp5Jl2/1RMj6U2rIJTimN+nnaPkocoAeFMVX5nzKXPpXDEogwHybg3x9peIPobKiTTIjbKga7Lqx9mr5gP5lJJT/bmJmcq6UVi2nyOgEJix5Lkg5PKJTEE1yz7qM0u8OoX7ATtGPnssjqKQPr+fOuaX0faDVYEVMQqRnut5GyCmScwTIsk8LCVt8Kxd4JD2toOlymkfi3GjGji+WHNIby7fxw6O7xLamYVin96fJP/qijksTSiT55GuobmMYuQPc6oe8UZ+CTpRsEoyrtNMmj013rk21D+/dvMkjm0qR+VqioVG+wCP3X2pfiGLxvooiboalrs52ZzEBZ7nnWfXfsgtNDJcDi+9XCqA38LIx220iKoPCZlIdqJ5Rr1L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(136003)(366004)(396003)(1800799009)(186009)(451199024)(83380400001)(26005)(6916009)(4744005)(54906003)(478600001)(66556008)(66946007)(66476007)(5660300002)(6512007)(316002)(41300700001)(8936002)(6486002)(8676002)(36916002)(6666004)(4326008)(6506007)(2906002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+6D17XwZZpoOkYEhfDD8VNRDbr+dDJI15em9V76Xk6G9TWFFPJi/EFVpYCNr?=
 =?us-ascii?Q?Gwp6xSQ/a5xlSlrWRlu6u0gDmKwj6tYOyLROJUbYuJ20QICoKfo3uCzfT4Rj?=
 =?us-ascii?Q?gaGuJTTvUX38GyNvzHr24cvU8AMoKNqg/+lhbzMR1y1WWLZpHakRQrauGFDZ?=
 =?us-ascii?Q?4qKNM+AqTI0zi8MtfTkrYMLMOegUOnJRgn2t+hdB1KZEEgK89yRn84MWcBe7?=
 =?us-ascii?Q?HwBR1seMAT5/nXmIuCmH7SbIyf9++MxM96253wVoT3yZWv2t1R9WKMkfK8z2?=
 =?us-ascii?Q?8SLz60q+WHxbWqqFUjCCsZ4lxYbkyVZteJzzmKmXsAfDxao4pUsl7FZynxJd?=
 =?us-ascii?Q?Q/YWuoEDmO/UanpgCs23Xp88wTOHqE9EC2+2YZN3hsnR7ykpNGUho6lZ7YQe?=
 =?us-ascii?Q?LRMjjU3RAY2AOYT7Lp5RpUm3yXeuTehGYRZXMF2xRoSOufhS6PCoKEqLAR4I?=
 =?us-ascii?Q?qFhL/GoFIYv81NzJlRz3PeW5GrjtO4Q9Py3P1CllPXaUOYQCxulI1bjWKtus?=
 =?us-ascii?Q?AmVLIxYOJhV4MJHxKBZvEC+L0Luus5URqig0ieHqNQ497s2JXgc2x3qsoZzg?=
 =?us-ascii?Q?zVe1TMjX8W5rRVfli/0vjEtp9ib1STFxohAVBj0sb1dpXTFCxFIm1GBtBTIs?=
 =?us-ascii?Q?SbTXfx+6pu/9osWCxNHUOtbuJQTWmC9ONDyHFpePbSdiikuOh9Oo7TUP2REU?=
 =?us-ascii?Q?o6SMMggNGPFtZcqJTWJ0mUKCuLx4PDUxZ2BQrfNvPGNR8gjuZM2Y03Ko0+vT?=
 =?us-ascii?Q?EATErFoSqbCJcjy7YcawBFsuNU188EpRBAvmoTWo0CNvJI3NHNgCzZyBLXnM?=
 =?us-ascii?Q?d4bGw/4ujULVpYESeRlHQ8zl/a59qTMvXRHa32t3wsHtxdYhn4DzwU56EKO1?=
 =?us-ascii?Q?Co7XUCtcIy0D3AeuwZtyBjJXmf/t0zvBJSoNz+3qSFTDpX585iGxymh2wp9s?=
 =?us-ascii?Q?pyAcyMqhkAzQZCN6mtN/u+f+IuC1sliqqBu4BInskjop3lMhdZVshPIWR3gZ?=
 =?us-ascii?Q?ATRvWiIxVRzQfD4mPg10KEF4QiqvjOP2lPjIqHH7PGn/k7tnYaq9Osm9acYp?=
 =?us-ascii?Q?08fD//nEHq9Novp0SIBriJtc37MRYgdUzkjy6/iSnawaNmfXAap/Wl7BJB9T?=
 =?us-ascii?Q?xLx+7FAMwkRvr3FFa/O6EFC3MgakEUPqm3IqBtEE7oTL3zV9jD+ST93+WrSg?=
 =?us-ascii?Q?9PWPyTLkaH2coaPtGu1kxNgbed1YFKrqPH+E5bcLszHX7HE8EefMn0eY/AMF?=
 =?us-ascii?Q?chi6oIjwmEPRdTlpX9Y+IkFBoWt+2Tkvne86BpedGZaSiu8skOoSC3ud8nnc?=
 =?us-ascii?Q?bKtRoAbt5eVs4gu6jpQlOuhHoitDjtXFMdJDWxTm2eeGJMgKh83Mo2pS32e4?=
 =?us-ascii?Q?4ZNyDNySnsbPHDZtr6HPlHR/OaNJiKvNPSMMNcSQs0k9nqoBVJWAYtzIW4OW?=
 =?us-ascii?Q?SDVMb4hLMdqaZnV1ruRa31ncLdFkewjp5eZ8PmblBqoCs58ruXdPrOJKTfVr?=
 =?us-ascii?Q?wrHwYI/qCGeNq9WVJrM4CypdfLe/pJxsjWCuH1bo3Zm9a/MtcPZ4M1czufFE?=
 =?us-ascii?Q?KWwfzAN/B4pMsoe2TYjxXBYEoLdHfT6BQI/T5mkVsl60ZMm8kTn7saOpj/tc?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: oiyWrUaQfcN38jNipw0Lh7+Bb7DvO+wTubzu6pAVyk8MSufzT8PnaAY06dEfpWdn8dMdPWkbA4bicySL9vfssOo1+BxfGq5b8FxHC+YKp94OYcHOwekWEipfN4ddOsXqc5xFrapwY8wRkgZ01+A8+TRSaJVyQ6NOSdm5OYH8ixZHpLte9kjjd8ztxqF5JHsudnN6jMMaYyb0Gyz6pq6AY1Or24LaW/LXKzzRb58A6JRpEim61qVWyAMRyYiV7dcjqlSjdOb/J7ViALdG+whuKMvlTit43UtEUFftyZR56OCJfAoU+UZMZ66UlFDLVBb4h/7+UmWyHJnzc9KkPqw6wgZE687I9KsO8pV13ncg9dKfSb1/frCG4IVdbhYwIMww/8XbV3/YTd/FthB01OoioB1UpTOvr2OKMiOzLRjg0ZqOTG7tYp8zh4u5FwXznO1gTmUOjTMPDX4aO1N2lZdT6YWihvT+2YFyvxLlCponkhqZ9ncmh9ebozOoJy7ymKeMMlni8LXY98rmckBvi5TyAk8GfRg0F6NxGTFAy24p54KpX/RCYcfv/P3sY1lxmAHFF2hvipHkDspcsZEXrNY1Li1j69ilBr+pGeoUzTas8XAqT1qyV57weAseYNUhYhIL6BWGYkttBfzl599yhaYAVc5Kgpl6rAuZcFhl3MBPUqp4NIlpL1Vqbetr+r/fasG6iIsS0rLGVTnfJcB0MEpWp4+0ZK29fbZXlFEkfK1S/LqXDBhggppV/8uoLCoHFL1jGT+XEd9//zGhnoZvS4WIXqKDBsq3wCACKDW7+T6QMph+jM3+xWCygTQSD3MfSYxk
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3935b79-8a0a-4599-21a5-08dbbb0d291a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 01:42:20.2622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R7zO8MZaI7F3tP0r7fUfUOLGLKKvTyt3O3LPNJ5iYUe1Loy098K5p7FBcwRGq9t44yizwpQgXd1w1lOYzmffcbCCBjkHcruxetn4ZEzPbww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7592
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_01,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=464 phishscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309220013
X-Proofpoint-ORIG-GUID: BZzQT7R1QVtT2JyDBt2ego3X49038NLM
X-Proofpoint-GUID: BZzQT7R1QVtT2JyDBt2ego3X49038NLM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The first patch of this series fixes an issue with IRQ setup which
> prevents the controller from resuming after a system suspend. The
> following patches are code cleanup without any functional changes.

Applied #2-10 to 6.7/scsi-staging (now that the first patch is in Linus'
tree). Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
