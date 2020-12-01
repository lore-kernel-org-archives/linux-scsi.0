Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF96C63777
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 02:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26AD520809
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 02:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgLACq7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 21:46:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9077 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgLACq7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 21:46:59 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ClRKz5t17zLy1d;
        Tue,  1 Dec 2020 10:45:43 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Dec 2020 10:46:12 +0800
Subject: Re: [PATCH] scsi: zfcp: fix use-after-free in zfcp_unit_remove
To:     Steffen Maier <maier@linux.ibm.com>
CC:     Benjamin Block <bblock@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        <linux-s390@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
References: <20201120074854.31754-1-miaoqinglang@huawei.com>
 <20201125170658.GB8578@t480-pf1aa2c2>
 <4c65bead-2553-171e-54d2-87a9de0330e8@huawei.com>
 <20201126091353.50cf6ab6.cohuck@redhat.com>
 <20201126094259.GE8578@t480-pf1aa2c2>
 <9ba663ad-97fe-6c2a-e15a-45f2de1f0af0@huawei.com>
 <20201126151242.GI8578@t480-pf1aa2c2>
 <90356c8e-f523-1d16-45a2-0c8b9fae15c0@linux.ibm.com>
From:   Qinglang Miao <miaoqinglang@huawei.com>
Message-ID: <fb8fa07f-ed76-479b-4aaa-fbb91dd949e2@huawei.com>
Date:   Tue, 1 Dec 2020 10:46:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <90356c8e-f523-1d16-45a2-0c8b9fae15c0@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2020/11/27 17:21, Steffen Maier 写道:
> On 11/26/20 4:12 PM, Benjamin Block wrote:
>> On Thu, Nov 26, 2020 at 08:07:32PM +0800, Qinglang Miao wrote:
>>> 在 2020/11/26 17:42, Benjamin Block 写道:
>>>> On Thu, Nov 26, 2020 at 09:13:53AM +0100, Cornelia Huck wrote:
>>>>> On Thu, 26 Nov 2020 09:27:41 +0800
>>>>> Qinglang Miao <miaoqinglang@huawei.com> wrote:
>>>>>> 在 2020/11/26 1:06, Benjamin Block 写道:
>>>>>>> On Fri, Nov 20, 2020 at 03:48:54PM +0800, Qinglang Miao wrote:
>> ....
>>>> Let's go by example. If we assume the reference count of `unit->dev` is
>>>> R, and the function starts with R = 1 (otherwise the deivce would've
>>>> been freed already), we get:
>>>>
>>>>       int zfcp_unit_remove(struct zfcp_port *port, u64 fcp_lun)
>>>>       {
>>>>           struct zfcp_unit *unit;
>>>>           struct scsi_device *sdev;
>>>>           write_lock_irq(&port->unit_list_lock);
>>>> // unit->dev (R = 1)
>>>>           unit = _zfcp_unit_find(port, fcp_lun);
>>>> // get_device(&unit->dev)
>>>> // unit->dev (R = 2)
>>>>           if (unit)
>>>>               list_del(&unit->list);
>>>>           write_unlock_irq(&port->unit_list_lock);
>>>>           if (!unit)
>>>>               return -EINVAL;
>>>>           sdev = zfcp_unit_sdev(unit);
>>>>           if (sdev) {
>>>>               scsi_remove_device(sdev);
>>>>               scsi_device_put(sdev);
>>>>           }
>>>> // unit->dev (R = 2)
>>>>           put_device(&unit->dev);
>>>> // unit->dev (R = 1)
>>>>           device_unregister(&unit->dev);
>>>> // unit->dev (R = 0)
>>>>           return 0;
>>>>       }
>>>>
>>>> If we now apply this patch, we'd end up with R = 1 after
>>>> `device_unregister()`, and the device would not be properly removed.
>>>>
>>>> If you still think that's wrong, then you'll need to better explain 
>>>> why.
>>>>
>>> Hi Banjamin and Cornelia,
>>>
>>> Your replies make me reliaze that I've been holding a mistake 
>>> understanding
>>> of put_device() as well as reference count.
>>>
>>> Thanks for you two's patient explanation !!
>>>
>>> BTW, should I send a v2 on these two patches to move the position of
>>> put_device()?
>>
>> Feel free to do so.
>>
>> I think having the `put_device()` call after `device_unregister()` in
>> both `zfcp_unit_remove()` and `zfcp_sysfs_port_remove_store()` is more
>> natural, because it ought to be the last time we touch the object in
>> both functions.
> 
> If you move put_device(), you could add a comment like we did here to 
> explain which (hidden) get_device is undone:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/s390/scsi?id=ef4021fe5fd77ced0323cede27979d80a56211ca 
> 
> ("scsi: zfcp: fix to prevent port_remove with pure auto scan LUNs (only 
> sdevs)")
> So in this patch it could be:
>      put_device(&unit->dev); /* undo _zfcp_unit_find() */
> And in the other patch it could be:
>      put_device(&port->dev); /* undo zfcp_get_port_by_wwpn() */
> Then it would be clearer next time somebody looks at the code.
>
Hi, Steffen

Sorry I didn't notice this mail when I sent a patch to move put_device, 
you suggestion sounds resonable to me, so I send a v2 to add comments.

Thanks.
> Especially for the other patch on zfcp_sysfs_port_remove_store() moving 
> the put_device(&port->dev) to at least *after* the call of 
> zfcp_erp_port_shutdown(port, 0, "syprs_1") would make the code cleaner 
> to me. Along the idead of passing the port to zfcp_erp_port_shutdown 
> with the reference we got from zfcp_get_port_by_wwpn(). That said, the 
> current code is of course still correct as we currently have the port 
> ref of the earlier device_register so passing the port to 
> zfcp_erp_port_shutdown() is safe.
> 
> If we wanted to make the gets and puts nicely nested, then we could move 
> the puts to just before the device_unregister, but that's bike shedding:
>      device_register()   --+
>      get_device() --+      |
>      put_device() --+      |
>      device_unregister() --+
> 
> Benjamin's suggested move location works for me, too. After all, the 
> kdoc of device_unregister explicitly mentions the possibility that other 
> refs might continue to exist after device_unregister was called:
>      device_register()   --+
>      get_device() ---------|--+
>      device_unregister() --+  |
>      put_device() ------------+
Glad to know your opinions, I'd like to take this one on my patch.
> 
