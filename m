Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE999C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 17:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACF1261058
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 17:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhKDR0k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:26:40 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:62760 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234610AbhKDRZ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 13:25:26 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4GwKTo032488;
        Thu, 4 Nov 2021 17:22:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8xjRDzDfdkAkURoFc78KVnv6nrHkppQH3BlOo3PZMb8=;
 b=vPGqvfpeCpjcRUBt8NjIpPxW+9CpWkEF/sclS26N40Fsq1feUEbvUTmJFPytG/CTq/pj
 HGfaXvBpvr5QucRZzqNo+9c+OtOaQX3t5NOAo1vWjGhgS8Q5jaAKEDOjXyyYm4BRoB8u
 wR45jtO7a9vknP1TciQ/KXfE6JczH4I14idup4IrvxTDJsO95upcY/oQv+fPOOc/bA5Z
 GJIfM9jS/RbY3ODPVFbB68sOhL/QGo5WZ56kBubTNO7REmr0ZLMKxl4haHNKDk2FG0U6
 hr7Ra7SWpSC7//c2GGhtJq83snblB+qAaZxwcdR7Kv6P4SarrZSqNgU8iqnDOVjMT043 VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3ju72hwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 17:22:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4HGOoE034474;
        Thu, 4 Nov 2021 17:22:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3020.oracle.com with ESMTP id 3c1khxh6yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 17:22:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTTpa7/p7cOPjDmeM/jtut1RY9L/ZBWaafqPUiRiVdxar6J9vNSzxtTBZnCeAeIspXGwQEp1FsFGMpCfE1xJOjjOL0gKDKwD90ToCmEd607N59tkVJ6w8cJ0BBefJhjsutGj1qLtd1wWzrUh4DoF8AOH+S+yVM8xoLlsyrmofNra5Emsxjxw1HvbLAMc9D/tFw4q+kQ94QvkdhXVR4sl0TJXkemCl7Vgb1sTOYYACfNWMjvfw7BOkhwJuxPT3l88C3XP4T2Sn3d6I0Lx2sXiGYGSDh6t0Cmp+gAHN0Pi/1bBOf4IDC6AP95tJUKlYmePabWUv+Xz+20pf0xRhVkk+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xjRDzDfdkAkURoFc78KVnv6nrHkppQH3BlOo3PZMb8=;
 b=HuDUoFrCvW4/neZJmro6d/6RK6arUIljn1q7L0M7isO1/xsQADHIUB+wswzaYGCX2uNuZqDegxc+TjL0QZPgqbOC/6WyST/cDN1faJATNlVxa2k58WaInHnQpQf5pujhvfTdGOtgC1bUtwzJUviKx/00fMv4ou1Bar2p0Py4NdIcUhO/hNpdOo1CKT2DOff2nV/FUh4URO4FJNoJ0K0MFxh74M9rPyJ8Ho5lv+pPBogQ9fIcS1YTvZM2DEY0WnHZIyhdRPczld1ZvBt5XuMEgxqpo7Kzoj5PokW2/bYiA+85YIX36YvYzPQR3KheR2qjAHq4D4dVj7k8yKFDAE+8Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xjRDzDfdkAkURoFc78KVnv6nrHkppQH3BlOo3PZMb8=;
 b=LDdjYeM5UtDI29X5dyZ9OMMXN4rm/+C+HoJ5OJHZTeUdbc9NlBZ971TIWFWSj04KPWNk66vtjYk5s0S1EpzKtamPJcm1qWDVv/A+z3JzXT7YVM5A6aCZ7+nB3OvoiEObUgNR2AbnvVEmPVpIwSjA0yfnY0jdKkKGGxjJp82Ws5w=
Authentication-Results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN0PR10MB5046.namprd10.prod.outlook.com (2603:10b6:408:127::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Thu, 4 Nov
 2021 17:22:38 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e%5]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 17:22:38 +0000
Message-ID: <a7b4e31b-d548-5a29-9d98-fc6e916ac7fc@oracle.com>
Date:   Thu, 4 Nov 2021 13:22:34 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] scsi: scsi_debug: fix return checks for kcalloc
Content-Language: en-CA
To:     Joe Perches <joe@perches.com>, gregkh@linuxfoundation.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
References: <1635966102-29320-1-git-send-email-george.kennedy@oracle.com>
 <834e83a227f40c4654b97f2f0b045b4cbd326f16.camel@perches.com>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <834e83a227f40c4654b97f2f0b045b4cbd326f16.camel@perches.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:806:130::11) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from [10.39.233.139] (138.3.201.11) by SA0PR13CA0006.namprd13.prod.outlook.com (2603:10b6:806:130::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Thu, 4 Nov 2021 17:22:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f5717d2-73b2-497d-55f0-08d99fb7b2b5
X-MS-TrafficTypeDiagnostic: BN0PR10MB5046:
X-Microsoft-Antispam-PRVS: <BN0PR10MB5046C487008CDE322D1735F2E68D9@BN0PR10MB5046.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w6p14GO8as+ZtDo7IfGz/uTEKuEwjMnsLSBLmx7QUP9UnCGyaxs7FEVuo81j/9RuGsfmQJe1StTkvzciwlBaBHfRA2Tjh8AAYvUquBGGNeH+xNpsyNgOlU2/zC7vHUuRIaqu+2RVJIqnXWfbo9yP8iU/9LOoJA+Nii4bGkgY69oCqgSZYr+xtGyZd2TFifXUfigwYQIXnQLEvzmCyHBdK+Z+e0LGGzSWTnDHlc5az6Zi/bZx3Az1sVSx3sQke/m33JR3odmP19MslrLo8/sxMMHr35s7YFwPKTRyHndpb4cGwBwYLdzMhaK9Tm6pC1ljG6AtqOoSXDRQTvu/FmyrHYL1l9yFGlMW5nHp5koN5r2QOCPK7y6COI+xHN76olBTEdesmh8yxF50cXy11tbFbpKRJ9cYSXou5oLoyhx0z8tTKSiTqGU0UXB4WygRxfxTxsCmVext3zoDqKyXHhziYYQSwo757TfzZvWKPTVkG0knXT8XZhq+9B7Lq0EqeS+2oFjl6hg8ebRrW2vojtErIo8bLK9m6My8f8Xh/LBWuaa8kEYSLmaJkBIBeBr6jZqjHrqYLchJxwovbBvByMw0TNm5U5/bRvxjaLX7OOWA+SNpOlQ+ab/dWiHYB8T03zIb3LQb06sa3nMeJ3ZzMjI+Nth0kPwrgebg9GxgLInPqwiwZN0xp6wVH7Ie/oPBaTi986t4NOZo5ANVfa/Xtefaj/K560Wl5E4mvB5rx8fGC7M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(316002)(2906002)(5660300002)(8936002)(83380400001)(31686004)(16576012)(26005)(66946007)(6486002)(53546011)(86362001)(6636002)(36916002)(8676002)(66556008)(66476007)(44832011)(2616005)(31696002)(956004)(38100700002)(107886003)(508600001)(36756003)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ri82NmVrcDN0RXg2eEk0dmpuNytyc0g1YzVKWTR4ZDF1Rld1WlhSbnBtT0o1?=
 =?utf-8?B?dlhwblMxZFo3Y3ZsdDVpQktOd25GYzFxRkZmSXdPakJKMTdHd0dyTGRhNTh0?=
 =?utf-8?B?aENma1k3SUR3a3ppOGpQWnVYMllVeVkyNklXbEpDcjMzengxamx1eVRhVmxo?=
 =?utf-8?B?QnRKRWFyOEF0TXFEM0V1Z1BzSXBnTHJHMVkrb0FVWlpwZkpRL3ZlVFJCRFN5?=
 =?utf-8?B?eTNsdEFFeTM2VFZ3T1dnellWb3pYTEF4dFFxejE5ZFIyeXJ0aGMvTXRPRkYr?=
 =?utf-8?B?eUdvRHZKVFJJbCtySUNQMmJBcDh1Q1RHbUxuU2tPaWNiVzlVNk5BL2Nxc2w3?=
 =?utf-8?B?Ukl2SkFxTEIwNCtXTGtidlRTb1FnWVhOWjIxYVpwQkRmdzFWdDB3enRaeVhU?=
 =?utf-8?B?Y3R5V3kyN3BtRjJZdTcrWERhcGZFRXJZNVZNMXk4OGFGYnBnUW1QZlJpd2JZ?=
 =?utf-8?B?VGJlbTVQRVVQbG5INmdETVV2eFZWUE5kbEI1NGs0L2RrZ0FBZE9tNGhlS0pR?=
 =?utf-8?B?UjVmd2pJMno1R1dQQTB3azhSa0RDSkxHbnpzbVRWWEdoRi84L3RXSkY4Mmxn?=
 =?utf-8?B?Y0VVcHh1RW5jQnJsc3ZZbzVINStML09jSWF1NTNjNmRlZ29Sb0FFZWk4Zjdp?=
 =?utf-8?B?MVNMaHF4NjR1a2FzNitOTC9XK0lxQ1QxM2RpUW96d1ZqaU1oZHNFVHBHQ1Ew?=
 =?utf-8?B?WGxMZVQ0K1pDNlZ2YThreTF5Slg0dS9sdkNUUFVubW42YlhGOHFjREZJanVC?=
 =?utf-8?B?VVFyZ3djYnBFSjVLL1lZYW5QMXVIcVBUUitydDlETmM1WGZOckltdG1WVDVR?=
 =?utf-8?B?eU16NlJGSnowS0hqUC9xbld0d1k5WnFsVC9LS2M3RktFdWR5aHRTeVcvT1RM?=
 =?utf-8?B?eUhwanBMbzdyRkdpN1YwOXVyNVVidWQvOUhNbmpVbjF6Wmd6SGxzZjF4S3VB?=
 =?utf-8?B?a0JBZ3pIRHpJckg5NnhtM29WWURpRFZuY0V1NWk3eXVRZlJDQ1JsZFFkbkYw?=
 =?utf-8?B?UmtEN1E4bW4vRkROWjBEYkRERXBLQWdhVG9BNHJLN3p5UFVHZ1FlaUt3aUVF?=
 =?utf-8?B?THlPRUNyYWsyUnZWZHM3NVBheW9vL1huZU5ZbVVJRjN1SFVhcFJmelBtQTJJ?=
 =?utf-8?B?cWRhTForK1B2NEU1OW0yZmp3eEI2S1NqWC9Mc1kxUVBvNWNEKzNWbFZMK1JW?=
 =?utf-8?B?Y1hFS2t1eWRYM0c2clR0Sm1vWVNCVG41cFJNOG9jblI0S3l3b21nMlRQRUxz?=
 =?utf-8?B?bmJzUncyNHZodW1IT1VHOUl5VFJSZUpCQXJ5MnBrNDVnUzB1ZWlPRU5IREZu?=
 =?utf-8?B?TUY2akJ0RHZMVWNuVHJyTCtZbnBPa0VraWJ4amgwRjR0dXVDMlgvT1NNdTBQ?=
 =?utf-8?B?cDBMemtOWlNOb0R2NE42U0JwMlMrMkUvaHlPYTdNajU5SC83THc5K3JnY0Z4?=
 =?utf-8?B?N3VqTkQxNlNqZnJsMGVWWHJMR2gwNGV0U2I3WGhyWjNQcWRscWFPc1pGcmwz?=
 =?utf-8?B?T045aWlDKzR0eExXaEFiVzNUQWRjbnBXZ3FZQW5ZdXVqV1VtdFFpSTZ1VEVB?=
 =?utf-8?B?c1RhQTNnZk1NNEFjZVVRUTMzcGllSTd2dGo0M3RnYVMzOTZXWXNSL3N5Wnky?=
 =?utf-8?B?RENtVm9GRytPNnNPUUV5S1ZGWlVidTFDWFpFLzZ6QVRvSm9tc2syRHNRZGtq?=
 =?utf-8?B?bFlIVEFiUTB3YmN5UDZBWXoxMTR5RzdNejJmaVlRY2swUGtYbmFBcXZOcStF?=
 =?utf-8?B?bEFkQndRSTlpa1ZBZ3Fmd2Y0S2htclVxMVZ1SjdHemxHQjBVNnQ5aktCTmFv?=
 =?utf-8?B?RHRTSGVyTTBHQzF2U1YxSVg5UGVMeEh6dENNSWpuem5NN2dhaytDUy9mY2lz?=
 =?utf-8?B?K3d6YmxoUFVrcDBpcjdDTzN3RTJmYmRHUVJWVHFKalBKV3FoMVFaaE4zY3pk?=
 =?utf-8?B?MVE4eFE4L3czOUx0cUJvbVJ5STc4OHpiQU9DdUpLbnB5cVFCQkpJK2RkcStz?=
 =?utf-8?B?R3ZKQjRqWTE5bUp4TFNYYmg5cTR3STN2R2ovRHgrcHlvS2VCdGZkSlhLZVlE?=
 =?utf-8?B?ZFoxQXduY2kvTVA1ODRJbFlOTlREZzRDTnFHdWMvbUp3SmVQcUdaRkZ4ektn?=
 =?utf-8?B?OW9VT2FSdjZqVEdaRE9VZGhuZ2lqQ1NHOGZrQ2NFK1lZcCt5TnpaejVsK1Ju?=
 =?utf-8?B?NzJRZnBuZy9jZzcxOGhxYWNTbkFyVFlNc3RaWEFEQnljejBFVGJ1R0RSTDFy?=
 =?utf-8?B?T2kycWkyb3BxOTRySnM0OUtxbUx3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f5717d2-73b2-497d-55f0-08d99fb7b2b5
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 17:22:37.8981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6pNGRtncBKbim43vcxSon/z6LSugY6YUfoVjOXK7ULUvpIO4mgx31TVr34mMDCNzNho6Ybfva53hjIFrKUO6eiufN08AsaEoe/zI9Tx3e5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5046
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040066
X-Proofpoint-GUID: TscKvuWHQP5lDNNhqVfGtXfvAvZ70fFa
X-Proofpoint-ORIG-GUID: TscKvuWHQP5lDNNhqVfGtXfvAvZ70fFa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks Joe,

On 11/4/2021 12:04 PM, Joe Perches wrote:
> On Wed, 2021-11-03 at 14:01 -0500, George Kennedy wrote:
>> Change return checks from kcalloc() to now check for NULL and
>> ZERO_SIZE_PTR using the ZERO_OR_NULL_PTR macro or the following
>> crash can occur if ZERO_SIZE_PTR indicator is returned.
>>
>> BUG: KASAN: null-ptr-deref in memcpy include/linux/fortify-string.h:191 [inline]
>> BUG: KASAN: null-ptr-deref in sg_copy_buffer+0x138/0x240 lib/scatterlist.c:974
>> Write of size 4 at addr 0000000000000010 by task syz-executor.1/22789
> []
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> []
>> @@ -3909,7 +3909,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
>>   		return ret;
>>   	dnum = 2 * num;
>>   	arr = kcalloc(lb_size, dnum, GFP_ATOMIC);
>> -	if (NULL == arr) {
>> +	if (ZERO_OR_NULL_PTR(arr)) {
>>   		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
>>   				INSUFF_RES_ASCQ);
>>   		return check_condition_result;
> This one isn't necessary as num is already tested for non-0 above
> this block.

The check for "num" preceding the above does this:

         if (0 == num)
                 return 0;       /* degenerate case, not an error */

Shouldn't I use that same size check and "return 0" if size == zero in 
the other cases?

>
>> @@ -4265,7 +4265,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>>   		return ret;
>>   
>>   	arr = kcalloc(lb_size, vnum, GFP_ATOMIC);
>> -	if (!arr) {
>> +	if (ZERO_OR_NULL_PTR(arr)) {
>>   		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
>>   				INSUFF_RES_ASCQ);
>>   		return check_condition_result;
> Here it's probably clearer code to test vnum == 0 before the kcalloc
> and return check_condition_result;
>
>> @@ -4334,7 +4334,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>>   			    max_zones);
>>   
>>   	arr = kcalloc(RZONES_DESC_HD, alloc_len, GFP_ATOMIC);
>> -	if (!arr) {
>> +	if (ZERO_OR_NULL_PTR(arr)) {
>>   		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
>>   				INSUFF_RES_ASCQ);
>>   		return check_condition_result;
> And here test alloc_len == 0 before the kcalloc.

Using your suggested fix (with return 0 instead of return 
check_condition_result) the patch would look like this:

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 40b473e..93913d2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4258,6 +4258,8 @@ static int resp_verify(struct scsi_cmnd *scp, 
struct sdebug_dev_info *devip)
                 mk_sense_invalid_opcode(scp);
                 return check_condition_result;
         }
+       if (0 == vnum)
+               return 0;       /* degenerate case, not an error */
         a_num = is_bytchk3 ? 1 : vnum;
         /* Treat following check like one for read (i.e. no write) 
access */
         ret = check_device_access_params(scp, lba, a_num, false);
@@ -4321,6 +4323,8 @@ static int resp_report_zones(struct scsi_cmnd *scp,
         }
         zs_lba = get_unaligned_be64(cmd + 2);
         alloc_len = get_unaligned_be32(cmd + 10);
+       if (0 == alloc_len)
+               return 0;       /* degenerate case, not an error */
         rep_opts = cmd[14] & 0x3f;
         partial = cmd[14] & 0x80;


Does the above look ok?

George

>
>

