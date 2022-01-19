Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74E0C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 03:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351314AbiASDca (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jan 2022 22:32:30 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46532 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351313AbiASDc3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Jan 2022 22:32:29 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20INx7TI002453;
        Wed, 19 Jan 2022 03:32:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=EmL1y9pjGaGS2lI5KfLJWicLPOuSZy43iNrCmnd4ttM=;
 b=wiLiYT6ziAyxdedtVRmmRGvDWAifd4EbMRheHbXQF3rX7XJMT9w+4cQMYETvgUAjMPKh
 nGWtrqjTNgmwEkiA730t4E7C6b6z2jQlrNF0qb3G/Vi3aTPc8swRrML2O2fClcz/eaW2
 s5tE0buYQwGYs6KtqFM+0Wb7gc8HKFKXTXcxwae4cMlEiuI0s0FIRHAPCP4t+RUJQkut
 T81uiRcuGp9JDAHo9eD/gC7L+g4T3mFV5lx7BFsbR8op4ZK0zwXgVb9CrHqkVTa/VH1T
 T7FTZ2CHsET6ax2xz4D+3RD+L3AGD4Xv7lkbiyPEagNGuPMNVmMTjUpetx+xw7Al31td VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc5f3s94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 03:32:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20J3UOQU063455;
        Wed, 19 Jan 2022 03:32:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 3dkp358bjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 03:32:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7PQQg2mAzCA8a9CAldKhJxvXq97BuSezwevacCVZNBKssEVsI6G4OYWZxn/TZVzLt1sbEHjAUbxeGMfLh/oXsaM6CW4fBXRKweEV6q8O114DzAlEnLLc8nL8yGR7n96Un8icFMK+Y7/4ArMlTnnyoMDA6gjr7rlym6pao7Xz7l+htE8BEo/Bn9uCg0BDy6OJwp3nScvgA/YI2H5nImLQNMOzN7AaCKFreyhyJJcIIV0Xo+ceFHwfSIC1wuG6v2Ot6DxR+/4mCLrZaevPiI2Vk+ehKMKY1S3zyDy7zWzOVZkCv0ruImZ5/PvMWcCS2/Dzgz+vHOGcw9GuG7jfRbx7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EmL1y9pjGaGS2lI5KfLJWicLPOuSZy43iNrCmnd4ttM=;
 b=EOgcSrDMyOVtjKjMMNh8zP6fYpnnZ9NcArfjXiZwTskhj4Pmkg8dhRgkid3jB2blto8LvF5iPkjmdWI5IjfQIMUL8OwZtpJNik4oHONjijFkY5ObX8MHFgjBTkp/c3OHuWuw9d1POug8mZN75wDY8iunZsaLWJ0Qe4h+b2RTd4m8hakTfGlSTDf0T2exvlR2p4qjR3Hm/Gr4+8m1RwvxG1z6OtypPjyZAXsOeL6370dpo3BNhx/87WUCeFxOXj0nuiNMlxAnV46jkncHXU3cGZSNxAMF6OyPHR7FgDPOZIoQyqxime3uEGRwogQVPh3lcxQ8sxt7SomqeoFICuUDCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmL1y9pjGaGS2lI5KfLJWicLPOuSZy43iNrCmnd4ttM=;
 b=PKU7ODIunJRGXGth6W1u+qy7ceEE+UzVewDBRgMHKBtagNav0Q6cfikXpc1i/J9cKo1ybSsTWKq1i4SgVjgzIhwTEBuAn6/f8p6fKA+RvLvkqlYB60GDBG6QofEdTg1yk5Xd/wGOacGo4ugbceOh7ZXEHFtz5+SZ4hBAKca7r6U=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN8PR10MB3204.namprd10.prod.outlook.com (2603:10b6:408:c7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Wed, 19 Jan
 2022 03:32:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%7]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 03:32:13 +0000
To:     mingzhe.zou@easystack.cn
Cc:     martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] target: make sure the np under each tpg is unique
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilugmmdv.fsf@ca-mkp.ca.oracle.com>
References: <20220111054742.19582-1-mingzhe.zou@easystack.cn>
Date:   Tue, 18 Jan 2022 22:32:11 -0500
In-Reply-To: <20220111054742.19582-1-mingzhe.zou@easystack.cn> (mingzhe zou's
        message of "Tue, 11 Jan 2022 13:47:42 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:208:91::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1df5212-59cb-458d-5f3e-08d9dafc489f
X-MS-TrafficTypeDiagnostic: BN8PR10MB3204:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB32046F6DFDA0E7032EC597A68E599@BN8PR10MB3204.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G+CD7gBKa01XJGGPaGkfyhrTi9dBZvFXoX8Ed5timwAkwjUrOHDMjYPt/B+xJ9ZlkISHiYe7GljWWqQGHFAyNbPTBohJfunJ6H+5cQoSE2CxcuxTvL/+GMzs4vx5TSjtnUk5zIqvBp+evPohOzzswi4/7bKSQWWAuVafzqN5A9T1ZZxyrgzSxlKwrFP8mlzwNPxIzmp8R72GC6371B7GirzCde/UXRSQRGGb2SmJoknF5yaZr9cY36T800XwJARn4vk04EnMSDskeApRBswkMYa1Z1PFtw/zJVARJUgt5vDQE9juFONbbUpix2v2vEJKWcgpRyN02q1tunktswYVVDmTlhDn/dk2Cr867tLJ3GHHVoKoMXeLmKrwyK0phMVZS9FaFOna5lqvNoM+uMtQwr2Rvx9X76iuWdakzL7sZxTkVrKmdBniijNKyTZF9St/zK8hEQhHUifVH8IFj31xyIBzM4P7uKfetNIOr5+eIEJJdkAPHH4fyxD6QaRQlOjTSPQowcQFwx+gG9J9g5LEK7Y6IMR6yFGJHbzmD8xoZEmuQFGLtpwDoN3Nc9xty3NQZASvIV6uVCZ8t6PpOvPvyEdCM5nU5sqY/ovQhi2t+H0yaGfNACC/F1wKiU4liNsrUadDweGJVwJLV2Bfk+QgRtAh8MtXP0tq5EfRPJi3of5UdNub7KfJXBmJSqk/c6nZwDXs7AVT8Kl03Na5ictalA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(4744005)(5660300002)(52116002)(8676002)(6506007)(6916009)(36916002)(8936002)(508600001)(86362001)(38350700002)(186003)(6512007)(316002)(66556008)(66946007)(26005)(4326008)(6486002)(66476007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dJ6uoWF0M079869/pqej12v4GpyJIzb7VamijtLZd0pt6UlzwVyFljKHC+sO?=
 =?us-ascii?Q?vQSl5xf8rMl42b3EBTux4hc+L+h6z6HeT7c2AixWaeYb9cZoTjh/3/MW5CQG?=
 =?us-ascii?Q?OVQfLF0Qlnc2sZWrEBp5ZOHsI+j6I7vD5R4xT4m65K+bNnnn6U/P03iJeuBW?=
 =?us-ascii?Q?TjWdTKtw/ZQDf25riQ2OJn2hcTGKoD71pKZBNTVdx5MUjL2XAf8gr7H0V0NE?=
 =?us-ascii?Q?63HGgTnW5Tg9hYNIMdqn07Z9gRN9IEniNkq9jMx9k7fFY7XpSxLxQVD0RtZv?=
 =?us-ascii?Q?dZwGEKyd7ImJlumgoA/jW24Zs5Gc3rCdTxet1yLRSUj3GdNip+34RiDr6isW?=
 =?us-ascii?Q?4pAQBgjAvymujwAVu10c5qtbPJMDHg3OCOEGPcAKqBngBmtjGPuzCjnX2IWQ?=
 =?us-ascii?Q?cPDJ2f0agHwmA2N/URiYZrHMRV/OFhIvYA3RgvGtuJZUkT5kJ+njfFEQ8kFb?=
 =?us-ascii?Q?ySVSbYSwb97ijnkIdCqALjo3OcM9nuxOnoiHzxztoprfzaVnhdHVX/PRsZi9?=
 =?us-ascii?Q?3CjOfSPieFQn2d0dwivB0+Dlr+yvXhaD3gwTnWfb8bunXhhK6q/nzpqRoL4h?=
 =?us-ascii?Q?uX/gdpTtGYrAZNlmSJBrtxNGUASEplBQekpvZMU2Zl0nmazw/nVpyrwTs7BF?=
 =?us-ascii?Q?mZkP+0lX9nE0Bu9u1gjw7cr1M4oYzhMA0dK98acBvknRzK4dId9Jgqez0N+5?=
 =?us-ascii?Q?Ec9v4uCHBgQqXE923ZUTJ382+Jr0tweQTwgOC4MBenVkX8DV85pCeixO8BHZ?=
 =?us-ascii?Q?aLqkfQD9kM0b/lqRpztgVvZK4mTx7yK08eiJ8oACiEmQaeG8haMviBSTHAkY?=
 =?us-ascii?Q?rmHX43A5gq6Xy0Nf0y+uefpBS0eyetYQyAP/XrNsA7vLhIfbAD6BJDf2RmVM?=
 =?us-ascii?Q?SJdBrcJRUiy0QJ6AfGX91dYLWra5QW5mv6jSp3j3EO8O7Vr1OeVwXnw7q8cU?=
 =?us-ascii?Q?h1UsInn2ssLaD8x+EbV8FbWAPtesdGiw0co3TvUdldfoewODgf4r8614oFoj?=
 =?us-ascii?Q?ydKHlnUHe8+KYSkWmSWxLavke3sDKM6hVgx/Pr9aC0XFwRWpccXMacUVf/zL?=
 =?us-ascii?Q?ZrfkxDvkT3zG34YUS0VESPFSb/GcVFMl9kaSV3cINuuAVXUt4UQSAha7QxkN?=
 =?us-ascii?Q?oqc6FXzBYW+U9FzcT1ZEjdemgC4RFPFqIHgCmPHfbuY4S8CJxdwmLPyYnMhZ?=
 =?us-ascii?Q?y1oakSI/9XvgJI05iS9NiZlxUu2LQzCGcOh++0Nq2/FnyjN9GLJp1gpgO18X?=
 =?us-ascii?Q?gwcAfLuFey3q9ZlqNFn5OGCFnZ/p5BoMgZqKRakF3EaslbLPIyQaaVF17pO8?=
 =?us-ascii?Q?Y4aU5YHumVNOSPoKu3/a0HvcQciP9mQGet9bK2xqi8Q6Feoml/iseqLga/89?=
 =?us-ascii?Q?47LGIB8jy3k0WW7Kyq5xOKmCi5BIllKluKG1JfiSdKNE4QZBeOwlQwwcpIg8?=
 =?us-ascii?Q?K3w7uRbAnIeAQ9OtseKWHZoJeibWxdUitwFXkK+VEN4a4ecFmpjk0nIp5z/Z?=
 =?us-ascii?Q?YKso1/7QRDuCbUS6G1h1fL2OjcEY4X2QEArvxFK6UQUyMz4ZdZnDv1F1ecIb?=
 =?us-ascii?Q?DoN8lZVl3McpGiO5WJEQsLTa9tt1+3LNB2BLN433CJur/1kwr2mgH4DZoyXN?=
 =?us-ascii?Q?7PmXX3gb6HUloenmYpootE61zJjr53kzJRBK1tBUcyclM8IrQqBVlCVwSxcH?=
 =?us-ascii?Q?5Fw5dA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1df5212-59cb-458d-5f3e-08d9dafc489f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 03:32:13.6372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 65TJUNGSLoVf5I1BT3FkGKSJDyYg4sjiaoqKFR3ooDWmVe5VCHmVRoYCCrP1H4Oh4G8C+YXVzmKKcH9i1yJM01VAaXiDWkU1E+mu7s4UrXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3204
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=588 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190015
X-Proofpoint-GUID: mQiJjg3SRzeMJB2YRIetG3PNoNDENDe3
X-Proofpoint-ORIG-GUID: mQiJjg3SRzeMJB2YRIetG3PNoNDENDe3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> iscsit_tpg_check_network_portal() has two-layer for loop, and should
> return true When a match is found. Then, the tpg loop will still
> continue after break the tpg_np loop. If this tpg_np is not the last,
> the match value will be changed.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
