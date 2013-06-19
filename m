From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Wed, 19 Jun 2013 15:00:38 +0200
Message-ID: <51C1AB76.2020200@acm.org>
References: <51B87501.4070005@acm.org> <51B8777B.5050201@acm.org> <51BA20ED.6040200@mellanox.com> <51BB1857.7040802@acm.org> <51BB5A04.3080901@mellanox.com> <51BC3945.9030900@acm.org> <51C09202.2040503@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C09202.2040503-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 06/18/13 18:59, Vu Pham wrote:
> Bart Van Assche wrote:
>> On 06/14/13 19:59, Vu Pham wrote:
>>>> On 06/13/13 21:43, Vu Pham wrote:
>>>>> If rport's state is already SRP_RPORT_BLOCKED, I don't think we need
>>>>> to do extra block with scsi_block_requests()
>>>>
>>>> Please keep in mind that srp_reconnect_rport() can be called from two
>>>> different contexts: that function can not only be called from inside
>>>> the SRP transport layer but also from inside the SCSI error handler
>>>> (see also the srp_reset_device() modifications in a later patch in
>>>> this series). If this function is invoked from the context of the SCSI
>>>> error handler the chance is high that the SCSI device will have
>>>> another state than SDEV_BLOCK. Hence the scsi_block_requests() call in
>>>> this function.
>>> Yes, srp_reconnect_rport() can be called from two contexts; however, it
>>> deals with same rport & rport's state.
>>> I'm thinking something like this:
>>>
>>>     if (rport->state != SRP_RPORT_BLOCKED) {
>>>      scsi_block_requests(shost);
>>
>> Sorry but I'm afraid that that approach would still allow the user to
>> unblock one or more SCSI devices via sysfs during the
>> i->f->reconnect(rport) call, something we do not want.
>>
> I don't think that user can unblock scsi device(s) via sysfs if you use
> scsi_block_requests(shost) in srp_start_tl_fail_timers().

Hello Vu,

If scsi_block_requests() would be used in srp_start_tl_fail_timers() 
instead of scsi_target_block() then multipathd would no longer be able 
to notice that a path is blocked after the fast_io_fail and dev_loss 
timers started and hence wouldn't be able to use the optimization where 
blocked paths are skipped when queueing a new I/O request.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
