From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: 06 Apr 2004 12:13:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081271594.1837.37.camel@mulgrave>
References: <Pine.LNX.4.44L0.0404061251460.1042-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:9405 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261366AbUDFRQq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 13:16:46 -0400
In-Reply-To: <Pine.LNX.4.44L0.0404061251460.1042-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-04-06 at 11:55, Alan Stern wrote:
> In principle, yes.  However...  The kernel still has to process requests 
> correctly while the stack is partially deconstructed.  It also has to 
> protect against userland helpers trying to pull things apart in the wrong 
> order.

This I agree with ... that's where the "robust to errors" statement
comes in.  I'm not claiming we currently are, merely that we have to be
(regardless of ordered or disordered event propagation).

> I'm not trying to say that anything you wrote was wrong -- just that the 
> situation is more complicated than you make it appear.

Well, I think the principle is simple.  The practice is less so ... I
can still panic my test system by offlining the ext2 root filesystem in
the middle of heavy stress.

What I don't believe is that enforcing some kind of ordering can relieve
us of the necessity of making the error paths robust.

Since the largely hitherto untested error path becomes our main handler
for forced disconnect, we're necessarily running into a lot of bugs that
didn't show up before.  However, they have always been bugs regardless
of whether they got tripped.

James


