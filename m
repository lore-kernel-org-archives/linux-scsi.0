Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31C9C56202
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 06:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B80B24654
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 06:58:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GzRR5yp7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgKRG6Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 01:58:16 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42836 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgKRG6P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2020 01:58:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AI6sOOt084839;
        Wed, 18 Nov 2020 06:57:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=prjU4NDZWJ5kw/Z/iJs8Ong2w4lNnsKNq+ipIc+THRk=;
 b=GzRR5yp7B1sHH5bBKua3L8J4+kWczPCPXBqiUUGkSBqi4e4kxekZOA22XJdOpOi8FHsD
 KVe3vH5nXGIlF6LmRP49n2+7xMjxgQBRqyduoMd4RsvSSmxBcI5OEBA8j2rXtscA3LPR
 9/9e3yOvWhCAvzElOQl0oPqf6va2f9DbJQbDzNJYgRVF8m/fkHJq2vJ8n6cQfH9BvUBd
 djHvhFg4LuSqgjQkuYT7SqiXE5eA7no3by++/sVkS9N6CdjwjxtwKalaGN7RsJk5TV8y
 Z69EPiRyT7WvvROuJALwFyoqGrG9G7YF91koauzXjd8/RZiREM553Id+yniB+CsOF+AH Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34t7vn6d85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Nov 2020 06:57:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AI6uYWJ152879;
        Wed, 18 Nov 2020 06:57:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34ts5x4p45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 06:57:53 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AI6vof4008847;
        Wed, 18 Nov 2020 06:57:50 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Nov 2020 22:57:50 -0800
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
To:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     fam@euphon.net, linux-scsi@vger.kernel.org, mst@redhat.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        target-devel@vger.kernel.org, pbonzini@redhat.com
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <20201117164043.GS131917@stefanha-x1.localdomain>
 <bba47572-bec9-794f-5a70-d7f016267022@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <8318de9f-c585-39f8-d931-1ff5e0341d75@oracle.com>
Date:   Wed, 18 Nov 2020 00:57:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <bba47572-bec9-794f-5a70-d7f016267022@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/17/20 11:17 PM, Jason Wang wrote:
> 
> On 2020/11/18 上午12:40, Stefan Hajnoczi wrote:
>> On Thu, Nov 12, 2020 at 05:18:59PM -0600, Mike Christie wrote:
>>> The following kernel patches were made over Michael's vhost branch:
>>>
>>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost__;!!GqivPVa7Brio!MzCv3wdRfz5dltunazRWGCeUkMg91pPEOLpIivsebLX9vhYDSi_E1V36e9H0NoRys_hU$
>>> and the vhost-scsi bug fix patchset:
>>>
>>> https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/20201112170008.GB1555653@stefanha-x1.localdomain/T/*t__;Iw!!GqivPVa7Brio!MzCv3wdRfz5dltunazRWGCeUkMg91pPEOLpIivsebLX9vhYDSi_E1V36e9H0NmuPE_m8$
>>> And the qemu patch was made over the qemu master branch.
>>>
>>> vhost-scsi currently supports multiple queues with the num_queues
>>> setting, but we end up with a setup where the guest's scsi/block
>>> layer can do a queue per vCPU and the layers below vhost can do
>>> a queue per CPU. vhost-scsi will then do a num_queue virtqueues,
>>> but all IO gets set on and completed on a single vhost-scsi thread.
>>> After 2 - 4 vqs this becomes a bottleneck.
>>>
>>> This patchset allows us to create a worker thread per IO vq, so we
>>> can better utilize multiple CPUs with the multiple queues. It
>>> implments Jason's suggestion to create the initial worker like
>>> normal, then create the extra workers for IO vqs with the
>>> VHOST_SET_VRING_ENABLE ioctl command added in this patchset.
>> How does userspace find out the tids and set their CPU affinity?
>>
>> What is the meaning of the new VHOST_SET_VRING_ENABLE ioctl? It doesn't
>> really "enable" or "disable" the vq, requests are processed regardless.
> 
> 
> Actually I think it should do the real "enable/disable" that tries to follow the virtio spec.
> 

What does real mean here? For the vdpa enable call for example, would it be like
ifcvf_vdpa_set_vq_ready where it sets the ready bit or more like mlx5_vdpa_set_vq_ready
where it can do some more work in the disable case?

For net and something like ifcvf_vdpa_set_vq_ready's design would we have
vhost_ring_ioctl() set some vhost_virtqueue enable bit. We then have some helper
vhost_vq_is_enabled() and some code to detect if userspace supports the new ioctl.
And then in vhost_net_set_backend do we call vhost_vq_is_enabled()? What is done
for disable then? It doesn't seem to buy a lot of new functionality. Is it just
so we follow the spec?

Or do you want it work more like mlx5_vdpa_set_vq_ready? For this in vhost_ring_ioctl
when we get the new ioctl we would call into the drivers and have it start queues
and stop queues? For enable, what we you do for net for this case? For disable,
would you do something like vhost_net_stop_vq (we don't free up anything allocated
in vhost_vring_ioctl calls, but we can stop what we setup in the net driver)?
Is this useful for the current net mq design or is this for something like where
you would do one vhost net device with multiple vqs?

My issue/convern is that in general these calls seems useful, but we don't really
need them for scsi because vhost scsi is already stuck creating vqs like how it does
due to existing users. If we do the ifcvf_vdpa_set_vq_ready type of design where
we just set some bit, then the new ioctl does not give us a lot. It's just an extra
check and extra code.

And for the mlx5_vdpa_set_vq_ready type of design, it doesn't seem like it's going
to happen a lot where the admin is going to want to remove vqs from a running device.
And for both addition/removal for scsi we would need code in virtio scsi to handle
hot plug removal/addition of a queue and then redoing the multiqueue mappings which
would be difficult to add with no one requesting it.
