From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: Re: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Tue, 4 Jan 2005 10:29:41 +0000
Message-ID: <20050104102941.GC26051@parcelfarce.linux.theplanet.co.uk>
References: <B51CDBDEB98C094BB6E1985861F53AF302DE45@nkse2k01.adaptec.com> <1104831161.4215.17.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:65193 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261646AbVADK3n
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 05:29:43 -0500
Content-Disposition: inline
In-Reply-To: <1104831161.4215.17.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Leubner, Achim" <Achim_Leubner@adaptec.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 04, 2005 at 10:32:41AM +0100, Arjan van de Ven wrote:
> On Tue, 2005-01-04 at 10:29 +0100, Leubner, Achim wrote:
> > You are right, in gdth_fill_raw_command() the driver is doing two
> > different dma mappings, one for the data buffer stored in
> > SCp.dma_handle, and the second for the sense buffer stored in SCp.buffer
> > and host_scribble. So reuse of dma_handle does not work here.
> 
> Is there a way the driver can get rid of looking at the sense buffer at
> all and let the midlayer do this ?

AFAICS, hardware wants dma_address of that puppy passed to it.  Which might
be a solution of this problem, if that address is not clobbered and can
be read back from where we'd stored it.  But that's a question for hardware
folks - does the value of cmdp->u.{raw,raw64}.sense_data survive until we
get to unmapping stuff in gdth_sync_event()?

In any case, we really should check for failure of pci_map_...() and be
more careful with checking if two areas need to be unmapped...
