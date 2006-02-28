From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Linux v2.6.16-rc5
Date: Tue, 28 Feb 2006 12:43:15 +0000
Message-ID: <20060228124314.GA4674@infradead.org>
References: <Pine.LNX.4.64.0602262122000.22647@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:64693 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932206AbWB1MnQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 07:43:16 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0602262122000.22647@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sun, Feb 26, 2006 at 09:27:28PM -0800, Linus Torvalds wrote:
> 
> The tar-ball is being uploaded right now, and everything else should 
> already be pushed out. Mirroring might take a while, of course.
> 
> There's not much to say about this: people have been pretty good, and it's 
> just a random collection of fixes in various random areas. The shortlog is 
> actually pretty short, and it really describes the updates better than 
> anything else.
> 
> Have I missed anything? Holler. And please keep reminding about any 
> regressions since 2.6.15.

We still have a regression from 2.6.15 in the megaraid_sas driver.

We started sending down all requests as scatter/gather lists after 2.6.15,
and the (broken) way megaraid_sas tried to hide the physical disks ceased
to work.  Now the driver shows all physical disks which confuses installers
to no end and could trick people to write to it which would corrupt controller
internal state badly.

To fix this properly the scsi midlayer needs to handle the ->slave_configure
return value.  The patch for that is pretty trivially, but could in theory
cause problems if an existing driver returns something bogus from
->slave_configure.   Both the core patch and the actual megaraid_sas fix
are in James' scsi-rc-fixes tree, so if you pull that once more we should
be done with this.
