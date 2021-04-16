Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FC1C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58C5F6117A
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238344AbhDPCwU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38954 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237999AbhDPCwO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2mhC4046795;
        Fri, 16 Apr 2021 02:51:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=OJ+3fG+Tn33uODWBThdpbSCHUOPs/lpqpVkn4+sKZC0=;
 b=wUZxzhOSHXQjdKJh43zzgNzq/VNl1NJdpGFOT+Xg09rHv7zX5upzjA9CntQr2oYQEL0d
 asLG/oohtch0aGpTG8ns8UeWuqzbjDY+gLic5hk6Z3cqmbHt5jO2ut8JoyhXLUkyKoEx
 lwUmeic4kIOhdn1y9JSEWu3L0zpYCMvLr1TIaNxoh0VonJ/lONC/PpPIEc1D5qfQ2L1+
 DMO+zPnVV9eH8+G5ZpOqJaG8EztIPt4eNjQ1AHLHo134bilG/KaYGWSh9Gx6vJlq153S
 eEvWPuqT5O8eElcYQxMBS+lwYwu0H5WH4PvwY1dqtfcHjRr8sxE7pnEnySAu8V3cb5sb tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37u3ymqpm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2oeFk162577;
        Fri, 16 Apr 2021 02:51:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 37unktgk4m-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPLrXXgTHj2nmG0Smx2BeSS+nwXKv8Te/cYuzDRaEnK1oDE1KyL/RR2c/zWoBl6kTcYW2CMbZ/2oYDZYFs/SHz5eXIGYA9Hzzq4m7EeEu9nw41gxYBcVo66YHMLBXXIa6Frw+75Joasn68oJAy1BDsyeG1bev5E0RmhvNVN2Bch+X+pcMYo/LRQY3XHcKyMHEgWm8ag27I30lH0M2THPI1srUfNt0Kw3nT0Ca5lgNwkj+nXjuu97R1mXAZcbxKICa9t8rjw0LQh2zaHrwVTV9LdpweqkH6mAE6LZH+XkEGpc1K4/CL8YBcgnU/bDMnAlXPnsd13XvqTQ8puma3SYnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJ+3fG+Tn33uODWBThdpbSCHUOPs/lpqpVkn4+sKZC0=;
 b=JZT2aa41uLWPiWBYGOZjIFQLiA3ny7rk/qVFk6OJg8qwvOW55YCndB+cj8UFil9uEGd6dBymteEkIWuW8HoicQoBNaNcpt71Soll12LcbvQXi+jQ69WjIckvcUHMlrKY7b/nRN61yeNlC5hswsXxNq8v5cIdZb3J7xTcOOFC5AE96qv/bnkarArT/ETffzyvCE9MRraL8OUBEW0ao4dJ5C9U7lCapo7GErNgAeLuicmPi3VhemHdLyy0FK/E7NExJs/CNtLdB2VOuL4aEpQ6BACFrtqKZKPECkp9Agyp2RuvaB1jEvEj/yg6madbOD4hy2mVe/4ewE8XQq36/DMBkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJ+3fG+Tn33uODWBThdpbSCHUOPs/lpqpVkn4+sKZC0=;
 b=v4JD7bxW7dbrtV9bLPrTcukQxmYw9V2QmYsofMVq7kFUsVaOpliM/KCu//EiCWkRC7Vk/SeIWeg99toQ23M+uAfp3BGS3y6oXpdB2HWpv3O6euBMr7Y9PELJWm5T8yTtX3CLxF0x9zr+hzMOTXqa/CuxXJkQldHK+Sl3JEqCG2g=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Igor Pylypiv <ipylypiv@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Akshat Jain <akshatzen@google.com>,
        Deepak Ukey <deepak.ukey@microchip.com>,
        Yu Zheng <yuuzheng@google.com>, linux-scsi@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>,
        Viswas G <Viswas.G@microchip.com>
Subject: Re: [PATCH v2 0/2] pm80xx mpi_uninit_check() fixes
Date:   Thu, 15 Apr 2021 22:51:09 -0400
Message-Id: <161853823943.16006.12910776685015754020.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210406180534.1924345-1-ipylypiv@google.com>
References: <20210406180534.1924345-1-ipylypiv@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f2df8d0-e95e-42c5-730a-08d900828a4d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB456823FA1BEDB363CF471A7F8E4C9@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dlvdiLYd+BYoaq6/kglb2mQN9Cqh967cz0SKgBJY35AXy8EVCG7e7GsvXxEULA/tJKKop4dqJgSLL5V3YheCrB1j5rLZYNZfydS7Cieg3Th0/APiFn7MMaDoN00zTOowt8ZP6JoEpLWwrDLDaVWCldoBrPJWPeHPdkIQdg9+9QJcZf147mrpypg/4xDqPojnh7pazyyyiCNx3uSzgEfohaYzwQc4/5rDmqqbCUcsxLFfiG7lOblOwDZXjfS/e+9QNiV1cxQGOcWgbkuqFanqpC/3zyDUkYepTN7mK7M4gs4yCxV89bDYR024FfEix5IElZzrvxOvDmDHz0MarTcfVuaefp06g7MSOqutziGYPj0CH14/XYrld6jMCjew1UIIl1NIaXjauptaOTVEkWPLQ450tUZDuh/x1GYa/E7DuJuyKzVspnTYaa75AHa6j7oyVm5FZFcNGcstGBNuu2V8l7W2DcFUI00tFFwDjhHGApUQzynS9J8r9dTtom4Suo3uagE1p5N7ZZqfc4eEJrtgpv0zH/lEhU9Q8qExLDEuQ6z0k50CuXetaqp4OJnSysssVv2qWBy9ZXBzt8Uq2H7V+zaXfrEdLse7vligfW5vDszBjdWu4OWSmPKKAmVBzR0tCqVskpEuPbe/UQQnGPG0Y6E2CTQXVWuwizpM2WByJYqRrNrwelIECCD4YskitrURHF2qkBJeSXyy+stcnokjSV1HYo+Q/tLriU498k1Af28=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(316002)(103116003)(7416002)(6486002)(5660300002)(478600001)(26005)(54906003)(2616005)(956004)(8936002)(16526019)(66946007)(66556008)(66476007)(86362001)(4326008)(8676002)(186003)(110136005)(38100700002)(38350700002)(2906002)(36756003)(966005)(7696005)(6666004)(52116002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eUM2ZnF5OTBmWjd4NUo5TWtaMllHV0JQWVNnTXhPU2hDdlhrcWtQMlVXZWk5?=
 =?utf-8?B?dHJkSW9vQ1l5ckY5NWhraTlHZUVrSC9rWiswZitUK2tsNW5ZUTdwRWdPaWxI?=
 =?utf-8?B?WllVSjZwUnl2emxHTmoxeTRWK0F0ZjVKdFlXL2tDendRRTN1ZUxWdTI1TGJ2?=
 =?utf-8?B?eDRVMUVqVUNsMW1kNUVIaTJzdEpvblk0cUlNcHFLYUI2eFVzT2RKNEpENEl2?=
 =?utf-8?B?ekpIeFIrSGErV0JzNWNtRDFYcnJQRjI1M0hVQVhON3BlRXhDK1k0ZmhyQUwy?=
 =?utf-8?B?WkUrSUFrSzlVQlpKd2ZxT1ZodWlacEpUdWNHOXZVYUd0STh1ZUlKa05pNEow?=
 =?utf-8?B?WUNMeHA1U0x1TU9qRWdKaFRHak5meE5mdXBnejhCM0lsMTFmU3YwUEIzMms3?=
 =?utf-8?B?bzBuZmNnckJiOERKNXlrcEdFZ2hiY21GRjVsUEMycXJCeFVCbUhkSzRKMW9m?=
 =?utf-8?B?OVhlZVhCUEZWY1hwWlF6TVFqUXlzQUkyTG9BS3A0aXlXd2pYQTg1US82RG9P?=
 =?utf-8?B?YXQzcWhEbEdaZFl4OFFySG5HL01MME00UGNlYzZWdXQ0alVmUFVmcm5YVHpC?=
 =?utf-8?B?bnNhaXo1UEk2dExoNUtoUlh0cG13U0NpMXNaRDlJak1qWlFzK3pYdDVXeEVQ?=
 =?utf-8?B?YmQ0WENpTGllUUxEUFowS1VQKzliTVRlMHBaZlZ3T0VWMytKdWs3Y2h2eE1X?=
 =?utf-8?B?UTZvWUtRUlVkaVE4VzVwczBjR0I3UUl6clhMRU5EYmhJV1U1ZElCUnRxT05l?=
 =?utf-8?B?WnBGdEt3NGF4UEpvdk45bEZrZVBtN0pyaUtDeXR3ejh1TldmbGlsOVh3Tk1H?=
 =?utf-8?B?YXZvZDJwYWhMQVI0Q1lRY0pFWUJlU2xGYnZCRlFUbzFpdG9McFM4azJIbzlO?=
 =?utf-8?B?ZEY1OWNCUW1NNnZ0ZWpCMGNLQWs2SWkwcVkxVjV0N0Jld3dNZFV0cEZBczBj?=
 =?utf-8?B?c1VBaGExL0hKeENRZDIxYkwyaGY2Q3ZsaU5yMHZ6c0VRRmY2alo0Z3dBbFV2?=
 =?utf-8?B?UFVWdzhKRzJjVTlxVno0ZStobmIyaWdFNUplSHZIS1Y3cERJZFRILzYwL1Mz?=
 =?utf-8?B?aWlwUnZNM3pxdHQzaDNCYUV3R0Q0NENaMlZtMmUwTXBOQW9naUcrM2tSMFFP?=
 =?utf-8?B?c2JLcWpadko2L0dyK1BUdjNORHdHU3YwdzNaOUhPUlhtU2JQaDd4cHJKWnBE?=
 =?utf-8?B?QzlLOW56ZGZjQXYwdFV0RFdpQUYwSjVDNlhJU0xWSEpwQkVCNkQ3KzU4ZFlo?=
 =?utf-8?B?eGNoTXc3c0c4ZkU0M085RTFBeDJmK00wRFFiQWNEZzljQVdlQVd5YWZqRFBP?=
 =?utf-8?B?T1NjM05IZTVrTkNvM0hRdzlpZUJQYm9Ka1VFUk93YW1xOGhNRzMxeU55WnNE?=
 =?utf-8?B?czFhQmhLZER5dzYzWjdFZmtCd2xnbjBVY0ZOVXRvNnIwak5DUkdtNEhKSDdz?=
 =?utf-8?B?NUFSZmhPdXpERTVZVWZacmQrTG1yc2FJbFU1M2JNemtaakY4cFRzUlMwaFF6?=
 =?utf-8?B?cGM5d1FTMHZlYzQvN1dYVGwxbCtvQlVqMXN4UWtSTUxnbEl2U0NTUkI0MXFO?=
 =?utf-8?B?RmxQVXk0TEVwbEU4TGNGektlY0p3SWZwUzlNLzU5cUVjamhPazlIeHBhY21o?=
 =?utf-8?B?aUZicnl4ZmY2T2tnbHIvQlpOaEgwZm1xMnhpeUx3NmdaSWxUSEVSQ3ZuVzhu?=
 =?utf-8?B?ZE52aW1yaUxlTEpzOXlOVHEzTHNycEt2MGhoQVJKMGlKb3FiOExWVDk4MHI0?=
 =?utf-8?Q?qpeInM0GFSgqkjJDvk/UlJYHwOHk156/UdA0DRe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f2df8d0-e95e-42c5-730a-08d900828a4d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:31.7846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qwo2ZDbho36xudzCkJuW8uBGFqDqr9Iog7zZLZLdNy69CQYPKuPwHVC4WxI8jZ/r2VMfeKKGgtAt0SwjHx4GHPxNHteDtMEfYVD0IZ1MM5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
X-Proofpoint-GUID: _UL4NrHAyrH8OcBK2bpyZmW7ZuWBtVEJ
X-Proofpoint-ORIG-GUID: _UL4NrHAyrH8OcBK2bpyZmW7ZuWBtVEJ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 6 Apr 2021 11:05:32 -0700, Igor Pylypiv wrote:

> Changes from v1:
>  - Added missing semicolons
>  - Removed redundant parentheses
> 
> This patch series changes the wait time handling in mpi_uninit_check() to
> make it similar to mpi_init_check().
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/2] scsi: pm80xx: Increase timeout for pm80xx mpi_uninit_check()
      https://git.kernel.org/mkp/scsi/c/3f744a14f331
[2/2] scsi: pm80xx: Remove busy wait from mpi_uninit_check()
      https://git.kernel.org/mkp/scsi/c/6f305bf699fe

-- 
Martin K. Petersen	Oracle Linux Engineering
