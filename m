From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: remove unlock+relock cycle in ata_scsi_queuecmd
Date: Wed, 17 Nov 2010 03:08:16 -0500
Message-ID: <4CE38D70.4010507@garzik.org>
References: <20101117062958.GA2894@havoc.gtf.org> <AANLkTikQysiwSV_m38vKaEuPQ=NH10o2s69d=aNGOhLr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <AANLkTikQysiwSV_m38vKaEuPQ=NH10o2s69d=aNGOhLr@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/17/2010 01:44 AM, Linus Torvalds wrote:
> On Tue, Nov 16, 2010 at 10:29 PM, Jeff Garzik<jeff@garzik.org>  wrote:
>>
>> +       spin_lock(shost->host_lock);
>> +       scsi_cmd_get_serial(shost, cmd);
>>         spin_unlock(shost->host_lock);
>
> This is just sad.
>
> How important is that serial number? So important that we need to do a
> spinlock over it here? And it _must_ be per-shost?

Quite unimportant.  Quoting James from 
http://marc.info/?l=linux-kernel&m=128949079704323&w=2
> There are only a few drivers left that actually make use of a serial
> number.  Of those, the only modern ones are qla4, lpfc, mpt2sas and
> megaraid.
>
> So the next logical step seems to be eliminate the overloading of the
> serial number zero value, which removes the last mid-layer use (dpt_i2o
> seems to abuse this unnecessarily as well), then the serial number code
> can be pushed down into the queuecommand routines of only those drivers
> that actually use it.  None of the modern ones seems to have a
> legitimate use, so I think their uses can mostly be eliminated.  Thus,
> we might be able to get away with a simple queuecommand push down and
> never bother with atomics for this (since it's unlikely the legacy users
> would convert away from a lock wrapping their queuecommand routines).


Looking solely at the SCSI code (ie. ignoring LLD code), it seems like 
the magic number zero for serial_number is signaling a boolean condition 
"are we an EH command?"

EH tests this at the very beginning of the abort/reset/explode error 
handling sequence, presumably to avoid recursive EH invocations 
(scsi_try_to_abort_cmd).

So maybe an EH expert (Tejun?) can correct me here, but I think we may 
be able to completely the lock/get-serial/unlock sequence from libata, 
as long as scsi_init_cmd_errh() reliably sets an "I am an EH command" flag.

Would be nice if true...

	Jeff


