Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A354CC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AF4A23B1B
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbhAWDFn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 22:05:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37330 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbhAWDFl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 22:05:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N34ewU122361;
        Sat, 23 Jan 2021 03:04:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/ddBKXQhNggrYnezqjfvFUcLtppvCKsqvM+1bBCkPck=;
 b=lNLWHxwPeFEB8YXH2BHK26CzmdVy491Pa1aZ0vhHT8yoZHGHz9HldGgeRf7BujqR1o9o
 K9vvxU9yBfnQ/+BDe28rI9m8G68LlV6/wVNBbKr6CL7+caduP6rZqktHCe2rf8q33ab2
 y9LuY+cQpOt4cpMYn/zPMVkit5eZB7ZrinrJinJkH+whl8vRsxCwLquCvPngBeKahpUC
 2+Y88SX+/EnnnDxBy0B0FRC/xuLvBD6RQ0cGdar5sZNFieCxFqELatqNe9+qimb6/2m+
 x93De5hVUtVfHIaQ8oV6PRTubZJyGcBRxr/jJ/uWJWozgv5j1niF0dGKN2OvYsCz9SKX LQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3668qn6x5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:04:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N30nC7111065;
        Sat, 23 Jan 2021 03:04:54 GMT
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2051.outbound.protection.outlook.com [104.47.46.51])
        by aserp3030.oracle.com with ESMTP id 3689u8tqgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:04:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSM7+X5jDc8L/ILZl/nmVzPSdVQVMjq9TR7ieGnwaN/87zX4LkYR60sWDCdsK3xAkoecGvmzEAPNYMwVGyDFc0s4tYYfaLtpBAih1waC5lUdyK5uq+XN1a7d/pxklcLrTg4oLqmSmTV8UG/nQ8thA+mRHIqKpvpKCr9cwy6k2R7gd6SH2IZCx1eTw8rkSRqTQNnW5ydnC6iBpxyDHWgkGcP0a2ERJBb9euK5D6K73vD4kDKW4S6w8bWGi9P8BPz8gMwQFwD49VjNdttWRonFkXNa0wS6cj4i9DcgfWaDjEYXwaZ6AYDV9SwjvE+hsLZawrOXczxA7vD9UqiVU/t6DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ddBKXQhNggrYnezqjfvFUcLtppvCKsqvM+1bBCkPck=;
 b=G6lxiS2+odGAJCQz3JlRfsTPGWXFeNAaooMrme0HNBjHsy1+hjZTPqI9RzcSw5MWpSWRAgNqyaXxIBn1mP4wV3XjsIhHFqRNsmryHwWXKTLXbEUqHk6HB/Er128H3GFEP1UIpuc6pzBqa4erwJaKMPdPVUw6D+wKwJ4Nc+dCA9nqTpNMT/+7Us2MyuyLla3pm3jViQtsyO5lPuAz1o3Bl3NDbysqufNaIRKX//MwVzMxNZ/SpvQVRHWBpbKincEaAeDVfqxj+9Q8FoMmQh0ciHIMuUlA9TB1K4BKse99gb1eALp2lqAqtN1v5j4IUSwnNopL7tp5sGG3NVqvwOVafw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ddBKXQhNggrYnezqjfvFUcLtppvCKsqvM+1bBCkPck=;
 b=Uh2jfFHDoTV+oLFdoG82pgdYgpLtIOrPZSkxZgwS3PI2lHQ0wVesh9Z0CHARYD1YmSC0N5mE5rR8JlGAaU/6jsPGptb+QNmcW5Fk7WUCWBzbOcv/qMwrYRzAlXxyz6GsbNanayIPzxirT0FN4DbuASMcaKcnpwz5IxUJTPe4rHM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4776.namprd10.prod.outlook.com (2603:10b6:510:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Sat, 23 Jan
 2021 03:04:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 03:04:51 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: remove unnecessary NULL check
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <YAkaaSrhn1mFqyHy@mwanda> (Dan Carpenter's message of "Thu, 21
        Jan 2021 09:08:41 +0300")
Organization: Oracle Corporation
Message-ID: <yq1zh109wwc.fsf@ca-mkp.ca.oracle.com>
References: <YAkaaSrhn1mFqyHy@mwanda>
Date:   Fri, 22 Jan 2021 22:04:49 -0500
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0154.namprd03.prod.outlook.com
 (2603:10b6:a03:338::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0154.namprd03.prod.outlook.com (2603:10b6:a03:338::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Sat, 23 Jan 2021 03:04:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d9ef9d0-5f4d-49da-8aec-08d8bf4ba69f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4776:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB477670E3C5E52A444968973D8EBF9@PH0PR10MB4776.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RY0wSYNEsA7vGzK1sKCAUaAsG+ba3gPQ0h6b7PFexsDc6owYoXC8fPpBaaBgaIyscWBBGVBtx69/9nb7hZdER25zyas340POjeKcaA8aa8CJaNFyNxPFRXg2ZakVszxqQvxZQDPY39XzqnAyNFX+vmz3BlxHci6lavs1C3w3cK+FMB0y2mCadFHN+AfBvVR/TEQNqDGNY/VHnPmCfcRiD82Cuh3+U2b30dqQF3qS+4cWofHMJaWEcKuQGr1f8HabSngkSJuGKU13deLnsvEIXJ6LkUVIcXfekO8Xu8iOUpsWQQ5mGIdl+jal4tzIae3A5DmlHhasmJGAlHqqum+qPWd6WxkYKHxjDuk5gdkkeOGIogY1muHJ83uHgQw3x5LsdMGzec+ocWkcoxeo2kP6hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(366004)(396003)(376002)(8676002)(36916002)(66946007)(8936002)(86362001)(4326008)(478600001)(54906003)(52116002)(7696005)(2906002)(186003)(4744005)(83380400001)(66476007)(5660300002)(26005)(66556008)(16526019)(316002)(956004)(6862004)(6636002)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gqr5KpULx9pX3sMTFgav0TorUlz1HI8Pp1iVvhdSokcjJWaKHPz2Xnxoueu8?=
 =?us-ascii?Q?nnvv6AiNiAsTwHDNUR+AHq3ahzD9jQX+sVRxQe4HIkYH2UpREOsCdi8H03OH?=
 =?us-ascii?Q?w5wD3jhWT8oRNPl+oKlEd/JOiqGEl5WjsYhZ1PKU9XEgPHioDMIPz4YhrdHr?=
 =?us-ascii?Q?wsMQRNX/C2SfWtT8eXjPFP4TaHiFGiVtRXp+ZZv7s0Ej42tAy7ISCBP6B54e?=
 =?us-ascii?Q?ec2w9zCHjCwNwUWFqx8S02TTFf97fsTNGqBYOmNVJuCsfp8CNL9ekSbAvJtw?=
 =?us-ascii?Q?EoKQJpuX3PO9fq4sP4+u7/1oqnEhpvbjUHstuc8rqyK1n5Uq+CAvPb03rRHe?=
 =?us-ascii?Q?ZzUEc0laoutCN4Gq2E4ewlIFrzpvyAWGKD0WXlPb/rU3QBTNiB6442f8V4Il?=
 =?us-ascii?Q?r41x8O1BqH4LfnOBRt/Qx5azxcRSq+TeMrt8WNO3xw3qryngS9a/y2j7VLxR?=
 =?us-ascii?Q?SR86iucc/V36RQL4fBSF6KfgM2jQbwr9oHwxlOhkPGX/JRt12v2ko/3B6uXk?=
 =?us-ascii?Q?ep6sxE+InoGjknIcfIx7joxhN36wfGDWPVl3sndSh4wxBJeEtX7AN6O6iEul?=
 =?us-ascii?Q?GbWE5f359u9SYofjpeMERjXGBCXnCPh/L4TJOufSof3eGTmIkEYf2A1Lgeyw?=
 =?us-ascii?Q?j11tAXg5jmkN0r+FesBi2xTUfl9/whAnbJjcXRsZjH3I1KnEdAFgRQOmdZ90?=
 =?us-ascii?Q?UzwWKhh0ubmxz83rfIxwdC3gw0xnp43fUl6DzEuUXSZ76HzS7cBOY6Klb/02?=
 =?us-ascii?Q?g9Nw9JTt9NjxuMfW7ooxkPCcQc8hcWQs1jM3ZGymH2yXxpeNuNZIlNUWlZq/?=
 =?us-ascii?Q?q99a8DeIjPVqCByUVbfijS+dIbe6smoArVEpaQ/DXF/SQnnvEib1Z90yZPVG?=
 =?us-ascii?Q?26jcqU/vNwRkBVTTUvwweaN6iiPRdpN8tW1U/2GTUYGCHs2PCVAA0kz4VDa5?=
 =?us-ascii?Q?98nkO/0IyVad6k6BmStJ7TfBUTKNG/jCJRB9Lq8NvC67/86IBF5Ik5Pfra3F?=
 =?us-ascii?Q?phSJ083njEyyUY/fSpQxMHw/WVFVtFrfHW3QQ+pBZz9d4rMmraOEOoCNt4un?=
 =?us-ascii?Q?EYVHlwOu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d9ef9d0-5f4d-49da-8aec-08d8bf4ba69f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 03:04:51.2836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v+TdGnC0jZh6tib6BInNBprmYtqLCdXH0xNjCwQlzGnUHXIogxCpxdOYwjFr3XeR5JrAJNZSB1vfOKRqv4DfFlyQrUFtEbZYkwbnz+5f+gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4776
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> The list iterator can't be NULL so this check is not required.  Removing
> the check silences a Smatch warning about inconsistent NULL checking.
>
>     drivers/scsi/qla2xxx/qla_dfs.c:371 qla_dfs_tgt_counters_show()
>     error: we previously assumed 'fcport' could be null (see line 372)

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
