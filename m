From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] SCSI: implement scsi_eh_schedule()
Date: Sun, 02 Apr 2006 10:15:41 +0900
Message-ID: <442F25BD.8040000@gmail.com>
References: <20060401103857.GG13172@htj.dyndns.org> <442EDF1F.6000001@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <442EDF1F.6000001@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> [PATCH] SCSI: implement scsi_eh_schedule()
>>
>> This patch implements scsi_eh_schedule() which provides a way to
>> directly invoke SCSI EH from drivers which implement EH using
>> ->eh_strategy_handler.  Combined with scsi_eh_flush_done_q(), this
>> gives such drivers complete control over when and how to invoke EH and
>> handle failed commands.
>>
>> scsi_eh_schedule() can also be invoked without a scmd.  This is useful
>> for handling exception conditions occurring while no command is in
>> progress.  New Scsi_Host field host_eh_invoked is added for this.
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
> 
> Not so sure about this one:
> 
> 1) Rather than creating the scmd==NULL special case path, just create a 
> new function scsi_kick_eh() or somesuch.  I presume such an 
> implementation would be quite tiny:  satisfy the condition 
> 'shost->host_busy == shost->host_failed', then call scsi_eh_wakeup().

I see.

> 2) Looks almost exactly like scsi_eh_scmd_add().  Minus the code deleted 
> via suggestion #1, you really just add a timer check.  Why not add a 
> SCSI EH flag which says "check timer", then just call scsi_eh_scmd_add()?

I didn't want to add stuff to SCSI main EH path which isn't necessary to 
main EH. But you're right, they are almost identical. Maybe a wrapper 
around scsi_eh_scmd_add() should work.

> 3) I would think that host_eh_invoked could be deduced.

Okay, I'll try to cook something prettier.

-- 
tejun
