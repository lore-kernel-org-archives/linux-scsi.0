From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Thu, 13 Apr 2006 14:32:14 +0900
Message-ID: <443DE25E.90905@gmail.com>
References: <443C642E.5090106@gmail.com> <20060412082442.49921.qmail@web31809.mail.mud.yahoo.com> <20060412161842.GA19787@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060412161842.GA19787@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Luben, Patrick.

Patrick Mansfield wrote:
> On Wed, Apr 12, 2006 at 01:24:42AM -0700, Luben Tuikov wrote:
>> --- Tejun Heo <htejun@gmail.com> wrote:
>>> Patrick Mansfield wrote:
>>>> On Tue, Apr 11, 2006 at 01:41:57PM -0400, Jeff Garzik wrote:
>>>>> Tejun Heo wrote:
> 
>>>>>> +int scsi_eh_schedule_cmd(struct scsi_cmnd *scmd)
> 
>>>> Per other email it should be called scsi_req_abort_cmd() or such, as that
>>>> is the only reason to call it, correct?
>>> Well, it's named this way is to keep it consistent with 
>>> scsi_eh_schedule_host().  Either name is okay with me but driver which 
>>> use this function probably have interest in schedule_host() but not in 
>>> other SCSI EH functions.  So, considering that, I think the current 
>>> naming is okay.
>> Tejun, note that scsi_req_abort_cmd() absolves your patch.
>> I think this is what Pat is trying to say.  I.e. it is much
>> more general and thus applies to more applications (as in uses).
>> Plus it is shorter, simpler (3 lines) and more straightforward.

Yeap, I kind of misunderstood Patrick's mail.  scsi_req_abort_cmd() is 
good but...

* The event is not really a timeout.  It shouldn't be logged as 
TIMEOUT_ERROR or completed with DID_TIME_OUT when add_scmd fails.

* Similarly, I don't think it's a good idea to call ->eh_timed_out() on 
explicit command abort.  If something common has to be done, it's better 
to make a function for that can calling the function from both 
->eh_timed_out() and after scsi_req_abort_cmd() succeeds.  Otherwise, 
libata has to decide whether ->eh_timed_out() is called from real 
timeout or explicit abortion and skip timeout processing for explicit 
abortions.

* I don't really understand what you mean by saying scsi_req_abort_cmd() 
is more generic.  If it means the WARN_ON(!->eh_strategy_handler) part. 
  That's just a safety net as standard SCSI doesn't know what to do with 
commands directly aborted by LLDD.  If it's something else, please 
elaborate.

> Both implementations work ... really I'd prefer a scsi_times_out() and
> scsi_abort_cmd() that call a __scsi_abort_cmd().

__scsi_abort_cmd() would just contain scmd_add, I think.

> If we implement them right, in the future those simple interfaces can stay
> the same even if we no longer have to invoke eh to abort a command.
> 
>> So, scsi_eh_reschedule_host() is equivalent to simply scsi_req_abort_cmd(cmd)
>> xor scsi_req_dev_reset(dev), the latter in case you want to notify without
>> piggybacking on a command.

Can you please post the patch for scsi_req_dev_reset()?  One thing to 
note is that libata might not have sdev to call that function with when 
it wants to invoke EH for hotplug.

>> Also, your routine calls more specific eh routines and you should try
>> to be more general.

Please, elaborate.

>>>> Any other handling can be completed by calling the ->done function.
>>>>
>>>> Even the abort/cancel could be done in the driver without this, I assume
>>>> it is avaiable so the driver can use the eh process and existing code
>>>> paths rather than duplicate similar code.
>>> Yeap, as I noted earlier, passing scmds to EH is possible without this 
>>> function but it has to be done in a quite hackish way.  My earlier 
> 
> I didn't mean pass them to eh, I mean the driver or transport could have
> its own work queue (or not ... we don't need a work queue or process
> context to send commands, scsi core sends commands without a work queue or
> process context), and issue the abort. Then on completion set error to
> DID_TIME_OUT (or whatever makes sense) and call the ->done function.
> 
> We should move towards driver/transport supplied eh, that is invoked by
> the driver/transport specific code, not (possibly) by a single timeout. I
> thought this was the direction everyone wanted to go.

I think it's good have some infrastructure in SCSI.  e.g. libata can do 
everything itself but it's just nice to have SCSI EH infrastructure to 
build upon (EH thread, scmd draining & plugging...).

Thanks.

-- 
tejun
