Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB8AC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 15:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 609BB61050
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 15:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbhJKPcL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 11:32:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:18058 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231951AbhJKPcJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Oct 2021 11:32:09 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BEfBrW004403;
        Mon, 11 Oct 2021 15:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZisDULcjY9SoreHSqZ7DiJ6/sAPjChVm9Tkaclt7ihA=;
 b=PeEvdwgUiLHCDab/OLn0BNVS47ZqQhr8n9mqM1/Wmi/h+m2TPwnGAhnASFD+ED6HyRQM
 FHKXW6mvlyeq6CJrL4iMG5iYem8N+YKLrNfLXAQIhQjIexHjdunixc7p5QUjEvqm0/SK
 YmKp3mm5C0Vc9QKIQBEO/ZV9H1rXIJkl3tvFh/79A+x0ev6XpiZ9rBMGTICgrp4rRJYF
 z0C8VdJ5F+jQPzc8f/cJpPI2bQbUOQ88le/xkwowMP75xqUYZKhqR4PLkO9aYfol10pX
 AQeO1GyyZi3zV0tmxb+OIJ92woZNcKpfxw6T+HkORg8/+x82Bz+NsS1wAWlSGObxuTTI Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmq3b8d9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 15:29:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19BFGMqC063352;
        Mon, 11 Oct 2021 15:29:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3030.oracle.com with ESMTP id 3bkyxq3bef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 15:29:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiYKeTzTsrgEAdQ3UJ7oxuITEbT3Zb03JywNakUPfKUtbFAkfMnRvEzLcTPgmH8K9FmN8H5q6c1/RJ0L9uAK8SdYb/GUgnCPw7qzGWSv6RpHR6Hw8dzHndlEt3ySZcotLxE/17FWZch4lVH66Lm+a/0gJHj9C9ytKWzbVE7DRdA9IfNWKbhMfqnsJxMp1xTtljYmbKTVyucmSgc5vj9MwjM78YyJUKgSasmEE9Ame3xNHlbtjnqSwspKy3kf/wMvgu0iiD1s2dBBykb0yRvzPf9dCQec3YbMJcFdsJIQbGuBmaUZi8NMc9Vhe0ZwDquiDAmSQcaC4LDHu5EEhwZuXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZisDULcjY9SoreHSqZ7DiJ6/sAPjChVm9Tkaclt7ihA=;
 b=FHpRnHEmaQ0t8xRBmcD3pnnRQ0tocXXoGL/5VngmhoOfBKcB2b9HE0AHKyONud3mziEj17t9MalLCmYEX/TsJeUQwGUNWhsYaS76UGpbMx2adjvHgrATHg0s+Q6y/fCkbkRG3TURE7btMAA5cZwCUx9jaxHpwg1hFWuR1kKmiGCd0a8B8n4ugDKfcLb5utO+2I69NYAr4QodIqkW9lou4Nj88vGnUiVAVvGXl/RfV8b3vX0CpNLI7U428BKJ6xH1pVvuMe1bPXD6pYTokxJOc9IcYhUF3c28lE+sYDCncY2B//yG70Z0P9FTAcHqHbNwWKQ5LhReSfooX8ze5d7rpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZisDULcjY9SoreHSqZ7DiJ6/sAPjChVm9Tkaclt7ihA=;
 b=URP/cqQ/aKpHnR4ao12X14cGeShf3MPRgcqdMmwCjucjbg5TFPoaDV3BQdpxirTMnUVOIx3mnI0/NrZqd4idzCRFftbMkdEOUIDGGhkb/jS+IZyTc3dVIBy8BakpSB3qu+1SvthTh57Iv1nocDS2C4g6t9YHsYGlnkJdG2XedOA=
Authentication-Results: rz.uni-regensburg.de; dkim=none (message not signed)
 header.d=none;rz.uni-regensburg.de; dmarc=none action=none
 header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3803.namprd10.prod.outlook.com (2603:10b6:5:1fd::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.24; Mon, 11 Oct 2021 15:29:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 15:29:48 +0000
Message-ID: <ae7a82c2-5b19-493a-8d61-cdccb00cf46c@oracle.com>
Date:   Mon, 11 Oct 2021 10:29:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
From:   Mike Christie <michael.christie@oracle.com>
Subject: Re: Antw: [EXT] Re: [PATCH] scsi scsi_transport_iscsi.c: fix misuse
 of %llu in scsi_transport_iscsi.c
To:     Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Chris Leech <cleech@redhat.com>, qtxuning1999@sjtu.edu.cn,
        Lee Duncan <lduncan@suse.com>
Cc:     open-iscsi <open-iscsi@googlegroups.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20211009030254.205714-1-qtxuning1999@sjtu.edu.cn>
 <5daf69b365e23ceecee911c4d0f2f66a0b9ec95c.camel@perches.com>
 <6163DB2E020000A1000445F1@gwsmtp.uni-regensburg.de>
Content-Language: en-US
In-Reply-To: <6163DB2E020000A1000445F1@gwsmtp.uni-regensburg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR1101CA0004.namprd11.prod.outlook.com
 (2603:10b6:4:4c::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM5PR1101CA0004.namprd11.prod.outlook.com (2603:10b6:4:4c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Mon, 11 Oct 2021 15:29:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 213403dd-e323-485b-ec20-08d98ccbf629
X-MS-TrafficTypeDiagnostic: DM6PR10MB3803:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB38030F7BDA9F2AD896F4F65CF1B59@DM6PR10MB3803.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sFSodL70MvaX8EmPNx12JjChCG48R29gzxS77JOZ019zspwc/AG0dYBYNviqTLt8nnees799RC6127f1t5phAHWjzz+lwgjlXkwCBBAoZyPCe/nxsZtlKdRwcjOC8rSRHzS+P+vVC6+J9HRcJ+/wfh3khXczJkib2rXfYvRT/jTnd+lgI/00T3/kMd4NgvGUsGr/G70qKy8nD3GvBG4L1KOAAl9k3u8jEDi0fkHmRgiJy93GXUkmymZ5vL8AMzUEPmZ+AcRPYK3IgQhytfU5kbh9/KDKhYNd+aW5gtegjHuedkxkEg689WDYTIUqHfUqeQm4K1bOOBLZJ0gkkMQBeV/cqP9lrUNeyBRYTgSy3Y8Huvzr0CNpBBR2IcVk1XnHZeTLwYFIu6zfubzoqN7ini3BG7f1bH6m5XJGj/aoIxFKFoFO0B7zQCPBlaBYCsLPy0yy4d9h6vgG6v8U7afT3nHYMZAXfc3Oj7ulLCK4f/yjVlcvN1X9R09amzrX3TG5T2qJ+BmIKhrPjIP8ga4e0/MewcfxEeBxENYOF88VrOR4lzqJLGsFKt/qN3DtpfEfgzu+MHeJBaRr/gPMOk/hc7vfsfKqNrPh75Q+mB9b1bfShzqhjzyVrG9WI2NgpxfQ9ul4tjD3MZgu2l/IKCggiQFHksjeQ4gfsTkovzgxVK8JWnqOazPW7gWgE25xRuAlYvA/DmLDcimnBb3KTvjQW7lYDr/ZWSAqulJMVXn5NxfaJdlaTBe5RpTR1FHqB3hr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(26005)(956004)(16576012)(110136005)(508600001)(316002)(2906002)(5660300002)(83380400001)(6706004)(31686004)(66476007)(66946007)(4326008)(53546011)(66556008)(86362001)(36756003)(38100700002)(8936002)(186003)(31696002)(2616005)(8676002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1ROVkpQMDNvRGlhNEQ3SWp6R082M0x4R3ZDRmF5RlFMcEpJL0l4bnlMVnBn?=
 =?utf-8?B?OVRXY2NQQlZWREZqeEYvYjA3Y0lTd3FwUUF4TmlyNlJQb1RVMkRWVjJGVTJW?=
 =?utf-8?B?enNrdGxjRC9BcU5MTSs2WUZBMzd5SThvZ2c4VHNRSVZMcisxMnIyWXZGeHpT?=
 =?utf-8?B?TG9PZHI0ck5ZRWhQNjltcFc4eHpFYkNWK3pWOW52YjQ5LysxQVNHUUR1VEtH?=
 =?utf-8?B?NXA0QjJ2RnVBN21XeUdnTUFhY1NzQ0h6eU1JWXFoMmtzOGcyYis3aFN3TkNT?=
 =?utf-8?B?RUg4WVJlL1B1MzJuVGVhdDhudCsxS1lwUjNJb21sdU9Wck91b3pxR0d5ZHRt?=
 =?utf-8?B?UFNGVEFYbzl4NlVtQ2xWTjRzY3dDTFRHRVNlSS83K0taTnI3OXlQNXpzOExO?=
 =?utf-8?B?TnF0cXJZUEpNQkk4cjBDZGJFeU5vRnFaUy84eEFxN2V6em5IS04vQU9XTjQ4?=
 =?utf-8?B?YW5OZktZdUNXb2VMQmVhYVZzbUFuMDZ6VEphZkhBZTM3RUJhSnErZ1ZjbzNs?=
 =?utf-8?B?VGw4eSt1S3IrT2VjWWtSZy84TGpEdGZvWUZKVFJXR0o4bTNzb2Z5Q1IzNjdm?=
 =?utf-8?B?T2pPazR1NnFOOWVJWkZCNkVRWllQVjNmdER5cFhjanlqTzd2WUlIZHF2bzBM?=
 =?utf-8?B?WDlUc1N2ald2UzUrbmV1Z01kNUlXb003MFBLTUdvQWhpWjlzemtFRHQ5MjZ3?=
 =?utf-8?B?bFFPWVM1QjBDc01OSnQ4N1dCZ2k5Q2ZRNHBVbTRTTzFzV3lQYU5MSkRBZy9V?=
 =?utf-8?B?VHJ4MlQ1aXRmeVVTSi9wY0lFUzlaR1ljTTgxSGlVcGl4SmJIcEw2RmVCZU9n?=
 =?utf-8?B?YVgrekk3QmNvVU93SFBzT2hzSmNUL3Zxc01WenZISkU0cko4QXVIcWpOUnVF?=
 =?utf-8?B?eS9GQTlDMDl2QUJWOEtzVU9VakxPRW1YMFZScFcvSnc3NVNwTldXSnIzZ3Bi?=
 =?utf-8?B?bXZ5V3dxdThjWWorbnlsakJXdW9SWC80ODJvVmQ3Uk5abmV3a3A5RWlqa2hR?=
 =?utf-8?B?aTlxTzJLdFN1Ry90T3pVWURjeU9lOVVjY014RFhZSjdsZ2QzbzBHK0E5NUE4?=
 =?utf-8?B?eFZBQlVGSjViQU1iTGpWaXBzR3dxR2ltNmJab0RuT0kwaVAwcGx5QkFxbjFs?=
 =?utf-8?B?bnpjM2tkTmVHMmxQMkd1cVlPYkh4UXNiQTRiTzI3V3g5UTBRQ0hGQyt5SmtR?=
 =?utf-8?B?SnBYNkNhenZkR2kvRWNjbDArM3FpcmswWVBMY25ZQnBsVnNBNEtDY29oUFpS?=
 =?utf-8?B?bGVIdlZLTjdkWTJQYWdJMWY5clN6Y2Y3YTY3bnFzcVAzUmJPdmJZTGtmcmJn?=
 =?utf-8?B?WDhCMVJ0Vk56L2tUK1FSM3NteVlyclRuWDNGcEREU0tBQkxGU1dKZTVnTEg5?=
 =?utf-8?B?ZXROeVFVM3JXRVhUVkZ4VmxKRWR3R01rcldvNWoxRFBDSzdPczgranZLVHM5?=
 =?utf-8?B?UTRGenBYOThRY0NTWGdDL0FjTi9BZjZsZ2VXSnFEdU9DZUpJNHhxVWErMmtB?=
 =?utf-8?B?TGNVdFlUK0xUY2tEVFB5bWxoUm5kSUR1bHM1OFRKanlSZGVLT2tYSnFJV0Ez?=
 =?utf-8?B?dU1aWjBEWlg5UDJlK3o0Ym1LSGhKKytOclU4NTNwd2RDTmRsa0FRRWk3RGpJ?=
 =?utf-8?B?azE4QWVwcWEyY3F5aDVJdVZILzFCbmFVeXI0VlhabU4rZUhiTHdKbmgvYTlS?=
 =?utf-8?B?dUk5NXFyWGVwTjl2ZkFlOE5aS0s5NGJOaW1oWjRRclprbm1oUlNYTjY1WTdG?=
 =?utf-8?Q?eB75Hxx/c7qWbS1SQSzTxqGQuoBVDIG8rFOgIvd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 213403dd-e323-485b-ec20-08d98ccbf629
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 15:29:48.7237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G898/D2e2eBWBRCwoRAGfHawO7/nsTCIL8qFIO3ll10FjiV1RnnCJnd7TCXikRWdbHg3kaIp4AuJu7xikiL1TjfsvvTskm3fIbmhOFqEzBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3803
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110110090
X-Proofpoint-GUID: JwKZ38PnUqpCQmfQci3CxYYb2jtA-FJa
X-Proofpoint-ORIG-GUID: JwKZ38PnUqpCQmfQci3CxYYb2jtA-FJa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/11/21 1:35 AM, Ulrich Windl wrote:
>>>> Joe Perches <joe@perches.com> schrieb am 09.10.2021 um 05:14 in Nachricht
> <5daf69b365e23ceecee911c4d0f2f66a0b9ec95c.camel@perches.com>:
>> On Sat, 2021-10-09 at 11:02 +0800, Guo Zhi wrote:
>>> Pointers should be printed with %p or %px rather than
>>> cast to (unsigned long long) and printed with %llu.
>>> Change %llu to %p to print the pointer into sysfs.
>> ][]
>>> diff --git a/drivers/scsi/scsi_transport_iscsi.c 
>> b/drivers/scsi/scsi_transport_iscsi.c
>> []
>>> @@ -129,8 +129,8 @@ show_transport_handle(struct device *dev, struct 
>> device_attribute *attr,
>>>  
>>>
>>>  	if (!capable(CAP_SYS_ADMIN))
>>>  		return -EACCES;
>>> -	return sysfs_emit(buf, "%llu\n",
>>> -		  (unsigned long long)iscsi_handle(priv->iscsi_transport));
>>> +	return sysfs_emit(buf, "%p\n",
>>> +		iscsi_ptr(priv->iscsi_transport));
>>
>> iscsi_transport is a pointer isn't it?
>>
>> so why not just
>>
>> 	return sysfs_emit(buf, "%p\n", priv->iscsi_transport);
> 
> Isn't the difference that %p outputs hex, while %u outputs decimal?
> 

Yeah, I think this patch will break userspace, because it doesn't know it's
a pointer. It could be doing:

sscanf(str, "%llu", &val);

The value is just later passed back to the kernel to look up a driver in
iscsi_if_transport_lookup:

        list_for_each_entry(priv, &iscsi_transports, list) {
                if (tt == priv->iscsi_transport) {

so we could just replace priv->transport with an int and use an ida to assign
the value.
