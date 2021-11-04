Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975F2C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 15:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FA0B61215
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 15:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhKDPYZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 11:24:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4348 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231215AbhKDPYY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 11:24:24 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4F5D93008911;
        Thu, 4 Nov 2021 15:21:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=RYk1+5O85V4LeBTb1GanvlN14iz1qI3xvPQKcCiEXA8=;
 b=dbVotqeqlVx9TIwrc0y5bvWMHJmoaY9WvnrpRrhNLSLSdG/tWpr8keX+yYJVQjDx42JX
 s8rAk7POhJ/JPKM0EpY3rQP5X9cIcVpTrN89mE4PPiyOv1r22YrLE+VrJVoyHmfJ1SZV
 8es4IzGOtSEUtYrbjNXn2svJobJEXublW/YxMwqQmTujq9PYpXMJ99sO639/XmULjYva
 ezp12YfitlOkfaGv6CYjicSZilmyMGwUWIKTW0clzPVn5M1o4A90APYXfFH0kFOtMHyT
 kuteQzOdaldOptnf1lrHEX02dxEhFkOo/Q73OwavEamVJSzhxCRR1RXs3GSjCrthoHEL TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mxh93kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 15:21:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4FGZI8011317;
        Thu, 4 Nov 2021 15:21:42 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2176.outbound.protection.outlook.com [104.47.73.176])
        by aserp3020.oracle.com with ESMTP id 3c0wv7x8t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 15:21:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cyJ1QGHzbXtLDot42+mvCDmR2hJQjTlBKSD0nx3FEiu0ocFoTd0UJzutIBYV6Xovkny50xfMXCy6eYUvsCQPNRMohHJGQDoZ6WZirb29AANpGz6vWzdS2aLuFXm/aw4S4o10b79+6/SmoPw2Cbqhm/zIHArPdUbo9ltIyOGJmIEZNdCyg8DW4//G87QAHUV8gPb2yEt8PuGFneh3nnQJ7eBO/FP6AmukumSZbPbAkrASH4DUkQF5H7vkggdVoxVvhvFpLhCVxA7tPE4G/fqrZvYZTEfZtZo3f6vLel+KlHt9QWJaI07UdvXZoW9bDzwXmB5otOR8MBjCvKBgPbUpTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYk1+5O85V4LeBTb1GanvlN14iz1qI3xvPQKcCiEXA8=;
 b=INsYCz6w9CJqC6TYo3eWhprIG7CkJgUEgo4doPsHnxhqQ/e5Of+mcsC3FFsoL7wOAYddABfYJfNYCEP6mAXIaYtcsLQq7d3vSeAngu52rtc+GCUEIzff0GV6abKUGX2m31d1few0r1SZ7rUUp6TOQfbEGUiJO7H0ZA7xvRH6Ma99yXrq/AXGbcx2M+SF8mDXQKvaLLMVYT05m5OHAvrHAVeaODB3EMXo4LsPuuPaArUIrHvG0cfe6GrRjeJ2rr1HEacFm46jGDICqnRMP9Ct4C6ha5XKDfLEUetHGbydWEYgizn+Z/qNrFzBEGI6Y3/9BzN3xmMKJDQpTLApRfWUcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYk1+5O85V4LeBTb1GanvlN14iz1qI3xvPQKcCiEXA8=;
 b=QGpIziaL6a9/Yrmka0NTrEnDl/jsJcrgoCiYj0k41yO/TtnbTCJcGkEkDoSb4wVWVekfo7m0sZuq5C+G7nlpmYd9aHR+VaDnbIkJMw1HvyogQrfbjBzgy/NXIKbLuUxxS0RbbyUZLqm4wg6SufQF7/GFWRWh/yfVV81X0gSw6aY=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN6PR10MB1857.namprd10.prod.outlook.com (2603:10b6:404:107::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 15:21:40 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e%5]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 15:21:40 +0000
Message-ID: <5a8772c3-7999-4675-59fe-c20ee2d66510@oracle.com>
Date:   Thu, 4 Nov 2021 11:21:36 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] scsi: scsi_debug: fix return checks for kcalloc
Content-Language: en-CA
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
References: <1635966102-29320-1-git-send-email-george.kennedy@oracle.com>
 <YYN81hZyBZ2dU3Wu@kroah.com>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <YYN81hZyBZ2dU3Wu@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0235.namprd04.prod.outlook.com
 (2603:10b6:806:127::30) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from [10.39.233.139] (138.3.201.11) by SN7PR04CA0235.namprd04.prod.outlook.com (2603:10b6:806:127::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 15:21:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8055167b-e9c0-47a8-1706-08d99fa6cd03
X-MS-TrafficTypeDiagnostic: BN6PR10MB1857:
X-Microsoft-Antispam-PRVS: <BN6PR10MB1857F08EC14AC9E83D6A67C8E68D9@BN6PR10MB1857.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i0hiGGP0zuAflTXVFGRlxtoUAxvyOswGLXNscshLMjjtjVXGwdLuLkcylcbpXnZVHlB2VCGaTYvvZu5HNb94ncnt2mNS63MiJ2trQ75VqGtP4QBaUZN7WbvGpgdEgWbUiENDdVZkOaBD5IzsRE10ZAPMkoB+Nl5UeBg1YCgCC3IyG8OkWYBLMQby74aI8CWiOAxKk5E8m29EwKhlVE3gF8IOPVL74fNtBJ4+q5SNmiT9ilK8if6KCMTMGOH2fvNZQSRMJXodmt4dfXuKBa5DiyI8m9Yp9p2K83WWgeM6nnh2tvPd8J+TMA6W3Z7MhgczrXBK7pYmMiLYqHpwYF9FwrmHQGvwZb/oEDE1ql8PF8whUSwz98+7GEiUdtybnOlNI6WHj4PzNNx/ir4xhpyApHUOlRVIoaBcGMtXCx0djSrq4vGaSd9eDO/3E1FNqIWB8Rl12dIRcIMp6cf5n/1zRLww8P55FEPoz9GiC7Ha70fk4HjKS8jBA8mNDTOsNlVZukHnyfij/s8gzxfR9n4rbacjm4WVBcHuSfVYZWDmVgZQdDfhg6eCBKGL901KyMldhP1mLMdG+ZWirWSxG1NWz3Oj5bk42vz4wUHzIPx1wuH+qk2nC/jAo8O2fz1fpaMSO4kdtYHKUJb/jOBMiDrcNn5HUZ1lsBQZsMq2LxHlyIkexj5avYetwIp53qB4RCxL56vGMETmxaiMotUlwFouYtvBHpP5kXgrwyzS8FPOQeQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(107886003)(8676002)(508600001)(2616005)(5660300002)(31696002)(66476007)(53546011)(956004)(8936002)(66556008)(86362001)(66946007)(36916002)(36756003)(31686004)(44832011)(186003)(38100700002)(26005)(6666004)(2906002)(6486002)(16576012)(4326008)(6916009)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THVFRWpmQ2Nja2ZlU3BSeGpuMVIrcEVQSjFqU1V2ZVRhb0laVTlvczBOSTVj?=
 =?utf-8?B?aEdTc2YwRjdsWEpMd1ZZT2wxZU5YZDBoWkduU3I5eVg1cFpEQ044V3ZnYnlK?=
 =?utf-8?B?UEk4eTJpQnQwSzBHRHYrc2hoMHlGQm5aSGt2cS9JUHlNL1NwcEtDMWZST3Bp?=
 =?utf-8?B?SDN3R2xYRlBpY3Q0TFZ4R3B1V2REWHdiT2FmSFViZ3lndEd2Ti9QK1FpTlB2?=
 =?utf-8?B?Y080WjBGVXprd0hIZGpYdEtibG5vNW1zcFBsZHVqTVpwNGlOT0Z4OVlVTElq?=
 =?utf-8?B?d0FMRmJDQUlEOEFNbEprYkZJTENENm9TaWpwUzEzcDdHRWJLelgwZWFQRG1j?=
 =?utf-8?B?ZkxRZ055cWdKZ1NVR1Z2c0s1ZzlOZ0c1UjQrVU1LRnhQVDNqRFlkbExIcnhi?=
 =?utf-8?B?Y25YRVdrTGhPaXZmTlZQQzVpRHZsVjBQREV0RDZXaDF3VC9mMjh6a1R1d1c5?=
 =?utf-8?B?YUdSaVByTGlsYU1ScklIM0tCVFd6NGgyRitlc2wwMUZKZTJYdGlOd3c5aURS?=
 =?utf-8?B?QmlWeUQvRnhHN2ZjN01LVktPY3lrbWd3OUNLYUR0dUtWSUxWUjJKcWl3aWc2?=
 =?utf-8?B?QUNRY21sbEtrdlYvNHZlaGJRbG5RTDc0M1VsNjlFVXBzdTRPZ0g5aGE3TFNM?=
 =?utf-8?B?RHE0WUo5NXFoUUg5RVJwUG9nU01WWS9BRTdLV3ZnMmxFaDk5NW9HbGJNeStr?=
 =?utf-8?B?VmxEK3FLMWlHTmRmNnRQWmpmUDM5NXluZE5HVDFZblUyY1dmcDVBRFphaWty?=
 =?utf-8?B?ekQ0NHlXVFNZTlRHenVYc3Y2dDNqcHN0aEd5VHVqSkpDc3pOVjUxNGJ3M3h2?=
 =?utf-8?B?ODRlMHZjSTV1YVljbzMzZC9aRXN4WWM2RDI1N1A4NHI1emdCbGFxVTVMNFJP?=
 =?utf-8?B?djFUckxsMVFVMWU2MEFBWHVqWFNrSUZuaWVnWWdNSnJVRVJ5dWN3ZVpod0gr?=
 =?utf-8?B?MXNqb3dQYzRQUnUvZ1FaMDNtZVJ6czA3NkY0TlI5NENUczBON1E2TDFGc3Uw?=
 =?utf-8?B?VXNob2pHRjFRdS9Oc1JoTlV0bzNwT05nMWJ4QVNTR01MaWZJOUlaR2tTbjFD?=
 =?utf-8?B?a1hGbnY3Y0NERVQrVXp5bFlyVnErU0J2SDVWajVET2xWOHpHWTlRdlZYL3gw?=
 =?utf-8?B?cVFXNHVPNkloZU1lajJ1Q29rVlY1VEZ2SDJLMU9qaGh2eHBmcW5mL2RZMTN2?=
 =?utf-8?B?M1A5VjBYbEhsRmFhTWozQzVWM1o3SVRKM0JhSTMvOFladDJRcW5XV0FNRTdl?=
 =?utf-8?B?Z0dWTHJhVXZweUd0RzRRM2dRNjhQZ2ozM0c3TjNnKzA4R3VqMHBKeFVwVGtF?=
 =?utf-8?B?Ly8xMklIMTUzT2I2WjU1TUJFUlE3VzgySExWTWlUa2RycGNXdk9oUUF3cit4?=
 =?utf-8?B?TzFIdHVUcE1VYlVYa3h2dktQVnQ4bEZTSC9YZW5ZRUREQ2JpU1YwUzlUdGpM?=
 =?utf-8?B?T3BZK3VvNTJndGFVUEg5VlJOb2x1NlEyYlhhQklONmsrL0hUWHkxUTRTbHIr?=
 =?utf-8?B?RGkzR05HZG9IWkpncS9yZE9kSlAxTlFCUVVtb1hBZXBDa2Z1MWtzbXBDTkZI?=
 =?utf-8?B?L3JFblhLVEUzTE9iVEdsNDdFWGFaRFRkbU85VnRRWEI4Vk9lM0ZRZjEycHZz?=
 =?utf-8?B?SG1rK2g2cjFNZnNCREdDOTAydnFCbHJEblBPZmtBRExFVDJ3RWg4ZjNMUlUw?=
 =?utf-8?B?OXFuUEVyZWtwUm9wd3dqU09XelBDY3BSMDdzVXBvRk5GbEJLLzBoYzVZbVhT?=
 =?utf-8?B?c0F0Z0NtR1ArQlpzYjVkaE9JVXlxb0tlc3BYbXJkUFFJNENtajN6bHBiQVY4?=
 =?utf-8?B?Vk8yQjhrU3BSY28xS0FkUzhqWXpxRFZwOUpORTd5UUU3UzhnaHNVMkVnekpr?=
 =?utf-8?B?ZE5XZ1NtdU80VkdGdHhLYWh1R1psOWh4MUMyNjMyZGd6d1pEZWF1VU9xZ2V6?=
 =?utf-8?B?THFRdnBSZm1DMk5DQnVEQlRLNXNjRUxaUW8xOWFCVVhaanZEM0JWaHVOQ2M3?=
 =?utf-8?B?SlpyNDJxN2pPb1JzUXdjNEZmYzlETTd4aFY4U0pGS0kxTHd2OTNCRE1oeENo?=
 =?utf-8?B?djJISnhYeWVEalIyM1loT0F4VSswVWxpbGRveVJEOHhwSWtPc0UySkpHUXJ4?=
 =?utf-8?B?WXMzL2pvWjh4L0xPdVZMUWU2UlVnNzlSMUNRQnloNlRvR1FBbVNwQUVSNFZm?=
 =?utf-8?B?S1o3VVB0cXVqL0RWZE9kV3puU25BaWRjLzd1ZXZVS0ZGNExmY0RraTNRMGRI?=
 =?utf-8?B?dFJhNVNjU1k1L0x5RWU5bm4wRkNnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8055167b-e9c0-47a8-1706-08d99fa6cd03
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 15:21:40.4217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gKTVoYgzj4ijr6rFjlH5bowRV/2DlZ1ob7zPxY2H4Um/wKo5tiu/1EvzZ0ahOiDXyrx3oSo8v7lM3J769lqur1wpuTSfA9BCdCmkPytw4FA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1857
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10157 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040058
X-Proofpoint-ORIG-GUID: CA9I1pL3lBgjgPDXQ5tYTPR8uSpBmyoL
X-Proofpoint-GUID: CA9I1pL3lBgjgPDXQ5tYTPR8uSpBmyoL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 11/4/2021 2:25 AM, Greg KH wrote:
> On Wed, Nov 03, 2021 at 02:01:42PM -0500, George Kennedy wrote:
>> Change return checks from kcalloc() to now check for NULL and
>> ZERO_SIZE_PTR using the ZERO_OR_NULL_PTR macro or the following
>> crash can occur if ZERO_SIZE_PTR indicator is returned.
> That seems really broken in the api, why is kcalloc() returning
> ZERO_SIZE_PTR?
See Dan Carpenter's explanation.

kcalloc() purposely returns ZERO_SIZE_PTR if its size arg is zero.

See commit: 6cb8f91320d3e720351c21741da795fed580b21b

>
> Please fix that, otherwise you need to fix all callers in the kernel
> tree.

Here are the kcalloc() args:
/**
  * kcalloc - allocate memory for an array. The memory is set to zero.
  * @n: number of elements.
  * @size: element size.
  * @flags: the type of memory to allocate (see kmalloc).
  */
static inline void *kcalloc(size_t n, size_t size, gfp_t flags)

Any call to kcalloc() where the size arg (the 2nd arg) can possibly be 
zero needs to check for ZERO_SIZE_PTR being returned along with checking 
for NULL being returned, which the ZERO_OR_NULL_PTR macro does.

In most cases throughout the kernel the calls to kcalloc() are with the 
size arg set to a sizeof some data structure, so ZERO_SIZE_PTR will not 
be returned and a following check for NULL being returned is all that is 
needed.

Thank you,
George

>
> thanks,
>
> greg k-h

