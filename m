From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Tue, 04 Jan 2005 08:55:59 -0600
Message-ID: <1104850560.5327.6.camel@mulgrave>
References: <B51CDBDEB98C094BB6E1985861F53AF302DE45@nkse2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:10172 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261683AbVADO41 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 09:56:27 -0500
In-Reply-To: <B51CDBDEB98C094BB6E1985861F53AF302DE45@nkse2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-01-04 at 10:29 +0100, Leubner, Achim wrote:
> You are right, in gdth_fill_raw_command() the driver is doing two
> different dma mappings, one for the data buffer stored in
> SCp.dma_handle, and the second for the sense buffer stored in SCp.buffer
> and host_scribble. So reuse of dma_handle does not work here.
> And, you are right, this is ugly and brittle, but there is no remaining
> space in the SCp scratch area to save the second dma mapping.  
> The other patches look fine for me, thanks. But what's the reason to
> remove the support of 2.2.x and 2.4.x without the full dma API?

Well, most other drivers don't have this problem.

The sense buffer is only used to communicate sense if the command fails
with a check condition.  The point being that you only have either the
command or the request sense active, so you can do the mappings
sequentially.  It's a bit of a waste of dma mapping space to map both
the request buffer and the sense buffer for every command that comes in.

Is it not possible to modify gdth to do the mappings sequentially and
only if the initial command gets the check condition?

James


