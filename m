From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: dc395x: can't write to tape
Date: Sun, 9 Jan 2005 16:33:42 +1100
Message-ID: <20050109053342.GA5799@twibble.org>
References: <200501060518.25782.andrex@alumni.utexas.net> <Pine.LNX.4.60.0501062138580.7568@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nynaeve.twibble.org ([202.173.155.194]:47256 "EHLO
	nynaeve.twibble.org") by vger.kernel.org with ESMTP id S262256AbVAIFdr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jan 2005 00:33:47 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0501062138580.7568@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Andrew Schulman <andrex@alumni.utexas.net>, linux-scsi@vger.kernel.org

On Thu, Jan 06, 2005 at 10:48:38PM +0100, Guennadi Liakhovetski wrote:
[...]
> > Jan  5 22:50:18 helium kernel: dc395x: sg_update_list: sg_to_virt failed
> 
> This doesn't look good. However, after a brief look at the code, I cannot 
> say what exactly went wrong there. Jamie?

This messages has been happening in the driver for ever for some
people (mos tlikely related to specific devices they are using?). I
believe the sg_to_virt thing is trying to convert from the bus
address back to the virtual address to be able to recaculate the
position for the next transfer after a partial transfer. I've never
been able to actually reproduce this specific problem myself.

All the s/g list handling stuff really needs to be re-written. I'm
certain that it's not high-mem safe and another rather nasty thing is
that it modifies the sg lists after dma mapping them in some
situations which isn't really on (and seems to be the cause of the
hangs I see when running on sparc64 with some additional patches I
have to support big endien machines.)

[...]

-- 
 Jamie Lenehan <lenehan@twibble.org>
