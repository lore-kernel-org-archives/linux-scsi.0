From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: (as54) Fix hot-unplugging for sr.c
Date: Wed, 9 Jul 2003 10:04:46 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307090956350.846-100000@ida.rowland.org>
References: <20030708222906.GF2232@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1028 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S268311AbTGINuI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2003 09:50:08 -0400
In-Reply-To: <20030708222906.GF2232@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 8 Jul 2003, Mike Anderson wrote:

> Alan,
> 	This looks like it solves the problem for sr and could be
> 	replicated for other upper level drivers. The patch I created
> 	works a little differently in that the remove function is not
> 	called until opens drop to zero (if the device is open).

Interesting.  As I understand it, remove() is called from the SCSI core
whereas block_release() is called through the filesystem.  The two code
paths only intersect in sr.c.  So how does the core know when opens drops
to 0?

> 	I started a new thread for the cleanup patches I have been
> 	working on  because I have four patches in the series (
> 	including a refresh of your /proc/scsi fixups).

I'm looking forward to seeing the end results.  Incidentally, it turns out
that my patch still needs some minor fixups.  Locking is notoriously
difficult to get exactly right.  But it can wait until after this other
stuff is finished.

Speaking of /proc/scsi, have you given any thought to making the procinfo 
contents available through sysfs?  That way the /proc entry points can be 
deprecated and eventually removed, but the information will still be 
easily available.

Alan Stern

