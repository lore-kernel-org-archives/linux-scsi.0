Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780FCEB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 16:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbjGKQhq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 12:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbjGKQhn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 12:37:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECBA1BC1
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 09:37:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BESIs5014570;
        Tue, 11 Jul 2023 16:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=jHBWiPsGxLpBPgeTrMulk9uDrhAKWoa55x51AnvFrA8=;
 b=X1yFqY42rZ8t3RfFTChg4auKnD1yEY2gc4Ex8ouXHTcYr7/MgkQ5kctfg4rAga5obvKm
 K2MV7m3eU3gxh7H/+OZ0UytIRBWJFkg71O4DKvNYz44dHrc7r5ptq6ORishw9GuFrFLu
 aQZeqw7g9UgmdNI+q1iZQMPzQ2NeipMGIajybZy9xxNJtwwrnvM+sOfGW6chnVcgDLTY
 BgYPDGPA/plCnAzr7sbqFl4fLc213jV4gTvxk2l6sQKvq7YnOvllEj0ZmQF7wngjb8MW
 5B1HWQ4G9/LkfHYFFsz5QWIc9gbg1sntUoqC5arPoMA+OdYfIx5V0UxBmmRUdx4KCb2f vQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrea2ub8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 16:36:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BGQ3P3000503;
        Tue, 11 Jul 2023 16:36:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rqd29d0xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 16:36:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzCzToAGjfRv/hOS5hPohdPrkgFJGMT/8ASCVPfqnwYM1PURyWCZ7a8k18DkrR9dAtA7eUQW/i0PJXsASRdrgMM65AbN2oArEuH9cEj0oYiEJ/mNIhuppO3gRIWaJNA/0nWqCRDFr+8glALzHgrjxFxAnFbxdgv6rABpaunC9LqUd814Y3FLFBSF4VB8G3NNVS2RAZdk0h8iGkuEyCuywasXL51lG1K+e8zdflmp94kZ+IIOTu4nCABO1e2Jk4Fs96y53S2rMhy0v6VSEvz+wwhFWchp/CtBkpbgXm2or/YwLjGyT5koE8e/cfa6suQX7f4oVK6ZlxdjKMdMRCOpxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHBWiPsGxLpBPgeTrMulk9uDrhAKWoa55x51AnvFrA8=;
 b=lrThLBbY7psFeW/gDH0NeRkxf6IYWOHwzW1QRGUVr5I2PRHde/+0IQ1U0AJRRoIRvYzo9YbBue9uB3kElHJvUZ9URUwBTYFYBxqYLos3/pqlocBZYbzL/SCtdD6yxEivXS3q7q4JjUXUSzJe4FvAF1kBJUGW0E2TjeDhhAbiBZIz/v471zgjt4qOQTzp+KdRvtga8A2eOn4bE7sPczYhET77SzxvmHezaYJ2u+z/MTqdVwQISCVGav43PoQMFlKqIGiIJgw343ve7obzoob4zEjgZEV5VzEtfp2V9/5EQONzq1BP7UIXpllAW5nsytmizJaTNqxBnP9t0k8VqqwX6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHBWiPsGxLpBPgeTrMulk9uDrhAKWoa55x51AnvFrA8=;
 b=Tw9/LR+WFFc8xlY68cjpBcEztwxgMMCZZllxwdDunmLbirVufG2NsG8XUmxJBHVVJiOtk0YtMgMZ7LuRjEIbyaR5nzkYtWkCdQsjsTXakLG8cobuMbyLqiZyXb1BkT2wGZb1yaYO65ZPQQYac5ePgAMmqpJEhIX9bhQpIzlg5GA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB6373.namprd10.prod.outlook.com (2603:10b6:a03:47d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Tue, 11 Jul
 2023 16:36:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::101f:466f:718:4375]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::101f:466f:718:4375%6]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 16:36:53 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Markus Fuchs <mklntf@gmail.com>
Subject: Re: [PATCH] scsi: ufs: Convert UPIU_HEADER_DWORD() into a function
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lefmflr8.fsf@ca-mkp.ca.oracle.com>
References: <20230706215054.4113469-1-bvanassche@acm.org>
Date:   Tue, 11 Jul 2023 12:36:51 -0400
In-Reply-To: <20230706215054.4113469-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 6 Jul 2023 14:50:24 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0074.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB6373:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f9b0c3e-d4e9-404e-46b4-08db822d08c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9/V/Zsjsq5fj9uIUYFyH9SvNkyptt1dKZ0zKp1IRMKnVf8C8jkHCZFW7e8JJ7wqR8RmFgUDl5h876KaPSJrnd3DjeETj5C3LrRe2dYRyeA8FYLfkrs4pk7tjd4vYClJNuL5ARm0q/N0lM5TDelHSlx+LRMWwLK6zwxbYmog6hRxpqVujjnTqXyZMFxDpRbjJx3k0G4hstDnUl+f1fFmtQwAeqdK1RTjJW7XeaSU2fJ5zKh7k5YotSzzh/NCG85jyi24qCnhQOXE5/F5QWVQptmKyi0FDKmZDxfafoTEI/HYisnZrEPI3X0VkclgmAqIeswyFNpzdal+nXzUWrUXXl121SgHaKGQ+Se4e2/oEqCTxHv2mBfQo0OYf3V4bfJW+OZFMthrytrAZyh/mqkvacNS47R2KlR7FIOQlOrH+cTwnCHDh7z6krX/entg1edeKqsH/z5O0ZvTRhE3rFt09wEIbfwhsniKMYAMq/KtOc8jeEAqoCvwzU0aMxcmAIL4W0wPBdUb6Sz25Kfjvsg5mirjnb2FJgEeWHGkIl2p/eGIHicBPtG6zGJtN4NRHb2Oi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199021)(6486002)(558084003)(478600001)(6506007)(186003)(26005)(6512007)(36916002)(316002)(2906002)(41300700001)(38100700002)(66476007)(66946007)(66556008)(4326008)(6916009)(86362001)(7416002)(8936002)(8676002)(5660300002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XYZQ2Np7oxNwJHNbuYO7MS/zcisva1ZemBmQR883cdZHx8C7sYN1oXqmh87I?=
 =?us-ascii?Q?F0nzCWyVIfnjZSEuhQa0OCXKXpbTqVXWnw6SCakYPDiLNPiIa1rcAsQt4kQO?=
 =?us-ascii?Q?jnb+zrGVrPBtg+ZeYB5dTJfObFuq5TzkvGUHGKBuqGtXmS4RdMyIzfjhP99Q?=
 =?us-ascii?Q?i/rju1TE6+jgS91Z3aE3J/UrKpDbRSoQ+gymT4ylae9IspxJwDhSREVbAyZt?=
 =?us-ascii?Q?aAl2UGIRH8iQMtPzNAjrDANrLXvE0XK/5Nef6KWeWhT888eb0bZQeje9uVvV?=
 =?us-ascii?Q?PVh88o6C5ZiBYsbdpMGJTZRBDWVQLoBZTf1njrl0gbTWoc0QlFoggsWVnTnT?=
 =?us-ascii?Q?PPpXj/w/tinP9Z3NYl5PkaVhFaYuPklViKxGGXmmOEYZItjWL/PPJtuY1kkC?=
 =?us-ascii?Q?m61bwRqhEbshppxaZ50XGKks5oFhUUEcBL+aowyzn4W/5OXH/68omtYkiaCS?=
 =?us-ascii?Q?n2bJWL0oZGpxas/NEhcpgEYFZmu/12ncJ0kFWk4kG6GZvW7djkF72i7dQLg1?=
 =?us-ascii?Q?BtxxStPhK58+5UC0ePHMkig+17E0Cac7F0m0ETXDGqwDgQmxGD9sTSxkHNVr?=
 =?us-ascii?Q?KriZN9AdmzNTu4q5wt8Hf2QmG4OE6XJE6eLgPE3GhsCetV7QbUUzVcbPrbVV?=
 =?us-ascii?Q?bWVwdmX6Xs8tDm1LG9XekK7etg3B8QQ59IABpbA1b8IIuhnE5wByxR7tlJU7?=
 =?us-ascii?Q?yo+ST0s8jLuVaQfMkW/NLUxl4AdhudLvj5ffFJ2vNWhDmsaIlS3N40Brrum1?=
 =?us-ascii?Q?zvhU2udKcb6I9gn950vdNq5TL4nCwGTHoW+WMx2Nq5/SKw+v1jhp8MkKNGf7?=
 =?us-ascii?Q?JgE4YAaJIWPqCKXLiCD3m5QGqfd9LBr9lcvC8jLZYC/lOEveONmXESssys0C?=
 =?us-ascii?Q?x7Wxqh1PQarkwx97PWmliBfucE8UXVFM2uKp8Aw3HPYeMHIx75QJDU7r0DdJ?=
 =?us-ascii?Q?glkpTmlwn7WUljk8/dq1ixJwFLxaeNsqzMp7+GjHdBtdSHVkPrEDfdqVAry0?=
 =?us-ascii?Q?Y6ywYlUS1BUApHFKr6Pz6GXm/x7WKqGqtrOCifsfngBdOhMhyllG0tfCoSQb?=
 =?us-ascii?Q?IcUHILkNHv6Mba4x8pMtRnVqxkmqMgtUzpBIRn2zV/sdJifnpO7vCGojN81R?=
 =?us-ascii?Q?xbtVm1BUuE5l27shruP8Ts0WpKihRiYy7vozPSR5lZbPoIL9Ex+o9AAy8Q3l?=
 =?us-ascii?Q?j7671Fk7pmZMm6hFat8/HJkqNHpaT1rIWKdEw6RDACzZs3ZyXkk4W1+U1an6?=
 =?us-ascii?Q?gfsuUW2twgFRhHd1hVsEx46dESjgXGNjfeUNXVdOa12fY6QKvx718VJrQ+MH?=
 =?us-ascii?Q?Tb5glKaYwhfllzQyxms5tYdEcGbK6AUzgBz5Onh5u1qgQ/1tRi8vg7RRIy/u?=
 =?us-ascii?Q?unEONDepBR1pEBC/jaj2C5mi0mSO9r8hdKEdaMBVoXlOJXOSUzls864W0g2K?=
 =?us-ascii?Q?zM2OsQyxZ7Uwn1g1Bvfj+CmKDmUteQ/sgTXDvmBIsLGOiUbFN4RIwBqlIaT/?=
 =?us-ascii?Q?vIO8XubLqupGSKD0ktW7F2ZH+gTz+1fxaQ6PC8kTK07KCWkajGIFjGogpquz?=
 =?us-ascii?Q?SBMPrphKvSxR28dMdczRaD0bhOXvJjBunf2rp4js+oUO9GpYFPnJgR1RzFDn?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?4XVbdpWkOYGtOgYC4iUjbWyLFl77t5mX7Z4irBGneuZy4+bPkts8X/NGmNp3?=
 =?us-ascii?Q?yFBnxrF9ZtW+55kTcAHlU0Nsu3ugKlrHXMYvCNHKUHlgbdf4UeCuaMrsn5Nf?=
 =?us-ascii?Q?DE7Ct8XG3WMQHeWNLzzzCZuaWXTHPIUPnmNph2akhHtCsxxmqSv55MnYStQd?=
 =?us-ascii?Q?ODG/3VdOOaIBj/azMp7vFP126TnS5ygyT8cvr9ayBar7IX3IiL4o1Nqv368c?=
 =?us-ascii?Q?rFEHFLSjgjQ1LtlpRhZovAYw3Bc+iXK4mOG0KwDCBX3i0NpLDUiB1/vMQUqs?=
 =?us-ascii?Q?+7fzxCz6g1gtdLGqViR7kqH9nRw/PcX+rUdNt/rEGxMi69XuJ8D5NubvgAKA?=
 =?us-ascii?Q?u9DrQgeBBdjQdTadrF+Ew6+02wrHutRKThOR5u8J1WoTKE5Qto48XhoD0K0J?=
 =?us-ascii?Q?k1S/PMkiZXH8yxh5G5Uoe09hT1W8REdcNlcZZzueFmI+mv7fIatToTLtz189?=
 =?us-ascii?Q?LVoozVjoZ6fbs55GWKthAzQpIFTZWYlI2VmBznxnMAsW7WpaWT8pLskEbtdb?=
 =?us-ascii?Q?NqVS12suRbbc23/xkekf8vVCxv2bL85oXWf62AVOUPOv5JUrOvGclM5mFKG+?=
 =?us-ascii?Q?0UOlNvksPu5LpieQyztrQnLZHWPha8XJ5XAkCRdHMyDJ9ZTFHkJZupzIDeLV?=
 =?us-ascii?Q?x8bQ4EFVcQlLtUAVOvn437JPyToofywh340RHqA1QO6NZgdjG+AljSfzD/eU?=
 =?us-ascii?Q?W/easXhpIHcflRotiFeVOfvZumpNJumN9ZNd/PmrlUEIlqtkFOyjIbY2JiU2?=
 =?us-ascii?Q?GZBWW4BtvdcdRJojq+Yr+VTzBBGDYUdSnFSUwv97WH1nQA/A/dsxto/R0lCs?=
 =?us-ascii?Q?JbjXvFfegGxWQgbHseZZDqEBZNETeFv5IyQ/fzZB+rCPymultKiDg/U95xei?=
 =?us-ascii?Q?4RhGBG8lcWktB5AGceyHANl3pOp4jGOeldjAOG3FqJdWi/fq/4zRBeefysKO?=
 =?us-ascii?Q?C7VNAVo4fKz8exztHKUdygxEbmPOIjZ6BzaN80icXOqVFxTi/mJsZZSLDwQK?=
 =?us-ascii?Q?iM63gkYAZFtU+me9V5wEm5LTrv0GbQ1AbQMh7Zy6yjMoHYK3PsISA7CdJJzD?=
 =?us-ascii?Q?Yonv2TB30ZpGJPdaTpBjPmFT0QXgGg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9b0c3e-d4e9-404e-46b4-08db822d08c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 16:36:53.6260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0eqO/vfOnqH76rwxpmxnAHyDowhdx+tQucm8TVExVM1gM74Rg+ZJwhJal/tdjl5vpPeRdfODkCcC1vSCNoDebmzxVAmuACjjeZCu2tdKjZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6373
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_09,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=900
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110149
X-Proofpoint-GUID: OFmvov05eB6AHxlxW_iZ-zblMiZyLMmE
X-Proofpoint-ORIG-GUID: OFmvov05eB6AHxlxW_iZ-zblMiZyLMmE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This change reduces the number of parentheses that are required in the
> definition of this function and also when using this function.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
