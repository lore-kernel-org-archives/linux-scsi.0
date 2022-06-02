Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62E2C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 02:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiFBCtl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 22:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiFBCtj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 22:49:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58243227358
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jun 2022 19:49:37 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251NXnKV021718;
        Thu, 2 Jun 2022 02:49:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=HwJpiKLmqNDaWO0DfY+UyU6cQT8wqSE92xyKGbWe6Ak=;
 b=oCYefBd5kPu0wc0+QdNYDQm+MRAiYvnh+BLhr0VqCVsRV45WAyI1FBF3pDM8uqx3ICKN
 cnt+LSWb3+QL/zH+8Hgf8oVtW/BMVYxYHMxBT+U9ayvlamfdkknl67f0OO433C/kGX4o
 a2JDp8g0A27Kfc1YdPwG4VoxeKZrYa8qaIAJsS8JtrJHw5/Rzaj79rkpsOo63eOphIvc
 I2VzeZZYvcUepzZZh45mg/xlPemkjymHQSZo5qWjmflBA3QA69WAxxZBrumqd3sdPu2D
 dCZAN6FJ/jJ43uh2LpBISpiNab+BZY2RxbQM7yAbe7v6D/gUzGACizDhp88V+1CxQVt/ WQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc6x99pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 02:49:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2522dn9o031894;
        Thu, 2 Jun 2022 02:49:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8khmpx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 02:49:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KercE8qO87t4t2rKM0htApD7Pwyz7xPzubntoO5XaobeXZwA1qEPL6QfKiDHsz5skapzvjaite+YehTYvK3tg/8Sgh7HjZIU/s7Uo3GsOCDCwAklbH0JSeM5Nw+l6xcUG3s3uNFtjOp73Gr0VLMiOiAyMiOOvyEMznuB2ChC+H82mKxaaXGvwvuhZ7XOgFPFMZKE73oF6fn9LezNNZqchuhxoC7ZVdQ+J0Iwx3/LJ8rBp8f1GLnKzbt7LMcPXkFwma2jA6ibZgVbLkb9jeqXb6mO5F7sxFTki0G+yLTUCsA77tMddNhcO0yGP9dVo5mCwMvomYW2hoo0WszWymYtCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HwJpiKLmqNDaWO0DfY+UyU6cQT8wqSE92xyKGbWe6Ak=;
 b=mPg6I49mMpHLmT9DgbC5ZItw7ObW0qQ9LXauXufn79K/SSYyi7DWokgWxrOAFQXCTYwkNW19lA7hkAIgyQwLrEIen6ZrQmy4lSNUKOHQLv2fP5w71iWVfOAHVAadW/wPpOgw2N83p3W4c8EVdOL62WitkPLDT8U2weJbhaGNv0N3Ho1ApqiVRQDnDtC2e00XZHf6XnTwjK0UwSMLwcTUpZpS7WtSIlV8P34yi/U6Z9LmHYoiW3n0EIfMfQqRuIZ3VjyLZS89QcYKyxdf2NbNT/DpdshXtHeYC2bwWdLyJMgVgkZm8Xt23clM5CGK5E6XsLlq+Wlhb1XxkdYs4//WYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwJpiKLmqNDaWO0DfY+UyU6cQT8wqSE92xyKGbWe6Ak=;
 b=Sbo6xeoU2rKT6wFelqMNsPy3eIDCCyUKkRVDmUeMUgVOp4YxYUdW6TDSXwAIZ1ZQyZw/N+Vl3SqkP/cq8myuB74NXgCULBGrpadbZtiXGiJxYMzU08nx4Rnfh8SoG8/1cUdkOEuKq7cGRcNknHU2fAiLqA9oWEbAe29Y1m28Z+4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB6104.namprd10.prod.outlook.com (2603:10b6:8:c7::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Thu, 2 Jun 2022 02:49:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 02:49:10 +0000
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
Cc:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] qla2xxx: Remove unused ql_dm_tgt_ex_pct parameter
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1474w6d.fsf@ca-mkp.ca.oracle.com>
References: <AM9PR10MB41185ADE95B92B4E6926BE639DD49@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
        <5ED96E4A-08F0-449A-8A9E-034BCFF1C993@oracle.com>
        <AM9PR10MB411874ABB2FF82B263EDD89C9DD69@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
        <06B14F66-F736-4A12-9D47-6AA4A8920DDA@oracle.com>
        <AM9PR10MB41181FDAF10299549765FB1C9DD69@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
Date:   Wed, 01 Jun 2022 22:49:07 -0400
In-Reply-To: <AM9PR10MB41181FDAF10299549765FB1C9DD69@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
        (Chesnokov Gleb's message of "Wed, 25 May 2022 15:41:51 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb0898bf-3506-4009-6073-08da444277f6
X-MS-TrafficTypeDiagnostic: DS0PR10MB6104:EE_
X-Microsoft-Antispam-PRVS: <DS0PR10MB6104AC9AA55834BE6429EEFC8EDE9@DS0PR10MB6104.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: am1234ci9VT7eg9zpNInJ3vfygcxNM+o8aa5n/+ocEoaP3yM8vKAk0I9ky6CamVfw6KjCbaMVLBH1ku4J9GC5vTIGzu9p9va396A0OVhwGN3SeTMLcCOYs2jt8pyr/ZyLcO7sFO1Uli2SWkmNc6H3ww40N2yJ3YKOnA+qWr3D3csNiTyAydtvsNck1Fm2yzeLvSCAgkZy8o3McHUjjKkhJiPvP64wlTAIzvlw7G6wK4JwSfzhk8S1TLxNAnH4EfF3lOQ9I5Hw2h8RZ1G2uuhuHEmxtSXtdykPg5GaT1U0+8TwzLlP8IeYV+E50dS1lGtsErX148BNsF/CYZ7M0u22XVM3MlnwGhrl+A9a0Thq0IExxFZ0NhnR66WUvsxKH2ajEMYEJeQKsFYB+XfZbvvr3Ef403vYPbuqOav/mx7tHwTIRm3JLExhLpgvynt7hVry/nGt+9BmrUzngaqNuw6xaZaCeJtmhTiE3A1BlV2C7FaJgsSCaqkmmOfGaBu0e0LBsgUIb643qycSzMIIbHT6uFKi0K1VqJL3ZpxCn96MWRWlGnqA48Iw71fw77htHkGS3E/ihwgjviuBqXrz4L85fB/YY55jW4t9Nj9rCYu9DZW5lhNmVgtr2iP5h6zkttZXoZyois6nk6uUyuhQ17WBRR6CwlLZuAuuXA6ym+9suvhgkxyUwP9U1eOIY0c0/qOhuvYmEbpTq+MjnBLrFBwDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(66476007)(66556008)(38350700002)(316002)(66946007)(36916002)(52116002)(8676002)(4326008)(6506007)(6486002)(2906002)(508600001)(8936002)(6666004)(186003)(26005)(6512007)(86362001)(5660300002)(6916009)(54906003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tkVmskkz/Lab5kGa7VURWwCRbZQXeVEBRIIVAUZeUnW1dJbuZ573hmjnwK9O?=
 =?us-ascii?Q?8nbIibE+/CS3McKWCJGQ1igAM70atbmui0JUuD+9V9UuK1WfYFo56rvT+mwf?=
 =?us-ascii?Q?uEzTI58s6T5jTcfOsVR/EChCZY8UVjILPtCiByxhJmvFymPdpmGkaTP1NXUM?=
 =?us-ascii?Q?GqWyg5Zpbg1UaSSQF7fFgB+FHW1HQMOvKdcBXAegaORggp29hIyfNoR+9d6H?=
 =?us-ascii?Q?sGZcqsUDcQwEJ7xIftGnliR0RmlMrp8yCl+mVotmK3Fqsiq022UHOircPhMt?=
 =?us-ascii?Q?VyjUpeKeeC5KJoc2Uevc8rO22adFRc3N1dBrS8ooRZlmo+jodQ6SxPr9GYbj?=
 =?us-ascii?Q?1nCEQ6u6hwKRA0e2z4F5aXNw3m7vGhDJgHbYDJC3F9NK6G+pAuMdiqPBD0Tm?=
 =?us-ascii?Q?iXYGlvZsXrABkky0fuSpTFfWEirr0LZrtS/ZAu04wd+9j+XrBi6o7nDmxhCM?=
 =?us-ascii?Q?fEEDA8rTfS51wOrip1WYkWdGFBZpOTHLl6+0B5yLpu9gX2kajwON+BJO1q5N?=
 =?us-ascii?Q?rvZE8ZNQRVQqI8VYMRx2GkOR4xZpYup6ZadiGbqapjisBG+tR0bxTeb1M21I?=
 =?us-ascii?Q?cb7wisa8kyZXsaA7z5AuG9yfy5sfGjD6ryFmQECvGkVo/x+JY9cifoj89g2t?=
 =?us-ascii?Q?dmnW6LByLy3tfKuIsMjzhOhvHpgbMki8jaU3xXDI5jCNUYb1KCk1wUxXyw2f?=
 =?us-ascii?Q?BAS0FihI+5E3vuDzwIV0C0eAYMNja0CCTikzJvRU1pHHaajDUKAXroB5TKq9?=
 =?us-ascii?Q?0G1IA6VMwWG0lE/MCLXzOfGeOq5QIUUshVWDmjXq2AoCkqJGgBaBMzy25LHQ?=
 =?us-ascii?Q?VeojA4PmIgI29h/B8wxoGhk5Xp9YrCaNnIOPtJSha+uk4kQnc3L+zY/pk68l?=
 =?us-ascii?Q?5ozhWq4hc7+5GkKD2w1J9aTwU1hT04e868gJl3waWqNTVCST12E/YjFH2E50?=
 =?us-ascii?Q?DyC/fUUtFZGFuYZHdDVNrjybYV/Wbbmiv4pJIXP6FSvpnZid2BIaoeWTPYrQ?=
 =?us-ascii?Q?lZ2cDOgAa3IdUeCwjjBDGjjn/GtlvSUBpMOW7eveUWAQCaa3k7b1CL2UWe5U?=
 =?us-ascii?Q?fhXLWVM8JAu1kNeQj6fiqT673WX09kvHX50bbZ1K2TJj/d1bVSS6UZypHQdP?=
 =?us-ascii?Q?TMpp5eLoTl451tSsWr9+wVlWxaDEz44EHj6wSWVFAs1NgfWAXGi16iZh7rPU?=
 =?us-ascii?Q?YvqlQlu3M0nS3qZl2iSh8ualg+6k6TpXZo+sVugTnMB+VDHB1pNJmNJerug6?=
 =?us-ascii?Q?3IzMoicZI23FayXAnhlPnXkYOhKBO9sIfSkhTXPvTmkCjErfVt1TT3p4mM8n?=
 =?us-ascii?Q?rLtJRx5iJqPbGeWae/XnCkSyeo29HhiTLLyy56P2ExnIlIniEVsS7f1SdSbn?=
 =?us-ascii?Q?xEHbitRjy2b0m5VyukIqwP+vGMtlXsRiAnrr2sgcCPXZW5vHOAlIJyiJdi7e?=
 =?us-ascii?Q?l/uX9spDOV1ZnehA2yp6FKrkDfxa207BZxTEJ58Um/NsRuWSRKGT0ctDzQbt?=
 =?us-ascii?Q?QRHX1ICKROt/hcKDnVQBJzY8ceG9Y2PjqhTJh8teCoiUIhCzZUj/sAdLYk51?=
 =?us-ascii?Q?2rw4rl9GtROe9OeMzH2QXAEklXttk3ZtfTT3hMGSLzJsMC8w7gLhk5i4Ul9r?=
 =?us-ascii?Q?g62bdNZkdJ9LfaIwt/6SkRtEyN3Cg0RdICDpczGr+stbb+Rf8LyYz9EvoGk4?=
 =?us-ascii?Q?XHvLTy4fI392WgM66Gtv/t7HPLxFPm10NmmuSdhQqU1n1/ColVpfrwkQYDKY?=
 =?us-ascii?Q?pgYQlc583HTUEiaKBwFvBNpdEI4CbR4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb0898bf-3506-4009-6073-08da444277f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 02:49:09.9073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: prQhi4rPab98wni6kD8NPM3pgb4n6hldX29yui0j8RqReKLSZobA97fzTb6THsCgt9SBoUHbEcMUo4GLooCHteZEV/OTR6Ikd/5isWChuEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6104
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-01_09:2022-06-01,2022-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=814 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206020011
X-Proofpoint-GUID: s9gaWQmF_hrvjax9I60lDI0-ziq8pCn7
X-Proofpoint-ORIG-GUID: s9gaWQmF_hrvjax9I60lDI0-ziq8pCn7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chesnokov,

> The ql_dm_tgt_ex_pct parameter was introduced in commit ead038556f64
> ("qla2xxx: Add Dual mode support in the driver"). Then the use of this
> parameter was dropped in commit 99e1b683c4be ("scsi: qla2xxx: Add
> ql2xiniexchg parameter").

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
