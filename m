From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Fri, 11 May 2007 16:12:47 -0500
Message-ID: <1178917967.3692.70.camel@mulgrave.il.steeleye.com>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
	 <20070511.130024.104034874.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52188 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761105AbXEKVMv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 17:12:51 -0400
In-Reply-To: <20070511.130024.104034874.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org

On Fri, 2007-05-11 at 13:00 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> Date: Fri, 11 May 2007 13:33:41 -0500
> 
> > Right at the moment, we're planning to clean up the way SCSI drivers
> > process commands.  The proposals are essentially:
> > 
> >      1. Get rid of the now unnecessary map_single path (every command is
> >         either zero transfer or scatter/gather)
> >      2. use accessors to manipulate the SG lists (mainly so that we can
> >         alter the implementation without affecting the drivers)
> > 
> > It strikes me that in all of this, we could also consider doing the DMA
> > mapping inside the mid layer (instead of in every driver).  This is
> > essentially what libata is already doing ... leading to confusion in
> > SCSI drivers that use libata for SATA.
> > 
> > So what do people think about this?
> 
> This would require platforms to handle all of their bus types
> behind the generic dma_*() and that's isn't true everywhere yet.
> 
> For example, SBUS still requires explicitly using sbus_map_sg() etc.
> 
> I plan to fix that of course, but we're not there now.

I could probably cook up a patch for you, if you like? ... I've already
done it for several other architectures.

James


