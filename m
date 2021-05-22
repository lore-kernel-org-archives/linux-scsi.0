Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22AC9C4707E
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03219611BD
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhEVEmL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:42:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53460 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230043AbhEVEmL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 May 2021 00:42:11 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14M4aauG007988;
        Sat, 22 May 2021 04:40:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=IY6vapqu8v78j02nzc5ww/t4nRMNlYFGvkzOFM7k264=;
 b=nPaE1lMNNvzgEB4UvW/WgamLxdj6TgzmHQ2VHDD4UTxVzs4vXbYdZKTMVqX59Ajw7KjF
 +FVoivN0tD73k1QsUUGtv+C171ApzoN+ir5rw5IDPZBRwY1rtgc8jlBpBAOdij+RfhS2
 K+mbh7vH65mGRADXgIicGAN8L4nr2NYlQtvEop4F11yNswEWYosfoihZOAsVdJ0mEa2G
 7COcB3euAjhfXVPnrEAp8D9VwOR+H3FPZOSTefeWKfNzN3VGAcrbg6fNrdV+ya8e71z6
 3gBQqOccd1Fx0ACsIHLk1WEGrnBWY908nyGhEPSGfMcvMDuJ8SfwpdHoqVxWznjSqs++ 1g== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 38prj001ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:46 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14M4d5dQ172766;
        Sat, 22 May 2021 04:40:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 38ps9j32fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKwqcWQap70zHoCakiBGR6ec5503vlcELVSCf2w7Uek1mQqpiJXd3WH4od8IoSgyi4Zg+QkDHlHmawYjAcfZ6ufGA+fyF3BJTI4VLp3uXJASr3pS7Otgw4+8BHF/SQEjCGhWGKuu+KPVHCggfGyh1qqYBbat1KZviP/IkHDpfPh2dQ4L8MEi0hZkemXkVFRTcQjLYMbkWo7jzpnhIaOuD4LGbWFHuBk+iZOqo3oLunpKqT6FZEjY2HC3ucJ75jKRLJo8WQXuO4OBeGQq9nCkZX0aqXsKwEqY3UyDVzaxOFAFLUlDej5Q2Y3Src+8jpyFSu/JUhNEkAyjllg5Au/joQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IY6vapqu8v78j02nzc5ww/t4nRMNlYFGvkzOFM7k264=;
 b=Q+6qIxPkfSUSvCtBZIOJmESHCFka9Z3v6SoBxp/DX0j5XJSGK/qzKyj01WfPP4Q80xMP83MN/nuvduylYDKUvUHlUdsYkOUyRPGLdsTUFzYqppHxDDLL45mtvH6VO7HtlzWw79gkuGM1BmGYtSg0cvC94gdPObEC3xYrXB195jOj5GvtmbtDZCPrGFyxkWP7QXHtJIW+IdIbgCLYDBIONphe0mAStXG3P+GTwgbAJqtPuVSdYxrj6b/sO0ne1dqGGDrqKUb6jl5e8yPbZ7ihTZoVH1fVxjH1Oxiu4vyU0U+z23HdvZNNkFj3MYnzI1IAkA1EkyNDg3ZfaujbQka0Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IY6vapqu8v78j02nzc5ww/t4nRMNlYFGvkzOFM7k264=;
 b=S1ovBELQqbBNAHEsNS7zXjaghoRObtFFChmrBtuLGJLHJlst0YWv7VHF13iJtrgVFjlEG7aBksfTdoKLpl0JS6vyMmuxzc3WS9tufVnWqz896+4dBr3DLfU4kOEbgun+3KkauUu3a+cDLGWqm1/X1o8y2ZqNZ3CjXY33V1SMVWk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:40:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:40:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bodo Stroesser <bostroesser@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3] scsi: target: tcmu: Fix xarray RCU warning
Date:   Sat, 22 May 2021 00:40:29 -0400
Message-Id: <162165838886.5676.9613892813904842731.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519135440.26773-1-bostroesser@gmail.com>
References: <20210519135440.26773-1-bostroesser@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0201CA0038.namprd02.prod.outlook.com
 (2603:10b6:803:2e::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0201CA0038.namprd02.prod.outlook.com (2603:10b6:803:2e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sat, 22 May 2021 04:40:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82c44715-c9fd-4840-0507-08d91cdbc17e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54812F04EB9B3A5AA8F109928E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MAN0jvURKFZQ0ast1fR1LOd2lAq/SN57RPcCqjDT3/WL1xRGOIuOG1vHC6N7l/Zx9vU1uYoygWXTUCHR5ChOSjYCuHkNWjplrkSifp/pgWvoyvf6vdZCAxu9M/GiFMNsy9Xn2dE/cSCn+6d5gSHiZb6tiiBz7h6jkgOm+yF2zMqvOoc+2klBZczyHGWZddfqPSu6DGIjjbXQl9u1877n8HDb1LMW7nMoCe/y9peGKipE2bmCWPqlSakaAJS9n6E0fP/Oq+fu7okGogM0XFOPyNXXWSXEyNtc4C+j4RMvNu+b5YWKCWB9wUtHffZQahXmf/22bIB3fxh3nqP8t0cB3C0k/0nvzHnSDYKLfgTq/6LtJ9K2Mh9YOKg/yR/yRge4lqm/VVrKkrO26Z00xJerl++d+LeEL8BlueLVi7q8noF0imGsGZV/VDRbaiouRPzpG3UCdt4+QWP2Pw1JhtvwgJiSb8QviYEjTlZz8qzFStEHYsChUEkrfjml4wyylSvfnuB06vpaSAmVPyJ0zkZikmf7NINXmhlHq4dZ8rfj9FIXJqWPj1Szi6Uii8gIpFvwj9jKAKZrgfUbv4g/RD27WWl3Ufq1RbVArkz3CmKOSauL7aCd1G1IEIkwr1amzFBudD8kf04wdRQ3PjUVOyo1mZNs+utk8mKselVQzbTt4gl/6JMgCkBi6zU40ixbbg2QFbjiUqKoxJgVSMiTTvzYA0BhPdJ20HlLP/NaKTEJ24dFDKACLzPZ+hsoWh9k14g5Od9V4+mAcWxiG71VkdlZZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(6916009)(38100700002)(38350700002)(66556008)(66946007)(8936002)(54906003)(5660300002)(2906002)(83380400001)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MTNJTGFQcG1WOWJXSWVnOTV2Nm1IelNGK2NaT3dWOUJkakF1VnFZTDFyTnZR?=
 =?utf-8?B?bmMycnVRS0hlMVpkcnhDUGVacytkOTBVcnVibHovckhadU96NjA5QkcyaENL?=
 =?utf-8?B?MTVKWjBoaHJRZXZEWDhBRlgyQlRRR2tmbER0bm1hck5XR2VCSzdmY0swZGJS?=
 =?utf-8?B?aWVQQmU2dXlSbUc0N2VTRjFObndnSFBHYVNodE9Tb2pCSUR0UXNNR25XU2Nl?=
 =?utf-8?B?bmw5ZTVCOUdZWm1CdEpuT0J3bnA5SXlDMzd5Skw2SlRDMTN2R3NUcFpITkg1?=
 =?utf-8?B?Rmd5Q1pxNjQzbEphNXR5aEswRXRCUUFrRWpFWkhrV2JJOS9YakJDNDNqZjRQ?=
 =?utf-8?B?aXFoN3g1dUdCN1dsbm5MdXhNdjJKRGhHNjU2RldybnNuajV3azliVUtTYTQ1?=
 =?utf-8?B?VDRreUI2cU43TzFubGJ1bVpOMWZpUHdvYy9xa1FqeWtwbCtJWnVnWFN1NHJk?=
 =?utf-8?B?T3BwTVN4NzNTbFl0NllxNjNHeVJ6OGcyQzloUUJhYXpZOEw1K0VNKy9rL3dD?=
 =?utf-8?B?aUcyYkhSQzVTOWdhN2ttLytOcjJlODlNU1lSdDFBQ3RzdjBidlN3MWJuRm56?=
 =?utf-8?B?SnFkSXVZRkV3b0FkelVMaDhFVVMyQU5WQlp2cVdjM0J0a3ZKYzA3QUhwVko5?=
 =?utf-8?B?WjB5TitTUzVoTXZjcHFTK0VPM0xSclZHV1VjUFEwUlhsVk5paHRTUWMwd2V3?=
 =?utf-8?B?TGpRV1BOYndLaEFMdjJMa1ZRbjJpRElnaHNBdXJXYVFXRm16Y0YxWEc4akZa?=
 =?utf-8?B?UTIyQ3BSNG9jRVJRME9oMTBuZkVBbXVFRHhDcTViM2dHQzJqemVOcFVOLzh4?=
 =?utf-8?B?OGwzRnZjekVtOEVFTUV3bW9MSjdJdnlObzNpYXFpZ2NHMmw1d1g2NGR6aTdG?=
 =?utf-8?B?R2cxMVRqQ1RLQWpWVmN0LzhVdEdDZVZSVnAzTEl4RDJnMUdHWk9VOThRU2Fr?=
 =?utf-8?B?K1luQ2FkNTllREsydGJWazlvM0hRRmxYQXEyMklzWng3Uk5TS3VzNmxydTZo?=
 =?utf-8?B?b0VnajhXazhWSHkySDMrUUFHc3NtOUNQS05UMkhwM3czVml5VzJQSExQYmMr?=
 =?utf-8?B?Q1BORHkwK0ltQWNlQ2ZqdnZaajV0N0wzbkU3S1pWdmZHNEhqT1ptNGk3K2tR?=
 =?utf-8?B?bThIZDlPSHJzdnNoZUxwWUJVbm5PNGhIWFcvT3FLRkl3Um1aUnJDSHQ1cUtE?=
 =?utf-8?B?YkhQemhTcUg5ZjVwb0I4aFhQdmRRTTBwRlUrQ0llNStKdWN3MTBQVllQSGtv?=
 =?utf-8?B?OGozektZeW0zTTRPTHZyRjMxOVp0MDNRbGIvc1JQalFxN01sTjAvWkNacUJ5?=
 =?utf-8?B?MURKRHVORkxwRUZTM1BKRVU3R1Y4RDhlWC93dzdJQXdXUUlUK3hpR0FaWDlF?=
 =?utf-8?B?QjNzWGFOMjljdGQyWWZyQmoyN09OMnhHTW5SVnBJa3JGdlZlZ05semt3ZWVi?=
 =?utf-8?B?c0RDSjcrRGFMdWdPYUV3aFZ0YXV6dzhXNHlEZWN3K2szaTZJY0ZOU0VEYlFZ?=
 =?utf-8?B?eHpzWnFzZTBHRnREUExMZy9rek5kdG5Md0x1OUpvNXZKZXY5RG1UMmluK0JG?=
 =?utf-8?B?NVJPUjFoczZ6K0RDTFJTQk92YzNmSktGTVczNW1URENBK2QrcXZsWVErTWxZ?=
 =?utf-8?B?c3VFcUxYWGhpZnM5MmhWVWJwQkw0TE9pSnYxcVZOc1FITm03UitrbVhvU3oy?=
 =?utf-8?B?akorWkEvanVxNFhFRkxTSXAwMHlpSlJmZzdWUGRRYzlPeDRRZ0F6TDk0SktL?=
 =?utf-8?Q?19KPs5xmsdyh+NHzz1TycpUgrUA8eR1+lYpkYsm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c44715-c9fd-4840-0507-08d91cdbc17e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:40:42.1035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YarJNwafxhzmGsBSpj02Ryji0GSX+LjmaUKBYPOLRzM0hQNfHJ4gRq2NvPVyskpkFIRDWepGhD/n6PBtFYuBH1rbFGeKIMjUPzxMZTVf7UE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-GUID: RJ4sZC2Bn9z-otvlSQv1529JUfUeuXP5
X-Proofpoint-ORIG-GUID: RJ4sZC2Bn9z-otvlSQv1529JUfUeuXP5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 19 May 2021 15:54:40 +0200, Bodo Stroesser wrote:

> Commit f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE = N *
> PAGE_SIZE") introduced xas_next() calls to iterate xarray elements.
> These calls triggered the WARNING "suspicious RCU usage" at tcmu device
> set up [1]. In the call stack of xas_next(), xas_load() was called.
> According to its comment, this function requires "the xa_lock or the RCU
> lock".
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: target: tcmu: Fix xarray RCU warning
      https://git.kernel.org/mkp/scsi/c/b4150b68815e

-- 
Martin K. Petersen	Oracle Linux Engineering
