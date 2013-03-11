From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] [SCSI] Wake blockdev queue in scsi_internal_device_unblock()
 for SDEV_RUNNING
Date: Mon, 11 Mar 2013 11:21:47 -0700
Message-ID: <CAG4TOxMv28sN4pQWz_DCrmEx2dyuLEk3oYM-98ZK44Van7JkAw@mail.gmail.com>
References: <1361814905-7201-1-git-send-email-roland@kernel.org> <513E1DB5.8040404@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:56293 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3CKSWJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Mar 2013 14:22:09 -0400
Received: by mail-we0-f177.google.com with SMTP id d7so3807062wer.36
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 11:22:07 -0700 (PDT)
In-Reply-To: <513E1DB5.8040404@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Mar 11, 2013 at 11:08 AM, Mike Christie <michaelc@cs.wisc.edu> wrote:
>> If at the same time a SAS fabric event goes to the HBA, what can
>> happen is the following:
>>
>>      - mpt2sas calls _scsih_block_io_all_device() -> scsi_internal_device_block(sdev)
>>
>>        (In response to some HBA firmware event like MPI2_EVENT_SAS_BROADCAST_PRIMITIVE)
>>        Now sdev state is SDEV_BLOCK and blockdev queue has QUEUE_FLAG_STOPPED set.
>>
>>      - Someone like scsi_add_lun() calls scsi_device_set_state(sdev, SDEV_RUNNING)
>>
>>        (SCSI bus scanning runs asynchronously to firmware event handling)
>>        Now sdev state is SDEV_RUNNING but blockdev queue still has QUEUE_FLAG_STOPPED set
>
> Is this a valid state change? Should it be failed in
> scsi_device_set_state when we try to go from SDEV_BLOCKED ->
> SDEV_RUNNING? I am not sure if it make senses to ever have a device in
> SDEV_RUNNING but have the stopped queue bit set.
>
> It used to be that scsi_internal_device_unblock called
> scsi_device_set_state so the transition from SDEV_BLOCKED to
> SDEV_RUNNUNG had to be a valid transition. scsi_internal_device_unblock
> then started the queue. I am not sure if the sequence you were hitting
> was actually a transition that was intended or just worked by accident.
>
> Should we be failing the above call to scsi_device_set_state, and then
> the call to scsi_internal_device_unblock would work as expected.

Dunno ... I was a bit scared to go too deep into this sdev_state
stuff, since it looks very old and fragile.  With that said the big
question to me is who really owns the state -- is it the low-level
driver or the midlayer?  I don't quite understand what it means for
the midlayer to try and start a device if the low-level driver has
temporarily paused things.  However since we have the blockdev queue
stopped state also, it seems to make things work out OK.

 - R.
