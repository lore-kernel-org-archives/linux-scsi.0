From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: Fri, 1 Oct 2004 23:46:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041001234606.A9024@infradead.org>
References: <Pine.LNX.4.60.0409051654460.3039@poirot.grange> <1094398979.10977.9.camel@mulgrave> <20040905173134.A31521@infradead.org> <1094422949.10977.15.camel@mulgrave> <Pine.LNX.4.60.0409061042240.6252@poirot.grange> <Pine.LNX.4.60.0409061143020.8550@poirot.grange> <20040906110150.A4845@infradead.org> <Pine.LNX.4.60.0409061400560.1676@poirot.grange> <Pine.LNX.4.60.0410012253460.3951@poirot.grange> <20041001233554.B8853@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:20742 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266663AbUJAWqK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2004 18:46:10 -0400
Content-Disposition: inline
In-Reply-To: <20041001233554.B8853@infradead.org>; from hch@infradead.org on Fri, Oct 01, 2004 at 11:35:54PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Oct 01, 2004 at 11:35:54PM +0100, Christoph Hellwig wrote:
> > +    if (pcmd->cmnd[0] == INQUIRY && 
> > +	(pcmd->result == (DID_OK << 16) || status_byte(pcmd->result) & CHECK_CONDITION) &&
> > +	(ptr->DevType & SCSI_DEVTYPE) != TYPE_NODEV)
> > +	/* device found: add */ 
> > +	pDCB->DevType = ptr->DevType & SCSI_DEVTYPE;
> 
> instead of ptr->DevType you can use the 'device' field in struct scsi_device.
> In fact the dcb DevType field should go away aswell in favour of that one.

And while we're at it: The whole inquiry sniffing in dc390_SRBdone (aka all
uses of ptr and ptr) can easily go away if you kill pDCB->Inquiry7 and check
sdev->sdtr instead.

