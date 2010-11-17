From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: remove unlock+relock cycle in ata_scsi_queuecmd
Date: Wed, 17 Nov 2010 10:11:19 -0500
Message-ID: <4CE3F097.6040202@garzik.org>
References: <20101117062958.GA2894@havoc.gtf.org> <AANLkTikQysiwSV_m38vKaEuPQ=NH10o2s69d=aNGOhLr@mail.gmail.com> <4CE38D70.4010507@garzik.org> <4CE3A7E9.3010009@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4CE3A7E9.3010009@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/17/2010 05:01 AM, Tejun Heo wrote:
> Hello, Jeff, Linus.
>
> On 11/17/2010 09:08 AM, Jeff Garzik wrote:
>> Looking solely at the SCSI code (ie. ignoring LLD code), it seems
>> like the magic number zero for serial_number is signaling a boolean
>> condition "are we an EH command?"
>>
>> EH tests this at the very beginning of the abort/reset/explode error
>> handling sequence, presumably to avoid recursive EH invocations
>> (scsi_try_to_abort_cmd).
>>
>> So maybe an EH expert (Tejun?) can correct me here, but I think we
>> may be able to completely the lock/get-serial/unlock sequence from
>> libata, as long as scsi_init_cmd_errh() reliably sets an "I am an EH
>> command" flag.
>>
>> Would be nice if true...
>
> Yeah, it's actually nice (for once).  libata doesn't use or care about
> scmd->serial_number at all.  The SCSI EH path you mentioned above is
> not applicable as libata implements its eh_strategy_handler and SCSI
> only calls scsi_try_to_abort_cmd() for the default EH handler,
> scsi_unjam_host().
>
> We'll need to test a bit to make sure everything is okay but I'm
> fairly certain removing it won't break anything fundamental.  If
> something breaks at all, it would be some silly easy-to-fix thing.

It would be surprising if there is breakage, because serial_number is 
only tested in two places in the generic kernel:

scsi_cmd_get_serial() -- where it simply avoids the zero value -- and 
scsi_try_to_abort_cmd().

	Jeff


