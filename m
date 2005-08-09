From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SPI transport class and generic Domain Validation for fusion
Date: Tue, 9 Aug 2005 10:13:53 +0100
Message-ID: <20050809091353.GA11397@infradead.org>
References: <1123537590.8235.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:22403 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932475AbVHIJOC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 05:14:02 -0400
Content-Disposition: inline
In-Reply-To: <1123537590.8235.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Aug 08, 2005 at 04:46:30PM -0500, James Bottomley wrote:
> Eric,
> 
> This attached patch should do DV on both physical devices and the
> underlying devices of fusion IM assemblies (providing you apply it on
> top of the prior underlying device exposure patch), which, I believe was
> your only outstanding concern with the last generic DV patch.
> 
> There is one slight unsightly piece: the IM device still attaches to the
> transport class however all the parameters it shows actually belong to
> the underlying device at that id ... I could do with finding a way of
> persuading the SPI transport class not to attach to RAID devices.
> 
> Since this addresses all of LSI's prior concerns, may I now apply it?

 - there's a stale printk("HERE2\n"); in mptscsih_writeSDP1.
 - the #undef MPTSCSIH_ENABLE_DOMAIN_VALIDATION is probably not needed
 - the hd == NULL check in mptspi_target_alloc isn't needed
 - should the driver print a warning about too old firmware when we can't
   access page 0?
