From: Anton Blanchard <anton@samba.org>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: Mon, 15 Mar 2004 02:18:09 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314151809.GG19737@krispykreme>
References: <20040314082444.GA3416@linux.local.home> <1079275768.2022.1.camel@mulgrave> <20040314145142.GL6955@suse.de> <1079276396.2022.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:7893 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S263363AbUCNPU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 10:20:27 -0500
Content-Disposition: inline
In-Reply-To: <1079276396.2022.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <axboe@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

 
> Actually, to be fair, I think he means the qlogic request queue, not the
> block one.
> 
> The Qla chips are rather weird in that they have a single issue queue
> (whose size you can vary) but whose entry formats are fixed.  If I
> remember correctly, an initial command can have 4 SG elements, but a
> follow on entry can have 7 (not sure of the figures).  But anyway, large
> SG commands end up having to find multiple entries in this queue (and
> being a single issue queue for the entire card, it has to be mutexed
> while you search).  The more resources you need, the more difficult the
> search and the more contention you generate on the resource mutex.

With 2.6.3 on a ppc64 box connected to a shark with 8 LUNs I could
easily consume all the request slots on the card. At this point we spent
> 50% of the cpu bouncing into qla2x00_start_scsi, doing a pci_map_sg
realising it wont fit and doing a pci_unmap_sg.

As Andrew points out, the driver shouldnt be doing this constant
map/unmap stuff, but is there some way for a scsi device driver to tell
the layers above it to temporarily leave it alone?

Anton
