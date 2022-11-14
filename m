Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5018DC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Nov 2022 21:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237139AbiKNVDq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Nov 2022 16:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbiKNVDl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2022 16:03:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75477115A;
        Mon, 14 Nov 2022 13:03:40 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AEKhxK6020210;
        Mon, 14 Nov 2022 21:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=qbXaKX4Z5I0JFgCtjpH7t6AMtwwPAFPn/EhMXIjkGsI=;
 b=nCD+65z9F1UJOhDUKe65/VCGw5Zss7suJ6GX8XXb0NygFFtv2KCEbOymzE872s7JHanp
 TtUNHYjl1RpoaWEwdThZwhKVjHpPmsgurk9uIFWVM7IfoN6FSJMOAZKNX3mSlPpcAujZ
 5EDv8LWWrYQvaT6TrhTQHnkckmBltLH+Teln4mNAaqmui6925RwGfOo4gyziEdazwLOd
 xqt19sXEnaiWf0Ay2Mqn4hkZUhTwmVgnEyKP+/Vlg4UP/yNCUQ2kDdzNAQJ+gWKb0ZpV
 tOQh6laDtN60+YpmNHTeCYFxEvN4sxlIXtqtx64Ao/mNQ52zI3nuvdUR6VHTdYUOMPvN gQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kut2e8p2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 21:03:39 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AEL3FZq004773;
        Mon, 14 Nov 2022 21:03:37 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ku3k5gt3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 21:03:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbGuOBDzaN4XLfTdfxOR6F4b+vk8c2jNTmdRvFDJyr9StHKSU3DpYqkGqh+cTLAQ3mXKtVf8dM1OLv4b7obIE2Kr2riMlFLImGpKzfq+xq22x7Ch2MkO3c4clOm+aWtHsa54cJU8TFrJtIQGCj9sVf5GJTjArlkKCFqkpuOVFr45C+mO/54z/UpXh/Sgttmd8CrOXGn98N/ZrSi0Eg0nFkQY1zrYzTzAbho9PG4e647wt9mkX9fuZP1QK7Hp8T4ycUqcuUTT7e9NIddk4hhx2jtb0mCqJfs/YOQK82zfpRDRvIqXm8G0W2nYwUyyXFY39ZwQf6RZoCF4/jwtWTDymg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbXaKX4Z5I0JFgCtjpH7t6AMtwwPAFPn/EhMXIjkGsI=;
 b=QXpRohKp9Yy+1vpYlXIiqBBOH1gjYH+1d+WtkzoSaXxtdM17I59YCF3ZqOuGxjp3cjxF7BRZiPMIEEVtPRY3FlkBjh33xqUtqCjq8wS8CAHbtytN62wCeYPOEDcyzmWHwPXR/Xjqrmr1UOw2K8ll29wz+Pk8mvmnnwvAE2lp7dUKFosr2aoMLFDWIbHkf+mSeN4sD3FSNwx0pzPbmFu59ckXjo635VzROe2cV7EUpmQQWinBVDEQrXD2t4ON5h8NtFLCVMG1D9qW7vIcNNVwxMCiDzl2jXFgql/JL7sB2Uh8p1+0QRwHwnbRQnUjGnFwbvykK9T2apBEPt2oLSqf+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbXaKX4Z5I0JFgCtjpH7t6AMtwwPAFPn/EhMXIjkGsI=;
 b=gChH/dAC0JR0oZFEl3oa8gzV6HTWe1qnix1ooSMgbkqc8sUwv11Ga7L1fBv+f3TWutrxavHcn+hE+l3gij8HrZWQ+7Tlm5DoNmSS7jhUqs7Z+fM5d4pzRFDR0gK86rIlupYV9TI1Q7R3yaDBUcHVnOUD/ut0A2GuNjHgRhccXW0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY5PR10MB6216.namprd10.prod.outlook.com (2603:10b6:930:43::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.17; Mon, 14 Nov 2022 21:03:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 21:03:35 +0000
Message-ID: <b3e546f1-ce18-1144-4a60-e98f35165a6d@oracle.com>
Date:   Mon, 14 Nov 2022 15:03:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 0/3] Make target send correct io limits
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20221114102500.88892-1-a.kovaleva@yadro.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221114102500.88892-1-a.kovaleva@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:208:c0::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY5PR10MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: 7eb048cd-2c77-4a08-7886-08dac683b1d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ffpIVYgRpu0l5TkXh4xrsnCaRH9nKlFg1cC4LgSKgqI1mJtRSq6k/pVdruL+ys4wBHWvdeZYWgJmeq0vyFQB7RfJrjEHDHa5exDai2yyly7/HNsQxHyR17fMUumBEypPe6jI9HvHrTOUXMZcRt2DRD9+rgN3zwWyrro3LEsxWhzhxADts6eCOY08yWSWkMbmmnxW6jCxyRKFjvzv/J+ly+a4u4ezFjPDsOcjhy1mXg5suOYlXffi+j/Yq+bvMGZqrF9P30eC9dQgzO/aNAYwcvK/UrKbRASfH7XFaMqkyKfU1CaVLJbgD3ih+o6gQyXllDDPLblAF0JjBJ97FrAuizWAprFGJuzbFlgnl3+6sMr0Is7WMkyqJNbQsxLtoIm9IxhePYNitgfaBXb7bO7k5P3DYxtVVC0aDboPAg4u+BfQmV1xU+/BiGUh8kXIv+xZ7GgoveL/s4+TKR/qS6jIh9462UDUNrz66rDHy3T5IYupD+ZBVfZz1qh0/FavG+C/PLjKoDVHGDsRMWw32VPqjIcB5Te5OHd8VOzAUzi2kwubZsl3HwDbkDrCAZ5gEpdLD2kc5seWhegU2dRTlpD/EQwItGp1YENMfWpYRG+c+zTTrMe8QoDxCJf4JBzHqRT16/qkhw7lgM8VhmFfi/pzVe4nKJfs55ZROF22y2vJTINpYUHKyWMXT01h7N4QtYTrpHqGq64+x6xvcCWAl53AX8c+ZbJT8UjSWRh8W3+7s7u4LFsjk+WjfZmVjhLMwM+q9rowqyEPX8+5k8R+eM59ovgnkJFdRSY8uhmQnyWnys=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199015)(31686004)(2906002)(8936002)(5660300002)(66899015)(36756003)(66556008)(66946007)(316002)(8676002)(31696002)(6512007)(41300700001)(6506007)(6486002)(26005)(478600001)(4326008)(53546011)(83380400001)(186003)(2616005)(86362001)(38100700002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXFCK1BDeUlpM0dNY2g0V3dxM29xeUZ3VmZXc2pNdEhLcWhzQ044ZVpNSTMv?=
 =?utf-8?B?Zk83d0lBUFNnMU40TWR2ZUt3ck96R2Z2ckE3MG51QWJqUUNJMHZLNEtnbnU2?=
 =?utf-8?B?dDdDM2dpYVFsOVkrNzVnTDdEMm5BYUc5ZUxha21kTzBkdmJpY3RaamlVVytn?=
 =?utf-8?B?UkV6eittdTIydWJ4c2xrRHlxa2lIY3E1bE4rZERjYUdxL0tJU2VyUW1TS1FL?=
 =?utf-8?B?UnFzZnVOeUMzWm1rN3hHcG1aMFQ2T09HSU9lTWlrTk1hSjBHRnN3Q2VRYjd3?=
 =?utf-8?B?QmQ5ZkwrMG9haTVXQlNScElhdU1vOWNnc0MwSzJSc0JYck0rMmlJR01xSlVM?=
 =?utf-8?B?Nm1xaXJmbWFqUTIydlFDaDBjOFJQUE1oK2N5a09NYVV5MFFxM2xoL0Noa0g5?=
 =?utf-8?B?WXQzejlSK2ZaSWI3YzJ5WWcyY2tmQnZyOEpPYytQY25nekEwMGtHNVROUEJE?=
 =?utf-8?B?YlQxUTRYejMzY3dvNW1PYmM3azc5eXdaeG5HZzhUSmdFZGVTc1ZVYVA2dGZh?=
 =?utf-8?B?QmMvL05JMWJVMlNOMzdvNUpPRFJUQVlvMkdLRHlIY1o0TE10U1Y4bWdXc2pT?=
 =?utf-8?B?eGNuRXpSMncxZy9UMUZPS0kvYWZWUkVzMXFwMXRWMHB0UFVxS2Vka29BcnRv?=
 =?utf-8?B?QnhEU1FuVEEyRDRxbXB2VFNtQWh5akdleUUvV3JoZzRLV21HYXJNOWxoc3lM?=
 =?utf-8?B?dDZZR0VkUzFkTVhBYU5IZk5Sa3pmMmdWWFpEUXZIQXdWcWdUNUlIQys1aEg5?=
 =?utf-8?B?K0x6YWFvaE1CdzNGS0pkSlI2ZWZjd2ZoNTVCZ29IYnNHN0E2TzR3Q0ZBRHlN?=
 =?utf-8?B?eUt4bC9BZDVhZ0xlTWZQYmVYWWlSTnJWbStUOWQ5djZYcmx0OWdyc0ROUHUr?=
 =?utf-8?B?WDExbXFyWHhvLzBjaHY5OEZ0MCtVcHMwcTR4NjVBTVlFelU2RExIMCtrWW5o?=
 =?utf-8?B?SitqOHJWeXJuUU51NDRRTTFFb1V2eFVZd1dZVG9XcTlzaVgwTzZqanROYU83?=
 =?utf-8?B?MmZEbVhvVTArYzV3aVdVRmtnME1IcUxlUkcvekZwUW9za3FLY3A1YWVXZVda?=
 =?utf-8?B?M2NZUmM2eUp0eTNlWHV2YlNGZ3REOG84aUplcmg4cE9jcFFUY0p0WjhUbVhX?=
 =?utf-8?B?TVRPaG9zTExyTmJUbTFlbC82S3duNStDckFLUUd5UW1zSE1ZNUY4VCtvQXpP?=
 =?utf-8?B?azFvdnNvbE52S2hQbEFtU3d6N2k3aGdjZHlRZ3A5ajZSVzJiQVpZMWR5dkcv?=
 =?utf-8?B?Z0M3c1NOaWxiYWVodDJnazdGeXRZYWwrSFhaNUNhUEIvbXk1QTJEZ3kzSExV?=
 =?utf-8?B?M1JRNXFJekgrWW5IcVI2dWZpaUs1VU1xV084WXNYR1drb1RKWkk5Y2VnQUJq?=
 =?utf-8?B?SnQxNlRqcE9wTXZKVEs2MHVQMTRrQVBQMzlQSUpvQSt1THFOS3hKaDY3Z3BJ?=
 =?utf-8?B?RG5qNktKdmZ0cEpJTVV0NTA5cUxIZDlrMGhacitwWDZZd05aYnc1cjM2cFZK?=
 =?utf-8?B?bW9wUnUrcFdRMDNwR2YwNmtOV0RUUFlxb05CVktGM2F1SVBnWDY3RTl3NW5u?=
 =?utf-8?B?WTYwRFhBcmZkV1UwT2luQWQraHlPQnhrTCtVVDhLVXF4a2VpUDBJcGc5eTBz?=
 =?utf-8?B?WWpGWGVvbVNNZHFwM2gvaUpQVmd6dlVINnJ0SDJYa2VYL3NOTXJDS0hQMDE5?=
 =?utf-8?B?a01aZjBkKy9YdlFDaWdEZUs0REtQSmI0bUxMcnJ5ejAwS3ZWbnFiL1kyY3J6?=
 =?utf-8?B?akliNTZkZDlCL1Q1cmpDd0JwWFQ3R05XbURGQ253ZnlDMjI1dUx1Zm1FaU5Z?=
 =?utf-8?B?MVNQVVNENitMaDREQ0Fmc0wyeURYeGF3YkFxM2hlcXEvRHJGVzJUakZTTGJy?=
 =?utf-8?B?SDJONktkL3QrMFhaYmhqa283eGVkV0prdFV0UGNsR0IvZDNjYlhZM3RldWV1?=
 =?utf-8?B?NHAydlViOG05VUxwR0JIK1QrZy9lSlg5WkFtS05XZWh2UTFxSjE3ejhoK0tH?=
 =?utf-8?B?TmJNOU94dWhxaGVHaXdGR3BOY1hlcXJ0bkFKbHlvWngvdWdOZHVRVW1nV2sx?=
 =?utf-8?B?MDFPMzYxd2UxKzUzSGptVUR2bWdaY2lJOGRKK3pTdGxoTEZtK2xpOW1SZm9h?=
 =?utf-8?B?b3liNVJrUWwzUFdvU1RDTGNrREZIT3RLZHpkOTJpakN3NGlwZi81cHovV01r?=
 =?utf-8?B?VkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: q0mnxTG3BNuXDHDE7g2yKSOGoIQv3oKcvLLXfBj+QWMp6UOd6N06AEFfQRTutv6ksWF4aN5WyFvCWHht5lx6dlWB4xCHpTWY2F2o2UxThhbo13OWLWkig+XpN+wX7vnHBJ9nBelH02W9dSVmld4MvgqP1Gx3fxlbptQpkor80NyHWxrluYbdnWWBHmf5AJOH5MUkS4Q8C79rQzy/OsCfKV2YBtqkHsNnSzQgXC6TlU3Kh1h4kiDhGsJim7YLMHDUv+Q7j9G/LGXdOSbAabfEqY3HWOsIwf6FLooEPqjOIT1ur0Kvy5Ko7W9yNgIB2pporLNsdZVLc4nsmkypCGncEqS3493ofQtK962g7a9NqrvMb/XFO/wV9LohM3OG0yjbVUHcoB0LvnHg3ooL3pnj+jiiUYed1J+fsPHc+AyEPBowzwp8jkbVyd9KwIyzfVI6SV5A7HD6cp/14T9xEg3j2KVpBLTUwWCAjro1wltnJqtJy8T4YfwTb3NpbA9220VJjZod7Y+mMVLw16Y9eWDoJQQLvvbPX4/Gwdf5AMUO8wPDDpu1JGakHZ/QqdKZDd0CdLCwrOkeyfQdzfYhF0iOlQWOMZrRiu7h1kvffsFJrKadZgD4l7huSYDOQH7zHB8bqn1qzj1sVc8twsiTlPOe/b0DnSwCwQftA8zfv5X94orPXzBzdDcTUK6O0xfA2ZykHuq0ajLo1M+VE3Mk3/eo+kTOsZet/3hPNzI5uh2YHRq9HOnlPsUtyGn9WTXwqB4550cLmpTep4Bri2Epk5fgZhr8ePeh9Ux61ddB4vOkYGyIU0ja/4iNMihVsnk8NreCxaySNcCQKtg7cRhvihBRaiLzzixbscMF2xxuy+9yB4k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb048cd-2c77-4a08-7886-08dac683b1d0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 21:03:35.5403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KO8aD2W7KfunHGP6cNZ7GI8/7JHirNZS9yLxSgQvgTpCdfi9ofANUIchrqWH9GB2T4yUyz4iMC/XpjcCoKdZtW3IVdDIaqIZfapy5ay8z1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6216
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_14,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211140149
X-Proofpoint-GUID: EyFDnq8uW7YhxudxSOLNvmomT7_IS249
X-Proofpoint-ORIG-GUID: EyFDnq8uW7YhxudxSOLNvmomT7_IS249
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/14/22 4:24 AM, Anastasia Kovaleva wrote:
> Currently iblock always reports MAXIMUM TRANSFER LENGTH in 512b units
> regardless of the LU block size.
> 
> Target block size:
>   target:~ # fdisk -l /dev/nullb0
>   Disk /dev/nullb0: 250 GiB, 268435456000 bytes, 65536000 sectors
>   Units: sectors of 1 * 4096 = 4096 bytes
>   Sector size (logical/physical): 4096 bytes / 4096 bytes
>   I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> 
> Initiator block size:
>   initiator:~ # fdisk -l /dev/sdc
>   Disk /dev/sdc: 250 GiB, 268435456000 bytes, 65536000 sectors
>   Disk model: nullb0
>   Units: sectors of 1 * 4096 = 4096 bytes
>   Sector size (logical/physical): 4096 bytes / 4096 bytes
>   I/O size (minimum/optimal): 4096 bytes / 131072 bytes
> 
> target max transfer length limit:
>   target:~ # cat /sys/block/nullb0/queue/max_hw_sectors_kb
>   128
> 
> So the maximum transfer length should be 128 * 1024 / 4096 = 32 blocks
> But the target sends MTL in 512b units, so the initiators see 256 blocks
> instead.
> 
>   initiator:~ # sg_inq -p 0xb0 /dev/sdc
>   VPD INQUIRY: Block limits page (SBC)
>     Maximum compare and write length: 1 blocks
>     Optimal transfer length granularity: 1 blocks
>     Maximum transfer length: 256 blocks
>     Optimal transfer length: 32 blocks
>     Maximum prefetch transfer length: 0 blocks [ignored]
> 
> This happens because MAXIMUM TRANSFER LENGTH field in VPD Block Limits
> page is derived from dev->dev_attrib.hw_max_sectors which happens to be
> in 512b units for iblock. This patch series fixes this issue and removes
> some special-casing for other backstores.
> 
> Changes since v1:
> Sinse the v1 patch series, some variables was renamed, the checkpatch
> script was run and issues with debug logs was fixed, some refactoring
> was done.
> 

You forgot the tabbing/spacing issue I mentioned (checkpatch --strict reports
them for example). It's probably not a big enough deal to hold this up though.

Reviewed-by: Mike Christie <michael.christie@oracle.com>

