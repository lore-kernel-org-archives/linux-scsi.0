From: Jens Axboe <axboe@suse.de>
Subject: Re: extracting infos from struct scsi_cmnd
Date: Sat, 27 Nov 2004 16:48:49 +0100
Message-ID: <20041127154849.GA24460@suse.de>
References: <20041127124222.GA1200@abulafia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:58505 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261161AbUK0Psx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Nov 2004 10:48:53 -0500
Content-Disposition: inline
In-Reply-To: <20041127124222.GA1200@abulafia>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, tommaso.m@tiscalinet.it

On Sat, Nov 27 2004, Tommaso Moroni wrote:
> Hi!
> 
> I'm writing a module for the 2.6.9 kernel which tracks accesses on a
> usb-storage device; in particular I'm interested in extracting from a
> struct scsi_cmnd the data read/written and the associated sector. 
> 
> 
> The code I'vr written till now looks like the following:
> 
> 
> struct scsi_cmnd * cmd;
> [...]
> if (cmd->use_sg == 0)
> {
> 	buf = cmd->buffer;
> 	buflen = cmd->bufflen;
> 	sector = cmd->request->sector;

->request_bufflen and ->request_buffer.

> } else {
> 	struct scatterlist * sl = (struct scatterlist *) cmd->buffer;
> 	for (i = 0; i < cmd->use_sg; i++)
> 	{
> 		buf = page_address(sl[i].page) + sl[i].offset;
>                 buflen = sl[i].length;
> 		/* sector? */
> 	}
> }

This only works on non-highmem pages, you should use kmap/kmap_atomic
instead.

> Is it correct?
> Where can I find the sector involved in the operation if the
> scatter-gather is used?

It's ->request->sector as well. The total length is just the sum of the
sg elements.

-- 
Jens Axboe

