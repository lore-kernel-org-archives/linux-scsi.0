From: Alan Stern <stern@rowland.harvard.edu>
Subject: Is it safe to do DMA directly into scmd->sense_buffer?
Date: Sun, 22 Jun 2003 12:09:52 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0306221200050.434-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:42252 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S264505AbTFVPzr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2003 11:55:47 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

When retrieving sense data for a failed command, is it safe to transfer
the data by DMA directly into scmd->sense_buffer?  My guess is that on
architectures that have non-cache-coherent DMA, it's _not_.

The reason is that there is no guarantee the SCSI core won't touch the
scmd structure while the I/O is taking place.  For instance, should the
abort timer expire, the error-handler thread might very well end up
reading or writing data falling in the same cache line as the
sense_buffer.  That would corrupt the CPU's view of data transferred from
the device.

But maybe there's some provision for taking care of this I'm not aware of.  
If anyone can supply the correct answer, my sense-bounce-buffer and I
would appreciate it.

Alan Stern

