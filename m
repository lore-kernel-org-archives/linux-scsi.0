From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: Wed, 29 Sep 2004 09:41:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096476093.10859.73.camel@praka>
References: <B179AE41C1147041AA1121F44614F0B0012AD92B@AVEXCH02.qlogic.org>
	 <20040928193614.GB192475@sgi.com> <1096401196.2008.97.camel@mulgrave>
	 <20040929003611.GK192475@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:13475 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S268714AbUI2QrT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 12:47:19 -0400
In-Reply-To: <20040929003611.GK192475@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-09-28 at 17:36, Jeremy Higdon wrote:
> So do we have a consensus on what the driver should limit queue
> depth to?  Currently, it's 32 or ql2xmaxqdepth, if that was specified.
> From what I can see, ql2xmaxqdepth is effectively limited to 65535.
> 
> We don't want one lun to use host driver or host adapter resources
> to the point that it starves other luns.  Ideally, the max would
> depend on what else was attached, but I don't think we want to
> make this too complicated.

I agree.

>   Anyone changing the queue depth should
> have a clue about what they're doing.
> 
> Andrew, how many command slots are there in the various adapters,
> and do the continuation entries each eat a command slot?
> 

Well, determining that can be complicated...

The request-queue size is based on the amount of SRAM available to the
ISP.   For most HBAs (qla2100, qla2200, qla2300, qla2310, qla2342) which
have an 128KB memory chip (per-port), the 8.x driver will allocate
2048-entry queue for requests.  

Many new(-er) boards (qla235x, qla236x) and embedded implementations
(fibre-down) have a 512KB or 1MB chip.  Not wanting to digress into
another layer of firmware resource-usage details, let's just say that
the extra memory allows for the firmware to manage a larger number of
requests.  The driver in these cases will allocate a 4096-entry
request-queue.

Now depending on the sizeof(dma_addr_t)
(qla2x00_config_dma_addressing()) a single (scsi_cmnd) command with 32
sg entries (assuming 4KB page size,  transferring 128KB of data) will
consume:

    sizeof(dma_addr_t) == 4 (32bit):

	 1	command IOCB (3 data segments)
	 5	continuation IOCBs (7 data segments per IOCB)
		- only one entry within the last continuation IOCB used
	--
	 6	request entries

and 

    sizeof(dma_addr_t) == 8 (64bit):

	 1	command IOCB (2 data segments)
	 6	continuation IOCBs (5 data segments per IOCB)
	--
	 7	request entries

Extending the basic formula, to transfer X KBs of data, you'll consume:

	         32bit    64bit
	      -----------------
	256KB -     10       14
	512KB -     19       27   request entries

As an example, taking the 512KB transfer consuming 27 request entries,
having an 2048 request-queue depth will support the transfer of 75 
(2048 / 27) concurrent 512KB transfer requests; ~150 concurrent requests
with an 4096 request-queue depth.

Here's another small table showing total requests per request's size
with an 2048 request-queue depth (multiply by 2 for an 4096 depth):

	         32bit    64bit
	      -----------------
	128KB -    341      292
	256KB -    204      146
	512KB -    107       75   concurrent requests

I hope this answers your request-queue usage question.  

I'm not sure if it brings us any closer to answering the question of
'what's the max queue-depth we support?'  Is it even possible, since as
you mentioned earlier, the admin will have to possess some outside
knowledge (backend-storage, I/O type, I/O patterns) while tuning the
queue-depth value.

--
Andrew








aTypically you'll find 128KB of memory available to the ISP, in
thoseMost implementations tend the request-queue can be , typically
there is a 128KiB for each 

> jeremy

