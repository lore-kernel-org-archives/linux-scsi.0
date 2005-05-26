From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: NBD (vs. iSCSI vs. EATA vs...)
Date: Thu, 26 May 2005 19:48:59 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0505261716080.3382@poirot.grange>
References: <1416215015.20050504193114@dns.toxicfilms.tv>
 <1115236116.7761.19.camel@dhollis-lnx.sunera.com>  <1104082357.20050504231722@dns.toxicfilms.tv>
  <1115305794.3071.5.camel@dhollis-lnx.sunera.com>  <20050507150538.GA800@favonius>
  <Pine.LNX.4.60.0505102352430.9008@poirot.grange>  <1115923927.5042.18.camel@mulgrave>
  <Pine.LNX.4.60.0505260103430.6612@poirot.grange> <1117070378.7534.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:65445 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261666AbVEZRtm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 13:49:42 -0400
In-Reply-To: <1117070378.7534.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Paul Clements <Paul.Clements@SteelEye.com>

(I wonder why my emails still haven't appeared on linux-scsi?)

On Wed, 25 May 2005, James Bottomley wrote:

> On Thu, 2005-05-26 at 01:41 +0200, Guennadi Liakhovetski wrote:
> > IIUC, the suggestion from James to implement ATAPI translates in 
> > user-space terms to implementing respective ioctl's, because this is what 
> > nbd gets, and this is what nbd-server has to reproduce.
> 
> Actually, no, that's not what I was thinking.
> 
> nbd currently only understands the block layer REQ_CMD (which are basic
> READ/WRITE commands) if it understood REQ_BLOCK_PC it would probably be
> sufficient a transport for sending the packet commands that are
> necessary to drive a remote device.

Aha, I see...

> The idea being that you could then do
> 
> cdrom - nbd <--\/\-->remote - ide/scsi - CD-ROM device
> 
> to drive an actual cdrom.  There are some pieces missing in this vision
> (like how to attach cdrom to nbd) but it should be doable in principle.

You need the cdrom driver to convert user requests to cdrom commands, 
which with your scheme would be collected by nbd from the block queue, 
passed to nbd-server to be translated back to user-space requests...

Well, doesn't this mean, that you would have to look, if the server 
exports a SCSI cdrom, nbd would have to add a SCSI bus to the system and a 
cdrom on it, respectively for ide. So, you would just get a new srX / sdX 
/ hdX / loopX? Or you would have to write a new cdrom driver for the "nbd 
bus", or teach one of existing to work over nbd (ide or scsi?). Wouldn't 
either of these 3 possibilities be too complicated? The third one could be 
not too difficult, but you would have to choose a victim - one of ide or 
scsi cdrom drivers. And what do you do with discs?...

OTOH, if you just pass all user-space requests to the server and just pass 
back return code, you wouldn't need high-level drivers on the host side. 
You would miss anything, comming not from userspace - any non REQ_CMD 
requests from filesystems. But those we could just add separately - for 
that you don't need cdrom / sd / hd drivers, right?

So, just pass ioctl()'s directly and convert the rest (filesystem) block 
requests separately - wouldn't it be easier and avoid any modifications to 
other drivers?

Thanks
Guennadi
---
Guennadi Liakhovetski

