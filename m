From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fusion: streamline ->queuecommand
Date: Wed, 6 Oct 2004 17:41:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041006154136.GA28333@lst.de>
References: <0E3FA95632D6D047BA649F95DAB60E5705262196@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:29604 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S269314AbUJFPmH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2004 11:42:07 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5705262196@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, Oct 04, 2004 at 05:33:41PM -0400, Moore, Eric Dean wrote:
> (3) How will a generic negotiation be done for raid volumes?  The MPT driver
> supports RAID levels
> 0, 1, and 0+1.  The driver does DV via RAID passthru to the individual
> devices. 

I've taken a quick look at fusion in that respect.  I think the cleanest
thing would be to add "virtual" scsi_device structures for raid physical
disks, and set the BLIST_NO_ULD_ATTACH flag so we don't get the disk
driver to attach to it.  This would have the added benefit of beeing
able to use the SG_IO passthrough interface even for physical disk in
a raid volume.  To make this work we'd obviously have to add some code
to ->queuecommand to handle this special case.

I think all the other questions have been answered already.
