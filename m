From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: requeuing a Scsi_Cmnd?
Date: Mon, 12 May 2003 20:20:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC03A69.1060302@pobox.com>
References: <3EBEB1D5.3040300@pobox.com> <1052750688.1769.27.camel@mulgrave> <3EBFE408.4010607@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:13492 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263011AbTEMAI0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 20:08:26 -0400
In-Reply-To: <3EBFE408.4010607@rogers.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> James Bottomley wrote:
> 
>> On Sun, 2003-05-11 at 15:25, Jeff Garzik wrote:
>>
>>> This question applies to 2.4 as well as 2.5 (I believe the strategies 
>>> are different for the two?)
>>>
>>> Suppose I am passed several Scsi_Cmnd structures via ->queuecommand. 
>>> TCQ depth is >1.  An event causes the entire queue to be aborted, but 
>>> I know that the majority of the queue was actually ok.  So, my LLD 
>>> would need to requeue and resend most of the recently-aborted 
>>> Scsi_Cmnds.
>>
>>
>>
>> You keep finding these unhandled condidions, sigh.  The correct thing to
>> do (since this is a situation identical to QErr set) is to return a
>> check condition to the failing command and to return a status of TASK
>> ABORTED for all the others (SPC3).  Of course, the SCSI-2 behaviour was
>> just to expect all tasks to be silently aborted on QErr=1.  Neither of
>> these, of course, is coded into the mid-layer.
> 
> 
> Iff TAS is set and if TST is 001, and there is more than one initiator
> whose task are being nuked, then this is correct.
> 
> Jeff didn't give much information, but it sounds like ABORT/CLEAR TASK SET.
> Anyway, no point in speculating.


I'm working on a SCSI low-level driver that drives SATA host 
controllers.  For ATAPI, it's mainly a passthru.  The headache comes in 
the translation of SCSI->ATA, and in the error handling.  The SCSI->ATA 
translator can be effectively considered a SCSI simulator (or at least 
that's how I look at it), so like iSCSI I'm creating a software target, 
and I want my target to be compliant to spec.  (Which spec, you ask? 
Well, initially SCSI-2, but long term James has convinced me SCSI-3)

So for my specific example, I'm passed a bunch of Scsi_Cmnds.  I queue 
them.  And then according to spec, an error on the active command will 
cause the entire queue to abort.  Clearly, I do not want to error-out 
the other probably-valid commands, only the specific one that caused the 
error.  So, the remaining ones need to be retried.

	Jeff


