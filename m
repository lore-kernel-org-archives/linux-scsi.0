Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54302C2D0A8
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 19:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E408720BED
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 19:14:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HxKCEOo+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgIWTO7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 15:14:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46916 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWTO7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2020 15:14:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NJ5Z7B050262;
        Wed, 23 Sep 2020 19:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FOhm5BDhhxeDYqPw6WM2h2xUFnH+2vEGRQOEp8Grrlw=;
 b=HxKCEOo+C6yh45LP7xXftAjGnii+qKm00aQ1UtStYU3GbCTHmA/2C9Bj75JhoCpNqUUU
 UUimTEHHyI0cXku6n/X7M+uIDVDAPsG1XO5dWUncsHqVNFoSnmtoawqM9BHl/4Yf0vAw
 uEnn9HhsJK7wiUPG0rBcj8l1Na8PEYgytd2AyWUYL8vXk/hGHHVHRV1ximhz/MO9EVrb
 F5yFkPg/v+qgFm97jEZUAK7UAQOaw3ocuHIhWfDGyN0BztFUJc7xfTCVOWallh0ly3xh
 gPjO2HsVo6JUp/8HKHpp+ijmjpU/9Q3emlDSLqdRW9zcKt/xHfcP3In6n6UKmcUY+j/p HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33q5rgjpy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 19:14:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NJ6Qi1185797;
        Wed, 23 Sep 2020 19:12:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33nurv4a9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 19:12:53 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08NJCqNs014956;
        Wed, 23 Sep 2020 19:12:52 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 12:12:52 -0700
Subject: Re: [PATCH 2/8] vhost: add helper to check if a vq has been setup
To:     Jason Wang <jasowang@redhat.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-3-git-send-email-michael.christie@oracle.com>
 <e2d16333-d5ed-4c5c-58b3-7b5d0a9da47a@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <63094bae-1f26-c21e-9b3c-3a6aa99a7e24@oracle.com>
Date:   Wed, 23 Sep 2020 14:12:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e2d16333-d5ed-4c5c-58b3-7b5d0a9da47a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230141
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/21/20 9:02 PM, Jason Wang wrote:
> 
> On 2020/9/22 上午2:23, Mike Christie wrote:
>> This adds a helper check if a vq has been setup. The next patches
>> will use this when we move the vhost scsi cmd preallocation from per
>> session to per vq. In the per vq case, we only want to allocate cmds
>> for vqs that have actually been setup and not for all the possible
>> vqs.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/vhost/vhost.c | 9 +++++++++
>>   drivers/vhost/vhost.h | 1 +
>>   2 files changed, 10 insertions(+)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index b45519c..5dd9eb1 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -305,6 +305,15 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
>>       spin_lock_init(&call_ctx->ctx_lock);
>>   }
>>   +bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
>> +{
>> +    if (vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq))
>> +        return true;
>> +    else
>> +        return false;
>> +}
>> +EXPORT_SYMBOL_GPL(vhost_vq_is_setup);
> 
> 
> This is probably ok but I wonder maybe we should have something like what vDPA did (VHOST_SET_VRING_ENABLE) to match virtio 1.0 device definition.

It looks like I can make that work. Some questions:

1. Do you mean a generic VHOST_SET_VRING_ENABLE or a SCSI specific one VHOST_SCSI_SET_VRING_ENABLE?

2. I can see the VHOST_VDPA_SET_VRING_ENABLE kernel code and the vhost_set_vring_enable qemu code, so I have an idea of how it should work for vhost scsi. However, I'm not sure the requirements for a generic VHOST_SET_VRING_ENABLE if that is what you meant. I could not find it in the spec either. Could you send me a pointer to the section?

For example, for vhost-net we seem to enable a device in the VHOST_NET_SET_BACKEND ioctl, so I'm not sure what behavior should be or needs to be implemented for net and vsock.


