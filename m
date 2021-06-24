Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FA6C48BDF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 04:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E6926100A
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 04:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhFXE3g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 00:29:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36586 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229379AbhFXE3f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Jun 2021 00:29:35 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O482Db020599;
        Thu, 24 Jun 2021 04:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SFHAWFcuRrUSSuuo47wb4NmnlM2rH+iBhUZUsIYNpYU=;
 b=gDZ9GPAvHm3HSSOVhLkPEhK48z+sVSmeWams+coKE1dBfYnZGb2RUt5e6ij/HTaBt+y2
 FbvSHLOWplkRk0XebuR+nyRAebsjk2+yavXYRPuhUYMbPregozm15XiL3WOPyynYP9IB
 rP+Fej451gYZPKcdJvw21jcDOYpZ/KExrUK21CqvGTX+pp/jMba+3vEkokr/MMldJeml
 sX8d8ZJYa6Ix9ocd3PZ5TUwqYU+WIzARDjqa3UL+EvXetJSI3KiqJzVEKQ0tuNNgsHLW
 oRODi7rK05vqFdprmk0xa2CL0f1HUK0MqKLEh3oHZxBZeedtQ6+B9mVe3YnQyAd2VhWJ jA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39c8tw8xmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 04:27:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15O49Vms046486;
        Thu, 24 Jun 2021 04:27:13 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3020.oracle.com with ESMTP id 3998da0d5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 04:27:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3IKKwYtlyo8LWy3Kcp4WHx71cEPhOdTs4a8WW5v/1SxYF2euJQYf7VgU6dKyuCOAapAznr1a0SmEIM8+DQ76wcgQc7Ml5BmOtlIWFq6mklNFlWY7cyYOQ9XLYSrtIPJ6151xCrC014advkmX/cDO3E555vPHQI+2u9oGeOPXaFS1+AQ5mBqm2Na1sOcCsuYLDfAsKtz9AehhwoFzprKLSBcZsHFmkcj6wOHVoKpmiAOI8OP8BPobwMet2wC+f6y35vUq7maURIz19nMfZGXhH3++J9QYUFWpo/8T2tPHAGdl9Q+mWrZsZxr9ighjc4QTd91obNModTh/cAohOgLDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFHAWFcuRrUSSuuo47wb4NmnlM2rH+iBhUZUsIYNpYU=;
 b=LSHkt2Lw7mePJhfof4un91OBJVmUqE4JtEosKqlQLvgW8+v4s0hhZqptSS201C3RStTevXqpA/hkQR+7v4qNcDqgMm0y2jpAbb1B+JFMYGfkIpMk2GeR3OwLiFAn9rXpEpkq9Uq2pSVHKkSlTkR3/Sz671vxFatmbYyGJFY5rbh4XZv9v7LLOZX3WigsDQffo2g04pBxrmyzxB1D7DQfZFUY8CSNWOpPNgOqwMbe/5FhcZnXRW5h7Coxm9JEfBuTGZBo0snTTwzJV9oUsEOuM1phz4A0dx2mKqJpvtuKD3ATcjWrg1qwnQdZT66st1b+xF3KXVKtPXBs/9m7OsRbXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFHAWFcuRrUSSuuo47wb4NmnlM2rH+iBhUZUsIYNpYU=;
 b=Z2QyssoIUGdUct4fgu2evK4DjLKaIpUGa9dYZJjo6AHszunDuROtUv/Xx7yxEExLnJXPNOk/ZHYTUBNmG1gceSFqY1YsA9Yd+v8h09MGUZyE42L6EGVSVDjvCILyRrOWK0MwigikSpcU3BzjlGyuRTTiMWYaPepZGL92BAPYYEA=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2944.namprd10.prod.outlook.com (2603:10b6:805:ce::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Thu, 24 Jun
 2021 04:27:11 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4264.019; Thu, 24 Jun 2021
 04:27:11 +0000
Subject: Re: [EXT] Re: [PATCH v3 10/11] qla2xxx: enable heartbeat validation
 for edif command
To:     Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
References: <20210623102611.3637-1-njavali@marvell.com>
 <20210623102611.3637-11-njavali@marvell.com>
 <9862c087-71b1-92e2-677a-a74330212de4@oracle.com>
 <CO6PR18MB45009B91FA30BDE67A994F9BAF079@CO6PR18MB4500.namprd18.prod.outlook.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <e793b8a9-54f3-68ba-c853-39ff8eb7e011@oracle.com>
Date:   Wed, 23 Jun 2021 23:27:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <CO6PR18MB45009B91FA30BDE67A994F9BAF079@CO6PR18MB4500.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0501CA0094.namprd05.prod.outlook.com
 (2603:10b6:803:22::32) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0501CA0094.namprd05.prod.outlook.com (2603:10b6:803:22::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9 via Frontend Transport; Thu, 24 Jun 2021 04:27:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc45501d-3c39-40bf-271b-08d936c855c0
X-MS-TrafficTypeDiagnostic: SN6PR10MB2944:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2944DDF4D8A2E1CFDE2AEA55E6079@SN6PR10MB2944.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:260;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GDXpBIIgla0RbyhGBwTdtUh+dvtYmIlvrDm8taEI+CuofyMWczrlSuUWNh5W2fwLf4eDCKK116ai/NkfsAqwrfpeWF7mteBEAr02u0ZvZbwxtPGLnTeESBag+Mm94o1BACncbvbeLOZPguGd2mZrY52ag2lVAb4Jf/uzby1mu3N0LV9eRfjIXrjfWWx5dksSGI8qPydUAB5joIpFU3HUZJYsTmQZXUgvbS7fRJmeN6VtQwu3jdoKTWIuUjR2AWYQkOdJqFm96hlRyBwFFieYIq/MA9xKmgv+y7F76Z9xk5vMUXesfQj70KTlJKiBfrLmKKBYZYQtzktxKaGLqSleSRxM+29HXBsqKyJLSiSJVeSeEAiRGOCj5GFN7tEJl+/OjoD+w5bCW3sb9mV3vYjtlEMh/1prWRmGkJlxMFIMGDmoc1NZ0w3wQ3POsDMrersOub9FS/DWQAIQ9768aWceSN+yTms6sU2PzJ/TtLkICoX2F4z+z94o2o7jjnTuSRFAf3rTlfObY0lraAy/dJN5zFa55GiEQ7SmN8NZ/1Cte14oSXPpTeqoOP1mJm+2i+RiunDfS+vy4q9C4yzTe0Xrn16V7bBFCWbLaQynvk4X+jqtX1pnrBGXXiuZXVIm6kBq0tyP0lt2eBr7iNuRR/EpRtwmlUIK/LNU78jTFMq14NDMjXhnNNifxBC13X1QlOap
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(346002)(366004)(956004)(53546011)(83380400001)(66476007)(26005)(38100700002)(2616005)(36756003)(2906002)(66946007)(4326008)(44832011)(5660300002)(478600001)(36916002)(16526019)(186003)(66556008)(6636002)(31686004)(316002)(16576012)(110136005)(8676002)(54906003)(8936002)(86362001)(6486002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3BoK3BFOWp0dWZ2MWNwU2NJUHdNTXJNb2dGZHJCS0lXU1d4c0JyZTJVMG9h?=
 =?utf-8?B?RWtiUHV3bXZsaGZOOXdOcHRDQks3TXBHYzFkMmpaU3FMdjI5TTdSTVFmeFU3?=
 =?utf-8?B?cC93YUxZdVRCSnJBV2NQcGRQZzBPNFZDMlBlTzBiRXdMTDVqaHd3RWl4ZE9a?=
 =?utf-8?B?dndhcHlrY0NybldobXhGWURhVGJYc2ZlTFgwcE0xRitMcDNBWldwWnRMWXJQ?=
 =?utf-8?B?WTN0VlhENjNjVW4yMGxZK2V4ZXRJZzZRYUdIQVlmdkgrb2lGLys4THNYTlgv?=
 =?utf-8?B?eHJjLy9FUHU4cC9GcTFVWUlicmxQcmRCNzlPSmxMQmN4Wi9hWUMxVllzelkx?=
 =?utf-8?B?VzBiUFpVVUQrbmd0VVJlY3dYS2JFU3QvRmdtUGJtbGxmSkR5QVpTZEVrak9B?=
 =?utf-8?B?V2tPQWlsY2FRaUdZdUFramlFU1RHZER1V0ZBRXdEQ2Y1TUxsdFpYWThQSDB6?=
 =?utf-8?B?dURKcnNkUDJSOE5OME9ra3JaWndYSU5TWTF1eCtyTStCWHVBRkxKMk1oeTJn?=
 =?utf-8?B?aDlPVmx3YWJXdzIrKy9lcmNMRitHVTgvLzZZU0tleWkraEpXekY1dEVYUE8w?=
 =?utf-8?B?ZHQ1NUU5bnZzbTNKNzA1enlMeTVUVXBvQU9kN29CNk02K3VGTDMwbmJvQ0la?=
 =?utf-8?B?R2g3Q255dHpJNGljWDVSZ3ZtYjF6UzN1aW5HSUVyd2phdGY0TW4zaWU0czFq?=
 =?utf-8?B?WTFGYlUyc3lucWlpSlFqdTdvcmpndUpETFdaQURvZGVsWklJRzMyd24rMlN4?=
 =?utf-8?B?T3lNbHJtNFdRNm94ZW0ySHdFbFY5cnJVZHF3QVh1NFhqY1RjVjN0bjRUU0lm?=
 =?utf-8?B?N2N5RjhTRUFORzUzRDBpSm5GZytDczZndG9hYStWNklnaGZhVHhSdFMrb0tM?=
 =?utf-8?B?Qzkrby9PNEx1N3Zvejlsb0NhM0hJWWkrbjBvRko3aTFNMm5KT0d3LzMwTjdl?=
 =?utf-8?B?bE93cVVrU0tFRXVLZndmd01qSkJ3UGFFVFhhQWVwbnlCenFhNkg0TzQ2b3pK?=
 =?utf-8?B?TG5iNlBpcGpyNytpN2Vib0w1a05YL3VaMDV1WWtMQ1ZzTFdlOENDYTR3V2M1?=
 =?utf-8?B?SUFVTTZuMU1maGR3NnNRZ3kwR2Z1VnRnb1Y4RE9ZMVQ4dGhaN1dVb21oTElr?=
 =?utf-8?B?dlRnVitmdm9DT0JBcHZtTEhvTDNEbE5BMWNjTmFBanhGb3BQTVFaTURtOEdW?=
 =?utf-8?B?bG1UT2Vka2pLN09OTjhJSE9DbVNvNmwwMEJaUkdNUDBTTHBtTG54UURmbklx?=
 =?utf-8?B?cC84NXpTcEpBUVNBcW5YaDV2ZEpqWElibElRYmNtZzJMZTZzYXc2bmRjancv?=
 =?utf-8?B?c2tRSm5UQVhvWTdTOGJ1MTNaU1Y4N0NXd2hiaTYvbmQwRmFlOXVraTVGTDlV?=
 =?utf-8?B?aVJaQjI0ZTR1KytzcFA2OFY0a1FpdXh5dWhNZmZSM3haRDhsb2wrU0VsMTlq?=
 =?utf-8?B?dDFpVTVad2xudFV6MmhQR0c0ZEZFWlJzYTUrbXNQSlNtSWp5YmwyUlhNRTNh?=
 =?utf-8?B?UUwySHpkT2Q4cGNoWWo2U1hvblBQNnhkQStCUGdhWENvcjRnMk9pRUlHcExM?=
 =?utf-8?B?T0ZhVi9RL21SNCtCV1RSbit0ZFJjcW9PSzhLY1paLzQ5aGJtQlBMczFtbFVo?=
 =?utf-8?B?Z2t6ZitKZVJIUkhnNVpwMUF2L2Z4MXBWQ1phL1d1RjE3NG1yZllrQWtKNGxh?=
 =?utf-8?B?RGNjZCtKY0ZwY2ltM1ZKMWZlQ0VvT3AzWE1GRWxKck1uYWNqeG5Td0VFT3RJ?=
 =?utf-8?Q?tjhyvjYnflNbscg3A3y5bTSU/cB36RDorm3YjSD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc45501d-3c39-40bf-271b-08d936c855c0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 04:27:11.0660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUjfaAS/Xa3g0FDqWVHN6tYAjCZppOaQZt0BVOjHD35zLlHSV/IkrNp0msq51UZJXSicEOyMTSoU9j5WKDSiQDg1Wly0Ap1k3fDp4WIBj9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2944
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10024 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106240022
X-Proofpoint-ORIG-GUID: ffDv_rT6esC5J33Av4j-i0_nk7ArSA-Z
X-Proofpoint-GUID: ffDv_rT6esC5J33Av4j-i0_nk7ArSA-Z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/23/21 11:02 PM, Nilesh Javali wrote:
> Himanshu,
> 
> The heartbeat check patch attached does the actual validation,
> and the same is extended for edif commands too.
> 
Correct.... this patch is not doing that enablment right?

My point is that your commit subject and commit log does not match. it 
should say "qla2xxx: Increment EDIF command and completion counts" 
instead of "qla2xxx: enable heartbeat validation for edif command"

> Thanks,
> Nilesh
> 
>> -----Original Message-----
>> From: Himanshu Madhani <himanshu.madhani@oracle.com>
>> Sent: Thursday, June 24, 2021 12:17 AM
>> To: Nilesh Javali <njavali@marvell.com>; martin.petersen@oracle.com
>> Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-
>> Storage-Upstream@marvell.com>
>> Subject: [EXT] Re: [PATCH v3 10/11] qla2xxx: enable heartbeat validation for
>> edif command
>>
>> External Email
>>
>> ----------------------------------------------------------------------
>>
>>
>> On 6/23/21 5:26 AM, Nilesh Javali wrote:
>>> From: Quinn Tran <qutran@marvell.com>
>>>
>>> Increment the command and the completion counts.
>>
>> I don't see enablement of heartbeat validation code in this patch.
>>
>> Am i missing something?
>>
>>>
>>> Signed-off-by: Quinn Tran <qutran@marvell.com>
>>> Signed-off-by: Nilesh Javali <njavali@marvell.com>
>>> ---
>>>    drivers/scsi/qla2xxx/qla_edif.c | 1 +
>>>    drivers/scsi/qla2xxx/qla_isr.c  | 3 +--
>>>    2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
>>> index 8e730cc882e6..ccbe0e1bfcbc 100644
>>> --- a/drivers/scsi/qla2xxx/qla_edif.c
>>> +++ b/drivers/scsi/qla2xxx/qla_edif.c
>>> @@ -2926,6 +2926,7 @@ qla28xx_start_scsi_edif(srb_t *sp)
>>>    		req->ring_ptr++;
>>>    	}
>>>
>>> +	sp->qpair->cmd_cnt++;
>>>    	/* Set chip new ring index. */
>>>    	wrt_reg_dword(req->req_q_in, req->ring_index);
>>>
>>> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
>>> index ce4f93fb4d25..e8928fd83049 100644
>>> --- a/drivers/scsi/qla2xxx/qla_isr.c
>>> +++ b/drivers/scsi/qla2xxx/qla_isr.c
>>> @@ -3192,10 +3192,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha,
>> struct rsp_que *rsp, void *pkt)
>>>    		return;
>>>    	}
>>>
>>> -	sp->qpair->cmd_completion_cnt++;
>>> -
>>>    	/* Fast path completion. */
>>>    	qla_chk_edif_rx_sa_delete_pending(vha, sp, sts24);
>>> +	sp->qpair->cmd_completion_cnt++;
>>>
>>>    	if (comp_status == CS_COMPLETE && scsi_status == 0) {
>>>    		qla2x00_process_completed_request(vha, req, handle);
>>>
>>
>> --
>> Himanshu Madhani                                Oracle Linux Engineering

-- 
Himanshu Madhani                                Oracle Linux Engineering
