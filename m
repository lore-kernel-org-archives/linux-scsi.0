Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC03C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Mar 2022 22:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351646AbiC3Wc2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Mar 2022 18:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245658AbiC3Wc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2022 18:32:26 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED87E5BD33
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 15:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648679440; x=1680215440;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j5/+7NjVRG9pSqEJs+3YZQ+s6jwWs0SKfwoc0psMQ+M=;
  b=O7jwTuX+G29K/0FKPf6j4yUW5hEuoYHjuNpLk6MzjUg7xGbia+XHPUsQ
   aZlHHpbqX5IlZAShU4jFQdc6yzRqAVLrZTK8ek1ezQxncW6NXwjGVkOcD
   X1TYpj2VkMDSHhf2wZZKlaaPlSGz+EjVCalFoywHN5RpZO9XTougDWN7z
   6RjxcC5WzL0Mi5hpcWsQl/5VBHzHZGsRG8mOY+gPZJbBbRJjshXPX/wd0
   xawKldrV/tJ+0os+/KO/X99QA6PB7F6C9bEPMp+eVlYOcYRVxiiJgy6R2
   SqP1UQPzUFR4LXQLygA0nCssWW1xR6MjaPJzi9RePYT6mYTvHcIKv5NEn
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,223,1643644800"; 
   d="scan'208";a="308631223"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2022 06:30:39 +0800
IronPort-SDR: 44HuNhMM+MMyP0lrDlH42bOBVM7uxRjrQH6fybaiQQCz9Xpf7N1ov7R1n6qjlqYNw4BOL/XyUW
 wMrg3fjKvpj+hfnjFS+Saxqt1YnIayky2yNFpC+S+G723cak7BgtR12oig+WplGOmNbv1g3jwI
 Dwh/4WURTQG+JaHE2fecHZCHO3ZP9uPzkHL+oNrKXcbCke9agAD0m88V1wW+bhEJ28N2uB14yX
 s86Wxm5sCCXqDFshMmL2IpamOtq9G1AAT5yC8pLuXuX2FoYam+SYEeVlHPLDq6gLZr+gzpBEE/
 h8myeCG1ARC6Clg7XHlyoopv
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Mar 2022 15:01:29 -0700
IronPort-SDR: rD8ZU6SZfpNntnV8WGtQHtyofBpI2kWTRvFixqkaDtmz8pA6A7S/O6CHlSCQt7C8gmp2dsNpts
 6w2TKt0xKDb30MmilzboGBV3iRlVLjdSW8laOYVWTyecK37Xia4/f2az3LMpR/IxuIG6acXOG/
 SF7unaO+xTLEaSzFs32t3284BVlWg0JRXet+lURlcjtLNn5M3ZyCWra4M4biOWnihqJITuo1iS
 uuvqrQzCxm80frpDgSWMPXLJ1go4u/LtIjyQ4UhkoA8Ezbs5yRP/ySV65qyapDKNvSq8NyNSaA
 c+Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Mar 2022 15:30:40 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KTLjq1Crvz1SVny
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 15:30:39 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1648679438; x=1651271439; bh=j5/+7NjVRG9pSqEJs+3YZQ+s6jwWs0SKfwo
        c0psMQ+M=; b=qhNRTS8qSTMNHIgXO1kWagzYlKg+EvQ/crJuOZAc01Bth/0UZ8t
        kvEZM1QOmWFrUMR9f7kyRvoUyLfgD1sQgcCu17/+LtceoLDZ0ngeypnahSiHT/2X
        iJShARZdKwzs4CwqPCp47LgMNAsTzQcb9uTl4p+NNpkSOn6SJjFttd1c2dlsY4G5
        TZxv1MiVK9nX8QIq5+ntmhYwVGtI1FhxxlSEXTrnmUlfs0JB4xWKYksYT3pvBY29
        zyARL9dDOFnonTs9b+xdyRQekwORLdRauRD0NGIoh6XmKyCj83hj4fS15l8lzKUk
        zGxLYcETMgswy8+cEPk30l2RTzJYtFlxAQg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id odeF3wjJORjw for <linux-scsi@vger.kernel.org>;
        Wed, 30 Mar 2022 15:30:38 -0700 (PDT)
Received: from [10.225.163.121] (unknown [10.225.163.121])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KTLjm5HCsz1Rvlx;
        Wed, 30 Mar 2022 15:30:36 -0700 (PDT)
Message-ID: <ba090f1b-a767-46a1-5728-82d9c587ef3c@opensource.wdc.com>
Date:   Thu, 31 Mar 2022 07:30:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: filesystem corruption with "scsi: core: Reallocate device's
 budget map on queue depth change"
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>
Cc:     John Garry <john.garry@huawei.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Martin Wilck <martin.wilck@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <YkQsumJ3lgGsagd2@arighi-desktop>
 <f7bacce8-b5e5-3ef1-e116-584c01533f69@huawei.com>
 <YkQ9KoKb+VK06zXi@arighi-desktop>
 <08717833-19bb-8aaa-4f24-2989a9f56cd3@huawei.com>
 <263108383b1c01cf9237ff2fcd2e97a482eff83e.camel@linux.ibm.com>
 <YkRfrjgNpD+S2WpN@T590>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YkRfrjgNpD+S2WpN@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/30/22 22:48, Ming Lei wrote:
> On Wed, Mar 30, 2022 at 09:31:35AM -0400, James Bottomley wrote:
>> On Wed, 2022-03-30 at 13:59 +0100, John Garry wrote:
>>> On 30/03/2022 12:21, Andrea Righi wrote:
>>>> On Wed, Mar 30, 2022 at 11:38:02AM +0100, John Garry wrote:
>>>>> On 30/03/2022 11:11, Andrea Righi wrote:
>>>>>> Hello,
>>>>>>
>>>>>> after this commit I'm experiencing some filesystem corruptions
>>>>>> at boot on a power9 box with an aacraid controller.
>>>>>>
>>>>>> At the moment I'm running a 5.15.30 kernel; when the filesystem
>>>>>> is mounted at boot I see the following errors in the console:
>>>
>>> About "scsi: core: Reallocate device's budget map on queue depth
>>> change" being added to a stable kernel, I am not sure if this was
>>> really a fix  or just a memory optimisation.
>>
>> I can see how it becomes the problem: it frees and allocates a new
>> bitmap across a queue freeze, but bits in the old one might still be in
>> use.  This isn't a problem except when they return and we now possibly
>> see a tag greater than we think we can allocate coming back. 
>> Presumably we don't check this and we end up doing a write to
>> unallocated memory.
>>
>> I think if you want to reallocate on queue depth reduction, you might
>> have to drain the queue as well as freeze it.
> 
> After queue is frozen, there can't be any in-flight request/scsi
> command, so the sbitmap is zeroed at that time, and safe to reallocate.
> 
> The problem is aacraid specific, since the driver has hard limit
> of 256 queue depth, see aac_change_queue_depth().

256 is the scsi hard limit per device... Any SAS drive has the same limit
by default since there is no way to know the max queue depth of a scsi
disk. So what is special about aacraid ?

> 
> 
> Thanks,
> Ming
> 


-- 
Damien Le Moal
Western Digital Research
