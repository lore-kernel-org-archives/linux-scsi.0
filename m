From: Black_David@emc.com
Subject: UNMAP is a hint
Date: Mon, 10 Nov 2008 12:05:57 -0500
Message-ID: <9FA859626025B64FBC2AF149D97C944A8A64A6@CORPUSMX80A.corp.emc.com>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <20081109233639.GT4985@disturbed> <9FA859626025B64FBC2AF149D97C944A8A648D@CORPUSMX80A.corp.emc.com> <20081110083126.GF2373@disturbed> <1226311189.4367.30.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:28641 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbYKJRIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2008 12:08:54 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1226311189.4367.30.camel@macbook.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dwmw2@infradead.org, david@fromorbit.com
Cc: martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, rwheeler@redhat.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx, Black_David@emc.com

> On Mon, 2008-11-10 at 19:31 +1100, Dave Chinner wrote:
> > On Sun, Nov 09, 2008 at 10:40:24PM -0500, Black_David@emc.com wrote:
> > > There will be a chunk size value available in a VPD page that can
be
> > > used to determine minimum size/alignment.  For openers, I see
essentially
> > > no point in a 512-byte UNMAP, even though it's allowed by the
standard -
> > > I suspect most arrays (and many SSDs) will ignore it, and ignoring
> > > it is definitely within the spirit of the proposed T10 standard
(hint:
> > > I'm one of the people directly working on that proposal).
> >
> > I think this is the crux of the issue. IMO, it's not much of a
standard
> > when the spirit of the standard is to allow everyone to implement
> > different, non-deterministic behaviour....
> 
> I disagree. The discard request is a _hint_ from the upper layers, and
> the storage device can act on that hint as it sees fit. There's
nothing
> wrong with that; it doesn't make it "not much of a standard".

Bingo!  That is exactly the spirit and thinking behind the UNMAP
proposal.

Besides, UNMAP is already inherently non-deterministic in that only the
device knows what value will result from reading an unmapped block
(unless the "unmapped blocks always read as zero" bit is set by the
device).

[... snip ...]

> So I think it's perfectly acceptable for the operating system to treat
> discard requests as a hint, with best-effort semantics. And any device
> which _really_ cares will need to make sure for _itself_ that it
handles
> those hints reliably.

I agree, at least to the extent that the device makes sure make sure
that it reliably handles the hints that it cares about.

Thanks,
--David
----------------------------------------------------
David L. Black, Distinguished Engineer
EMC Corporation, 176 South St., Hopkinton, MA  01748
+1 (508) 293-7953             FAX: +1 (508) 293-7786
black_david@emc.com        Mobile: +1 (978) 394-7754
----------------------------------------------------
