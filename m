From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: I/O Request [Elevator; Clustering; Scatter-Gather]
Date: Tue, 4 Mar 2003 09:47:59 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFDE36CE13.9373E086-ON87256CDF.0060BDDC-88256CDF.0061A289@us.ibm.com>
References: <20030304142041.GA660@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030304142041.GA660@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: David Anderson <david-anderson2003@mail.com>, linux-scsi@vger.kernel.org, Daniel Phillips <phillips@arcor.de>





>>Scatter-gather may cluster sg entries that are
>>> contiguous in memory.

Please explain this function.

The only "scatter gather" I've heard of is the concept of a single I/O
having a discontiguous buffer.  If it's a write, the system gathers bytes
from multiple separate buffers into a single write.  If it's a read, the
system scatters the bytes from a single read into multiple separate
buffers.

The readv() and writev() system calls are examples of something that
implements a scatter/gather function.  (But not the scatter/gather function
we're talking about here).

When you cluster disk I/O by combining separate requests that happen to be
to adjacent disk locations, you must have a scatter/gather function
somewhere (e.g. the disk controller or DMA controller) to make it work,
because those requests probably don't have contiguous buffers.

