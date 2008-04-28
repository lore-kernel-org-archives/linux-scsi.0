From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] another tranche of SCSI updates for 2.6.26
Date: Mon, 28 Apr 2008 08:13:03 -0400
Message-ID: <1209384784.3367.1.camel@localhost.localdomain>
References: <1209320076.3801.26.camel@localhost.localdomain>
	 <20080428013400.GA6245@elte.hu>
	 <1209351113.3801.107.camel@localhost.localdomain>
	 <48157B6A.60307@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38716 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765110AbYD1MNJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2008 08:13:09 -0400
In-Reply-To: <48157B6A.60307@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2008-04-28 at 10:23 +0300, Boaz Harrosh wrote:
> If we are already on the subject. It looks like we always have at most 1 command in the 
> free list, so why the free list at all? or am I reading the code wrong?

Because list handlers are well understood mechanisms within the kernel.
Also because in low memory situations, one command per host is
sufficient to guarantee forward progress, but it's not going to be very
efficient.  Embedded and other low memory environments can increase the
size of the free list to improve their I/O path.

James


