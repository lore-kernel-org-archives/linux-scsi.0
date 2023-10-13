Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9395AC41513
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 19:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjJMT5z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 15:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbjJMT5y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 15:57:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DE0C9;
        Fri, 13 Oct 2023 12:57:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DIDw4C006256;
        Fri, 13 Oct 2023 19:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=oJsRt1IIlH950WyO+EFf+nyh+AYNyLlmefGJZJ2JhmI=;
 b=K07/bEvuYPoM+JAuoc2xseOixvvpqLVt732e+6otn0FoG7WzX2O35dlgESvlVyTjDLFR
 4eKzm+PaLXQQXxanBW7b6HRi47wQ6aHhbF9hCqnkImrE6hnOXkzSprC7UKn3UamKaiLm
 BsnFsDElKYA4IezRl92Bbnjoxyx//xkCAqIURPAJxn8YPkitKbkxoer5n306dWi7EK3X
 TxzQlMmEI9xVMXIjLP6ZLJZ4Ui/xdeDjet2ErIOaalBFd8X8bKKMIkkUkcyPEu9JcEXV
 NMJC83N4c8OdfZmnk/LnZmjvaGzmOU8zMnpfUqWFjxFUvMKWXM9ZknvpQxqq9nGQliBO vw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjx43wstp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 19:57:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DIk3wc039960;
        Fri, 13 Oct 2023 19:57:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tpt0uc4jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 19:57:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBWCxiTWox/UvqlcPbREpnAkC7AsPCx6HVahMq+z5CAlLfw4B4psdPO3VomgWS8plp/URAkYe8t2Cz0C34U1tOUUYo9tV/ZXjbIjYf3H27DKVLzLRZ1E0w82Lysl6ysKIMVWcMdApd4j76MRuR2jmWhTBooKhnRe4JTWfCl3ZAnamcM5P0FGbSnPhd7EUv8uAqZRExTcv7ZcxYLViQbmRJcKKIksNVxgn8hd5ObT/mNzy+NPWiihlUl4H1kn8mCSQHFSoB+aZyD1RT8uq2zCV1wC2BYJnU/RMfYGHazNaaA50MNa4+T+CZ3KyxGKmsUZ8W9faLDzEoQKltS8f/bjvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJsRt1IIlH950WyO+EFf+nyh+AYNyLlmefGJZJ2JhmI=;
 b=NBJdV8YjaYdzmQD6bXZPMY9Hrw5Wut7OEIsgb+MiqO6QujSZmKqOYg/myeUijOraGABMkEBehX5knM63vETbUroGKG2gJj4u0RQXiWo9JhtUy3wjqvoi81grtaaxyXh0ku7ORCsotlAcfDWHhgnx2nPg+/zHcMzPerB5oOY6e7oeknhrq5TNkU7YJNKXelJG3MtXIeoAQPdCqKfJHeYTYMulQXM1Y53s9KxTk0podMBoDVgKPQKn0ou/5GzOHxEyz37Cpdpc0aBuua2DrQ40P7uCGxurOknA2SUOvB2CijJR18O1KiphzBGpkg3beavzdb3miprWzTiyto9GtMQBkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJsRt1IIlH950WyO+EFf+nyh+AYNyLlmefGJZJ2JhmI=;
 b=YUxljELs0Cc4NQ1y5j9gNWnW0YX8PL9EE0utSbS10OmeMWaOwhivXo5ngrwL8Fjsch/8ZRhmjV3eHP+bO+G/QJYEYqx17LQ7ytaM74WGTjkbdg0iHmtEspRHeiVBZsZ6/bpZN/Gs3Hj/UjQfdfIYkayf/KeT0YIbfhROC1r8aZ0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB6679.namprd10.prod.outlook.com (2603:10b6:303:227::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Fri, 13 Oct
 2023 19:57:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383%4]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 19:57:21 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] scsi: target: Allow userspace to config cmd
 submission
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fs2el2hz.fsf@ca-mkp.ca.oracle.com>
References: <20230928020907.5730-1-michael.christie@oracle.com>
        <1b1f7a5c-0988-45f9-b103-dfed2c0405b1@oracle.com>
Date:   Fri, 13 Oct 2023 15:57:19 -0400
In-Reply-To: <1b1f7a5c-0988-45f9-b103-dfed2c0405b1@oracle.com> (Mike
        Christie's message of "Wed, 27 Sep 2023 21:31:32 -0500")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:208:a8::42) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW4PR10MB6679:EE_
X-MS-Office365-Filtering-Correlation-Id: 157af630-8ee1-4706-da2f-08dbcc269c74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: efkD6YK0uE1kB+0mlYyZ/Tl22GEdQEKolWzAs8NY+sJScQ/oy1P4aiRFr5MRWInHJ/XMr6XMwFMLIzmmWorlIsmO3b+tJcJCHtrQzIivfeIvF5kwmHC1sraXJ18Tc34aWHH6s5sRqcvMB+01A52cDLkxRDnHoSrJ0DQPsUrUcI6SkJSeil2QgZsMAM0YqlMEA/opBE4N+jyFhsSnwVCT23DZ+ws0KYxQVYYruyxdMk1J8b4sQoiHgrj9tcTY+UTVwMTCytLuk8EXaM3VjO3nS8i7zZ2esCfnx1kGlojlVHo0NpvWabrpiB/b+KBM8Yvh+ys5gUqcpVL758r5bt6jTJ9Sp/N31nMDqINsgfswhjZ7/s0bQBWpQRhni3Wi00ywIaIyw7oh51PbmabFKGq0me6y1kWB2wBxaGjDUd7aMmFPrgzgu6eGMqip4tEQFVUtzGme/Rvk1yMjdHOCVQ0AgQmJWZJ7IWGofliiuBaljvSiSWKQ1HVcYXq8tZ97fDPmAVR3PXS3GHyhH+f0heKWrCO940+zDCvdrJheE1ICGRRh/ld3PjBs+NUxUKZbNePO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(396003)(346002)(376002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(2906002)(478600001)(66476007)(36916002)(66556008)(26005)(316002)(6636002)(450100002)(4326008)(41300700001)(5660300002)(6486002)(6506007)(8676002)(6512007)(8936002)(6862004)(38100700002)(86362001)(558084003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eTon8mR9d+aNd1vz1bkoC10C0q2y2DeY406QuHyO1E9QdaoNtXzzfXxcgSZd?=
 =?us-ascii?Q?JZAOdhen+4jtCEtkiNTakpDPIHrIAo4L2nMdkwa4vRkVAAXmgMmJrlGh1q98?=
 =?us-ascii?Q?sGX1T4HYAPdHS5gSbQHjyjp1czRR20fL+ax5xQLLR+Sby8K7FxNz4n8AT+xf?=
 =?us-ascii?Q?V+2vRUbkTkJsZZQJ3VKSSo0vr57BjBKqTEZLBk4UnLL2WHyfwHpfgOvWFNoF?=
 =?us-ascii?Q?ntjfGWMY8hbT3jWnHgjwKquqi31xX6kEzf8CZczaGMq8uW7rv7+e80gWcVMe?=
 =?us-ascii?Q?jtVHBOMFh7p7YThKRkvUxSqelpSj6ERDuOxCrxXpJ2SKWbfLkuGKA7yzvpZf?=
 =?us-ascii?Q?1IrQevIG9Tn6xn1cX1YWM4D1B3dfCErQq9OBGs0SphFGVvMdlhrU2lNkfki5?=
 =?us-ascii?Q?GNXfITuMUFVbD1vzskhM3SstVBA4hUoMT4nY9PMP9hf8yJxttSKAFxvrK6tL?=
 =?us-ascii?Q?PvdGHrXDH64GjPw3ga6I9JRzeHMM+YxYK3JouMdErhKAX05dbuWPDuXTvCl8?=
 =?us-ascii?Q?Y920eG3k7QgoyUDaExabjMm/MiSJqJm2ypAmFulf4xUv+SPFIfgQORNOjXic?=
 =?us-ascii?Q?iZNGdFkDqosmgYhQ7K4M1dtMrV1zLoHS/QvADTitbiDOIUWYa5VFjjk5ZYPG?=
 =?us-ascii?Q?1eRqweUXoDOe1wuA1JnehQYOvAR/v6xww9sPFQLYHCQno/mTXCMPvLQdAH/C?=
 =?us-ascii?Q?8RcXHc9z07dSvFzO8D6bDD28Xmn801MmvkA7WVtzFh0ZZ946y9IRaytHP7QV?=
 =?us-ascii?Q?IvBpirlCLeoB9tox+Z3QogZ53w3BZ7V8Of/npClMPUXz6xauQdtl3YYexUr1?=
 =?us-ascii?Q?MC00Q45k3K78+pL5kVAqn8XvG+pGsTtKUkur0n+5GkPvdqsArO3QkD75NpqV?=
 =?us-ascii?Q?kSjRmTxKQlQXJhM+cG6BfEM1c8sHRquJLLoHmm/waQrAkfpQ9cUsX+7eKLUV?=
 =?us-ascii?Q?LpAOH2O+hGxKs3UL3+d2HUX1Xy1aZa7RgG2G5GPBlj4wYywfNFRKuCCCyJk6?=
 =?us-ascii?Q?f/oYNJKTqQCfkH2m28q7tab1N/mTigeXhh0Dmz3qK6ET96nGMhoe4JTMNfXS?=
 =?us-ascii?Q?R2pCxeUEylaGXeisa7Mpxn4KyjcW7P69E2/b4Qwy3kh6m1YDmcSCbhHxXd9o?=
 =?us-ascii?Q?5OwkE3v0/c+sBPhsu79FQ+Mqx9/Sx9FNZVlsOMQS1Q2AwBO9Exm3bRZs990X?=
 =?us-ascii?Q?vbYw2xlmt0Fydp0VSdSVQ8c+jw1/iJ8pDMFhvEK+luQ6giIs2sbZG/yOlrrE?=
 =?us-ascii?Q?rk0xsGJWkqEVU5KAljxIIURNqr5YQgsq8w9Ywi+Xtz8UhHMG0aD/6CC5gMbi?=
 =?us-ascii?Q?snfLyfzYD5M5tdoYfUXmDSWdHdexRclAXeJ42ND420Al+i2T4P77EajflpZ1?=
 =?us-ascii?Q?yWk2jxhOMjoogv0Z+B722oeTgtfvMcMUVUxFe1LzuoMTv1DgTd1plZh0/4tJ?=
 =?us-ascii?Q?auuNuWGSUzJj7+feURMK0PGH6ObUxWiEpMI2NEVpArg7LCBj94kcoI7h1ZXy?=
 =?us-ascii?Q?hNqWqeNQiu+iTWdwrMdY0iR3u5WMtlRcAQ13hHqD63l8WkLNJdNQeeBzoatk?=
 =?us-ascii?Q?PjUMVi411/RRGOJXe4NZ5ChV/Iot/r36day3dqwRl+oO9HM4ua/07Wea+Qe2?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ELg1GQrXmfm+mR0z0O7u6fAHLSIfiBRC3VzXC+fAe4G7zEk9gBAjn5s6nSSciF8+aWd1X6hYWKRh4bFJRloOfRHX5Vnze5p4GgurHl2E0f+scsqP0ehe+ZLxdkMOTP8+uuyP1w/rlvXuMBh/CLDPv/DKA964gaTYDIpc/Tf46j4tl8JocCXWtR8U0Xkb9QC91Eak+LK2Fp5XhKKq+2duVC6z8E8gZVKlVNKtO8E1LCLIPxUhuo4uvlrs2ffUA0+PULsQA6xSrQA82h6hhXy1tLHoEH9DaR0iF5xIdFYu20CyWk/L4QExZ562RsAny3nOXgqpF2Tq0uEpFH5s/EI6usLjhBAWL6gEDSCmb1CBVDCQSq1rQtok336DXGIx7iyHOgDPHZz5ol0CHrFFci5YQeabQO8d446JhZxr+mxmLwZqJFGhU4lxIsjhesGAO5dz7Enguv8G1LIYolBh/HW8D6Jw9Z/WOIDRqeB8OZ2aPsjGtRnYhUtsn2jhZM398ItpBMYDeIk5vMgs6/4SOW5GwXGtXAij2FNtnUX7fY1SPI13AKMgbBE4Oi15r/TCKqVqVttxLANOs457keiCzdkl8x7+NgrE8H+TCFtZuBIuEPSz4OG/nzjcxOBh8x/Q7yCRpCiznEOwm2CHyGLX2lFD+duHnnuphXWuwUebe4R8aIQGS/TU/nqs1Eqyj6MxiUnMYZlcGManTYoU1U5p9Lemy97cKYvyFBIa4qw9L0f2PJQxqcKRnZL5MURwl22+N//dTkyu7rmtnIYh4fW1BFvJYw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 157af630-8ee1-4706-da2f-08dbcc269c74
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 19:57:21.3799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R30IVhPO4xHDd6l2agqTC8bwti4pef25r4mNjTUgRHpGghEHZtstqIK7RIi7kt+bVuNllSLfCyoSrE2Gjq1TijZ8pBuYvJSmIpQDuJkoI1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_11,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310130172
X-Proofpoint-ORIG-GUID: 8JqiY5yWrO0rDjr4auA8UzcUPJCc8FHE
X-Proofpoint-GUID: 8JqiY5yWrO0rDjr4auA8UzcUPJCc8FHE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches were made over Linus's tree but apply over Martin's
> branches. They allow userspace to configure how fabric drivers submit cmds
> to backend drivers.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
