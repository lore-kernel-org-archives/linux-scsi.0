From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Mon, 28 Apr 2003 15:12:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EAD7D0E.7080407@rogers.com>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl> <20030426151356.A8697@one-eyed-alien.net> <1051397024.4089.86.camel@mulgrave> <20030426183428.B8697@one-eyed-alien.net> <1051409717.4089.146.camel@mulgrave> <20030427023517.A15212@one-eyed-alien.net> <1051458107.2427.25.camel@fuzzy> <20030427125237.A23693@one-eyed-alien.net> <3EAD7B86.8060300@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-mail.bloor.is.net.cable.rogers.com ([66.185.86.71]:42052
	"EHLO fep01-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S261244AbTD1TAC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2003 15:00:02 -0400
In-Reply-To: <3EAD7B86.8060300@rogers.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, James Bottomley <James.Bottomley@steeleye.com>, Andries.Brouwer@cwi.nl, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net

Luben Tuikov wrote:
> 
> Matt,
> 
> You cannot really constrict yourself to the CDB only.
> 
> As a transport/interconnect (what a LLDD is, as well as USB Storage)
> you get an Execute Command remote procedure call, in SCSI Core this
> is represented by struct scsi_cmnd.
> 
> Execute Command rpc contains all that the transport/ic needs in order
> to deliver the command to the device server (who will execute the
> CDB) and perform (the interconnect) the data transfer.
> 
> The reference you want to take a peek at is SAM-3r6, 5.1 --
> this is what USB storage is working with, not just the CDB.
> 
> Now, you've been talking about the Data-Out buffer size.

Corr: Data-In

> This is either ALLOCATION LENGTH (normally bytes), or
> TRANFER LENGTH (READ/WRITE, normally blocks).
> 
> The reference here is SPC3r12, 4.3.4.4 Transfer Length and
> 4.3.4.6 Allocation Length.
> 
> Please note that Data-Out buffer size *is* the

Corr: Data-In

> Expected (maxumum) Data Tranfer Length, the device
> server may tranfer less data, (request_bufflen, bufflen).
> This is what the standards specify, and what SCSI Core
> sets it to.  The actual memory buffer may be bigger.
> The device server may transfer less data, but not more.
> The device server will NOT modify the returned data
> to reflect the insufficient data-in buffer.
> 
> So to repeat what the standards say and what SCSI Core
> does: sr_bufflen, request_buflen, buflen *is* the
> Expected (maxumum) Data Tranfer Length:
>     - when it means Allocation Length it is the
> maximum available space (e.g. IQUIRY, Request Sense),
> (The transport CANNOT write more data than this!)
>     - when it means Transfer Length it is the
> Expected Data Transfer Length (READ/WRITE), and I say
> ``expected'' less any End Of Media or similar errors pop up,
> (i.e. number of blocks from CDB * block_size = this value).
> 
> I.e. the _actual_ buffer size *is* IRRELEVANT to LLDD and
> the Transport/IC -- since it maybe an offset to another yet
> bigger buffer and SCSI Core/Appl. Client maybe requesting
> part of some data (see SAM-3r6, 5.4.3).
> 
> Some transports provide an Overflow and Underflow bits in
> the transport protocol to let the Initiator port (LLDD)
> know about any residuals -- SCSI Core struct scsi_cmnd supports
> only an underflow residual (bytes that were not transferred out
> of the number of bytes that were expected to be transferred).
> 
> I don't know much about USB Storage, but what do you think
> about this: add an unsigned overflow_resid to struct scsi_cmnd,
> and set it to an applicable value when a USB storage device
> provided more data to be transferred, but the buffer was too small.
> (I can see how this will not work, if you need a large enough ptr
> to just write the data to...)
> 

-- 
Luben


