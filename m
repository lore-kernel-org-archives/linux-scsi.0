Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0821C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74ADC23B1B
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbhAWD2r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 22:28:47 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51482 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbhAWD2g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 22:28:36 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N3AjNK036030;
        Sat, 23 Jan 2021 03:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=aqAqnVAFURoDMGDHYEqNOp2Hb8o6LPodik9bKYSjno0=;
 b=cF25iEq4f93Fv2n/k8l8dxmdbSuvNsKAzPBcHpucGL196TCe1H+glbMrC1Ax4wSdwqi8
 mIE69nX5/JUdNFXF28oaNupgeJe144rKLhFQiQbw+Y8jfBBO+57y6rm/eFZkD35BKltC
 4nKAzw7xq5GZTLjTWY0zE/Uu6JL1S8r8QTygj1YN03AKRpJaaEKzIZjZDJuAnnBNtra+
 QtjLc40PWKfpo5zx4JrB4aV5IveusXhcNArc2jJspspYQetZlnY2bNc7fTDMx0l2+O+t
 gkcGF4jdISsKhZDcfHxp/92psbyCxdx6qWSV4aCrBYCAVveqR2WFDIzodbHvrLcytqMy rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3689aa8808-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:27:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N3B1MA043592;
        Sat, 23 Jan 2021 03:25:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3020.oracle.com with ESMTP id 368b4grx3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:25:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7aoCKrNhqYLq7uKYSCdYJI65I0BNd1LlU+L/PPo8LxTF0PIQK+YIFFhSasUW6iCJa9qCDj7j5/+RaoNIW3ezKduKqnLohFIPBFJQVOr2K0GST9dST+DmvwOQf46rPt9K4HotYtW2nY+//yJdaK6e8upx8ysGCX29LGC2FHOn1x+IAN9TOKxTgLqyQChWew9DrB3o7yIzWcrPcP6+gD39pwTrflddKGYLp/cmE1QJkbYytNH8eDVodnumrtLOixPcYbFeS3BNaqlxMGWT5QW0+6Z1g4o/CJXDvOf+hXO+EkDRWIiAxaF1nT41HhuQWCsm/jJ+1FJdu2sm1qD75zOOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqAqnVAFURoDMGDHYEqNOp2Hb8o6LPodik9bKYSjno0=;
 b=RWpGrmedJaZJAVQmsqT1h7rLjwzgt53YxFApTO9geNGtuKYtRRN/FTftPedIaKoPcu9KnoJcWGn0zmnagFTn5RNA9O31fb3oBgv2zvq96GhbbkgFkhBSVFGsSAyl3W/xb2mahNs09hzN0FopUsM93nRke0PAvWAtZbevkoiSoDDp8vjynKn/sT1Evp/JBo7O/2AOi6djZXcBCOJGuoPmoaw/HDYb84fiJ2rXpM1FBfuqrKl5hgoNlrdvw19gK7ZK+fA8JZ6gBWH+itHIzh5ZwVYPo8cAcyVupNONivcvAtjGWGZfhO8WLv8QJRf+pEUtjjenfivbWB2V0RmgAETIOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqAqnVAFURoDMGDHYEqNOp2Hb8o6LPodik9bKYSjno0=;
 b=q8JsbVMUFoW/5TRmL09qsUb6mwkObKW8/OSa78gw9J2fl065kDclDIJU89SbychF0CUB2wo6tatOQNHpaZYbIfS89FwrwwDTEK9NqgJocgNX+WyBCzqO0jhjW6A4l9xsE2kFdttuG2gJOZUx8r3DcAs284WyBVuxKd85kKf58Tc=
Authentication-Results: exactcode.com; dkim=none (message not signed)
 header.d=none;exactcode.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 03:25:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 03:25:31 +0000
To:     Rene Rebe <rene@exactcode.com>
Cc:     linux-scsi@vger.kernel.org, Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] fix qla1280 printk regression
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7n89vxb.fsf@ca-mkp.ca.oracle.com>
References: <20201210.223944.388095546873159172.rene@exactcode.com>
Date:   Fri, 22 Jan 2021 22:25:28 -0500
In-Reply-To: <20201210.223944.388095546873159172.rene@exactcode.com> (Rene
        Rebe's message of "Thu, 10 Dec 2020 22:39:44 +0100 (CET)")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: DM6PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:5:60::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by DM6PR10CA0015.namprd10.prod.outlook.com (2603:10b6:5:60::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Sat, 23 Jan 2021 03:25:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2a1de36-b1dc-4ede-fc09-08d8bf4e8a10
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4696353C0A43760A10BD4B0A8EBF9@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:187;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Coq3OMaXJPGg9EE1ja48xao06HBByLWmEB5MZ+i00chT43ub+EXbT04nWtliUWdlFeKc8HSL98Q0tgRhnXk3ZKpcuZStZw4DOWF60OZN6TOOHD4QBtbjBgGz3DdanVbxZYfg1A89acyfYPsWzKZNvQRxmcRLwvgOZR5gz6iW5wMUxCPPfimuQUlztKwINJSXb/4zy8bTvTnPOO71XidB05711EWVS0c9YwuDHd5hrk6hFH0v4dtnA/dym0CdDOjTfPKsdVyPOHa57ZvXIcPydoNNoyJjrODjzd0srUIkZuEHpQZeKrqq5pgItEKAIVJV/X5lNbX3VQgQVjzizOtvV89yak7NhhQJxy8zwQcYXRQ0i/I4w4GaE9pL7Kh38gazNWeo8QPEWnBVhVC5auqwCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(396003)(376002)(6916009)(66556008)(66476007)(6666004)(8676002)(66946007)(4326008)(4744005)(86362001)(316002)(7696005)(956004)(5660300002)(52116002)(478600001)(186003)(26005)(16526019)(36916002)(8936002)(55016002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iD4fFj4XbY+zs8UduMR4yWzN0t1FiCtHzAIRVB36aPnQYOxsZoxVaFohBloB?=
 =?us-ascii?Q?Y+/lSs9ibN6j9poXrAwzteijvVHl5AnSSQkd4pn01tuoAffFU6ZOkPwYObQQ?=
 =?us-ascii?Q?nRzAX4MJg0i3nSosF7tDaXuB/tLURlgfgrwPi73bZ4fkGGkRm5gWBR6e5Zss?=
 =?us-ascii?Q?tx+b+oIXUEA6tJKvaZkJCUeUxgOGrt+eSzJE57kPKpb5VTKdWqosXyWtvF5X?=
 =?us-ascii?Q?/N50/inOOubw4zXYU/sVAF7lvaCSRrAvzBR+YlS81IB1C5GsfBrrGEP6AhEs?=
 =?us-ascii?Q?+w5lYL2XgaQfskASxZNnVkG4f2dloTH928Llfn/RyvsC1YSpHEXGQOpZUPMn?=
 =?us-ascii?Q?2znmKzqziGQq9AqqzyqBn5Jf+qMexAfDkDTMZLXyjK7SNOxkD7ycVDFmTVkz?=
 =?us-ascii?Q?XpqfxQueki5/QR5EQBaa4DYz3e6XvE4MQo52g1tesTdCiESZneMf2Ncrj6xP?=
 =?us-ascii?Q?1IygcYeIlBPturjoJZlAwgrHJ52Zi1VMaNehwIn72zjIudow/4SDxlP2NLBF?=
 =?us-ascii?Q?nlwFsD9iEbTugSxUSm0M7zOenMx6TJIDokH50ZKR1ZoZVvER7ymvDcOH4RgX?=
 =?us-ascii?Q?m1v1DkWOtpWkkPBPwZDWxwbHD3BOYbMhhyTXYK2MbdeUAjr6vqmpiFbRxZV0?=
 =?us-ascii?Q?XsDW5gtVxM0tBfoU8jHzBok/1+OzqKYKCfMpCLnuxbktLDhsLBpKYoNeHWlp?=
 =?us-ascii?Q?euWQduXjstKNLKHqjiczjahDoCHMswGrAqye/ROaHhm/TyqS4pM9JJtXB1q4?=
 =?us-ascii?Q?2zRpW9Fre5u+iC4VKUsCTBfNweHjfRsdtk7dZAPGqErNQOAYLobypaJP7hlg?=
 =?us-ascii?Q?MV/LEE6lZgYFpUNP0ERRCEIlzd5JYXcIHZo6Ydqw4/N8cklsL3XPCjgZaJ/p?=
 =?us-ascii?Q?WET21I3pzSn08yj3rpNEFDa6mC3ZIOJ7DKeOLvZDPVHDP5aDA5SuYSUdJNab?=
 =?us-ascii?Q?wU3FYIH3mW/IROFnJjmuF4kLMcUgClknueFwS152I1yQTDnYgvDwf6Fv3FBO?=
 =?us-ascii?Q?1NT4ayUa9wXoZnc4T98xE9wfgXer+F9TQM+vQFuVv4rfoi9Jj0pe/04DWMrs?=
 =?us-ascii?Q?D13FLoPs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a1de36-b1dc-4ede-fc09-08d8bf4e8a10
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 03:25:31.8594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vbhTY+e/KupVVbPuYAjcVUpWGhMf7qsR5+obbozSbiTcjx6uCHTxSDodGIWsMDNXzQewq3pPzPLRMFNtAMncQDxndGARMSf7EDUe7KTqems=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230018
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Rene,

> Since Linus Torvalds reinstated KERN_CONT in commit 4bcc595 in 2015,
> the qla1280 scsi driver printed a rather ugly and screen real estate
> wasting multi-line per device status glibberish during boot.
> Fix this by adding KERN_CONT as needed.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
