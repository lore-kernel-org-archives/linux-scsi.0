From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM (take 2)
Date: Tue, 8 May 2007 18:14:44 +0200
Message-ID: <20070508161444.GA4163@kernel.dk>
References: <20070508171710.1ac730cd@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:32634 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934891AbXEHQRC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 12:17:02 -0400
Content-Disposition: inline
In-Reply-To: <20070508171710.1ac730cd@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org

On Tue, May 08 2007, Alan Cox wrote:
> The CD-ROM layer doesn't bounce requests for old ISA controllers (and
> nor should it). However they get injected into the SCSI layer via
> sr_ioctl which also doesn't bounce them and SCSI then passes the buffer
> along to a device with unchecked_isa_dma set which either panics or
> truncates the buffer to 24bits.
> 
> According to Jens the right long term fix is for the CD layer to route
> the requests differently but in the mean time this has been tested by a
> victim and verified to sort the problem out. For the other 99.9% of users
> it's a no-op and doesn't bounce data.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Christoph passed me his patch to get rid of ->generic_packet() in the
cdrom layer, so the work is almost complete. This patch is fine as a
work-around until that gets merged, though.

-- 
Jens Axboe

