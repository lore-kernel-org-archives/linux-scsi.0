From: Brian King <brking@us.ibm.com>
Subject: Re: host_self_blocked question/bug?
Date: Tue, 25 Nov 2003 16:31:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC3D82D.2030604@us.ibm.com>
References: <3FC3CDCF.4030105@us.ibm.com> <1069797320.1787.220.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:14776 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263203AbTKYWbL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 17:31:11 -0500
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e4.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id hAPMVAh3842976
	for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2003 17:31:10 -0500
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay02.pok.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id hAPMV9je156530
	for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2003 17:31:09 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

James Bottomley wrote:
> The original design was to allow short hiatuses when the HBA couldn't
> accept I/O.  It doesn't work if there's I/O pending (unless the stop is
> very short), because the SCSI timers are still ticking and error
> recovery doesn't see this flag.
> 
> There has been talk of making this interface robust to pending commands
> (halt the timers and freeze the error handler) for FC HBA's that take
> ages to process loop events, but no work has been done on this---it's
> quite a bit more work than simply not allowing the eh to emit TURs.

I'd like a way to be able to stop the mid-layer from sending me any 
commands. The scenarios I have today are:

1. Fatal error on the adapter.
2. microcode download to the adapter.
3. Adapter cache recovery commands.

All of these cases require me to run BIST on the adapter and bring it 
back up. To do this may take 20-30 seconds. I call scsi_block_requests, 
fail all pending ops back with DID_ERROR, reset the adapter, then call 
scsi_unblock_requests. My usage of it gets around the ticking timer 
problem. I agree that the error recovery thread doesn't see this either 
and that this is a potential problem. I had planned to work around that 
by failing abort and device reset, forcing the host_reset to be called, 
which would wait on the completion of the adapter reset, but it would be 
nice if I didn't have to do that.



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

