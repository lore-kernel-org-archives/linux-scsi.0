From: Luben Tuikov <luben@splentec.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 14:16:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D90ABEB.E540C8D1@splentec.com>
References: <200209241429.g8OET2r10804@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> 
> A better fix is probably to implement a flag to say whether the door should be
> locked or not.
> 

This would really depend on the command to be executed.
I.e. does the command need access to the media, or not.

> The whole lock door before a command goes down philosophy looks slightly wrong
> to me.  I can see we want to lock the door for a mounted device and other
> conditions, but locking the door just to send down a test unit ready or
> inquiry doesn't seem correct.

Well, SAM-3 is the place to check this out. For TUR (7.27) it would seem that
one does indeed need to lock the door/media into place in order to
be ``able to accept an appropriate medium-access command without returning
CHECK CONDITION status''.
 
> Door locking is very similar to reservation maintenance.  Perhaps adding
> kernel code to maintain certain persistent but fragile states of the device
> might be in order.

This is the job of the task manager for the LU, and if not implemented
by the LU, it should be implemented by the LLDD, which would complicate
things considerably for the LLDD.

As to your suggestion, there may be generic code, which LLDD may want to use,
but nevetheless, has to be no higher than the LLDD, and ideally in the LU itself.

The idea is that SCSI core should be quite minimal as I've been suggesting
for some time now.

-- 
Luben
