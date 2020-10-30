Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE24C00A89
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 16:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA6042151B
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 16:30:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dayIVAUo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgJ3Qa0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 12:30:26 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59118 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgJ3QaZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 12:30:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09UGPKPd110010;
        Fri, 30 Oct 2020 16:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=x0B4h1PKNQTQCjBOc78CBMVDKKSaBPuk6XwzMFUnwas=;
 b=dayIVAUoMcqbattTPt1oG3HqVn64MC5ggJ0beNhsdkSMa8CIGwqCd14/wfH4tCHlhgVT
 4OELjSwmom5IaxkZTPYb3wTQ0v+p7zGdHHGcM7/YzcSyZDplhHw7sO8ws2+ICY+Bbddm
 dp1nAKV6p9xb3Bhvu7/J9k6mxmPcbRxgGOr7yAvfDD0Z/m3AR7eMa5bRfSOEypEPsRBn
 rAx1iVIM+z294rkg3ipMzIkMdvN68BT1f01pfGblC+wWMZ6wvVIwTkFEd4pRZ/2VQsuw
 ql71qSkCB93la5gLey6VtcfhLkJHf10/0S0oGzs8ymOIPuAJ+0lmGNZltHmIv6D6jIce 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9sbara4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 16:30:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09UGOZbX067707;
        Fri, 30 Oct 2020 16:30:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34cwur5944-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 16:30:20 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09UGUIZR023334;
        Fri, 30 Oct 2020 16:30:18 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Oct 2020 09:30:18 -0700
Subject: Re: [PATCH 07/17] vhost scsi: support delayed IO vq creation
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
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <d53ae860-5b7e-7fd6-d34b-122c03162be1@oracle.com>
Date:   Fri, 30 Oct 2020 11:30:16 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201030044402-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9790 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9790 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300121
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/30/20 3:47 AM, Michael S. Tsirkin wrote:
> On Tue, Oct 27, 2020 at 12:47:34AM -0500, Mike Christie wrote:
>> On 10/25/20 10:51 PM, Jason Wang wrote:
>>>
>>> On 2020/10/22 上午8:34, Mike Christie wrote:
>>>> Each vhost-scsi device will need a evt and ctl queue, but the number
>>>> of IO queues depends on whatever the user has configured in userspace.
>>>> This patch has vhost-scsi create the evt, ctl and one IO vq at device
>>>> open time. We then create the other IO vqs when userspace starts to
>>>> set them up. We still waste some mem on the vq and scsi vq structs,
>>>> but we don't waste mem on iovec related arrays and for later patches
>>>> we know which queues are used by the dev->nvqs value.
>>>>
>>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>>> ---
>>>>    drivers/vhost/scsi.c | 19 +++++++++++++++----
>>>>    1 file changed, 15 insertions(+), 4 deletions(-)
>>>
>>>
>>> Not familiar with SCSI. But I wonder if it could behave like vhost-net.
>>>
>>> E.g userspace should known the number of virtqueues so it can just open
>>> and close multiple vhost-scsi file descriptors.
>>>
>>
>> One hiccup I'm hitting is that we might end up creating about 3x more vqs
>> than we need. The problem is that for scsi each vhost device has:
>>
>> vq=0: special control vq
>> vq=1: event vq
>> vq=2 and above: SCSI CMD/IO vqs. We want to create N of these.
>>
>> Today we do:
>>
>> Uerspace does open(/dev/vhost-scsi)
>>          vhost_dev_init(create 128 vqs and then later we setup and use N of
>> them);
>>
>> Qemu does ioctl(VHOST_SET_OWNER)
>>          vhost_dev_set_owner()
>>
>> For N vqs userspace does:
>>          // virtqueue setup related ioctls
>>
>> Qemu does ioctl(VHOST_SCSI_SET_ENDPOINT)
>>          - match LIO/target port to vhost_dev
>>
>>
>> So we could change that to:
>>
>> For N IO vqs userspace does
>>          open(/dev/vhost-scsi)
>>                  vhost_dev_init(create IO, evt, and ctl);
>>
>> for N IO vqs Qemu does:
>>          ioctl(VHOST_SET_OWNER)
>>                  vhost_dev_set_owner()
>>
>> for N IO vqs Qemu does:
>>          // virtqueue setup related ioctls
>>
>> for N IO vqs Qemu does:
>>          ioctl(VHOST_SCSI_SET_ENDPOINT)
>>                  - match LIO/target port to vhost_dev and assemble the
>> multiple vhost_dev device.
>>
>> The problem is that we have to setup some of the evt/ctl specific parts at
>> open() time when vhost_dev_init does vhost_poll_init for example.
>>
>> - At open time, we don't know if this vhost_dev is going to be part of a
>> multiple vhost_device device or a single one so we need to create at least 3
>> of them
>> - If it is a multiple device we don't know if its the first device being
>> created for the device or the N'th, so we don't know if the dev's vqs will
>> be used for IO or ctls/evts, so we have to create all 3.
>>
>> When we get the first VHOST_SCSI_SET_ENDPOINT call for a new style multiple
>> vhost_dev device, we can use that dev's evt/ctl vqs for events/controls
>> requests. When we get the other VHOST_SCSI_SET_ENDPOINT calls for the
>> multiple vhost_dev device then those dev's evt/ctl vqs will be ignored and
>> we will only use their IO vqs. So we end up with a lot of extra vqs.
> 
> The issue Jason's hinting at is how can admins control the amount
> of resources a given qemu instance can consume?
> After all vhost vqs all live in host kernel memory ...
> Limiting # of open fds would be one way to do that ...

If I understand you, then the answer is vhost scsi has a setting 
num_queues already that controls the number of vqs. The upstream 
kernel's vhost scsi driver and qemu's vhost scsi code support multiqueue 
today. To enable it, the admin is setting the qemu property num_queues 
(qemu/hw/scsi/host-scsi.c). In the current code, we are already doing 
what I described in "Today we do:".

In the second chunk of patches (patches 13 - 16) I'm just trying to make 
it so vhost-scsi gets a thread per IO vq.

Patch 17 then fixes up the cgroup support so the user can control the IO 
vqs with cgroups. Today for vhost scsi the vhost work thread takes the 
request from the vq, then passes it to a workqueue_struct workqueue to 
submit it to the block layer. So today we are putting the vhost work 
thread in the cgroup, but it's a different thread interacting with the 
block layer, and the cgroup settings/limits are not applying.


> 
> The need to share event/control vqs between devices is a problem though,
> and sending lots of ioctls on things like reset is also not that elegant.
> Jason, did you have a good solution in mind?
> 
>> One other question/issue I have is that qemu can open the /dev/vhost-scsi
>> device or it allows tools like libvirtd to open the device and pass in the
>> fd to use. For the latter case, would we continue to have those tools pass
>> in the leading fd, then have qemu do the other num_queues - 1
>> open(/dev/vhost-scsi) calls? Or do these apps that pass in the fd need to
>> know about all of the fds for some management reason?
> 
> They know about all the fds, for resource control and priveledge
> separation reasons.
> 

