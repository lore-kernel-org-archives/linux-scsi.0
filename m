From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 01 Sep 2005 14:44:00 +0900
Message-ID: <43169520.6040008@gmail.com>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050901043850.15186.qmail@web51611.mail.yahoo.com>
Sender: linux-ide-owner@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Albert Lee <albertcc@tw.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org


  Hello, Luben.

Luben Tuikov wrote:
> --- Tejun Heo <htejun@gmail.com> wrote:
> 
>> As implementing autosensing will probably need rewriting failed qc
>>for REQUEST SENSE command, I'm opposing it.  My proposal is to do the
>>following, which, in effect, should be equivalent to autosensing.
>>
>> 1. ATAPI CHECK SENSE occurs
>> 2. libata fails the command
>> 3. SCSI sees failure code but no sense data, SCSI EH invoked
>> 4. libata EH invoked
>> 5. REQUEST SENSE
>> 6. sense data acquired
>> 7. scsi_decide_disposition() called (this needs to be exported from SCSI)
>> 8. libata handles the failed qc according to the verdict.
> 
> 
> Hmm, yes.  It sounds good, except can you make it so that step 3
> doesn't exist, ever.  This means that you would _reduce_ the
> double "bouncing" between eh's _and_ implement autosense.
> 

  libata EH is invoked from SCSI EH via hostt->eh_strategy_handler(), so 
they're one - libata EH uses SCSH EH framework to operate.  I'm having 
hard time understanding what you mean by 'double bounncing'.

> SCSI Core should never know what happened.  I.e. if the command
> has completed with CHECK SENSE, sense data _is_ present => "autosense".
> 
> 
>>This is very similar to what SCSI EH currently does for commands
>>without sense data.
> 
> 
> Yes, you're right -- it is very similar to what SCSI EH currently does.
> Unfortunately it isn't quite correct.
> 

  Can you please elaborate why getting sense data from EH is bad idea 
for ATAPI?  For more advanced SCSI transports, I agree with you that 
autosensing is necessary with queueing and multiple initiator and etc, 
but I don't really see how requesting sense from EH would be bad for ATAPI.

> 
>> As ATAPI device's queue depth is always one (ignoring SERVICE cruft
>>everyone seems to hate), I don't think there will be any noticeable
>>performance penalty as James was describing in the other mail in this
>>thread.
> 
> 
> What you can do is keep a qc around to request sense immediately
> afterwards.  If _that_ qc fails, then you know you need the big hammer.

  Yes, that is also a possibility, but I was opting for REQUEST SENSE 
from EH for the following two reasons.

  a. As we're gonna have facilities to issue EH cmds from EH, ATAPI can 
just join the crowd without implementing separate mechanism to issue 
REQUEST SENSE.

  b. It's not a hot path and I think performance gain from implementing 
autosense would be negligible.

  Thanks.

-- 
tejun
