Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26F9C4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 17:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6D4E22AAB
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 17:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbgLDReA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 12:34:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731091AbgLDReA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 12:34:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4HNoiY080330;
        Fri, 4 Dec 2020 17:33:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=L+iDa6dDlhvm7pe18W12bCuY2sZwDkK6QTofv8pLkyQ=;
 b=mtLNojK6B/QKxOpDu2gh/+6YpAHoM2HN3mYXKtcqncigh622PoU5PBcTMp0oOznWpxun
 AKN3pcEqOWA/oqk1mqZ8hSOjbGhLUFMa8sJWDegeqFIthedDbrmlxjpN3P5skqKRsolJ
 tGMiwop7h+oerIBYX5BrLOeUGsO7SW1XjhiB1CqXVHEttAJ1X0G9T77QSUqLRTy1P+Yr
 4QOYckKeND5LaqGEeTFriSsOuvAqFJBKOgsRCVIyDikgOCoBCuO+qwMA6kWFvle70Iqe
 v0oIDTxPJoyu/QrkMa6oGOka19/U3tDtEVuJN0jHAtcKUO2MyU+gu0+rRHsDhaLCp7Iv Yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 353dyr4cey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 17:33:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4HOaQF054057;
        Fri, 4 Dec 2020 17:33:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35404skbhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 17:33:14 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B4HXD7Q012977;
        Fri, 4 Dec 2020 17:33:13 GMT
Received: from [20.15.0.5] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 09:33:12 -0800
Subject: Re: [RFC PATCH 0/8] vhost: allow userspace to control vq cpu affinity
From:   Mike Christie <michael.christie@oracle.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     stefanha@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
References: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
 <20201204160651.7wlselx4jm6k66mb@steredhat>
 <40b22c4a-f9db-1389-aed1-b3d33678cfda@oracle.com>
Message-ID: <73defee7-2c9b-7a2b-a532-3c297fc56ca6@oracle.com>
Date:   Fri, 4 Dec 2020 11:33:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <40b22c4a-f9db-1389-aed1-b3d33678cfda@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040099
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/4/20 11:10 AM, Mike Christie wrote:
> On 12/4/20 10:06 AM, Stefano Garzarella wrote:
>> Hi Mike,
>>
>> On Fri, Dec 04, 2020 at 01:56:25AM -0600, Mike Christie wrote:
>>> These patches were made over mst's vhost branch.
>>>
>>> The following patches, made over mst's vhost branch, allow userspace
>>> to set each vq's cpu affinity. Currently, with cgroups the worker thread
>>> inherits the affinity settings, but we are at the mercy of the CPU
>>> scheduler for where the vq's IO will be executed on. This can result in
>>> the scheduler sometimes hammering a couple queues on the host instead of
>>> spreading it out like how the guest's app might have intended if it was
>>> mq aware.
>>>
>>> This version of the patches is not what you guys were talking about
>>> initially like with the interface that was similar to nbd's old
>>> (3.x kernel days) NBD_DO_IT ioctl where userspace calls down to the
>>> kernel and we run from that context. These patches instead just
>>> allow userspace to tell the kernel which CPU a vq should run on.
>>> We then use the kernel's workqueue code to handle the thread
>>> management.
>>
>> I agree that reusing kernel's workqueue code would be a good strategy.
>>
>> One concern is how easy it is to implement an adaptive polling 
>> strategy using workqueues. From what I've seen, adding some polling of 
>> both backend and virtqueue helps to eliminate interrupts and reduce 
>> latency.
>>
> Would the polling you need to do be similar to the vhost net poll code 
> like in vhost_net_busy_poll (different algorithm though)? But, we want 
> to be able to poll multiple devs/vqs from the same CPU right? Something 
> like:
> 
> retry:
> 
> for each poller on CPU N
>      if poller has work
>          driver->run work fn
> 
> if (poll limit hit)
>      return
> else
>      cpu_relax();
> goto retry:
> 
> ?
> 
> If so, I had an idea for it. Let me send an additional patch on top of 
> this set.

Oh yeah, just to make sure I am on the same page for vdpa, because scsi 
and net work so differnetly.

Were you thinking that you would initially run from

vhost_poll_wakeup -> work->fn

then in the vdpa work->fn you would do the kick_vq still, but then also 
kick off a group backend/vq poller. This would then poll the vqs/devs 
that were bound to that CPU from the worker/wq thread.

So I was thinking you want something similar to network's NAPI. Here our 
work->fn is the hard irq, and then the worker is like their softirq we 
poll from.
