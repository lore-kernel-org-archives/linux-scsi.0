From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Wed, 24 Sep 2014 15:22:35 +0300
Message-ID: <5422B78B.4000501@dev.mellanox.co.il>
References: <541C27BF.6070609@acm.org> <541C28E0.7010705@acm.org> <5421A093.1070203@dev.mellanox.co.il> <5421C3DF.5000102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49585 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaIXMWj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2014 08:22:39 -0400
Received: by mail-wg0-f48.google.com with SMTP id x13so2874503wgg.31
        for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2014 05:22:37 -0700 (PDT)
In-Reply-To: <5421C3DF.5000102@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>

On 9/23/2014 10:02 PM, Bart Van Assche wrote:
> On 23/09/2014 10:32, Sagi Grimberg wrote:
>> On 9/19/2014 4:00 PM, Bart Van Assche wrote:
>>> Improve performance by using multiple RDMA/RC channels per SCSI host
>>> for communicating with an SRP target.
>>>
>>
>> Hey Bart,
>>
>> Since you don't seem to negotiate/declare multichannel with the target,
>> did you test this code with some target implementations other than SCST
>> that happen to be out there?
>>
>> Overall, I think this patch would be easier to review if you also
>> provide a list of logical changes (which obviously are introduced in
>> this patch). Patch 7/8 can use some more information of target-channel
>> relations as well.
>
> Hello Sagi,
>
> That's a good question. So far this patch series has only been tested
> against the SCST SRP target driver. However, as you probably noticed, if
> setting up a second or later RDMA channel fails SRP login is not failed
> but communication proceeds with the number of channels that have been
> established. This mechanism should retain backwards compatibility with
> SRP target systems that do not support multichannel communication.
> However, if the new code for SRP login turns out to be triggering bugs
> in existing SRP target implementations we can still add a blacklist for
> these implementations.

I'm more concerned that a target will accept multichannel and then
starts flipping since that wasn't tested in I don't know when, probably
never...

Since SRP_LOGIN_REQ/RESP has some free bits why not declare it and
activate it when both sides *says* they support it? I'd be much calmer
knowing we're on the safe side on this...

>
> I will provide a more detailed list of logical changes in the second
> version of this patch series.

Thanks,

Plus, I would like to run it on my performance setups. can you point me
to the SCST repo? is multichannel supported in scst trunk?

Sagi.
