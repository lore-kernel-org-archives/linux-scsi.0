Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA8CC433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Sep 2021 20:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB752600D4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Sep 2021 20:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhIDUGO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Sep 2021 16:06:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46332 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229888AbhIDUGO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Sep 2021 16:06:14 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 184EF5Cc018641;
        Sat, 4 Sep 2021 20:05:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GBFKRrYQx5FAzBcbf0GPg0A/rD7dCI0zlrpqm/Nyse0=;
 b=PN5b+/A6fGuVMNvn9ZLt2R4aX9PK8V58jWH7WxbUWT7JK1RcohIaa8TLxbhMCeJbXSh+
 SVTi6PO8ex9AAbymtneiFSjmZo2bgddU7ddfUlaIziy9oRXV1ZzarssOYBWms7pEbQrX
 k774cXXscexyj7al3bK/0khDj7wfy7gSUlq2iWj9ClU8oeSq7nURjP6/dpdIpEraXemu
 ZkbukB21voYhzg1aX283os4BwCOEKur7d0KLwPYqMPaTmNmI6W5ShudWVoh8K5aexbcP
 zixohbd69t/Wno5Php0J6hsvP7AG+fUHpFjYwV2GdioXd+CZw7Qy8h0P7Q0MpbUdaSFa pQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=GBFKRrYQx5FAzBcbf0GPg0A/rD7dCI0zlrpqm/Nyse0=;
 b=r1vBo0PT6gYuFz6OIQJhT8koUYGRb2rOHZvFf+YMRaYeKx+MLfceC1ItNXy4B4nMPQos
 JGu3csGLZoseZw8XpfSmYVLQ77bcJELszaHS8iTelfTTCrI32iTQi0dX9CrhIobEgZem
 AChIbiINJR4u2vrgXeeOX2S9FpDs8NsOQZG1vD+I4/h2qzD49y0CLguxAw83s1R1UzhJ
 AUzNmDeZrjv6dPyxtzqsxWnm/roQeHiOGVIA7Yf4xZ3tJbJbWAZwmcYq2TTh+OuH3+FU
 bXXj541jSVMT3Qvj/Xc4oItlFfwTZxvN9QubVK2e/++h8oaYrRmL24AeMLn42GwWvdWD cA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3auyk3sbn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Sep 2021 20:05:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 184Jtw3w058859;
        Sat, 4 Sep 2021 20:05:09 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2046.outbound.protection.outlook.com [104.47.74.46])
        by aserp3030.oracle.com with ESMTP id 3auxuadkfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Sep 2021 20:05:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gr65iUBkkCJma9O16W8WWea0mhfj9tqkCCmbXh6bXOEKyTUdz8N5KxIyJLcHa8J88lAfceou/1SmRVKsvW6VZsB7cOWIM3lCsNJmbqGMcDNcGM7s2vwLiguVNGicPIQr0EwxEvljxmFlgnFjsLUs1ew2Uhd0sb3JtE+ydiFYF85WNO3Ec6jmAJgCxKx8mSd06wx1LH35MIZJ9vuLp31dldu6r1v83HZ1f832X22/LoQZ+PWYs4WFc7++woUDfOYedXf4zalnZ5Y4AF2Jc5RbYPWTvWfWT297ebqMhwptf0Spr2dVpqpEdwIny4dg24CRAntJPzTCWEV6aUmdI+MKow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GBFKRrYQx5FAzBcbf0GPg0A/rD7dCI0zlrpqm/Nyse0=;
 b=LDttFnseHugdqbuQWsc062MJN3r6hyIwdCnt8JSLGuXu/cuxsGrvaz+CTOcp0MrO0/VxDXTOvFTGrNp+S2l2/jfxYAyDWTlUzUkg7ueHTAyjxYmA0P3/SoI+viavd6aPgG3dqx66xYfJ00vc+CGcpHeJ5m96zNYRtsXEacmnoDqyrSIIQ81wRdPZHywHJegN3SsBlw+OXY9R5J/UTIcd0CsU3J+GfzriB4QORw7cNjZsHp5SzdTdg+MEPURDWqi3At3vFWvylCPE3LmAKHrbVbYOMPSucs/bhzviJtVS5XPmtE+Hl+YwVBbQaHpMGT7gSiRZ0mmEhfg6G+12CO6t7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GBFKRrYQx5FAzBcbf0GPg0A/rD7dCI0zlrpqm/Nyse0=;
 b=ryQloMGtVfI4FXTkhR9yHIp2WpRrB3QczBMozSPKu5VN3BVPWaWXLTPeawuuleKfYbdkCtPXZTlBXAFy6jDgoCMhKTsWQeypHqmLj/KyerzPoOsfZHpYNpIVtSdaLfjGqihoFeU6UZ2FSSnBJKvKot3Hmz1Apipezhj3Jm+uGbc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2887.namprd10.prod.outlook.com (2603:10b6:a03:84::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Sat, 4 Sep
 2021 20:05:07 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5cdf:33ab:8d17:9708]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5cdf:33ab:8d17:9708%7]) with mapi id 15.20.4478.024; Sat, 4 Sep 2021
 20:05:07 +0000
Subject: Re: [PATCH] target: fix the pgr/alua_support_store functions
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     bostroesser@gmail.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20210903124800.30525-1-mlombard@redhat.com>
From:   michael.christie@oracle.com
Message-ID: <e3c5d767-6d31-3496-b2c3-d843a9e2d80f@oracle.com>
Date:   Sat, 4 Sep 2021 15:05:03 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
In-Reply-To: <20210903124800.30525-1-mlombard@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0159.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::14) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
Received: from [20.15.0.3] (73.88.28.6) by DS7PR03CA0159.namprd03.prod.outlook.com (2603:10b6:5:3b2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21 via Frontend Transport; Sat, 4 Sep 2021 20:05:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b371749-33b8-4111-595f-08d96fdf4a7a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2887:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB28876855DC7B7E69E30335C4F1D09@BYAPR10MB2887.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: csyThdS5e/APzbw/50ugQkRdd7AXPopFGgPbQvPxlQ30lIpz3lrf5zMNNT1s7ayj+oaOlFrAAoWzreaQ7dx+md56B6Q71e3yCCV/fWIHOXoN9p3rer2tZQ1a9bqFMmQRRUANNo+bF4jW0tVrE7aGzpUBipLBlQB09UCd8ZYUGeMrHZGDlQR20M4+nr5MUV3rlAKkt5C77WJMhf/DUerAXKFo6/V4rQ9Wmc7oeMeZgVw670mUnxQ0Drivhzw548sCu+M8J7Mr7FbcybjlR8EStyiRQgrrMB1QkytFNfrvFMhRIjluhM7qJs8NC/SM7e7LC0wTBt0uYybwxXdXgX0AxXINvurpwpmPv+tXGUX/Y8pruD1cpnLY9gIzqS+4vMQTbEQ/8hFoxz0j9yuFnoAXv1diAER0alvpO4JcBWFzqtK6bIzfU4VvQHpfdtqS/bEwRQumOS6MtzGi+JegHNhBFVipGY4RFkTlfPm6sIpK3RwjUhlpBvzN0A0E/g5Ee1sr9dXmBb9SsMAdtzlyZx+ms5B8oHP/PTrzNvNMVt3/g8HrKL/Cih7qN8217Sw16kfYEEYOx+IvN3psCBJOuUd/PBy1GUxf3hZ5JWD8QVabxgPzVIyimkVqVL7N67TfPm6769gXBm0EDn87hP96uRnL0n8eVBLtXd0alB0YiEHWUWfytrqZb6D0ls3x2uF05uc0HdFNhNcYx1hBjjBGDpfAqotnTIAlydveh9EEfaOA+pU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(36756003)(956004)(9686003)(2616005)(6486002)(38100700002)(8936002)(31696002)(53546011)(316002)(4326008)(86362001)(478600001)(83380400001)(26005)(8676002)(31686004)(16576012)(66946007)(186003)(6706004)(5660300002)(6666004)(2906002)(66476007)(66556008)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzN0UW8yQ0NGNWFFUEVTN3AxYmlLdi9BcnVhanZvRHZsRnFrSjc2VnRiT2ZC?=
 =?utf-8?B?TjhINWdkZlNwUDNabEMyTkRkaGJqejBmZit1eHUrSlJIcWJQNWxuYkM5d2dR?=
 =?utf-8?B?MzdqWmE0MXo1NU0vb2dRd1pRNE9jVWhRY1FJTTZPN3R4TWhwaGV1Qmd2VE9S?=
 =?utf-8?B?aGlwOWtpRGNYR2NOenpIalN1OE8rSU5UZlZJdEZBb1hhbGhvU2dyejZLL3hn?=
 =?utf-8?B?RGpOZkZBYXlSazlMY2RVZFo4N2tFKzRZUlQ4WE81eFlvMXhtTzc4c0UvM1Fy?=
 =?utf-8?B?MG16Q2lhUFJ3RWFqeGt4Tms2OGdhZFpwK2FFYWYwaUdLTURLaE9jMy9hb0U2?=
 =?utf-8?B?d0UzQWw1bEY2a1FyYmdqZ00wRTFUaUh4MkNZdmtjNGNtVWJqUWFpTHhHNUkr?=
 =?utf-8?B?bmtiZ09mU21IbkVoMzJtbHM3Nlo0K254TkRmdWYrWGdzL2ZMakF3YVAya2x2?=
 =?utf-8?B?QytOY2ZYOWZabkNZYUpONG9QTTVFM2x0bXV4ZjhzektzYmxYWU0zY2FxekJi?=
 =?utf-8?B?TlJkL2lyZER2ek1vZmM1aEY2bnBBY3NNNU12d3FTS0twS2h3RWF6ejhVNW9E?=
 =?utf-8?B?bDFZVGxRcG8yMUgxOEpteUptT2RRS2RXeW5FbUZWcXExb3cxcm9BenlrMThZ?=
 =?utf-8?B?ZjRTQWh4YmtGRGU3eG5pR2ZsWlZQR0Y1eGlNRjh1T3RQSGpYWHJCNFVKcUM4?=
 =?utf-8?B?eWpwUUNnRWlVcitVLzhyMnFLd3lHeHZGcnNEY1lFVHFXYklKRTEyeU5RL1JE?=
 =?utf-8?B?MFdxVFBHT3BSOHhSK0JhVzJHLzFmclNDcUx4RXdzNENjMGFuZEhUWGpqQmtt?=
 =?utf-8?B?UXdSSXpMaWVKQnE3by95MzNJSUhLdlJSUGVSTUhLNVVmbnRJQmVvaGJwMFpz?=
 =?utf-8?B?N1A1YkFaZXBkZ3ZOUWoveEdCL2NIUkdwM09kbDUrVUozQndUNW51SkJpRGpS?=
 =?utf-8?B?SXVBVEl5b3hmR2RSNW1VTFQ3MnpPdnRpckVoN3VZWDZCOUJJRW1ZMExYVzQr?=
 =?utf-8?B?aTRjUm9ZTEtrZVBGT1VId2FEenpuN0dMeTRaRVpHb1o0ZnlIUkM2UHZWWi9G?=
 =?utf-8?B?eTE1MWZMNVNhcTlqQW12Yi81a1pJNk5HWXlNM3Jicm9NeDVyTGMrbVJIbU12?=
 =?utf-8?B?Ukd3S1N0OWFBUXRCMkpnNlpDR3MyenV4T3FRdFBER3EyUjNMRHFlc01sYjY2?=
 =?utf-8?B?OTUySTJKYzh2V0JuVXhTZm9ZUlJLVHF2T2tXSWxNT0dpNnFmZmlybUQzdFJz?=
 =?utf-8?B?aE85UjZHTWZSbE9CRy8xcjE3Z1hGV09ZWTg3NGZUVWp1ZkFkNVBDbTFwMXZh?=
 =?utf-8?B?R0pMYVZ5cis4NzNMZExaTk5IWHcvbnc4TzI4V3UvRW1mczJFQkFJTi9TZ2U2?=
 =?utf-8?B?WTdxS1ZKa2NTK3BFWGNzVGdqL1RaaFZKSG5nOTNzNkJSbzRUMGQ1cHpreGVQ?=
 =?utf-8?B?RWlQMjEwcW1BQkdUVXNOU0F5YXJISUpkWWRUUFZHcFFHZEt5S25FK3ArNkRv?=
 =?utf-8?B?UE05MVd6YmY1OG5kN1Q1UVB4ZXBGVjlub1BNNWJwV05HQnhmWFE2RnVpd2g3?=
 =?utf-8?B?em9HQlNFaUx1bEk5R1FxRGRRL0FkTElCYXdUNWtIeDg1UXF1T0RSd21JRUtP?=
 =?utf-8?B?UDdzTFMrTUVaMTRQcU1RNDVMeVdreFhSeGlXMnhQV1lVbkxZakhaV0tGaloy?=
 =?utf-8?B?dkhIRmIwWHU1bjVBcWs3T1poVXBVdWQ3Y0tlR3k3bk5wMUFNK0dCMjcvT2VO?=
 =?utf-8?Q?kJRd1YgyDlO9KG7exSpr0AYfMe0xW3flnWOeKj6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b371749-33b8-4111-595f-08d96fdf4a7a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2021 20:05:06.9277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w4JypdTvMReCez2yP4bai1RfTAaNA/EZnHxmV5QirJ6SrHRa6rlR2DyJsiCeBxekIQOGalHkVtCeowXWQHGR6uriEqIUVAq4y/pglowEDkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2887
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10097 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109040143
X-Proofpoint-ORIG-GUID: qV-3MF7r_l0FW3n0R5yC_v45d7FiuOpV
X-Proofpoint-GUID: qV-3MF7r_l0FW3n0R5yC_v45d7FiuOpV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/3/21 7:48 AM, Maurizio Lombardi wrote:
> Commit 356ba2a8bc8d ("scsi: target: tcmu: Make pgr_support and
> alua_support attributes writable")
> introduced support for changeable alua_support and pgr_support
> target attributes. They can only be changed
> if the backstore is user-backed, otherwise the kernel returns -EINVAL.
> 
> This caused a regression in targetcli/rtslib because now a warning
> is triggered when performing a target restore that includes
> non-userbacked backstores, even if rtslib is not trying to change
> the attributes' values:
> 
> $ targetctl restore
> Storage Object block/storage1: Cannot set attribute alua_support:
> [Errno 22] Invalid argument, skipped
> Storage Object block/storage1: Cannot set attribute pgr_support:
> [Errno 22] Invalid argument, skipped
> 
> Fix this warning by returning an error only if we are really
> going to flip the PGR/ALUA bit in the transport_flags field,
> otherwise we'll do nothing and return success.
> 
> Return EOPNOTSUPP instead of EINVAL if the pgr/alua attributes
> can't be changed, this way it'll be possible for userspace to understand
> if the operation failed because an invalid value has been passed
> to strtobool() or because the attributes are fixed.

Maybe you want to use -ENOSYS. Other lio sysfs files return that when the
operation is not supported. You could then handle all the warnings with
the same check.
