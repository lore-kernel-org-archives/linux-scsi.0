Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B87EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 15:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A2BC60F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 15:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237241AbhJLPzB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 11:55:01 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36170 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234892AbhJLPzA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 11:55:00 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CFX7dD032333;
        Tue, 12 Oct 2021 15:52:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=iS6ngmRxJ/9ryDZFcnU/QCw3FzFIYJghwcaP5YaBSoM=;
 b=Z3M/2Mor/UWu8Pbvpm9xGifWjihrtIQk64DY5J49WwguERtkeFzqlQ0D+N7eXcGg3hfG
 2i8eru9kiMYLsBVgiOV/cbEyEdTJPMKHi2yBq2lc88hSJPbFWIWjjC8W8tmasPP5ltif
 Vq1Dbph5fwA5nZv9ZWh6TiWA/5IuKmHkas+gfEYtsrI4ccT2NrAbzxB4RAaCq7EG3mOQ
 1sdYu7fD1E1G74WtxapibIxl+u12eP/zxC/HbSOS6KzQJwXwLizstuV7l20xcIpeWgLL
 xRME7WwVe4qIEzdsYYZuEUeiJcZh9NkmgeFyEZm3JXJe2DCHoY6Xg5UeaZ3Ld3b60y1T Cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmtmk7ak7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 15:52:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CFik5o180051;
        Tue, 12 Oct 2021 15:52:34 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3020.oracle.com with ESMTP id 3bmady7n7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 15:52:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B98EaZTg9quJ7cCTclna3THnH+QphBHIfXTPTk+ekl4EJpMvygWz8n2l2tqxFmcocDq0eIG8KxUzG/izxqiLx34vuu4rWrGvy0WsjdBbO3vUVVK2LDlvHVUaMdnnKZrdrJsfp2Ejf4ceJQbbyC2f8vicdNDGS0VpV3F+cnS8EdndetEhfXvuUKE+8h2o3jFf8E2+xgdy2mzrLR7GfhGnRH5PiXhS1WNSVIIa0gtCMP7XXLnz/zrJV/uKfGtqsT70CwB1g0gx69rNVuQjc5g66RhSsGy1KTiFWM8kyPaZ8nzPqxqwfDBCbNdJkTIi5fhXZFxK90C88E+KX1WC5BY+pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iS6ngmRxJ/9ryDZFcnU/QCw3FzFIYJghwcaP5YaBSoM=;
 b=U3fxen1VHm6biNubN2QVG5UHYsxzeAyrpV2RJ5njfExcfbWUFkIG+uxVJjFc5pgJTlDnF6F02d0o693j/hELt78mFLKjZmIUXa5326fhwfGfoClmcG1GDbGC160RC1li270cLS2g1WSw5vfk2aA0+dpGtQa7Kpp/s2mFKinM9wHbvm9kBOqJvbJ3eSfxN+KXOkoc2Wo+5LfwzGC0Fyc2xkK5U1CpPsxnNkxFGXz52FpG2I2mjMKtGFCMIu/td24Ya5kFIPZNCm67Wq1a7EM+HeiGQIE+gGns0m750B/gI4TgXByPV/HkQKo3j8UyDri9IMmXTSZe19qQbwDs/KMeVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iS6ngmRxJ/9ryDZFcnU/QCw3FzFIYJghwcaP5YaBSoM=;
 b=kHWSgkAd9IzjLWTqsc92l2nh1wOnmoaX4j7MGWF+AFA2Sqyv4eSP1uzBrEsJIw9heupxzKowUZfnoAIRUGXkQe4neNgqGuZ8R3gqnftuKf8Xl7vYU4uhB+d62pgy4tXpQY0lUpckcMQUGCzvfLoHaybGvWynbPqU7FrUwQmdvNE=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR10MB1835.namprd10.prod.outlook.com (2603:10b6:3:10a::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.22; Tue, 12 Oct 2021 15:52:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 15:52:31 +0000
Message-ID: <a2736fd6-fb15-9699-da45-e05fa41c3ea1@oracle.com>
Date:   Tue, 12 Oct 2021 10:52:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/1] scsi: fix hang when device state is set via sysfs
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     lijinlin3@huawei.com, qiulaibin@huawei.com, bvanassche@acm.org,
        wubo40@huawei.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        Lee Duncan <lduncan@suse.com>
References: <20211006043117.11121-1-michael.christie@oracle.com>
 <57607b77-7d3c-1a75-78c2-4a15d8863c82@oracle.com>
 <b9bd869a-a67c-77dd-96bc-d0fceeb8895c@oracle.com>
In-Reply-To: <b9bd869a-a67c-77dd-96bc-d0fceeb8895c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR01CA0030.prod.exchangelabs.com (2603:10b6:5:296::35)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM6PR01CA0030.prod.exchangelabs.com (2603:10b6:5:296::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Tue, 12 Oct 2021 15:52:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9026c3f-901d-48d6-77de-08d98d984c89
X-MS-TrafficTypeDiagnostic: DM5PR10MB1835:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR10MB18356CBDE026FB7251C8DC49F1B69@DM5PR10MB1835.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gd5MPqBv0YyuP3V6WIG8FWJ9UQfTt13R2C7TFKIcF0pt+wPeLRxFRSGmaHfdgGll3Rlnouxke9NqMks1+qvNlRqAkkxsP92Dc9AzJmftSGDTFZZFFLdVMTPEs+14lDods9JdY9wi0Nv7qM1DtoLZKe5qh4U1oTb8fqdgqw5fuC1o/Y9d+hFSyhmC31pJm2x88hvwzyiU99QNWp9Uqs6SkN35bxzkNf+k0xa7cBRAGZbiavaQ0ST7sRVaD97wshWGU1z/VKSK7uZajK6ZvnvpUB59Xo0fI9u7MPujVkJSJP71Q2YqiuNYph5L6C5umxVEnMQ4RpowfR6rfG0b0PUSxuRuUssPNsfCLixpo/vjzf1ln2VERMq3NY1XzjslyepqmQAwZII3NDY4LPgtECi5Rz1JkbjVeTF0hYj7YIXvvcuMc7qBSCtPnHhLD64t/L4RbBVejOU0uiknnrZpNWHUalQqc0pZbeznmE3Ola/yjEDeWe3OeWE1Ks32FxEMsUrjE4qlDLWmL/FCnYc2PgqeLheRizZWqGYWWyQ5jGoNsFdRh/BmarzttLNOakfywnaZ16HsbouYPlWKOXRGrDBmeUQf2xFkRjfSiGqsaYaCecGaGWT+4f3oForZf8U0Rj0Sk9PhuD6Vx+PAhx/spX9h/tBH6aEDg5DmAI6HUIcIZWDFtKvy6+uTeGA+pVYqrYzmXRqa+nwzWqrYo8T65kaekwYw3JLs88llbpHGIvT+7sM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6706004)(86362001)(31696002)(2906002)(508600001)(6486002)(956004)(2616005)(66946007)(5660300002)(316002)(26005)(8676002)(186003)(36756003)(16576012)(8936002)(31686004)(38100700002)(66476007)(6916009)(53546011)(66556008)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTQya3hJcTF0eU1tZm10cVZOdTRFUk4xdEhvUmdNTEcrNTVZMWlXUE03OTR5?=
 =?utf-8?B?c1dtZG01Wm1IUGZ2VmxoVWQ1N01GWitRcWhlWkljdkFBOW1LcFRxUGVHdis0?=
 =?utf-8?B?MjJDRkFqQUR2ekdreFNqYVNuZjM4L1lJVnBGbHRlMmVoSlJxUzJETUdLYlRN?=
 =?utf-8?B?bVQ1RzhBOGtBSW03N25ZZXRVUWllYW1JeDd3N2crNXZVQXdNK0ZaL0hHaktQ?=
 =?utf-8?B?dFlvS2R4d2x6Tm90VkVKakhxMXQ5WnpJN3V4TkMyQVYxNW5kcVF0QmZrSVZ0?=
 =?utf-8?B?QkNJU2ZWMHliT290ajVXWnZLWDBMam11VlN2NGRHdlBiTGtFZytOeVNkMjVk?=
 =?utf-8?B?aTgwUVBlL0w2clN0c1o2S0x5QVFySXczbXJNZ2JQdk1RSDJDejljTW02Smx6?=
 =?utf-8?B?VkRXdGRwQ3preWd1ZVYwN09iUjd0N0FzT2pXbkVrNzJoamRneXBONTV4eXZw?=
 =?utf-8?B?L0xGekRtN0c5Mm5KVDUrd29GTXl1VFRWdnBXRGZFeWZJUVUwcjVmd3k1L0ZI?=
 =?utf-8?B?ZllqQUUyYlVLdjJENExjZm1HTzF5YVpzTW9NSGRqQVdmSHZxNGQwRXEwN0I4?=
 =?utf-8?B?MTJ4aWFZODlITWdrc1BoT2c2dFdyektRS1ZrSkFsMVBTOUtHWTkxL1BFUjZ1?=
 =?utf-8?B?OTdyaTYrU1ZPb1Q1OUJ3VFYrTDdFK2dtaFdqL2pvS1pRa3FmMTRCYjJJYm8v?=
 =?utf-8?B?OE0zUSt0Qi82T3R6UENUbmpEVHZ0ak45TkNETjNZV1B3dGlETG1YcFBBRW1s?=
 =?utf-8?B?NENkdGJPai9aT09neWs5OGhwRmNLU1pMdC9NVHArVnlGNUNaYUpWZTNxQ08v?=
 =?utf-8?B?MHpCMENtcysxdHV2RFVpcDNKbjQ4ZytnSDRaSjZiT0U3dDBHQ1F6QW1USzV6?=
 =?utf-8?B?QlJxRERCcENKVkkyMEpJMWVjSVcxeXNEbjhUZXNnTjZMZ2VxSzFDMTFwaldT?=
 =?utf-8?B?amtBcVlwYzU0UzZVYWtMNWhIcVloOHluMllra280UHpoVUM3U2lmeFk3Ukt0?=
 =?utf-8?B?QkpGY3M3ckFBK2RCWEpwT1hpZHh5VVlUT1pFOVRvMUQ2Qk1Ceng0UzZqU2gz?=
 =?utf-8?B?dmFyUGVocEZFcWlPYncrMVV1TlNPa2JNU280Q1EyZjNybU92TEVBTnhlTXNQ?=
 =?utf-8?B?bGdpMFFwcjRGQlFWSTBiSW54Unk4YU9nbWhVV1daQVdBblFUbDRFa3RBTnln?=
 =?utf-8?B?K0RUei8xNDAybjJYWUlXWTFSVUVLUUpKVTZQNHFYOGpoSkJEYThJYUlDelJ4?=
 =?utf-8?B?V0NBem54SDZFa3dZajNFWkpPenErS29BQWNhVnhBQmRlU1NFWm1Cd1ZtVmc4?=
 =?utf-8?B?ZEZJeHhIOGQvMXBOZzFoSzMwMVJIM2FxSlNkWGR2dnoyVmQvaVVQc1IwT0kx?=
 =?utf-8?B?MndGZzZQeTArMTYwN0pET2lRbXpxcjArby9QdU4vTms3dGdrNUZwZnlUZlY5?=
 =?utf-8?B?U1VWYUZkazZwSFRscEpQWjZ6dFZ3TmZwZmpkNGpNc1hBMlFTYWkyY2kxQVU3?=
 =?utf-8?B?WWJiUjg5RUNIbW5udXAzZkJveWh2YU9pek56LzBhbkRsaXFlWkFjYzNJajB6?=
 =?utf-8?B?MXhhRDhjcDEyNzVpdklnb0owbEpUYkQ2TmZ0YWhLTGJHRHZVa3FZZU9XVVJQ?=
 =?utf-8?B?N1FjNjBTWW51aGI2MnhveVVJQzJHUm9jc1hlWHBnYW9jZXBTSnVjYkU1ekVy?=
 =?utf-8?B?YkRvdlJrakVuUTJNMEdXdkxJdnZGaXp5WTBmOGU2WTJ4R1BuMEE4Uy9QRXhw?=
 =?utf-8?Q?y4Y8jmjaCWwZA2u+yURkwEOLqr7NW+9a6Zmz2g8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9026c3f-901d-48d6-77de-08d98d984c89
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 15:52:30.9848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5T+uTTZaQO+Qs+JZaJlBGqK/NU+A8Bzn8Qx1CHARfCzWTF0+L5+Vr4bXrKknz98kzH8N/AlksQ5C0x6mAPjNfvJ1ArJPC8rZYkjZChgtuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1835
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120088
X-Proofpoint-GUID: suJ8NuIJTj7p34pXOWtKA8-njScmd6Bi
X-Proofpoint-ORIG-GUID: suJ8NuIJTj7p34pXOWtKA8-njScmd6Bi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/12/21 10:50 AM, Mike Christie wrote:
> On 10/5/21 11:45 PM, Mike Christie wrote:
>> Cc'ing lee.
>>
>> On 10/5/21 11:31 PM, Mike Christie wrote:
>>> This fixes a regression added with:
>>>
>>> commit f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
>>> offlinining device")
>>>
>>> The problem is that after iSCSI recovery, iscsid will call into the kernel
>>> to set the dev's state to running, and with that patch we now call
>>> scsi_rescan_device with the state_mutex held. If the scsi error handler
>>> thread is just starting to test the device in scsi_send_eh_cmnd then it's
>>> going to try to grab the state_mutex.
>>>
>>> We are then stuck, because when scsi_rescan_device tries to send its IO
>>> scsi_queue_rq calls -> scsi_host_queue_ready -> scsi_host_in_recovery
>>> will return true (the host state is still in recovery) and IO will just be
>>> requeued. scsi_send_eh_cmnd will then never be able to grab the
>>> state_mutex to finish error handling.
>>>
>>> This just moves the scsi_rescan_device call to after we drop the
>>> state_mutex.
>>
>>
>> I want to maybe nak my own patch. There is still a problem where if one
>> of the rescan IOs hits an issue then userspace is stuck waiting for
>> however long it takes to perform recovery. For iscsid, this will cause
>> problems because it sets the device state from its main thread. So
>> while scsi_rescan_device is hung then iscsid can't do anything for
>> any session.
>>
>> I think we either want to:
>>
>> 1. Do the patch below, but Lee will need to change iscsid so it sets
>> the dev state from a worker thread.
>>
>> 2. Have the kernel kick off the rescan from a workqueue. This seems
>> easiest but I'm not sure if it will cause issues for lijinlin's use
>> case.
> 
> I have not heard from huawei, but I don't think we can do 2. The problem
> is that I think userspace will not assume once the write returns that the

Meant userspace will now assume.
