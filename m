Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D377C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8FC423B1B
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbhAWDGH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 22:06:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54324 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbhAWDGB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 22:06:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N33f3t030188;
        Sat, 23 Jan 2021 03:05:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=AwnK1Z1vctJAidVSzV302fpyZnEjbtEbrYTQLi/v4uE=;
 b=lF54OARtRmD8S8g8mvWk1qrb3WwIPifLM3QobSYTqaCL+D9ct0Vn2u9iyLRBR9RlKJKl
 nUBGsKSjWy6A4YhbLXlVo+cHBQd93zf8IQ91GyMwV2rM0vMlSi97+qTMNAienBee1GXg
 ERXMpIiF5EK2iPh+ES4hCtYKUQEJ48zCLC3cD3iCPt3loGxCXyhII82qZ5VwospOVitP
 TfslAgiAwtyiF7mNK9KvW//yetwOn48bjSWpM9U8gtYvHGTLgFcsnGG9kLyDUln2BR8x
 +ypcQsrLAbfmcSELAJ6my07RjgXpH8guqFp5cCRrovNvcvjPMje79H7v/Bbeyvx6R1DC Tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 368b7qg0ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:05:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N30nD3111080;
        Sat, 23 Jan 2021 03:03:08 GMT
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2054.outbound.protection.outlook.com [104.47.46.54])
        by aserp3030.oracle.com with ESMTP id 3689u8tpf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:03:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/5Qb6ruMF/8fSXVFVXsjq/INhJI3/Jvjp869RutqwCf0wjEhj/lC+L8SB73SZHbnKBMXuc/2ZOXezswlk6ISTIK35TMnR7+qbyuJEWXKyhoGFEBvFtWK+2FsfpUB7ZDBBppDGzE2U8bxlH9i2o+FofY9861kFeFvducCzUqh9AzkJD07APoVR9lRPGIeT3mUeXdxS+LMPqrpMb3OMlYwnGKYI7cJG9GQjZsBgz1pOwCE8WOmiRVxOVhTm2FiqD3LtC2PZfYLn7fbyv2SJ6E0Wur30kpBQEDTJlhq5GHpOBAaN5u0yTrBLELIZNSzz6/v6Z0JkNcb3bWoo3ircDEBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwnK1Z1vctJAidVSzV302fpyZnEjbtEbrYTQLi/v4uE=;
 b=m/Gc9YkJLHudeckPzUjZJP5qUwjRJqZJDJFUh8Fl6n/Mdhf1h7jviVWYpNdt5E29pzm8cBquLOcsHBCZ/U1RMoAE7fAUKtXCRQCMTsVQJX3NFr23WlwNvHxP3LSSrQdaQHNlnD3+eHqhPQp1wU/39lBjm3AwEc0uWby3ODycJ+Watc64hPRRQXG3iDtQxT7kDtWmRaRuSoVifkTVK7S65vNnVuOF2HaEFdXYHr7hEwrXQDfPXtICYZdUrkwALf47ipRi+aM8ouTqyZndnbn9o6cfkaL3qvBdPZnAgelmMUJd97TG1c6srmjVbx0UhFliNpCJRZ9UREuvp5vKHB5aTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwnK1Z1vctJAidVSzV302fpyZnEjbtEbrYTQLi/v4uE=;
 b=CYJiZlgW0OLcSj6589LsPGHAT+o8Mp3xf2LazJ7vGw3+mddwM6m+0WUO96QGShpQbmDt2hpnGtimae1Rf0zbUDs/ii1Y2ZCubWIkge2JjmA183Bcy2R6HpHmXIgUihqC6UogtRj8zBd4DGnGghpW/4gZIQrr/eIFsuarmWY2HpQ=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4776.namprd10.prod.outlook.com (2603:10b6:510:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Sat, 23 Jan
 2021 03:03:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 03:03:05 +0000
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Assign boolean values to a bool variable
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z3obbj4.fsf@ca-mkp.ca.oracle.com>
References: <1611127919-56551-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Date:   Fri, 22 Jan 2021 22:03:02 -0500
In-Reply-To: <1611127919-56551-1-git-send-email-abaci-bugfix@linux.alibaba.com>
        (Jiapeng Zhong's message of "Wed, 20 Jan 2021 15:31:59 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:610:53::40) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR17CA0030.namprd17.prod.outlook.com (2603:10b6:610:53::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Sat, 23 Jan 2021 03:03:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e26e6db9-8142-4c5a-c6a7-08d8bf4b67cc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4776:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47760E78BE561E85193374DB8EBF9@PH0PR10MB4776.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NKaE3gOnkhpuTLWv1dgZuIjG6ohv7VmvxNcrqC7oCYb4wEK91e+fUGFTwBfIoXzTld4B5JJT1tlAQoMYlK54vBeWMafB92rfd5FUCMACfeL9VrXV6YDChQ6cjrxGTZVFsiicI1y9BwEe3D/4aB5prHAMcWP5C6bixTVdyi2zSj2Lpz6M15w44egZIDulqBC/v8WHiEspb3y324PxcB5zYKAOh6EfnxxnDTl/uPNVt9gRiAq/V7nd2Wn+D6mNRQrY1zE/sb8UkAF0e5aQXSkXqxwWi/TQiMWJJKXAS2Gg90n9Mf+DuqdoQ7XEfDvPmEDFLSY9LziR0F9kx/Mcl2remBMu9SOFaaV14t6DWd6FScEOA8EpVqdd8iSMndr/U0sDcOrw4PvvV9D+qRG6IHt/Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(366004)(396003)(376002)(8676002)(36916002)(66946007)(8936002)(86362001)(4326008)(478600001)(52116002)(558084003)(7696005)(2906002)(186003)(83380400001)(6666004)(6916009)(66476007)(5660300002)(26005)(66556008)(16526019)(316002)(956004)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jc/42UTchsSGCToTLbVo4qTWmRkkHRFbkP5xAHfRZt2LanmQmFaUXNvmDuAp?=
 =?us-ascii?Q?lrA8kadan+qkiP+rae596QLgu0v13Rkek49tlbcZgl53TWR5zEFTwgE9knQB?=
 =?us-ascii?Q?Lyy+YQ/GMD+vnVkkGmf+jzEiyVkZgUxqg7mTqiLAdRb3NZ5KIVcblqdLE90q?=
 =?us-ascii?Q?oumZyRjnFRBXyd3EPfjUqFDeZ0oClwnlBfK2d3yngOgfOZ5iqbdmVlEskOKP?=
 =?us-ascii?Q?VVcX/LisEDtkyaO8o3tyCt8jnvQLDlC8KSm6Qs4hCsh2FjF06quopi0S/0Zu?=
 =?us-ascii?Q?tu90SdhaiyrSb4wck+JW3YD4YfgMyH+PVyeSpHlVNMEDswYGdsGYDHZ3m45P?=
 =?us-ascii?Q?O0MYXNzrpfWGbv7Ppvyl2URWvqlYCp2ceP2GIT5xwLgNPrL40kw1oI3Z2EcW?=
 =?us-ascii?Q?CyU+9blqqvdi/MGRiUWRXhaBMeFvORVm6HsmhZ22AwAFsyVXsKZ7h2oEn59i?=
 =?us-ascii?Q?2ZYYLdVJzBDXUMCFK7ydMjM7rbBbPiHjorGj9NQhyqPHObOui55iJ2stgAwz?=
 =?us-ascii?Q?ZEZe5ZP4+TfEtcEbGyybPeTX+gumo/nKB+FHotw3739jAqM14hOTOo6EUvrh?=
 =?us-ascii?Q?QnsODtwqsjSWx5dPtofCZ2wp9+/+jGcWhGFizs/b0oa0OUpUUoK+Bswz+eqF?=
 =?us-ascii?Q?+/ZhT6S24rMTvPKj8kREjNd2yYR9Cxj8x0hG+7h+au7m+mGf3MZLxNShN3kx?=
 =?us-ascii?Q?TC1qYH2e05rlLd7NHPv6uTXmWa3VKGVhdVDBXyGvsHX73MPAxdqdBLZNmQxw?=
 =?us-ascii?Q?NmclFa7J/R0eHRDvOvBYddxvVA5NlD4cTc03bZ8azigwO3AJ9QxhwhBhWUhU?=
 =?us-ascii?Q?fOiG3uP/HNmSsdtWV+1BpiqdyJw8khS2fQXNljcSSeQiGjKu/X/kSEErYtx8?=
 =?us-ascii?Q?my53njyeVnpKQ7FQaE2sTm1uDCobME3uhwagMBKI7h6jUhFSrYt90xQ83tGK?=
 =?us-ascii?Q?mcrcAWvzr0I+zujzCPuzwnOdnxPv9Z6ursIx0ElU3OKhSRpm4MJCNZUCJpoK?=
 =?us-ascii?Q?TGLBxsV6Qo9AfTrtwRJgShHnY/z7Hmb0YFirD36VK2bAuFs1L5Obqki2nyLV?=
 =?us-ascii?Q?Z19aMPaJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26e6db9-8142-4c5a-c6a7-08d8bf4b67cc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 03:03:05.8856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VEij/vayuziWlQr/7HEXh9ZTt3ITIGHHTjkbvh509ax1z9WwSnVATZHeON/DllL5q3nx1ZTRHR4KxG2VfhisJVuzpMVuojDljyB3zK54Emw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4776
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jiapeng,

> ./drivers/scsi/qla2xxx/qla_isr.c:780:2-18: WARNING: Assignment
> of 0/1 to bool variable.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
