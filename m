From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: IO buffer alignment for block devices
Date: 13 Sep 2004 10:14:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095084876.1762.8.camel@mulgrave>
References: <41459729.5060106@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:11999 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266835AbUIMOOj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 10:14:39 -0400
In-Reply-To: <41459729.5060106@il.marvell.com>
List-Id: linux-scsi@vger.kernel.org
To: Saeed Bishara <Saeed.Bishara@il.marvell.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-09-13 at 08:48, Saeed Bishara wrote:
>     Is there any minimal alignment for the IO buffers (sg and single) 
> sent to a scsi LLD?
>     I found that buffers that come from buffer cache, page cache and sg 
> are page aligned , and the raw driver send sector aligned     buffers.
>     so can I assume that the minimal alignment of the buffer is 512 bytes?

You can assume it will be whatever you set blk_queue_dma_alignment() to
in your slave configure routines.  If the LLD doesn't set this, then it
will be 8 bytes.  However, beware, setting this higher can cause user
generated commands to be errored if they fail the alignment checks.

James


