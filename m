From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 3/3] tgt: fix scsi command leak
Date: Mon, 05 Mar 2007 10:36:15 -0500
Message-ID: <45EC38EF.6000603@torque.net>
References: <20070303001750H.fujita.tomonori@lab.ntt.co.jp>	<45E9A92B.5040507@torque.net> <20070305143222H.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52954 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933524AbXCEPhI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Mar 2007 10:37:08 -0500
In-Reply-To: <20070305143222H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> From: Douglas Gilbert <dougg@torque.net>
> Subject: Re: [PATCH 3/3] tgt: fix scsi command leak
> Date: Sat, 03 Mar 2007 11:58:19 -0500
> 
>> FUJITA Tomonori wrote:
>>> The failure to map user-space pages leads to scsi command leak. It can
>>> happens mostly because of user-space daemon bugs (or OOM). This patch
>>> makes tgt just notify a LLD of the failure with sense when
>>> blk_rq_map_user() fails.
>>>
>>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>>> ---
>>>  drivers/scsi/scsi_tgt_lib.c |   23 ++++++++++++++++++++---
>>>  1 files changed, 20 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
>>> index dc8781a..c05dff9 100644
>>> --- a/drivers/scsi/scsi_tgt_lib.c
>>> +++ b/drivers/scsi/scsi_tgt_lib.c
>>> @@ -459,6 +459,16 @@ static struct request *tgt_cmd_hash_look
>>>  	return rq;
>>>  }
>>>  
>>> +static void scsi_tgt_build_sense(unsigned char *sense_buffer, unsigned char key,
>>> +				 unsigned char asc, unsigned char asq)
>>> +{
>>> +	sense_buffer[0] = 0x70;
>>> +	sense_buffer[2] = key;
>>> +	sense_buffer[7] = 0xa;
>>> +	sense_buffer[12] = asc;
>>> +	sense_buffer[13] = asq;
>>> +}
>>> +
>> Tomo,
>> Perhaps you could add a memset(sense_buffer, 0, 18) before
>> those assignments and state that this is "fixed" sense
>> buffer format.
> 
> I think that it isn't necessary because when a target mode driver
> allocates scsi_cmnd, scsi_host_get_command() does that.
> 
> 
>> What about an option for descriptor sense format? With SAT now
>> a standard, we now have one more reason to support
>> descriptor format when required. The ATA PASS-THROUGH SCSI
>> commands in SAT use descriptor sense format to return
>> ATA registers.
> 
> tgt's kernel-space code doesn't know anything about SCSI devices that
> initiators talks to. So it's difficult to send proper sense buffer.
> Nomally, we don't have this problem because tgt user-space code builds
> sense buffer.
> 
> The bug that we are trying to fix is that the scsi command leak due to
> the user-space's bugs. So we can't rely on the user-space for this.
> 
> Not that, like open-iscsi, the user-space bugs are pretty critical for
> tgt as the kernel-space bugs. We don't think target mode drivers can
> continue to work. However, tgt should tell target mode drivers that
> unrecoverable problems happen and we should cleanly unload the kernel
> modules.

Tomo,
If I understand correctly, there is a target SCSI command
interpreter in a user space daemon (plus lu support) and the
target transport end point in kernel space (roughly speaking).
So if there is some problem in the kernel module, or
the user space daemon goes away (or won't respond) then what
you have is a transport error at the target end.

The error should be lower level than SCSI commands (i.e.
transport level). The kernel module doesn't know the state
of target SCSI command interpreter (by design). For example
the application client may have set the D_SENSE bit in the
control mode page prior to the failure that your code is
addressing. So the application client won't be expecting
fixed sense data format thereafter.

So what the code is doing is definitely better than nothing,
but IMO it isn't quite right either.

Doug Gilbert
