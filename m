From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 2/4] mvsas: Deadlocks meet when TMF tasks issue
Date: Sat, 09 May 2009 10:05:25 -0500
Message-ID: <1241881525.3542.19.camel@mulgrave.int.hansenpartnership.com>
References: <20090508061605.GA1884@jason.marvell.com>
	 <1241797765.3327.57.camel@mulgrave.int.hansenpartnership.com>
	 <4A04ACB3.5060608@garzik.org>
	 <5FF020A1CFFEEC49BD1E09530C4FF5956BCA03C8@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42185 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbZEIPFZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 May 2009 11:05:25 -0400
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5956BCA03C8@SC-VEXCH1.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Yan <ayan@marvell.com>
Cc: Jeff Garzik <jeff@garzik.org>, Ying Chu <jasonchu@marvell.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sat, 2009-05-09 at 00:25 -0700, Andy Yan wrote:
> 	For considering the possibility of future use, I did not remove the parameter; I will check this and remove it with next patch if it is OK.

Well, there are two reasons for removing it.  The first is that it's
unused, but the second is that conditional locking isn't very nice
programming style, since it makes control flow far harder to follow
rationally when just reading the code.  The preferred style is to define
a function that does the unlocked operation, usually with double
underscores and then have a locked version that takes the lock, calls
the double underscore unlocked version and releases the lock again.  In
your case, if you find a use for the unlocked version, you can split it
in the patch that's using it.

Looking at the routine, the only thing you call outside the lock is
mvs_find_dev_mvi().  The thing that strikes me here is that this is a
bit inefficient: why not store mvi in struct mvs_device?  Then you can
get it as a simple pointer operation instead of having to search.

James


