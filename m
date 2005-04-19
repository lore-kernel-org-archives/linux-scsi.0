From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Can a non-sg scsi write command be more than PAGE_SIZE length?
Date: Tue, 19 Apr 2005 09:14:33 -0500
Message-ID: <1113920073.4998.9.camel@mulgrave>
References: <20050419084730.GA96767@dspnet.fr.eu.org>
	 <20050419085008.GA9194@infradead.org>
	 <20050419092431.GA98975@dspnet.fr.eu.org>
	 <20050419092926.GA9785@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:5771 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261537AbVDSOOk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 10:14:40 -0400
In-Reply-To: <20050419092926.GA9785@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Olivier Galibert <galibert@pobox.com>, "Hack inc." <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-04-19 at 10:29 +0100, Christoph Hellwig wrote:
> Good question actually.  I know XFS does passed vmalloc'ed memory down
> the block I/O path, but that's as a scatter/gather request.  All non-s/g
> request should be contingous I think.
> 
> We really need to write down the rules about what memory can be passed
> down the block I/O path - XFS for example sends kmalloced memory down
> which all the iSCSI implementations don't like at all.

We have two rules and two cases in every driver: sg and non-sg.  (i.e.
use_sg == 0)  this is where we do the distinction between dma_map_sg and
dma_map_single.

If someone wants a project, it should be possible to eject our non-sg
path.  This would mean that all requests go as sg through the block
layer.  The advantages would be

1) internally we would no longer care about kmalloc vs vmalloc memory
2) we wouldn't need to know the gfp flag when allocating internal
requests (block would bounce for us if necessary) thus we could kill the
scsi isa dma flag
3) We could strip the special casing out of every driver ...
4) it should simplify the I/O traversal paths

James


