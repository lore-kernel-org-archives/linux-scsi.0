From: Andrew Morton <akpm@digeo.com>
Subject: Re: 2.5.73-mm1 falling over in SDET
Date: Sat, 28 Jun 2003 17:02:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030628170235.51ee2f69.akpm@digeo.com>
References: <45120000.1056810681@[10.10.2.4]>
	<49400000.1056814561@[10.10.2.4]>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pao-ex01.pao.digeo.com ([12.47.58.20]:16030 "EHLO
	pao-ex01.pao.digeo.com") by vger.kernel.org with ESMTP
	id S265482AbTF1XsS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Jun 2003 19:48:18 -0400
In-Reply-To: <49400000.1056814561@[10.10.2.4]>
List-Id: linux-scsi@vger.kernel.org
To: "Martin J. Bligh" <mbligh@aracnet.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

"Martin J. Bligh" <mbligh@aracnet.com> wrote:
>
> > The killer SDET has got you, but this is all I got from the chewed
> > remains. Maybe the EIP is enough? ;-) I guess that's a NULL ptr
> > dereference, though garbled somewhat.
> 
> Repeated it and got a much better panic. This is with feral isp driver
> + Mike's patch, BTW. Maybe it's just some stack overflow?

Oh lovely.

> Call Trace:
>  [<c01c42d3>] blk_insert_request+0x47/0x78
>  [<c01d3679>] scsi_queue_insert+0x71/0x7c
>  [<c01d05a4>] scsi_dispatch_cmd+0x180/0x190
>  [<c01d465c>] scsi_request_fn+0x1f4/0x264
>  [<c01c42f1>] blk_insert_request+0x65/0x78
>  [<c01d3679>] scsi_queue_insert+0x71/0x7c
>  [<c01d05a4>] scsi_dispatch_cmd+0x180/0x190
>  [<c01d465c>] scsi_request_fn+0x1f4/0x264
>  [<c01c42f1>] blk_insert_request+0x65/0x78

Yes, isplinux_queuecommand() returns non-zero and the scsi generic layer
cheerfully goes infinitely recursive.


