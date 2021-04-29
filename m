Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B9EC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 03:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBDB76144F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 03:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbhD2DUR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 23:20:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50164 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236899AbhD2DUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2021 23:20:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T3DpxZ175236;
        Thu, 29 Apr 2021 03:18:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=cahQV6RdWLRqhdBlsuSy1LHpcMX1OULnGneBpczsoy4=;
 b=UpBPtlRyqaWrf+lqxW3nRw29ZhImrUhg9NN6c2kZHuSbvj+bRgEmhfU//p21sOA/3mkn
 Ht5XtZgekkJpyDnxd1C7EosgnktWiZ+FcKatFGlu1GCkXSMRTeaFLS0vz/KKWqoXAqof
 pCbw6wd2dEd03zMaOp7rriARx3SiIIlVrFNGi6cUi6YK5RKoNnStcVkFv/jfWNw1KBVU
 N/mEy2hM1m9CiuXXztLyX6Yunh95jQqHOiqW5VeCmhoTUeufh1FkDMp3/h7Ou8wO0fiZ
 QqVpoRimkdFBJM5pi2sOY+PVMDA4Q2lHQUxVzN6/O6R2EEXfplhpHlAzB5usorwSWGb7 nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 385aeq2w3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 03:18:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T3Eq2t154231;
        Thu, 29 Apr 2021 03:18:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3030.oracle.com with ESMTP id 3848f0es47-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 03:18:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jczss5RXvvak7ik+dPOZmPL5/K/A5oguP7qWibuY/CN1UCZnUwEGTMzuZ3zoJZ0eBSVFnntLLRj1reZDk6YkHJu1IdJQeU+d57pxQA7Xkfga3IggbskomMkFeb1Jqvcv+5Z+0pgnbcYwjiwwkO7hwGJgyoul6/7dx0cRdGHJAAXZpvbVUPtIMauKaPpF2Nwz8VnqpyjHuZVWmKVfRhF9vtmC8W1XKX6M9ScwQ4pIYm8JMV8OeXNTH0sTMPP0dlRSrkplALGrYprqVtr1NY05lX5osXQBAqiuVA4Vlv0rFYF+FH+wV1uycI1+rbPHb4kV7jkB1Qz5fAMsD9unMszHkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cahQV6RdWLRqhdBlsuSy1LHpcMX1OULnGneBpczsoy4=;
 b=h5C+LHyymRvrV5f/7buuDgSkieiFBF0e5Qyrc2u6w88CrH+TkpLdCz+HSs2duWb4EMjUQPbMXTvjJ7z29e1jQcsGkcHDLKWBoaXj5UJedmmUEPC8KjgTqXOYscUb64mO+Zt6tATSEuOZRTtmL59NzLDzKDOFis86glBJ2r7z5do+W62F46M6Oj85YcRvYU7jquIm1iwZaz1eDea0is9dx5+1XYgzDSElNWlL8WnaAdM4P12Y5nwFHnnTqTf/s6ijrRIQt/cHYl4K0Slp5j2UiNTgL+U0GW4zulhzUyDQu4tztUu6YTHUrOlPvHdSBGb0rBCxHeZ1M6ex0NOZC52nWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cahQV6RdWLRqhdBlsuSy1LHpcMX1OULnGneBpczsoy4=;
 b=n0DD+qSQ+9n6EzV4Q7KCuwsDh6GrmklGO8GZn+cHgZ17/XDzL4LvdbCZRidw21j5sjqDQAZo/plUBEmvReD+U5FbkDdnUAgAN6/mJhLczjV3LqAi1jaa6OwxbQxSvbjplzlwu/z4jCzS3wAGuz9SKuuD7KJ4Jr4cYLf01xClmM0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4805.namprd10.prod.outlook.com (2603:10b6:510:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Thu, 29 Apr
 2021 03:18:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4087.025; Thu, 29 Apr 2021
 03:18:54 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Bodo Stroesser <bostroesser@gmail.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: tcmu: Return from tcmu_handle_completions if cmd_id not found
Date:   Wed, 28 Apr 2021 23:18:46 -0400
Message-Id: <161966630052.16262.16190510653308472334.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423150123.24468-1-bostroesser@gmail.com>
References: <20210423150123.24468-1-bostroesser@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Thu, 29 Apr 2021 03:18:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 482addf8-d2ed-40d4-fefc-08d90abd84f3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4805:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4805678F1A0B762D61CEEAC98E5F9@PH0PR10MB4805.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QgS7GlXyGc2iJI1EZwbG0KSpZzxUbAcpuRKJyplLLow/8QBA0i2hZQBmGwoZGHub3z+QhAgaYReD93pmLAwWvVNtOHnQhyPptASdFtFT4sw39G0N348yygmBd5l3yyapJYp54LsGHRVuVuT3h7WPAn+P8wajWR3ApAhpK7zRccwVO2O8BfzFBhBp3MyAqoTCbJ+C0fPEieyE+5R40mDNS+xmr+NERarKsqhMZWkzvRCL4UMSOjVl7Tznk3RCw0F7sm09ogJc6qaM1eDwuBZcZn7QgHc09FXcWM7OJQtIjfjH2b4z87vSG249ojLsCmMIULBccuZlNE28Tdhr88Xglazm3he9p0sjSLKVSgYNeMzvNdS7H4tlwKAsgW40tYmbtN0YtrDlEsPeco9DuGWAvMxzM0ESpp414Tj7Rz2ikGI1oRoRIN1gnFFMpR3UHlMRhgVqYCOJpJawTVQj1Y3XJY644CdsdLU8hrc9HkcoaM/rgj0l1c74kcI3Bd3rvE7wcwTZkd/GyDTcfMf5OQJLzicHEZbNtTvAOZoRHrIrpMyNuf3O15c1JdwspHLBOT6rOMw8EVOazvQHZPkFzf4zZvWiAZUgGqD4eAdGrAEbIbykuGs3PaS8v40wd462L9PzbaTBRPTnw/l74Q9HMBjyIVrSWaCh+chDpUltgBWt6jwfAOXv7yBfrnJyr2UtZd5jSY4ZF1Z5UFjUIl5hlXcGAZ1iGU8SlY97A3gi6vWhLpE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(396003)(366004)(376002)(26005)(36756003)(107886003)(103116003)(5660300002)(4744005)(52116002)(16526019)(186003)(7696005)(4326008)(316002)(8936002)(66476007)(66556008)(38350700002)(6666004)(38100700002)(6486002)(8676002)(2616005)(66946007)(478600001)(86362001)(966005)(2906002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MjhINE5xUGJoUDBSMHJGZHVhUlVFR08xRUh2YWp4Z2V4NiswaFIxaXpwd0kr?=
 =?utf-8?B?dktLOHhEVHdVeXlZQU9jZTV1ZjhNcFhYbHh1UlFBdmZWcGE3Tkhqdlo3Vy8x?=
 =?utf-8?B?N0Y4UHZOWDZCUTl4eW5WekR3VG1YMDk3YjV2ZWNkcG5HU3hBUldHdk5wdGFt?=
 =?utf-8?B?YUEyMGNVZ1RSbFFjVk5xQTJxbTBrU1JpYkhlNEZTTjFjR3lPV1dKdEUvOXB1?=
 =?utf-8?B?c3FkVFZGQ2Zld0RtbE9TS0RiMER0MjNZR3dQZHhpN1ZaRkw4RE5WQ1FIa3FF?=
 =?utf-8?B?TjhKcTlDL3QxSFBSWFc1aUlSL3cyRk4rT0pEaGdIcnl4ZXUzTElLb3ZDTnpZ?=
 =?utf-8?B?TGUzblBCRE0wcDZxQlNkN0FrVXpyMjA5cGIrMlBTRkJGMVhxZG9oNHpOQkZl?=
 =?utf-8?B?aU5KSytJT3BuYTd6LzVYenhIc3pybmZqeUZVVnVHaC9uamdzNC9BdWpiaHpI?=
 =?utf-8?B?M1UrNisycDFGb1BQazltbXpSdnF0ZVVPOHJudFYvZHd4MWZzUnVZSGpDQ0s3?=
 =?utf-8?B?aDJyaUhZVklQZ3kxUVp2RGRLOGhpY3lFSmhLOFpiM3ZuRWJpb3hBWWhZS1oz?=
 =?utf-8?B?MjE5cC96UllaMGthTURuQW5OVE9kSlhhRVNvWkhSNkM2aGxMMjJKR0NxOXIw?=
 =?utf-8?B?WDlINUk3WFA3SVpWYzdDeHFzMzZjRm8xaE9aQTFIUU05ZGh4YWx5OGw3VG5X?=
 =?utf-8?B?QTBYWWs0MVJKaGNraHVEVEdhd2paOTNKUEp0RDhLc0JZMGQ4WThyOE1MSlBR?=
 =?utf-8?B?Y2t4QUV4MmI2WHR1b0VjZmlTamZuUmlXUXVZQk5XeTU1RkhrMFY1bmMrbkQ0?=
 =?utf-8?B?dzdoeE9RaW1TUjBjN3pwYUUzUW5aNksxT0JnVWZSOHEwK1JWaTYzK3hTdmZI?=
 =?utf-8?B?RWF2YU1pSkxrSmp2amNLRkxCVlNTbitXVXF2WWYrKzZVb1RMa1FMemgzL1RX?=
 =?utf-8?B?dFpjZVNqOWxkMU0rY1RXUHI4Tk8vdFFqNHpDV28xVExtRDgyUk5uUTg4cnJi?=
 =?utf-8?B?Y2ZTemdqazIyRFNwSzZUUlRMYjAzdWJOSXpPYk02SHNqWnVKRTFFcHNvRVgr?=
 =?utf-8?B?cFhXTy9MZjFQN0duODZTcnc3aWY1S3Fkc1FhNWgvOWgvdllqSGE5RmJwL0ZW?=
 =?utf-8?B?NkJoMGNxV2xlMEdCNkFsOWZYN1c0ckE0WFhhYnUvV01RbURlWFdIazduazM5?=
 =?utf-8?B?eEZscXlUcEtFM1NBVG1tU2FQekZINTRKL1piU2lQZjJXQmx0d0xTcXRXc3ph?=
 =?utf-8?B?YW5MajZnN3Z3NjYyamNOOUdpZEdwM1RBUHBwRUpKRWhFQy9ydHBnTGVEZnNB?=
 =?utf-8?B?Ynp4YjAyK3RmNkxtU0xuOXp2UWlMSkFndGhTNnFYNVNRMEFDTjJ5d0ZISG5h?=
 =?utf-8?B?VUFtVGtleVhlTE1NRGdySG9mUExGbVZRdW1WMk11Qis3bDA5YjFpZ3VMZmx2?=
 =?utf-8?B?UjVhSTlpQy9LcWphRTdMZzRodjZvamhUbXNQMXBseG1KT2pvR3lIanNSLzE3?=
 =?utf-8?B?dDM4SHFvOHdidzRPRFAxcWFXMkJYMnFNQ2hSblR4eXpPZUU5eGYydy8vSHZN?=
 =?utf-8?B?elhiVVBTUDN5NVJEb1RXTkxiK3VwMWhNOE9WY2tkRC9qYnZvbzBiek9jOWRq?=
 =?utf-8?B?dm1MYVd4Yjl6NmRBay9zcmtENVZDdUFKV2FVYnFES0MzTk00eTNnZE42L0dM?=
 =?utf-8?B?bTNyT04xVkptL0J5RzVscXJZcS9iWmV1V3JZeGtvK0pXSlFEdFlmK255STFO?=
 =?utf-8?Q?C1T4JO3SzIhtV/AOyQZMkFKl6TMbX4IhU6QbLXR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 482addf8-d2ed-40d4-fefc-08d90abd84f3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 03:18:54.7197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O1hI1ClWQ9kyeWL977I8sJ/l3N3LU7HDSqpj9rsTg86AVsarDZ3BhrvAHxczhJ+axLBb7RBgZzJNCoYxhnmmxuqBB67TM1kxREEJy/jtoqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4805
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=874 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290024
X-Proofpoint-ORIG-GUID: 0EC0Kdau9HPnGydRSts0Wjbal1500Ny5
X-Proofpoint-GUID: 0EC0Kdau9HPnGydRSts0Wjbal1500Ny5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104290024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 23 Apr 2021 17:01:23 +0200, Bodo Stroesser wrote:

> If tcmu_handle_completions finds an invalid cmd_id while looping
> over cmd responses from userspace, it sets TCMU_DEV_BIT_BROKEN
> and breaks the loop, which means that it does further handling
> for the tcmu device.
> 
> Skip that handling by replacing 'break' with 'return'.
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: target: tcmu: Return from tcmu_handle_completions if cmd_id not found
      https://git.kernel.org/mkp/scsi/c/9814b55cde05

-- 
Martin K. Petersen	Oracle Linux Engineering
