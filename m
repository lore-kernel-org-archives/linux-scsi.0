Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F37EC4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 17:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56AC322B4E
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 17:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbgLDRNj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 12:13:39 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37966 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730905AbgLDRNj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 12:13:39 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4H9Euo064924;
        Fri, 4 Dec 2020 17:12:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=z8vrJFmnHBre5s0X+Ha8ju5ZAxkwmLaUqRsNel02kvc=;
 b=Tj//AQAH3OfkK8y2g8A1mplf8UvbCIG3BZYMDPZhfL39G5E6s6mXvJUOBlTjNR9TNxwY
 CEv42ptjxyubCvHWdLOK7JqJds4KtG210Txx8cjzk35kvAw8RwzijJtWikLvYJkLA7tP
 yH4ICmL9Aw9Rm+89K24vqz2Jb0349/N80xNbnC/fnAAOMnaGiEUm5PSf9AvhEB0WvMVH
 VhX2lGojcITyIF7Jv1vAfFkWjSrm1/4Uq9EWK793EQd1h5bp6sfAKK8ujBFBlYPFCFBx
 hQuKbR4fLP3hJohevh5c9dkTTPpXcjMgi1vqouSE1jLgdMk4gc7u2WxTnPWcJukwTrWG xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2bca43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 17:12:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4H9UwK081250;
        Fri, 4 Dec 2020 17:10:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540g3xtc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 17:10:54 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B4HAq5A031978;
        Fri, 4 Dec 2020 17:10:53 GMT
Received: from [20.15.0.5] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 09:10:52 -0800
Subject: Re: [RFC PATCH 0/8] vhost: allow userspace to control vq cpu affinity
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     stefanha@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
References: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
 <20201204160651.7wlselx4jm6k66mb@steredhat>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <40b22c4a-f9db-1389-aed1-b3d33678cfda@oracle.com>
Date:   Fri, 4 Dec 2020 11:10:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204160651.7wlselx4jm6k66mb@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040097
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/4/20 10:06 AM, Stefano Garzarella wrote:
> Hi Mike,
> 
> On Fri, Dec 04, 2020 at 01:56:25AM -0600, Mike Christie wrote:
>> These patches were made over mst's vhost branch.
>>
>> The following patches, made over mst's vhost branch, allow userspace
>> to set each vq's cpu affinity. Currently, with cgroups the worker thread
>> inherits the affinity settings, but we are at the mercy of the CPU
>> scheduler for where the vq's IO will be executed on. This can result in
>> the scheduler sometimes hammering a couple queues on the host instead of
>> spreading it out like how the guest's app might have intended if it was
>> mq aware.
>>
>> This version of the patches is not what you guys were talking about
>> initially like with the interface that was similar to nbd's old
>> (3.x kernel days) NBD_DO_IT ioctl where userspace calls down to the
>> kernel and we run from that context. These patches instead just
>> allow userspace to tell the kernel which CPU a vq should run on.
>> We then use the kernel's workqueue code to handle the thread
>> management.
> 
> I agree that reusing kernel's workqueue code would be a good strategy.
> 
> One concern is how easy it is to implement an adaptive polling strategy 
> using workqueues. From what I've seen, adding some polling of both 
> backend and virtqueue helps to eliminate interrupts and reduce latency.
> 
Would the polling you need to do be similar to the vhost net poll code 
like in vhost_net_busy_poll (different algorithm though)? But, we want 
to be able to poll multiple devs/vqs from the same CPU right? Something 
like:

retry:

for each poller on CPU N
	if poller has work
		driver->run work fn

if (poll limit hit)
	return
else
	cpu_relax();
goto retry:

?

If so, I had an idea for it. Let me send an additional patch on top of 
this set.
