Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2922CC00A89
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 17:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADC74208B6
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 17:27:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EJXWHzoB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgJ3R1I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 13:27:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgJ3R1H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 13:27:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09UHOeXL051761;
        Fri, 30 Oct 2020 17:26:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CThKkD8fKLFdJpCtyjsx01DzFICwSg3N9chL45J5io4=;
 b=EJXWHzoBSJ+AfBlD/50K/Th8uri51kFLNNUMkJGIJdB/HZK+psTD7LlD80PUCE/gjdF0
 kuVbQZ7BR0AmyhCCUP/wS2Ard1IPI2vGAphecKytDbGGPyW8gsTlcHsYZKaRnNxNAAvf
 6jdMIri2A95WQyJrJm5HeErHYn3maN9CdZT4B8r0vwHa9V0JLpsL4uMTXy4mUfr8hTxt
 WBKVrcQboCMy+fO1TRj5wcRXyHWyApz8PjRyd3YXT6SEGtayVFJxMA+5wyuJ8Bbnzp+q
 eMLwPErKWzI0uhr3VFo5QkUTs1T/B5lTvubivHomefEIdynkcLbbiNNk2ErXENQLfYo2 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm4gfbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 17:26:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09UHQS55191797;
        Fri, 30 Oct 2020 17:26:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1uqf7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 17:26:56 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09UHQtNP025388;
        Fri, 30 Oct 2020 17:26:55 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Oct 2020 10:26:55 -0700
Subject: Re: [PATCH 07/17] vhost scsi: support delayed IO vq creation
From:   Mike Christie <michael.christie@oracle.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
 <9e97ea2a-bc57-d4aa-4711-35dba20b3b9e@redhat.com>
 <49c2fc29-348c-06db-4823-392f7476d318@oracle.com>
 <20201030044402-mutt-send-email-mst@kernel.org>
 <d53ae860-5b7e-7fd6-d34b-122c03162be1@oracle.com>
Message-ID: <e78d5787-45f5-4b94-9d3b-116639af3c1c@oracle.com>
Date:   Fri, 30 Oct 2020 12:26:54 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <d53ae860-5b7e-7fd6-d34b-122c03162be1@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9790 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9790 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/30/20 11:30 AM, Mike Christie wrote:
> On 10/30/20 3:47 AM, Michael S. Tsirkin wrote:
>> On Tue, Oct 27, 2020 at 12:47:34AM -0500, Mike Christie wrote:
>>> On 10/25/20 10:51 PM, Jason Wang wrote:
>>>>
>>>> On 2020/10/22 上午8:34, Mike Christie wrote:
>>>>> Each vhost-scsi device will need a evt and ctl queue, but the number
>>>>> of IO queues depends on whatever the user has configured in userspace.
>>>>> This patch has vhost-scsi create the evt, ctl and one IO vq at device
>>>>> open time. We then create the other IO vqs when userspace starts to
>>>>> set them up. We still waste some mem on the vq and scsi vq structs,
>>>>> but we don't waste mem on iovec related arrays and for later patches
>>>>> we know which queues are used by the dev->nvqs value.
>>>>>
>>>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>>>> ---
>>>>>    drivers/vhost/scsi.c | 19 +++++++++++++++----
>>>>>    1 file changed, 15 insertions(+), 4 deletions(-)
>>>>
>>>>
>>>> Not familiar with SCSI. But I wonder if it could behave like vhost-net.
>>>>
>>>> E.g userspace should known the number of virtqueues so it can just open
>>>> and close multiple vhost-scsi file descriptors.
>>>>
>>>
>>> One hiccup I'm hitting is that we might end up creating about 3x more 
>>> vqs
>>> than we need. The problem is that for scsi each vhost device has:
>>>
>>> vq=0: special control vq
>>> vq=1: event vq
>>> vq=2 and above: SCSI CMD/IO vqs. We want to create N of these.
>>>
>>> Today we do:
>>>
>>> Uerspace does open(/dev/vhost-scsi)
>>>          vhost_dev_init(create 128 vqs and then later we setup and 
>>> use N of
>>> them);
>>>
>>> Qemu does ioctl(VHOST_SET_OWNER)
>>>          vhost_dev_set_owner()
>>>
>>> For N vqs userspace does:
>>>          // virtqueue setup related ioctls
>>>
>>> Qemu does ioctl(VHOST_SCSI_SET_ENDPOINT)
>>>          - match LIO/target port to vhost_dev
>>>
>>>
>>> So we could change that to:
>>>
>>> For N IO vqs userspace does
>>>          open(/dev/vhost-scsi)
>>>                  vhost_dev_init(create IO, evt, and ctl);
>>>
>>> for N IO vqs Qemu does:
>>>          ioctl(VHOST_SET_OWNER)
>>>                  vhost_dev_set_owner()
>>>
>>> for N IO vqs Qemu does:
>>>          // virtqueue setup related ioctls
>>>
>>> for N IO vqs Qemu does:
>>>          ioctl(VHOST_SCSI_SET_ENDPOINT)
>>>                  - match LIO/target port to vhost_dev and assemble the
>>> multiple vhost_dev device.
>>>
>>> The problem is that we have to setup some of the evt/ctl specific 
>>> parts at
>>> open() time when vhost_dev_init does vhost_poll_init for example.
>>>
>>> - At open time, we don't know if this vhost_dev is going to be part of a
>>> multiple vhost_device device or a single one so we need to create at 
>>> least 3
>>> of them
>>> - If it is a multiple device we don't know if its the first device being
>>> created for the device or the N'th, so we don't know if the dev's vqs 
>>> will
>>> be used for IO or ctls/evts, so we have to create all 3.
>>>
>>> When we get the first VHOST_SCSI_SET_ENDPOINT call for a new style 
>>> multiple
>>> vhost_dev device, we can use that dev's evt/ctl vqs for events/controls
>>> requests. When we get the other VHOST_SCSI_SET_ENDPOINT calls for the
>>> multiple vhost_dev device then those dev's evt/ctl vqs will be 
>>> ignored and
>>> we will only use their IO vqs. So we end up with a lot of extra vqs.
>>
>> The issue Jason's hinting at is how can admins control the amount
>> of resources a given qemu instance can consume?
>> After all vhost vqs all live in host kernel memory ...
>> Limiting # of open fds would be one way to do that ...
> 
> If I understand you, then the answer is vhost scsi has a setting 
> num_queues already that controls the number of vqs. The upstream 
> kernel's vhost scsi driver and qemu's vhost scsi code support multiqueue 
> today. To enable it, the admin is setting the qemu property num_queues 
> (qemu/hw/scsi/host-scsi.c). In the current code, we are already doing 
> what I described in "Today we do:".
> 
> In the second chunk of patches (patches 13 - 16) I'm just trying to make 
> it so vhost-scsi gets a thread per IO vq.
> 
> Patch 17 then fixes up the cgroup support so the user can control the IO 
> vqs with cgroups. Today for vhost scsi the vhost work thread takes the 
> request from the vq, then passes it to a workqueue_struct workqueue to 
> submit it to the block layer. So today we are putting the vhost work 
> thread in the cgroup, but it's a different thread interacting with the 
> block layer, and the cgroup settings/limits are not applying.
> 

Ah, I think I did misundestand you. Today, you can set the fd limit to N 
and that would limit the total number of devices. But right now the user 
can set each of those N device's to have anywhere from num_queues=1 - 
128 which could be a wide range of resource use. You want something 
finer grained right?
