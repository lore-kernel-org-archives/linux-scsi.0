From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: 22 Sep 2003 14:28:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064258938.15409.63.camel@mulgrave>
References: <UTC200309221855.h8MItM216884.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:49926 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261808AbTIVT3s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 15:29:48 -0400
In-Reply-To: <UTC200309221855.h8MItM216884.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: Patrick Mansfield <patmans@us.ibm.com>, Linus Torvalds <torvalds@osdl.org>, david-b@pacbell.net, greg@kroah.com, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu

On Mon, 2003-09-22 at 13:55, Andries.Brouwer@cwi.nl wrote:
>         if (sdkp->media_present) {
>                 sd_read_capacity(sdkp, disk->disk_name, sreq, buffer);
>                 if (sdp->removable)
>                         sd_read_write_protect_flag(sdkp, disk->disk_name,
>                                         sreq, buffer);
>                 sd_read_cache_type(sdkp, disk->disk_name, sreq, buffer);
>         }
> 
> and I suppose we could skip sd_read_cache_type() in the
> hot-pluggable case - a flag that USB storage could set.

what about just having a conservative mode for sd?  This could still
internally be a set of flags, just one single way of clearing them all
from slave configure.  For the most conservative setting, we could
probably dump spin up, read write protect, and read cache type.

James

