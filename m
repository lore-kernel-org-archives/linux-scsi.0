From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: advansys regions [Re: 2.4 vs 2.6 versions of
 include/linux/ioport.h]
Date: Wed, 6 Aug 2003 11:50:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030806115035.24c8f03b.rddunlap@osdl.org>
References: <200308051041.08078.gene.heskett@verizon.net>
	<20030806104041.4a09f4f0.rddunlap@osdl.org>
	<20030806175954.GX22222@parcelfarce.linux.theplanet.co.uk>
	<200308061435.43458.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:30103 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S270939AbTHFSy3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2003 14:54:29 -0400
In-Reply-To: <200308061435.43458.gene.heskett@verizon.net>
List-Id: linux-scsi@vger.kernel.org
To: gene.heskett@verizon.net
Cc: willy@debian.org, linux-scsi@vger.kernel.org, kernel-janitor-discuss@lists.sourceforge.net

On Wed, 6 Aug 2003 14:35:43 -0400 Gene Heskett <gene.heskett@verizon.net> wrote:

...
| >> | >| ----
| >> | >| First, the define itself is missing in the 2.6 version.
| >
| >What define?  check_region() is still there, just as an inline
| > function, not a macro.
| >
| I found that later.
| 
| >> | >| Many drivers seem to use this call, and in that which I'm
| >> | >| trying to build, the nforce and advansys modules use it.  And
| >> | >| while the modules seem to build, they do not run properly.
| >
| >Explain?  Has someone broken check_region?
| 
| Its now marked __deprecated.  The module builds while indicating the 
| errors, but gets into a bus reset loop and hangs in the second 
| iteration of it.

So the kernel driver, without mods, is broken?
I didn't realize this earlier.

| >> I'm not terribly interested in spending much time on this driver,
| >> so the simplest thing to do IMO is to emulate check_region() with
| >> pairs of request_region() and release_region() calls.  Yes, this
| >> is still racy, just like check_region() was.  Is that a problem
| >> in your machine environment?
| >
| >I think this is the wrong thig to do.  Leaving the check_region()
| >calls there indicate this driver still needs to be fixed properly.
| >Replacing them with unsafe uses of request & release_region leaves
| > the driver racy and removes the indication.

--
~Randy				For Linux-2.6, see:
http://www.kernel.org/pub/linux/kernel/people/davej/misc/post-halloween-2.5.txt
