From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: 05 Sep 2004 18:22:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094422949.10977.15.camel@mulgrave>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange>
	<20040904140102.A15247@infradead.org>
	<Pine.LNX.4.60.0409050022570.3092@poirot.grange>
	<20040904233835.A18659@infradead.org>
	<Pine.LNX.4.60.0409051654460.3039@poirot.grange>
	<1094398979.10977.9.camel@mulgrave>  <20040905173134.A31521@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:48358 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267298AbUIEWWe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Sep 2004 18:22:34 -0400
In-Reply-To: <20040905173134.A31521@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-09-05 at 12:31, Christoph Hellwig wrote:
> Umm yes.  But lets get the driver no oops first and then move forward.
> There's still a lot of work to do on the driver.

Well, OK.  I agree to putting a palliative fix in, since what I
suggested will probably take more thought, but I don't think this one is
actually it.  Mixing tagged and untagged commands is illegal under the
SCSI spec.  Simply untagging the INQUIRY command may work to fix this
particular bug, but I bet it will introduce others when a scsi utility
sends an INQUIRY down to an in-use device.

I think perhaps the correct palliative fix is simply to list this device
(whatever it is, it's not listed in the bug report) as BLIST_NOTQ, then
the problem won't arise (and of course, tmscsim would have actually to
use the mid-layer black list rather than its own much shorter internal
list).

James


