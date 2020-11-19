Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8B7C63697
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 16:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B30CD2222A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 16:44:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XbYjRLGK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgKSQoD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 11:44:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48464 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbgKSQoC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 11:44:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJGhjcM095167;
        Thu, 19 Nov 2020 16:43:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+ApXWtZGfu+O1bz3mzFfdZ4acwEqWfrjwehPFPpqL1w=;
 b=XbYjRLGKG2x4zh/HP0jUZwV4xPEe+nlEcn49SZgJRBrOw81HouDn8nBpAYzwIyL+kW8s
 vvNq9IaKpA+zjHaI2efuFsoNxiHAuFxzXGoaPAUDdE9vSOBYiK8c/r5OB6hrtBwgbN9b
 S2DvcxpsPl25qLt30urrtjsFrERmvXnVJ9hKhBP4ghbVYP0hybSUgrMlXYEPpyl5kVRP
 SCJD2TPLTa/wb25QNSksoT8YvB/lQ9AKt21wo9tw05rW9wK/AxWTHoB1BGNVPI2Z36fg
 W4cXYfGo6rRyYZeRzPdAZUQ1OYsXMIBy2kVg9mmGffk7KMMcLxoh4PjixxMq8o6qj7Rn bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34t7vned9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Nov 2020 16:43:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJGPNYW058340;
        Thu, 19 Nov 2020 16:43:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34umd26uk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 16:43:44 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AJGhgn3013224;
        Thu, 19 Nov 2020 16:43:42 GMT
Received: from [20.15.0.5] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 08:43:42 -0800
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, fam <fam@euphon.net>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <20201117164043.GS131917@stefanha-x1.localdomain>
 <b3343762-bb11-b750-46ec-43b5556f2b8e@oracle.com>
 <20201118113117.GF182763@stefanha-x1.localdomain>
 <20201119094315-mutt-send-email-mst@kernel.org>
 <ceebdc90-3ffc-1563-ff85-12a848bcba18@oracle.com>
 <CAJSP0QUvSwX5NCPmfSODV_C+D41E21LZT=oXQ2PLc6baAsGGDQ@mail.gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <ffd88f0c-981e-a102-4b08-f29d6b9a0f71@oracle.com>
Date:   Thu, 19 Nov 2020 10:43:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <CAJSP0QUvSwX5NCPmfSODV_C+D41E21LZT=oXQ2PLc6baAsGGDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9809 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9809 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190120
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/20 10:24 AM, Stefan Hajnoczi wrote:
> On Thu, Nov 19, 2020 at 4:13 PM Mike Christie
> <michael.christie@oracle.com> wrote:
>>
>> On 11/19/20 8:46 AM, Michael S. Tsirkin wrote:
>>> On Wed, Nov 18, 2020 at 11:31:17AM +0000, Stefan Hajnoczi wrote:
>>>>> My preference has been:
>>>>>
>>>>> 1. If we were to ditch cgroups, then add a new interface that would allow
>>>>> us to bind threads to a specific CPU, so that it lines up with the guest's
>>>>> mq to CPU mapping.
>>>>
>>>> A 1:1 vCPU/vq->CPU mapping isn't desirable in all cases.
>>>>
>>>> The CPU affinity is a userspace policy decision. The host kernel should
>>>> provide a mechanism but not the policy. That way userspace can decide
>>>> which workers are shared by multiple vqs and on which physical CPUs they
>>>> should run.
>>>
>>> So if we let userspace dictate the threading policy then I think binding
>>> vqs to userspace threads and running there makes the most sense,
>>> no need to create the threads.
>>>
>>
>> Just to make sure I am on the same page, in one of the first postings of
>> this set at the bottom of the mail:
>>
>> https://urldefense.com/v3/__https://www.spinics.net/lists/linux-scsi/msg148322.html__;!!GqivPVa7Brio!PdGIFdzqcAb6DW8twtjX3r7xOcM7XbTh7Ndkhxhb-1fV1VNB4lXjFzwFVE1zczUIE2Mp$
>>
>> I asked about a new interface and had done something more like what
>> Stefan posted:
>>
>>     struct vhost_vq_worker_info {
>>         /*
>>          * The pid of an existing vhost worker that this vq will be
>>          * assigned to. When pid is 0 the virtqueue is assigned to the
>>          * default vhost worker. When pid is -1 a new worker thread is
>>          * created for this virtqueue. When pid is -2 the virtqueue's
>>          * worker thread is unchanged.
>>          *
>>          * If a vhost worker no longer has any virtqueues assigned to it
>>          * then it will terminate.
>>          *
>>          * The pid of the vhost worker is stored to this field when the
>>          * ioctl completes successfully. Use pid -2 to query the current
>>          * vhost worker pid.
>>          */
>>         __kernel_pid_t pid;  /* in/out */
>>
>>         /* The virtqueue index*/
>>         unsigned int vq_idx; /* in */
>>     };
>>
>> This approach is simple and it allowed me to have userspace map queues
>> and threads optimally for our setups.
>>
>> Note: Stefan, in response to your previous comment, I am just using my
>> 1:1 mapping as an example and would make it configurable from userspace.
>>
>> In the email above are you guys suggesting to execute the SCSI/vhost
>> requests in userspace? We should not do that because:
>>
>> 1. It negates part of what makes vhost fast where we do not have to kick
>> out to userspace then back to the kernel.
>>
>> 2. It's not doable or becomes a crazy mess because vhost-scsi is tied to
>> the scsi/target layer in the kernel. You can't process the scsi command
>> in userspace since the scsi state machine and all its configuration info
>> is in the kernel's scsi/target layer.
>>
>> For example, I was just the maintainer of the target_core_user module
>> that hooks into LIO/target on the backend (vhost-scsi hooks in on the
>> front end) and passes commands to userspace and there we have a
>> semi-shadow state machine. It gets nasty to try and maintain/sync state
>> between lio/target core in the kernel and in userspace. We also see the
>> perf loss I mentioned in #1.
> 
> No, if I understand Michael correctly he has suggested a different approach.
> 
> My suggestion was that the kernel continues to manage the worker
> threads but an ioctl allows userspace to control the policy.
> 
> I think Michael is saying that the kernel shouldn't manage/create
> threads. Userspace should create threads and then invoke an ioctl from
> those threads.
> 
> The ioctl will call into the vhost driver where it will execute
> something similar to vhost_worker(). So this ioctl will block while
> the kernel is using the thread to process vqs.
> 
> What isn't clear to me is how to tell the kernel which vqs are
> processed by a thread. We could try to pass that information into the
> ioctl. I'm not sure what the cleanest solution is here.
> 
> Maybe something like:
> 
> struct vhost_run_worker_info {
>      struct timespec *timeout;
>      sigset_t *sigmask;
> 
>      /* List of virtqueues to process */
>      unsigned nvqs;
>      unsigned vqs[];
> };
> 
> /* This blocks until the timeout is reached, a signal is received, or
> the vhost device is destroyed */
> int ret = ioctl(vhost_fd, VHOST_RUN_WORKER, &info);
> 
> As you can see, userspace isn't involved with dealing with the
> requests. It just acts as a thread donor to the vhost driver.
> 
> We would want the VHOST_RUN_WORKER calls to be infrequent to avoid the
> penalty of switching into the kernel, copying in the arguments, etc.

I didn't get this part. Why have the timeout? When the timeout expires, 
does userspace just call right back down to the kernel or does it do 
some sort of processing/operation?

You could have your worker function run from that ioctl wait for a 
signal or a wake up call from the vhost_work/poll functions.


> 
> Michael: is this the kind of thing you were thinking of?
> 
> Stefan
> 

