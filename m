From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: compile warning fix for advansys (trivial)
Date: Tue, 30 Dec 2003 23:32:26 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0312302319320.5614-100000@poirot.grange>
References: <20031228232831.A23869@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:32735 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265896AbTL3Wcb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2003 17:32:31 -0500
In-Reply-To: <20031228232831.A23869@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Sun, 28 Dec 2003, Christoph Hellwig wrote:

> On Mon, Dec 29, 2003 at 12:26:39AM +0100, Guennadi Liakhovetski wrote:
> > I think, the patch would only be wrong if either the original driver
> > behaviour was wrong in the race-case,
>
> it was.  That's why we're changing it after all :)

Ok, then, I think, the driver is doing the following: for ISA / VL busses
it does check_region for ASC_IOADR_GAP (16) bytes, does chip-detection,
and if a card is found - then issues request_region() with the correct
length.

So, I see 2 possibilities:
1) replace check_region with request_region for the same size, and then
release the region before requesting the correct size. (Well,
theoretically, one could request the rest of the larger area in a second
request_region, but that's pretty ugly)
2) replace check_region with request_region - but immediately of correct
length. Finding this correct length involves identifying the chip... But,
reading the code, it looks like only 38C-1600 can be used in ISA and VL
cards, right? Sorry, I didn't find any data sheets.

Which of the 2 options (or a third one) would be preferrable, and is my
assumption about the 1600 chip correct? The first one is easier to
implement. Ideally, one should properly identify the chip and then request
the required number of bytes, of course.

Thanks
Guennadi
---
Guennadi Liakhovetski


