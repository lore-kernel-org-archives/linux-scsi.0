Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC7BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1708A61156
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhIVErW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:22 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42940 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231844AbhIVErM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:47:12 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M1wB8E010075;
        Wed, 22 Sep 2021 04:45:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=SecPdzInPvLVlRyLhmHcdsm/GA3CrnKa00nmS/zzuJg=;
 b=vai2LGSrXEXVQnThnnuuKJl0BjGC8hLMgx23IFro39jlxe1TVKMx53+CBMWrGj8B1R3/
 tYCdG6qc9xs5kFSNz82Y1TK9redoBIxE3l9E4ZSfY2OHWQ9lZ4IOBOW6HVSo7rDdS2vJ
 +YPfqdZZlBg07gcXgqv3UKEdiwa6YjyVimoPg6Kodqkr15FDwhoIFC7BJ9zt8MXbrGbQ
 KLTlNHjte50l8kABzKhBoFzDcEBPJnCU0XG4RjZ5PEZKyyFKbetsjlGMnM5mzOxrMvTZ
 BjAxqeyqjBr0fiBt+BDP26JdBO+DK3YCZiehX/jL+neJXkTW01D9xkf9tGsKekVeQ2Oh 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4p9ax7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4jZs2178811;
        Wed, 22 Sep 2021 04:45:36 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3b7q5mc7nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsyny9TRIukjZzIjd1aHNcUbpekmtcgaUW7rF408OyvfEw62y1OFeL24L571yHyD7eWyruV7KZ4Fm2vbJTsOmp2HqHBLMO5ZRg/bP/e/RTLY+pEbPX19rM2TqkwXu0DhW0NumiN1hUd0TLM2bYDCa3UZcKM2XxV1FZ1SqrAoFNafpyh9cobrFCcz6fBNc06GbzuqNrPiDrREeG0VxpqPU7CFdy9InQlFnTgKmGrvGjCsPNVzdwDM1kZpNrvNQi++DzlvXCxRJrLopKTJ932sOwmb96pGXB2E4iEAP1DxnrFVJVyPX7PL3b0H8ME8i/SBtFIlKpB67zJIbwtykTjzvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SecPdzInPvLVlRyLhmHcdsm/GA3CrnKa00nmS/zzuJg=;
 b=UBBmwSMwNdvQL/Pb7HdOt8dHJZecCC6pwjFBo7gH3WdaTaEHrQWFBw9gKlW6IexfiswrRezY/TIzP6IVfoiBCI8ew6W2C/XjWBTA3onNLqkBHOj1dBPH/YOH2yqHB00XTTLp5lWgqFu7ey91popp4SyMcJoOfZlvQEiulLGysvRV/Ks8LKucGiSQdbm2qIFDdjdSWMkcHe3Uld/aFnHNdC/pQf0JgSi6wAb0L6DZH4Lv3G1jrNqVcul+uA3mlv1mhRtifxc4SYy9eR/ZujtdhqLnTc+XgZ/SOfN5FhB2loLJ2J1P5nN7pLnClEQZxPS8Att5QP5oaYqt6Dti9mLTtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SecPdzInPvLVlRyLhmHcdsm/GA3CrnKa00nmS/zzuJg=;
 b=xEy+krnTiDb3raQtvxnMZTvfXmHOEb8XD1WWxx0mQm9TS1/9mqlHjpiSfSP29pIfYk0QAgRU7QuM3SrvQ1Xx+VT4AtfQbdOq89XrKfUM3Os8rkOfNnuLXY744SNcjd4uEllgWsu2zbuzFlO52D/FRHkHxpI8bgfei1hQqWepdVU=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 04:45:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:26 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ajish Koshy <Ajish.Koshy@microchip.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        Ruksar.devadi@microchip.com, Viswas.G@microchip.com,
        Ashokkumar.N@microchip.com
Subject: Re: [PATCH v2 0/4] pm80xx updates
Date:   Wed, 22 Sep 2021 00:45:12 -0400
Message-Id: <163228527478.25516.12702615574089791784.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210906170404.5682-1-Ajish.Koshy@microchip.com>
References: <20210906170404.5682-1-Ajish.Koshy@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 04:45:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1aadd87-d3ee-4582-4328-08d97d83cbdf
X-MS-TrafficTypeDiagnostic: PH0PR10MB4456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB445605192C4C6784D8EC6FC88EA29@PH0PR10MB4456.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:298;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6tOyHpbdtdmScnCEDj72G3238BF4oqRQlS0UaSyf9lh/ZJ1/g8PvWtL5jRJRdwnny+jNoxE3zXC8E+6Vh6iVfjlqSt8SYdB6AhN0XnwAiSKt29YBeG10QeK7bnJy0d3BhVjzAlW41ASAxZcSUHL0/AYSqEz9+7220B9nbjnZT5j3xfOaZHUMzZlNaOW5N4tJFptbc9yj31C0Xny+tx88zmi3ilLLZZDDevxEpaOSxdZWVB/w7aTxycrm0SxBfkLlxWVPfH+AlVjV+o5NZKjJsgr88tTLpxW/x/sFqJlyoNgKeUkZBulHbbp3CHfgIPu7JD9R5Ra9UiyDhQJYVoHbw74z2fyAeM+8Ysan8d0nOCafiqKFUKdkLZNREuPXPVVtEJq25P3tNn3knTDmpss18NCWst4xIYBMQ8+VKtK9LEAeSyl1ScRsLE3bpWFvamWsiB27t17sZoOyDgJcqF5GWJHCtAFZ0Q99hvAwp32LSmL+ZY351R1T2s+LiU8cpzUM6LyYWf2Uj3UV7DO5FeHiUHZwf0da6DzdNUPgO/MBy1slgvm/Z3EVYdjGBNW6epuWPnbjE4VSGOzvloSPcnnPgqLVNBIdXIoSZMwOL3DFfgS0iflqDvrJ/hg4Te0dO+NL4lkuEjvXTidUOPn55wx0qkMLy1OlVYMT/r16y0d3qKzJxPn9+0/47+kCR6JRMX+FgYaV86XjgUNf5+RMGF3WkIa7RyXbaaYscUzXFYm8QHIPa74GaJT1rNCWyjvTT1bD6+UuycekKV+kZ/pxY86GErg89/kh7669RKEIIyE1mRfZW4ZFoGTztrWW1hgZL2s3W/BaTWpAn4wC3apxVth5lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(966005)(15650500001)(36756003)(86362001)(2616005)(4326008)(508600001)(2906002)(8676002)(6666004)(66476007)(38100700002)(26005)(52116002)(103116003)(66556008)(5660300002)(66946007)(7696005)(6486002)(4744005)(186003)(38350700002)(8936002)(54906003)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkNIREZRbVNPSjdNUFAyQlZZVGVTOW4vc3htcW9kNmVUM3JUY0U2eTd4cWJI?=
 =?utf-8?B?YzN0dUFIU1Y4azhoYVVHOE5wZFdhN2V2SDdJbmtVMzFER25ocFJuRFJYMzUv?=
 =?utf-8?B?eUROa3V5S1lVRlpsbGN0ckoxcDJFL3lzNkxpT0RpbnhNS3ByVWxaSGZjdzZL?=
 =?utf-8?B?UWo4U0FobzJNV05DZWxycnp5dm5lYy9jZ0tZZ1FPeVk2ZTJNclBhT1dBRHEv?=
 =?utf-8?B?Y1FXV3N3R2lFWkJhdnJNeXlhL3ZrV3BVbHlMeUpyeitxNW1IdGtNVU1XbTZB?=
 =?utf-8?B?eXAzVkJIN3J4Q0Y4THRZTlBHRjE3M2RtVk8wWUlZRWlPUmk3K2JuVmY4Q2RM?=
 =?utf-8?B?bytrY3REbkJiZ3JGUERBUzJuRDh1NVlYekNORlM4NG9jS3JHNys2TXA2U3o5?=
 =?utf-8?B?Y3JJdno3bm1tLzFraGJKOElDRGZ4dVRyRlIxbnJ0MkxDSUR2c3YxMGxTeStF?=
 =?utf-8?B?QVFFb21OU1dJUFBXQVpJQUxaK0c2Q2xJTXBYcVhSeXZGVTNKYlVSMk9jbzha?=
 =?utf-8?B?RjBlWWQrTmtZV3BpZjkrdFBadU1QV3F6eTBlYVFNVlZwT1JUaHVKb3NkUHZE?=
 =?utf-8?B?RXFITGVMWWhUUm5SZnBrek9Fd2tzQi9YcXBhNkNFUFlYTWJiMlhrWHFzZExa?=
 =?utf-8?B?R1RnM1pPVktXaVFHb3c2c2lhdlJzd0JMT1I4dzFLT2tMY1ZyTnNCUlBHcjBR?=
 =?utf-8?B?NnZyTVJtUTI4SG1Oc2Ewd3NTdFVCdzNVNkFiNGhjRkd3dlFyRjZHcHJCaFo2?=
 =?utf-8?B?NUNrYVJKNUU5Z09xSFFNN3lOYkJGRXhyeThYZHZuQU04ZGFyNVhHOXZuTnA0?=
 =?utf-8?B?VDNlOEYzYzBOUGlkQWtnMXBYaUpyUWxnVHVBOE44SHF2ejRDL0l5anNKd2Vh?=
 =?utf-8?B?b2tYcEpJZTVrNktsYUI4WnRZT2ZtQVVaMlUzUWFnTTlVOC9COHlpMldFNVpD?=
 =?utf-8?B?a1pYeTFodFZJUDY1OVRiQjBGeEpaM2lVTjFaUnRHUzFrUjBVbkJuU0hZQ2xS?=
 =?utf-8?B?c0Y2M1V2WmNPbkY2MnF6M0VtQ3hybHU1eGxWNTlWeFVNUkVyUW5LZWtZS2U5?=
 =?utf-8?B?RFFTZ1FDZ08ybGJHQlQ2U2xQWEtpQkNpd3dvdDJieGFFTzVJMk5ZamNPTm9o?=
 =?utf-8?B?aDU1L3B5T3UxZzZzRXE5dm1XK3I4NFhsNElTUUtTK1FEdStTSmRvbkJNR2ZC?=
 =?utf-8?B?Nm8yVGV2RHo2d29qdXpPeWlaREhyMit5THpLazBxVE1hMGhpeHVWMDJtVkg4?=
 =?utf-8?B?UnRMUGVvQlNYYjhXTjlmOGNwU3RHWmJwb2FKTjhTN3Z0cGZOZ0NqKzNwVytE?=
 =?utf-8?B?VGxJbWNaOVdzZ2NnamRwK1NlZkhjeGcrL0t3cFpzYm14b3JsNWo4L2Nnd3p2?=
 =?utf-8?B?blJOcUFaSlNLeFNrQlpFcHl5L3dFZUZXWjlaVWJiWnR0cm41VWRkWEtuZkNM?=
 =?utf-8?B?TTZXY0V2WmN3UlE2T0RKL3ZCVWxVTXhkWnVxeFZRKzNmYXFUVXFtL1dpM3JP?=
 =?utf-8?B?OFhvanZFbzJDQ0dsbVQzMWV0ek90SEtqM3pSOElFTlg2RnQyaC94d0E5aitT?=
 =?utf-8?B?RmRKNDhmaEVSSFR5bGUrUFVhVi9DakNDTnRTWXZWeWhwQ25IS0haazR0a1la?=
 =?utf-8?B?ai9iTTNDNUZrY1l5MG1QVUQ3WlFqT2JRR21zSmVnS2NodnNJWFNtKzVmdkJ0?=
 =?utf-8?B?MGhweHJkaXBBakljYU15bGw4QUZwTGVpNEFmTDRtVWsrTjN3RWYzQzBiR0hT?=
 =?utf-8?Q?mzsyBubwOHMOr4/xt59HvFs0SqvNX+AJpPFY4Wg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1aadd87-d3ee-4582-4328-08d97d83cbdf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:26.5723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POH47aLBcswlaQGauWvZ+jjxTSScoehQGAZUTKVPOVBRPAN/gpS02PwupUia7NJVMlqoX+T2jREowJ4+WtF1tVnDu792sZ3WqcwPf8O+3zk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=811
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-ORIG-GUID: rP7yfpXiTExO4ZQu0VMrW6sdsmRHyxv-
X-Proofpoint-GUID: rP7yfpXiTExO4ZQu0VMrW6sdsmRHyxv-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Sep 2021 22:34:00 +0530, Ajish Koshy wrote:

> This patchset includes bugfixes for pm80xx driver
> 
> Changes from v1 to v2:
> 	- For fix incorrect port value patch
> 		- More detailed commit message now
> 		  mentioning problem and fix.
> 	- For fix lockup due to commit patch
> 		- Commit message includes little detail
> 		  of previous commit.
> 		- Added 'Fixes' tag.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/4] scsi: pm80xx: fix incorrect port value when registering a device
      https://git.kernel.org/mkp/scsi/c/08d0a992131a
[2/4] scsi: pm80xx: fix lockup due to commit <1f02beff224e>
      https://git.kernel.org/mkp/scsi/c/b27a40534ef7
[3/4] scsi: pm80xx: Corrected Inbound and Outbound queue logging
      https://git.kernel.org/mkp/scsi/c/c29737d03c74
[4/4] scsi: pm80xx: fix memory leak during rmmod
      https://git.kernel.org/mkp/scsi/c/51e6ed83bb4a

-- 
Martin K. Petersen	Oracle Linux Engineering
