From: Brian King <brking@us.ibm.com>
Subject: Re: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: Tue, 24 Aug 2004 17:04:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412BBB6B.4000701@us.ibm.com>
References: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org> <412A08D9.7020502@adaptec.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:26597 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S268413AbUHXWEi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 18:04:38 -0400
In-Reply-To: <412A08D9.7020502@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, "Mike R." <turbanator1@verizon.net>

Luben Tuikov wrote:
> Alan Stern wrote:
> 
>> The SCSI core doesn't react properly when it receives SK/ASC/ASCQ = x
>> 02/04/01 = Not Ready, Logical unit in process of becoming ready.
>>
>> The core is complex enough that I can't tell exactly what's wrong or how
>> it should be fixed.  That particular sense data combination is spotted in
>> two different places: scsi_lib.c:scsi_io_completion() and
>> scsi_error.c:scsi_check_sense().  It's not clear which one is causing the
>> problem -- maybe they both are.
>>
>> Anyway, the reaction in both routines is to requeue the request for
>> immediate retry.  Obviously that's the wrong thing to do.  The request
>> should be retried, yes, but only after a delay of, say, a second or 
>> so. (Presumably the queue should remain blocked during that time.)  
>> And this
>> should keep happening for up to maybe 30 seconds.
> 
> 
> If the queue is a _general_ SCSI queue on which _any_ kind of
> SCSI command can be queued to the LU/target (i.e. not necessarily
> medium access), then you must _not_ block it.  HOQ task attribute
> commands could be sent which may operate other components of the
> LU/target.
> 
> But you should block the IO (R/W) general queue, yes.  _A_ way
> to do this is to send START STOP UNIT (0x1B) with the IMMED
> bit set to 0.  When the command completes, you'll get status
> and set the device to active, unblock the IO queue, etc.

Is there any way you can reuse the 02/04/02 handling code in 
scsi_error.c? It could probably be generalized a bit to handle both.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

