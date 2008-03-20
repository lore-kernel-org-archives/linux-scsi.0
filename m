From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Subject: Re: aic94xx driver woes continued
Date: Thu, 20 Mar 2008 21:21:25 +0100
Message-ID: <47E2C745.9080707@ipax.at>
References: <47E2B044.70705@ipax.at>	 <1206039714.3038.40.camel@localhost.localdomain> <47E2B7EF.1050203@ipax.at> <1206043027.3038.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ipax.at ([80.64.143.40]:49294 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757407AbYCTUV3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 16:21:29 -0400
In-Reply-To: <1206043027.3038.48.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2008-03-20 at 20:15 +0100, Raoul Bhatia [IPAX] wrote:
>> James Bottomley wrote:
>>> This is all normal.  Seagate drives are known for throwing protocol
>>> errors under stress at certain revs of firmware.  That's what
>>> REQ_TASK_ABORT, reason=0x6 is.
>>>
>>> Your logs indicate that the recovery occurred correctly (as in all tasks
>>> were eventually retried), so it doesn't show an actual problem.
>> ok, i already filed a trouble ticket at seagate - lets see if they
>> provide a firmware update for the disks. afaik mine is "firmware 0002"
>>
>>>> sometimes even a disk is kicked out of the raid configuration.
>>> This would be abnormal, if you have a log of this, could you post it.  I
>>> assume it was because of I/O errors?
>> i attached a bigger syslog file (.gz format).
> 
> OK, this looks more definitive, thanks!
> 
> What appears to be happening is that you get a run of protocol errors,
> not necessarily all on the same command, but what happens every time (by
> current design of the aic94xx driver) is that we halt the aic94xx, abort
> all the outstanding commands and resubmit them.  Because the disk is
> being hammered, there are rather a lot, so all it takes is five protocol
> errors in a few seconds for one unlucky command to get aborted five
> times (not necessarily through any fault of its own) and run out of
> retries.  This causes it to return to the upper layers with DID_ABORT
> and be treated as an I/O error.
> 
> A work around might be to lower the queue depth to say 4 or 8 and up the
> retries (this latter can only be done by altering the SD_MAX_RETRIES
> parameter in include/scsi/sd.h and recompiling).
> 
> Longer term, I think REQ_TASK_ABORT needs to be handled better on the
> fly.  What we should do is abort only the task we've been asked to abort
> and return it to the upper layer for a retry without invoking the error
> handler ... I can look into this, but it will take a while.

thank you for your in-depth reply, we will try to play around with the
queue depth and the retries.

i will try to get back to you with some feedback!

cheers,
raoul
-- 
____________________________________________________________________
DI (FH) Raoul Bhatia M.Sc.          email.          r.bhatia@ipax.at
Technischer Leiter

IPAX - Aloy Bhatia Hava OEG         web.          http://www.ipax.at
Barawitzkagasse 10/2/2/11           email.            office@ipax.at
1190 Wien                           tel.               +43 1 3670030
FN 277995t HG Wien                  fax.            +43 1 3670030 15
____________________________________________________________________
