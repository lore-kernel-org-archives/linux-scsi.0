From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [RFC 1/6] bidi support: request dma_data_direction
Date: Tue, 23 Jan 2007 15:37:58 +0200
Message-ID: <45B60FB6.1050708@panasas.com>
References: <45B3F578.7090109@panasas.com> <45B40458.9010107@torque.net> <45B4547A.3020105@panasas.com> <45B4D2A0.4080201@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:42050 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965092AbXAWNtG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 08:49:06 -0500
In-Reply-To: <45B4D2A0.4080201@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com, Daniel.E.Messinger@seagate.com, Liran Schour <LIRANS@il.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>

Douglas Gilbert wrote:
> Benny Halevy wrote:
>> Douglas Gilbert wrote:
> 
> Perhaps the right use of DMA_BIRECTIONAL needs to be
> defined.
> 
> Could it be used with a XDWRITE(10) SCSI command
> defined in sbc3r07.pdf at http://www.t10.org ? I suspect
> using two scatter gather lists would be a better approach.

Exactly. This is a classic example of a bidirectional command
and indeed two scatter-gather lists (that are mapped into two
bio lists) are used.

> 
>>>> - Introduce new blk_rq_init_unqueued_req() and use it in places ad-hoc
>>>>   requests were used and bzero'ed.
>>> With a bi-directional transfer is it always unambiguous
>>> which transfer occurs first (or could they occur at
>>> the same time)?
>> The bidi transfers can occur in any order and in parallel.
> 
> Then it is not sufficient for modern SCSI transports in which
> certain bidirectional commands (probably most) have a well
> defined order.
> 
> So DMA_BIDIRECTIONAL looks PCI specific and it may have
> been a mistake to replace other subsystem's direction flags
> with it. RDMA might be an interesting case.
> 

I would say that it might make sense to define an equivalent
for dma_data_direction at the block layer, for example:

enum req_io_direction {
	REQ_IO_NONE = 0,
	REQ_IN_FROM_DEVICE = 1,
	REQ_OUT_TO_DEVICE = 2,
	REQ_BIDIRECTIONAL = 3,
};

can be used in struct request and upper layers.

Besides the fact that having separate I/O buffers for bidirectional
transfers makes block I/O different from pci bidi I/O,
this enum makes more sense "arithmetically" and has
a much better meaning for the zero value.
Today DMA_BIDIRECTIONAL is used in several places as the default and "invalid"
value since no-one ever used it before. I'd rather have the value 0 mean
REQ_IO_NONE (or REQ_IO_INVALID if we want such thing).

Benny
