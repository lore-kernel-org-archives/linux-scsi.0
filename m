Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF822C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 02:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4681613CF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 02:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243773AbhI2C5d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 22:57:33 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21426 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229771AbhI2C5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 22:57:32 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T0xjTF027787;
        Wed, 29 Sep 2021 02:55:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qHHje9R7DWOmwDVTPy5taRRR/Nhy3qtFg+csT4sTGdk=;
 b=ggfGjPd8T4348Nr9aILUb2CX45OMH3c6ikHiRoXT3dbUXXlpkGhjXOG6lHUfgN3cGzUk
 6GMNt21ZK+PtID5fBuJvOgK+Nx0IPVncwg43WZFR4yUqGTb31d87GkmN48r/7IJVmO1l
 hi3xL2zVuOyAWvZmteMIMurGdH7ciwhiUbMhFkFfV06V/3P/PUPr6Vv6U3W2NarQ0a6Q
 EuQUdYmeXuALVHjrwAy6k2cXHW0HFIYvsaxXtYNnQh9iT48p2Lgt7mL6IdoMtyd9k7CB
 3aKqUTfH2/RcZJg/PhTikzzi0Scwrgg1WW/AF0g4ikUONtKIXz4qbKX/Z++xaahfJzis lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbj90tj0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 02:55:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T2o7pG014487;
        Wed, 29 Sep 2021 02:55:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3020.oracle.com with ESMTP id 3bc3cdh43t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 02:55:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hs2dXHkpzIbzgLSOOtFhnMLcZGTtP2Tk2L6N/JfgAK4peF6xBG0abX02RmqW0uytJnD2w/WwNuEZfCIsWPTi78ssHJ8eFwF0e3jLW7+EgLypeJ2i/Ky8kAQU+7gyDpw3XANWU0OLxEBSAg4l2fj+ycHDhGmvXYhXo3A7U/8ymxDJm0w16+KBUzLKpFeZKieIuDdN6j/gC72+7qRhyuYwfHfWp0a1/5Gcwz2iB8ni8wWYi+C2Lc8zkqE10+XGCJOpc0anOhi4013O+znFQt7euxYzOL4BQa87807tXhZgYsuiCTXa+VV0LSivsw3eAtYrDLAdi51W0+QqNmz/n0cxRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qHHje9R7DWOmwDVTPy5taRRR/Nhy3qtFg+csT4sTGdk=;
 b=fJIeDu4UGFE4jwHABCDdS6DRdrLN8PMvqwIb5wUitxXwBnV9NTNLJaDPpPP+e3qaCpm8W49Xg6SJSsXIxkdR2GXhE1Y31n2PqJAOjNVEmwOoKpCL8rXoqXpXYg4omKRtTZPUfOCfSbUWDAGinEF0JGYsKEYS+MTSLJRfOqlGSfhQRPI+6PqJmKieGMrr+Wo/78j7rttRcg+pdVUt6bc1M2yyAxFGD0CAZ4DOer90FUa+Uj/kp1DCilu/5K+QV3FUkdWM1WRbMVUpJnTdG0v60EBiTkPuyUMViObsEXAu04+w76AFPpZfb30Tl2pJ1eAx6fCozgKLXBz46oTubRVOog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHHje9R7DWOmwDVTPy5taRRR/Nhy3qtFg+csT4sTGdk=;
 b=A0YiPSoRAJ38uCa/sdt9yjGAG8TLoaNGAto1xYSHEb9LxBjoe76IA4qny73ZzXIYMmGULmpzSpEcIcjiLYQVLdxatYkB6g35r6KGqY5J4ISSKSFKQSTbnHjnVpCevz/j11GCphmUhkYg2MBZSdtoJT/kEM+/SyIfdvWeid9Dw7c=
Authentication-Results: gmx.com; dkim=none (message not signed)
 header.d=none;gmx.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4520.namprd10.prod.outlook.com (2603:10b6:510:43::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 02:55:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 02:55:15 +0000
To:     Len Baker <len.baker@gmx.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: advansys: Prefer struct_size over open coded
 arithmetic
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17df0gkfw.fsf@ca-mkp.ca.oracle.com>
References: <20210925114205.11377-1-len.baker@gmx.com>
Date:   Tue, 28 Sep 2021 22:55:12 -0400
In-Reply-To: <20210925114205.11377-1-len.baker@gmx.com> (Len Baker's message
        of "Sat, 25 Sep 2021 13:42:05 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.46) by SJ0PR05CA0057.namprd05.prod.outlook.com (2603:10b6:a03:33f::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.9 via Frontend Transport; Wed, 29 Sep 2021 02:55:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5401e35a-617b-4abf-a3ef-08d982f4902b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4520:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45207E2A553F1FF570462C438EA99@PH0PR10MB4520.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ts29awC6RpHQxkHkJeJvgZJm/FLUKbRLzKwAPyuUKhtQst8gPGtp7b3CfEi971wzRqIdJkrmpsVUIq15KL1tVLsMH+jFl2W5RgIvuedDpKu21ldELgQ4dH3sYSoc+d6VAYzAjZm0dn+dwh2QCPBhPs2zXYVw851np9mEgnrcxA6HW11rZDvjxM62semD1xtCAjUi41Croc3syovVqhzGaFfDsoI7/C7/zfdx/bGJY+FCPoLRbbKAAT7Ajs0GcaZIt7v+7FNnQDGuoj0ECDiv2GGChb7LUxT38fy5HFa97ZSsT/QQFifMcQoEH4bVBEsG9Rd/TVAcUtkNdAH3cPDPIUGm9GvKykDpC5/GASbO2tjTY7NVaRcVR4iqRYUj5E5LltdaLndyHRURBBfGeMYngNGRA3Y7poZyjd2eUpG5zSZ9tlepixxS29ulIsVfF7QgK2QxzPP0WcyelG2HfP/Zxz6s+S9fHI2IWkpGUWoXxJfWmIL/NriAe7pzngXp+aZfbwvoPweX2IP24LpaIYcXP+bG+rRbuWPQLGvgj8Dcu/dGFduC8t9HpSXgWYjFabeb4fmeYPBpo6oeKRExfMgNWZjL26USzagbHDVzL+bETKBMRApc+eQ8xq+5LNqteoOmygmNLVKyL6gBNvELkHXdMr2d4SneU77xdA1MV5eslBjhEyGye+gEeD5Y7GMN3PNug9PuDRycwLLPYLLxuIEY7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(36916002)(5660300002)(4744005)(55016002)(6916009)(8676002)(66556008)(66476007)(52116002)(7696005)(186003)(4326008)(956004)(66946007)(54906003)(8936002)(38350700002)(38100700002)(26005)(83380400001)(508600001)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FLFE871mN/trFFgPgXOeWOY86+4QUQWBgKUKUTdWj99U6vgG0muEJQtsXDIF?=
 =?us-ascii?Q?9IoxbNdTWA/7OHj27a5SlnwhDMObTgWZqOIp7wAw/ASN2X/Rr2xvD1O6jXCG?=
 =?us-ascii?Q?zL2lHGk4pWG4gITjqVpJfCklgNPU6P/5MeMhGDSFgv2t2HejV+yAAcaFilpg?=
 =?us-ascii?Q?L3Ov6x1KYHF8aW2fiheJ3rX/ddZ0/rUwNYlJRO2FKbtc5cm7xk/hOnnzyCBO?=
 =?us-ascii?Q?0VxGFNzWKZdvezdtZyKNy9NF1CivJ9aQ0qA7EQefg/RAZFnExcoqtO/xQKdQ?=
 =?us-ascii?Q?bjXGx40DTHmy/UIqbykrJoGOiazo3f1I8jRjF2po0w/bcV2imn2SIjpwfQsQ?=
 =?us-ascii?Q?yKY3Z8vIkrUIDjC8aPJ7dG6BQFY4A9c86fqm4Sq75gJNZ23mHTfS5/FxzgFG?=
 =?us-ascii?Q?XLbG9qJP6LzM8LJ4spM+NYMKCPx8RkZodmQV5Kx/fdD/Sxu8l4TzSRs31kQS?=
 =?us-ascii?Q?5KUZ3SCfUXY0a7Z7A+AmaEqR+TP2oKYRzKCPz41BclDPs25/EKQ0kHbTgtA/?=
 =?us-ascii?Q?BwdB8C211GSAwbtaEjLWHcgP1YAItKb+eWyvGxllFAgRPXbjuJW9GZzKPdD8?=
 =?us-ascii?Q?77ZAyHT5JUqS1Jy46OFJi6bJC5Fviayz8/uVsVemL0NvnyWe0mkuHd6EXYuF?=
 =?us-ascii?Q?4F3+6NU63d+n9UC19sypEyhLcFrY6iDy64n4TpKi14jiF34JxVk1SP8UEaoH?=
 =?us-ascii?Q?cX9LDqvHzqlTR3dNVzfpEdLWIXw1DbZfnm6bvFfnPt/r+fQZTogjACVunep2?=
 =?us-ascii?Q?Kmd8lmwSChGF/T3Ebc+m4nPIg3pgp8+Rc7aVlP2BtmOMNbhac0PWkBwns2LA?=
 =?us-ascii?Q?tKll9/mcA7he39stU3sL1viJHyrA2nrg04wMKjxFpL9YQCKSgiWWHuOwztma?=
 =?us-ascii?Q?5MPaOwTlveXEG42eoAZCrzhjBfMdZ0kK3ZX/2PtnJ+YI1Y+cw9FBnXVleJhf?=
 =?us-ascii?Q?WREPp+scBoBV17x89uw2WTquhKJUE6R+xEe1+/kdFA+/WwMBVgzjuG+M/Cdr?=
 =?us-ascii?Q?1JL6XS/QY2YPSu+c99Uw+dEtP8LV3YVgmGy9Wj+I3imW9aOX7Pe2S3gx+SWp?=
 =?us-ascii?Q?zhsQANdG5GT6ZvTuBRQvixwrLBsPK0dwhDhzjNH51hIia6Mq4R7HnqFOqsYY?=
 =?us-ascii?Q?iPYk6Odw/hQh+8kFYl+ZSuLs11qpxu2ZgF20cLn6kKYWnsTguX+aROXwHW2k?=
 =?us-ascii?Q?pk0UC/DDt1pmYNh+LCNraEPcAHg4xKyvGzmlB4sIdy37FJkgZlyreyoV7TbD?=
 =?us-ascii?Q?dTM22lx1J6pFHvJKrjN6AS45fax0HpQPG/k+rFeM28LaoyVpP4rpulRgFq+I?=
 =?us-ascii?Q?h8w+R0b/5v0rj6Jg4gdesANq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5401e35a-617b-4abf-a3ef-08d982f4902b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 02:55:15.3081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jOVGto/PovN1/MKutMyJUvgWAmwBA0uwpKFkNt5JvcFI8qbUr4ScUNtZZCtbFiD0sL40h3WpcDqoYiIi5x23yMOh1DR3gtOcvsgvrcwaOQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4520
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=775
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290014
X-Proofpoint-GUID: ygi3cYwggKQ9HK7N3fJveg58Ai1HgSQz
X-Proofpoint-ORIG-GUID: ygi3cYwggKQ9HK7N3fJveg58Ai1HgSQz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Len,

> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or
> similar) function arguments due to the risk of them overflowing. This
> could lead to values wrapping around and a smaller allocation being
> made than the caller was expecting. Using those allocations could lead
> to linear overflows of heap memory and other misbehaviors.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
