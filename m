Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3C3C47080
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 18:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06BDD61026
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 18:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbhFASJn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 14:09:43 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34042 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbhFASJm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 14:09:42 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151I4xpk071360;
        Tue, 1 Jun 2021 18:07:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=bW1GHQ2seYEQ/x6EPB+k7ypH3byE5bqqVFKbuRNmjPg=;
 b=ec1jsdft5u75hPbvc2ZZ1Wkl3VSsIN9Pkee6tXXAb0aL6ji8QKj3EI3ezVwYNK1NY6oO
 zsYz/1MSDzO4A4yatHhYIVhTuVFpMZHhqxNxe38j2ztbHNZIIR6iFUOHWgqsb9SoFd4L
 3SeHtYbE4c7/110mNqEQEjgABHmpKDfKp7GIY4v6NOMkDjbkfXBI8LBU/o0sgCqwpydo
 6qsnOoi17Esig4KxwRfHEXgNhJT4MzV5uIdFWcxy5XWJPaRX/xzJmPVE075+gw9Mj4eR
 UJU+YW9FNQoAc84b1EmNvLynbgm3ho89lavsAUceBVvTjtcLaLY2G0moIou2ZakubG3N ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38ub4cpe0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 18:07:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151I5s8P116786;
        Tue, 1 Jun 2021 18:07:58 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by userp3030.oracle.com with ESMTP id 38uaqwhdav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 18:07:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ot+u0Jl0ZwMDUVn+oLAKZKynIPFLQMqN+ulKICksPn8alO51PKAE4cw96iHc/PJUInbHF7ssklYVapvo5vNjetEQ3KaOubL7WzXeVrZIGvSsbWY/gCJbVJXwtLMwRofke8O9367ph09fYZOIjTlQuSOcFuLlzO2wfrRi1wWqRnAvdwTMbUrvbgd716ntiDi1C4KHn06y0oh0Dq8vRh4+xNilxavLjALNeGLVkrVyjncu1S7DY2jjY0J2y7vvpcQfhV0l72Bi8Lz/939G7ar/n6B8i1FNVl5igPST27reUlU5gBngAnpkYRtR5lKESWtCB1G7zBdwjvssvK8XhjS0Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bW1GHQ2seYEQ/x6EPB+k7ypH3byE5bqqVFKbuRNmjPg=;
 b=FIS/78iHjSJtYTX5g26+ECZyab/oI/CUxSyXhi24nDl9/h/8990REQpTh0Le7X4f/H+9RTPzckz8xzVahmVRh8bxFePyrlYtzFcTQECUGFjGVCfE+QPHq9HErSOeLY6+aKcSRFGWE5FiWDfmwnBFHKEq4Q6EL+rhEWnIYG7J7HAw7euFe3w3mpw/5QtbjYbOikn090d/xNOANX3QhUwgyQDXaeFMJaQlrPeiQ9u2o3ghKsotqCf08q2DCn3CSlkHpI3PnQwRLZE33KgB5eqqxFgOh9bSuiwHtsvVekqSS41JhftyJkLy5jl/PuVm1QsIgGzXC9StxRYbDjl4rCkMzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bW1GHQ2seYEQ/x6EPB+k7ypH3byE5bqqVFKbuRNmjPg=;
 b=Vr3uOP6KTn3Kw70j9wH2R/p8lRNSvRU331cdmGCJHmI08OS7Y0oWR9l2vJA7K68fsd0CyEUyvFBS9s1RPAZohav6w4k8acnPA/I2HNyUFA/SjYOd5tPOGwrCRJhW7HJcCaFHcebnVjRTMbvQbX42TDYHCATfsowsQa5Ny3VUKvk=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4602.namprd10.prod.outlook.com (2603:10b6:806:f8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 18:07:56 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 18:07:56 +0000
Subject: Re: [PATCH 1/2] scsi: fc: Corrected RHBA attributes length
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210601172156.31942-1-jhasan@marvell.com>
 <20210601172156.31942-2-jhasan@marvell.com>
 <dd421a80-36c5-337c-d786-a3039183e534@oracle.com>
Organization: Oracle
Message-ID: <edfb9c44-10d5-b2d7-1f3b-c3012ebb1128@oracle.com>
Date:   Tue, 1 Jun 2021 13:07:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <dd421a80-36c5-337c-d786-a3039183e534@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2606:b400:8004:44::27]
X-ClientProxiedBy: SN4PR0201CA0016.namprd02.prod.outlook.com
 (2603:10b6:803:2b::26) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:2001:92:8000::a72] (2606:b400:8004:44::27) by SN4PR0201CA0016.namprd02.prod.outlook.com (2603:10b6:803:2b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 18:07:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b06cd0a-5bf6-4329-2da8-08d925282eaf
X-MS-TrafficTypeDiagnostic: SA2PR10MB4602:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB460279CFB5E7052364C78BEBE63E9@SA2PR10MB4602.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5KmdzXFbFR48cVTk+g5QLdlvVyGsOj4bmj8YGiya15k1MVLnOJO1mfO9cmNkwWg3+ZMMnXlyGlFOL3FdUNZ/YOwGACekRKtx2oAZU3MAPwdyK/8ezL9+7eN4cv4SxnVekQytICM/dJge30wEtRhik7unWTdv3IvXNA/n+x8gMSiM2+nVYps8Ia1azMHfjxU04L0j2zJE5KUUEu6p5vxJ8DbbN4+lcBp9J3TEZ7+rNwAl5mRcOo+/Sr26+N6xwQ9fqPPe0Tvh/kokC0vO++FtPDOm+L6e9z3A4oZnzZ5aN4TELaYyPorMgpuvy2QAMtL3jtLYSEC1Flhd87q1bZji1ZtVwLqAxPYwzYzrhDF5jqgzYZBvYqOjwICyvATmiZsd8mj5czz9F+i5p3Opk11OawLjoXcwVBD/kqKp4A8eArmvgqy6Jw4fVAYRQJC6TEPm1BRDy4fF4R+cGOCI5BURrJpVN94D0xJMjNVgJgO0vtI3wHRro5HUMySFy/xSOR6a/VFldyuBt0j+93++DuZA8VgXRctVs6sFkb5nX02y3t8Y3lvhJ/T510jxdxdq6Z3a/KWEecLl5JuYCGxtb0kzht+iatGiq+jsZFlopJYp33i3W09/8FMFZOuGfPNiv7BiHCvngbAFW+Ke5wIg2V6DzaWrzbkbZ1vqX3Vb7yEmX/YbECrzKogrenMjEMlswjp2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39860400002)(366004)(396003)(6636002)(16526019)(186003)(86362001)(316002)(2616005)(83380400001)(2906002)(31696002)(44832011)(6486002)(38100700002)(478600001)(66946007)(31686004)(8936002)(66556008)(53546011)(36916002)(4326008)(36756003)(8676002)(5660300002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R1ZGNXU3bGtoNlc1YTF0eUZtYWtzU3hBa3d1R2pESHY3Qy9MS2ZBM09yMTlC?=
 =?utf-8?B?OCtlNTh1VmVkaGFjTEpUVE9YbjVnbTJUQ1owQmRFM1lsNFhsc3dFMUoxUWJH?=
 =?utf-8?B?ajU1K0NmMlJCTG90R2EyZmFjcjluRUliaFFnUjZzMlB4SFFXcWV6by9MK1Jn?=
 =?utf-8?B?RGdzVjVPV1BwZjdjMm15YXhMeCtFTmxMNEVFWG45ZkExYkszM2VOUWZORE1Z?=
 =?utf-8?B?MUoydWVBVk44QVVSS1ZNN1FsdkVIUi9pTm5yNnpaMkRHenBScEt5L3duUStV?=
 =?utf-8?B?WDYyNEtqaUo2TTgvTWt1c040VVl5aXptd096VllybS9UUUh1YTZVODh4enhU?=
 =?utf-8?B?dm1NejByOFZTTm9MS2ZjQ2dZaFlHb3J1Q2NrejhPK2NSR3JxWVladkdYZGpQ?=
 =?utf-8?B?c2JEWkw0d2IzcWx1b1U5WDhqQkptek9oZkdEQUVWelJCWDl0cW95NWdCd2NZ?=
 =?utf-8?B?b2ZpbGlYblB0eUUzdVU0YkwwNXVDS1VHZnBpK0xjOWlwUHg1SXV0VkxqV0ht?=
 =?utf-8?B?enlGdUwyWXlsRGI5NGJwOWFLOUFzUjZtcGtWZllZY3FaSXhmSmpoRkJEeXVm?=
 =?utf-8?B?QjhJQ1VjdGl1N0tadUk0c25rWnNrZlRQVWI1OExlWEhjQ21nY1VVVG04ZUVa?=
 =?utf-8?B?bTYyTHFoUDJSRnUxc0tUOGc0VXVrSWRqUk9RbUo3L0ttR3E3bm1kWUVDMGdn?=
 =?utf-8?B?aG90VUVqVyswMGYyU1dndFp3U3c0cjZJY3JLSmJ6UEdBUzJ0MDlodzYwY05Y?=
 =?utf-8?B?SWxjNmxQbGJNeTlNdk5Jclc5RmQwek9DYW5uUUsvMHVsSUtpcnBtbTV6VS8x?=
 =?utf-8?B?V0FtLytCVSsrRFJnc0lHRVlXS1FKY1hMT291WUJ3MzJScWdpbFpHUGEwLys0?=
 =?utf-8?B?cjVnbUNGekhkaGVxWVR1ZDRoc081VmFRSG11TmFEbUVHc2NaUkhhcHpaQkVr?=
 =?utf-8?B?VExkdTZWOXo0RFU0UEo4QTNQOGk3UElmZTcvRHFkeGhEM050ZkVtWGtUaFFK?=
 =?utf-8?B?aFhxMGJFWXVXQ3FvSGJ6azlxYTZYbDZkeDlOSUlrUi9VbjJyR0dRa0t5K3Rm?=
 =?utf-8?B?MWNIVmZHSFpJSUZuQTlBZlI5eUlNRWN3QjRVeEFrbEM0YTdwVnp1dUFTVlZr?=
 =?utf-8?B?ck02ZStaY3ZFRDlEQlZFUU1qWnpsMjZtZFpnSU4vWTQxRDlWd3RmTHZhMjBE?=
 =?utf-8?B?STY5UHQ4MzlwQ1hSYkNuMk9KSE9wYUJaSGNjRTdEYU90ekpkbXRkbTZlZ29x?=
 =?utf-8?B?K3VKZ2ZUQUVQOWpEc3g4d3dWWWZKamRxK1ZLd3NhZUc3dE5vdWVuTVo5MVFB?=
 =?utf-8?B?YnVQVG0zQlVIMXRjQ0t3OGNYU2pwcWhUSUNxeFVYL0pZUCt3UHFKV3FjalpH?=
 =?utf-8?B?SUpRblJEM3U0SE5vSi9VQWc2UEljcHJrN0JEblpGTHhrMmxqR2lWK1g3ZjNX?=
 =?utf-8?B?OHk1Ym8yc282RytnVmpCQUpnRXZFaC95RVJsWFo4ZXEvbVNlc1VkSDYyTTMw?=
 =?utf-8?B?Q3U4d0xiMUtid045aDhZZmFZSXRMeTJzUlRLUk4yL0ZsTEpDdFRPYmNUdTVt?=
 =?utf-8?B?K3c0N3NZTDFmM0lMcUVpRkxhZ0paQW9jcVh2RjFHTnlFeVg0K3duYU4vNEVG?=
 =?utf-8?B?Q1YxWkFWbmpXdFdsRzhZb1ErM1lGd1BiMWljUTFyNjEyVWVRTnJ2eWt1Y20r?=
 =?utf-8?B?a29mKy9vRVRobDhGaWRDWTB1TDBoTnVhckRCZjcrVU9LN1ZZRGRrOEc4ei9Y?=
 =?utf-8?B?M2d4Y0EzbGhOM2FJdlhRS24xVUE1Vzd6dVI1RnR5ZWl1dEloSjlQWHkrcWlH?=
 =?utf-8?B?NVEzaWxtcUFudXA0VG41dz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b06cd0a-5bf6-4329-2da8-08d925282eaf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 18:07:56.2787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xlzHHPzCEkCCKENhvTxYkCEb+Kl3pyWd8bFJmurNrosbmWrUodzSIE0xMBo1DsE7K6pmC9UIR13ivRNyJf4tFEPbRLC+bDvwCnSx9s8f074=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4602
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106010122
X-Proofpoint-GUID: hex0Bc5qjyD8ikzweG7HLL5R3KVYbB03
X-Proofpoint-ORIG-GUID: hex0Bc5qjyD8ikzweG7HLL5R3KVYbB03
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/1/21 12:52 PM, Himanshu Madhani wrote:
> 
> 
> On 6/1/21 12:21 PM, Javed Hasan wrote:
>>   -As per document of FC-GS-5, attribute lengths of node_name
>>    and manufacturer should in range of "4 to 64 Bytes" only.
>>
>> Signed-off-by: Javed Hasan <jhasan@marvell.com>
>>
>> ---
>>   include/scsi/fc/fc_ms.h | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h
>> index 9e273fed0a85..800d53dc9470 100644
>> --- a/include/scsi/fc/fc_ms.h
>> +++ b/include/scsi/fc/fc_ms.h
>> @@ -63,8 +63,8 @@ enum fc_fdmi_hba_attr_type {
>>    * HBA Attribute Length
>>    */
>>   #define FC_FDMI_HBA_ATTR_NODENAME_LEN        8
>> -#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN    80
>> -#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN    80
>> +#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN    64
>> +#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN    64
>>   #define FC_FDMI_HBA_ATTR_MODEL_LEN        256
>>   #define FC_FDMI_HBA_ATTR_MODELDESCR_LEN        256
>>   #define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN    256
>>
> 
> Looks good.
> 
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> 

I just noticed that this patch is basically reverting commit 
e721eb0616f62e766882b80fd3433b80635abd5f ("scsi: scsi_transport_fc: 
Match HBA Attribute Length with HBAAPI V2.0 definitions").

Have you verified that the compiler warnings do not resurface with your 
patch? if you see that compiler warning, please fix appropriately and 
resubmit this patch.

-- 
Himanshu Madhani                                Oracle Linux Engineering
