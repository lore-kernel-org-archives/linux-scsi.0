Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EB7C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 17:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A789561130
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 17:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhJFRBz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 13:01:55 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:30941 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230108AbhJFRBy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 13:01:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1633539601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P/u2eR/ciIakoXFqDPw4f4NY8C/PjCVzrDpVrD+GQek=;
        b=O1gXO7WGMKEprWbYjhGmWZI6JPrqEVCWs8Z4EbHyN5a9TsgQO6jFvWwS7GYx0bMq3ntDqQ
        NmDT7l76684P6nrT1Tz9FBh+NsLWcXdl9CxVqyyVvRtqUIycEyfjH9qlK4wYj2AF44SJZw
        fHVm+/ws9+GKXp8VhqCaJJjCPZBG9XA=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2053.outbound.protection.outlook.com [104.47.0.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-36-eA2J52H4PSyQaGnA0jLObg-1; Wed, 06 Oct 2021 18:59:59 +0200
X-MC-Unique: eA2J52H4PSyQaGnA0jLObg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b4Gr1pOku0SGPLWi+j6ZZUHWvMjFBJzAz2wAM8XQ5Zzk5SRdmdxwi5ru0uUNogo5dOZUPQUoqhjV/X3LfEPWpYbNWJhtoFHD3K+UFIMgS1zlbGJ10wE1ZcbqG5KVqPy2fk9MVCb0vRhV5JOrZXSHxJwPLx6Gap1vQUDt7Bxz53ihevbhyXwYvRFgG2MGN/W9VLt/UYszVsUL56dDlcLbfcDtJ1fKYpDsoaB2+DAuFaXYYAGu4WX7sUHXoZN5AaBKqBsXnxECH4FuRdreXfvNWpm5B/Pwn8Sn1wZi4gdy+MWc8wFLcFwbohy0iJgmYxDRECJHuM3skhXiFewN7+/7Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/u2eR/ciIakoXFqDPw4f4NY8C/PjCVzrDpVrD+GQek=;
 b=NHGolMFr8WwIjZvu3/SXCs513SIx9/b204QmuWxUAHkOGFDpyYM8yfKyJm4fa0l+rz3dMVDR4l7m5SvSBJpn9w/6LHH0Uh27Nmda1Q3lCSxf2+vDC0C9N+LhRBWwqNoHBWLXa1jsWgRDzxnKQbWymckVJ4o7JBHSna3d5Dhd2gIltiNhyE59SqslWCYyEX4qC+e+ugehgQXu8AyfkkkPwX0GGAqo9ZZJ/XS0IqeoNWsNsIGrWusgBuZG8c35xX28il78NIVQ9kgC/AVEQzJYdIXxcWkxAQcKSxwhsW7HNyL3l/lWfsQ1EHe1Cny/CH39/lVjnAX/xn0h3ROG43l46Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: hansenpartnership.com; dkim=none (message not signed)
 header.d=none;hansenpartnership.com; dmarc=none action=none
 header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR0402MB2769.eurprd04.prod.outlook.com (2603:10a6:203:a2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 6 Oct
 2021 16:59:58 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb%6]) with mapi id 15.20.4566.023; Wed, 6 Oct 2021
 16:59:58 +0000
Subject: Re: [PATCH 1/1] scsi: fix hang when device state is set via sysfs
To:     Mike Christie <michael.christie@oracle.com>, lijinlin3@huawei.com,
        qiulaibin@huawei.com, bvanassche@acm.org, wubo40@huawei.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20211006043117.11121-1-michael.christie@oracle.com>
 <57607b77-7d3c-1a75-78c2-4a15d8863c82@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <3071a399-d31d-ee0c-9c67-9b66d8587f8c@suse.com>
Date:   Wed, 6 Oct 2021 09:59:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <57607b77-7d3c-1a75-78c2-4a15d8863c82@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0701CA0009.eurprd07.prod.outlook.com
 (2603:10a6:203:51::19) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by AM5PR0701CA0009.eurprd07.prod.outlook.com (2603:10a6:203:51::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.8 via Frontend Transport; Wed, 6 Oct 2021 16:59:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b69cea68-4e4e-4e86-fd02-08d988eaba88
X-MS-TrafficTypeDiagnostic: AM5PR0402MB2769:
X-Microsoft-Antispam-PRVS: <AM5PR0402MB2769C8C741AE227FF611CDEFDAB09@AM5PR0402MB2769.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0NgqccUHd9r8GEwyzDzk3lk/jroRZ7v8T0MzbP2uj4orqNm7gH21DBidey4c8cRTa6CNCa2gLv5Uu/BkPlInO8MTiL6FW70CvvK5DjYUQ/oW/zUiH93jSEKuFCDJJv8yaoBFiF56aHcfMhfTG1UwxX1MHeYIZUTNdKCzvkb0fH8OAp3HTM4eQOtqr2eZCsEFy/RlI/ae+HXYoVLXy+zH1IcYpGYBAG1KPTbsOJDOaLa7OcpvZeyzCgpiw+dSDHuD/McwK1/kcJzlGrNnQLa+KX8HiTBOsjIc9n5VmcvgcTz0MBQEY7Ely6jM3DZCBMZ+qGiNqueUG1rW4rOu9W5mOru6UiVUTIeYRDM1STQfYquvFIuRRH+IicgyTbLa2SHWqDfL8HN+6hpixoS17RyzX4yE0fqraBuYUJDJB2dPqRICNnFO1333sTEHpmYMDfJ84RiUgFqppyW9Ul/OjVxjbL15B86rSa50RSUxG30TL1XTgiaaZa1MnFEq7JR8OD5lkyOU/LMAezt3n6xvdWR/CxX9JVe3yNxAA8Z+fUVh1XRdWTdjB8i0vX6pR55BhGaHWI+hP/u3VaRxyA8WKvTfTF4F/XlB+5lHw2/V2efMrAWCOFzKuLSQjmtJ3TYcbzber7ixCXy4Hf7q98w9YnEiOFLuwvtDMysF9bUEpDp8YCQ3SwljytiPpc3INubApMtGNO3OUT6VR0NJaTGYz9qJpu5G8Fh84qCwPZGqQ9U0zm4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(36756003)(5660300002)(66476007)(66946007)(26005)(31696002)(53546011)(186003)(316002)(2616005)(16576012)(6486002)(86362001)(31686004)(956004)(83380400001)(38100700002)(8676002)(508600001)(2906002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LytqNjBBTFZiN3N6QVJRT1JvektlV1ZSUXhmWVkzQmREeU05Yjl0NTBLa3dK?=
 =?utf-8?B?OTl3bXY0NkpkM0hWdE1nSXlPTEk0a2JYRzZKdjdCQVY3ZVRsVzQ1U3dSN09L?=
 =?utf-8?B?dTAvS0ltUklBUGw5L2V1UVlPTUNWcjJrTi9MNzlobko3cHUxTS8vVDVHdVJj?=
 =?utf-8?B?NVg1N2tXVVRwMVJhbUt1cWFTWEFrcWVoTXpZNzR6L2l3bGc4NTRZSm5VbTNR?=
 =?utf-8?B?WTB4a2pvV2hzUmdFRzNPZHVjRUZTdGpYV3dwMVhvN3hwanpseFdKRDBscmhs?=
 =?utf-8?B?a2k3VWVJbTNFZ0Rxd3VpZWFHMmtodFNLTFp4OThma2ZXU0piOU9JMlBBZWMy?=
 =?utf-8?B?UTlPeDFCWTZORkUxMk5zT1ZhZjFoUjBVZE9kZExHMFlUZFEwZHpOMDdDZU5R?=
 =?utf-8?B?SGdFcGw1cWtoKzZmd3VUWXJ0ZUpJRGhVOENpUXN0YUtObEUyb1pEamY2Tm5s?=
 =?utf-8?B?SnBjYzNrSGNQM0JlZUJWaWFUeFVqQ3JKeWhyUGkwZHFPUFJnMTM0SER0cVRu?=
 =?utf-8?B?R3lYK1dOc2ZYVUVSU21uWnhOM2RXcXdDOFBFZTFqNXBObDFTSld5R0dvVy9u?=
 =?utf-8?B?ZjBCSDJ1VmZBbkVzL1Yvc3cxNmxvUlRVNDhoTldtc3hJbkNhQ255c0JQaGIw?=
 =?utf-8?B?cmNZbzA1WkhxRFhLRm1XT1J0b2x4ZjYxSG81UVJJTWUwbTVLSGJlaGo5Ujd4?=
 =?utf-8?B?UThVMG40ekpzYWoyTWFGQlROaTl2RnBYdmZ2M0FCOHJlazN0aVNlbUdua2dI?=
 =?utf-8?B?UG5VSkZZNllRZkdWTThXM0hwMUdpMmxzTDE4NmF2OEQ4Z1p1SStkdFdzMCtm?=
 =?utf-8?B?bWE4Rk9CaHB5TDlFdW1mamR3Sy9XZUY0L3prYXZEbmo5Y0VoTmNFeXpONlBZ?=
 =?utf-8?B?WmFqOXpaVnZsejViWjEyM0RRZFp0S2NQWlFJdXFwVHBNTGNzejgzYnVheG9C?=
 =?utf-8?B?MlU1cjUzUFVQMFI1SnZhNUJoVklqbHh3dzY5LzROQVMwWVRNMmdEKzVwT2hJ?=
 =?utf-8?B?U3FwZ1d2ME9DdTNETWVQSGx4cGtkWlFjN0xaMVpnOGJFMTJTMXJPN3VxVG5t?=
 =?utf-8?B?c0VnVnF1OFJFNGxUcHg3YmJPUnRPcXhKV1NObnIvZVg0Ri9IVW1PQ094UVRB?=
 =?utf-8?B?R0Y0Q3grdmN0ZjdzNUJ3djh1M1hsYUxzbUZPMXBKb3MyN3J0SHVOdXNVZVly?=
 =?utf-8?B?bzZKeGhyNWZwRWo5bGkzYmM1NUFrRk1ldjNlSkJOSmE1WUZ6WXZiRlZUdHA5?=
 =?utf-8?B?ZFF0NmV3Zmxhc1hkdEY0cFd1YmhIUmhEMVp6Qmp6NlRLME14UHl6NzBCbHNV?=
 =?utf-8?B?c0gzQU5BbEJMV2o0c1V3YzN5YW9jSXI4REkvazJVRXBTM21sR0pBL1BEcnpu?=
 =?utf-8?B?U3hVTU94M29ucXQxSEttSVNnR1JjS0pSSjNpTmxMd2duTGsyd2lpVkZHTGZX?=
 =?utf-8?B?WmxyMC9hbjltc3grMUJialNEblNWQ3Y5QzhBMWM3WmxpNXozeEFzT2hLNDBW?=
 =?utf-8?B?M1BIN2dING1hZkI4UHQ3c2VJOCtCcHpPNzNwVzJnSFJOSm55NlFoMVMxY2Zo?=
 =?utf-8?B?WFNJQ0xqQ0RsVDBDTlBtTzdHOWI0OFMzUDF5YStQME9EMlVCNjJsSG1OTWdL?=
 =?utf-8?B?SEZZSktnODh1bFZBWmU1L1lhRU9NVVVHbDIvZllJNk9RV2lwb2ZVS0doc0Vp?=
 =?utf-8?B?Um9tR3NRV2NNZjR5bHdqaUIyQmdDWTB4blo0SmdHT29jajNOcnpHQ0h4T1c4?=
 =?utf-8?Q?NYx72v7ccq2CwnO/kLmMxS9JB+UndRoffctjGka?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b69cea68-4e4e-4e86-fd02-08d988eaba88
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 16:59:58.4129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bggHViT63pbzmBVJd05CiHdyFd0Rh8LxnekpvEtwyXPJC03Uf4iLvfzRgKPcTwR4/1sQPwUyCAOmrVZCk9iKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2769
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/21 9:45 PM, Mike Christie wrote:
> Cc'ing lee.
> 
> On 10/5/21 11:31 PM, Mike Christie wrote:
>> This fixes a regression added with:
>>
>> commit f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
>> offlinining device")
>>
>> The problem is that after iSCSI recovery, iscsid will call into the kernel
>> to set the dev's state to running, and with that patch we now call
>> scsi_rescan_device with the state_mutex held. If the scsi error handler
>> thread is just starting to test the device in scsi_send_eh_cmnd then it's
>> going to try to grab the state_mutex.
>>
>> We are then stuck, because when scsi_rescan_device tries to send its IO
>> scsi_queue_rq calls -> scsi_host_queue_ready -> scsi_host_in_recovery
>> will return true (the host state is still in recovery) and IO will just be
>> requeued. scsi_send_eh_cmnd will then never be able to grab the
>> state_mutex to finish error handling.
>>
>> This just moves the scsi_rescan_device call to after we drop the
>> state_mutex.
> 
> 
> I want to maybe nak my own patch. There is still a problem where if one
> of the rescan IOs hits an issue then userspace is stuck waiting for
> however long it takes to perform recovery. For iscsid, this will cause
> problems because it sets the device state from its main thread. So
> while scsi_rescan_device is hung then iscsid can't do anything for
> any session.
> 
> I think we either want to:
> 
> 1. Do the patch below, but Lee will need to change iscsid so it sets
> the dev state from a worker thread.
> 
> 2. Have the kernel kick off the rescan from a workqueue. This seems
> easiest but I'm not sure if it will cause issues for lijinlin's use
> case.

I vote for #2, if possible.

> 
> 
>>
>> Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
>> offlinining device")
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/scsi/scsi_sysfs.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 86793259e541..5b63407c3a3f 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -788,6 +788,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>>  	int i, ret;
>>  	struct scsi_device *sdev = to_scsi_device(dev);
>>  	enum scsi_device_state state = 0;
>> +	bool rescan_dev = false;
>>  
>>  	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
>>  		const int len = strlen(sdev_states[i].name);
>> @@ -817,10 +818,13 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>>  	 */
>>  	if (ret == 0 && state == SDEV_RUNNING) {
>>  		blk_mq_run_hw_queues(sdev->request_queue, true);
>> -		scsi_rescan_device(dev);
>> +		rescan_dev = true;
>>  	}
>>  	mutex_unlock(&sdev->state_mutex);
>>  
>> +	if (rescan_dev)
>> +		scsi_rescan_device(dev);
>> +
>>  	return ret == 0 ? count : -EINVAL;
>>  }
>>  
>>
> 

