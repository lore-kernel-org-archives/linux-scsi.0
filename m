From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Plextor PowerRec for users
Date: Sun, 12 Feb 2006 12:10:15 -0700
Message-ID: <20060212191015.GH12822@parisc-linux.org>
References: <200602121718.15200.T.Maguin@web.de> <20060212165327.GG12822@parisc-linux.org> <200602121835.44430.T.Maguin@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:30085 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751417AbWBLTKQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 14:10:16 -0500
Content-Disposition: inline
In-Reply-To: <200602121835.44430.T.Maguin@web.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Maguin <T.Maguin@web.de>
Cc: linux-scsi@vger.kernel.org

On Sun, Feb 12, 2006 at 06:35:24PM +0100, Thomas Maguin wrote:
> On Sunday 12 February 2006 17:53, you wrote:
> > The trouble is that these are vendor-specific commands.  So they're safe
> > *for plextor devices*, but they may well be unsafe for other vendors.
> >
> These are just read commands. A correct firmware should just reject the 
> commands. 

I don't think you understand the point.  A non-Plextor device could have
a HALT AND CATCH FIRE command on that opcode.  That definitely wouldn't
be safe.  If 'just a read command' were enough, we wouldn't need to
have filtering for read commands at all.

> Plextor users have been waiting a long time for the features in linux, so 
> please think about a solution which is a solution for all users.

The only solutions I can think of are big and ugly if they're in
the kernel.  Why not write a set-uid helper that checks the device
manufacturer and device type, then issues the appropriate command?
That would work on 2.4 as well as 2.6.
