From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Mon, 17 Jun 2013 09:04:31 +0200
Message-ID: <51BEB4FF.9000607@acm.org>
References: <51B87501.4070005@acm.org> <51B8777B.5050201@acm.org> <51BA20ED.6040200@mellanox.com> <51BB1857.7040802@acm.org> <51BB5A04.3080901@mellanox.com> <51BC3945.9030900@acm.org> <51BEAA40.9070908@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:34276 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3FQHEg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jun 2013 03:04:36 -0400
In-Reply-To: <51BEAA40.9070908@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Vu Pham <vuhuong@mellanox.com>, Roland Dreier <roland@kernel.org>, David Dillow <dillowda@ornl.gov>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

On 06/17/13 08:18, Hannes Reinecke wrote:
> On 06/15/2013 11:52 AM, Bart Van Assche wrote:
>> On 06/14/13 19:59, Vu Pham wrote:
>>>> On 06/13/13 21:43, Vu Pham wrote:
>>>>>> +/**
>>>>>> + * srp_tmo_valid() - check timeout combination validity
>>>>>> + *
>>>>>> + * If no fast I/O fail timeout has been configured then the
>>>>>> device
>>>>>> loss timeout
>>>>>> + * must be below SCSI_DEVICE_BLOCK_MAX_TIMEOUT. If a fast I/O
>>>>>> fail
>>>>>> timeout has
>>>>>> + * been configured then it must be below the device loss timeout.
>>>>>> + */
>>>>>> +int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo)
>>>>>> +{
>>>>>> +    return (fast_io_fail_tmo < 0 && 1 <= dev_loss_tmo &&
>>>>>> +        dev_loss_tmo <= SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
>>>>>> +        || (0 <= fast_io_fail_tmo &&
>>>>>> +            (dev_loss_tmo < 0 ||
>>>>>> +             (fast_io_fail_tmo < dev_loss_tmo &&
>>>>>> +              dev_loss_tmo < LONG_MAX / HZ))) ? 0 : -EINVAL;
>>>>>> +}
>>>>>> +EXPORT_SYMBOL_GPL(srp_tmo_valid);
>>>>> fast_io_fail_tmo is off, one cannot turn off dev_loss_tmo with
>>>>> negative value
>>>>> dev_loss_tmo is off, one cannot turn off fast_io_fail_tmo with
>>>>> negative value
>>>>
>>>> OK, will update the documentation such that it correctly refers to
>>>> "off" instead of a negative value and I will also mention that
>>>> dev_loss_tmo can now be disabled.
>>>>
>>> It's not only the documentation but also the code logic, you
>>> cannot turn
>>> dev_loss_tmo off if fast_io_fail_tmo already turned off and vice
>>> versa
>>> with the return statement above.
>>
>> Does this mean that you think it would be useful to disable both the
>> fast_io_fail and the dev_loss mechanisms, and hence rely on the user
>> to remove remote ports that have disappeared and on the SCSI command
>> timeout to detect path failures ? I'll start testing this to see
>> whether that combination does not trigger any adverse behavior.
>>
>>>>> If rport's state is already SRP_RPORT_BLOCKED, I don't think we
>>>>> need
>>>>> to do extra block with scsi_block_requests()
>>>>
>>>> Please keep in mind that srp_reconnect_rport() can be called from
>>>> two
>>>> different contexts: that function can not only be called from inside
>>>> the SRP transport layer but also from inside the SCSI error handler
>>>> (see also the srp_reset_device() modifications in a later patch in
>>>> this series). If this function is invoked from the context of the
>>>> SCSI
>>>> error handler the chance is high that the SCSI device will have
>>>> another state than SDEV_BLOCK. Hence the scsi_block_requests()
>>>> call in
>>>> this function.
>>> Yes, srp_reconnect_rport() can be called from two contexts;
>>> however, it
>>> deals with same rport & rport's state.
>>> I'm thinking something like this:
>>>
>>>      if (rport->state != SRP_RPORT_BLOCKED) {
>>>       scsi_block_requests(shost);
>>
>> Sorry but I'm afraid that that approach would still allow the user
>> to unblock one or more SCSI devices via sysfs during the
>> i->f->reconnect(rport) call, something we do not want.
>>
>>> I think that we can use only the pair
>>> scsi_block_requests()/scsi_unblock_requests() unless the advantage of
>>> multipathd recognizing the SDEV_BLOCK is noticeable.
>>
>> I think the advantage of multipathd recognizing the SDEV_BLOCK state
>> before the fast_io_fail_tmo timer has expired is important.
>> Multipathd does not queue I/O to paths that are in the SDEV_BLOCK
>> state so setting that state helps I/O to fail over more quickly,
>> especially for large values of fast_io_fail_tmo.
>>
> Sadly it doesn't work that way.
>
> SDEV_BLOCK will instruct multipath to not queue _new_ I/Os to the
> path, but there still will be I/O queued on that path.
> For these multipath _has_ to wait for I/O completion.
> And as it turns out, in most cases the application itself will wait
> for completion on these I/O before continue sending more I/O.
> So in effect multipath would queue new I/O to other paths, but won't
> _receive_ new I/O as the upper layers are still waiting for
> completion of the queued I/O.
>
> The only way to excite fast failover with multipathing is to set
> fast_io_fail to a _LOW_ value (eg 5 seconds), as this will terminate
> the outstanding I/Os.
>
> Large values of fast_io_fail will almost guarantee sluggish I/O
> failover.

Hello Hannes,

I agree that the value of fast_io_fail_tmo should be kept small. 
Although as you explained changing the SCSI device state into SDEV_BLOCK 
doesn't help for I/O that has already been queued on a failed path, I 
think it's still useful for I/O that is queued after the fast_io_fail 
timer has been started and before that timer has expired.

Bart.

