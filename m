From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [ANNOUNCE]: megaraid driver version 2.20.0.1
Date: Wed, 21 Jul 2004 09:48:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC89C@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:29112 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266327AbUGUNve (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2004 09:51:34 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

> The philosophy for scsi drivers for a while has been to 
> remove internal
> queueing, which is why yours attracted my attention, so the question I
> was asking is can you use these APIs instead of having to 
> maintain this
> internal queue?
The internal pending queue is fed not only from the mid-layer packets but
also the packets from the management module and (forthcoming) sysfs module.
Both of these modules rely on the fact that the commands issued by them
would be issued sooner or later.

In addition, in certain situations (logical drive deletion) driver has to
stop sending commands to the FW before these operations can be initiated.
This is also implemented using the pending queue mechanism. Although would
be minor change to move over to scsi_block_requests and scsi_unblock_request
to achieve this.

This is not to say that I am reluctant to implement SCSI_MLQUEUE_HOST_BUSY,
but just a precursor where additional impacts would be so that reviewers can
focus on those areas as well.

Thanks
-Atul Mukker
 
