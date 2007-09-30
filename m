From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/16] gdth: gdth_get_status() return pointer to host not its index
Date: Sun, 30 Sep 2007 22:26:28 +0100
Message-ID: <20070930212628.GC13343@infradead.org>
References: <46FFFC8C.6080804@panasas.com> <47000270.8000209@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40356 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbXI3V0g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 17:26:36 -0400
Content-Disposition: inline
In-Reply-To: <47000270.8000209@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Sep 30, 2007 at 10:09:20PM +0200, Boaz Harrosh wrote:
> 
>   - Return the interrupting host and not it's index.
>     NULL if intr is not by gdth.
>   - fix calling site
> 
>   FIXME:
>    Why are we looping on all cards? the passed dev_id
>    can be used for pinpointing the exact interrupting
>    card. The kernel is already looping on all sharing
>    cards so this code makes it O(n^2).

This is just pre-historic code that makes no sense whatover in a modern
kernel.  I'd much prefer to stop doing this and use dev_id properly.

>    What is that polling mode? can we pass dev_id to
>    gdth_get_status() and do a poll only if dev_id is
>    NULL?

Just loop over all host adapters in gdth_wait instead and pass in the
ha pointer.

