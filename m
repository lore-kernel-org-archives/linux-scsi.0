From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [ANNOUNCE]: megaraid driver version 2.20.0.1
Date: 21 Jul 2004 12:06:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1090429579.1951.13.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC89C@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:36525 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266545AbUGURGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2004 13:06:32 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC89C@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Wed, 2004-07-21 at 08:48, Mukker, Atul wrote:
> > The philosophy for scsi drivers for a while has been to 
> > remove internal
> > queueing, which is why yours attracted my attention, so the question I
> > was asking is can you use these APIs instead of having to 
> > maintain this
> > internal queue?
> The internal pending queue is fed not only from the mid-layer packets but
> also the packets from the management module and (forthcoming) sysfs module.
> Both of these modules rely on the fact that the commands issued by them
> would be issued sooner or later.

Hmm, well, in order to re-use the block layer queueing, you can wrap
these up into special requests and queue them as well.  The actual SCSI
implementation does do a head of queue add, so any request so queued is
the first to be pulled off again and executed

> In addition, in certain situations (logical drive deletion) driver has to
> stop sending commands to the FW before these operations can be initiated.
> This is also implemented using the pending queue mechanism. Although would
> be minor change to move over to scsi_block_requests and scsi_unblock_request
> to achieve this.
> 
> This is not to say that I am reluctant to implement SCSI_MLQUEUE_HOST_BUSY,
> but just a precursor where additional impacts would be so that reviewers can
> focus on those areas as well.

Well, OK, just do the changes to get rid of yield, and we can look at
fixing the queuing in tree.

James


