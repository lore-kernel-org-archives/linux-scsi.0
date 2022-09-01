Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B38ECAAD8
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 04:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiIAEff (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 00:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIAEfd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 00:35:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D487A520;
        Wed, 31 Aug 2022 21:35:31 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VNnUee017482;
        Thu, 1 Sep 2022 04:35:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=pG1aggXHKX5vGL/gKZn0qmnbG7Hw4nuNdMS7OS+zjoI=;
 b=ACAnuOak07IVoraAdenojDGD8grIgmsYs1RjeYntnqsdoIEa6GPPoFSU6rSZoz5phTHZ
 cqtDSHHyLrtwuhWeJ4wAwxpnrQDshHA3nAI7oFXuFRaBKriupAmS3yxb/rXWJbO++QVT
 suETZJka8Ib2ACjdaUW56jsilJf9fKfjTaqdkskAhpxhm3StLd30QdI6xlEhR8x0IFL5
 VfrmucBjaH+9+M0zt66tBUpp2u2/57GTuo2sOkDPDUPxHAstNBcLs5XX5KiyO7i5Psiw
 YmoWkM6iPkBGCAPeZgIXB9B0IET2NSIjTpaybVDDYjtDuNpvgVVpMSxsWGV4C/F2d1hY 0Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j79v0txrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 04:35:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2813QKP8033605;
        Thu, 1 Sep 2022 04:35:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ja6gr2rya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 04:35:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jG+te/tGA2qNg3xQZrTsSpPWlB/r2dC63cjIv05Na533hapZtQLJ57J5yZ3edLRTFrzLrek7uVKyeDlDrEhfCeEyYCdn9MHxIybdQHFrSTYPT7q64l4oVzaGIwBSZ+yzd8HFaq4YS4lBXhAE41fZdTGP9/Q5fuyF6yJs5CPTQ7hKqvHl2UaurAHAYhVOsnymDdoOQL7wwwsj88khdem9ptjE5uJ2aFqPRelK1AVzoofna1yTEySNNcTcunR9rzu6GhSbtkJ9LEnwDHQeTFICGHUXSHmFvoEIJo6vGlpl3mWrKa/xVnQ0Fr27DxYbHJ5DiV+rVCm27DXIQW4i5HJtNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pG1aggXHKX5vGL/gKZn0qmnbG7Hw4nuNdMS7OS+zjoI=;
 b=j+72/prUQqNF/LPmaJJ4iQ43JBFYu5rLZaRmG4Do20zV2Fhntai9r3iXKL1XOmM7Au8AGKJH59EF9tYWeLJOvv22yKSU6fWHM9B/4UVsZ1YIh9WSgX+ltDNFFIoj5QmrIFtMqyzEmBeAwZBvrJuAkn/xyi8orRi+oLq3YtFxicVFwa5JeRJ5heR8vz4DrqsX7aT1+zYcLTrHY+zvIDDl4njyAh0yZA/hU1ql1TK3cUnlyLYF0cpBgznHkI33/nQ7Fg9x8Qwxbv/g2jVRPak9wPgKoi+g6WBPOlJFWytMPZ/tDAJUrA8sfTW2sHtN7gsA6gaaEkgRsy6CZn3Ll6IRGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pG1aggXHKX5vGL/gKZn0qmnbG7Hw4nuNdMS7OS+zjoI=;
 b=UTeA4e5CXw+Owk7kAsdiIgDM+cS2dsloWj3VpBsKkmwg5kbXrROgjYG7fJVplRy6U0zz2usFEP4lDeXI7K5SvPifjv7fmH/DELAR4NNjatVV5zLPNIx2Z2Fkm7hs4Yh1+iTtlnCJpXq8jBoqWdQjtCKSei+fmqGqcsTXvHn3r/Y=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB5943.namprd10.prod.outlook.com (2603:10b6:8:ac::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.28; Thu, 1 Sep 2022 04:35:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 04:35:18 +0000
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-doc@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation/SCSI: fix a few typos
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnanlnmm.fsf@ca-mkp.ca.oracle.com>
References: <20220827221719.11006-1-rdunlap@infradead.org>
Date:   Thu, 01 Sep 2022 00:35:15 -0400
In-Reply-To: <20220827221719.11006-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Sat, 27 Aug 2022 15:17:19 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0034.namprd02.prod.outlook.com
 (2603:10b6:207:3c::47) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2ab061b-57f1-4473-6e0e-08da8bd35f35
X-MS-TrafficTypeDiagnostic: DM4PR10MB5943:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 64unhDPJve0BrVP8GnJTk1GjrLtl9BbrQJFmka/KhMsrDIAxPbRxsuv6LbN1urs2A7qWRqrBQEm37sHxokXFSw/VFBNaV7RZ8i2L1ughQ7ZtyHEyIqlFddIuBzGXXkpegJRSKoIb4PKB1iKzxvGuX8satdPNOeqQRQf747nxgALN0cl6OA+oai/plV7DkY96/zJT11EynRTw0DA2P7KRG/4/cRmMEnzmoirMgJd5IYhmvEcseYUDhXXcCVi4zC6yuZj7u4UY5UCv5X381WT9mnuUJOGGJZxflH1J3K/Wy5ayPFyAj0uFUNgwhFFANpNckmBztNtQweUmFrvENFO5+8TtqHqL8hNl9MLGGSOf3O/e1xMpEVo01lXbDXFWu49i5s4wGYqrs0KRmLfq2o1ztv4sufaMbcyB0t3oSr19LBMWfbJm4dPqwDrk49qybSyCDM0zHvFnaa47rVeQB3J0+idzxyWjuu93CGbwzBbyj3RWmrpFuU5YSlmvGRCUc+41ZnQbLcBy+NJAxpBlYIPhFgXiAOBhTRB1T075v4siazNR6Y0R7sK+khFIuGTX1idwHKytXv/FLg1W9wHgiHd3uWHWC/TJG/qVvA4zHhNArunuaoWl5EXlIEdGIdHzpIXpuegBUamMXywcDuiIjmbovUFKRkrB8ASzqPSmnufipXAUbnpGoC878OBvT6X1drVv8hEk8y9EUQNFuXhY/GZkIJObX9SKYtRNTKgQuRqyZJVA4hdHitXCgKDgwNzLxio84fmexlzR5NiTr+o+yji8kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(136003)(396003)(366004)(66556008)(8676002)(66946007)(66476007)(478600001)(6486002)(316002)(54906003)(6916009)(4326008)(2906002)(4744005)(5660300002)(8936002)(6506007)(86362001)(186003)(41300700001)(6666004)(52116002)(36916002)(38100700002)(26005)(38350700002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u3nfQ6HaV4zLC0/3QuYbeTbny1eHnjWmWdNpsDBHzNZOLLMm6pW0Kvqpefwg?=
 =?us-ascii?Q?imDtvwNuQcGrMwgfy9ai+aGlbZlHZtYCcmThoKAyXt5JIaUZA3/Z9v60Lq0J?=
 =?us-ascii?Q?DHi1qYt9wtNPDCUz+lJZUjfJNdy5qmsZF0V/3iv0THs7Ow8eq4m1cuAXmOyC?=
 =?us-ascii?Q?DEgwsQ0d4lVxZtv7k5K7N/t+N7lPCU2cg8hWjfVl+qYP2ADDSMBEjUkDObsE?=
 =?us-ascii?Q?nsS9I6MBKH78ynu+T+24sCiZBeVwZLAnqe/NC59QufAQsq+eLn66Z+uetp++?=
 =?us-ascii?Q?eKfzjcfBEWbL2WK4MyQ4LRPa5D5n9xDz26Q+waPilrvxmllM/H22jgVkQ8Zi?=
 =?us-ascii?Q?UL8GwJx4g4EPwniYWJ661689BlxG1rCbeT2aJsZMGNH5QyurSLOAPFvdY5DB?=
 =?us-ascii?Q?pcn8zkxxFcZAkuKkM7VtXbAwn9SyHHQdBgQ/CO81x6Z5VxvrgYG6ibUMn7Gz?=
 =?us-ascii?Q?4aGi4iwaJHcw/gV5/umBVO79e/2Sbq77/VqbCUeto/zs7Mj3oqFgaec+BO9p?=
 =?us-ascii?Q?/nSIlzJBgjPdAOzvAV6DP3A+k7VtChoDPNXJqA5JAFpefzyYAGDQYyfQ1a/R?=
 =?us-ascii?Q?Dp0ppixBToH097d8PS/fdUr8cwx7MEmGPbhHvpXYYCkj3rVcmrwufXuebOvG?=
 =?us-ascii?Q?OWk3eVoLtE0CD3lHB3FuHVCKVqbEKjgRW3mPy8dzymdeCG6SJNele9vbObY2?=
 =?us-ascii?Q?mZfJesozGM0uFrxfdqcYK9aeaAqy0hDWtiWxNAO//wYNN4V4u6d4j5NHjq7o?=
 =?us-ascii?Q?VlEoIWWKbu6DP4bUkIQReQVSONz2hXPxq7DrD4LGvXZesHyM4YbzvO+hnYiS?=
 =?us-ascii?Q?bKQNQC+OcPTnT2ckcQgMYXkkEQVP9HwuUuVqIyQAzwQRi9AN2Y9hCLSfrdlt?=
 =?us-ascii?Q?qEAlJ/5qMvR4sMo302YCz4QkHev/o1YmF8ZZRXup28nH3D+6gP/M/zrZlxGh?=
 =?us-ascii?Q?kLriOk9cbEoW8uPTZue6BLcFL4b4GSU5XFeUD1FrRLvD3Q1ICuuQvWl8fC4B?=
 =?us-ascii?Q?jXmG0pCvC4R+mhG6zbiyiTUCb52ZTxyjBLda4NwXSc1rb7jeRghgzLyKJas5?=
 =?us-ascii?Q?4IPJZ4/XDPnzNZdltFVFwUc4VdIWtnvatSVIJZRwgVZWKg3z60DI50Zch3Zo?=
 =?us-ascii?Q?X/uQQWVK3uIQyzK8F1r+cLUAjGMNbr3n/K2Kn+bjOMI1Vbqaconyghdzk3Rm?=
 =?us-ascii?Q?5f96VO/c9OXlybV21q4Iw8mQ10kQgdaGOreLd7UXFaKq6vUDACs1nKoWZPK1?=
 =?us-ascii?Q?yHdz8g1uq855VJtNAUyiV/cLcy8DMghairSHVwGI0hKmkyP2l2KY5PYrl2hg?=
 =?us-ascii?Q?HBD+wEkbElQMyHSAMQu6XZ+9bnL4R6MEVtuCkBUBDMWTsOqRRTNMdGfftwED?=
 =?us-ascii?Q?4Dfw+qggXWOsDc0m+vXmVQch+/uGi19zhDHhe7t8ay31fSEIIEzWlaXCBGF0?=
 =?us-ascii?Q?pYvDXbGmb1H6A6CbnAjYC9fJ9RIY4jqyTzVeqmvKzrGfmvOgaKph/lwJMfUt?=
 =?us-ascii?Q?IemlBxyeCOURATTn6CwJ2wnTGoTH2rRjl2ZCQpSA7Gge7EhGfLceNgf8aNLx?=
 =?us-ascii?Q?O54b0ou/4cEVuNL3CTb8Rxv/33QO769AY10NKzky+xUDtWcSMLkdP+e9q8g/?=
 =?us-ascii?Q?4Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ab061b-57f1-4473-6e0e-08da8bd35f35
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 04:35:17.9978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5CRiwi3aPBQVGREUzCAxIt7LlyOrPJ2jWjDWuKn2qI/EYM9A9wRAgAkRWXnqH0FpE01dU0D0+UyXlwte7900R3IbyT7AIh8zVbSio5Z1A4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5943
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010020
X-Proofpoint-GUID: lP5T0JleYnhlj-R7Lx5uX6LscwZ0mL7D
X-Proofpoint-ORIG-GUID: lP5T0JleYnhlj-R7Lx5uX6LscwZ0mL7D
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Randy,

> Correct some spelling typos in SCSI documentation.

Partially applied to 6.1/scsi-staging, thanks!

> --- a/Documentation/scsi/scsi_eh.rst
> +++ b/Documentation/scsi/scsi_eh.rst
> @@ -206,7 +206,7 @@ again.
>  To achieve these goals, EH performs recovery actions with increasing
>  severity.  Some actions are performed by issuing SCSI commands and
>  others are performed by invoking one of the following fine-grained
> -hostt EH callbacks.  Callbacks may be omitted and omitted ones are
> +host EH callbacks.  Callbacks may be omitted and omitted ones are
>  considered to fail always.

This one is correct, hostt is shorthand for "host template" in SCSI.

-- 
Martin K. Petersen	Oracle Linux Engineering
