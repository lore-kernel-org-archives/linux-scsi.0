Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74370C7618B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 16:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjCPQHo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 12:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCPQHn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 12:07:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CBFB6D30;
        Thu, 16 Mar 2023 09:07:42 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GFdLHF018290;
        Thu, 16 Mar 2023 16:07:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XJs/999D5/1bTrFltL+1jqJCvGi5xfkiO9si+Q2e+3s=;
 b=K5ZOtd30EA1Gd5rrUcXIOA39cy+R633KU35Sbu2pLKlqz56nc6r7FOAbpwh4ResGmaGK
 smxJt86nJ6AWLmWtdBy5NFR7qyj80A3CjTFT2UMWwK+k/i5FHdt4z1iF0H43c5VgAVIX
 JyvhK3vO7PqHtfHk2aLhzZsWclWxoyCHDOuvQFTQUSv6i2syD8F/fdlZtDb1MmLosou6
 isHnWD5B9Q/8GN+hXFrDmj3DZ5i1kkLJ//q1Yk0IhnDhN5SMzDygZNmRzjS3IclYrxB6
 pjHSDbiZe6cif8TWMC1vLblvbqSUxYVj2jT3hVHZeTS/UWh+hXSa/ObwnbmydqaAUR2A aQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29hm1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 16:07:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GF3Ob3020457;
        Thu, 16 Mar 2023 16:07:33 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq46hcwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 16:07:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JaoHbaOmgRXINTR3LQy76WeF09dBGs9G0hTUmcqqVcz8dSXOo1ZrMwYz7y4Vf37VHMKaCpKs7uJSiWsKYjvhwf4+m+OyZ9nQb/b5OoTC/Z5dQxksfc7k1uN+BU8hpopgiv/stiFIhFg7WvTe53GxyXXKKWCwIKJQdy+3+TREIJjKqPZ5rx+BvpbrRM55rQnSmitE5xpXg460lGcj9jOZWB9EzjoyblEWSvurgDFl8/vYbnWWrEpPpL8qDCpgDwTIyE0HLBpx4tQcq/NW4Q1cWxlBKj6wwBvHj+QNhxvK3nInCD7zOQ3fUiViSVQkdLGyrsmlKMMFPyKNVrq5P2EjQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJs/999D5/1bTrFltL+1jqJCvGi5xfkiO9si+Q2e+3s=;
 b=jvnQmx383eZJDmiuZmXkoslqO6A7iuB3MhIRrdr28gixYsctkl0iUVZ0tLHc4U634A1snirAheHlB46wCKDof0JlJuk0TFpP70XiTiRwpEuIHg6k0FFHL0ao9C9HdHt10aJcrpcY03oGeD4I1WdkoXAPsbgUo50pKVRVH6SVYf9hVUq479wcwPPShFyTzv62Y+GGrMk6D9WU1uukqLtEwlh7KvHSIQipDZuxNHBKXVWEKm4V9/agbSeD2v1i52ZC3t3T5NGdqxNJmX0oSB1nAc+rYtpUY+amQw5NgRM9jLJ8NMwsX8bw1f5Y0rahDmMfDDX3sugZaIvGsVYAOT2+GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJs/999D5/1bTrFltL+1jqJCvGi5xfkiO9si+Q2e+3s=;
 b=jlkum+Q3cbgR0OxqGsUlLL5hV5m2ezrqQ0SG+v7m39YGn8K52Uubiw1pRi0YZ3zglrfmv9cug5W/TseuY2NEBZdyVluzFaMh8Trlfx80r/VOvoOjfVLzlkeQVO4n2Pmb1V8TeGtqY+Z3tTSjR/sGrVxnmBh81W9w1rxhsVo5ogk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4554.namprd10.prod.outlook.com (2603:10b6:806:111::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 16:07:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 16:07:31 +0000
Message-ID: <3261f494-6cf1-e2a4-486b-250e946f167b@oracle.com>
Date:   Thu, 16 Mar 2023 11:07:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 13/18] scsi: target: Fix multiple LUN_RESET handling
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230309223312.94595-1-michael.christie@oracle.com>
 <20230309223312.94595-14-michael.christie@oracle.com>
 <20230315161301.GE1031@yadro.com>
 <50afe378-c0e8-7914-377e-ae8c91f82455@oracle.com>
 <20230315191141.GF1031@yadro.com>
 <5a1c2ac4-d7cd-b7fe-cc74-7e58e8fca968@oracle.com>
 <20230316103929.GG1031@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230316103929.GG1031@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0310.namprd03.prod.outlook.com (2603:10b6:8:2b::9)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4554:EE_
X-MS-Office365-Filtering-Correlation-Id: 90023109-8e2f-4da5-2305-08db26388be2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4dAHbXKW45IxHSru51XVqE1G3ND1WradzssHyaDvjYA00YDLdPne3Xfy67TGnbnlLhhjBPBbGEN+CSCTddv2QzhrQ4LOoRPvszTQF3S37AcyzdS9Yx9EXq+BgMoe6KDFXn0VEnBDGgFAOhlUiQc/t7VfTcXWywIpT0vasaVK+Hv/iSXV+Vs9MENeA8DiyIgv2sKA2YLGIn1OnjZeQq6iIdZvW8sNOlOomlWH5hRkKzrq3ixZYaJknYjcnTR7hXQ5pG/JsJ1ik/fcCiAdLWT0wYH3y9NMc+0iUArGOBE7oZfesW0ZMLP3Uz8X+q7t8SN4CIJ6Zo1whhNrcY2lZ+TqOjcFfpJTgMBebZWafdWPJOWU59RyRJiMwrw9xHpmpoe795XYGNECwZeM16U/KtzF2WH1wOyBdy+/kjVavh8Xzyk3zLV0HcvvU2uQ9FqoGH5WF3EI8KbI5bvIQh57Q8hFjboBtKly1kcHe+PIvdLfaTKTSD5AwCLluxCy4b/G3QsuANvuTKY6Mnivwc6uB5loRLsKipLFKdDX7U7K/MDFG6zKxy10W0vn9heOod7GiapDVeyyt/X6S95Rkx5An/nY25XLanuqU8Ea+eUnCKn0Ux2idif3By4SCbMAwsBrMYOCgt8i9S6hPo8UmtgPLoJ9XGVGhTPIS/orfW6f8nTdEHRf8QFHZdjRaymak+1AB6lf1pbHNp1iddykSsqZt6L9PjNdXP5XFvr0yzpJdkDqAdE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(86362001)(31696002)(66476007)(36756003)(478600001)(66946007)(4326008)(5660300002)(2906002)(4744005)(6916009)(66556008)(316002)(41300700001)(8676002)(6512007)(38100700002)(53546011)(6506007)(6486002)(2616005)(26005)(8936002)(186003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUxQcnRNbG5PNTlZQ0VTRlk5N1pDWmNEUllVZzJ1cERDcWNHMUVDY0RST3Nq?=
 =?utf-8?B?VzRMbkdZbGRmMHRlcEhTcUJubGlkcy9GOHgyaVozZFg0Z1hHdE5JZWdmV0NH?=
 =?utf-8?B?UGJJQWZsZjV2eTkyQVFZQXZ2QlFDeGhpZTY1VE43QXgzY3lwWGdDNTZsdk16?=
 =?utf-8?B?MGpDeGthNGpva1lEWU5Pc1hWR2hkYTEyeG1tQzZvSjBRQU5MNjBpaU4ySnhx?=
 =?utf-8?B?anVwOXU4eENXaXIxZVJHdGFGTXJqdVBkbXVnNVkwVEcvWElRd0xublkyMUpi?=
 =?utf-8?B?V0Ftd2xzZHIzM1dYNHUvSE41bVJyZ09HUjNhTk41ZnhBVkpBV1duZEpFM1oz?=
 =?utf-8?B?aytXWGRLMmkrSWVEK3ZUTE9ZRjMzTDZMZkhqUUtTbnFHcWNSRDJxUVYySG9u?=
 =?utf-8?B?eklmV0ZGQUphSjY5ZmtWdFVta2pKcVI4NDhrK2VRTUNzeTVYZUlzZjRaNGF4?=
 =?utf-8?B?NlhzSWNPNktjQU5tZkxNQzdpOERhY2JydGJMUE9lWXhIdEpEemgyYmpucUd3?=
 =?utf-8?B?R3cvWWhjNElzV3NMSHJPMVd2NFpsVEt6eDYzYnVmSFVkRHZ6c3JYODk4SDRx?=
 =?utf-8?B?VkR6eFIvYXpyMXFveXQycHUwZk90UURRSGpyTG0zTHpjOG15aGRUYjRjSnM2?=
 =?utf-8?B?M0NoQkRaTldjOEtodTdaOXU5ZTR0bTV4aGhBNFhQWEFpelpWc3BaQVNzM0sv?=
 =?utf-8?B?aGZZbjRjK0p4dXlVeXhVU1hyamhmODRwUVBydFdVSWhibzhGY3RsbEJUc2I5?=
 =?utf-8?B?TmE2NXJwSnJZN3I3Y0xUakJBVFFYSnF0NUZKOEtqN1lPSnFuR3FScm5UT2tz?=
 =?utf-8?B?MEcrQWFSVEUwa1pRVGhoR1k5T3ZyZVpXNWxzQXpoNXRaVHBkUjFmdE5Wb2ln?=
 =?utf-8?B?NVYvMFQ4RklBQVorR2N2d2JkTEx5TlczZldRMkFueEJuT05JNnlEV1lVMm5i?=
 =?utf-8?B?K1BtZHZVVEorazNIb2pWeWRPVUVzaTdqcXNzY28wOE5tRTlwcG91OUNLcXky?=
 =?utf-8?B?VDZGL2JhRDhvWFBpTmphMkZWdTZkSllPR2NDK0J4NVY1ZUpsZi8xd0RlUGUr?=
 =?utf-8?B?OGd3M0dTS29hcXpYanZsWGliRm9ZV28yTXR0cFErRWYxU0JYYTJObzEyQ3NZ?=
 =?utf-8?B?M0h1T1djZkRoSDV2VWY5OXZoMndLV0lHaXNBWXBiSmNYVURZNEtlc0cydlhZ?=
 =?utf-8?B?alBlNjByL0Y2Z0Rra3I0bFZTTXhhR2ZjSTB6Vk5XZ2dDYmNDUDRCYVc4UThj?=
 =?utf-8?B?TW1hMXo5MFJScFE1eUdBdWFzMEpLUXJ1T3d4ODRIRWxLMFJ5a0xBdTlwMmVW?=
 =?utf-8?B?THEyK2sxMGdkeFdGQjBSbXRMaXBtT09VMy9Nall6dzJ1SzhjcDNJVXFuL3Nq?=
 =?utf-8?B?UFdoREVJWXNSVXY2QUozNkRxZjR0K3ZYb1ZrRGhBanZNUUwySSthalVyMGRZ?=
 =?utf-8?B?VUplaklBNGpiOElQM1VDZEM3MWM4UzQzeHdwVTQrdFlTMkx4bkJhU0M0ZFJB?=
 =?utf-8?B?UG1GdVZxRENMSDdXM05jTElIcmllbEhlaWhCM3o5U2g4Q2VkNFZ0QWhJSnJX?=
 =?utf-8?B?SHYyUnFwbTJRMkJiaDFlUG1tMjBrYTlGNlV6WkJiOW80eW1Eb1ZpbWQrQS9x?=
 =?utf-8?B?dm4vMTZ6cVY0aGV3Z1dodmhZSHVMdUlJZWZqM1ZNTi9ueVVnV0xrOTFZYUNG?=
 =?utf-8?B?WlVveURJMFd4cXlHRVAyZ3pVOXVVMVROQ2syY2NrNlZ0bHRrSzg3SFZOMDEv?=
 =?utf-8?B?TDd5YVRhTWxDNUZ5cElJTCtuQnV5Uk9pUjVVd3BFMnZobUxqbmRvMk9OMzdh?=
 =?utf-8?B?K21qRXVSYjhtcHhUT1U1Y1RZQ2NmVHFzNFl4Ky9aUm9uQ1JUL3VHcjZHaWFH?=
 =?utf-8?B?REJncGkza2FGako4RHNMOUl2NTVYTzZMMW1XQTlsYmdRcG53Qmc2QnhCaUVC?=
 =?utf-8?B?V05ncE5Pdis2bExaSzRJNVZTN3ZzUG5ub3REWlhtaWowclhUUURwUzJ1a2cy?=
 =?utf-8?B?aitTMnhqL1dmVFN5eDhqNExqQlN5MDhieVVEWkwydmNFU2F4VHhDSFRhTDFZ?=
 =?utf-8?B?QXBWRFhjeW5mSk5CRDFBYlNDcFNWVHhwTGQ4ZjdFditxWWI2UWxLM0laR091?=
 =?utf-8?B?M3lXc2hRQ3RmRzQydTZtekYzTFY5WGJ4WklKcW85YWF2am5WbW45eG1STHlV?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4u16kp2Z98rkcajTRTgmswC6dCyNgfJNM3d3q4Na8ALTY5rKpq8j4t1A76cIZ/S7UxP+gjr4X5tYO/XSgVa5O09VPEhsADpSeZfRUWkbC+mnYURP2aq0ViTstv01xHT7/gPWZekpWUWtNNHd//+y8sKMCt7+vHfFO3zqYNwqCr5O9fF4OZPle43Vn0SkMxqIQk+Py36f2fs3C9UaGvsXZef4XN6nwDNlgjfOGhTAPGZQd/zvNv6h+Al+qVfYMNlzyZ3wjcYrqwsy9mxmgD2ENujnO8qLfGycEIipORg00rj7OHiv4oaTuGJ2OpPidQMJhdP3C8Ek4xvm0rCj9/h3ukfTVz3oLwx3KRUCHp/Kz4B3KmGF3JGeWU+trSOgllxZzCPljMV83q6AMAfBOqw1vXWFipWtO4M3oMVU5lvVGx6S030g19mQilOFQkW+nxej4LoVvGIkwKHYxXWTM7t3LN6BaHtidJIoXf3kSeSwafnpwgxiaVmMoXCzwMQ19b1TS+qYRf378gH1LTmYSd0qrauvUdoMu5K9E+/VCkxD3WY/F34N2ed+g4im6F6Mv3D8Ey0PrKUEXr+PIA0kHpD7CYtaY7gVyKHOUmP3GylJaCqMj6mNtbj6wDqSuHUxV441GmXeSF3SMPigIK6UL0iMk+buj8PhniaHsSzBBri2YYtY3KjYM3PWj9FcyBqMoSBFQcez/Aof70lIdS6I81Q29qke+4jmkeZIcUMQzNn2HscnD+ctin8L8kDHiJSTx1LdFGzwx/mCWOLqnkHgmElXKVHbcvhnOgfp+QZC0eqICd2EzkwLY+K38b53O35Est+Nutkql70RXPEYyuYTSmhk0e4RedylbU2yyj+J7PluDAezAc36CTJbwhKvYb3nWbPb
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90023109-8e2f-4da5-2305-08db26388be2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 16:07:31.1496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qy3s9kw7v7omY5xk4Ha3sz+yM2HSccXUnpcs6a1OZioTdI7021WX2zpFQhH9glouH9+t4GLHxjrOPXceNOCWFmaV9HeRqr5ixN3laI4yMjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4554
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_10,2023-03-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160129
X-Proofpoint-ORIG-GUID: 7VDhAcCwrUnJeCzWyLqqNs4YoX3Lp5Fz
X-Proofpoint-GUID: 7VDhAcCwrUnJeCzWyLqqNs4YoX3Lp5Fz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/16/23 5:39 AM, Dmitry Bogdanov wrote:
> Considering that (if) I am right with PreemptAndAbort,
> to address multiple LUN_RESET issue it's enough to wrap
> core_tmr_lun_reset and skip all LUN_RESETs in target_drain_tmr_list.
> Without any new lists. That would be as simple patch as possible. 

I think even if you are not correct about PreemptAndAbort, we can
just do the mutex and skip LUN_RESETs in target_drain_tmr_list :)
