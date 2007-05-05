From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] tmscsim: remove bogus endianness conversions
Date: Sat, 5 May 2007 10:37:51 +0100
Message-ID: <20070505093751.GB9422@infradead.org>
References: <Pine.LNX.4.60.0705042257410.21060@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36783 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423241AbXEEJhw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 May 2007 05:37:52 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0705042257410.21060@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Fri, May 04, 2007 at 10:59:40PM +0200, Guennadi Liakhovetski wrote:
> cpu_to_le32 endianness conversions in tmscsim.c, followed by
> arithmetic operations don't look correct. Besides, {in,out}[wl]
> already perform the necessary conversions. Further, bus addresses
> of request buffers are guaranteed to be (mapped) under 4G by
> current scsi- and block-layer defaults. This could be explicitly
> enforced by using blk_queue_bounce_limit(), which, however,
> doesn't seem to be the common practice among SCSI drivers.

Looks good to me.  If there are structures in dma memory in the driver
it would help to give the __le annotation to get the whole endianess
handling completely right.

