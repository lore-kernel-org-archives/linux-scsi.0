Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87F5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 12:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhLGMyc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Dec 2021 07:54:32 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4224 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhLGMyb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Dec 2021 07:54:31 -0500
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4J7g9s0pVMz67NsT;
        Tue,  7 Dec 2021 20:49:53 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 13:50:59 +0100
Received: from [10.47.82.161] (10.47.82.161) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 7 Dec
 2021 12:50:59 +0000
From:   John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 02/15] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bart van Assche <bvanassche@acm.org>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-3-hare@suse.de>
 <54d74843-3b14-68c2-a526-a111e26e84a3@huawei.com>
 <ddc265d3-9f31-b4d9-06c4-d205b03a566f@suse.de>
 <2cef903a-80ec-216b-b99a-e4021511711e@huawei.com>
 <bd45ddc5-6865-59dc-0809-b6901dccd1bb@suse.de>
Message-ID: <962fbba6-a3e3-bc54-d905-754afee7a08b@huawei.com>
Date:   Tue, 7 Dec 2021 12:50:42 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <bd45ddc5-6865-59dc-0809-b6901dccd1bb@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.82.161]
X-ClientProxiedBy: lhreml721-chm.china.huawei.com (10.201.108.72) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/12/2021 17:46, Hannes Reinecke wrote:
>> We did discuss libata before, but I'm not sure on the context you mean.
>>
>> One thing that I know is that libata-core has "internal" commands in 
>> ata_exec_internal(). I could not see how that function could be 
>> converted to use queue_rq. The problem is that it calls ->qc_issue() 
>> with IRQs disabled, which is not permitted for calling 
>> blk_execute_rq() instead.
>>
> 
> We're conflating two issues here.

I'm just trying to see the final picture, and not just this first step,
please

> 
> The one issue is to use 'reserved' tags (as defined by the block layer) 
> to allocate commands which are internal within some drivers (like hpsa 
> etc). That is what my patchset does.
> As these commands are internal within specific drivers these commands 
> will never show up in the upper layers, precisely because they are 
> internal.
> 
> The other issue is to allow these 'reserved' tags (and the attached 
> requests/commands) to be routed via the normal block-layer execution 
> path. This is _not_ part of the above patchset, as that just deals with 
> driver internal commands and will never execute ->queue_rq.
> For that we would need an additional patchset, on top of the first one.
> 
>>> And I have some driver conversions queued (fnic in particular), which
>>> encapsulate everything into a scsi command.
>>>
>>>> It just seems to me that what the block layer is providing is not 
>>>> suitable.
>>>>
>>>> How about these:
>>>> a. allow block driver to specify size of reserved request PDU 
>>>> separately
>>>> to regular requests, so we can use something like this for rsvd 
>>>> commands:
>>>> struct scsi_rsvd_cmnd {
>>>>       struct scsi_device *sdev;
>>>> }
>>>> And fix up SCSI iter functions and LLDs to deal with it.
>>> That's what Bart suggested a while back, 
>>
>> I don't recall that one.
>>
>>> but then we have to problem
>>> that the reserved tags are completed with the same interrupt routine,
>>> and_that_  currently assumes that everything is a scsi command.
>>
>> I think that any driver which uses reserved commands needs to be 
>> thought that not all commands are "real" scsi commands, i.e. we don't 
>> call scsi_done() in the LLD ISR always. As such, they should be able 
>> to deal with something like struct scsi_rsvd_cmnd.
>>
> See above. My patchset is strictly for driver internal commands, which 
> will never be send nor completed like 'real' commands.
> And the main point (well, the 'other' main point aside from not having 
> to allocate a tag yourself) is that the driver can be _simplified_, as 
> now every tag references to the _same_ structure.

Sure, but I like the distinction of a separate struct scsi_rsvd_cmnd,
even if it is at the cost of some simplification.

> If we start using different structure we'll lose that ability 
> completely, and really haven't gained that much.
> 
>> BTW, for this current series, please ensure that we can't call 
>> scsi_host_complete_all_commands() which could iter reserved tags, as 
>> we call stuff like scsi_done() there. I don't think it's an issue 
>> here, but just thought that it was worth mentioning.
>>
> See above. These are driver internal commands, for which scsi_done() is 
> never called.

Right, but I am just saying that we need to be careful that it will not be
called possibly in the future. Ignore it for now.

> 
> I deliberately did _not_ add checks to scsi_done() or queue_rq(), as 
> there presumably will be an additional patch which allows precisely 
> this, eg when converting libsas.
> 
>>> Trying to fix up that assumption would mean to audit the midlayer
>>> (scmd->device is a particular common pattern),_and_  all drivers wanting
>>> to make use of reserved commands.
>>> For me that's too high an risk to introduce errors; audits are always
>>> painful and error-prone.
>>>
>>>> b. provide block layer API to provide just same as is returned from
>>>> blk_mq_unique_tag(), but no request is provided. This just gives 
>>>> what we
>>>> need but would be disruptive in scsi layer and LLDs.
>>> Having looked at the block layer and how tags are allocated I found it
>>> too deeply interlinked with the request queue and requests in general.
>>
>> They are indeed interlinked in the block layer, but we don't need 
>> expose requests or anything else.
>>
> Correct. And this is one of the drawbacks of this approach, in that 
> we're always allocating a 'struct request' and a 'struct scsi_cmnd' 
> payload even if we don't actually use them.
> But then again, we _currently_ don't use them.
> If we ever want to sent these 'reserved' commands via queue_rqs() and be 
> able to call 'scsi_done()' on them (again, the libsas case) then we need 
> these payloads.
> 
>> Such an interface could just be a wrapper for 
>> blk_mq_alloc_request()+_start_request().
>>
> I do agree that currently I don't start requests, and consequently they 
> won't show up in any iterators.
> But then (currently) it doesn't matter, as none of the iterators in any 
> of the drivers I've been converting needed to look at those requests.

ok, fine

> 
>>> Plus I've suggested that with a previous patchset, which got vetoed by
>>> Bart as he couldn't use such an API for UFS.
>>>  >> c. as alternative to b., send all rsvd requests through the block 
>>> layer,
>>>> but can be very difficult+disruptive for users
>>>>
>>> And, indeed, not possible when we will need to send these requests
>>> during error handling, where the queue might be blocked/frozen/quiesced
>>> precisely because we are in error handling ...
>>
>> If we send for the host request queue, would it ever be 
>> blocked/frozen/quiesced?
>>
> Possibly not. But be aware that 'reserved' tags is actually independent 
> on the host request queue; it's perfectly possible to use 'reserved' 
> tags without a host request queue. Again, fnic is such an example.

So considering a scsi_device request queue may be blocked/frozen/quiesced,
how should we decide which request queue to use when allocating a
reserved command for some error handling IO? I assume that request
allocation/queuing is failed or blocked in this mentioned scenario for the
sdev request queue.

> 
>>>
>>>> *For polling rsvd commands on a poll queue (which we will need for
>>>> hisi_sas driver and maybe others for poll mode support), we would need
>>>> to send the request through the block layer, but block layer polling
>>>> requires a request with a bio, which is a problem.
>>>>
>>> Allocating a bio is a relatively trivial task.
>>
>> So do you suggest a dummy bio for that request? I hacked something 
>> locally to get it to work as a PoC, but no idea on a real solution yet.
>>
> We're allocating bios for all kind of purposes, even 'dummy' bios in the 
> case of bio_clone() or bio_split(). So that's nothing new, and should be 
> relatively easy.

But these APIs need some bio to begin with, right? Where does that come
from?

Thanks,
John
