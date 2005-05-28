From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: NBD (vs. iSCSI vs. EATA vs...) (fwd)
Date: Sat, 28 May 2005 15:12:00 -0400
Message-ID: <1117307520.5192.3.camel@mulgrave>
References: <Pine.LNX.4.60.0505281030510.3721@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:22205 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261189AbVE1TMG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 May 2005 15:12:06 -0400
In-Reply-To: <Pine.LNX.4.60.0505281030510.3721@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-05-28 at 10:32 +0200, Guennadi Liakhovetski wrote:
> So, just pass ioctl()'s directly and convert the rest (filesystem)
> block 
> requests separately - wouldn't it be easier and avoid any
> modifications to 
> other drivers?

Before you go any further, I suggest you think about what an ioctl is
and why we're going through a process of trying to get rid of them in
the kernel:  They're structured streams of information, where the
structure is architecture and 64/32 bit dependent (look at all the
issues over compat ioctls).  Inherently these things will be incredibly
nasty to convert to an architecture neutral network protocol, and you'll
have to provide a translator to and from every possible ioctl...they're
inherently unsuitable things for building a protocol on top of.  On the
other hand, the current nbd protocol is block request based, which is
why I suggested looking at that instead.

James


