Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 639C8C4167B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 09:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiLIJzf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 04:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiLIJzd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 04:55:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730585F6DE;
        Fri,  9 Dec 2022 01:55:32 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97nY7J003554;
        Fri, 9 Dec 2022 09:55:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=KxEf8ju+WhJT1zCbkhTkLzN2FVCXDpEbVb6GqywZ0Fc=;
 b=Xxq1QlipgenmTlQNAnIyrxnk3/V/rjOj98TZf8Io6ubUMoVSe/W9hwkup/9T/pgG/b+B
 NRUG9F7/mSB23RMGGxPcd8TaPz4nwfZi+4k6ASKke14TBSnscwGrkwBlLVCXajdEwQnL
 fGNTPw0TmrOly816zom+l6uWivK7jxDr5cL07sau/2CqDVWJqPq9fSbDi41/TEDAg0te
 jRLomY0LVH4N1cwvVsCTTQkyFkrwyFWc2D2oHxAfLpmi0UOgV1zTuTrUkVCKVe/A9pb/
 Ph0mAch8kekXqUOg+UGJ0uFTwL8jqbU1fzqDM4alZRWghP/Gi00YdvUNjbXO7zjUFDYQ 0w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauf8mq5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 09:55:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B98YLoR019708;
        Fri, 9 Dec 2022 09:55:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa8k46g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 09:55:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWNV6uRP7o8YaPbaxqG7FszF3jBb5YLUm+6JSouuSgLT1989MYDDpIdF0kkGTjda5J41Ih8BXfJWztrD8CWgJzdfMSYEz/VD1tldbS4ZskmiWXWtHrNnKBqdZAPwqgMzOpaGo1hljKmrkoNkKS/brPGQhhzvzNvVyzhMBW7Y/h6iALINeRmSu6YRv6QfU5SXqvYe/OKXaWgjwek+6WmKVhQvn/gXGY+4hmIJcf9Iw65JEZTxenEJtvoTF1Qh28QJv6bXc9RNLKqe7+jxbb453wBG5PR2RIDbwfVLllebA7ZdjKK59f8hZg8x4dDfimqh4AAl12S7CbjsE8cwzLc6Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KxEf8ju+WhJT1zCbkhTkLzN2FVCXDpEbVb6GqywZ0Fc=;
 b=ABsK7ZCa20cL2aU2nDzBf2OmGuqvmYBCB8eVOsP5ISX3AjbpWqByR7Lug6pn5UsjlmbdB4Fu0e/esw9JunUOVx3fK01ShKk7SDq2BEbsaDFnYfh2cc6YadgSwmaDVWWSMoa7ZOdOzTm1hOIor6NnDfIw/fqb3ygZHqIeEZVbVtcbv/TK0DEwMgyhMZIIoDrtYx/zV54p/nJOpZ/gvZqq1k6Wk5YjlQHo8YovRE/AT859bJthYW9MT15FnUWVzYqv8/TOwVAbgFpfclg/gbbc/L+yiNUjeXTJaTH7vXl7km+o8UWP65Qsv1hzx2HHQBh6dMUwwISVBaTZSIMPBybSFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KxEf8ju+WhJT1zCbkhTkLzN2FVCXDpEbVb6GqywZ0Fc=;
 b=bUv5cnNmHIt7VmuGn15RQMRDR4FpJKZ8V/tiWA3OCcBnetuG0QvNhZZs8rQeeNYze2lnK1mTxQD/Op2DN0tPtSwn2euU5f10eAPWRAW3wXlcQ33idnGJRgcfWSwH6swJPi+wL1pFSo7cX680oJOW1RgwTMoha9dUBK+jyL5M9Tk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7294.namprd10.prod.outlook.com (2603:10b6:8:f6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 09:55:18 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 09:55:18 +0000
Message-ID: <863dfb55-ed51-4655-17dc-54f8a53ddb7f@oracle.com>
Date:   Fri, 9 Dec 2022 09:55:13 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 02/15] scsi: libata: Convert to scsi_execute_args
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-ide@vger.kernel.org
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-3-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0480.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7294:EE_
X-MS-Office365-Filtering-Correlation-Id: 09b830a5-1845-487e-b25f-08dad9cb7a65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rcnEJ8PC411Xyolk1vDBnbqkX7zzATNaPpo6BC+3FoARLLXhjkATCE63nS5XSDQlzFSh2nUxDFAeKHbB7yMhFyUnmCXTB4ml3JDNlj4XS/F+Io4aKtuN8oBBz6/6jsPXJGqkUJqLYbBh4fFLeOvniW7ajyApIP8jsitM7/hKsdNpwLEPArtglSQ8ZOFatjQU9ft6mWPAiirjH+9+OWCa1k+Kbw00VAnK3nuGBoUTCDzilAEQ9M5dxmslvhnZ48DVKtjxrSfCJQdbUzl0gY0f3uwVFXKyQ+yENDOFV6lx7XqJ0N2VOiseAQpBGFe378sOnQNGtb8zlBmXE40OxBmFsn7gUEzWJpdI9jQYMois77Dny9IIUPf1IAUdOAiF3MW3pdW71/mkR9NkqfMxuyRL+DYErwuijD8U29kNscM+hhUGLd7W0DI0h86J1Q2AJ5uO/r3rIF80U/QE0vhvkTp8f2m3jO/tFDZzTl02CD6GhlCMfBbI6AkAFZH6Zf5lUhRTzby90ZzWIXBXh9P8kmH/ocO9/+ytW1Eh16uN0IZqMHZ2O7Qd5sGOGZPpolmDlYE8Dau98981sut8QZ5+Whl3qKBnP4JOMyw/ZxukIEIxQC32A6QtBiTV2GiNAnFPsfLvxJLqRQyk4Zdno7PAORQ3mz+7nQwJZXmGc6lckPKN4J62hjTYof6s46kowenIhpgywcTcgl+KH8AcDkgkxKOeQbvmSX9HCsU4k+4JTKy2nSE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(39860400002)(396003)(136003)(451199015)(31696002)(36756003)(86362001)(36916002)(478600001)(6486002)(53546011)(2616005)(316002)(41300700001)(8936002)(6506007)(26005)(5660300002)(8676002)(186003)(6666004)(4744005)(6512007)(66556008)(66946007)(66476007)(2906002)(38100700002)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlVqSzNVeVJYeU1oV1Mva09RQjYvc1hrWTZZNnd6ZnFod2lrK0pJYjVNNHMz?=
 =?utf-8?B?LzZHcWVRcU1nL081L3p6V2d4VmtnTkd6M0o2N0U0eit2VjVZZDVpMWd5UDNV?=
 =?utf-8?B?MDJuSHVyK2toUnpiTjZsdkxuRWk5Wm1la2RvbUNhaWp2d1JJN2c0ckNsejZq?=
 =?utf-8?B?Y1RVU0FjWHZOTTUvbytRdDB0WFhCNmpRalRzczh0UXJMZTZJRHZYQnc2eWFU?=
 =?utf-8?B?SWJlLy9Bam5pNzlZcW9aN0daM3BCQjBla1g0MmFuL2FjbExtMTRGa1pKa3ly?=
 =?utf-8?B?YTl0eDcwRlFER1Ixc0UzZDhXdE5mVmxLL0haTVRSaFhtRlFpVDdiVVRPVGFo?=
 =?utf-8?B?RHAzMHY2LzdUQ2lrWDVPWlRBVjlNaWJBTHVLVVI3bkZRUUN1N2hZRjNrMlk5?=
 =?utf-8?B?TTEvdFE3emovTGlWaDEyOXAvNUZRNVpLM2w2aDVOK09HekF1OG5RZFEvMzNZ?=
 =?utf-8?B?VHdOS0drSlR2OW1iZHdHRkc4M3BDMEdQOTNvMi9mdkY2RlBlblg1Y3d3TUp6?=
 =?utf-8?B?emRQVC9EMGQvNVpRS1d2SUF5ZDJ0UWpaQmhnZ3RkWlVrRXlSVFFmZUJ1OXdJ?=
 =?utf-8?B?TlFuZ1NmbWdiTnc5ajFPNEhuZ3dzR2NRR0tOdUdXb0pwTmVSOXV5YTEzTXdN?=
 =?utf-8?B?UDVvaFNDQkdxcDFQVko5NDk2cnhDUDdDYi9Pek9YWkxqQ3QyV3F5SUxnWllk?=
 =?utf-8?B?bG82N0pmZHdOSUdUdGNBRHFDY2Q0ODdXUkxFRjVTYmpGYVpGWjZOL1R0ZFpp?=
 =?utf-8?B?ZnJrUndqaUNZdUxmNi9qL1BJVTI3encxZHkxMG1EWjZ5VjZWcW40NHl6VENm?=
 =?utf-8?B?ems4L0c4MHZ1bFBsNnZPejlMZlZ5cXJXYUt3Tlh5azVUWWlQVHEyMnBCR1lz?=
 =?utf-8?B?UXd3czJSQkdhUUNkK2w1SlpDWTJudzhnanQ0TVNiQzB2cmhBaXpneWZxL081?=
 =?utf-8?B?Q3VNd1ZsTThaY0huY0VoQytqd09kMlFTSXkrL25GSk9sZytrelIvaTJRMFMz?=
 =?utf-8?B?VFI1andqODM3OUgzZEloRTVlNVAyVDNIMmo2UUxiZWtlaFRWK0g0eXhsKy9p?=
 =?utf-8?B?ZGUrdXFlQ1BvaUlNWUcrT2RJS0EzRkZNaURpMGg3NktZUHFSUUgxN2JHRk1o?=
 =?utf-8?B?N2QvbUVPQXF5R1NlTUg4dnZPdDZXbkc0aXR6Z1IwdzFUaE4xd2xUZlFsYzhy?=
 =?utf-8?B?dHdlanZsM3JmUkJyWUR3REFEak04N05IdGcramR1Q0lCaXJQSkZVQXhqNzAv?=
 =?utf-8?B?VVlqUzcrc2tHKzNjaFVaRlNCNnlUb3pBMEtUc2xPREhZSHpuS0RkRjdLMk5L?=
 =?utf-8?B?MnIrelg1dXJsUENrVjBaTkJXK1dCN21HNzg0YjlZR2hTZmFZbVhNNHMyK2dl?=
 =?utf-8?B?M0N5ZytmdHprRWtYcW9qcDZFdDZweENDN1NXM0NEbjhpU0RDaWZvdkdSQXhC?=
 =?utf-8?B?UFRKUHIyQzVSb24xdWw5cEZKVDh3SWZUcDVSRlJWMW5LVm9SSnJMaTlVcnJx?=
 =?utf-8?B?c2JMWG5kRFpGNEZSRW53cWNpejFNdEMxSG92bnFxdXF4SDRITjArS09wWW5I?=
 =?utf-8?B?NnRtMytXRlNOODNYQ2FrbXZLQmhqQWxlTHhIVFU2T1g4YlZGSkZkSjNPWVZQ?=
 =?utf-8?B?Sm4wWWVMRUhFQ3ROZFB4R09QZy9Fd1JiTlU3bUtRTUVmRkhOTDU2TG1rMDc1?=
 =?utf-8?B?RXU0M2xsKzlaeHFpa09jUUJNc2VsdGc1ODVvU1h2VitHL3lvcnhOYklzN3VQ?=
 =?utf-8?B?YnFoaGgvNjVGbEhEalVNMkpUY3lrNlNLMldWN2podkdiTUNQcFYxb2hHV09Q?=
 =?utf-8?B?a0VvWHMydnh4WXRTUXJnTDhwR3lEbFZKN0xFNis3WDdXazR6RGFQRnkyU1pL?=
 =?utf-8?B?cGJxckYraFR6U3hSdWUycjYvNGwwNVVsd2JBVy90bkU3TGJwSnMzY096eUN1?=
 =?utf-8?B?SkhRc2FodEpJdHpNSVJ6Q0Qya2Z5cFMydm5VRnpXY2R3QnFKWjdZU0Y5R3oy?=
 =?utf-8?B?M3p6UE1jRkptWHl4cG1INFd0ZkcwdjZwb0Y3RlhJZGNzam8vZDVSU21ld3RN?=
 =?utf-8?B?M2dpOEVkcllpUXZXbDk3TytudHpuRkZrNkJVMmVJVDMwcUNjb0JvYXI2d1pG?=
 =?utf-8?B?QU9KTFhtYTFZM1NMODlyMENhakVxMmZMTzVKYkk4OFVvRnFEUmpQR3VTWng3?=
 =?utf-8?B?Nmc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b830a5-1845-487e-b25f-08dad9cb7a65
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 09:55:18.4075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wNJAk+BisAMqWhmACSj6n21m6hWFQ+80WGShtuHIVJvm5MZlFJOfY+hLQN5aAmcT2Or6/k+FBaLLtw0ZTkZY2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7294
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-ORIG-GUID: FAOHVXBVR6BH-J3k7jVN8PReGyvTGL4R
X-Proofpoint-GUID: FAOHVXBVR6BH-J3k7jVN8PReGyvTGL4R
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert libata to
> scsi_execute_args.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> ---
>   drivers/ata/libata-scsi.c | 23 ++++++++++++++---------
>   1 file changed, 14 insertions(+), 9 deletions(-)

FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>
