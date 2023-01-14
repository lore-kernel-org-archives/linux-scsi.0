Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986BDC3DA78
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Jan 2023 02:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjANCl6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 21:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjANCl5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 21:41:57 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A9113DE2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 18:41:54 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30DNO8Yk030816;
        Sat, 14 Jan 2023 02:41:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=JL5+k7LENqFkq6hFazQE6O7uui7uadEdLpZLZpRPrd0=;
 b=IHarEPQqVLs/RVvf7JfgwiHYKsHi0Pc8IsW2gR0DduQtTa8iOzfxPqSX3K5KGG0ct0Ak
 38bDO+Y7N07/fYW2ar0TOwnRx9dZr0yBwVqGHMOlRLHm96JplC9MYOcVJRmz9oYEwAQp
 YxtLp7ZrenAguzFu0ETTlwSGmtk0gSRk/vbzmF3321uaeYWXSmIht7+a7ox2slUxnlgi
 VNf+Gnbkmuo4JcoQAIIjsPmweFO6a7xlUO7eFTKtF5JG8poQqgEV1+qOLvZanBsdk8mf
 ulNuT0Uf3EzAQyQPkRQAnZn3LTWRkX0aWpeB1u6fcYsKFUf3LwzHoMUe8ueX8gwCI96Z Tw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0scp3u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 02:41:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30E2d9p8008335;
        Sat, 14 Jan 2023 02:41:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n3ksx01g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 02:41:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqh0LhwbrrWCKtPwtI7bgFcxKvLTK9s+wEvMnTnXrUeFldOsiaeBQq4CGn+8U0XJp6rAGKS+fx3bLHNHs5ZetXjnOjbGPwT7JAwZE1B9bQEbadQXS3UNFS5HHUnpZHkD+zD8HfKjJJJCBODhp9A+YKDc/fIErJoCMkFOZ/mWJF2Rshkis4LddwalkGBAJwOrVBcrAiCNtIm6c1UIOd1TYJyWCiCCeU4gCwlmyu5bAXd8xppS30HCuTb6Ki9ktWVpafGabMYuFWL2akCEAGcqyyBRfotJQ0M4+2nH5Ys8Uq8fCHTt9Rn7XmuCS7BIfqOWQb/HeV61B7PScSrbSYl80w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JL5+k7LENqFkq6hFazQE6O7uui7uadEdLpZLZpRPrd0=;
 b=Bx5jNJHqltvuHszKrcGrws+3yTcagKt8SVixOC0HbVh88jGIEBQ2nAfpq2vsynqkaxm4/64CidJ9sC9D2Gou3PlFlrXH0yg5nMOnpmBJPGpYgBlaD27EN9KAMv4mBXvJz7f9FFHY0mMJL6IO6+uB7/8c6E6BNeMbroukTkYZ967yxHhIPdDqW7N7I4w3ybVz/T6pzMzZ9lWTVpeJ0xlrxb4hXCiFmCyqcvuqq3ilx0PnGFssv/JhS+rfA8cM8Ykjd6qjvVVIjN0Xw/zzyxe7TADwyrvPo2Rd3Sa4fP3iStJostglEPKSnmpwc9c/vaSvgkuo7V3+2BOUxEyTd6HGAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JL5+k7LENqFkq6hFazQE6O7uui7uadEdLpZLZpRPrd0=;
 b=SltTo38+lR0rWYl5GDFsW+e2ewAKBMrzhPgrt/6Pv2lCUe5NqqRyQyc4Ofo+o5O+MjgmVXxN3ScN0cMqGZ/qMGp10kVYNqUmTy31syw9DjMB7y4b/Msyrm4Pes8MCSxXpN8h4y3ZghtxdG4SLGg3vcB1V1PJ9A7K8p62kYaf7rY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB6132.namprd10.prod.outlook.com (2603:10b6:510:1f4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Sat, 14 Jan
 2023 02:41:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6002.013; Sat, 14 Jan 2023
 02:41:42 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v4 00/15] scsi: Add struct for args to execution functions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8l9suqv.fsf@ca-mkp.ca.oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Date:   Fri, 13 Jan 2023 21:41:39 -0500
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com> (Mike
        Christie's message of "Thu, 29 Dec 2022 13:01:39 -0600")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:5:335::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB6132:EE_
X-MS-Office365-Filtering-Correlation-Id: e1c1bbce-155c-4506-d0f9-08daf5d8de74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gvRc8QgC07dUJUE3ql0GyrCtcWpVuNjWdKH2oQcKqpGNZIenGjxLcmPt5eiFWT7/hwEh7XrCYQsF1Ta3pt6E4Kf2gHJcLUvpHEggrULag3jKE+W1AhODyWHrqxFVkSQfpJZkF7E6PhUJmblShIbELa+vzCZ304CntEtHfLm6xwRAwxDt9Wwp/16IIboy5nYKw1+x3aJKcYI7eDvmWdbZx9IVAoUyCuAGadtCUt2lZTeeajBdvgBahS2n2uT4W9CPLsEkWYkDZBZPEl4yQS4u8s4iqzbFkd+DUVMMcKZ3Onc4Vblu41bmcNATgOWfpNO+iGdtz2ArQKP1oFaJeZFOxzdkDUlsZxvTot+BpdMfyB8phiV2yhLe7pblc9r53DDp1AAADY6HfrA7JcmF/7U90thafMmfrhxtepOSfHFSM8vQewdB70OxG+gry8L2BBfFVRQZ4BFMBBTVobL6JxBsAZdf/y8J1PeSge+l8OWqPXPexIXgVbQhqUE/t4/FUZ0Rsyhfrl/7mzgLgLoNkCB1mkkV5EFsnGsIiLWamWHKhaKr94m6VQL6b/p8coj8mnvWxb/Eo+51jOH9iZcXyMz3Gu/GrE8F8y3d6stH2CnMOUkvdy+hecLwgy98JHQka0C+orJ40fmbLJs+OLgpUmSUSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(346002)(376002)(366004)(39860400002)(451199015)(6486002)(478600001)(36916002)(86362001)(2906002)(38100700002)(6512007)(6666004)(6506007)(26005)(8676002)(66476007)(186003)(5660300002)(66946007)(6862004)(4326008)(41300700001)(66556008)(4744005)(316002)(8936002)(6636002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VOnylAHVqluL7ziCYQaC0t838nVo/MCHK4rqBpNta9dJGYsQ06aRxQ0OSUBV?=
 =?us-ascii?Q?brQIUYrbo4TEjEQKawVf3Fv+U4UbkQHMpTD52dxMgJ1HO7TvpVp+3/NM6/ZW?=
 =?us-ascii?Q?rfWgFYGJ6a04HkfsY6p/CUQex+JYxqEuI0y4nh9PrpXb4lmjtRHNY0OOdXRu?=
 =?us-ascii?Q?3NOU/lLuT7dSLxalen3Dit17iw8+jSrCvoCRDuEn3wKK5Mmu/3BgKo/By2T7?=
 =?us-ascii?Q?QZ3aer5otiarPMRTDJv2yR7IwlEo8mkH9xC6/Ci1/za3jhbzMp9fUdH7y41i?=
 =?us-ascii?Q?DjKbJY5CxV68CZeoBZl61Szsny+s8ffOe1tA7EXb2UYDZMdU1uL/6sjvEcoq?=
 =?us-ascii?Q?C2uo1O2goVIn9h5vsV03X+/d857tXetP7H2LyGo5gwMZHu9pP+teXLgcaSgm?=
 =?us-ascii?Q?WoWIPXcp8mH4O2T/DItCRKowK4t9shfiEgcnLSFrxR68fAvYg9QZrhZw7VhW?=
 =?us-ascii?Q?fbf3a5/7bUDQTNvaMK90+Y8VUOO0vysMIBeg4bG4nX9A+AUVAxDab9tpfuhH?=
 =?us-ascii?Q?7+ByCV0TAe1ET8ONtXTbnJaUOvXIL7+saJwMkvx8H+xYX3htxQLQFGh9sytd?=
 =?us-ascii?Q?4WngBn4q+N9sqKKFzP4qwf8N0nFJ4/PD5rL34NkQE4ZQ37OBo2Ij3oEDphhJ?=
 =?us-ascii?Q?LYXPWFyTElz8t4HB0GSj3lNTSUFzIUVM8iUUAAq8ooOVMzwzRJ57NNjC2CB3?=
 =?us-ascii?Q?WfnQOPYbDVSDZ9Q+3cTaWrfghqzgxUZvi96cvCfO0czLU9YcbQWkqhaV3pDu?=
 =?us-ascii?Q?XBqx+yVI/Plh/q2c9nVQr8F9Z5hrDSSR9Ji64o0e41eW9AgxVHdryEL766nO?=
 =?us-ascii?Q?++fJVFPa8K47+DR56a8DQu1wtRj9TRMVdrXlUI6mlyNmIyY0NHQelITzQmO4?=
 =?us-ascii?Q?SnQvK1ttpDv9CyqccMD9H19jN1CbgYn6dGI7GMSVdnY5oCmP+WwB9C7mPt2D?=
 =?us-ascii?Q?eW6GxdlK5TvMN6AWw1lDW12j01SQQiOpdiNkZ7RMhKVmJNzV7OqBbUr5Ju/j?=
 =?us-ascii?Q?O8gdAYy4uqwKRPW/xR2Ty7LLrKqAlzywq1zJpVgbgxP7ZodFPFt/ZnrfTYiL?=
 =?us-ascii?Q?1Di7vOjoPp4SJt6QaAOlNLCTcIVssFJ0jaUxKDVVkP01H7nuOs8kxeNsC9x7?=
 =?us-ascii?Q?MirtjOWE8qKmCQi/LZ4BBiAMYM0ItCYFCn6q8LaawFQeuGUY+v4yGSPCNZYs?=
 =?us-ascii?Q?o4rndGUdm9APxm+1fFMrAW9aebE2gTexwo5K6/ugyRySkXWETGtjghr0U+Z1?=
 =?us-ascii?Q?0Mr45vhlxvtbom5XfYvrkFyPTPxCI1S1CT8mKII549gt0OB7PT+c/VqRxNjX?=
 =?us-ascii?Q?lKoJJhTeusMEVP3mv0Q2Kldj932Z/s7gKBrwhKpAXKqxHCyRH72R2PEmT1O2?=
 =?us-ascii?Q?xB1NSGpPoQlgSqUlsZNtI4/JQsSrbWuNIiMO3uxlHwBrGe59tvR7ICitt0Pe?=
 =?us-ascii?Q?pjLzlfHDXrx68Q2oRrOvnY8Kop7qfw9OBx5edrgDPfGvM5dmsPZJUQgTUi3f?=
 =?us-ascii?Q?uv2rC0JWok3yBXyAF+wtbJNJteq/6ra/FTVW/aLhB6shRCk5LUr+6/9nSM7y?=
 =?us-ascii?Q?766FP4tchs29eBYx1XhQwuuZ3bOYPgVfiQQ88Cor8KKHKkPOf+dftMpZgJRD?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KKnYUq6AC0EUKGb5p2JhyxOiv1OEpUgMl1CV7uyPg2PXjdH+1JzYVl/D/Q1m0RKOL383aKEw2XfdNVB2PeEMe6tmPSLgSBT9hmifm91S2CFnK9bhz5GKLXD8n400zUdRXjsbOEhMj+Y/RYjX1FG67GRGr/vITf3gi3u3vMstzFG0rvNtTJ5zZDAyahXfE2PpvFyv5WkeO5zlFmwCKaaxBlJi6IUlLxycITchoN90oMWthP+Xw5a4JBciDKboUStCsEoevdv0ECwm7Tc6pp6kxatRpvBuzE2kNc5oMurq+EqaZYTVGwtkG8jjWbJYMzDKVZY2wG/ZoBwk3xVzxkmhUDhsE8Pb5EJ+WzzMRrwz9aSlfdffXu9XbmM/Xrk63VvFqHWC+C1teUWl6noMizcAMYfn+esYknQlghvMm48Ng+OIn6Z3KpusL5aYCy+U+XkXIPEW0S5bjqNeej+qWfWLx4F+7mspz1oedbdCgjCjXZJUeDojAjQHPLbkx5h5mTbz5uBoM/fbqITJrK8Cz6c/zuig6xs7p4QmGBVRrP/GiC0LfwGAxLscZnvzO4kYNoUSLnbNLdaAqUMyyTNgoVYi6ptWTX2Y9wRJaESF1orTFrAps192/Ln3kWidSyxxDPzPaEZhj/sbxSBfab0Cj3ZfXz8nhU9apsPTKzcOThJBMXzE+Mhza6dijCzG+/48gR4E2wOz/WylICbn+R5tYIK8rTsXwuWPuhLwjQpJFPD9XqH47MfSYJGqJ6XoBUuTDPv6CqoHy329197yTTFyc8QW7jGZwT5YUjbbQCV2ExZ3X9SvJs9K4xmtiQggwcCRt/WTH7n1Wkdpeo7BbkhG+wKNuRhK0uXVrDszh1rccXJqasU3ZjHWAJYFGIQqayj4EfYG
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1c1bbce-155c-4506-d0f9-08daf5d8de74
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2023 02:41:42.2472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btAkuzTFSVAyjkOiF0e7JOak70Ev8vOha6PIxGxgfgcBZp9kmIeJG25Sp3Kr/louGmbzNH/5sn4dhaG1xzGHGbNFAFiB9fq4WjbhXUiSKBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_12,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=983 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301140016
X-Proofpoint-GUID: VcK1CMPdw3TUL1RrjjuBbg16RrmvKVX8
X-Proofpoint-ORIG-GUID: VcK1CMPdw3TUL1RrjjuBbg16RrmvKVX8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches were made over Martin's scsi staging/next
> branch.  They add a struct that contains optinal arguments to the
> scsi_execute* functions. This will be needed for the patches that
> allow the scsi passthrough users to control retries because I'm adding
> a new optional argument. I separated the 2 sets to make it easier to
> review and post.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
