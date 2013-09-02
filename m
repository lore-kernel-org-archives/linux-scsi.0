From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Mon, 02 Sep 2013 18:38:30 +0200
Message-ID: <5224BF06.3000208@acm.org>
References: <1378105985-79686-1-git-send-email-hare@suse.de> <1378105985-79686-4-git-send-email-hare@suse.de> <52248882.7060109@acm.org> <52248E6C.2060105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:50074 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab3IBQif (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Sep 2013 12:38:35 -0400
In-Reply-To: <52248E6C.2060105@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>

On 09/02/13 15:11, Hannes Reinecke wrote:
> On 09/02/2013 02:45 PM, Bart Van Assche wrote:
>> On 09/02/13 09:12, Hannes Reinecke wrote:
>>> @@ -353,6 +354,8 @@ void scsi_put_command(struct scsi_cmnd *cmd)
>>>        list_del_init(&cmd->list);
>>>        spin_unlock_irqrestore(&cmd->device->list_lock, flags);
>>>
>>> +    cancel_delayed_work(&cmd->abort_work);
>>> +
>>>        __scsi_put_command(cmd->device->host, cmd, &sdev->sdev_gendev);
>>>    }
>>>    EXPORT_SYMBOL(scsi_put_command);
>>
>> Is this approach safe ? Is it e.g. possible that the abort work
>> starts just before the cancel_delayed_work() call and continues to
>> run after scsi_put_command() has finished ? In
>> drivers/scsi/libfc/fc_exch.c a similar issue is solved by holding an
>> additional reference as long as delayed work (fc_exch.timeout_work)
>> is queued.
>>
> I have been thinking of this, and in fact my original approach had
> 'cancel_delayed_work_sync' here. However, this didn't work as
> scsi_put_command() might end up being called from an softirq context.
>
>>From my understanding the workqueue stuff guarantees that either
> a) the workqueue item is still queued
>     -> cancel_delayed_work will be in fact synchronous, as it'll
>        cancel queue item from the queue
> b) the workqueue item is running
>     -> cancel_delayed_work is essentially a no-op, as the function
>        is running and will be terminated anyway.
>
> IE from the API perspective the transition between 'queued' and
> 'running' is atomic, and no in-between states are visible.
>
> So case a) is obviously safe, and for case b) the abort function is
> already running. But then the abort function has been called from
> the block timeout handler, which did a blk_mark_rq_complete() prior
> to calling the handler. So any completion coming in after that will
> be ignored, and scsi_put_command() won't be called.
>
> Hence we should be safe here.

Hello Hannes,

I think that you have just explained why that cancel_delayed_work() call 
in scsi_put_command() is not necessary at all ... In case of normal 
command completion, scsi_put_command() will be reached with no 
scmd_eh_abort_handler() call queued since there was no timeout. If the 
command timed out scsi_put_command() will be called after the abort_work 
has already been dequeued since work items are dequeued before being 
executed.

Bart.

