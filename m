From: Vu Pham <vuhuong@mellanox.com>
Subject: Re: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Tue, 18 Jun 2013 09:59:46 -0700
Message-ID: <51C09202.2040503@mellanox.com>
References: <51B87501.4070005@acm.org> <51B8777B.5050201@acm.org> <51BA20ED.6040200@mellanox.com> <51BB1857.7040802@acm.org> <51BB5A04.3080901@mellanox.com> <51BC3945.9030900@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:36198 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932860Ab3FRRAt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jun 2013 13:00:49 -0400
In-Reply-To: <51BC3945.9030900@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@kernel.org>, David Dillow <dillowda@ornl.gov>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

Bart Van Assche wrote:
> On 06/14/13 19:59, Vu Pham wrote:
>>> On 06/13/13 21:43, Vu Pham wrote:
>>>>> +/**
>>>>> + * srp_tmo_valid() - check timeout combination validity
>>>>> + *
>>>>> + * If no fast I/O fail timeout has been configured then the device
>>>>> loss timeout
>>>>> + * must be below SCSI_DEVICE_BLOCK_MAX_TIMEOUT. If a fast I/O fail
>>>>> timeout has
>>>>> + * been configured then it must be below the device loss timeout.
>>>>> + */
>>>>> +int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo)
>>>>> +{
>>>>> +    return (fast_io_fail_tmo < 0 && 1 <= dev_loss_tmo &&
>>>>> +        dev_loss_tmo <= SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
>>>>> +        || (0 <= fast_io_fail_tmo &&
>>>>> +            (dev_loss_tmo < 0 ||
>>>>> +             (fast_io_fail_tmo < dev_loss_tmo &&
>>>>> +              dev_loss_tmo < LONG_MAX / HZ))) ? 0 : -EINVAL;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(srp_tmo_valid);
>>>> fast_io_fail_tmo is off, one cannot turn off dev_loss_tmo with
>>>> negative value
>>>> dev_loss_tmo is off, one cannot turn off fast_io_fail_tmo with
>>>> negative value
>>>
>>> OK, will update the documentation such that it correctly refers to
>>> "off" instead of a negative value and I will also mention that
>>> dev_loss_tmo can now be disabled.
>>>
>> It's not only the documentation but also the code logic, you cannot turn
>> dev_loss_tmo off if fast_io_fail_tmo already turned off and vice versa
>> with the return statement above.
>
> Does this mean that you think it would be useful to disable both the 
> fast_io_fail and the dev_loss mechanisms, and hence rely on the user 
> to remove remote ports that have disappeared and on the SCSI command 
> timeout to detect path failures ?
Yes.

> I'll start testing this to see whether that combination does not 
> trigger any adverse behavior.
>

Ok

>>>> If rport's state is already SRP_RPORT_BLOCKED, I don't think we need
>>>> to do extra block with scsi_block_requests()
>>>
>>> Please keep in mind that srp_reconnect_rport() can be called from two
>>> different contexts: that function can not only be called from inside
>>> the SRP transport layer but also from inside the SCSI error handler
>>> (see also the srp_reset_device() modifications in a later patch in
>>> this series). If this function is invoked from the context of the SCSI
>>> error handler the chance is high that the SCSI device will have
>>> another state than SDEV_BLOCK. Hence the scsi_block_requests() call in
>>> this function.
>> Yes, srp_reconnect_rport() can be called from two contexts; however, it
>> deals with same rport & rport's state.
>> I'm thinking something like this:
>>
>>     if (rport->state != SRP_RPORT_BLOCKED) {
>>      scsi_block_requests(shost);
>
> Sorry but I'm afraid that that approach would still allow the user to 
> unblock one or more SCSI devices via sysfs during the 
> i->f->reconnect(rport) call, something we do not want.
>
I don't think that user can unblock scsi device(s) via sysfs if you use 
scsi_block_requests(shost) in srp_start_tl_fail_timers().

-vu

>> I think that we can use only the pair
>> scsi_block_requests()/scsi_unblock_requests() unless the advantage of
>> multipathd recognizing the SDEV_BLOCK is noticeable.
>
> I think the advantage of multipathd recognizing the SDEV_BLOCK state 
> before the fast_io_fail_tmo timer has expired is important. Multipathd 
> does not queue I/O to paths that are in the SDEV_BLOCK state so 
> setting that state helps I/O to fail over more quickly, especially for 
> large values of fast_io_fail_tmo.
>
> Hope this helps,
>
> Bart.

