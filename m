From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Thu, 21 Aug 2014 14:57:44 -0700
Message-ID: <20140821215744.GA29651@infradead.org>
References: <Pine.LNX.4.44L0.1408211326070.918-100000@iolanthe.rowland.org>
 <yq1bnrdr01e.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57636 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbaHUV54 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2014 17:57:56 -0400
Content-Disposition: inline
In-Reply-To: <yq1bnrdr01e.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Christoph Hellwig <hch@infradead.org>, Douglas Gilbert <dgilbert@interlog.com>, Tiziano Bacocco <tiziano.bacocco@gmail.com>, bugzilla-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Thu, Aug 21, 2014 at 05:43:41PM -0400, Martin K. Petersen wrote:
> Alan> Okay, here's a patch that implements the suggestion, except that I
> Alan> put the flag in the Scsi_Host structure instead of the template.
> Alan> This was to minimize the impact of the change.  Among the various
> Alan> SCSI-over-USB transports, only the Bulk-Only transport gives the
> Alan> LUN separately from the CDB.  I don't know if there are any
> Alan> multi-LUN USB devices that don't use the Bulk-Only transport, but
> Alan> if there are then they won't work if the LUN isn't stored in
> Alan> CDB[1].
> 
> I'm in agreement with this approach.

I like it too. One idea to unclutter the fastpath would be to have a
single flag that controls if the LUN is set which is based on the
host(-template) flag and the scsi level, which would allow us to remove
all the clutter around that area.
