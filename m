From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue
	reached
Date: 06 Mar 2003 12:04:04 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1046973846.1746.30.camel@mulgrave>
References: <20030228111924.A32018@beaverton.ibm.com>
	<1046833360.2757.43.camel@mulgrave>
	<20030305104320.A14722@beaverton.ibm.com>
	<1046966278.1746.12.camel@mulgrave>
	<20030306094156.A23231@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030306094156.A23231@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2003-03-06 at 11:41, Patrick Mansfield wrote:
> Such a solution complicates moving to a per-device queue lock - we need a
> per-host lock while pulling off the restart list, and we need a
> per-queue-lock prior to calling __blk_run_queue(); but when starving in
> the scsi_request_fn(), we have a per-queue-lock and need the per-host lock
> to add to the restart list. So we have to allow dropping a lock in both
> cases without leading to a hung requeset queue.

Actually, I don't think it does. Any driver that can truly have a per
device lock can't have a fixed size pool of resources that device
requests are competing for (otherwise it would need a host lock to
access these resources), thus can_queue should always be set to a number
much greater than the aggregate of the local device queue depths (we'd
need a comment in the code to this effect).

Do we actually have any LLDs in the tree today that can benefit from a
device based locking approach?  (i.e. they must manage their resource
pools on a device basis and also have a mailbox scheme that doesn't
require host based locking).

James


