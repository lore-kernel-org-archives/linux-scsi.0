Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB98C4321E
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 02:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiKZCcJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 21:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiKZCcI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 21:32:08 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB4C5216D
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 18:32:07 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ1VlZm025938;
        Sat, 26 Nov 2022 02:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=7Y4rupEo1pDxPNkLtBLHkAfVpDhaSKWNVzlboXXOtjs=;
 b=nRSejC9K1F10Epxp6KkZ5z/xuQtiRm43ji/EQ2huWvNJtYamBojp40leQ6v5LlLTWaZT
 X9RSaq2D2/SW5cJFcvBGeDrcy/bpmY/SqedWPCg/mjIWUYKJx37OMrirJjPYMvpeDfmX
 FFgLHB80GTjITWw6XLCLC2TsMViIKrwzRNiJTP1cmy7w/+6jVqUnXpKAHOPcMnEVn4HJ
 BeU08RooF/VDJvB8SSMEL7AdOZJ9Ly24lMuzD/RTi7eTichqMxZPVVrc7N8gJN1pJ6nw
 VGmsb3a2owqvbCFxPBgGYSeVEV7oPxvE1rnoHfQ0vIEfnQom6Q7ihiG9GhUJRdlQc83G eg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m397f81bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 02:31:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AQ1X589005360;
        Sat, 26 Nov 2022 02:31:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m39821fv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 02:31:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSiavclE/wlW9X82EtQasxSVrKOaBZsIiReLLpPXF7rD6OutG+Um0NfXsFajrDh7SEPVd2lork1OrO1w/fPSW1c2bSOLv3e65h0H0oYpGn99N7vhWi0Iy4u50HgZ/D6v8Yj1n43i7E0eRRWRFI/d75kMQrZLMNWcQJsCe2+BZibBJslxQt+6KnKFc7f5+mfHU4bLChrMCz+gWSUPET5Hm9Y2Qlf8Fz244L3EkN7nEeNoCBV30XBna4+W13nJ7Ij2OLwms0Khed20+7QUui8sCp2joIfMOpi3aRlEW3AMdnqPCq5ZdMgFszoLjsX+ZoYsD54Ua+BtcfEGSIuLgvYgOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Y4rupEo1pDxPNkLtBLHkAfVpDhaSKWNVzlboXXOtjs=;
 b=R4RG0OfIyyC/RfGOzoh0I7bQrLSSWXwF3XoFIp3IpYBkx2Su0OXmU2ikxxDG3Y1Y93UWaX1IiS+5L8AQw7NCcCMEVsWxKKGLr73SzTqCD6M7iGMn7rk+Rl2niunyUYIK5kuyxN3qBfzN1EE3Itjyk/davT8XEcEIxCVrc+g7V2qN6txumLAFSYFZqWd1M8ctBT1hVNWiVuH88lii4735B0IfgKjQ1kb8k0LckEHTZQFBj2B2/wH47mf0yDzOjQoP3p+s3no60zLm6qtKj/sbbTAte1Kn8AbTeh5Rlx3ccvpl3EPNf3o/fY1h4gJZ/uOs0bKh8qCnnsIItVRMdsC03g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y4rupEo1pDxPNkLtBLHkAfVpDhaSKWNVzlboXXOtjs=;
 b=Q/xoxiwcsFtKl0XrlxJgtHhxvR1FABFuU3O5tiU0+b0jZcDcjeAtJSem4fRTZRDnZ+mGuc0oUrp9lmopxDNv0Wzg/nV14pt1iyRAtE2Uijxq0HTPyLJnqCy0IEid/Ma0HTrFttJcjOHFOuqddmOIrPPbwb6r1EHM0xI2xrUNBFc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5063.namprd10.prod.outlook.com (2603:10b6:408:126::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Sat, 26 Nov
 2022 02:31:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 02:31:46 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: Re: [PATCH v2] scsi: ufs: Fix the polling implementation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkouo394.fsf@ca-mkp.ca.oracle.com>
References: <20221118233717.441298-1-bvanassche@acm.org>
Date:   Fri, 25 Nov 2022 21:31:43 -0500
In-Reply-To: <20221118233717.441298-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 18 Nov 2022 15:37:03 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SA1PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB5063:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a8ab75a-fe9f-4db4-4219-08dacf565d54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OVk+UtOwZCm6TVNMLRm0FEisRGG+AnCNffnD7r0CbAd2ZemejuCJ3OFsAYAy2GWn1XZOpyFoewJLFrxdcsF98gndeFPUSn+Okn63tZIyBAAafjagEJgkFqZo7OIQuvraP9t1gZfqkujFTEzi22nSZfmGocld4UrJ/tdl8DJhfExgIEld17sanx4dZFCBTaXCYX70ha+WLYfCdDiJmocEBgDJRnkthl6PSw9Akqh1tx8siXhyQ9nmnSkrmpk82yoXrYUd6dn3FMBcDoLhGKPNq3knafTG3iz9uCj4DH7qWjG7b/5UF8kJThDJXQnh6Uq+mINw3vjsaVvSHMyqg9cofhDEQdiWZC1mAcXmi0NwMuBVW78l7yC4n508OBFfWy4+4JppXI97aRf/7t7nloLU6qVtzoOKX101JByB+grhmH+O/aHG6E86Fd05hw3jFRQBOapFMAyGR56gl0eoTYAfkVXwdDr3m684iT0ukNGBVZtQ/+A7mhMn7H+Z8F5RtqCsMXShBXVjSR1LMd8sjbFRDf8E9/NuZ0iNgGGgEt3xbPDG1vaVW/ZyZKaty4v5olp7y05nt+wuWeh2gIE+eXh2B564ZkWT65GQoQlMArZiqo9jfRVN0/310Nlh0PqGC5nm44Z0MKtaG1RNkPSXlYJfog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(366004)(396003)(346002)(451199015)(8936002)(38100700002)(41300700001)(5660300002)(4744005)(4326008)(8676002)(6506007)(66556008)(66476007)(66946007)(83380400001)(86362001)(2906002)(478600001)(186003)(6486002)(36916002)(26005)(6512007)(6666004)(6916009)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RWKxwIfska461CGXBIF3qvXE6P3UFruCL9De3DxCVrz4KgVhfViSRYhnbsnm?=
 =?us-ascii?Q?bgAsUnAPSTSgdhEQ+xkhMUaYgddChRW6CntmjoCuBrAGY+uAZlefW9jiKKLt?=
 =?us-ascii?Q?76+kJDD8vt+mA0rfO2R/Kiul6+fjEhy60rkbZG7a5OjS0jI1BJX2ZnxmbZmm?=
 =?us-ascii?Q?RdWpuUQC8bvtpjUV32SXzDhlf4QYnUee97ZWhMZFh8Sobj3DMkOr5NqFiWtG?=
 =?us-ascii?Q?SCuFJ3zazq/tOybJCY5ghowY8VC3cth5cA8MCd8vB/spbHhoSpQHJ/1jsgO9?=
 =?us-ascii?Q?F5KKOe3eb5bLBaXhQ8QNv0RX9/jSjhhmMNL1MkLYQoENASh0siC83EpI/lKb?=
 =?us-ascii?Q?YVRDTeln8W808Y6HcFnf+yfjFu++x+K5CcAbjRxzOcLCzyBvn0MSykPQH/4F?=
 =?us-ascii?Q?BqzyNZW1RLUJF/TEpeCZIKHoyz1yQtdaTuW4NrUE5Tv0ZUez23e5ROaGE0SG?=
 =?us-ascii?Q?Y7tJeZrt1Z2Tlw0oMpUXCr5Qr6p1tAP1+21v14gReS4aY7Hw6YWcP16ZRQpW?=
 =?us-ascii?Q?M4RKc2WdIbSJ8AD4JO8yg/g9uOzc7RAIPxOvdh+cDl6jsuJCowGRXhs6RZU8?=
 =?us-ascii?Q?45MBGH0A/ywY9XHumb3gll8+016MlhTX3Qr6nI/LcKXDwiCwfAFfAYfvJQSH?=
 =?us-ascii?Q?j0GHCH1SPtBax6A/4LxwYdSzSaZWyvg5sRu45ZGSWg4ZQXjhXqFcMNZYM/hO?=
 =?us-ascii?Q?SNeyjVr0osGslpa2p+dEDygUXkQzXM8+f3Qry0+AWqvXwe0QC4qEVLtKgKOo?=
 =?us-ascii?Q?I8/GplzH8YS055aujtVaVs+S5UMd0bl47tXKHkbNg3xkMtD5EFoxtI3hVNYb?=
 =?us-ascii?Q?NiAhdih6vPcAc+rNdnNgFjC3oqxzLYG8BDOrm8ZErkxVgwbh0p2THCTRZKxr?=
 =?us-ascii?Q?Gyso/kbB6srrboObMbqo0wh8sYH+Au6fVTsMVH87zM8Wp70LwJMcnRfJSQl3?=
 =?us-ascii?Q?jEvgnsFIgj162h2OQiqA2NZ1JZHe/fv1wLWcEcUQgB/Q0Ri9faXZ6wK+uAZ+?=
 =?us-ascii?Q?o/QfTRx3aFgHHfAjDOz/5ZCYbVl9yId8X/gte7lJJ7oE2Z0lGSNZwodPrA0q?=
 =?us-ascii?Q?TLy64DonnMf/M9cNm82I4snV65Z/NB39NVR3nf/NTYVFYRD/dA4a0/7rNfZl?=
 =?us-ascii?Q?dW8VHgs4IgaTCKebA1I1P/ZnYgK1Dai8FRzibaOc59VytLZkNbpA0mhtF1Dj?=
 =?us-ascii?Q?ZN9kVDs31Fl1K/KnRyS3PQO77o0Jj5mIxL4mN2l1xv1L3tnaiImEgSyJhyR7?=
 =?us-ascii?Q?M/b22Y+/wiFhysIGq2ai6D4W5RxlNqIBZ4vvsOakktoeRbUFYiBqV41qpvZl?=
 =?us-ascii?Q?6q/xbI7BfH8MYGWd+BxkWP7nETVO1pHAC0Pja6KdBfF9ycg3lQc7AYEo+AmZ?=
 =?us-ascii?Q?BzWnt/nXu4RYD/a6nlXsK5K01uX6u+CK/fOvIt1USDjGk0XV+35eQDbFDmRG?=
 =?us-ascii?Q?Ec+QLzDp6Lioor9jwVOKLw8h0+GqU37tN8O9amkKj0pL9QChxgYYgOi6UT4Y?=
 =?us-ascii?Q?jfkk/FbKL3eFKLpF873VP4atemI+qJBOVbXHjf87rWsR4ct9j3ObJ44rEovu?=
 =?us-ascii?Q?xGwtzNuawa6cBtWjYwzc7flQNHKG8lChFZOzbydKbbDcIm/kEGziRfmoGTnP?=
 =?us-ascii?Q?0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?tUAcBEXVZnoOfOOVnGOWLzPvtCO2paGLjxKaaIa6vcKT+vRbHXBRbKgLohiX?=
 =?us-ascii?Q?Asndj0ZjwWABNmavRP3GcBO5dpj6zD+5SPQRobtqmcob/qtq1wBwvXJrFMC/?=
 =?us-ascii?Q?cNOvJlDbEvyIG/PXsPDpkFoLmmwS6XHDga3pWZTm9mYGf1DkS4LzVUiOwP0U?=
 =?us-ascii?Q?ZcmjDJaQDwzbAAkeNiRS2XOmVc9xibh9mU3kATwHkcxCH9QXawS+GhvbSjsP?=
 =?us-ascii?Q?s/sWAduKfx/t7bR+O/qTeA1Z5ZkDmZQXD7rHJJSr2Nh5lXiJOH0gje56E/tQ?=
 =?us-ascii?Q?cUm2RNIpRf4D0nMnZDmN98wNGhvfus4bRXojKo/uI6299zrNuWgO5AbluDC8?=
 =?us-ascii?Q?5jPvTZE2JZBNU9YXCRhWILAE19e3BfCvEcU0cohs5bjO57nJ5TTcaAxHkc1/?=
 =?us-ascii?Q?VHk1PbEBbL7uDa+TOcLktgAV6kXR/+7/aktilfAMOVr5Ow4N9TFZW3PALqxH?=
 =?us-ascii?Q?OaIcSK5GAsyxapflVLRpUG88kPRdsIlmXUWGL7plyTtFCYOWZKy1Y5i3GaP1?=
 =?us-ascii?Q?JS6XY6K7Rf0rnM0RQub9ODzaij3f/4ifKLDw+WtOHO773vneTXD9kn7jUbvL?=
 =?us-ascii?Q?ei2nxF3dNRlH+uI/X7f4gjp5l+qp2rJFPox085uCKY2cSqAAlOIARMaiwGwk?=
 =?us-ascii?Q?dMLMqgELHoDHK3QCxVLLeoEknCbC5wlkbISNiz0uZ0quc+FQfChtxKrhi6M6?=
 =?us-ascii?Q?DtMrOVHbt+DBg2NOGxnm5zg699V8T/5YZJsL3KtiUnHywTHnViFJHqVLvdFO?=
 =?us-ascii?Q?5ztcXJBThSr+5VP84yjrMsjTkmCO7lN4jb5CAGy8Lut+ThFa8OxbXwsCLYih?=
 =?us-ascii?Q?B7PVoqvKigw3B76CvXU0SffXDtD2Jtmyal2qwslflgm70qfTCtDnk5wEGb1K?=
 =?us-ascii?Q?40esC91R/JLij8E0tyeZujHSz16bNkGelWdNJBHKWgMiosGhEM7pCZHHWJDP?=
 =?us-ascii?Q?KVbIsOg7dzTyVXUPtAg2BA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a8ab75a-fe9f-4db4-4219-08dacf565d54
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 02:31:46.8458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JExid2iDz1jXLQg7WtfSlBs42njeWTeL483oobGd+g1GclgK24KfFrE1FwOeAls7O8GKvz0KhY2Erg3h5O8eFxssaTuVRbPstt3QN7OsKV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5063
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-26_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=712
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260016
X-Proofpoint-ORIG-GUID: 3C67iBMkoIkYa0Vz-OcuDJcGlBQrZmcK
X-Proofpoint-GUID: 3C67iBMkoIkYa0Vz-OcuDJcGlBQrZmcK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Fix the following issues in ufshcd_poll():
> - If polling succeeds, return a positive value.
> - Do not complete polling requests from interrupt context because the
>   block layer expects these requests to be completed from thread
>   context. From block/bio.c:

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
