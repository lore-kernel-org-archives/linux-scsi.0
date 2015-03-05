From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/43] hpsa: add masked physical devices into h->dev[]
 array
Date: Thu, 5 Mar 2015 05:34:56 -0800
Message-ID: <20150305133456.GA27960@infradead.org>
References: <20150221221553.21954.32599.stgit@brunhilda>
 <20150221221735.21954.24837.stgit@brunhilda>
 <20150223201442.GA11037@infradead.org>
 <07F70BBF6832E34FA1C923241E8833AB38D5D96E@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbbCENe7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2015 08:34:59 -0500
Content-Disposition: inline
In-Reply-To: <07F70BBF6832E34FA1C923241E8833AB38D5D96E@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brace <brace@pmcs.com>
Cc: Christoph Hellwig <hch@infradead.org>, Scott Teel <Scott.Teel@pmcs.com>, Kevin Barnett <Kevin.Barnett@pmcs.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, Justin Lindley <Justin.Lindley@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Feb 26, 2015 at 03:17:38PM +0000, brace wrote:
> Thanks, I corrected the code. Also, I asked Webb about setting up the queue
> Depth in slave_alloc. His reply was " We needed to get tagging set up during allocation so that we could use it in the lead-up to configuration, which is why it was done in hpsa_slave_alloc(); and, given that the code there was then already messing about with queue depth, it made sense to also deal with the rest of it there."
> 
> But given your next comment, perhaps I need to clean this up more?

I think so.  In older kernel we indeed had horrible APIs that mixed
setting up tagging with the queue depth, but this has all been sorted
out, so setting the queue depth in slave_alloc should not be nessecary
now.
