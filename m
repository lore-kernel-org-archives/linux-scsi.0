From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Disabling block layer
Date: Wed, 28 Mar 2007 13:24:20 +0200
Message-ID: <20070328112420.GL3963@kernel.dk>
References: <656559.33072.qm@web63001.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:54916 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbXC1Mrd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Mar 2007 08:47:33 -0400
Content-Disposition: inline
In-Reply-To: <656559.33072.qm@web63001.mail.re1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lobo <ntdeveloper2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Mar 26 2007, Mark Lobo wrote:
> Hello!
> 
> I had a question about disabling the block layer for SCSI devices. We
> have an embedded device, and it runs 2.4.30. We need to be able to
> support a lot of SCSI devices (in the thousands) for our device, and we
> talk to the devices via SG. We are facing a memory allocation problem
> after discovering a few thousand devices. For every device,  there
> seems to be a lot of memory allocated in the block layer. This memory
> includes cache memory (which IIRC is reclaimable by the kernel memory
> subsystem when it needs it) and also pages that are used for the
> alloc_pages pool.

A much easier approach would be to limit the memory used for each device
in the block layer. Since SCSI uses the block layer as a transport for
commands, you cannot disable the block layer in any easy manner.

But your memory is likely being eated by the queue freelist. So edit
drivers/block/ll_rw_blk.c and hardcode nr_requests to a low number (like
2).

-- 
Jens Axboe

