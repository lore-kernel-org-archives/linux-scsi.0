Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07582C6379F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 16:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B45A422259
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 16:12:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ucz61CzU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgKSQMG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 11:12:06 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54506 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbgKSQMG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 11:12:06 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJG4LOB128799;
        Thu, 19 Nov 2020 16:11:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=92SZnX3AmTlsNeLjdzDjgxioxeshvMDSZzrbzEVNdHw=;
 b=ucz61CzUjt3SQggm8KhfBtBK90thUX5sCvbKDfLnG+TvCfqFfuLmnMafg+YDW2qAfg0i
 xLKnLvG1pGgDRDHAGrT3NxSgoP0GFjJ1ZfmWTXu26l1H1iilV8sYImSWdVxmjgbuhBWU
 QgE97hgKD+368JpOfkfJdl1Bc/fTI3qmO47MW0xzdAdJN+nfzM6takSkLgngeKEHxdjU
 3W9fpuffPoaObWfmYY8zWx570AZC67fX1S8p1Mx0BFLlIukNL94YwoeuK67xhPX/+DnB
 /D+KloSU1FfSWCZotg2IlM+4zXoJKQ1ICTSlxtQyeex6LZ1MxKj+4Z20SIzN99ZH3GAz Cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34t4rb6bqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Nov 2020 16:11:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJG5hbV185393;
        Thu, 19 Nov 2020 16:11:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34uspwc13c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 16:11:48 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AJGBjtw031464;
        Thu, 19 Nov 2020 16:11:46 GMT
Received: from [20.15.0.5] (/73.88.28.6) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Thu, 19 Nov 2020 08:11:41 -0800
USER-AGENT: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
Content-Language: en-US
MIME-Version: 1.0
Message-ID: <ceebdc90-3ffc-1563-ff85-12a848bcba18@oracle.com>
Date:   Thu, 19 Nov 2020 16:11:40 +0000 (UTC)
From:   Mike Christie <michael.christie@oracle.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <20201117164043.GS131917@stefanha-x1.localdomain>
 <b3343762-bb11-b750-46ec-43b5556f2b8e@oracle.com>
 <20201118113117.GF182763@stefanha-x1.localdomain>
 <20201119094315-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201119094315-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9809 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9809 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190118
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/20 8:46 AM, Michael S. Tsirkin wrote:
> On Wed, Nov 18, 2020 at 11:31:17AM +0000, Stefan Hajnoczi wrote:
>>> My preference has been:
>>>
>>> 1. If we were to ditch cgroups, then add a new interface that would allow
>>> us to bind threads to a specific CPU, so that it lines up with the guest's
>>> mq to CPU mapping.
>>
>> A 1:1 vCPU/vq->CPU mapping isn't desirable in all cases.
>>
>> The CPU affinity is a userspace policy decision. The host kernel should
>> provide a mechanism but not the policy. That way userspace can decide
>> which workers are shared by multiple vqs and on which physical CPUs they
>> should run.
> 
> So if we let userspace dictate the threading policy then I think binding
> vqs to userspace threads and running there makes the most sense,
> no need to create the threads.
> 

Just to make sure I am on the same page, in one of the first postings of 
this set at the bottom of the mail:

https://www.spinics.net/lists/linux-scsi/msg148322.html

I asked about a new interface and had done something more like what 
Stefan posted:

   struct vhost_vq_worker_info {
       /*
        * The pid of an existing vhost worker that this vq will be
        * assigned to. When pid is 0 the virtqueue is assigned to the
        * default vhost worker. When pid is -1 a new worker thread is
        * created for this virtqueue. When pid is -2 the virtqueue's
        * worker thread is unchanged.
        *
        * If a vhost worker no longer has any virtqueues assigned to it
        * then it will terminate.
        *
        * The pid of the vhost worker is stored to this field when the
        * ioctl completes successfully. Use pid -2 to query the current
        * vhost worker pid.
        */
       __kernel_pid_t pid;  /* in/out */

       /* The virtqueue index*/
       unsigned int vq_idx; /* in */
   };

This approach is simple and it allowed me to have userspace map queues 
and threads optimally for our setups.

Note: Stefan, in response to your previous comment, I am just using my 
1:1 mapping as an example and would make it configurable from userspace.

In the email above are you guys suggesting to execute the SCSI/vhost 
requests in userspace? We should not do that because:

1. It negates part of what makes vhost fast where we do not have to kick 
out to userspace then back to the kernel.

2. It's not doable or becomes a crazy mess because vhost-scsi is tied to 
the scsi/target layer in the kernel. You can't process the scsi command 
in userspace since the scsi state machine and all its configuration info 
is in the kernel's scsi/target layer.

For example, I was just the maintainer of the target_core_user module 
that hooks into LIO/target on the backend (vhost-scsi hooks in on the 
front end) and passes commands to userspace and there we have a 
semi-shadow state machine. It gets nasty to try and maintain/sync state 
between lio/target core in the kernel and in userspace. We also see the 
perf loss I mentioned in #1.
