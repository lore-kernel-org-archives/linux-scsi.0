From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 12:12:43 -0400
Message-ID: <4469F9FB.7020807@garzik.org>
References: <4468B596.9090508@garzik.org>	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>	 <4469F2B2.703@garzik.org> <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2006-05-16 at 11:41 -0400, Jeff Garzik wrote:
>> I can't see a case _in libata operation_ where a set of circumstances 
>> arises that causes missed wakeups, can you elaborate?
> 
> This is scsi_eh_wakeup():
> 
> void scsi_eh_wakeup(struct Scsi_Host *shost)
> {
> 	if (shost->host_busy == shost->host_failed) {
> 		wake_up_process(shost->ehandler);
> 
> so if you try a wakeup with no failed commands and the host still busy,
> nothing happens.

Clearly.  And where in the code do you see that this condition will strike?

If we are talking about impossible runtime conditions, then the 
objection is academic.


>>> move the prototype out of scsi_priv.h ... it should only be used by
>>> transport classes, anyway.
>> We're talking about all ->eh_strategy_handler() users, which is a valid 
>> EH API for an LLDD to choose.  Granted libata is really the only one 
>> right now.
> 
> We're busy revoking the LLDD driver, so in future it will be transport
> classes only.
> 
>> Long term, ->eh_strategy_handler and transport classes are block layer 
>> not SCSI level anyway, so scsi_priv.h is clearly inappropriate.
> 
> That can be sorted out if someone actually gets around to moving error
> handling to the block level.  In the meantime, it's SCSI that we're
> discussing.

Its an API-which-only-libata-uses that we're discussing.  And because 
its moving to the block layer, its also a 
temporary-API-which-only-libata-uses.

	Jeff


