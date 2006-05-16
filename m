From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 11:41:38 -0400
Message-ID: <4469F2B2.703@garzik.org>
References: <4468B596.9090508@garzik.org> <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:10882 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751271AbWEPPlm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 11:41:42 -0400
In-Reply-To: <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

(CC's restored)

James Bottomley wrote:
> 1) your host_eh_scheduled logic looks wrong.  It seems to me that you
> can miss the wakeup if the host is busy?  I also don't see a need to

I can't see a case _in libata operation_ where a set of circumstances 
arises that causes missed wakeups, can you elaborate?


> move the prototype out of scsi_priv.h ... it should only be used by
> transport classes, anyway.

We're talking about all ->eh_strategy_handler() users, which is a valid 
EH API for an LLDD to choose.  Granted libata is really the only one 
right now.

Long term, ->eh_strategy_handler and transport classes are block layer 
not SCSI level anyway, so scsi_priv.h is clearly inappropriate.


> 2) This scsi_req_abort_cmd() is fundamentally the wrong logic.
> Everything else is communicated back as a result code from the command
> in done().  This should be no different ... A status return of
> DID_FAILED which scsi_decide_disposition() always translates to FAILED
> would seem to do exactly what you want without all the overhead.

Inigo sez[1]:  I do not think "fundamentally wrong" means what you think 
it means.

You miss the fact that the timer may have already fired, in which 
completing a command gets you...... not a damned thing.  scsi_done() 
will simply return, if the timeout has fired.  This has always been an 
annoying problem to work around.

scsi_req_abort_cmd() may perhaps be misnamed, but it GUARANTEES a set of 
operations which libata EH wants.  Certainly, if we can guarantee this 
set of conditions another way, we are open to any alternate path.

	Jeff


[1] from one of my favorite movies.  search 
http://us.imdb.com/title/tt0093779/quotes for "INCONCEIVABLE"
