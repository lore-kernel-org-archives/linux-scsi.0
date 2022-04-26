Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7A1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 02:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242356AbiDZCjR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 22:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiDZCjQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 22:39:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6D0369D9;
        Mon, 25 Apr 2022 19:36:10 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PNTEul017491;
        Tue, 26 Apr 2022 02:36:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=crCwd6/zjmo1oYC1STkCZgLWmlL+tEkys7TywohNbQU=;
 b=JX9u6wghscz1KX4XYdWCZDfFVT4Nk5keXpL2eCjNJN2tpzCzdmjGGMzRS895nk3JhCny
 AHDPGnFpygpywjUVya+ZynQtznD7TzmRuXFODez3CFdTKHcXMzmlTgxadF9SCplxTiFL
 QC6pJ22UI5Tfu6wQtfP4RuHVEW0uKji2yDOINo08nDR87hSV9ZH5QD0FJ367uqU+UuIQ
 CjOUwuL7Bixeg7fNBERFNVJANxQhKw1e2ZdjHNDgaGLOXi5r0caFZn/bMysOQUFdCR51
 VttDcPGTo/NubOHv0Ufj7t3bxcKYBmfwV/WAHUE6uCK+TNrwWx0DVVw+iThH7uThY8HF RA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4mqfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 02:36:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23Q2U26M011237;
        Tue, 26 Apr 2022 02:36:04 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w2y3u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 02:36:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6gcO7l2CGelWzQGseU8eh4UbAYBGwKtETEh6MRci6/Ew+T4Rx/tWDsl+0KGcp/xPvQQwwWQW771g7nr+KP03djpTcS2UrvtvwM0wfRzukR5OkCi4FLL3dmZNAyijE8YpQbcUxzJZkJysTPwmjoABOsqOV8s0WT8WuzxhB7qQb/Rttl3FqTvyry5clY2HemmcOZyhQFsjP2LAGKEBevhMDsSPsnxaKMMHTg44hdTFipLDQwnoBABUeVx0LpMvrkNLhRpvMiBInwLYdQbzeLp6tQvOVFmGJd7LBKiimpaKYOwrR2CSiOmoh8XpqpDm27YqC7lrHAuOfK+DeaiP7jzWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crCwd6/zjmo1oYC1STkCZgLWmlL+tEkys7TywohNbQU=;
 b=jS2eWwVKYw7qzer/kC3LC7GeA3JMumZzmFcU6qiZXBp8LVU2+v97RvVzJ0dKuSigUymsKoYnaby84Vl60SHUpMwLFG7Rfb/C97zLhJ1mHN9/EI8BQ+sgtAPWTUVzzEIitO5andwHyMt/JItTv0XXFWxm4K1Z9czT2dhiHKRnLmfwKUPoti+XU10PNIcm/MCY/gsnJ70qJyxL4LSP3Cko5KECGMN1aKTJhNDAl0+AMT86FEAEAhguAEk3k0qgwyhNf9NFksb5WF117YNq+mU1flBjOouadbYqB2e0xfnUKRucsWIhukBHdunhzUhlYLyMYSZwG+KoeoHJH3VGVweMRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crCwd6/zjmo1oYC1STkCZgLWmlL+tEkys7TywohNbQU=;
 b=LOpz8upxThp1JULk0inEVgPiDFRkdDTIU6WTCwKwpLWTS8ojkhIYr8gc74n6U38HvW8OGslLAYXOIZfuMK3nIovaBHVWbxab/obWyAyBdKTAPJiC7Z5KRSUwzki0Ld6l/kRmQOu4d9rbnFGDsw7m7WAbT5VsEhQJOR/l98VhcYo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4789.namprd10.prod.outlook.com (2603:10b6:510:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 02:36:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 02:36:03 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: iscsi: fix harmless double shift bug
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r15kwoza.fsf@ca-mkp.ca.oracle.com>
References: <YmFyWHf8nrrx+SHa@kili>
Date:   Mon, 25 Apr 2022 22:36:01 -0400
In-Reply-To: <YmFyWHf8nrrx+SHa@kili> (Dan Carpenter's message of "Thu, 21 Apr
        2022 18:03:52 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0016.prod.exchangelabs.com
 (2603:10b6:207:18::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ef72d44-f778-42a7-1305-08da272d81d7
X-MS-TrafficTypeDiagnostic: PH0PR10MB4789:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB47893C34DF5AB9B00D001F268EFB9@PH0PR10MB4789.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w0kykNaG8jpzIY+CX8kuCwYokN8xrOoa1play6/06UeYNRVHtMJ1L10H1WBAsYS/WSbkTHqUp/0+Dz671n0ZZNsab/CEWoI2jhTalJROAzOzDQ4f4OehT4/EE5Ioz62x0Dk1Vbq5ed0bi++M+8rdHsdGtcZ10nPleek+jTc+N2ImKUBD4/235Lq3mFdQnfEcIe5jI40dKtXNww+FeyUcMsel0vQjnT2vlAo2HoeHREETalUKnevR8JvtXa2JXBRYWrHXK6Ozh8NR9ldhYK6/qwbuMOxY1iKT6DZW+cgfx+r/8jg3Kz7Wj4XdQCPgwNdxhpq/h/5YlAdS/hIwmV9qZEfJ/fwP4X4cw3a+G8u+ngnrPiHIfWq5IAUWFFvZ8mAJaAXzRuIqZ65x9e38yHZlW0kr6ZzJZbiDeVWN5tCiifdrUvV4uAMfUOssRwcKbremV0uGXiJJovq6+3P4mRz85tRyee9cNjcwwkIVvBPlhiUz1A0hQxvO7LHG91O/SYnQ3jfOfa+B0f4R3R3poqlWJsCFZEWgT4RnHssJDTwzTmYZC1mDC4HmlGUYpK/LfD4OxtUoi/Y+aGrTjSos2ag0jIwatwsUuwFxUzq7DOqQXiL2ePOIh6UcJhVN+5v1I7Lf6EcJtCCM4Hz1kyd4Sg2TW6cNDipL96C/lkIXz+lfYaTEVV55d6JaHBBkzMfpJwS7+NV0jd0ZDKGmMhPnLjhw4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(26005)(8936002)(86362001)(5660300002)(316002)(36916002)(52116002)(186003)(6506007)(54906003)(4744005)(6636002)(38100700002)(2906002)(508600001)(6486002)(38350700002)(6862004)(8676002)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IxPRCSHYGKmWKpjs9xL3anuhiSC5uQlqu2aqILZdHvBzmMoxDEQsGw0UXJZv?=
 =?us-ascii?Q?370NdPV+U7hL/1SgxXJGVpLNMwlNE8nO33PuMjpYl44RN8Tt+OQjpBpLqUNr?=
 =?us-ascii?Q?Oe4vaMTL6FRB9IjgWYZpQcuHsM4KNP6W7fp3pJf+SbCsnEDI9XIKybcomhsE?=
 =?us-ascii?Q?IbxrC/3NTWmy2M2V9rjRvdSdsn6zSJD8fWFTm8UGeUZk3dPja8jwrfMDHqmz?=
 =?us-ascii?Q?dz7zVEsQ+lvHnKsOLIUdnOwpZXu45qtKEtmVSaBkPAYZV8uRlA8VeIqpUd2m?=
 =?us-ascii?Q?qxSUsk9eSklTJxJGiqjRv745fhGkaZNzgN0IxWILrzqRlZmlKadqYS5H2q7C?=
 =?us-ascii?Q?WN/G9NNegeMD45is1eRn+WGqYgRA9gxT2ZavpIfz4AgiX1eAsUQ8ZE02gzeo?=
 =?us-ascii?Q?oWzZHeHo+ivYIhkMldbibp5jEsNmG2hyRYQ565FMRt5UosknBLjng/RA5hU8?=
 =?us-ascii?Q?XRdPNPWZFLbQqVM7jnRT6r4WS5SOTwIKmbiosEyhKbbzNCbE/8MCyUHpFKKx?=
 =?us-ascii?Q?YEA8j3fpcxHZ2MKUGTOiCjI/aDnZXIfdc9lV3tE3Ji0VLz/sSc3n9SzBeTa/?=
 =?us-ascii?Q?/AFn2Iix4tl1F/oys58asxl9xQA/06u1A6pqq9gfpZuOaYa8WFCSTt9/jppr?=
 =?us-ascii?Q?Zb25onf+QRK/SC0Pa6TLZUF3nrmY3YUY7BGU6WZj+pTINWDOl56TgF9qygWs?=
 =?us-ascii?Q?AKdBdoIV484IuM5leav5Ep2DhQJYcsP00hOBef2FKF8FUXX25KRHoaBOEQHf?=
 =?us-ascii?Q?pBQ9HSWVECPVrwP3EzxkoSrblIsByGcmy0cIsjxAMGTmTeK2j2GN3jz2k8Ov?=
 =?us-ascii?Q?rAQZYVQgrhjLNzL8BDoUSVKLFgbLsTvUtia1jvHI9g5+qExwAu7Hys4nrNVZ?=
 =?us-ascii?Q?4N49yO58+SGW/GHVGv9WopFYOnzeQ2RUpv+k9E1EWUvVbvH4qoaftoopEjg2?=
 =?us-ascii?Q?P7624UPCpHN1go0QFLgc5oUOMOgRU1oV5DDYzr3T6gkZedsj44UZPQOcboz7?=
 =?us-ascii?Q?oxOwHZHofzRxBwtStf9lcW2O/c7FQG2/cq13R5ej1aTgC2BC1L1lOllQ9zkL?=
 =?us-ascii?Q?cjmMjp4nMj1p5GQ3S4ViIIsHnMjNGjRz/VNQrLB+3SaODcxxI/Dac4ixqEkT?=
 =?us-ascii?Q?dXPA2QTJ+euCxhyS2rovwLjgZCiv3gTODm9JeCvcF5e5olHMkhZEz0spPTDm?=
 =?us-ascii?Q?pZFSFK59hv0964RjoIC1uEnQJpHp7tW21pht1ORspSYNviGyX3knH2bYxR/j?=
 =?us-ascii?Q?8QBtGrUpDH+2tY1ymLThovByCsxXuUflbfPerknV5KfUTMnaKdCJdeyNgOTi?=
 =?us-ascii?Q?t2gDsDvictsPIDaOGBZqHl1ANiSTlabOJC2mPjiBowDdmmeApHsPgWOIufle?=
 =?us-ascii?Q?XI1fFwvgmwe0cRUbFNeEAmj/n0m5zoKEGT0pCOunJNIIsLd62nKB7nowstbJ?=
 =?us-ascii?Q?H+dkXbm+aetlcZin9NeBWW2DCgSWhC/3cV1zOfsuKROtxeTq/0vzg5CS7oNL?=
 =?us-ascii?Q?6k91E0X1gnsJKbcxNDob1/HeePh6TlFxlFyhaGN/jSjPsJ7PvegYEf2VAb/E?=
 =?us-ascii?Q?3v5Q3WftOwRGn8GgOQb68EC4RFuO6ngPPF13t3epUf8fKvtJwOt6GFsG2Kv/?=
 =?us-ascii?Q?kHkHyMS0PmMuZVZATSv2Sj/Gtgr4zy1OjprOI2blVzxL5NcCaIVnzyObfzAj?=
 =?us-ascii?Q?gBcEmEdHLSRO+DbOdk8qsDgIVTNBq4KcrRYwtipb8O774NrXq4L20kVOnc4X?=
 =?us-ascii?Q?hdYYoxvH9V4Ri46dsmyWQDfGPRDGxTM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef72d44-f778-42a7-1305-08da272d81d7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 02:36:03.2963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BdltNVn0HDZB2Ls3Z+u3uotIuXG71VqstX8RVHfrbzoVOf18rxS6m3IFFsokE04VZRUrG4S2V7J4GyXZIYgdgVFuF2ryQfDtxud1NIGSGbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-25_08:2022-04-25,2022-04-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=639
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260014
X-Proofpoint-ORIG-GUID: B-J0hL6Pi0UTxoDDxDt2HpCLmRPlUavG
X-Proofpoint-GUID: B-J0hL6Pi0UTxoDDxDt2HpCLmRPlUavG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> These flags are supposed to be bit numbers.  Right now they cause a
> double shift bug where we use BIT(BIT(2)) instead of BIT(2).
> Fortunately, the bit numbers are small and it's done consistently so
> it does not cause an issue at run time.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
