From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [stable] [PATCH 1/2] sd: fix memory corruption by
	sd_read_cache_type
Date: Sat, 25 Feb 2006 23:14:48 -0600
Message-ID: <1140930888.3279.4.camel@mulgrave.il.steeleye.com>
References: <tkrat.014f03dc41356221@s5r6.in-berlin.de>
	 <20060225021009.GV3883@sorel.sous-sol.org>
	 <4400E34B.1000400@s5r6.in-berlin.de>
	 <Pine.LNX.4.64.0602251600480.22647@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:33490 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751199AbWBZFPb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 00:15:31 -0500
In-Reply-To: <Pine.LNX.4.64.0602251600480.22647@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Chris Wright <chrisw@sous-sol.org>, stable@kernel.org, Jody McIntyre <scjody@modernduck.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>

On Sat, 2006-02-25 at 16:01 -0800, Linus Torvalds wrote:
> Perhaps equally importantly, let's get them into mainline if they are so 
> important. Which means that I want sign-offs and acks from the appropriate 
> people (scsi and original author, which is apparently Al).

Yes, I've been thinking about this.  The problem is that it's a change
to sd and a change to scsi_lib in a fairly critical routine.  While I'm
reasonably certain the change is safe, I'd prefer to make sure by
incubating in -mm for a while.

The title, by the way, is misleading; it's not a memory corruption in sd
at all really.  It's the initio bridge which produces a totally
standards non conformant return to a mode sense which produces the
problem.  And so, it's only the single initio bridge which is currently
affected; hence the caution.

James


