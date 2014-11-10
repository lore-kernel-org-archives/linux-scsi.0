From: Christoph Hellwig <hch@infradead.org>
Subject: Re: UNMAP command parameter list
Date: Mon, 10 Nov 2014 09:40:43 -0800
Message-ID: <20141110174043.GA26944@infradead.org>
References: <loom.20141108T001847-741@post.gmane.org>
 <94D0CD8314A33A4D9D801C0FE68B40295937B4CE@G4W3202.americas.hpqcorp.net>
 <loom.20141108T211736-836@post.gmane.org>
 <loom.20141110T164410-58@post.gmane.org>
 <yq17fz36m4o.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45431 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaKJRkr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 12:40:47 -0500
Content-Disposition: inline
In-Reply-To: <yq17fz36m4o.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andras Kovacs <akovacs@fixstars.com>, linux-scsi@vger.kernel.org

On Mon, Nov 10, 2014 at 11:44:39AM -0500, Martin K. Petersen wrote:
> You'll have to traverse scatterlist and extract the descriptor from
> there. You can use scsi_for_each_sg() to walk the list.
> 
> If you only care about in-kernel discards it's pretty easy since we only
> issue a single descriptor. If you want to support arbitrary block pc
> UNMAP commands you'll have to be able to deal with multiple descriptors
> across multiple scatterlist elements. But the accessor macro makes that
> easy so I suggest you take that approach.

Note that if the hardware doesn't actually implement UNMAP and you have
to emulate something you're probably better off emulating WRITE SAME
(16) with the UNMAP bit, as the format is a lot easier to handle,
and it's much better specified to start with.
