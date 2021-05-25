Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292DCC4707F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 17:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0761761378
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 17:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhEYRgb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 13:36:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbhEYRgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 13:36:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PHXkqu070896;
        Tue, 25 May 2021 17:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=eG7i3oRXqP9XaoyA3Ix+GtzbTmeKesRboEXOw7U1PiA=;
 b=sfyU6i7MnxGQxWDHuBR7h1P/AT/APDWNZOr5aqZ3dbId2U0r0kWwt9ovXrjj5Mb98HwE
 D9Rf80Ya5o7qRnaT9bjTMnDRwRRYUY5KG8XDqqh+ve9wShrVAsfxcdiDAMx0aFQ/0HxS
 YkhPHFaCwFlTudJxqgtMRWBTmKa0jsg/8RTSKy5x8YdEVSCNTMuO4RMTrtxUAiK45cC2
 rtD0D5AIe51q/+A2E0D1kdZwqhhS5R5HzTHlTVW27OReiquW7zbk5Xq0CCXNfj7aiRc0
 pzkWMGtKSy1sVDlpsXkOFpQrfwqJNMggicEe5cIIwTVzZPqd28zv9Ic8x+bpijj9HRAk pQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38q3q8x9p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 17:34:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PHQspM079118;
        Tue, 25 May 2021 17:34:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 38reham8jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 17:34:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipLM0fXd7WeIj9LrwXVIX/1TqcgHLcen7TH7qB7qcSYL8bAXrk12sIKJB5Av6sdImyiQYkKdbYqyDM16XjAfVYXzE+qiNz5QT1cbbfy1f5RJ8enCP8RSDmc3JdhPpm+XWjjxvWew/cyW8Tc6/i7QYpZoRm3st/dbpyxKMj+SzOcgv4UHmToQuAv1G2QF5if+76+22p50+eEIos0TTSHpJ4jGyvYxYc9ZYPDQCSS1UyTSYRSEvgiaso2RwJvSZ79HqQ3VpoT7xxbLBbdJ2cus+F5FyMMxBICEqPtz9uhvLRGIlOsGNNJjr0zrTStahoiWwAKj7z3l09HsS3W14r6AVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eG7i3oRXqP9XaoyA3Ix+GtzbTmeKesRboEXOw7U1PiA=;
 b=JiTOvki3aCN8X8um6cBj5sMjhsTYIJI1AWoKFJZdHYcSE7weSh67OFKD22HJCVhiYABCxv9WQJwDATJgvpqmIM+/hGEQJhoTMveJyNSoYm8LQg39oV3Uujm82M+33uDf4b0x/0u4ELnZbYyNXibIjn6vE8MwDW2Wx/T3uEB4IwpzPtD8C8mAQrgMWHt+OhBc1i8pQfzuL6cufHHW7GJiUJh2B7xVvuvvi9ibrL0mVFlKWBAR7+EGY3l4COtvtL2xdG5xtBYFj4iQ2/zSBCXZWU2CmP38ndouGYMUxCGKzxr4BOmYERh/Kp+s/6X12w2FnYoiL9rGUdBt/3C0kFYKtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eG7i3oRXqP9XaoyA3Ix+GtzbTmeKesRboEXOw7U1PiA=;
 b=Z1Fzwk9C0yGcInqX7Is3cpd1ur7+1xLVRsa58lXtOT6N9IhgBLaTmB/pqMPAbzhzXQa8HkFzsKw68JWmUQf1KIHeUy7V7xf2C/sah25jisdETNtZleJMFPeo019MAqkNNAxTZeAbFLXufCAoANU1EM7YYk2lmY4s4wJB+XFhE6U=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SJ0PR10MB4685.namprd10.prod.outlook.com (2603:10b6:a03:2df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 25 May
 2021 17:34:28 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::18a:7c1f:bf20:ba6c]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::18a:7c1f:bf20:ba6c%3]) with mapi id 15.20.4129.036; Tue, 25 May 2021
 17:34:28 +0000
Subject: Re: [RFC] virtio_scsi: to poll and kick the virtqueue in timeout
 handler
To:     Hannes Reinecke <hare@suse.de>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, joe.jin@oracle.com,
        junxiao.bi@oracle.com, srinivas.eeda@oracle.com
References: <20210523063843.1177-1-dongli.zhang@oracle.com>
 <ac161748-15d2-2962-402e-23abca469623@suse.de>
 <YKupFeOtc6Pr5KS2@stefanha-x1.localdomain>
 <a0404035-2ab7-6b9c-f393-0bb0417c4b3d@oracle.com>
 <YK0qKMF0I8Wm1euN@stefanha-x1.localdomain>
 <1184a5ac-bbb4-a89d-b5e2-ee0bf58cd1b8@suse.de>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <9bc96bd0-5a0a-da4c-25f3-c540163318f8@oracle.com>
Date:   Tue, 25 May 2021 10:34:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <1184a5ac-bbb4-a89d-b5e2-ee0bf58cd1b8@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:646:c303:6700:7972:164b:11be:8bb8]
X-ClientProxiedBy: SA0PR11CA0180.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::35) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2601:646:c303:6700:7972:164b:11be:8bb8] (2601:646:c303:6700:7972:164b:11be:8bb8) by SA0PR11CA0180.namprd11.prod.outlook.com (2603:10b6:806:1bb::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 17:34:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8234430-8a5d-4f43-3365-08d91fa35921
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4685E1274B4EA565219ACEBAF0259@SJ0PR10MB4685.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vjd2tXrqNq2hB9mWlm5wtzl5/fuVkCmcARanjv3QSIix1TeiFJpxjig5trRdzWp8tce5N5OE+obYcxoX0h9BP5zz8WN6IeL7xnJTp8jeiIunSBNmel0Q4GYb87zG2NyJSQ8kE5Je1XT1ZIkv5lFIDuSRwCT3Kem9IxX5/91M7OqgZVla+7an8fc7TayEn5IrdaugmCq4Q6x6hFQQ5wIHTAIputcJra5yxTiwoRuuEeW66/YzmnSevmSOO4wGTb2lHwL7IO1u+ZsPjUI1FL77/qACViYzjIYcWCFa3dKMZ9oG+7k0drEAoGZcAFCaxypOvuQsb+zMwB5RzRrb171odOOMbTM+MrhACVnrRiEZr01iw97Vk2tpLLEXQaMlSbojGdip3nzkuvOrxx4zLqQK8IJup6Vm/uKkTwdJts//B53kgVU0E848Ys1+mVwHgYMJHX6Md6SZn0KvpGUVBplD0SzxntmpzMGeepw3OVTjldGm5OgY8SjAHsqaMnP2MJNqhst/bXN9bFVAol1FGLTsjr0UQYY7/zPtsG2MTkjA+HbYoUuzopbX0JvY7BcI+JeyLV9KYakC1oh+dvCCeMIipX4tAq1S/Pb8LtwE1+IPq/5jrGDbqFQoq+i12EThEx8BlH+VLFtImCxNsOfloCX2euZJ/jC6Z77bngfEhx7OAH1uZJMJ5AAZtEuvb98iBzij
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(366004)(39860400002)(376002)(66556008)(316002)(66476007)(6666004)(8676002)(83380400001)(8936002)(38100700002)(7416002)(31696002)(31686004)(36756003)(6486002)(86362001)(66946007)(2906002)(478600001)(53546011)(107886003)(44832011)(4326008)(5660300002)(110136005)(2616005)(16526019)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?Xr42yOjLakIMDVJCtkMciLJfLdaY91a8Syn7xPEFsHnelnK7TRK1WWgq?=
 =?Windows-1252?Q?1R7H6lTtj8ViuhjOeM7TUN0NvGZw4Ljhjgo7h9IiGwqUktrGa4JY7d7k?=
 =?Windows-1252?Q?1mQgyW4XwQbqVrGJrUz5KWdl+sdnhO97O8TtqD2xdOx/XwuU//VWapGe?=
 =?Windows-1252?Q?RP4tjksItZa6aVE9AJJank2y2JRfLhRBVM81wm4jHxGvxIXN3ZtaXWN2?=
 =?Windows-1252?Q?MA3tjoFuGV1u0kDLZqE4lvxvp7Ql37tBNHq7ZSZ+iORAQvai+PM1zdgh?=
 =?Windows-1252?Q?t27Hpz87/RwUSL7Qjd/OYONRwxz1dxleDM0kVJ6nI8m+c7KKt+OKOsoM?=
 =?Windows-1252?Q?z/LD1vIBCPHYhjRRymNTYf2jHOVmBgnRcQgoqI7tgF071B30mixoHV5h?=
 =?Windows-1252?Q?pMtOibkIbuz/fzC0NNuMyCCZExI1UnjDqD/eypH2CdIXMrVti+uoZesJ?=
 =?Windows-1252?Q?9drYSCno7cKV8n37L9wEywk1jGp3/a9nM/NMBBWrn5YyhLyC77W0xQQ4?=
 =?Windows-1252?Q?da12K6031oy2UNxnhJlXsEz62Rltny46UCA6Z2DZRjnp2+1mZZQfTiNb?=
 =?Windows-1252?Q?qIsH0JIZNDYVtLiAjUV9rj2GJ/hAdSWJ9mG4/ohtN4uVSRZTLkkRo0lQ?=
 =?Windows-1252?Q?WBb7tBJZOqVrcrfp9HdbiFpajOq/dIKiPVbncJ81odWN9imNT8rpuW+5?=
 =?Windows-1252?Q?hvFdL3/9e4QrAcIUCDgksrlpfl8t7hCtCfkUG+l6/j9h4tn8mk/sTpSh?=
 =?Windows-1252?Q?q8XqUVBgW2xEIv6mT7sAF3m5MWA3ZeYfNGeTT8ulnIKCBZ2pcj4sCznJ?=
 =?Windows-1252?Q?seHbmSPp4/NymwVuv8ItvG7IUnShP1PwpkfEZSN1lm87Etw4dbwN73eU?=
 =?Windows-1252?Q?QZQkCMv1dbzy4bvpQCikAQYaYJXOEjc4FXOK4MjWQCTkpVd0nEMrGW7p?=
 =?Windows-1252?Q?m0DWFrFD7zXCyb7nJTvyCkKjsIRan6zk+cY+tPnPoP8k56sel/Yg7Nob?=
 =?Windows-1252?Q?clbR48+fZz1a+3E/etIuz/eGMlyFm+++sg05CGW//rzxBa2s1fxUI0lr?=
 =?Windows-1252?Q?yU4Uk2LuIxpkl7UVWoaK+gtKqdFCHy7J18XpV2ArgDfVb5Q6HuTrwFaH?=
 =?Windows-1252?Q?mBXH7BdjTPfHZeitOMXaTedGXTZrVH5nH9SLKP/SSYizR/f+WfcVh5hW?=
 =?Windows-1252?Q?CzOhoYZpYyJ9Tbvr5xB17cm2lX0nrUe9VlIxAVID8bve8+h81wD9Ey3u?=
 =?Windows-1252?Q?yp1hWo5J0o8CRDn2oJ05mkZ2uMoZ3bIsPOZGTH18jrYUkS81RyFZbMX8?=
 =?Windows-1252?Q?8EybMZ6Q8nhpojwzxJItlT8TwwsHW0lShiirPQg2b5fbI4Zbbqj+6fnQ?=
 =?Windows-1252?Q?L5zxB6a98jD2UCwv15IVY/2aPSL4GXrdHXYUxLBVtAzpahVpHnKbtnLu?=
 =?Windows-1252?Q?gYHOsxDXFJGTvNl7HUpWVdbHOjBA0YfFLdwDgyd1dp5uYIgIjhj8wqrB?=
 =?Windows-1252?Q?RdJAPLs3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8234430-8a5d-4f43-3365-08d91fa35921
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 17:34:28.7242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +g6H4HQOfwYQJPXhoJERFw4G/NsHQdh8mt0CrIO79bRWqnTVRxFlCg1gQa9UXMs8uciyLnr4AjGq0qn9LjENbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4685
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250107
X-Proofpoint-GUID: bwLbBbKme1Jaff0Z_5kBes8OpPTf03sQ
X-Proofpoint-ORIG-GUID: bwLbBbKme1Jaff0Z_5kBes8OpPTf03sQ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250108
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/25/21 10:24 AM, Hannes Reinecke wrote:
> On 5/25/21 6:47 PM, Stefan Hajnoczi wrote:
>> On Mon, May 24, 2021 at 11:33:33PM -0700, Dongli Zhang wrote:
>>> On 5/24/21 6:24 AM, Stefan Hajnoczi wrote:
>>>> On Sun, May 23, 2021 at 09:39:51AM +0200, Hannes Reinecke wrote:
>>>>> On 5/23/21 8:38 AM, Dongli Zhang wrote:
>>>>>> This RFC is to trigger the discussion about to poll and kick the
>>>>>> virtqueue on purpose in virtio-scsi timeout handler.
>>>>>>
>>>>>> The virtio-scsi relies on the virtio vring shared between VM and host.
>>>>>> The VM side produces requests to vring and kicks the virtqueue, while the
>>>>>> host side produces responses to vring and interrupts the VM side.
>>>>>>
>>>>>> By default the virtio-scsi handler depends on the host timeout handler
>>>>>> by BLK_EH_RESET_TIMER to give host a chance to perform EH.
>>>>>>
>>>>>> However, this is not helpful for the case that the responses are available
>>>>>> on vring but the notification from host to VM is lost.
>>>>>>
>>>>> How can this happen?
>>>>> If responses are lost the communication between VM and host is broken, and
>>>>> we should rather reset the virtio rings themselves.
>>>>
>>>> I agree. In principle it's fine to poll the virtqueue at any time, but I
>>>> don't understand the failure scenario here. It's not clear to me why the
>>>> device-to-driver vq notification could be lost.
>>>>
>>>
>>> One example is the CPU hotplug issue before the commit bf0beec0607d ("blk-mq:
>>> drain I/O when all CPUs in a hctx are offline") was available. The issue is
>>> equivalent to loss of interrupt. Without the CPU hotplug fix, while NVMe driver
>>> relies on the timeout handler to complete inflight IO requests, the PV
>>> virtio-scsi may hang permanently.
>>>
>>> In addition, as the virtio/vhost/QEMU are complex software, we are not able to
>>> guarantee there is no further lost of interrupt/kick issue in the future. It is
>>> really painful if we encounter such issue in production environment.
>>
>> Any number of hardware or software bugs might exist that we don't know
>> about, yet we don't pre-emptively add workarounds for them because where
>> do you draw the line?
>>
>> I checked other SCSI/block drivers and found it's rare to poll in the
>> timeout function so there does not seem to be a consensus that it's
>> useful to do this.
>>
> Not only this; it's downright dangerous attempting to do that in SCSI.
> In SCSI we don't have fixed lifetime guarantees that NVMe has, so there will be
> a race condition between timeout and command completion.

Thank you very much for the explanation. Yes, we cannot do that due to the race.

Dongli Zhang


> Plus there is no interface in SCSI allowing to 'poll' for completions in a
> meaningful manner.
> 
>> That said, it's technically fine to do it, the virtqueue APIs are there
>> and can be used like this. So if you and others think this is necessary,
>> then it's a pretty small change and I'm not against merging a patch like
>> this.
>>
> I would rather _not_ put more functionality into the virtio_scsi timeout
> handler; this only serves to assume that the timeout handler has some
> functionality in virtio.
> Which it patently hasn't, as the prime reason for a timeout handler is to
> _abort_ a command, which we can't on virtio.
> Well, we can on virtio, but qemu as the main user will re-route the I/O from
> virtio into doing async-I/O, and there is no way how we can abort outstanding
> asynchronous I/O.
> Or any other ioctl, for that matter.
> 
> Cheers,
> 
> Hannes
