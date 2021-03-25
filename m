Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBE4C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 01:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2869C61A18
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 01:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhCYBWV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 21:22:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14525 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239566AbhCYBWC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 21:22:02 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F5S1r5WxszNmxN;
        Thu, 25 Mar 2021 09:19:28 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.117) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Mar 2021
 09:21:51 +0800
Subject: Re: md/dm-mpath: check whether all pgpaths have same uuid in
 multipath_ctr()
To:     Mike Snitzer <snitzer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
CC:     <agk@redhat.com>, <dm-devel@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        linfeilong <linfeilong@huawei.com>,
        lixiaokeng <lixiaokeng@huawei.com>,
        "wubo (T)" <wubo40@huawei.com>
References: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
 <20210322081155.GE1946905@infradead.org> <20210322142207.GB30698@redhat.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <cd71d0fa-31d1-5cd8-74a1-8b124724b3b1@huawei.com>
Date:   Thu, 25 Mar 2021 09:21:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210322142207.GB30698@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.117]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2021/3/22 22:22, Mike Snitzer wrote:
> On Mon, Mar 22 2021 at  4:11am -0400,
> Christoph Hellwig <hch@infradead.org> wrote:
> 
>> On Sat, Mar 20, 2021 at 03:19:23PM +0800, Zhiqiang Liu wrote:
>>> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>>>
>>> When we make IO stress test on multipath device, there will
>>> be a metadata err because of wrong path. In the test, we
>>> concurrent execute 'iscsi device login|logout' and
>>> 'multipath -r' command with IO stress on multipath device.
>>> In some case, systemd-udevd may have not time to process
>>> uevents of iscsi device logout|login, and then 'multipath -r'
>>> command triggers multipathd daemon calls ioctl to load table
>>> with incorrect old device info from systemd-udevd.
>>> Then, one iscsi path may be incorrectly attached to another
>>> multipath which has different uuid. Finally, the metadata err
>>> occurs when umounting filesystem to down write metadata on
>>> the iscsi device which is actually not owned by the multipath
>>> device.
>>>
>>> So we need to check whether all pgpaths of one multipath have
>>> the same uuid, if not, we should throw a error.
>>>
>>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>>> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
>>> Signed-off-by: linfeilong <linfeilong@huawei.com>
>>> Signed-off-by: Wubo <wubo40@huawei.com>
>>> ---
>>>  drivers/md/dm-mpath.c   | 52 +++++++++++++++++++++++++++++++++++++++++
>>>  drivers/scsi/scsi_lib.c |  1 +
>>>  2 files changed, 53 insertions(+)
>>>
>>> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
>>> index bced42f082b0..f0b995784b53 100644
>>> --- a/drivers/md/dm-mpath.c
>>> +++ b/drivers/md/dm-mpath.c
>>> @@ -24,6 +24,7 @@
>>>  #include <linux/workqueue.h>
>>>  #include <linux/delay.h>
>>>  #include <scsi/scsi_dh.h>
>>> +#include <linux/dm-ioctl.h>
>>>  #include <linux/atomic.h>
>>>  #include <linux/blk-mq.h>
>>>
>>> @@ -1169,6 +1170,45 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
>>>  	return r;
>>>  }
>>>
>>> +#define SCSI_VPD_LUN_ID_PREFIX_LEN 4
>>> +#define MPATH_UUID_PREFIX_LEN 7
>>> +static int check_pg_uuid(struct priority_group *pg, char *md_uuid)
>>> +{
>>> +	char pgpath_uuid[DM_UUID_LEN] = {0};
>>> +	struct request_queue *q;
>>> +	struct pgpath *pgpath;
>>> +	struct scsi_device *sdev;
>>> +	ssize_t count;
>>> +	int r = 0;
>>> +
>>> +	list_for_each_entry(pgpath, &pg->pgpaths, list) {
>>> +		q = bdev_get_queue(pgpath->path.dev->bdev);
>>> +		sdev = scsi_device_from_queue(q);
>>
>> Common dm-multipath code should never poke into scsi internals.  This
>> is something for the device handler to check.  It probably also won't
>> work for all older devices.
> 
> Definitely.
> 
> But that aside, userspace (multipathd) _should_ be able to do extra
> validation, _before_ pushing down a new table to the kernel, rather than
> forcing the kernel to do it.

As your said, it is better to do extra validation in userspace (multipathd).
However, in some cases, the userspace cannot see the real-time present devices
info as Martin (committer of multipath-tools) said.
In addition, the kernel can see right device info in the table at any time,
so the uuid check in kernel can ensure one multipath is composed with paths mapped to
the same device.

Considering the severity of the wrong path in multipath, I think it worths more
checking.

Regards
Zhiqiang Liu.


> 
> .
> 

