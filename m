From: Bleh <luben@splentec.com>
Subject: [Fwd: block TCQ [was: Re: Degraded I/O performance, since 2.5.41]]
Date: Thu, 17 Oct 2002 16:52:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DAF22F7.36A79210@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

Doug,

That is, what I meant, is that you are right:
the block layer should NOT set the tags, this is
the job of the SCSI Initiator port (SCSI LLDD)
since the tags are closely tied with the interconnect.

That is, setting the tags in the block layer in Linux
should be rethought.

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
