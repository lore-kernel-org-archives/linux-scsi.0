From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] drivers/scsi/sd.c: fix uninitialized variable in
	handling medium errors
Date: Wed, 26 Apr 2006 18:22:03 -0500
Message-ID: <1146093723.12914.16.camel@mulgrave.il.steeleye.com>
References: <200604261627.29419.lkml@rtr.ca>
	 <1146092161.12914.3.camel@mulgrave.il.steeleye.com>
	 <20060426161444.423a8296.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:17582 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750726AbWDZXWM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Apr 2006 19:22:12 -0400
In-Reply-To: <20060426161444.423a8296.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: lkml@rtr.ca, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2006-04-26 at 16:14 -0700, Andrew Morton wrote:
> It'd be nice to have something simple-and-obvious for the
> simple-and-obvious -stable maintainers.  That's if we think -stable needs
> this fixed.

Well .. the original will do for that.  

> > +				int sector_size_div =
> > +					512 / SCpnt->device->sector_size;
> > +				error_sector /= sector_size_div;
> 
> You sure about this bit?

Yes.  If the <hardware sector size> is < 512 bytes then to convert the
listed error sector to the standard 512 byte sector size block index, we
have to divide (512/<hardware sector size>).

James


