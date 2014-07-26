From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: break from queue depth adjusting loops when
	device found
Date: Sat, 26 Jul 2014 17:36:12 +0200
Message-ID: <20140726153612.GA6513@lst.de>
References: <20140703150557.21608.37072.stgit@beardog.cce.hp.com> <20140703171106.GA16788@lst.de> <53B6878C.502@suse.de> <94D0CD8314A33A4D9D801C0FE68B402958B86659@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39469 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbaGZPgT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jul 2014 11:36:19 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B86659@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>

I just saw this patch showing up again in the hpsa series, so let's get
the discussiong going on how to proceed again:

I think we can't simply apply the current version as it breaks the intended
semantics in the FC drivers that expect an array with target-wide ressources.

So if we want to go ahead quickly we might just need two versions of it, one
that does LUN-level ramp up/down and one that does target level.

I'd also very much like to be able to use the SAM-4 indicators, but I fear
that a lot of hardware might not be able to get this right.  If anyone
has experience with using those I'd love to hear about it.
