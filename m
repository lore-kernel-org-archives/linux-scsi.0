From: Luben Tuikov <luben@splentec.com>
Subject: block TCQ [was: Re: Degraded I/O performance, since 2.5.41]
Date: Thu, 17 Oct 2002 01:52:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DAE5015.3EC5D5B0@splentec.com>
References: <haveblue@us.ibm.com> <3DA611DF.3000206@us.ibm.com> <200210110109.g9B19FJ14530@localhost.localdomain> <20021011015933.GC27073@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g9H5qLf06358
	for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2002 01:52:21 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Doug Ledford wrote:
> 
> As a side note, the generic block layer tagged queueing mechanism may not
> be suitable for a lot of SCSI drivers (I know it's not suitable for mine
> at all).  How many of the drivers in the scsi tree today keep a shared tag
> table between all devices on a host and how many of them have separate tag
> tables for each device?  Show of hands anyone?  Justin, what about the
> modern aic7xxx driver?  Gerard?
> 

Ok. SAM-3 specifies that the initiator assigns task tags (4.9.1).
Who is the initiator?

But, the Abort Task and Abort Task Set (and friends) task management
functions are requested by the application client.
Futhermore, 6.2 Abort Task uses an I_T_L_Q nexus, that is, a tagged task.
So, to cancel an untagged task, one would use the 6.3 Abort Task Set,
which would be consistent since there should be only one untagged task
per initiator.

What are the implications and can we model around this?

Checking up on the definitions, 3.1.4 application client and 3.1.93
the initiator is your driver and the application client is the
SCSI core/block layer/sg/whatever.

AFAIR, IDE happened to support some type of tagging and all of a sudden
TCQ was moved up to the block layer, since SCSI has had it all along.

While this is alright, SAM-3 suggests that TCQ _generation_ is performed
by the SCSI initiator port (i.e. the SCSI LLDD) and for valid reasons...
(again those have to do with the underlying transport/interconnect...)

Thus, the only thing which the block layer would need to know is
_if_ TCQ is supported, but genereration of tags should be left to the
SCSI LLDD.

-- 
Luben
