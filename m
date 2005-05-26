From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: NBD (vs. iSCSI vs. EATA vs...)
Date: Wed, 25 May 2005 21:19:38 -0400
Message-ID: <1117070378.7534.4.camel@mulgrave>
References: <1416215015.20050504193114@dns.toxicfilms.tv>
	 <1115236116.7761.19.camel@dhollis-lnx.sunera.com>
	 <1104082357.20050504231722@dns.toxicfilms.tv>
	 <1115305794.3071.5.camel@dhollis-lnx.sunera.com>
	 <20050507150538.GA800@favonius>
	 <Pine.LNX.4.60.0505102352430.9008@poirot.grange>
	 <1115923927.5042.18.camel@mulgrave>
	 <Pine.LNX.4.60.0505260103430.6612@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:39045 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261651AbVEZBTq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 21:19:46 -0400
In-Reply-To: <Pine.LNX.4.60.0505260103430.6612@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Paul Clements <Paul.Clements@SteelEye.com>

On Thu, 2005-05-26 at 01:41 +0200, Guennadi Liakhovetski wrote:
> IIUC, the suggestion from James to implement ATAPI translates in 
> user-space terms to implementing respective ioctl's, because this is what 
> nbd gets, and this is what nbd-server has to reproduce.

Actually, no, that's not what I was thinking.

nbd currently only understands the block layer REQ_CMD (which are basic
READ/WRITE commands) if it understood REQ_BLOCK_PC it would probably be
sufficient a transport for sending the packet commands that are
necessary to drive a remote device.

The idea being that you could then do

cdrom - nbd <--\/\-->remote - ide/scsi - CD-ROM device

to drive an actual cdrom.  There are some pieces missing in this vision
(like how to attach cdrom to nbd) but it should be doable in principle.

James


