Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2722EC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 02:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC51A64FC8
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 02:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhCJCrx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 21:47:53 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47622 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhCJCrf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 21:47:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A2jIVT143945;
        Wed, 10 Mar 2021 02:47:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=HniKBDV+6Yj7/AvshcNMNX+Dwvh2YjEpb0AfXerM50o=;
 b=ECnpRTaWXkEkHGVAQdB38xgDrivtBeRizS47dDb35rt+ONIMg7Nua0A5JoQeaYIhJ1xO
 xLymxwGCIJgOy35uzkZLsgTR7YY62X5GPbdflmgmHKZI1wLTVAIWTNNaaTqz4sdiWklP
 WhLksOnQh+MiuuW48YH2CHV8N4mr2zhneyp4qAC2Z0SinHrMEy87p2YzaCQA1fDb4MEP
 93ancg0yYOph5Mh9VdH/9pWlDmZ3cgTVfIm7nfUudDsF+47Mpq29j3hFhcSG90S6XkWd
 8pVDbMclx/OpyN+grGyrtRry+GaRKvdasaSkDQt0X6+LE26glX70lrvZt4DIbYU2TIWt BQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3742cn9f05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 02:47:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A2jVEL046826;
        Wed, 10 Mar 2021 02:47:29 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by aserp3020.oracle.com with ESMTP id 374kn0a1bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 02:47:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVmNMyj6Gt1MVd+4B13r9ldhnMSrGr9I/bB9xE6QZh28GDy+OZbuIp6us/hY6j8vSrAE3qTPbi1le3UYjVBh2ffww9TUSDXUF+oGHbsHMd9EFPigedq5P8wftvrk6BVzg3w2vTnp7GKJ0z6Dj5uuTZCclb9FXKJnIXDcn5SgnotSF5RISg+ujV96LiSKPvmhSY6iVuFTvh+Udmf6ytYevTJnQZnCOCx6JpCzAexHiAguyO3ETXzjJT7AT2OnNnalN+50OGzQaQoFtGZkpfJm2+2LOfvai/pdq26akD3nMen51nAP57hkV7ZKJjlWCa0+2xkQoDabTFfTbNVzwkog9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HniKBDV+6Yj7/AvshcNMNX+Dwvh2YjEpb0AfXerM50o=;
 b=jEbgJwtDHoEAbPO4cn98rC9+o+DVrV6jl0PisvOiy1r1ml4zzt/aFPmYMsCKdlOztbub8VcDcHjjrzU6dmr50lrbSrVhxH+9ZQReVD8NAWzuM+ayrgWhGbrhBXe0t6rzKHhswb0F2ZIR63nWzOatdjumUX/9bQnJHiCSxkdvh4gCx8V/SwC9HHm1gKVj1YvqdmvmtPEcoIM8U4M5vOqJsSUmCptGvg7ENabZdaR4Xzs38lhjWrFUlvCLTPkFl8MuyrMTSuR2FZd3VqytDcTan5da2x8CGNPXGgA6xt3Uas7hjsLQ/1sX6Pu1DJq2c2naFJrt2e0iKWjwYeZ18U/8rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HniKBDV+6Yj7/AvshcNMNX+Dwvh2YjEpb0AfXerM50o=;
 b=I+oHchDYPcfEfeWa5+eCVHKyhah7QQSIa5SltXfOo+Yh4Cd1E2c0IA2SdsHXohifee3GhYNgEkTYyDvOQg7leMVNps8arUpmd02xHM+ZMB2BOIHTX7t1jVYcSTe01rvIcja0AITqS5FZb1wCfEQKPk4KF6gugZZQKnOTRAVIrbE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4792.namprd10.prod.outlook.com (2603:10b6:510:3d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 02:47:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 02:47:26 +0000
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: pm80xx: Remove list entry from pm8001_ccb_info
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7ljbu8a.fsf@ca-mkp.ca.oracle.com>
References: <20210301181847.2893199-1-ipylypiv@google.com>
Date:   Tue, 09 Mar 2021 21:47:23 -0500
In-Reply-To: <20210301181847.2893199-1-ipylypiv@google.com> (Igor Pylypiv's
        message of "Mon, 1 Mar 2021 10:18:47 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0170.namprd03.prod.outlook.com
 (2603:10b6:a03:338::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0170.namprd03.prod.outlook.com (2603:10b6:a03:338::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 02:47:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54b22ad4-5fd8-4da9-1e8d-08d8e36ed6c3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4792:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47927BDD483D99DAC95FBB238E919@PH0PR10MB4792.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tY/GZ0mws3Zys52x9UnTlUaJJcJLJRtZjy4u32o2DkmwdICNpxypyaNsKo8fG7neeTBlmFFIY4wYQU0WqhDHt08LOBBihuyOks4HOMzeaWMMnUnJ1TWNwustbrSvCA/UAYOohZmtz5/pYh3Kw88HXQj6HN2ofGaXqdvgx7v4u4HgEUsD2t8WMhhJwrqNznaNkd2tj5+knBCI0rpZ3EfJO064MZ+VeLirTChc9K3rrqSLLjESjAkbxzG8V78JfZZwKZwrMEN7P6XF7FYPPs+6eaoWHGVRbGXZ9k0MNhnFV4lxTOteofPSgd9TXU4MV/cTB3pV/SR7jriqETvrQzE4OtNT2bgjsgvEUBHbX/v3YOX0BBimDCFEvmc8CKU4FbhURLRLsi7kdDkhwovLnX2hQW+aiwABqvXxL5ykfPAWi4UjMJ5DJKj8mUcBmOrjWZDyYamAcdDoIkfYYL1r+qT/ZJwOrdXUEvUXJaUSxvElH76k7RSmXXOK+29XkTwBAg3KRqit9gPIOoBg7DZ5RPVn6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(6916009)(2906002)(956004)(4326008)(66476007)(558084003)(36916002)(7696005)(66946007)(26005)(66556008)(86362001)(16526019)(186003)(5660300002)(52116002)(8676002)(54906003)(8936002)(478600001)(316002)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QApaiRL/Y+ZQediooQ4Xr/UwIexEFvSQzrHUE85zCJHEQHdIILUMkY20m/sZ?=
 =?us-ascii?Q?KyZU+RT9/tXIlS+nSqeQ7J91U7zP8CWLwLkMpEcsdvVN0buOfJWKPs0EDl9m?=
 =?us-ascii?Q?u0nb5NeMAAf1PqMmPhc23IK8JNW105d6XOYrkAsDkHkxgBLf6PYEwxTNn9I4?=
 =?us-ascii?Q?C4WKhEJkvWasYXEjQJiVMXflrfyxVKyms8uIOtu8b9t2e6EgWdR7xXkhWvnq?=
 =?us-ascii?Q?dXjrQONBUIVJxuc7iLvE6Un6hjI755WJsyHvvdn+2/0grL9Yxqs6VFKLFMEl?=
 =?us-ascii?Q?sjuWfCGP4RuQmfZd2Q/YFFIIUd7Q6e1Fuv/eLxMF21f9X5Jdw5Q8s70j8p+E?=
 =?us-ascii?Q?JRGdTnjo0pmhGNpVGt2nwyYp9wBwuZGWpgU+ft2E/KIA6J5KYU70oZaDQyHo?=
 =?us-ascii?Q?xkBXKdX2apKIr85ZWGXpt5CY6RSGxHd5AljWxqr15LKuKFWh0Sn4E55ZjTdS?=
 =?us-ascii?Q?Zt9PBsf6wUlFa5JAhD2j2XLgzFJN6sT4L3stqodPfOVaoxtwabk7ieo8ItWf?=
 =?us-ascii?Q?WsTeVQ4VQ6nEMl58F+OeeI7fmurhZZKlTTxEpHnwxy//NKuc7+EYSSyaJSGV?=
 =?us-ascii?Q?1fwRQTskgbGS9pSmvxSDRbUhGvwFBJvC5M/sbAb6tBJkC98eM3Kmxpv4Jpcr?=
 =?us-ascii?Q?vIcV8ZqRnRmbWFLRZIEwYIHgYDuF1lQmBctmPf8TMTU2AmAqx+n15TKr7xZm?=
 =?us-ascii?Q?WN5Q3PIwcnNBTU0TdnDO9RdoRcDulyhdOacSmQ5aMTszIU5dr31bbUm9db2y?=
 =?us-ascii?Q?tuq2ixgSKi9vJ+42pEiGmzYynUEso9Evn5+IJyGRxlgMEYy7zA2FT2UwD1m7?=
 =?us-ascii?Q?7hXJlk5mGI8Ywva9utcDKvOqZ74ljQFoDNfcjWZo5ruObZ7syISCdL1QG8/t?=
 =?us-ascii?Q?EYS2CV86z8zPnmzHeiF9KFckk3BZDL7fgCChkGynQpVRNYSD5ywmItTjEIn4?=
 =?us-ascii?Q?t9dUXFChBJERa7Lam7XSJo18dTZ0HSqE2NbK/R2nFLk32VVHfPAfJe6WEjlg?=
 =?us-ascii?Q?Dl6jRI1zQWOreC0yNJpWLNijYqP35LYeg5lf7/qPSo72D62XMdTRmT7JTAvQ?=
 =?us-ascii?Q?rswoT4lPGp9Myya2MdKkvcauCiD9y7tx/Oi2heC+NLVinRQ/kIWIeg+yz0wd?=
 =?us-ascii?Q?B2QyBnHi0OZXuHLWT3AfkW1TtAhezIpwD6hxG54/rRYKcW4dmK1H395eNiYa?=
 =?us-ascii?Q?Wvp2ZLt4RmW2Hp7N+f27bawqxkOHDMTXKC/G8Ch5vbwHh+NnZd6Bp1uroTMR?=
 =?us-ascii?Q?7A9JGytyWnIkmY5QiBa5H1oaRMVptUvpZFPuV/3lbla1co94Yqoz21kHfCf4?=
 =?us-ascii?Q?YFv5lJjBgukUWk5guUtELlnJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54b22ad4-5fd8-4da9-1e8d-08d8e36ed6c3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 02:47:26.3368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: du0k1wIKZaZq8o4bENPpzdL96ipxG2FKS7BKqN2yfTxIOBl4UKrqYmNP9KYWKWEoOlO56dRfU1x9XdYcWdKtISKXPbfQBJLhtYapzikUgxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4792
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100012
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 clxscore=1011 phishscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Igor,

> List entry is not used.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
