From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: 23 Sep 2003 09:04:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064325894.1857.13.camel@mulgrave>
References: <UTC200309221956.h8MJucs21996.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:33541 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263356AbTIWOF6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 10:05:58 -0400
In-Reply-To: <UTC200309221956.h8MJucs21996.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: david-b@pacbell.net, greg@kroah.com, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-usb@one-eyed-alien.net, Patrick Mansfield <patmans@us.ibm.com>, stern@rowland.harvard.edu, Linus Torvalds <torvalds@osdl.org>

On Mon, 2003-09-22 at 14:56, Andries.Brouwer@cwi.nl wrote:
> I have seen proposals around here for flags that are far too specific
> (like "do not ask for mode page 8"). If we go to that level of detail
> then we'll soon have fifty flags.
> Black lists, and flags that describe various ways of being broken
> are a bad idea in my opinion. I will not deny that they may be needed
> in some cases, but they are never the preferred solution.
> 
> Also "conservative mode" sounds like a flag that describes some
> way of being broken.
> 
> On the other hand "hot-pluggable" describes a positive asset,
> and if we can conclude from that that it is unnecessary to ask
> for mode page 8 then we achieve the same effect in a positive way.

I disagree on this one.  hot-pluggable sounds like it should be set for
ever hotplug device (currently that would include firewire, which may be
iffy, and Fibre Channel, which has our highest level of SCSI compliance
and would definitely be wrong).

The design goal is that this flag makes sd assume as little SCSI
standards compliance as it can get away with while still operating the
device.

So call a spade "a spade"

My thought, by the way, is that it would be a callback that would clear
all the "extras" flags, and the slave_configure routine could
selectively turn them back on again if necessary.

James


