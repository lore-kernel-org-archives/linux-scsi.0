Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03267C63777
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 07:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CC3A2223D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 07:20:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jGfopdR8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgKRHUI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 02:20:08 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59194 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgKRHUI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2020 02:20:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AI7AHij052502;
        Wed, 18 Nov 2020 07:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=vTyEmgL0cQqcMKTkcNJo0gmeMY6q5TZK/xQxC0Ooo8o=;
 b=jGfopdR8GzwnNAZ+jM7WPA3LFgYGgAEzG2C4T3MimxPW1b3YJRdT3dbtGZuCcyZjaGpx
 NyV453vRS4w7Wz7GxQmoVZQuqbu3kUNJJgJS/9EDSKDsH3AzllzbNt28RmkJaw6WlVZU
 /Rhd7VDjd2zxIguwc6lPe0ByUsXr8krVlgRKbqpE36SD7J/Iio0OzWHCklZkeKPo9Rec
 YETR0FdeOxrCmc49tVWx4QjvLQmhSqb2ZR3oofk8moKQjUL9Wkd3ZTTNyq7Gw5kOvde/
 WatUdbKmp2XA0rbmWP+hOn4OxBnUi2x0S350fhArIXq1g7S7N7TaBf3AxQzkDLvSuEwk 2g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34t4raxn5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Nov 2020 07:19:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AI79VF1163877;
        Wed, 18 Nov 2020 07:19:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ts0rxw1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 07:19:47 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AI7JiLa010313;
        Wed, 18 Nov 2020 07:19:44 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Nov 2020 23:19:44 -0800
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
From:   Mike Christie <michael.christie@oracle.com>
To:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     fam@euphon.net, linux-scsi@vger.kernel.org, mst@redhat.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        target-devel@vger.kernel.org, pbonzini@redhat.com
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <20201117164043.GS131917@stefanha-x1.localdomain>
 <bba47572-bec9-794f-5a70-d7f016267022@redhat.com>
 <8318de9f-c585-39f8-d931-1ff5e0341d75@oracle.com>
Message-ID: <ff02b7a9-60e2-c8d4-4de1-3135d2a9e125@oracle.com>
Date:   Wed, 18 Nov 2020 01:19:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <8318de9f-c585-39f8-d931-1ff5e0341d75@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/20 12:57 AM, Mike Christie wrote:
> On 11/17/20 11:17 PM, Jason Wang wrote:
>>
>> On 2020/11/18 上午12:40, Stefan Hajnoczi wrote:
>>> On Thu, Nov 12, 2020 at 05:18:59PM -0600, Mike Christie wrote:
>>>> The following kernel patches were made over Michael's vhost branch:
>>>>
>>>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost__;!!GqivPVa7Brio!MzCv3wdRfz5dltunazRWGCeUkMg91pPEOLpIivsebLX9vhYDSi_E1V36e9H0NoRys_hU$
>>>> and the vhost-scsi bug fix patchset:
>>>>
>>>> https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/20201112170008.GB1555653@stefanha-x1.localdomain/T/*t__;Iw!!GqivPVa7Brio!MzCv3wdRfz5dltunazRWGCeUkMg91pPEOLpIivsebLX9vhYDSi_E1V36e9H0NmuPE_m8$
>>>> And the qemu patch was made over the qemu master branch.
>>>>
>>>> vhost-scsi currently supports multiple queues with the num_queues
>>>> setting, but we end up with a setup where the guest's scsi/block
>>>> layer can do a queue per vCPU and the layers below vhost can do
>>>> a queue per CPU. vhost-scsi will then do a num_queue virtqueues,
>>>> but all IO gets set on and completed on a single vhost-scsi thread.
>>>> After 2 - 4 vqs this becomes a bottleneck.
>>>>
>>>> This patchset allows us to create a worker thread per IO vq, so we
>>>> can better utilize multiple CPUs with the multiple queues. It
>>>> implments Jason's suggestion to create the initial worker like
>>>> normal, then create the extra workers for IO vqs with the
>>>> VHOST_SET_VRING_ENABLE ioctl command added in this patchset.
>>> How does userspace find out the tids and set their CPU affinity?
>>>
>>> What is the meaning of the new VHOST_SET_VRING_ENABLE ioctl? It doesn't
>>> really "enable" or "disable" the vq, requests are processed regardless.
>>
>>
>> Actually I think it should do the real "enable/disable" that tries to follow the virtio spec.
>>
> 
> What does real mean here? For the vdpa enable call for example, would it be like
> ifcvf_vdpa_set_vq_ready where it sets the ready bit or more like mlx5_vdpa_set_vq_ready
> where it can do some more work in the disable case?
> 
> For net and something like ifcvf_vdpa_set_vq_ready's design would we have
> vhost_ring_ioctl() set some vhost_virtqueue enable bit. We then have some helper
> vhost_vq_is_enabled() and some code to detect if userspace supports the new ioctl.
> And then in vhost_net_set_backend do we call vhost_vq_is_enabled()? What is done
> for disable then? It doesn't seem to buy a lot of new functionality. Is it just
> so we follow the spec?
> 
> Or do you want it work more like mlx5_vdpa_set_vq_ready? For this in vhost_ring_ioctl
> when we get the new ioctl we would call into the drivers and have it start queues
> and stop queues? For enable, what we you do for net for this case? For disable,
> would you do something like vhost_net_stop_vq (we don't free up anything allocated
> in vhost_vring_ioctl calls, but we can stop what we setup in the net driver)?
> Is this useful for the current net mq design or is this for something like where
> you would do one vhost net device with multiple vqs?
> 
> My issue/convern is that in general these calls seems useful, but we don't really
> need them for scsi because vhost scsi is already stuck creating vqs like how it does
> due to existing users. If we do the ifcvf_vdpa_set_vq_ready type of design where
> we just set some bit, then the new ioctl does not give us a lot. It's just an extra
> check and extra code.
> 
> And for the mlx5_vdpa_set_vq_ready type of design, it doesn't seem like it's going
> to happen a lot where the admin is going to want to remove vqs from a running device.
> And for both addition/removal for scsi we would need code in virtio scsi to handle
> hot plug removal/addition of a queue and then redoing the multiqueue mappings which
> would be difficult to add with no one requesting it.

Actually I want to half take this last chunk back. When I said in general these calls
seem useful, I meant for the mlx5_vdpa_set_vq_ready type design. For example, if a
user was going to remove/add vCPUs then this functionality where we are completely
adding/removing virtqueues would be useful. We would need a lot more than just
the new ioctl though, because we would want to completely create/setup a new
virtqueue

I do not have any of our users asking for this. You guys work on this more so
you know better.

Another option is to kick it down the road again since I'm not sure my patches
here have a lot to do with this. We could also just do the kernel only approach
(no new ioctl) and then add some new design when we have users asking for it.
