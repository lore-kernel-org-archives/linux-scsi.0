Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71F0C6FA82
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 17:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbiIVRay (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 13:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbiIVRai (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 13:30:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC037105D6C
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 10:30:36 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MH4UxR022874;
        Thu, 22 Sep 2022 17:30:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=9csMI7ZqbS/R14cp6pER2e4rHZbuBlETIOm1F1ZUTYg=;
 b=X49roXouOnO6NQWRKvX2vwb6sxqTpDtAbMJ3KhGoik84oOtNYaM47IyobX2JQEujWllZ
 eB2Xl0PglB5LANPRlLpw98AaGjoXllhqA6mZu4gbA3Ecj5eP793Ehj8YRv9QRKxrE6Mj
 CGpNFm26i9W706rEtaIpM9phmraB42/a2rHHFttRYsLHsSM87B3k/XaWScunkWo4D9XN
 N8QVcm6harOSw7gNdmBP2smWZYmiZF9J+DjSA4ci+ymqHAsSwO6ToCmFazkDRPj2Baxd
 QyeiBTTGXpwCl8sy5vwwnivXK3gVTuZGTfkWrbhwGqIUZ8xLQZ1QJjmiHWXdRUML0XIR xg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stpkx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 17:30:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28MGFAKa028900;
        Thu, 22 Sep 2022 17:30:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d4ux6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 17:30:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7/jSxFOmRhlq7jv4pb0Ar1xBJ6HgHhEtpaRKQnV7DswUK5c/itK9GgAjU7G+Vfw+pr2WQS9LZr5Ixg5OgvvKHo5qLnnU9Zh0e+2Ae5srt2oXcrtdACCKSKN3QeLYmjFJV+k4F7eSRCQlnjd8P7Zmhng3iq0zBRFvOCtW0Fzfd604x3Q9THGAzbTjlpppo/dlDmvk+19ZN2jzQfBMyO/GgAAw8u7qh6FaHft+Qg2MiKk6WLRB2cYR7tSbZeD+SIqdOdu94goSm482DVcWVnYfEfV5BOWCxOXLL9QrslD9E4W2j8J7T7RFbktmX4/QmjgBQYmxZ2ZV1OF7OdrDiTYuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9csMI7ZqbS/R14cp6pER2e4rHZbuBlETIOm1F1ZUTYg=;
 b=kr7z7o6Xom4uo6JwJ/+Se7SkWmyEunf0kOy7xXBjw4l7/HVHdro7gr1mSalvIWRg5A5UcArqnil0iyc6QvWyE09je01dmHDdpqYwCYBJSTsJ9A2nQU8G1cWRib03iCG+3jG31GrfEosP6xuZ8OSFTL8QMxYBXQZ6V9wmzZy7dNN3Ag0pspyxHNeKyV60LJGtTIBdX7tUgVoGJF36A9rFmzZH8gd5MD0CUk4+gr5J8QCxMIPJTsqP3khc8uQCoOJizbSA+R1vo/uAZwjxaF3v49AXDZOByskFsxtqQ5cAZZ5+IXFiu7nb8kTBlBNdA5oaotAay/o0WqjYWmLMz8wk8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9csMI7ZqbS/R14cp6pER2e4rHZbuBlETIOm1F1ZUTYg=;
 b=QuGUHDzVlH1r0MtukBZRENBMwGi3DTSIcuDiEV2npFNfDfe90SaAPk2jfXibmVtxJbBQxQ87B0OQTUIlnIHyS0BA8rR8lcfARKo+MytQsmZmHgwUEOLC0uYkaIvPy0wC7oCM7uIE8vCngNB6ieqWNbjtZ3zaGv0z1kuDC4BDL2w=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5692.namprd10.prod.outlook.com (2603:10b6:303:1a3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.19; Thu, 22 Sep 2022 17:30:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 17:30:25 +0000
Message-ID: <8aae2e46-f526-8f09-5fd1-ec2011a8d087@oracle.com>
Date:   Thu, 22 Sep 2022 12:30:23 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH RFC 04/22] scsi: Have scsi-ml retry scsi_probe_lun errors
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220922100704.753666-1-michael.christie@oracle.com>
 <20220922100704.753666-5-michael.christie@oracle.com>
 <1cc0e85d-a530-a8da-42a0-91230b65c6b4@acm.org>
From:   michael.christie@oracle.com
In-Reply-To: <1cc0e85d-a530-a8da-42a0-91230b65c6b4@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR08CA0002.namprd08.prod.outlook.com
 (2603:10b6:610:33::7) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5692:EE_
X-MS-Office365-Filtering-Correlation-Id: c2f657e0-4f7e-4d13-c454-08da9cc0224e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /FdA4hjJZL0px5z8CTDH5b2dJF6Abi2e3kr6N6Zeh2MwZHHi94lL+oyyCboqzroGCcSr+p2/6xJzoxnk+k/Seb0bwXzxPuHLVPf0Av/+K6eVbrJDMUN63R49OxuuyXcEvk3EOPpKboHWSTkdebOtSjnSvdcNOI0K1NlhJtlm1egoHyiVvMHiIyjo09a5exRM0Lw/1u9fKmxY8ncavYeGiEzNPqeitS3VX7JtOINc8R7I29lk9Nvr2EzLNw//fdDx/7Swgcus2ljsLQ+PNrSjFG92n0YHuZAvH6fmEKKEwt9kE/8X82h76479ogKmwFLRYhpaAgr4MYKnHUYxy3uvRtbAAJYtUnUSVZjiVK+UkasSF7rDQ3diEGhIMzkJXjsw/0kcgXSeTMnlX1C+jYUe+DzA/JJIVb//PWZ70kJcnGuxAxptzse3dwSDChmmLvvRNjWsjauvBiVgQmOOVltiBt50Y6gfLb8qbTRqb2r5UwP1vTb39UGU0/kgvfptca2nQ4iRWeWUrQHWrlxyupeDS/IghWONUsA/oXYD0LNrNSBU4Fw17YYVMdafBirlcQLtxlM7GCqIhF/JueYDKrqUDQvGlpu0E/75S32BWj9Z4CBObWQdUqBNQDVXulcA7O6MS8yRnIwnplQ273o+y4of/k6s9zU4UhMh1it9+k3QjyuZF5f2stwLjM9AclOL6sBvghx/IJHkKw8VHEHoMHZBd/V9vqy4cgoVCjWMcKzpZgL5RNWFWCZeAJtVgnjEaKzudXhFz5S9T/bN36r3lM/2nA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199015)(4744005)(2616005)(2906002)(186003)(5660300002)(36756003)(31696002)(86362001)(38100700002)(83380400001)(31686004)(316002)(6486002)(478600001)(41300700001)(6512007)(9686003)(66946007)(8676002)(66476007)(66556008)(26005)(53546011)(8936002)(6506007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmR1QnU0SFF6TE9ZVTc0YjVYZXFuRElrdkpqZVF2emQ3Um1DNHhHdElDb3hl?=
 =?utf-8?B?QkdnaUtRNHcwWXUrZWFxQzdUYkFremJHNDJEVVpBc3FlOHN1UkZMaC9MbGpu?=
 =?utf-8?B?dUh1YjY5aVpUUHRCUzNlVnRVWERKOGRFWUVtU1JMTjFQd3kxVzgzcnk2TmJm?=
 =?utf-8?B?c0RMRmlJNElqS3pmMUZJbFRvWVNubW5XSGRjcFVNZWtDNW9mMFhzZHd1OUMx?=
 =?utf-8?B?Y0ozMzhFYUhaOHhWWDg3Z3FSZnJla3E0aTdVdkp0bmVCby9Xdk9wcVN4WFhk?=
 =?utf-8?B?MHVEVVE0Z3QydGQ5aXdSNjBPRVNwYTRIeDBVWEV6d3p6YkNFWWgrQTNJajVu?=
 =?utf-8?B?cjMzK3pLaU1DQWUrUzQwTW94c1Y1SUJFRE9TVlBnRDNBS2Y3b2wrM3R1dkJp?=
 =?utf-8?B?ZlNHaHh1Qi94UlJLTlVUUUN3RHdBYW1lM04wWS9ZekNFSGJJKzRGQzQzR25J?=
 =?utf-8?B?eFZqdzVmZTlZZEJnM0NnUTd5SGROOXp4eHVCWEpseFZUZUhQc1lSdWtZSXhY?=
 =?utf-8?B?Z2Evalpyb0VDeXpzZnRwTzlra1J4WkE3N3NlVjlocmNZS1JvRTlMRER5MGpu?=
 =?utf-8?B?eFBISzNtTkNoSStCZDRveGtHcnBDVUtNZ1RCYVczZlRiZzBHTEFpVHRvU1gy?=
 =?utf-8?B?UWhUd0h6VjBSbU5Bd3N1L3BjUkp1ZUdXZUkyekg2WlFGQTByTEVpK1kxOVpH?=
 =?utf-8?B?VlpzUHRJdDJLWHdsOVg5MzFid2gyNlJFVW1pUFd6eDROUitOdGhwUTRzdlNG?=
 =?utf-8?B?RzdIN1pmL2tHbXpZNlZ0ZWpOUlFTTXY3Tmo2RG8xMUMxL1VGODg3QnpOdHY0?=
 =?utf-8?B?c0NQVTduME56RHdQanB6WUdCRHh5ZjQ4N1YwZmNCMWt3VEFvR1R5NVlrRHZv?=
 =?utf-8?B?UnM0aDJDdjBGOU5CamlBWXZwTDVLaFQ1TysxY1hNSkd4dFpqaU1tRVZlakdB?=
 =?utf-8?B?ekp3NENaa3J0ajVBM2RtYnlsMmhaTGJzZ0Y3Z3FITU5JY1JIeGhzMXFkdVJ5?=
 =?utf-8?B?bXNKVU0xMTE4US9kbXg3aXpSL0srMUQ3eThuOVFiN1hJSmV6b21yUTl2R2Zk?=
 =?utf-8?B?cEFLcWdVckhCU0llOXpHdlVESmJ4bWFJS2QzVTQ1enJMdjZyY2RHWEhZaFVt?=
 =?utf-8?B?UGd3VTRGN1FxVFF4RktxZUZIMURIRlZaZkI2bThkQUlIZUhlR0t3SEdwLzlY?=
 =?utf-8?B?NzJ6a1BOMEcyK0E4QnRGY29CVGIxTHZ2Z2ZnMXhzRVQ4cEpjT2Nlc0JBbjRW?=
 =?utf-8?B?MkJ2SE1COXZ6clQ5dUUrVHdFY1pPcUNjc0lPTkFBTFBFQUlPV0ZOcWFBVmZG?=
 =?utf-8?B?QWJNVnA1YkYrNlM0d1ljZW1vVEZJcEx4VzlrOWJyVEtXdmJROTFTdU1aS3hW?=
 =?utf-8?B?RTI0ZUF5VGhiNXhPMzgveGhPbTZWelV6bTRERGZoa1VLZW5hUEJ3NFNhb0dY?=
 =?utf-8?B?UFpJM1EvNHgvN3Z4SFRuZW1LMVNlOGFNQ3cxMWtmOGh4dHBsZUkrNkNVVVhL?=
 =?utf-8?B?S3FCYnZtU2E5N3BPNEJyZ1ZvbjhHYTgzUzV2Z1RacERLQmMvazRXSk5Oa2xJ?=
 =?utf-8?B?VE52amljZUp3bWQwVkE4TmthcTNaYlZqYUxHcW5IaWY3Z1lMZUppYnNub0xN?=
 =?utf-8?B?bFFFcWxxcnp4NjBnbFVNTHlkb3JuRi9hU3NLRTliQVBwaHlLSXZvazB1Z2VB?=
 =?utf-8?B?Zng0bDJIT2docUM3aU5GSUxwUEV2OEFnWnNFeTRXOEROeHo1Z3hFNTBGU2N0?=
 =?utf-8?B?T2NHVlBjZ1lvMDk5R0RFalpKdXhXQWUrVk1LTTA0UVB3YlBFait5QTRrMHB6?=
 =?utf-8?B?ZGlUdnA2c3U3SHNDcExYZ0g1Yit3K0ZYczZLMERRbERPRFRKUmJHdkM2MHFx?=
 =?utf-8?B?SU4zMnk5ZmtmM3FoT1F6bG41WVRsK0gyVFJuRzVvZ3VBNUNhQmFHZi9jdXBj?=
 =?utf-8?B?ZTF0MUZmQzI0THhWNUpSVVAybXM1bVdRUGMvZHZJZy9FRGJGeEhzYnV2TDBZ?=
 =?utf-8?B?MG9ZMWRJak9lZUN5c0Z6MHE2cGtRWGw2bkRudkZ4U2JxUHdxWVUvdWRFVkNq?=
 =?utf-8?B?SFlxdHZvbnNmZzJKMnFsL3dBTWJOT001ZmhYdHBsdjlSelIreFREaDFrN1Vk?=
 =?utf-8?B?VVM1ekkrV2JUYjVINXBDQnVEZlJKNmIvckVxdEYyaHFlOU9kdzY4VFFiMWRm?=
 =?utf-8?B?QXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2f657e0-4f7e-4d13-c454-08da9cc0224e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 17:30:25.0837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O8SacIDkb21YWQq9TCwDsPvQHCFrxSlplLZd88DuRtzcXaK4VmSo3hRGYRhZIOLwhTgnImk3OkZE/uVDmvByvE9EBBIK/N1G676CzC06amY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5692
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_12,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220116
X-Proofpoint-GUID: JtVXxDoqpPuUkEn-y4CXnGp3X_D7uLys
X-Proofpoint-ORIG-GUID: JtVXxDoqpPuUkEn-y4CXnGp3X_D7uLys
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/22 12:03 PM, Bart Van Assche wrote:
> On 9/22/22 03:06, Mike Christie wrote:
>> +    struct scsi_failure failures[] = {
>> +        {
>> +            .sense = UNIT_ATTENTION,
>> +            .asc = 0x28,
>> +            .ascq = 0,
>> +            .allowed = 3,
>> +            .result = SAM_STAT_CHECK_CONDITION,
>> +        },
>> +        {
>> +            .sense = UNIT_ATTENTION,
>> +            .asc = 0x29,
>> +            .ascq = 0,
>> +            .allowed = 3,
>> +            .result = SAM_STAT_CHECK_CONDITION,
>> +        },
>> +        {},
>> +    };
> 
> Can the 'failures' array be declared 'static const'?

No, the struct scsi_failures in there get updated when we track how many times
we've hit the error.
