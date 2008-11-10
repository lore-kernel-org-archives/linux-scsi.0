From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: Thin provisioning & arrays
Date: Mon, 10 Nov 2008 10:59:49 +0100
Message-ID: <1226311189.4367.30.camel@macbook.infradead.org>
References: <4913028B.6010405@redhat.com>
	 <1225984628.4703.80.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
	 <20081107120534.GO21867@kernel.dk>
	 <1226072970.15281.46.camel@think.oraclecorp.com>
	 <20081109233639.GT4985@disturbed>
	 <9FA859626025B64FBC2AF149D97C944A8A648D@CORPUSMX80A.corp.emc.com>
	 <20081110083126.GF2373@disturbed>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49769 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbYKJKAX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2008 05:00:23 -0500
In-Reply-To: <20081110083126.GF2373@disturbed>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Black_David@emc.com, martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, rwheeler@redhat.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx

On Mon, 2008-11-10 at 19:31 +1100, Dave Chinner wrote:
> On Sun, Nov 09, 2008 at 10:40:24PM -0500, Black_David@emc.com wrote:
> > There will be a chunk size value available in a VPD page that can be
> > used to determine minimum size/alignment.  For openers, I see
> > essentially
> > no point in a 512-byte UNMAP, even though it's allowed by the standard -
> > I suspect most arrays (and many SSDs) will ignore it, and ignoring
> > it is definitely within the spirit of the proposed T10 standard (hint:
> > I'm one of the people directly working on that proposal).
>
> I think this is the crux of the issue. IMO, it's not much of a standard
> when the spirit of the standard is to allow everyone to implement
> different, non-deterministic behaviour....

I disagree. The discard request is a _hint_ from the upper layers, and
the storage device can act on that hint as it sees fit. There's nothing
wrong with that; it doesn't make it "not much of a standard".

Storage devices are complex enough that they _already_ exhibit behaviour
which is fairly much non-deterministic in a number of ways. Especially
if we're talking about SSDs or large arrays, rather than just disks.

A standard needs to be clear about what _is_ guaranteed, and what is
_not_ guaranteed. If it is explicit that the storage device is permitted
to ignore the discard hint, and some storage devices do so under some
circumstances, then that is just fine.

> Unmapping can and should be made reliable so that we don't have to
> waste effort trying to fix up mismatches that shouldn't have occurred
> in the first place...

Perhaps so. But remember, this can only really be considered a
correctness issue on thin-provisioned arrays -- because they may run out
of space sooner than they should. But that kind of failure mode is
something that is explicitly accepted by those designing and using such
thin-provisioned arrays. It's not as if we're introducing any _new_ kind
of problem.

So I think it's perfectly acceptable for the operating system to treat
discard requests as a hint, with best-effort semantics. And any device
which _really_ cares will need to make sure for _itself_ that it handles
those hints reliably.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

