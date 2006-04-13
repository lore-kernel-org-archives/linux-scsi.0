From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: HBA self selection
Date: Thu, 13 Apr 2006 12:47:06 -0500
Message-ID: <1144950427.3474.39.camel@mulgrave.il.steeleye.com>
References: <5CCF5F0F2514664CBE20FD24BCE17614044BF8@cceexc17.americas.cpqcorp.net>
	 <20060413152419.GD24104@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:60065 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751108AbWDMRrM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 13:47:12 -0400
In-Reply-To: <20060413152419.GD24104@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Cameron, Steve" <Steve.Cameron@hp.com>, linux-scsi@vger.kernel.org

On Thu, 2006-04-13 at 09:24 -0600, Matthew Wilcox wrote:
> I can take the code out that prevents us talking to the bus; it's pretty
> much a one-liner:
> 
> -        if (sdev->id == np->myaddr) {
> -                sym_xpt_done2(np, cmd, DID_NO_CONNECT);
> -                return 0;
> -        }
> 
> but I'd like this change tested, if you wouldn't mind.  After the
> midlayer's fixed, of course ;-)

I really don't think it's a good idea to try to force a HBA to select
it's own address in SPI.  It's certainly illegal under the standard, and
there are many things that could go wrong with this (both inside the HBA
and on the bus).

Steve, how exactly is this supposed to work?  The SPI protocol wasn't
designed to allow two devices on the bus with the same ID.  I'm assuming
the device doesn't do all the things that simply can't work, like
disconnect/reconnect?

James


