Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4206DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 04:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhLWEqS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 23:46:18 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22940 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhLWEqS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 23:46:18 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN0Sdpu006018;
        Thu, 23 Dec 2021 04:46:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=EFlJGCkOXsDyB/JFUfbMzDanG+rixw32rIR9c9dWchg=;
 b=WMfGiCWtZSwPfuRoUqS0NVlAvis3IB0liKhJ1M1PXxeh11zR3giglt/C1I8PP93V90zU
 gwgZlxHSKzpiJ/wNnjU+/u8lcC+m+9RGClVk4iNRCU1q3pwRYRb6i5zRU99oy3Gpevnx
 PC/vnryfEvkRcPTgI3Ga16GVmIqR0MZwDY7+M52Vr/LtXJCr1wik/yfT1aeb9GKUKrqQ
 6I/SkSr2eiatIegYS7Xv3PPQbDMRTuID7T7pCTpPf+MNRbW963/pvI9kewrfR3+CHhnR
 12jW7wAuPMS77iEk6ZM1So30O2ydkOwXEWa2OM0OoIqwObO5WS/lmrXxIOlG51MlHevv PQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d2udcfrcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:46:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN4j120036150;
        Thu, 23 Dec 2021 04:46:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3030.oracle.com with ESMTP id 3d15pfkmc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:46:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJYg00mxVOabB8OU1jW1RyedsW+qQWEqmtn0+391HcUaTVmRu4XjN8Qn1SDS3+re5Q6wcMTMUDcuuNzJKY7/GlXAyd1wUZbtrmOSJSe3yAHcqSi9f6nKDEIWltivJZ2nxVsBFUfLF9ZoO4docBn8xqZ9VRBKji2KTX69Noi+AOTFvtzjQWy8xIMrR6UOhFrpnHx7E12uYiabLk7kayEIrIn64NZ79s4RAN6tOQFfDtvL5BNMWMmKcHYmaVSJtbrjQBEfaaKtr0Z6bO4u4AGNevZrzu8QFPGIzCYPNIXO6v5rmkQainhIMaRbMhSHK1sOhluDd+22mN30xI5cKTlCRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFlJGCkOXsDyB/JFUfbMzDanG+rixw32rIR9c9dWchg=;
 b=IJAkl+k/NysmQAHFOOyny/YXGxIwmF+t20hK4TbsQK1t+D6gjfTULZFM5a1+IdodWrAeAC/NiR/rDaNXMHQVZH6AvXolqZbcLbYOJyqwJZNXDtJux4feZPVZwmUscTyujAvzgf3VOboYyjUy7D9jc00qTL1aTUw86mCgK9b1/hfodeOmis1RlTXcY0b64lRuWJS4uaO+RDOoErUd44SARKM/9SaKcaZ3lXKG3i308a922eDrHqnaSTvIwNgpHT2krZwBeFl7pOIdnwQH5Z5gGDVx/tLLPLbCY4gA2lvJwTG45GBIzdqn8zqbh++M9cIl9g8XzzeMN96MMkdXsvuHDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFlJGCkOXsDyB/JFUfbMzDanG+rixw32rIR9c9dWchg=;
 b=R49wbWB+pCTPwPEP3O2GkkvUorJSTffcBW+qhfNDxGKJZ5XLq3TrVAIMebjTFTAC7RcmvAM8v/coNMmAFOoO1KASh0KlfcjTzQ4m76dqr2I6BBeKDhk1MDEsafGxMwUVGJqGpjVdZh7pu9R/K2IF05iDBprK4S24OKzmcJRul98=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4599.namprd10.prod.outlook.com (2603:10b6:510:39::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 04:46:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%8]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 04:46:02 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, hare@kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] myrs: don't use GFP_DMA
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6gsgc8w.fsf@ca-mkp.ca.oracle.com>
References: <20211222091935.925624-1-hch@lst.de>
Date:   Wed, 22 Dec 2021 23:46:00 -0500
In-Reply-To: <20211222091935.925624-1-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 22 Dec 2021 10:19:35 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0042.namprd11.prod.outlook.com
 (2603:10b6:806:d0::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a0636b6-b021-4f4e-5c5c-08d9c5cf1f0a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4599:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB45991803D959C73F41E133C88E7E9@PH0PR10MB4599.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tExOcXj+HPZeI1kySgjfRd0VozrYGpxYyq/jJAWvOYcXglpEenUejTZ7+UxbsiIN15z1U9FAp33ZZN7euplV97BwPTNkCIW9nU6FhKyfj8y7Tah2Qd+0s/rdFAZrlEc+rwlrV6RPaq55gxAslz58oN2m/G88uakkeEiS7RXkkRE46u70fkqqgHYmVMzp6Q4OAW9O6OL2+al0KagakeM8KAwnRmETJlDzYGApdpOoem5dGQM1IGDjGPYRLSgBRLo1y/Ir5FYgii21h/IUNhmMVvGfuOYQBhxIOtrCWhh/ShaswdNkYwOeIuebJjf3xIjs/Jhbrh8MFOQPrxUT+ucjgoUYGdZ15JbsYGt2CAtNReofDV5bIbXsqYdMLyTY3KA1Fte5G9kW/4mjJVTQtVz19fq9vjBPXSamtzYMsV8NK5UISgcz35LB5H/uU93EHN+cCErJgq7GMb37j7EvHBcpV+UgZ7YTlmImZJDU7uJQQZd2253izn2Wzkz3CLVoAga5faC/J1G9zyZjyvnapVrl2+TGyFK/LGq6Mjek+ZhnF4c60rMCp3QYUZj36cBGpt7XUDDd4zKXQZlqL/AECPkJikjw/SIphq5NaMp0W/yR1WnCTIY0Kyug+WxtI9M/HA0Ti2E/lmC6sGqC/rglIPyWgIcSGbHtJ5+Uub/JBQrudrSpnn5L61uoxi/ged+YlUpO/Mh2tYvg62dpJjLYBWYbnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(2906002)(66946007)(38100700002)(66556008)(38350700002)(8676002)(66476007)(4326008)(5660300002)(316002)(508600001)(6512007)(558084003)(52116002)(6916009)(6486002)(36916002)(6506007)(26005)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rfonLGEhthQTZgy0uj0/gKS2JrNFI2bxAeWmDloA/8922bdWne/A2Wq3Jtau?=
 =?us-ascii?Q?90z+Nk1Qh5XejwU5PywGqmMHMJ+rJ4X7cIscZvVhzocCpI9v75s6Te5AD0as?=
 =?us-ascii?Q?k6LEhOC3P8Nr09ZB6RxG8VUfRnd5H0MFj4AVV+u8gOo2z7y0H7kHX/jaeL97?=
 =?us-ascii?Q?3uoi7kFLYHxP+lmlRIHg/4JiNRjI23uQ1E3T0v+RiSa92kf30DKtcZiDlQIo?=
 =?us-ascii?Q?K+ZmR440+naNW/MViEzoB4P07LyZ3YO2HHAU5OQ9ftPe9N0iAndfvjydaNAE?=
 =?us-ascii?Q?FB8sy1LuyhO6m56bXKsLvF29JKnJ8hcLthtTApEaD413W17iPblRw9ivobLa?=
 =?us-ascii?Q?gCf8QedkVpUU5kbWIPexwxtlViWZI+sGiP/XSsa0YUxvxvdEWk3fX6D9JD0O?=
 =?us-ascii?Q?WYzi/tgF2luz7s/+JTu4s9qVHZyc1mgzKQ3pyDZlJl0asvOTF16UHpkhibbo?=
 =?us-ascii?Q?p09YJW9yfX2YrTNR90efJ16LbQd2jb31luwML44a5L+qZ7gN/+Hw9JHdbbbS?=
 =?us-ascii?Q?uLmvW9h4lFEzrYJsRXRyJlOYnCdGHRGjZiqIh9TJ2FximUUpVMbxw1Op97A+?=
 =?us-ascii?Q?+sSDu86Iy+kOE2YRkmqqbsRsfmJz5VYP1NqB5k9AlHtce/uZrqCQmhqoy+2h?=
 =?us-ascii?Q?9bnHMGn/7yOU7DOs5Tvjds5Vrg6NU+jXJ09jNH+z1Yd007OfQkS2pTC2/274?=
 =?us-ascii?Q?wd6Y5HrOUY69Z++oxILajKE7v8AcmhIWjGxcbKzYTLm85Sihp+o0pZir9gRh?=
 =?us-ascii?Q?plAESzQH3J5E/nPdIMP3IkiUWcV73PLHF9kX+6Cs6HCc63919XOcbTDq6emj?=
 =?us-ascii?Q?bCbpXk50P2go2sa01Z8G+xl/PYNnun83HNr9fuGPqPwnSZz7/a10x8Qe1YA2?=
 =?us-ascii?Q?Jt8I3++cjwjFX6WwzeJIhiqrPNT9K/EOzhgGNVG1mhdei5gltdflnYkGT9O/?=
 =?us-ascii?Q?T9cKDByLyI+/8/2tvQ/QNry55qCPIl8vDwrFdg3nxAM34vZoQV76dBFiVhIX?=
 =?us-ascii?Q?qMtBdnSifFDDhp0LGW34QvFZ8bVs9gaG0fm19t3x50UblhPHKhR9/3Hayo8l?=
 =?us-ascii?Q?vb1M/8mfjYnQurJdbtg4j32YzqiPBQFeGreEkM95rlb9YqtANf43uvJcis2o?=
 =?us-ascii?Q?+/acb1osIp6lkLkuIUifCOHXnsFbDqqU72dF3pwFUjD4ahLMg/+wFBOkR47Q?=
 =?us-ascii?Q?FyT8pXcFYJYhYnvZoZ7xBWV0VHpJKp4/M6Y5nHap7ueVUOUPvGhTHr51GG6m?=
 =?us-ascii?Q?2kWzqnUtNV0HpcdJAA8VnNkxJfjkg5VXawIRAwVxS8j+5PD74LhSosML1+re?=
 =?us-ascii?Q?yBjQGpxC8gv1mnQBA1ciIYRvKmV4jWYAydVP47S2LHITIEwzI7If6ZKBzCqL?=
 =?us-ascii?Q?MghfsSumnZMhcvQXQTc03s6YBe883b2Qov6QZOte+PQBRiVrNfzFfrhy/XG7?=
 =?us-ascii?Q?SQHycatFeAxNLeXyDuzT5PWhsbDaPhy133BoNt1N2WTI7q3+F3LY4FIGi0st?=
 =?us-ascii?Q?KaV3DabMYEMFY74ElwiqPOkfo2yuD7LZ46V7/9wm+W58eUR9EISEe4Va8N2T?=
 =?us-ascii?Q?omV9uh5HaSd8aNsR3gJM2KJjKZMsg6CC8uuOjM3dk3h1jvYwGEzClmelVK0+?=
 =?us-ascii?Q?k2+gWLjvfCWEEb9VesI8e7pjp0NJeFVBLtB0ZeZiNT33w/SGgDSAFSTTtS3Q?=
 =?us-ascii?Q?CfTYkQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a0636b6-b021-4f4e-5c5c-08d9c5cf1f0a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 04:46:01.9935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aRUWj1wivxzJoFNQVijtEsWcSRroP0f5ecs6ynk4gP9DvU2ty+XqvJTldqKmmeq+f4wnAphP/s40nx8G6FPqWIs75/8U1AbNLDRxkTpCjrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4599
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10206 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=655 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230025
X-Proofpoint-ORIG-GUID: AHK-C7kRob65OH-1FhgZbfPXLlF_wUv0
X-Proofpoint-GUID: AHK-C7kRob65OH-1FhgZbfPXLlF_wUv0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> The myrs devices supports 64-bit addressing, so remove the spurious
> GFP_DMA allocations.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
