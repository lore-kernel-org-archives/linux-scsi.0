Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3202EC4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F25E3229C5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgLDQdn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 11:33:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36322 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgLDQdn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 11:33:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4GTCKP178673;
        Fri, 4 Dec 2020 16:32:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=OdRo3BfsP6FJ3mlRU1YB0eBUSCCRQ7rMFsS3pO2KKdU=;
 b=LIh/FkWhUKDEQ13tdYojgRRx+j3a6BdW4JWkaqCu0KzppmTNZwTMJQXpb1GgvktkflHI
 MfGmkLdXazg/73nJn/f8lxdPBT5k59sqi4d/okERoOGlv699pSNxdVliR1qN3NY5RgjV
 l/OKRz/Bf0No5SlwrcR5qijbpnw8m+hwDfvXWFnLsLdx4be07AlxVmLMo/rvzFpV4tmF
 HJWLTca7/x6hHBQ1vAiib5g2CiD3DQH8TrSgPK09AH4NOuqfYV7sUlUHhU0BleWmNVMS
 ubcw5qNTKevZGkbpLUBgjRue6+xmVy1XwWyAHQHXCPs4zcMK7u1crKwS9AMGicdtdnqS MA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egm405w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 16:32:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4GUJc1085453;
        Fri, 4 Dec 2020 16:32:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3540f3hkvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 16:32:58 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B4GWvJq014261;
        Fri, 4 Dec 2020 16:32:57 GMT
Received: from [20.15.0.5] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 08:32:57 -0800
Subject: Re: [RFC PATCH 5/8] vhost: allow userspace to bind vqs to CPUs
To:     Jason Wang <jasowang@redhat.com>, sgarzare@redhat.com,
        stefanha@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
 <1607068593-16932-6-git-send-email-michael.christie@oracle.com>
 <4546ef72-da7c-df9e-53be-c937a5437436@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <30746f1c-ed8c-d2ae-9513-54fca8f52739@oracle.com>
Date:   Fri, 4 Dec 2020 10:32:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <4546ef72-da7c-df9e-53be-c937a5437436@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040094
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/4/20 2:09 AM, Jason Wang wrote:
> 
> On 2020/12/4 下午3:56, Mike Christie wrote:
>> +static long vhost_vring_set_cpu(struct vhost_dev *d, struct 
>> vhost_virtqueue *vq,
>> +                void __user *argp)
>> +{
>> +    struct vhost_vring_state s;
>> +    int ret = 0;
>> +
>> +    if (vq->private_data)
>> +        return -EBUSY;
>> +
>> +    if (copy_from_user(&s, argp, sizeof s))
>> +        return -EFAULT;
>> +
>> +    if (s.num == -1) {
>> +        vq->cpu = s.num;
>> +        return 0;
>> +    }
>> +
>> +    if (s.num >= nr_cpu_ids)
>> +        return -EINVAL;
>> +
>> +    if (!d->ops || !d->ops->get_workqueue)
>> +        return -EINVAL;
>> +
>> +    if (!d->wq)
>> +        d->wq = d->ops->get_workqueue();
>> +    if (!d->wq)
>> +        return -EINVAL;
>> +
>> +    vq->cpu = s.num;
>> +    return ret;
>> +}
> 
> 
> So one question here. Who is in charge of doing this set_cpu? Note 
> that sched_setaffinity(2) requires CAP_SYS_NICE to work, so I wonder 
> whether or not it's legal for unprivileged Qemu to do this.


I was having qemu do it when it's setting up the vqs since it had the 
info there already.

Is it normally the tool that makes calls into qemu that does the 
operations that require CAP_SYS_NICE? If so, then I see the interface 
needs to be changed.
