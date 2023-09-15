Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F197CD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 21:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjIOVxT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 17:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237832AbjIOVxJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 17:53:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AEF10E
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 14:53:05 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38FLOwX4002783;
        Fri, 15 Sep 2023 21:52:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=v4Ta3yinEdE/mraZaNWilEz+qTen3gs2EDJH8ZhG884=;
 b=2QOmTxX9GGhKKFlK9NVzCF9oDmLmbza3qDJa6pbVV+QyjL2K0b2y+UE8Cswo8z1XUv07
 FoXiAtgGnlmhIAhZurlzlMI78iR8vm86N7EXCihfa14pkSxdf2g4Fz4w1ON0RL+35R7m
 t6HXuetmxNiJOglNfXBqECfN5aQGCrRviXp4OOszxHd2qBt8aNaJSUTVlwpCOzi3YPg0
 35RlkjUd7oCQkBplGteXjYvuY3RwWCA3OqfSaz3yPqoq+LLHxIihhLCj6nyM0Rq6WVFp
 u5O2Ooj1yGKvbODexMKKcz2fIViUQVQ3508TlZNGWsfeCtIpZCx9huxZrhCQjy8T36TM wA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y9m0n83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Sep 2023 21:52:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38FLMfhe007400;
        Fri, 15 Sep 2023 21:52:55 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f5bcka4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Sep 2023 21:52:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cx7X/viHeM2QPDk+OO0e/kXf1I+c59dtyYUmZBz662Bg9SXlOj5Vc+mTKXiC+ThtMGgsnmoJInv2SYLdWaT980sXOWBh6aNG7uvHiViSlVITGqmzXBl4giaFegA/vvJG1g6ptlujQqErlI3eFVATauBTW0RfkjoeUKVpCbF/1tEgHKO51DPVSAidOEJkGk6N0PjS8kAiq/+ZAYmwhrfzZG3CM03654nx9VE9PB4/H1wHD1FhNC3OprSKTkUZzmIQTVzNzLEaAoxrTEr8nLC6q+Nt+0I3/6O0Q5Zzyy7Se5NCVSqEW5DxVFf9RNJNLGGZ31ngI1zgVLOAylVGjA4cbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4Ta3yinEdE/mraZaNWilEz+qTen3gs2EDJH8ZhG884=;
 b=Ce9Z9asTEs19EodEjj0ABcPA6IoySPcVQeOYortmtuS53A3dLVcd5jJ5TibFTsU6cI/VYA7NCYBpg0MKqInxRpqFo6frAUGQTiYriHtvSjg1rMR8UTTdsgSfaD9ubof1fcfExqWVAKaAuy6fJBdrvLKTySFwbJBC2oxgB/bdIRhsSb5GU1JC9ytVFBO1t1KZmZkVeQ0uPYfQ1QkDuh2xiD0gThzgDjgPJxFIyK33dpkFfQYAnXFLvXrsqGpF7mluaKQGLvD6k+xprK9C2Egv8phSYWpvOt+qEUkFUkNpE5gyiiIBxAZaA/RaOTyLesuG8CombKmiTS4eDbTt5z+DDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4Ta3yinEdE/mraZaNWilEz+qTen3gs2EDJH8ZhG884=;
 b=rOL6sDNGoqbdClA7+SPBgC/2Z1e/L2XtN3OAoePX1gBhsk4KJxXg2m6zJ71+4EC2EEzdrTVqsZJwvXZqqgddPJNukHb3afFyFVfB61MLNIUWHOCc1JUSbVMz5mG12GGfrzRViDtXkAKk4rVlqxiaPgn7qWMH2owWqQmI9x3ROnw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SJ0PR10MB4672.namprd10.prod.outlook.com (2603:10b6:a03:2af::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Fri, 15 Sep
 2023 21:52:53 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6768.029; Fri, 15 Sep 2023
 21:52:53 +0000
Message-ID: <09d60961-d423-47d1-8dfa-5b677593319a@oracle.com>
Date:   Fri, 15 Sep 2023 16:52:51 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 15/34] scsi: rdac: Have scsi-ml retry send_mode_select
 errors
To:     Martin Wilck <mwilck@suse.com>, john.g.garry@oracle.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230905231547.83945-1-michael.christie@oracle.com>
 <20230905231547.83945-16-michael.christie@oracle.com>
 <f87d6c24e18b606a8ab3e4056e80959e43a360a7.camel@suse.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <f87d6c24e18b606a8ab3e4056e80959e43a360a7.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR06CA0048.namprd06.prod.outlook.com
 (2603:10b6:8:54::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SJ0PR10MB4672:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d378f5f-fcee-4314-a7d8-08dbb6361ccc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SEbQ1t4e0XacNFePQfVziNpXQYP4rGxiJy4arkDb5tzXa1yEkCCQtYt3OalCzeUmstCI61pjSrDzIHVcfvaNwuU07DMyU3cKZENg48qyeZcwi3fo3eKfsmI9AzuigekJvcpYM9zmgBy4RYbst+ZDcni6PRhMU5uo+uVmTZaB4NoIvXyW2hO0jbsm+QbwIXb32XUGDROdMtzEXQLEfrZPBZaPvx0OEiOESLGjIZfLFFeyCCBUubqJuKsBtfJehFA2JaB6xje9CLLth58HTTAKCvIOQu+q4yXk2DRkmtcRBXCAZP1M20B8Rb8FuB08RIezeoAGTyUcddwvSGukPIcpQ8rk8YC4T2QwlwtWdGZhJNry3J6KaSda+8OqkVfO5O54gNBddBMy/mrmZqdHzE0k8dfNX5+900PaULrY4NOFLK7xbtkq/uhi8yXho9ty5y4zUWq7qz5Fd2VsJTyeGsPohu+5Ep/Cm4a7taK512GBvXKQSB7FHKQkBWlArxQWf2MNQB3oj3kR/SP0nJaBsKazmVaAIFl9gtJ6i8biwtWiP3PDgWoN7WTri+8Yd46DUN6zEKveeS6rDLfajWVOoRxMt2JGQW3/ukQTsF65seRLUT2TyatqxLnW3pb4kAPXUp7xciWu/cU+G2HjRJM3L0iXwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(376002)(39860400002)(366004)(1800799009)(186009)(451199024)(26005)(2906002)(4744005)(6506007)(8936002)(316002)(6486002)(53546011)(66946007)(66556008)(478600001)(5660300002)(66476007)(41300700001)(8676002)(2616005)(6512007)(36756003)(38100700002)(86362001)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djJibHFCbS93eEVhcmpMWVhEMk8rbGtoTzN4cklSZ1owdWFPcHQzM1ZxcVdH?=
 =?utf-8?B?c01keDgySDd3bkswalc1azY4UVpRTDJ6MVlMY1RReXU0NEZIaXpGK3VZN2lh?=
 =?utf-8?B?cVpLdlNOSC8rVlJ6Qi9UQi9sM0xqaG5Za0Fhb3BtV2tBQUdEc2xZYjZEU2lH?=
 =?utf-8?B?VmkvdWk4SHhrNEYvR1RQNkp4SmNNRjFCd01kbmRaZ0RrMmJqT0VHaXRMaGd2?=
 =?utf-8?B?eEFpRDFwOXFScmdDWXN4SkNtSW1SakdnRk9uUUNXaU9UVkU2cGNrWEhHTW1z?=
 =?utf-8?B?K3JEZ1EzRVYzV2hicUk4QUhqMVRaWHpjTVRmc3FUc2xiS1pmcDk4Zmw3K3lC?=
 =?utf-8?B?OUtxL0RpeFVqU25tMjk4a2JRdkJCd3Z5dzh6QkdrVWNxa1NtZ3dmWWRmVjFh?=
 =?utf-8?B?bGtSWWNqcncvN0wzNlprOWpPaGpVa1QzVU8xTHl2UVRENjdBOVU2d1BRNUVv?=
 =?utf-8?B?dTVHNXB2Z20zcU5aNUJ6N2Y2Q3ZJYUhWU20vUVFYSDdYS1lrTkR5azN2M3BD?=
 =?utf-8?B?T2haR2ZqYkRYTHJKY1V5M1gwVWNKU1hScjFqbTRpZURZci9qV1I3UjVkNE1H?=
 =?utf-8?B?cmMrWVBLMEdqRGg2T0lyNVdlbVg3Z2tCMDRJZi90YWFHdytuMkc0SVdzczNQ?=
 =?utf-8?B?QkNhN3EzVTdkd2dwdlp6dmtQTkJrNVJ5NU91a0x0cVJVTmdTOWpXWmcvQ1BE?=
 =?utf-8?B?UmwwNXRIWks4OXF3K3NsYktiTEpsaXdTa0VLcXdIaWdtRU9rMlhpMU11NlFE?=
 =?utf-8?B?VDZrZTArblF6aUpaZ09jWW43aDZXR1dyMnRMeWVJN2JvTjNINVZGUGczenhw?=
 =?utf-8?B?b2d1SVczYmZja1dxcFpWWGluUGZ3RVhaODJXRmdKY3Vpbk9DZFZodGRCanFi?=
 =?utf-8?B?NWZOZ1NMaGZnYUFEMjk4U0p2ZUVKVUJBcGNVMkZkNXlqS1V0d2h6RHpvNmZ0?=
 =?utf-8?B?WjRDWnhjMS9ON0puWGdPNnlzUmZVV2NaTXY4SmlTbm9PcVpMRFFnNGhYcTBs?=
 =?utf-8?B?V21ETlFqTnlXNE5JTjdFWVlyczAyeUtPMGR3UmJpZHdrUXRxZm96dUtmd05Q?=
 =?utf-8?B?UDVLczJyTEJzVnFxNTlRZ0pzSTVQdWFHWU1xV0RNQjhDTjlFMmt6MWN2c0pT?=
 =?utf-8?B?T0dJWkZCK1lzR1BLakRHVklYOXFKWGtHL2hHOTVqdko2dTdONHdEdVFmdmw2?=
 =?utf-8?B?NllDUlZBQkQ5SWF6K2I2d2U1OTBaa1EzZXhIRGw3KzN3K0VxWlRBZUhUQXNP?=
 =?utf-8?B?cDVDNWhSUGJIK092cTBrUDZ5UkRtVldLS1JNeTllNG5LTTRVR3JoWmdTajhL?=
 =?utf-8?B?NThwdU9ROWgzY3RMa3MyYllHMjg3bmV6alRVTG9hZjNSY2JweEFmYXoxUHBw?=
 =?utf-8?B?SktDK21ScWs3d01DOVg5TGZ5cjN3cmhnVk9hUlU2U2NmaUJleWxnbUhUeVBG?=
 =?utf-8?B?UDRaRjdpVktHcHVabjdqYnU4VmIxYlR6cjNoazlaa1hjSmhUbGJHd0YyeFZJ?=
 =?utf-8?B?NGVqWFgwcFdvUmJkZUVKakJhT0czaURpWVdoSGdHOWgyQ3MzT3N0RFlOQ2hj?=
 =?utf-8?B?TGo5WEhpeXg4elM3MUZhalR4OTBWTThETC9rTmFJTnVUZUdSZzViSmJ2TVU4?=
 =?utf-8?B?M0lqQVRxbDdwME4vd05UYk9ndFVkUjFMMHMvQVhJVnhmdUgyNFE2ZFQ4aGpI?=
 =?utf-8?B?MDRJWk5jM0ZueWZUamRWMnMwTkszZ0oxV3F4K29XVTlCcnFYdnljMnlqYVJN?=
 =?utf-8?B?TjBlNXE1aWladXNzb1Mrei9COXUwZkFVWVNQNHp1WE9QLzN4RjFKMDNyWE1H?=
 =?utf-8?B?V0Z2SmE3WEpXZW9uZUdoY0lSenhlNUQzTjlKT1llOSs2REdvUkpsNjY5UGpZ?=
 =?utf-8?B?b2IrblJSYXA5MjVmVWMveXN2Tlp5Smg3RWxnb3FCcnVsWTJFNU9NS01ZRFRW?=
 =?utf-8?B?MTNVR0ZQN1h2ejdQd1dXT082bHBLNVc1Qy9iNzVhRnRaenM2NXpIWTJCcjVT?=
 =?utf-8?B?TmxXVTJ1alRFTzFvMjQ5N2xaVlRBdUM3RFhuZStHYzBRTENuSThXR3pCMzZR?=
 =?utf-8?B?RGpNNytWcGptbDZGSWpyVkpKMW5pTnFMQ0c4UUVncWZwWFRkSmhjTEV4S1g4?=
 =?utf-8?B?U2F1K3RRb2RjRnl1RUpUdzIwUjRkb1hUa3h6WXJWYlZFdXh2ZEh1bnJ0WW9w?=
 =?utf-8?B?dGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: j+O75Tz/tRk0V3TKR/0s4DPHjnfyT4W33GoTqfSarISX/QwhwHTwYfpJ8tPaGAMlz9Dh7gh/I628A1EhsRji3R+GTuca1dHteSrIFYi/+inu3i9hJDPxAF9W5egnlsOlGn6wISuqyx8sA5gNYVfLKYIYYk6VJBUzx8PiR8CQdQW173r2GC81S0CrisAiRlE581pLalHxJXGduVfKgq9hBYZCC8eDpWgJc4T+lETBB8vDhKdv5fioGcStq3LJ8p/dBj0T8wkEBSI9GoT+k+purWYKGU8xwVN6VO8mK33t+nFi1NapF070YCKU1mPAmhlnNLW+TxQMYg/o+oAtg/MWfTc3zPN+4ezvkDcSjZjAIhmXLuI+B2cEuNYjWlt6dc5SAlNYTKN3+FdMycH8vigvwPpCFZEBrIjwmYeZHc/sqtp9xhca41QPV7jmTBHa9ZmWulfIFjt0FkZhQWDmmK7cNuCZKT4lifD6ThTUKMy8sv5OB4S7+6zOmfjDwDm8fxh7QKfo/ekY0S63SO4YANdz9K/56nzNJtte1d6P3cWYjmlKrj0SS6iUdwcqeYPx4PLY1CbPmOiI9kcqRRyW6Ucj7m7ZddnR+nGFQ+5IkPd6eHsPV/Bp/e12mwAJXyVYl/kdsvqdzZnIwYcB3U3JhGjhjLc9ldROd6lwr4u0rIN0oxto45eTxajX2ZwMhXY4+wjhunxdbV+d1EcsN2RF7XCnJ/WttcEsSk7ajA4iUxlltFYRfXUlppgcscjS2h2+RKR+aU3NmxazMHk3gj2eyqQSn0ETzdfZOkAja09Vjm1uUQjrM1f9xImDQytLPThr0zu02ZrvV8cjO2A1t7RfObRcs5Z2BODOZkCOI0fQguOxPn/50ODeylMHD/4QsS5SPs0e
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d378f5f-fcee-4314-a7d8-08dbb6361ccc
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 21:52:53.2481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GqSjqYBuBSjXSqAEJRt6cYG1CygPQdFBRxjS1L+JEE1dEDSylnhF10uNEDd55KTMsKvPi5piNifMxYBEb4RDuUb+iUoic0B+BNx1FVUVLzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-15_19,2023-09-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309150196
X-Proofpoint-GUID: zI8WwdsvopkNpKR_n5VAAvjHkr1IEL8b
X-Proofpoint-ORIG-GUID: zI8WwdsvopkNpKR_n5VAAvjHkr1IEL8b
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/23 3:58 PM, Martin Wilck wrote:
>> -       RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
>> -               "%s MODE_SELECT command",
>> -               (char *) h->ctlr->array_name, h->ctlr->index,
>> -               (retry_cnt == RDAC_RETRY_COUNT) ? "queueing" :
>> "retrying");
>> +       RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d,
>> queueingMODE_SELECT command",
> missing space?

Yeah, I see it. I had just kept the existing tab/spacing. Will fix.
