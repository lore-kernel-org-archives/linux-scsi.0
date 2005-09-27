From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Subject: RE: [2.4.21] Spurious ABORTs
Date: Tue, 27 Sep 2005 13:10:04 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CD1DF@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:45769 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965019AbVI0RKc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2005 13:10:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'Christoph Hellwig' <hch@infradead.org>, "'hch@lst.de'" <hch@lst.de>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>


>> >On Tue, 2005-09-27 at 12:18 -0400, Bagalkote, Sreenivas wrote:
>> >> When I return SUCCESS to the spurious ABORTs, the systems keeps 
>> >> running. I am getting aborts for commands that I completed
>> >as early as
>> >> 60+ seconds ago. Could somebody please tell me what in SCSI
>> >layer can
>> >> cause it to do this?
>> >
>> >Well, 2.4 is somewhat more eccentric than 2.6 as far as SCSI goes.
>> >However, I can guess about this one.  If a command is 
>completed after 
>> >it times out, you still get error handling for it (this is actually 
>> >still true in 2.6).  When the system becomes aware of a need for 
>> >error handling it quiesces the driver (i.e. waits for all 
>outstanding 
>> >commands to time out or
>> >return) before beginning the eh thread.  So, if a bunch of commands 
>> >are failing, you can complete one that has already timed out and 
>> >still receive an ABORT for it ages afterwards.
>> >
>> >James
>> 
>> Thanks. But 60 seconds after the completion?! In any case, I don't 
>> have
>
>the sd timeout is 30s; I can certainly construct theoretical 
>situations where you'd not get an abort until 60s after 
>completion, yes.
>
>> an abort handler in my release driver. Only reset handler. If I see 
>> that I don't have any pending commands with me, I simply return 
>> SUCCESS from the reset handler. Is this the correct way of 
>doing this? 
>> (Returning FAILED would cause the controller to be marked offline).
>
>As long as you actually do a reset, yes.  The mid-layer's next 

What do you mean by "actually do a reset"? I see that firmware doesn't
have any pending commands. So I simply return success from reset routine.
Do you see any problem in this? After a hundred or so such cycles, the 
system is frozen. I should also tell you that if I introduce abort handler
and return success for all the completed commands, I don't see the OS hang.

