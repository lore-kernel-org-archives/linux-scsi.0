Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5DC2C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 03:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57CD42311B
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 03:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbhAMD4i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 22:56:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54116 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbhAMD4i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 22:56:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D3tsPQ129427;
        Wed, 13 Jan 2021 03:55:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zGbtn+Qpj0vb7Gronh8ACqx5r/LxImUK0EFWfpAKwmQ=;
 b=exzHXhFwvBnBeCQWnexRjaKyvhWuaRkdmyOrF7PZiVJMdFm6ySdluCI8kQwydSVhJCKs
 TnUuR7DE6i3JXLYMvyVnu3A5hTjYrdjB6Vb1m4adRAmu4pkqz7ugphbPtX5FLo/yYlJs
 dH4/JVIEcSIAjUg3LKwLAKfuzb5jGFJdM52+oKKoA7MUtE5cTAC9sQsY/l1r5V2so+Dn
 SESH/PzXS17bSqz5ex+PtmF8ECyre7ANVejHu+mjllTCDmQkjx+6P+GAnE17Ge0/111N
 9J4WbXBCFpOrS8yEFX+5xoWVdkHi0s15UUKNiHOmoG96SVX/wjRAUEtOzsOqJblwARdD Pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 360kvk1cda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 03:55:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D3tdGR135544;
        Wed, 13 Jan 2021 03:55:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by aserp3020.oracle.com with ESMTP id 360ke7menq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 03:55:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzl1/678nZqh96C+NYwoNrlHz7tMmtuh0QyCPZ28bqvsgKWtXq0H2O91dcWodbJOGyXMcgZnSpW8WGE1EtP2EshJC5ZK1/V98a7uFm6Blk7fXSgkFlkBtY6Rt6NxSlRKi7pAmjT8rpWYykhgqsoMEI4Vj9BGgTb6muodBzO2OjTWvaZaPOo30gMrCeBWnIyHrs27UyN+LHu7ia+a+PUgCRxk93vPqBOz7AB5QwCv1z8RAks3VlIPtlAIXuwbbltcXwM1ZDdi/R1hHF+kdHRFfUeNoEDxAKqsq2ED1AiKG5QOLmZ4F6GndNevYmU/6eLIuh1R9krIB4XMPsA+pEj1EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGbtn+Qpj0vb7Gronh8ACqx5r/LxImUK0EFWfpAKwmQ=;
 b=iOX60zTcIWqonrJOknSsKZMDG0ZFQS4ws7x4o1dvZmOSBv/ZgStPbFAeSGEZvEp7UcbYCxDOTf8C8v6zTPUD7Ljb7aOkLdB7gUE7K7Ky6Pt9b48aHNiPkLJwzW1c4W6Cl+2JPNDeEQ0mp8eRR2dKSFpiPa21sosVioY3ylzv8Gveu9e2NTyK6+xMx0pyv3B2rY4S7ce9UM0RaYEiGnSRL8nMe/NtGYJc/JPGl1o+xo0W4s29ZvTKJ8udU/mj1hf4f+pqlPnbhw2NkieyX1U6gAoWhRKYrdksFEUEofS8M20N7BALqHVCku3ZIdrMpvTME0hRD8GeKB1ZBvtEjSL9YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGbtn+Qpj0vb7Gronh8ACqx5r/LxImUK0EFWfpAKwmQ=;
 b=fwCVCQvJPWrysvtMw7lla63dZtUPZHKGKB9sNHaATXw1lp7TFB+3T29WmRCpXyCZ0yhkEnMwZtsU3/mJagVHIcWXxbeVnj+M+M1XrxixNaXgZDRZybHlQJXuYdnInK178DNP4VAoxNQFzIFDUzM3+FthWEnqXJhtsO0NLRdCVrQ=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 13 Jan
 2021 03:55:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 03:55:50 +0000
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v2 0/4] io_uring iopoll in scsi layer
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7nl4hpj.fsf@ca-mkp.ca.oracle.com>
References: <20201203034100.29716-1-kashyap.desai@broadcom.com>
        <af1ef280ded61be8ec5882b7a3b99ef9@mail.gmail.com>
Date:   Tue, 12 Jan 2021 22:55:46 -0500
In-Reply-To: <af1ef280ded61be8ec5882b7a3b99ef9@mail.gmail.com> (Kashyap
        Desai's message of "Mon, 11 Jan 2021 17:45:29 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0801CA0012.namprd08.prod.outlook.com
 (2603:10b6:803:29::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0801CA0012.namprd08.prod.outlook.com (2603:10b6:803:29::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 03:55:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72e5cd8b-3a97-4782-b92d-08d8b7771e00
X-MS-TrafficTypeDiagnostic: PH0PR10MB4536:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB453659E91604B6F0867AD9998EA90@PH0PR10MB4536.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:519;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h6get2YVcMuKC4+DfsWldk73bTOQZdXXKbENgI+Bt2002Mxk+M8zTiO/piFSCN15bfynKuRV+4dPHJrlIQ7+arGB4QgRRgAmugpSQZ0308wu73K7ChqoXMM93+PmPK8BOVRNqES5b9DRdK12s4PpRT5PGALSnSfqmrvdtlVpXTcbZa/y/GPUvP0qbG8ugUOGWsn0IXHZ20ZPQzp5Bo3c/l7+rYqAIL2+u97LoNkK7JgnuvoY66GeyxC3mvKddoQgHDhTIzNaU5sEAdgGPWZhKSROfuEPJ/vzh5QPgZxE9KgGXBLZzN1GVVQwGrevBXujqAkwsybPFFR7aGNghkgvSK/G891WEDZvgtmpe13sU4k+DenoBGX5gSOCS1XF3vD5HzyAsSf8CJz1Gcsf6hpXQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39850400004)(376002)(346002)(6916009)(5660300002)(66476007)(55016002)(8676002)(956004)(107886003)(16526019)(66556008)(4326008)(6666004)(66946007)(186003)(83380400001)(26005)(478600001)(36916002)(86362001)(8936002)(7696005)(2906002)(52116002)(4744005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4lZYmoy7dIVWwrKc/ZulVNyRvGCR/WE01C/jYuzqwP6sY/kTR0whSGJ1dCvs?=
 =?us-ascii?Q?l4KBsBynIotd0qFPJDDXM7WNKFjPGoyiw/9qIdVqIMKUKce/+k90hwk6JApP?=
 =?us-ascii?Q?U1TkOSEz5Hcq0gDizjc2JeZI5W0I3peCC0N9nGQjoc8H1JqIIhr+Q+FVjsYd?=
 =?us-ascii?Q?J4VejZJvW2cNV4rIp331JhohqbTk8vQ7+jSXQMq/FXlKgcoKytNk1eehKDXX?=
 =?us-ascii?Q?2FGE7W+WHH0jgw8ulZLFvTgKvKySNSsdrBBcsPbNVj84t6VUCvL+M8Wr/kFg?=
 =?us-ascii?Q?/W9uTCgYkDpCJh0diDDB9YaRXORMeItkbLvN6phJ5LgcOprHvbzacTwTSwl+?=
 =?us-ascii?Q?eZdaL3gv5Y3+cMt7ELVfckWG+nQ3feYFb9KD++mv+6lwfjBQvIPPzdkLTSBm?=
 =?us-ascii?Q?jf5xOFCPMyDlh7ilYkjpHFbacxOfi1QDb3bvcyI7RpJhEHxbQmSReiQgGvur?=
 =?us-ascii?Q?gk6H6Pw2s9ULb7NQNamcn4AYBlm1F2Cr0eSSpGor5aRrzQVWWavCxGGkdiN6?=
 =?us-ascii?Q?iKJtvyr59hV7qUAIvmjYeOeiQ05ESv50uYNQGRr/Of5XFg9CmvLnbe5may0d?=
 =?us-ascii?Q?vvELhsOa39N30aUIMYUbqMZvFQluqxV+Y0sSLQ94KGSb/vVRHdFvAQzV+QG8?=
 =?us-ascii?Q?ILBp8nrcj33PCSIpq6jK0pHW7voN3g/tYZEa4Dh3UWTgxg7YeGC+ZBnoqv/b?=
 =?us-ascii?Q?lQubHmNf5CSYgnmf3yqWV+r+VrLTFMvkOLq3srXonjlDruTYH1y+b7mZ7MNW?=
 =?us-ascii?Q?+pomcIogOurh4gZ0OgqZevdImvRRKd/2pHMQdu8YUfBHGudiT9RUGkvKheox?=
 =?us-ascii?Q?Ev1ai88IpDCZgYLDhcs/vD/7J2uCO6uP9w4hW3qAQd7Vb/l0p1ySa4mFUXEn?=
 =?us-ascii?Q?tgIwm2x/aMOVA47Xhxq3zWAIMv2489yObq26bI/AT+VGgFg11NBJdVePRTE+?=
 =?us-ascii?Q?zqg7ZfaElxdi926Hf5s0X+ub2NMWENRAw8SltvYw4NU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 03:55:50.4394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 72e5cd8b-3a97-4782-b92d-08d8b7771e00
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ddqxvRM5hhgav4nr3qLbYGRjLd2H6wvgsf6P60W1oF/SsWSKVpCJzlN2fOc5WpibKY6+6WF662HMYhRPRXvl564F81LlN+joxwCSHwrJNU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kashyap,

> Can you include this patch set for 5.11 ?  I see
> (origin/5.11/scsi-queue) has below change set. It looks like you have
> already queued up "shared host tag feature for 5.11"

The revert was reverted in v5.11-rc3. Note that 5.12/scsi-queue is based
on v5.11-rc2 so the queue tree does not have the commit.

-- 
Martin K. Petersen	Oracle Linux Engineering
