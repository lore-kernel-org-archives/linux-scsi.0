From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] scsi_scan: Restrict sequential scan to 256 LUNs
Date: Thu, 27 Mar 2014 07:49:26 -0700
Message-ID: <20140327144926.GB16958@infradead.org>
References: <1386673515-87133-1-git-send-email-hare@suse.de>
 <1386673515-87133-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbaC0Ot1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2014 10:49:27 -0400
Content-Disposition: inline
In-Reply-To: <1386673515-87133-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Tue, Dec 10, 2013 at 12:05:12PM +0100, Hannes Reinecke wrote:
> Sequential scan for more than 256 LUNs is very fragile as
> LUNs might not be numbered sequentially after that point.
> 
> SAM revisions later than SCSI-3 impose a structure on
> LUNs larger than 256, making LUN numbers between 256
> and 16384 illegal.
> SCSI-3, however allows for plain 64-bit numbers with
> no internal structure.
> 
> So restrict sequential LUN scan to 256 LUNs and add a
> new blacklist flag 'BLIST_SCSI3LUN' to scan up to
> max_lun devices.

What do you need the blacklist flag for?  There's no user of it, and
supporting that many LUNs without REPORT LUNS support doesn't sound very
practical anyway.
