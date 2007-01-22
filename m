From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC 1/6] bidi support: request dma_data_direction
Date: Mon, 22 Jan 2007 10:05:04 -0500
Message-ID: <45B4D2A0.4080201@torque.net>
References: <45B3F578.7090109@panasas.com> <45B40458.9010107@torque.net> <45B4547A.3020105@panasas.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35657 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbXAVPFZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2007 10:05:25 -0500
In-Reply-To: <45B4547A.3020105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com, Daniel.E.Messinger@seagate.com, Liran Schour <LIRANS@il.ibm.com>

Benny Halevy wrote:
> Douglas Gilbert wrote:
>> Boaz Harrosh wrote:
>>> - Introduce a new enum dma_data_direction data_dir member in struct request.
>>>   and remove the RW bit from request->cmd_flag
>>> - Add new API to query request direction.
>>> - Adjust existing API and implementation.
>>> - Cleanup wrong use of DMA_BIDIRECTIONAL

Perhaps the right use of DMA_BIRECTIONAL needs to be
defined.

Could it be used with a XDWRITE(10) SCSI command
defined in sbc3r07.pdf at http://www.t10.org ? I suspect
using two scatter gather lists would be a better approach.

>>> - Introduce new blk_rq_init_unqueued_req() and use it in places ad-hoc
>>>   requests were used and bzero'ed.
>> With a bi-directional transfer is it always unambiguous
>> which transfer occurs first (or could they occur at
>> the same time)?
> 
> The bidi transfers can occur in any order and in parallel.

Then it is not sufficient for modern SCSI transports in which
certain bidirectional commands (probably most) have a well
defined order.

So DMA_BIDIRECTIONAL looks PCI specific and it may have
been a mistake to replace other subsystem's direction flags
with it. RDMA might be an interesting case.

Doug Gilbert


