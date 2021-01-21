Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556F0C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B792238E2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbhAUDzp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 22:55:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38262 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbhAUDQP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 22:16:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3Audj152008;
        Thu, 21 Jan 2021 03:15:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=dzUY1gUXd3FYDHcKHRQ4Iczln0Qels6Xkbi3BgtrYU8=;
 b=r9Xtj3gq9EWaVqvPAOgO6CCtS2JKmG1bPD0AF8jl+Yxl9RbWGgB1fplYPrSl5nflYAGc
 SLInY7fkzntEoeafpphqyvVpKvUnsXXoPQ4+hb+b/lM8jHvxNIdzP8GxEWhk44ZpGo8q
 bErkKSmuoqULhLWrAeaZBw4+ty9rXLf4sohTEGq4+b7QEP1+gd9syRK6Vu2ObS/sCY/U
 LUfjaRv+NmIMwM6VEoOGs5+/XusbQo/0YJtuDYcZpX0o3z5hpBYF4jB3mboSzaseTBiI
 Nx3jErz+0s9cdPKhUu2EhDEtXJMIcZ0ix3vDcWV7sS6chuKX/a35uGZ98bmRmkjRAzLy Qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3668qmwbjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:15:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3Ae9q112128;
        Thu, 21 Jan 2021 03:15:06 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3030.oracle.com with ESMTP id 3668qwa0sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:15:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyiW79zUsHRL85l1ykX9vQIX4CQ74jFgWrSJoYaQbN8dt1L9UhiwASp+azo1myTKBxljvI6NkHTLVPYRTRgaVxYBYAVMKpo7TcJYU2AJYckrdvCsP9vKbrOrcF0uTIyXyC1/dwxSIKi3Tzqf5l/VlO8vra6qR2eZ3yTCNC5666dMpcq312uqA9mKqxhdIKgJYkaCwWapdniwNL1MCbYyYcGS4CkD7rV/yz3cDOdQfSEyy++/JBdpeAHO9H5KZHkLqnbX4n6Rz93pWTv0dBW+nWDcfNyfQ7vCOLM1nl8mUIX8ZPW72qSvL1LwHmtjQoLvU8l6AfeWcB3i4b1255DU0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzUY1gUXd3FYDHcKHRQ4Iczln0Qels6Xkbi3BgtrYU8=;
 b=GrqtggymVJY0QpjP5/P6KqZgKBRVP3SeY6iT6zJYK429P9ETAtStY0gYufUbAwnH17DhyjYealIpuQFAcw+woe1NS+UTQz9CpKH/SBE7JlDcBig9qM5u9aJ7XXOUrxGMce/nEHm8cvumAEkTCwsf20VgrfpXOOMNotkq+QGxw72JG3hz44sPBaxD5b/uZKH3VffRT+9/3Fa54l4bhhI0K41+L+julpH/nFXCk0+Xx7Ag/BnCR/6q/7iuk5dAFag3+DggHhz2650FHLV2ab10VAOBIEL6v+qPqxA2kXcLR8Kxsj+/p/2BeeL9xMtt6sm/uppm3xyAQ0pV9uQUyC3lvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzUY1gUXd3FYDHcKHRQ4Iczln0Qels6Xkbi3BgtrYU8=;
 b=w33c0IszDjgBSZix9iuvD0BkDQoeWbJiJqcwyrvSdqexRLGr4XQNCl+SmprsbCIouepjw9QSQJqiCQDftd/O7qIioznSUKk6fFWgBYDzRuls6+yOWCBX25ktDVI9y23LhY0KNDDj9LIKClggacL8DphjIX1JwZB0LX25gYgEYTs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Thu, 21 Jan
 2021 03:15:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 03:15:04 +0000
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/6] Several changes for UFS WriteBooster
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20210119163847.20165-1-huobean@gmail.com> (Bean Huo's message of
        "Tue, 19 Jan 2021 17:38:41 +0100")
Organization: Oracle Corporation
Message-ID: <yq14kjbgey8.fsf@ca-mkp.ca.oracle.com>
References: <20210119163847.20165-1-huobean@gmail.com>
Date:   Wed, 20 Jan 2021 22:15:00 -0500
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: DM5PR13CA0068.namprd13.prod.outlook.com
 (2603:10b6:3:117::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by DM5PR13CA0068.namprd13.prod.outlook.com (2603:10b6:3:117::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.5 via Frontend Transport; Thu, 21 Jan 2021 03:15:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbff5536-f681-4d67-d13c-08d8bdbabf28
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4408A72DBEDB717918F830E58EA10@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LaKodbSxu9uKuZUyK60et8/VF9LAZ9r5aSp5ZDtGhEMja8Oz+zR8S8UElj+Kf3tQ+SiDH3wFOdHlxwq9VLPBcfsWAkko25ScyIN3sdkBtNc57+iAR7nWGu9T7fH2L4ZgxZ9w+IoeZnNkOCe48+QyAy9cC41qDfnsBZ+3xZf0d9HfH7OZnuaiXK3ZxglI3yzn+1Q1PLpoUflGjFLFdXU3wXWOmP8mjME0lRXr0nqpERUpA1x7gjdte+nzgFLA7M/yvLIctLe3M5JnXm11OuQWa1m8szI9RHN9Boe8ajldvLh0uU29bAzmbAto6IO+2uQy9Cc0tTk2ePZ6S0Ir8w4P0qbp/HwxISJqj9378ghFFEcUfDfwI3bZdLWasQ5u4Bhcip4/ZhlqkYnZMg/AYpv/Fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(136003)(366004)(346002)(7696005)(36916002)(66946007)(956004)(6916009)(2906002)(86362001)(186003)(508600001)(52116002)(16526019)(316002)(55016002)(4326008)(4744005)(26005)(7416002)(8676002)(8936002)(66476007)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?94mile6ckLBs8Suuw+WXl/Gkh3OF4OtA38JsrRWbv1OjfnR/gV/jMFrX02vh?=
 =?us-ascii?Q?W8ZFtwJQaRCcCwePAx/Q49E9P48qNCzvbZl7ue5e7iSUOvkCkP2lG16g+Xxo?=
 =?us-ascii?Q?YVDYnsC20kKY4HP/ivbzgMy3SxJgrP/jYLQfEVb/CIF4brK42lPv2jaPm+tf?=
 =?us-ascii?Q?cm0bRSqC+h/6e00ELPVmNnWRjU8A/wDlkjY8vJ2HYUD2XUBX6QtjkC8O9nsr?=
 =?us-ascii?Q?xmQ2SsjdpR8HKdkuqaZBuT4+Z3D0S7M3XyB9NXj9yEJE48cfeWKgkgWBWf94?=
 =?us-ascii?Q?/vzAvmvmh+F9x/83i+uAjOectHVRCVXAAvt4qpwHekyWobe9kd+L2YLeV+eL?=
 =?us-ascii?Q?r8A5UTNipbgsf1rUU3Ca/tpsftLOLxgBSHO+9IfYr4uOLqJGx7NaKqSJiHeR?=
 =?us-ascii?Q?nRKRdz8VI768SPx3pPebgrhsA4ImvLEiLMy3e1+vvT7Fjz//Dxf6oyTOMZkn?=
 =?us-ascii?Q?C/dt5Wk/xcP3rgeF2cWGdpat2sZCPJApFZPnan0BXSBU+y8aIjhlFHw7fBPr?=
 =?us-ascii?Q?GOC7KNWX5alRZH7DIiOpQFEBAFDubwiKvoML6Q9zwFOxiyo1bv1D2FNjZ8wB?=
 =?us-ascii?Q?EAeuflFAI6yPxyarAzljK1BZrK3yY2CLvQtqUnUIO3Ar6V/FY+mxT7X7GlwE?=
 =?us-ascii?Q?LGt1WtihkoFiGHpHDyXfiCt8Tw5UecWqtL5hwSMkYTjx/cp3sx+sa1tYVct1?=
 =?us-ascii?Q?bFCIPnoEcW3Qk/ubY78kTWf83693mLHU7BAEeL+ZGG9ZsDODJQE+2u6rj+t+?=
 =?us-ascii?Q?MaSFPYYH1bPqbndInqCrHqgkIsH3uc4uQJpzWkXiy+wX6GpNhblxb7N/GcCK?=
 =?us-ascii?Q?0zWDtL9IsAX4uS1p2EABc86i7LN/e52lqePhKHTiobUiL3JdlISylbncfTLF?=
 =?us-ascii?Q?lzwo/EmgR9GHDVRESFYoRq38dTIjdFwMfC1ekb5Qrv/Vn7HzN/y4xTjUqVZb?=
 =?us-ascii?Q?XD0XSFuBxBKkUPqFfoMYdUVRcS1SfFnMxF3L5joxdQgPW5LNCzbIMBOFQAyP?=
 =?us-ascii?Q?2PtH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbff5536-f681-4d67-d13c-08d8bdbabf28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 03:15:04.2531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7kE9m8ikJ9LML8dS9edsBCGxIOwDEJ0IUexBFRxleLOPmHRa7lTYrnsUmUByqRgUiJAEjg3HAHMynU6gEY5LQ3wl4lebqPX5pCV3MN7J9p8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 mlxlogscore=974 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> Bean Huo (6):
>   scsi: ufs: Add "wb_on" sysfs node to control WB on/off
>   docs: ABI: Add wb_on documentation for new entry wb_on
>   scsi: ufs: Changes comment in the function ufshcd_wb_probe()
>   scsi: ufs: Remove two WB related fields from struct ufs_dev_info
>   scsi: ufs: Group UFS WB related flags to struct ufs_dev_info
>   scsi: ufs: Cleanup WB buffer flush toggle implementation

Applied patches 1-5 to 5.12/scsi-staging. Patch 6 didn't apply, please
resubmit.

Also, I had to fix up your sysfs ABI documentation indentation.

-- 
Martin K. Petersen	Oracle Linux Engineering
