From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Is it safe to do DMA directly into scmd->sense_buffer?
Date: 22 Jun 2003 12:06:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056301585.1979.58.camel@mulgrave>
References: <Pine.LNX.4.44L0.0306221200050.434-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:7991 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264825AbTFVQwx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2003 12:52:53 -0400
In-Reply-To: <Pine.LNX.4.44L0.0306221200050.434-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 2003-06-22 at 11:09, Alan Stern wrote:
> When retrieving sense data for a failed command, is it safe to transfer
> the data by DMA directly into scmd->sense_buffer?  My guess is that on
> architectures that have non-cache-coherent DMA, it's _not_.
> 
> The reason is that there is no guarantee the SCSI core won't touch the
> scmd structure while the I/O is taking place.  For instance, should the
> abort timer expire, the error-handler thread might very well end up
> reading or writing data falling in the same cache line as the
> sense_buffer.  That would corrupt the CPU's view of data transferred from
> the device.
> 
> But maybe there's some provision for taking care of this I'm not aware of.  
> If anyone can supply the correct answer, my sense-bounce-buffer and I
> would appreciate it.

The answer's yes, it is safe.  This is how it works:

The only way you could get the scenario you describe is if the command
times out while the driver is doing an auto request sense.  This would
be highly unlikely, because usually either we lose the command or we get
sense back quickly (remember, the entire device suspends normal
operations on a contingent allegiance condition, so all it has to do is
service our sense request).

Now, even assuming the above happens, the only problem would be that the
sense data itself could be corrupted by an interfering cache line (since
the DMA direction is to the sense buffer, the current model holds that
you flush and invalidate the cache line before beginning the dma.  Thus,
if the CPU brings the cache line in again the only thing it may miss is
the fact that DMA has altered data it has cached).

This was argued about a long time ago, the upshot being that the pain of
doing it correctly was offset by the fact that it didn't seem to have
any observable consequences.

James


