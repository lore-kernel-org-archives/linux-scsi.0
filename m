From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: 06 Sep 2004 10:34:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094481264.2149.14.camel@mulgrave>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange>
	<20040904140102.A15247@infradead.org>
	<Pine.LNX.4.60.0409050022570.3092@poirot.grange>
	<20040904233835.A18659@infradead.org>
	<Pine.LNX.4.60.0409051654460.3039@poirot.grange>
	<1094398979.10977.9.camel@mulgrave> <20040905173134.A31521@infradead.org>
	<Pine.LNX.4.60.0409052157540.2062@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:29370 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267393AbUIFOe3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Sep 2004 10:34:29 -0400
In-Reply-To: <Pine.LNX.4.60.0409052157540.2062@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-09-05 at 16:19, Guennadi Liakhovetski wrote:
> >> 1) remove the inquiry snooping and believe the flags in struct
> >> scsi_device instead
> 
> ...and use tags set up by the block layer...

Well, yes, that too ... it depends how much time anyone has to spend on
this driver.

> >> 2) Don't turn on TCQ until slave_configure()
> 
> Well, this alone wouldn't help with this specific problem, exactly because 
> INQUIRY can be sent later too. Or would the mid-layer completely disable 
> tagging for such a disk?

The bug report claims 2.4 works, so probably there the device itself
will still screw up if another inquiry were sent as part of the tagged
stream, I think (perhaps it doesn't, someone needs to check). However,
turning on TCQ in slave_configure() will mean that the two initial
inquiries are sent untagged, so it will only manifest in 2.6 in the same
circumstances as 2.4.

James


