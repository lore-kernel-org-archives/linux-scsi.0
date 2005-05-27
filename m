From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC][PATCH] allow sleep inside EH hooks
Date: Fri, 27 May 2005 12:43:05 -0400
Message-ID: <42974E19.9040007@adaptec.com>
References: <4296A2C7.4090107@pobox.com> <20050527071109.GB27256@infradead.org> <4296D0D8.6030907@pobox.com> <20050527075924.GA28608@infradead.org> <4296DC0B.9060802@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:31920 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262495AbVE0QnK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 12:43:10 -0400
In-Reply-To: <4296DC0B.9060802@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 05/27/05 04:36, Jeff Garzik wrote:
> Christoph Hellwig wrote:
>>No, hav ing the host_lock only held for ->queuecommand which doesn't
>>need that locking doesn't make any sense.  An API like the current one
> 
> 
> It makes a lot of sense:  LLDs are written with the assumption that 
> paths called from ->queuecommand will not be interrupted by their own 
> interrupt handler, whereas error handling paths are typically written 
> with precisely the -opposite- assumption.
> 
> Removing spin_lock_irq() from queuecommand in SCSI EH causes problems, 
> and solves nothing.

scsi_done() itself needs no explicit locking, it is completely reentrant
and this is a good thing.

I'd like to see the same thing for queuecommand(), i.e. host_lock be gone.

Modern HA and their LLDD, implement completely reentrant queuecommand()
and can deliver commands back to SCSI Core, via scsi_done(), _simultaneously_.
I.e. no concurrency between queuecommand() and scsi_done() is necessary.

This will greatly "free up" design and logic in LLDD to achieve greater
throughput.

Sleeping in EH is good.

	Luben

