From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: host_self_blocked question/bug?
Date: 25 Nov 2003 15:55:19 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069797320.1787.220.camel@mulgrave>
References: <3FC3CDCF.4030105@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:32007 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263221AbTKYVzd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 16:55:33 -0500
In-Reply-To: <3FC3CDCF.4030105@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-11-25 at 15:46, Brian King wrote:
> I am writing an HBA driver for 2.6 and found that when host_self_blocked 
> is true the error handler will still send Test Unit Ready. This seems 
> like a bug. I would like to be able to use scsi_block_requests to stop 
> anything from coming into queuecommand, as I may be running BIST on the 
> adapter, downloading microcode, etc. in which case I cannot accept any 
> commands. It seems to me like the solution might be to simply have 
> scsi_eh_tur return success in if host_self_blocked is true. Thoughts?

Not in isolation...what are you trying to do?

The original design was to allow short hiatuses when the HBA couldn't
accept I/O.  It doesn't work if there's I/O pending (unless the stop is
very short), because the SCSI timers are still ticking and error
recovery doesn't see this flag.

There has been talk of making this interface robust to pending commands
(halt the timers and freeze the error handler) for FC HBA's that take
ages to process loop events, but no work has been done on this---it's
quite a bit more work than simply not allowing the eh to emit TURs.

James


