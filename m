From: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Subject: RE: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Tue, 4 Jan 2005 10:29:15 +0100
Message-ID: <B51CDBDEB98C094BB6E1985861F53AF302DE45@nkse2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:22713 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261579AbVADJ3T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 04:29:19 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

You are right, in gdth_fill_raw_command() the driver is doing two
different dma mappings, one for the data buffer stored in
SCp.dma_handle, and the second for the sense buffer stored in SCp.buffer
and host_scribble. So reuse of dma_handle does not work here.
And, you are right, this is ugly and brittle, but there is no remaining
space in the SCp scratch area to save the second dma mapping.  
The other patches look fine for me, thanks. But what's the reason to
remove the support of 2.2.x and 2.4.x without the full dma API?

Thanks,
Achim

----------------------------------------------
Achim Leubner
Research & Development
ICP vortex Computersysteme GmbH
Gostritzer Str. 61-63
D-01217 Dresden, Germany
Phone: +49-351-871-8291
Fax: +49-351-871-8448
Email: achim_leubner@adaptec.com
Web: www.icp-vortex.com



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Dienstag, 4. Januar 2005 09:27
> To: Al Viro
> Cc: James Bottomley; Leubner, Achim; SCSI Mailing List
> Subject: Re: [PATCH] fix gcc warning on 64 bit compile of gdth
> 
> On Mon, Jan 03, 2005 at 10:54:01PM +0000, Al Viro wrote:
> > ... and dma_handle *is* dma_addr_t and gets used in exact same
driver to
> > store the results of the same function (grep for pci_map_page in
there).
> 
> But as it looks do me the driver is doing two different dma mappings
in
> here.

