From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: Re: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Mon, 3 Jan 2005 22:54:01 +0000
Message-ID: <20050103225401.GZ26051@parcelfarce.linux.theplanet.co.uk>
References: <1104788704.5506.67.camel@mulgrave> <20050103224321.GY26051@parcelfarce.linux.theplanet.co.uk> <1104792580.5506.69.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:64716 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261933AbVACWyF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jan 2005 17:54:05 -0500
Content-Disposition: inline
In-Reply-To: <1104792580.5506.69.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: achim_leubner@adaptec.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 03, 2005 at 04:49:39PM -0600, James Bottomley wrote:
> On Mon, 2005-01-03 at 22:43 +0000, Al Viro wrote:
> > *UGH*
> > 
> > Why do you play with shoving dma_addr_t into a pair of pointers and
> > then decoding it when you have ->SCp.dma_handle?
> 
> Well, I don't since it's not my driver.
> 
> However, I think the nutcase it's trying to crack is storing dma_addr_t
> on x86 PAE.  There dma_addr_t is wider than a void *.

... and dma_handle *is* dma_addr_t and gets used in exact same driver to
store the results of the same function (grep for pci_map_page in there).
