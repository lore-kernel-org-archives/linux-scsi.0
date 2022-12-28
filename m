Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A69C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Dec 2022 10:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiL1KP2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Dec 2022 05:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiL1KP0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Dec 2022 05:15:26 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04olkn2029.outbound.protection.outlook.com [40.92.74.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0050F120
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2022 02:15:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKiQTJQo7HzQThjyVfZkB3hubP6xGd7vwAOPmCHrUGd4imelQ9Nl3bLkDUMF4U+MkFYE99s+omGkeVOqF7rBcN8oGnbZ3BJSeQtzkVcQ0j+Dx0+gpYZli+KyV9j8ZE3/mdu15LZVwjJ1KIm1WVIYvuZX46ZZYYmd7Ig/UJVm7oWwMjMUk0dm4ZMmcOHnjAPD0GN+qCbPCDMelkrgBpsQeTxoqeA5TkzyjRKOWCLzgHqOUgLvhS/VotAdZobgLxAZzvW4TRJMoV3LbCUlyOSdk0H93VM1KLAX8soD1flNtNCI7gb8B52MWpxirK8qPut0+POtOipIEURkehGf+Ipohw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LD1u47ftDyuqxjZr3ZYdhl48kYd5LlbLJyguO1RF4SA=;
 b=ZApoNvLlfP6POZXrIVrpb5V5lkIm8WZRuaXfTI4qG+PHiAEYl0mR4ubZbefeZBmX0TkV7ycmPBjfZ0ul6tEEiiIQLZlobz8MBzS2jT1zMoB0r+3da8JTjESf52WhYWPh5NOCP5szQZIRk9PPy6B+BKFWSfAMoaw/0zkraWF+6ynqcc7MU0vr8SAuol6decxPcjnvgZNwoulPu11IlhqPZ2ujU+Nfarwdq0JlpCej40EMPTmVqZMh3GZt2USMPPw8Bnt+xEaSeqh8cAbcDAVz2gQmynIePVSU73eV30T00l2eJPbkLKwCJJmGwRd2e3Z/BLGlOgQHhg6sY2w8L6skrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LD1u47ftDyuqxjZr3ZYdhl48kYd5LlbLJyguO1RF4SA=;
 b=UIPbfwsCtNujCtZz+666IoDCn4lmDKhk9BQXoD7QUdvfPMjo+sVFivdNSnNLxYxHfSVGZSriQZsmEJj8sxzfd+WbXlrapNI+tKkYnu/G3VpIW9xZmKHKAp3RLqL2R+8xD833YV+ttYFQ6eAkfR15H3l/vDg9Q22Egnc3KRYLrq28761xrYMVInb9i02hUJua7WndjGLerQr1lvUWfyPa51HpB4jc+40y3B1fPVj+QkTrigy+/0X9l/K05WEP2hisXZ3mODGE7joy2Icogz9I5Wa93UicZhAUZHG9GH0i70M9Wx1Z3qF3T5lVkgjqhBFWi88Dyxz0tJvX60QmDZ30rA==
Received: from HE1P18901MB0138.EURP189.PROD.OUTLOOK.COM (2603:10a6:3:9b::14)
 by AM0P189MB0785.EURP189.PROD.OUTLOOK.COM (2603:10a6:208:19f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5966.17; Wed, 28 Dec
 2022 10:15:24 +0000
Received: from HE1P18901MB0138.EURP189.PROD.OUTLOOK.COM
 ([fe80::ff54:f6d3:aac5:b8af]) by HE1P18901MB0138.EURP189.PROD.OUTLOOK.COM
 ([fe80::ff54:f6d3:aac5:b8af%5]) with mapi id 15.20.5966.017; Wed, 28 Dec 2022
 10:15:24 +0000
Message-ID: <HE1P18901MB013819B9A535CC7B45E7C5C7E0F29@HE1P18901MB0138.EURP189.PROD.OUTLOOK.COM>
Date:   Wed, 28 Dec 2022 11:15:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
From:   T_chan <t_chan4958@hotmail.com>
Subject: [Question] Cap Sense data at 8 bytes or not for SCSI-2 ?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN:  [KD0ResPKTL2fKPg4DQIi30J+Ir6EbNdJ]
X-ClientProxiedBy: AM4PR05CA0036.eurprd05.prod.outlook.com (2603:10a6:205::49)
 To HE1P18901MB0138.EURP189.PROD.OUTLOOK.COM (2603:10a6:3:9b::14)
X-Microsoft-Original-Message-ID: <1bc0611d-18dc-eb8c-44cb-bda7cb478028@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1P18901MB0138:EE_|AM0P189MB0785:EE_
X-MS-Office365-Filtering-Correlation-Id: 470f99ae-79ec-40fc-aac5-08dae8bc6eed
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PSkZ94cgvtAJXdJKA6qZcykWN6cJl9X137rc8ZnRSCxpjhTKr98De1mvGYr3gke9oeKhRZhdZSzLnthnzgmUuj0ZUE9hQKgxuNDcXDDABJ8Y4maCFaLwLzmfuhX3NE9fREzBpQUb9oS15YGgCHw/hXdcZbwQeUBIIlYewo25f9Kr1yxpHOYmv28NQEjI7cLlTVYsWTQd+sGgLQbwsFmTEbTXFjRMwyaT+EXOo0Kamnw06wt+2ltiPC0FDBQzZVljUYTAKF3jhKP1jVPbGh+80wTTHzWxcfjP5tPc85kkwC9BvC22tv/oIBpnCeC2DW5WjnYu/AKBOwpUMajPIPUMbR1bNB9Nj0nh1zca+3OQnUw1StZn4MOLN5sRje1CaBocbCCOytqMi9BoHDIAdcP2ZZZUDMBycFCq5a+z9KMPzV0K94YtELcf72g+fOFYIC41jSCspDF/BC8w39UPAtraYLm+cZW7C+pifarxkcSkTUIZqohxqV/62RKWLa4Sw8X8/BVk0yMHCX7dA/Wqcf/5MWhy8h+CzPryfSD5eWK/g3QYtqRBI7PHlUXFDZ2JQ7H3iwBCtZSi1PlPkvqIRtq/YEr3/beQTHu1s07KM/kaCRs=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2V3N2xqQ1VDQU5CbFhkQ202OFFYbUdZdWhFMXNtQ1NSV2VUOUZZR1NpU0hq?=
 =?utf-8?B?YUFIeDROdnIydEZqY2VOSGhZZHlXeWgrWFozdlFPM2hIQ0pOOCtyZ0tWd2Ur?=
 =?utf-8?B?TGZZVGpaMUJzQW1YeG5yMGxrWndYdlJxQ2pGbjNwWGY2OVJwOXM2RFhxSG5v?=
 =?utf-8?B?YTdNeDY3ZVZlaVNQMDR1Y0xPVFJWUTh3SGliOTM2aHVaMHBSNGlaTXlaUHJs?=
 =?utf-8?B?bmgwNjBjMEVyTEJTS0tTc2xMRndLTFVvdXE3UkcxOWRXMWI4L2VaZnBVOFJU?=
 =?utf-8?B?Z0orZkJSdVlSb0dFVzJuUmVpT2NaRlI3WDNWcTQ1NE1FK1ZaU2VtbTk2VHBB?=
 =?utf-8?B?QVZpN012Y05ZbzNLU1ZydzNJQTlZc3BNb0ZCTkt6bUplQjZ4OXVjN0wrdXh5?=
 =?utf-8?B?MWt2NStqcnlwbk9KR1M2eHg0UERTQTA3RnZsRGlHQzdTMERudXZUVDE3VEI0?=
 =?utf-8?B?YTVTc0g0WlNPb3VzSmwwZlVlUUFscVhzVS9NQTMyeTR2cTJsRGZjVVV2Witn?=
 =?utf-8?B?Z3hGOWJLUlNLQjNSaTZhQTNMRkY1UUcxanNSUFo5Uk85THpXOWJobmh3VFd6?=
 =?utf-8?B?clFqcURuWTJTV1FQcG1IWWdqVXdOYVpmendoZDNVeEl6N0dKQmVLM3NTazhI?=
 =?utf-8?B?a2sxaENhbC9kYmpRY0lMeUpwNFVaaDZUTVRJZkFVczdWa0NPTmdTNXRnSlV5?=
 =?utf-8?B?RmtuM2ZiODRXYld0OEh2S0tWVnUyTm9zSXVLNXo2R3QrNCtONU9SME1mNEcr?=
 =?utf-8?B?aCtHS3ZZM0RPbE5sQTFtdW52amd3Z1Q0dkhUOHdwUEFzaGtKZDF4TlQwL3h1?=
 =?utf-8?B?eWxCTFE3OGRPcUhUd2RZR2hDZ29nQnBSRWlJRk9Ka1RITW5wcGo5ZnVJSjZJ?=
 =?utf-8?B?K2Q5QVVhNWprdkMzNXFFSVNlSXVpQ2xPeDNyZXkvbllYRzBKTFJrV0s0Vkkz?=
 =?utf-8?B?bytuSlBnV3RJdWsvNE5ZVHI0cXFCYnRxY2MvMmRpOUkyM09NaUdQSk1oMU11?=
 =?utf-8?B?aVJCYzZYdmZlb0FvT1FDd3dFUUpLRktVOVVsMVNqWGhjVFBqYW45dWFUbUtj?=
 =?utf-8?B?Ym80L0dyVXJTU3lHUXorV1hucjd2T1FNbzNKVWVnU041Z0dSeEJNSnc0Znoy?=
 =?utf-8?B?R1VoRjIvZjVhOVFDVnFTL2FNanBBenl2SkhldzZKLzducWpVSWpqMUlLQVlk?=
 =?utf-8?B?OUtVaEkyTGRzeGtvOWYwSWlsRlJieXBGMU1YRDd6dS95eEhXR2dUMnlsM0Yr?=
 =?utf-8?B?SUhSTGlhSU1oa1k1UHlJOVZtT3JPNi9MYjgwZ2ZCd3NJZWVNOExmY2dSaHRz?=
 =?utf-8?B?Y1NsSmY3cWlKYTRJa1JzNk1nQVE3bWFuVDNZTkZDMWhtcnJmMDJlZUxhQ3hB?=
 =?utf-8?B?WDlXL0FyOEtjRmNQYUEvMnV4anZGa1VXMmU1K1FvZ3VkcytOZFBsdmtMemo2?=
 =?utf-8?B?OE53eVNJdkZ2VjlLMjNJRUROYUJTZkdud3ZYYmZ2K1FJTUFPTTJrTUlVYzFI?=
 =?utf-8?B?azlJVXdXSWFmWGY4aVMyeEJNeWFvQWhSZTNFWURiVGJSZWtXQ1BoUjh5Y0xK?=
 =?utf-8?B?NFZHVmU4QStINFI1TlN2d0lmTG9DQUd2Sm5LUmhYbVBKb2pkZGV1WkVNenFT?=
 =?utf-8?B?dFJvNDRXcnNicWhzVS83UlRPK2lYUjZoSVRYTWVQdU4wOHlHQkc3eTlqZHVi?=
 =?utf-8?B?WnFycS9iQWVNRDZsYWhBR2tLbHpJcGZxd09RQ2ZLUDVnNGcwTjNBdXpnPT0=?=
X-OriginatorOrg: sct-15-20-4734-24-msonline-outlook-c54b5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 470f99ae-79ec-40fc-aac5-08dae8bc6eed
X-MS-Exchange-CrossTenant-AuthSource: HE1P18901MB0138.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2022 10:15:24.0942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P189MB0785
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

Should the SCSI driver cap Sense data at 8 bytes for SCSI-2, when 
'additional sense length field' = 0 ?

In 1985's ECMA-111, the default sense data length seems to be 8 bytes, 
but in the 1993's spec of SCSI-2 it seems to be 18 bytes.
What I found related to that the SCSI-2 specs:
"Targets shall be capable of returning eighteen bytes of data in 
response to a REQUEST SENSE command."
"The additional sense length field indicates the number of additional 
sense bytes to follow."

Context:
I'm trying to make old (non-mainstream) SCSI-2 hardware from 1995 work 
with Linux, with Adaptec 2940 / 2940AU host adapters.
This device uses the sense data fields "Additional sense code" and 
"Additional sense code qualifier" a lot to check the current state of 
the device.
Under Windows, I have no problems.
Under Linux, it does not work, because the sense data that is returned 
is capped at 8 bytes, and those 2 fields are located after that.

Example 16 bytes of CDB, followed by 14 or 8 bytes of Sense data I 
intercepted:

Windows: requestor asked for 14 bytes of sense data
SC_EXEC_SCSI_CMD READ_BUFFER (0x3C)
3C 01 11 00 00 00 00 00 10 00 00 00 00 00 00 00
F0 00 09 00 00 00 00 00 00 00 00 00 02 04

Linux: requestor asked for 14 bytes of sense data, sg returned 8 bytes 
(checked via sb_len_wr returned by ioctl() with interface_id = 'S')
SC_EXEC_SCSI_CMD READ_BUFFER (0x3C)
3C 01 11 00 00 00 00 00 10 00 00 00 00 00 00 00
F0 00 09 00 00 00 00 00

Thanks in advance,

T.

