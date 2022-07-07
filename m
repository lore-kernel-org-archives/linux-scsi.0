Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA48C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 20:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbiGGUgn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 16:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbiGGUgj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 16:36:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D08324F17;
        Thu,  7 Jul 2022 13:36:39 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCXvF026740;
        Thu, 7 Jul 2022 20:36:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=soTcfWF0L1x+hVwkrHXTfTrN32od2PWJpgNFXpuuf6Y=;
 b=0ygv64fj9GR7V8gtIvshmgmX37V+kLigpkIzSmgSD45nfhbQdZ0Svc13LHLY014B9+me
 bgVleDtyWcwOADiZc9ZMN3DhgVINAA1+Na8ZmcYTqQnVfog0xCASFPTperbJUbxuYUX/
 SbWm39icEqnTB42Cva3MK33ZU/kfIixFRyCImvXjdJ38REjuSsbJWwBuddr1eU5Q9Gas
 UygwXQZ2+RhdCmoyt7Qfr8Vo67gD04PJN2naIFRSXq4JK7zKQikzHOS8k3vBzIw71und
 BValOJDujQ2Bj70If9krL/aWL6r7AZXtXcbbXheD4uQyoxcmI+3+JT/54xRSEeaQ538B aQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubypdrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 20:36:36 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267KVY9m030887;
        Thu, 7 Jul 2022 20:36:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud7ar7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 20:36:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1a+mngEUwti+kUMCP+E3E60F5H1kK0I/1pUxGwqVACS/IfZptuaX1BVsfokyQmF5NApDIl2Z8+3Pc0pFk+B2lQc0eATljxuyTpBECDO3yKPiqcOENmNbHiCadnw+s/LSsG581ml99uBJlWi9FZNIja0QB6bzyfw5wN6jrlYgTFrI9zAbE8Yx3PVmgNuXamaYHa5+dMXd1KplTr6PiYNZgjSn3yxryM0r1lnLX0AX1H7ZoHZ/EEpZNeetgu21faaHNe2WXhu7UOFrU6etfxqxNguNLkjP7URr687oPqbTjgnXiLo0X7Km4tSxxMx6+1MEYDN50C6lC13HVA8klJ/kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=soTcfWF0L1x+hVwkrHXTfTrN32od2PWJpgNFXpuuf6Y=;
 b=YCm+/kQ5UEe1g7DjX1AerINdyfYvW/ou+GjW12ziT+HVL8bE8WTHZuf/5ZbLcj+p/e19VMzpo1ogk4Cy7lUZ5bik/04tqiJI70F50qFKFnXWricSmieDWnndSuOtSe5ZcUZ6W31717nbUrU85vUO9aZViOB3DMhTMd4esps0r3pK+UTioFrxNJvaIDI7QI3t7vCDcVWvFu6wVZQUNbeDSKIIGqmE9SdBp+oFAGDEyJm6PTx3PjTfNFwAdOdlpdiHaVlY3ouBxP9F6iKNDz7eMnK1j0hxBxPuWCO94+vhH+GV2OjRh9SwFULEj2miKUidWwwCJfLihDSYt5wWZ5k/Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=soTcfWF0L1x+hVwkrHXTfTrN32od2PWJpgNFXpuuf6Y=;
 b=TAtSWFpeMHk8KOTbRZmKOr0eWUYAe9ZDIZYvnVAJaPhnmxMYcOLQKtyY4PydGphFJBK9VI+OzdfDAFWujM2Q9MFB+KJdhD85QRVHkUj8w5h5sY1fJS+4vp6wv5xY+A4/CIu6YPMLwIADGDBXhgvK+814eXkoQwNks2EMWLyz37Y=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL3PR10MB6259.namprd10.prod.outlook.com (2603:10b6:208:38e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.22; Thu, 7 Jul
 2022 20:36:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5395.022; Thu, 7 Jul 2022
 20:36:33 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] scsi: qla2xxx: scsi: qla2xxx: check correct variable
 in qla24xx_async_gffid()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfnc7j9f.fsf@ca-mkp.ca.oracle.com>
References: <YrK1A/t3L6HKnswO@kili>
Date:   Thu, 07 Jul 2022 16:36:27 -0400
In-Reply-To: <YrK1A/t3L6HKnswO@kili> (Dan Carpenter's message of "Wed, 22 Jun
        2022 09:21:55 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0108.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ed1c019-371c-4d06-4323-08da605860a6
X-MS-TrafficTypeDiagnostic: BL3PR10MB6259:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PYYacdVaDYZnx2Yo2mP57COatwPMhbURySGJ+8StZ5LHNOMDbHZs1xx+xtxfNBsAVsgeADXrQMw4r4o3FH9uiQMmwJ76hT58g3c5mL3pbnoSousjG6FNpe/wxBHhv4J0uHsglYNGFTZwytNJb7VNpeBzsUgNF9yMkuOKuCXrSnb3A0TqzHYGT4mpfMEC54GNDbXfJKYysvb4eplq/uSvsrf5KHDcFv8NotOuEfcTbguKVdJKcSkOAkav2j3BHQAI1nkpHDCy2h6Bh9KDkZXHZn8XfupGG4lbRm5w5jyrDvKNj5riGzyc3ylLmFppkHfGn/MZzuAMJalEsNfhKdBRMAvGxjjjW4bS7hTXd5ritkT1Dc01H8/hxEXTJr0HhA7AWpbvJ0gv/czjThydKJvOJlzo0XVz9T7Me2HJbHxTuOKlMzZazDeNwXAiBa/ZoziHS2tfYnRY226hOrNjDdoeNsl2cJTuUU90WrJEQQQ+vTCLfWF5fspWa/G5GRcQK9fZ334AffDTCXfpo1vv9ew0DuUD7+7XikRVdFrNIsoNQJm7yaCcp/u+y7Ia1HEi0DODwss+LaUKp9PvRiQi/RXvy5lY0cs8QWuvUHnahs2tP0KQtVokMBu92uOSRvY3ivW589OZInBRtWSkGXBOUXwJY6VAV0Fa9QE2L/PAqiJr2vNrsGON5j3vzQs5jC8g/9ieIzLYWeMdo2dHNHUY0giDGzq8Djb/st0E1D/yu9F/UN6RoD9vwntT3O8qAa/MsDrEL3AwBV48Pm1RXO/rlyplPqc+sv3D9rCgylb1tEkiCBX2jMmwXcjZ06+uX2hA/oiP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39860400002)(376002)(366004)(136003)(186003)(26005)(83380400001)(8676002)(4326008)(6862004)(66476007)(66946007)(478600001)(66556008)(558084003)(5660300002)(6486002)(86362001)(8936002)(316002)(38350700002)(38100700002)(2906002)(41300700001)(6666004)(52116002)(36916002)(6636002)(6512007)(54906003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H8QbewwSBB3ReAIRgij8sIx/g+08h5T+9odYT7TbRi48er94IzbcNLTXUZfl?=
 =?us-ascii?Q?9XA4360e+DTgGf3qR2JYQgcu5mwv08mFLzn9tifZh1GhBemBGIcAYLW3LFOR?=
 =?us-ascii?Q?zeQNraxV78avB7Huv1YU71I3sj/Wb0lmjLwg9vpny9Nh5Bqc1kdYOBqAAFRT?=
 =?us-ascii?Q?/SQIdIaRZQlSQJpj4A3iorwNpj2NlysVeVUeCzjNuCHC7zDYPCV5IfKaRAiL?=
 =?us-ascii?Q?3+cJfWDRhrI6MV3pBQDGxZx9ySAEcbB0gDP/y8AZ0urpvBF535lDIOPo/MaZ?=
 =?us-ascii?Q?lB3fVeFcc9uq8lPAaxINAf86jFHIE1weHm0ZvNwceWF+96TOAvEnrwAcSJ9e?=
 =?us-ascii?Q?kzGGedMxLunpevEogTGFX/SuxPRk4C9F0TSHt+k9si07kpjpHLuNRBFBUhV1?=
 =?us-ascii?Q?Nqqf7BhzVRNxhlTXTJjkeSjgbYkRd4/kFbIP1vFRRUuLdHAcTztu1O/oCeEt?=
 =?us-ascii?Q?9qvisjDdbsEg4sk1ZshPeFEogsKxH0d31o4RJQi8bQgZMmvwgQweNVyVbZ/4?=
 =?us-ascii?Q?Ay9eLBLVN8F8xj8hD5GPiOHNuD7zy1Z0JzVhGFNVbQtwACJSdtUDOzyNhh/p?=
 =?us-ascii?Q?qiWJQDOA0HaYKQcnAQKSZuE/2VQNbgPYIwbl2hJr+luJl744XDIHi5kmG0Xk?=
 =?us-ascii?Q?mLyXjWWC+HdMONBIDl4Qwj//qZ6v/+bMPuCfrkwTa1vD2CadU9fcNSr8cr7m?=
 =?us-ascii?Q?AZmDglExk9kMufKAWlY3Ma05RVYitSXQ9nXkurPEhHOgEDMU2Kdog7S5462A?=
 =?us-ascii?Q?58s8dEnEj44pxFfmbbHe7w0a+3EIhm7OHJIt/Vu1Ujw9ni17YeQKOLRSCF1W?=
 =?us-ascii?Q?PDl6m57d8mOGNAolrTmw3VkJxp+vGXVnfGtxLuZukRqOO+v2DGMd5L3RBFsy?=
 =?us-ascii?Q?2bqDNGKMSOyUxR5q/hXEqdrT/Y4XDX0uYONj676zNH2lfhksLsVJysoKnR2u?=
 =?us-ascii?Q?KpeWuNZXQKUDg5ZkWXwKTgcjyvzNnRjSkc01P49pq3hetsKOMK9hULNJ1eYd?=
 =?us-ascii?Q?osolvFKSaH2h5ZYbUBN4yeTcjKfPp4YZRXOP9SxDB9ZZOAFQTn5lXOJH3dPJ?=
 =?us-ascii?Q?Rjys9KJyvtAuYD90QxTQ+DRI/QkWYQbFjf+inXnwx565/u+aaptiy6AZXHQe?=
 =?us-ascii?Q?C8Rd2jiPP3gV7jXgW/KoccCs8D581AUepKASyaFcyCR4PLSVC65gNFzwSjxu?=
 =?us-ascii?Q?OpPseR2KsJVyobnTf68hNZEL9x21qjZXQnfVqurHHDUgzC5O3vApujhpAkS/?=
 =?us-ascii?Q?KK1b6VXOgHjYUQPZW8YFRU5twD6RjuqkcrV1z2TQ7J5sDROghryhtTDoPXyV?=
 =?us-ascii?Q?TD1O7LRUFHzJycxfp8n4bnfCnkxE2YwtHD6vJGcX9nQjynOcMRYdaxumeQf1?=
 =?us-ascii?Q?z9xqviEFptoJQ7Yb4fg4A0wBMCgwMvBfSUrciGyMeDjGihrw3kklMTCzH/ye?=
 =?us-ascii?Q?Je4vq5Zwep25JyNK6IPUUwKkKgplLtO8of+c6y4l/A+0G09vEnukNJMjStux?=
 =?us-ascii?Q?Asuug0YEodeikvxkTzONJc5XHY2l1bPbc8xRQ7C4oN4SDU5f2kv4MUhXsVUT?=
 =?us-ascii?Q?53+9CZsVQLDIwZulPBbLwtbY5aIlGT/ndWWeaRdVt1i1BqR5HwCL/0BXKnJL?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed1c019-371c-4d06-4323-08da605860a6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 20:36:33.6892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SmuFpqPygcA4Llhl0wOMOGalLwXJiOYHvyP268hDtCHOxtLnkXuWrH9S+29O1+4u60hZMtHfyyTmKq2VYpHRaYbVTJafytp8M9Y0TgODLkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6259
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=860
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070082
X-Proofpoint-GUID: I6NjRvTiU4jCI1GQ5TbAoKyESb6kF7Cl
X-Proofpoint-ORIG-GUID: I6NjRvTiU4jCI1GQ5TbAoKyESb6kF7Cl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> There is a copy and paste bug here.  It should check ".rsp" instead of
> ".req".  The error message is copy and pasted as well so update that
> too.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
