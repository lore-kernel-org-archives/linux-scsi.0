Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE909C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 23:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbjEXXeW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 19:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjEXXeV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 19:34:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3F499;
        Wed, 24 May 2023 16:34:19 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ONUFVp012614;
        Wed, 24 May 2023 23:34:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=p0DrbhpKPVJF9JpO77Y8hTgrmqnvhBr03yX/RFmxj+Q=;
 b=vRgyNC6fqGF6To8jajtxXFyatSFrYj5C8I/T5jwgfukfybrAu6j0XqZ7jnQ4cvD+zvXt
 XrRSzRmhxXJLWmUb7GU/hygoJmPnzQJVbZHFL8khauJCbIMnlUR/JA7/iQmMHNZ4+aM6
 tl0YEV3BDqZUIJaFZLgd+c5f8P8D3sw0jN/MRvjeAIXdfENlrDN1LUzfyTwcsaJufd4u
 FShGe74bFc+HK58HV2Vsm94UxZBAt+tP+PXJYks8ISddIfOIe48efacuFJxeRbZsY/jw
 MgolD/T8ODjcIeBq+4YKF4LUtIxw12QL1yL8hMmdeT1eGN3riVFrhWY3++KUMPzzqTAk mg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qsva4806c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 May 2023 23:34:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34OMHrQH028521;
        Wed, 24 May 2023 23:34:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2t52hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 May 2023 23:34:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6Ld052SkZrW1/HAGMpJeb6ZVywA0SKMuvf3dhGr9yoohnp8zXT4UDLDxtVvUXvBP6ySvZFiSudq98ecxQanuDxh5tyv+1UHcpyeqfvQOIs2wErUfsO/5mz+R6ceEkvCAcJ/+JflAAaFCuOVonP4Y+Jbf74pQH1tWzTfxFWsQpwEUnCgaPaDPhWOs28vEUNyN/GVJFWvb2FsaDhIIViZ7G5uGGgJlUK1rTKb6jasb0ts2tG1kkMz+NVGZi5s71xFOHcLR1aE6m5BRmTABI2Wr5+Mj8wSKR+L8GWnljN4p9OwlYtmW/Vu4uP7nEJlo5Zp1b/xyB3YFOS8+Sc2DilN4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0DrbhpKPVJF9JpO77Y8hTgrmqnvhBr03yX/RFmxj+Q=;
 b=KIrAjAeutvzZgECWFe7vz3G2rCmTOZ6qUrQc4Kgglknh1pMaGbwjrO4yY6Q7gXKjN5MsH+2uNkCaXL5R/Sa+TXptXOLTis7IpMXBb4PvRBs6wVRysGU9ODU71bR5EFCJs93b8ijUjq55/P+5PdWRCX1L2EAyj88MNQSPeYwR6BP5VCaZY5oXfdPO2MskJ2PnldCqAb/F5owkzXTddjb8q4fG9MypDlBx1lZAh9NUPMxeJyRxhx6j2PfF4QH+E8dTJNhTRBM+2OQFR7uPzTO9J7cdoKbdDDCHRUdjFbmI+FMflbARpaugoC9RNyR/rUe0fr7w+oM1unmxYcV+N5wM7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0DrbhpKPVJF9JpO77Y8hTgrmqnvhBr03yX/RFmxj+Q=;
 b=sOFqpE21KYN29k2Cp1qWmiawgAJd2GBmhCQgNj1wpCWjj/qp+8bpJkpvy8QltFTbPmN2pSU+ZWpxJtQJi47JpIrd/hpej3Y5bBW3rI9mNPXQkqTzLHf5HlEONtZ1Y8WARyR9JboyVioORgDYNlOmOujzWFEJKcpIEoEA7mCendA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BL3PR10MB6114.namprd10.prod.outlook.com (2603:10b6:208:3b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Wed, 24 May
 2023 23:34:12 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6433.015; Wed, 24 May 2023
 23:34:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: [PATCH 0/3] vhost-scsi: Fix IO hangs when using windows
Date:   Wed, 24 May 2023 18:34:04 -0500
Message-Id: <20230524233407.41432-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0052.namprd07.prod.outlook.com
 (2603:10b6:5:74::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BL3PR10MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: 31b1ec51-85ae-4ac6-80d2-08db5caf5fa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dGFNl0pvpnOST3YJZuOx563YoAg48qGMnUGBir7MM7unf8iTtoC4ltjd4HrVpIi8+l+yxhXLHiQh8RDgfniAvFFXweHOuiQ0Z49xQ5hzUBKX0gEfPFGG487o6hJ0rsb8Ve3DlUrbEeSWCe6sXu8iXj+Kf6nkHyvJ+XJTmauGvZcHRAeHohzdGQyLxpsqgT+6mxjdtQd6h5KRvYLKkveBIqghzqi9AG1Hu8E14vmTsidCdGjAqRfQ43rkSYsAQkLoDRu8iWUsauzckpNkB0bB2qu/9BYgwQvvUPYLodUDmVE2zBILYQy6PTFoRVlF+w7jLQBv8ERfMc7S9DNuH7g9glX/qIXz7Qb7CGHNG+oAwU2JUZjT2aINQvONTU0wWGNYTUlmfTvJtW2/+LvmOMlYG2aHCh5mjY7Y8qJYlMDwZDHGg6O8sNwv+E7RV8tZhCr10aSgnCiEzyIMvszhzoE7LLiBvuA2PWMmAWFhshP+IhHCc5Wn6MDha0npofH12JuxpmLcwDjjQ0qFYIiRZgZbyWh4OahfcbvQRpkW7vx3Nxh7osGihnYF912EJAQzgQCF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(396003)(346002)(136003)(39860400002)(451199021)(2906002)(4744005)(5660300002)(8936002)(8676002)(316002)(41300700001)(66556008)(66476007)(478600001)(66946007)(6486002)(36756003)(6666004)(6512007)(6506007)(26005)(2616005)(1076003)(86362001)(38100700002)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KcZjz9YWdVLdK61pRte0HtuhPcCmaswAypivNcuUvDHEXkQI2quOR3phfZv6?=
 =?us-ascii?Q?2lmz3Bx4E3FMu4atYxrR1WsBkoSqICx9x186FhBUVZtRBKWYAlT03xINt/Pe?=
 =?us-ascii?Q?KLEzCmBeZ5sqvvbXbDvndiKVfBFlNwjF4hrfwl/7+7xirHFagSJajs2KyHqW?=
 =?us-ascii?Q?vOvWxbXaNEL/Jz3Yy1vwPLGV4KjuOviK6jZHlR8Mv2o404jwS2wCCNPef2vn?=
 =?us-ascii?Q?NSVZU/oH1trpeW15NBZXO92W22lPHbKObt4t01DeVUmt0Qn1EfeYbePCazjU?=
 =?us-ascii?Q?NqPpsbtuFvaqes/Hv6znGsx5l2sieYEssToQnjCM/A6luyJ9kYHhCSyNn9QV?=
 =?us-ascii?Q?LSv6AUZHlwpYxDrE5DYWJIC0ceEh6oekZls+U4Xv3LVTedCRt4wsXkbpz8Md?=
 =?us-ascii?Q?VUn5l2Lud81PeHUyDfh9erQ80/2LKF2WHcas7id6o6WM1U/omowN2Ekqnak2?=
 =?us-ascii?Q?u3zmh60ym15vb5pf1oVwluHBt7IcM17+5Fa8I+4xwM6jQiKhaEmGSzUmlLNc?=
 =?us-ascii?Q?4eqg791JBQJ5QdUKzZ3MhTyAuE3GxzLO47mkTK+yIheiBHFws+SAy/RTUu5M?=
 =?us-ascii?Q?x+3Jkbpv+kxC0dH4lOEux+2ccWxC4KJ9NbWqPNQGotkOxDM2SpiMB4cNyaJp?=
 =?us-ascii?Q?K4pjbqqmoh2cVu1Ypev82HukfCdyj3aMGXnohRwrXm3KvlsctWm7JhZdtwiW?=
 =?us-ascii?Q?maQHNDuSVHLazk9t6/SyB3WHkaBAoykczvDRFqAdk8pjn6et8DS2DMFSw8TX?=
 =?us-ascii?Q?9hvIHITliS4OIDEfvrah1aKJ97rcLVzFx/a/y3wr6EeRx4pPVnWtloZOT75X?=
 =?us-ascii?Q?RepadjuAlEGxGXlEAlRJUzcAsAsPh1hMLIdVfY+6mho8bIjSgrb6+oSKisxy?=
 =?us-ascii?Q?nTJkTp6hwBG5nJljseCx31x+jOD0V4F/xcH6wPWKr2b9rzPTj8H3kHf++IA+?=
 =?us-ascii?Q?L36bViQFp4uDRuyI3IcNIJisgpCVZVUSiO1TryWhYcWB+fZCJll8UdPYdZFi?=
 =?us-ascii?Q?W8swIy5qKzsvZRsRd2To3dQxdyWeyBCZgcOmozMMCdKzcQrbMVYTPKWcmXkO?=
 =?us-ascii?Q?KhdKc59HTWPZxApRT0C7ILitpEyEsmP6UTg+JMBm7UwHlakla5Oqq8tkhj9M?=
 =?us-ascii?Q?YavIB19x/zzi77KkX1HiSUET/GvkNMGaFu9LkQQS3Uspfzvve846EufMp6xF?=
 =?us-ascii?Q?j33RivoD7Jwy0phw4OXqHGHCKrApteQv55C/dKM9R7cPSb/Wy+P7OYEfH1CC?=
 =?us-ascii?Q?e2RZ3pnmdoO8ie3dWeoi7Vka7bQkQWkFk++UkN2FnhiZQIKmB/QUUVJeGsI/?=
 =?us-ascii?Q?7wWRshYnIHWV1PovUGsuzXqA1PqnerDCpJh8XD+iiAf+oDVGD4MPKxAhpWGA?=
 =?us-ascii?Q?es4GKH1wcVls1vSCsLpL/4koLm3sTVk9AZLskAlzkwXkMcDIi4IUjkXarxY/?=
 =?us-ascii?Q?kGdHJKjE9afMP55br6vM9bG24MyeKhQIu/JtBXcR35gRR8hQvg03gVO6fZGc?=
 =?us-ascii?Q?X6mN8E7nQdactwpye5OQagEPnYB3aEGqVpQ6Sucsuh8a9gwyAIIxr88ULz57?=
 =?us-ascii?Q?l1PUaysAGnshjwv0xk2h934bGzRK3vsEnR0/fmIPk/oLe4fJ2fpdszuAQfoc?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Zn/Ha3u0ERAvA29bLsfVzpvwuceEB41hbIE/mm0WN5oca7UcCWO/Isa7m/DCAqD2VS9nljnJ6U5d3U6zKKId+ublCb42vBXUxBafUqUePEnJ54Kg2n4tEHqgd78y2fyEbtLcln3jr4LdndFOn7MR3O5wwOgBX58Is9+xa2PjZEInjr7r+BwCINfFVfmATr9iOQPkP7fuQ9TLBrwSKeLv6eBPuBfyN94T2i0yGX3H3CL8sXdQqxbMFAGUsy6qXLbjwq3CCHeov9WrPpXeeI2wKzIDUdmqQCQ3dxOd466LumiHu/ooq+DOek7+AcCimcI94e/MJobiKCW28jhHxtkQhmxI7fjGHXcda6kzCvR9SMilEhZ15T3cMD52JKKZK4GsCa80E+YUSlaRHpVRoAlp4mHotLitikvwxrvz9+bOf8v45mvAHY9Z+ulmtZKJ0bsL/EYjE9xlWTadjorHq56SIyqtDH06WbpOU7acCmFIATR2wLBuwqEjcXlKakOYOcijSDVsHqzS7sqvbHSaPlvTLDyJnpFj6SMOVRPK2gT8wXexrEwXuMJiEN3tWg8suxNaVo3OUv0+m3x/dLkVGbQDPyADa/JKQWSUD2c5QyJvTdXE5nOWpNkx//31OeMfp0cEYX0dc39+OQ589yYRUkE8vVgDbq+U4Oz+NqBvpPGyNYbrmX9QjdsFh5/V+pu+V2y50czbKZDkDpznS2l+I+cvC9yBEEhSM9aVa/0Of0s6yf2RodpVcXrX1cVj4EYTniDc8+AN1cGPGNyljWhG1Tn60/tRSAC/qmkyWv65hZgkfGDR5iK+IS6dw2g4hYdnuPMe6gNEvNYNCtmTpJ+XSyGMFB8RJ3kFXgQDCBp9A2q9dMo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b1ec51-85ae-4ac6-80d2-08db5caf5fa0
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 23:34:10.0865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R10AYtJfCJqNZtCCBF8kmNJZPK3ffOBDeagibWpoSLEiOFUe8rUVqxydL+GW+a0sIVJkcc79tf3efmKlQuT6lG1WgyDRvrjDlUHDXzYiEk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6114
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-24_16,2023-05-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=660 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305240197
X-Proofpoint-GUID: q_Mh-pi7FZCHoTB1fZco0spy-yZjLMiG
X-Proofpoint-ORIG-GUID: q_Mh-pi7FZCHoTB1fZco0spy-yZjLMiG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree and fix an issue
where windows guests will send iovecs with offset/lengths that result
in IOs that are not aligned to 512. The LIO layer will then send them
to Linux's block layer but it requires 512 byte alignment, so depending
on the block driver being used we will get IO errors or hung IO.

The following patches have vhost-scsi detect when windows sends these
IOs and copy them to a bounce buffer. It then does some cleanup in
the related code.


