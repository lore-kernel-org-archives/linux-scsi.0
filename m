Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F04EE0212
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 01:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbjINBM7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 21:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbjINBM7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 21:12:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A2C1713
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 18:12:55 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38E0BQV2014746;
        Thu, 14 Sep 2023 01:12:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=CI/AhHXMkTHtsTizhUUeOdX8rd4t6vdpGVZv1TpsQuo=;
 b=upCNcD0G9MFQemQObMKsEGE4XWHS1IFfD8HA6SM97L/lp+zZJ17H+CnFW8x8SZjzcwza
 vcalKw/8Gz0pjJ/11Rp4k+HGQkXLCBApslNjfE04bdn69LECeTVna56z7L9fh8ix6kqd
 JFAvokCbGrhai13DaxMudbxUzm2s6L0sLonETQ+7PHXk/a1JVe5RtDhk6sA6UK3FNuEd
 y2n+nT2uYJOblAAjjwLA5JE+ny7oFCK0ljhQssviPXvqU0pah5Iskz+8FxtUP+IJgMYH
 SJGDpLIzOevfUjQrFjNUV/adb4WyzhGPDWUQQmescXqj6bUb4fsU6Ssr0Kwv7ZpaKEBy SA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7pkgtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:12:49 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38DNGqgG007565;
        Thu, 14 Sep 2023 01:12:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f5814bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:12:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Acf7ZjFpzDoTjbuZA2TQt4npz2ZnbKwOCiOxC6VCk8LdYdGXuyM+j26FN8V60FwxgtELDjmfapkNM0zZn3XkAN4Rnp5mFZW+J3sK8VKkRqF0HKk0Y3iwVAlFrHkMsP7M1B+0TXIypOL//mxm2XfzD5AylNdCN1r8NucmM++63UeJBNLyIywg7TgUuBzvodvZgizrrlMt0Slad2iSXqVfrEOF16SiOBYswsjZ+QTstR/cYvUn+497Qi3EITE2qC+9aJQHlqRpJnj90sir/OuRGouygfOANIfHzkgpzaW1jykCnBcBAIg7cmPLhqMkGj4kgfz2f1NaDht+roOoYu1WIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CI/AhHXMkTHtsTizhUUeOdX8rd4t6vdpGVZv1TpsQuo=;
 b=VBDZ7Huc9J5tMH8G0iiJFNcGnDO5Q/6OmXja9TpYD4YIXKtorXuIF4a/Qlo1xD1bePOePyLwOYhsqPEtxRifWeADduRW9ZM9qulr7pSSrfonzpf7MXGSUDo5fNWq5Flp0spR8YdnOmKqWyHYRGhqKqCtxpHrSbsSbiT2vZRtyIfBgHvGW7a4TVzD6ccRoREZtHBZroVC5/Rd9cWDdUsFJizSh6vC+7m8vp/PnzThACzAFEIhfEFwfH2MEvF/SbMBj+ehvEUJsvgN3Kzm5haTbvDN/E6KMv1EgCyQb/iAaDOpUj45Uxc+R2r9M54axIBTOtLhEftJk5WnbRjEugCsrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CI/AhHXMkTHtsTizhUUeOdX8rd4t6vdpGVZv1TpsQuo=;
 b=B5F52kqGXKWmAb+4bfJObEH9jH49iHdAFI2VGdTO6SP7ngV6RJfppry1ioEpbGZ7aPp9XP+cjqIws5KcgeyPKWhLCJfWg29JGvkBr8sxQb/IEo1UUMDxAik0RxItFA9y/Mcky1i4NUzkvS4I4omxn9s/UmGfQ16B2tBgp1UbNW8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB7579.namprd10.prod.outlook.com (2603:10b6:208:493::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19; Thu, 14 Sep
 2023 01:12:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6792.019; Thu, 14 Sep 2023
 01:12:46 +0000
To:     Alex Henrie <alexhenrie24@gmail.com>
Cc:     linux-scsi@vger.kernel.org, linux-parport@lists.infradead.org,
        martin.petersen@oracle.com
Subject: Re: [PATCH] scsi: imm: Add a module parameter for the transfer mode
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0n1eeww.fsf@ca-mkp.ca.oracle.com>
References: <20230831054620.515611-1-alexhenrie24@gmail.com>
Date:   Wed, 13 Sep 2023 21:12:44 -0400
In-Reply-To: <20230831054620.515611-1-alexhenrie24@gmail.com> (Alex Henrie's
        message of "Wed, 30 Aug 2023 23:23:48 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:332::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB7579:EE_
X-MS-Office365-Filtering-Correlation-Id: a3d391ad-37d4-4428-7776-08dbb4bfb476
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hHTFLJq1PWCvJPyvl4SdvfCo8yVYH9PZRYYfRLFz3TEuQaXLIK97wtBtqkx2iePy6T4f4OoTpfC7HMMt97CfRmk4dpBKNl0PGx2zxQuNnnk7ztbw7O7MQ0yoA3NMqhnj+IKUK+GT8Bhjy83X641jzsETqe3kYvZlGbuQl11PrXw7yp6Q0wwiJ9s85Rx3snnOCiAgJSUI0nnpN6ouONgIBJrhoFFVKyzY5fD0vWKo2pLZrNP+0eV7uqkdsUXr2rM39/d1MzjlEav31d5/6LoECFlEcdaML+8xkMOBDbcSsKkZsQtD4UgW0tTB106BFAPQ39LWgNxDgmFu9ewBIfxgGJpiQPTmPWmal/LdL2TQBqfTCTubcWDO+Rh9wWJj7IQfFVmZAkETSrE7S4rPm/WL4wO7IiD4rkV3c0EBy70uIqfo05QHkNiaSIi9FIqUAFHFubqF8nzoHcJ5iNCipwNYh5ErR3WfZ9MD768Th8B1MRfFpef2Gf2n6EmaFpfNTJfWqQA4QnXwLobMiUoY961f48HbYCNZNgpxUtgUxnDkq1J2tt1NWqShfT4ltAAPdUFu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(396003)(346002)(366004)(1800799009)(186009)(451199024)(6486002)(6506007)(36916002)(38100700002)(86362001)(107886003)(26005)(4744005)(5660300002)(2906002)(478600001)(6512007)(83380400001)(4326008)(41300700001)(8676002)(8936002)(6916009)(66946007)(316002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2RdKT65TZikZsjjSXIjnc3vT9ZiNCvMPHAW/FCgQz3dvgHJmMpeHAGGjQCor?=
 =?us-ascii?Q?CScrrboK0E3nA1jB0V83WpUwEIrFS4Kwy269F5V+rYjZzcU+njd7oPffPxab?=
 =?us-ascii?Q?LZ7D8z+msHBt7btUJmhu1Pc/wVnrT83RdNzeY4BsL3B/WXHgKFUqaHOiHWdc?=
 =?us-ascii?Q?AiZIqQ8J0PS0aMJKdfb5GgV4OBtSzhUfL7OUSxUQ9TvAzH8Z1C61YXIV9V+r?=
 =?us-ascii?Q?bFCUWk7+hvh9JNlyMMEtx1PQOdUPvHkl3w3o3l/fDE6dpSFwJwaqadK/Z6iC?=
 =?us-ascii?Q?8xMuOynsuf20xqdWAkG+4ydNelJwVYOI244ggd2CkZKRsL1WpoxeVutTCVi6?=
 =?us-ascii?Q?RHGU5yqWGAEceCpIpOv238NwD9OcnpRV+xCxGhQmykazNVM4DA2XGAXOEWMI?=
 =?us-ascii?Q?5TJTVROuIPf6yAUpJMkc4VbGPl6OWevXjtiHpi04+b586O272zddZ9Zhy80o?=
 =?us-ascii?Q?RmPhNDYecUHr65TlA8GzJWlIhXTX6vJ91EU3xVTjRoCPv3mLPj9ChtqDlO8Z?=
 =?us-ascii?Q?nzMP+QK8TUtT8768hDcAAC6VxgzIeJdftWAf8GtVg+d/z1TYL0D93PUxPXq4?=
 =?us-ascii?Q?GCBLQA/sUyk/6IFlGhW1C4fjBjiLjZpWN2NSfgKcNuoa8N2wLF7Fp+qFxfZd?=
 =?us-ascii?Q?PRTljDZ+IeKR2p08ynlDXjvWWhdPUlEL+3mKE3KqEpHrK266LydT+Bl3pp4/?=
 =?us-ascii?Q?OOgxKCU238mwUqjJKMFMjhfIJ5B7/5uh8upYVxrZ3QbZPT3EjeKwhEd1s8bA?=
 =?us-ascii?Q?BOOqFRnUf/cyZRqRDGADpvch2FzbM8JR9sPC8pr75R78SLYW608tpnIPwA8n?=
 =?us-ascii?Q?LD5V+uDhOlkDEKZUYuKIfqg3NHQ3prt1ehzb2ckBBtnwttHHdSnSVpjhgx/4?=
 =?us-ascii?Q?7fZu4huab9aw+hTS6Ak/8rfI7IiP1lFrZxgLJrLgH4GYAWkMVfeHiFhxXI0R?=
 =?us-ascii?Q?mOtx5mXmobaEwpWLcMnGoSb2NC/8Pq6+It0/zWFvoZNisKI5vbFE6Bib4VCU?=
 =?us-ascii?Q?JRGO8iO5H6plN56cjcGys8wJILaTtbf+1fR2naClu4zaPe21qQzvIdUQuXc5?=
 =?us-ascii?Q?hWvr+npvkn9MbR+hj0M+Howqm4bV4BKvSyr8SCIht70ND/WnQqC2GowCTbZG?=
 =?us-ascii?Q?Ia1fE+74W2RThHi1e2KUZS6zeDXf7ilZLULv+3bibEDG+nPUg01ItLu8uP4A?=
 =?us-ascii?Q?Z7mJ2aCSX959OAo8JfcywfF5n7OnThRnxcschtGde04b3OfN+wEy/Zgf+Ozf?=
 =?us-ascii?Q?BMaZgqJR17tOKNVmL1mwOnGjXRh3jK7622DxSQAk7bgSiyRAZVQoWe58jRA9?=
 =?us-ascii?Q?16CnCjYRogm+deXcHedHtRanFis3d4oi8wYcdp4w5cyrzkvZ7uYBi0zaPD0b?=
 =?us-ascii?Q?VGfpkpzWSGKObJEB2HscfhWu1hh3kLaESuHw1qPKZ+XpthOemlA95cb9NppK?=
 =?us-ascii?Q?2YnSdqAjuBwP5v7fsnh3YhNj5dWsF+YlE93Z8RiZpjnxfJ2fiDPONOrSOg6f?=
 =?us-ascii?Q?kpBukcWZmfcGeOe4uW3WvCrSZtg0QJiqOj2axfvIhBapv8ETp4fwvyXXZ56q?=
 =?us-ascii?Q?LqMTOWuhdCmgreaoVRJOG9fyfUoN3mITxEkC1rUFwjwkMH0jwAmnIgIa5c39?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XYLDPuyUWG7Fq8/E16h+a/mXEzsbpwZyupUqFVIgX6ySFHC1WVB4Dfblz3gGTQQ8xUHTBWGvLUBhz4APbJ0636PA62yKIG06dQVNM95jofQ5rNx0y6u2dA0KeVa+Z7W544N9OZUhs5ncwKcu8Uf5i5fxnXHMl67S3iwCCfy2voB9CMjYVB0u8Bpx8Ppw6dDhbHtKCXV/eow2v1/vUwobsiwYfEHYrkp9MA0JhJG3L13eN8AV9yrIAsoLN1KI0nyRdkKkhA+uRWcebyO9KNLmoytZsjjMq0Yfj/9RECP12UM7xmO2XP+Gzf2ZhBKCk+DdeKXc81i6gMn0QoEd+tGG8WVjpDlf7qULCPxXwYEfVMNtXwfAfzffD/RifsQarnIAk8Edj3AOWWSRIOhBzpPa3pEBfUYwjaSgLSpSnSWR5L+0mYfSr+EF46C28Lko3HbLf+RFoSuAgXIUpzjoShEL0lmT+OgWlArFj7vnuWnA61F3R5fdU0WB361bCzT+S7OaY3cnuRQC0jyxenJ6LYHPI8e3O6Tqzq+7gb8rN3cztxNsQxpsU3fOws7OcWmkp5C3Abo7/BWOyhdO2H0ohJzqAKRjeG4TiIxA83pG6H7g7lC+JMYKdO9hKXE9BKKYSRNavYF0R+pYMA8H+19yB2/Lplo/S6LVeXQY5xsbdW/UlWndJWMvH9dKqPV473fHx+KXw0q8YiKKbnoSNcY5PFZY4guVB0GFS9GSO/+EvvMqaLfnFP/TaVHSHEfO6wYmKjAAbs4JC8NyvTNcyxOgybdHhLDi58b/lSQat1PsF0LzARWuhRHtS+1aNyeyM+jWlo02VBizYukYZx5cDgCOutYN3Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d391ad-37d4-4428-7776-08dbb4bfb476
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 01:12:46.3348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cPu1ISFX1x2FCZf1GJZnBVvMPf1rsz5q7oBnGmP1DVZDSTPX5COF15M68KUso2aAz/IFZ2cDQe1SpVlf5wd8+/2YByGMqvGkvEVJfDCY/NI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140008
X-Proofpoint-GUID: nE7gaHjRbCpUI3pCenKRbtJpVfsLlWGU
X-Proofpoint-ORIG-GUID: nE7gaHjRbCpUI3pCenKRbtJpVfsLlWGU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alex,

> Fix in the imm driver the same problem that was fixed in the ppa
> driver by commit 68a4f84a17c1 ("scsi: ppa: Add a module parameter for
> the transfer mode").
>
> Tested and confirmed working with an Iomega Z250P zip drive and a
> StarTech PEX1P2 AX99100 PCIe parallel port.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
