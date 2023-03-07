Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75837C64EC4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 03:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjCGDEc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 22:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCGDE2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 22:04:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC2E4ECFB
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 19:04:27 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327006kw030808;
        Tue, 7 Mar 2023 03:04:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=VJBjE4bypM/DhNt8hvF8Xgh4zFK93LmlJqzBOtlmwwM=;
 b=akbWEg4zg8sEg5K3usZQ8Gg3kaNkCfLf28nP5OtssUjVbqhydWYqlaCos8/unsk6WrOJ
 iiAjkcLIej2OB6NTt/P/gLFUCsosnvO1Y4tfzZJVDiyvFlwTRxwsqoD+4ISqN1uFO76e
 2ZBJQcGM5nw9VwS8nzM0NT3tiNm402oEuNPZNV82geKiKEzfKzUP1IH4SpxzUyhicvyC
 z0ouL6zl15dSdGqBNmblx9gyioDa9cHkej1T8QqtK+mQxEGsV0Ba7HpPh6IilSVjWoH6
 d4J8Ay2zTmfzcKDnePSg5cJnrzx5YaJUp2RSA9plvwHB3VFnUVYLK3BvA7MFrnjrIaTV Hw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418xvha2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 03:04:24 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3271KFuL023592;
        Tue, 7 Mar 2023 03:04:23 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u05mgmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 03:04:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOxp3aJHCt7Cu1IzQVjFOaXVRvkd3IqnwfEI4hJUXnzU9MN2Kg6etiNqyy9E/GCcHBkbqKucBmY8vgCfs67MBNWsI0K+79HYSyNzzT0H1lVfp4IxUkFwWuo70+nv9O3wLqos3pNYrfKqStzQuHqwlDBUvO22SlOmmbyFlgjjF1FByRkOxE5MyZfRnHidP5bbbd7/hxdqtHaHhZvrr8NnjZoaggVoTp1qPb/NiZikq/Pj2TXEAzhzfIxCZ6icbXqlm1YZx373BnB1z56p7/pfFnS6Q/K1HpM5rlxDbqubPJbnPzhMe4r6NLVw0CODmRoW7vCetaKQUsHBIZDY9gaMyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJBjE4bypM/DhNt8hvF8Xgh4zFK93LmlJqzBOtlmwwM=;
 b=E/wf+JUs+iKRKtP/b32dtyHd6LpnroQoqfhAXOXnLghgTRg0YN468EymhjbsAwEngYgxooEYB327IEeprGQ/r0dpx+fO9OcIbnVXaLOryKEqmDRomoYpSDJQYkvcdyUyP3erYRKdlqrkSZuWCTckk70pOobkzc2l1gYd1QHgz+Otz51FBhP7ymCmJLojrYR8Py12Rq/OTsetSrtONxLJjEoSFkpy2+pEfzRuj4AyrAWaVunjMjzldjxRiGzLTdfWll0fXmeP29MuLQ4FuaL3LQfK3u3LlpIDqJT0FksJCDhUDDyp6ukJLndGx9rUbklF1jJ7/KH6IsuISuiXjjNe5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJBjE4bypM/DhNt8hvF8Xgh4zFK93LmlJqzBOtlmwwM=;
 b=RpzTQh6Ft8CncQwJMOYRL4mB1ojKmgdueIt28BcesPvAMgedTpHvVfTD9jfCVeT6yQhVV3rSusszz47qkKRq74AXn//6YcGrY3zUhfjFNGi7/it8kOPxO9ncuk5YliLJBK848WczAoTOUp+b1lQRm0XZI/Lp0V0hfuYGyAulv4M=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB6564.namprd10.prod.outlook.com (2603:10b6:930:58::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 03:04:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 03:04:21 +0000
To:     Justin Tee <justintee8345@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 00/10] lpfc: Update lpfc to revision 14.2.0.11
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cz5ll0t3.fsf@ca-mkp.ca.oracle.com>
References: <20230301231626.9621-1-justintee8345@gmail.com>
Date:   Mon, 06 Mar 2023 22:04:18 -0500
In-Reply-To: <20230301231626.9621-1-justintee8345@gmail.com> (Justin Tee's
        message of "Wed, 1 Mar 2023 15:16:16 -0800")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0101.namprd05.prod.outlook.com
 (2603:10b6:8:56::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB6564:EE_
X-MS-Office365-Filtering-Correlation-Id: bcda5415-b55b-44b3-77f7-08db1eb8a604
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g70CMo+QL97bsrLpXWfEb0UKuyUPFe+3dD9/JGBl+7SsQwJmYimUFFQHL4ZXyNyD9WE8UhgzO2UiIzRiyN+W5zQs4n74oprP9gpubfvhf/Ecjr3A82t+e4ueasN+ncdp+7SnAsILukEScy8ywTT1Pc+uT6SUuSKl+NOPiPMSyG7ZI5uSQMQcoQKNvOEZu7PblI1/HqKxyxMwz9LWY67GdlAo5mkfS/7C8Vzq626b4ub65rYO7W2a7c2kyxgwVGL+d9XbwLQM7y/bo1gCxW+oBZMJDSPjEJSg2gyU2Z84WTgwxKaRaXRmREASUIoKPu7UvfL9NaGCQUzB8/bi2IxPx9ISzQIPtyZBaJfnXc/VNqP64zghbnxskRZE79T7HKSmMNjWFAvuAgUeAg4pQxdJBELIvQsAVnPVK5TlpLHOdvieKrKcdlOssjFrerTaUcLBfRlTD46Y+zlh04cWkW33yWRfAm5vrvPYEuvtUHj7r+gi87PvoPNJsDwiLtzZ6n4o90zVHyzJYUrNGs2BVmTywCzmb0e9SbV0rLFGFpIPl4GpM172bCrF17EX9nMe3NPjHGn7KLi59VOU2NXu/djKS1mdZg/ETzt2Ev4NoydWvVeXDWuCpxBJlykXOeUAIUQJnfcCdxjWVaL7NL9FKfr8tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(376002)(366004)(396003)(136003)(451199018)(36916002)(26005)(186003)(6512007)(558084003)(478600001)(6666004)(6486002)(83380400001)(316002)(6506007)(66556008)(66476007)(66946007)(4326008)(6916009)(41300700001)(8936002)(15650500001)(8676002)(5660300002)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P4jSjr4INYAOi0Y41RSbL/mTPHbv4dMGHoyQdmYGveaWIrFy2uEeoyVkVLCw?=
 =?us-ascii?Q?GlUm4sDQNUPSVzN/5S0DNivY4Ql1JGSHrRxOXNK8YI8MthtqpJDt4hkVCVhA?=
 =?us-ascii?Q?1xJ4CfvDR7+cnLIBc8k3OJLn2cXJ508Zol+LGhS5FuU0OGe3J8g2dyz5LBk2?=
 =?us-ascii?Q?DlbeWOO41yW0EfVUa1yh4zTz7ebARQXrmAXtN9KYE/EG1l5ZURbguWZkLHWL?=
 =?us-ascii?Q?QAvzp4YwdKasXf3/ms1Tv6dICELco5/K43MlhQEVMOhcj9RghZP2MM6dMekN?=
 =?us-ascii?Q?qfBedHDB4GOFGSGigfP7zNo9M7WhkRwwCpOHmkeJtxuUziRfTRqqzzw+/OLF?=
 =?us-ascii?Q?OtuF/+Y2bg/aHislGxRn5eXZKM5uS60eeFEDQ9qHNwZXcLEQrfqzYlxhNYt1?=
 =?us-ascii?Q?g5wPPsyF8B+yvLZpa+2yImu+5CCz3MKBVErB3WX1tHJg0beDHBqakY3W8a6g?=
 =?us-ascii?Q?JueQIowrLHPH+pGF6KJxX8nofKinrfKpkih0R5GyQET35000swxC7FSI5fy0?=
 =?us-ascii?Q?HWQ16tE2SV8bnxLXyVZ7FhSeuXVKIrQssoITu4YT4V4/PjoZB5UQG550QH3U?=
 =?us-ascii?Q?VJ04NBrl1MpRIDNKK1LCyQTgH8rsPupkV6GzKdwwFTf/0nUKM/Dz9cMP7VKf?=
 =?us-ascii?Q?Ntk0/lK1Hs2D63GIUvr+vc4cVkh8zS0u1u3MjY5B91tMq12APP7VUi1KZLf0?=
 =?us-ascii?Q?1LUXyx13G5IR9gWsc5PBfc7+cpYkOsExKe/njU15NRiQhGzfmQByNExyo9+u?=
 =?us-ascii?Q?k++INl0g6GRdm6Dq3iaZhBHnoD2MUwZIiywY2u4LhTE6oQhsMvEuoRkd3aiZ?=
 =?us-ascii?Q?DeyJlp9jFnPzbHPemWXwn31KARkC7SjeIqSa6klKK6vLF0spcn9MYG8iT6E5?=
 =?us-ascii?Q?7UIJYO1HBslBBz6XZ11iz2SuXPiucALaWe7BWu3EunCRnvw+jXnUhtB8Rcag?=
 =?us-ascii?Q?GH01a57jTkDiHYQOTkqqw7ruD2IUQPoX37ofSd17o9AyDpIFtzq94yYbJ5YY?=
 =?us-ascii?Q?ePwEIW1RGsZ5LgFG23mBlyCubGAGDls9AS5c9D8eEz2d5kOcIdkm3H/EOuxo?=
 =?us-ascii?Q?037NX/Pa9TIpyRgVfc5yudKLPkkMgBzOo8Rp9+pCN5wX5gX1bJzfxHPCmnfS?=
 =?us-ascii?Q?YcSjopOaMf/9WScZhC0MmVAdxIV/id2lxc0nfmyc3KPDqSQuF2VMMTtqHTur?=
 =?us-ascii?Q?V3VOYwzG7jryDUVEOUJ0K2Oo0TOi0yDjBZn1ZDghoJn7ItIb224qFf3mfEuk?=
 =?us-ascii?Q?N0+Ax3iKDlCzm01Nh/1kuAwcoh6Hy7n1x+dOlhmFTSJ6a7CVahkGwKkE/bbK?=
 =?us-ascii?Q?EfaH8aepHgV9My7WRsn6Tdys7n43WfpkAh1UJ0a/qaFMNiZ+cPzemmNrOjWv?=
 =?us-ascii?Q?Wh23kz6SaDvBESuv9TooB5Uzbz/rvtwHIQVAiyvVwd/cEV/ThC49afBHnZVh?=
 =?us-ascii?Q?CZzao+/IgX73EkC8M2zrIWIvlDSqv820jgXY5p7fSuXnLDPehJtZ9dgCcwBs?=
 =?us-ascii?Q?vA9C7m5IwEsczrzhEMxIxNiYtD1FWCbtBDUSeiT9nbDd9pWW0slT2wOQNoxG?=
 =?us-ascii?Q?Po3q+7pKjglZ2kYGGVzMsJx1Nu4ev/gu2qUhOKV2rmax577ppbxRhP8NySvA?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KhLp15i1jQKN+JPcSM9DuwL99NBy/yCC/j3zOo/u+aSMXGrWgqJnmrtcmivFlgVgruDVaOkjYbY/9I/qyRfg0Dkgrhdplg+sDYWCYD2Qc9zAbbVhpsGy45xvCwyMG/NmQXg+8Ym+N2B3p838ymqQXLb0Efs6CJeirIvyJuFDUY10jIDGgLDZAI9NLaeIibH0rvgerS2UlzV/zW/Z2bu00i4yX4jDww6lheeLrjLdUNfYuOSHQ0SOZ6wjAK2r7AZzpafNcrMKS8JJHz60mXAWqXJduBF4Ti4lt5ioiJuSDG3B8avCDh9euZ3SuhtUWGD1VY+SbQQJKJz8bV26MSqYcoUcBHPb2BcKLh1+y/C+wQsbBtcm+kPn5llFzwm1vHQU1c6hft+8IYlSa9gsBd2DdY+dzcR0HTzuQ+vCe5EFnyZQWj11O56xPsYMuGhfPSxDYGevyeC6DmM9qDZD+jPp0IJykqV7J6M/xTHLj3OCW2MK/PDNwG0jJ49KschTzJSXPUG93WPlLtX7RWyejnywqB8m1SKPFPGq2mWab0y1S0+Q742D0ORrOa+coh5BxUBpqnlDImR34DTZZgDiQgZUNmYvp8T7mFrqJDOiHjzu8eQPVRhhsvjvaolqXtv9/OYOegCG0vIT4TqZoZEKmxkhj/NneAKYUgHmCchSyY2Y+rJc+fEJ1SAzGiutGWDsBznzNDpXdn63n3P0Qs9oY5srLbUucamwlomCUa7dlENFLzQF+EwwC2UmWwmJgRbzDoNxOCUtrQmnIyepUnjnQNy1lzfgr+dJjVutEp3/q9sLyfYd3OAR67+g4zUNlmK41xV0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcda5415-b55b-44b3-77f7-08db1eb8a604
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 03:04:21.2589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z6FVgj/Xq4joExUOVSLAPKUmMDtLlWPQMwnh7Qsp0TnzmTo9K3wR43byECNCQZTcN5TQ0AuYnqzIW75cr69dNAXV+F9ZPvhB2VSmpx2T+jg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6564
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=611
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070026
X-Proofpoint-GUID: 7l-SZIdS6iM1satWrMDDk8uKCf_Je1Bw
X-Proofpoint-ORIG-GUID: 7l-SZIdS6iM1satWrMDDk8uKCf_Je1Bw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Justin,

> Update lpfc to revision 14.2.0.11

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
