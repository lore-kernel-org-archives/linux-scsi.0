From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Check return value of fc_block_scsi_eh()
Date: Thu, 14 Oct 2010 14:02:47 -0500
Message-ID: <4CB753D7.6080608@cs.wisc.edu>
References: <20101013114228.96669354D8@ochil.suse.de> <4CB618A5.8030108@cs.wisc.edu> <4CB6A712.3090705@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34977 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab0JNS4O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2010 14:56:14 -0400
In-Reply-To: <4CB6A712.3090705@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On 10/14/2010 01:45 AM, Hannes Reinecke wrote:
> Mike Christie wrote:
>> On 10/13/2010 06:42 AM, Hannes Reinecke wrote:
>>>
>>> fc_block_scsi_eh() might return with status FAST_IO_FAIL
>>> indicating I/O has been terminated due to fast_io_fail timeout.
>>> In this case the rport is still blocked, so any error recovery
>>> will be failing on this port.
>>> Hence each driver needs to check if the return value from
>>> fc_block_scsi_eh() is something other than SUCCESS, in which
>>> case it should just return with that status.
>>> And we need to update the error handler to deal with a
>>> status of FAST_IO_FAIL, too.
>>> And fc_block_scsi_eh() should return SUCCESS on success,
>>> not 0. Otherwise the calling routine will become confused
>>> when reusing that value.
>>>
>>
>> Is this patch supposed to fix the problem I described or is there more
>> patches to follow or do you think I am being too paranoid? It seems the
>> patch alone is going to make the problem worse in the drivers you are
>> speeding up failure in. In the drivers now checking fc_block_scsi_eh and
>> returning when fast io fail is returned then the scsi eh
>> scsi_eh_flush_done_q's scsi_finish_command/scsi_queue_insert processing
>> is going to get done faster and more likely to conflict with the
>> termiante_rport_io callback processing, right?
>
> No, this patch does _not_ fix the race you've described, it just
> fixes the problem of fc_block_scsi_eh() returning FAST_IO_FAIL,
> which screws the error handler in drivers not checking the return value.
> So it's partially covered by your patchset.
>
> However, in your patchset you're missing two issues:
> - The current implementation of fc_block_scsi_eh() return '0' on
>    success. This screws over drivers which re-uses this value;
>    check eg. lpfc_abort_handler(). So we should be returning
>    'SUCCESS' here.

Yeah, my patchset is actually backwards. I converted the other drivers 
to check for 0 (forgot to fix lpfc though). I think your patch patch 
where we return SUCCESS is better than what I was doing.


> - scsi_error needs to be fixed up to handle FAST_IO_FAIL.
>    Any of the functions called from scsi_abort_eh_cmnd() can return
>    FAST_IO_FAIL, in which case escalating to the next function
>    becomes pointless.

There is a problem with fnic (it is also a bug in my patches). If fnic's 
terminate_rport_io fails to abort the cmds, it is relying on the scsi eh 
callouts to clean things up. So if fc_scsi_block_eh returns non-success 
then we cannot return immediately from the callout. The drivers scsi eh 
callout may still need to clean up the command internally.

iSCSI/qla4xxx also needs to be changed to return SUCCESS instead of 
zero. Luckily there is only one driver using it so far.

>
> I guess it would make sense to merge these two patchsets, either
> having two patchsets (one for the FAST_IO_FAIL changes and one for
> the rport race) or indeed merge them both into one.
> I'm okay with either of it.
>

My patches for the race do not work though. When you replied to my 
thread I thought you mean you were going to fix that too :)

I have been thinking of how to fix the race. I will make my patches over 
yours since your return SUCCESS fix is better.
