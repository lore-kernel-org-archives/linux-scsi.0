From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Tue, 04 Jan 2005 10:32:41 +0100
Message-ID: <1104831161.4215.17.camel@laptopd505.fenrus.org>
References: <B51CDBDEB98C094BB6E1985861F53AF302DE45@nkse2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:22034 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S261582AbVADJcy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 04:32:54 -0500
In-Reply-To: <B51CDBDEB98C094BB6E1985861F53AF302DE45@nkse2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-01-04 at 10:29 +0100, Leubner, Achim wrote:
> You are right, in gdth_fill_raw_command() the driver is doing two
> different dma mappings, one for the data buffer stored in
> SCp.dma_handle, and the second for the sense buffer stored in SCp.buffer
> and host_scribble. So reuse of dma_handle does not work here.

Is there a way the driver can get rid of looking at the sense buffer at
all and let the midlayer do this ?

> And, you are right, this is ugly and brittle, but there is no remaining
> space in the SCp scratch area to save the second dma mapping.  
> The other patches look fine for me, thanks. But what's the reason to
> remove the support of 2.2.x and 2.4.x without the full dma API?

ifdefs like that for really old kernels significantly clutter up the
driver and make fixing other things in it really really hard.


