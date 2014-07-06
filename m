From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: break from queue depth adjusting loops when
	device found
Date: Sun, 6 Jul 2014 11:49:37 +0200
Message-ID: <20140706094937.GA29045@lst.de>
References: <20140703150557.21608.37072.stgit@beardog.cce.hp.com> <20140703171106.GA16788@lst.de> <53B6878C.502@suse.de> <94D0CD8314A33A4D9D801C0FE68B402958B86659@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45790 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaGFJtm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jul 2014 05:49:42 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B86659@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>

On Fri, Jul 04, 2014 at 07:21:52PM +0000, Elliott, Robert (Server Storage) wrote:
> Perhaps the SCSI midlayer should keep track of both
> SCSI target port and logical unit queue depths, parse
> the status qualifier if present, and let the host
> template advise on the policy to assume if the
> status qualifier is not present.

We already keep track of the target queue depth, although with the
scsi-mq series this is not optional and only done for hosts that declare
they have a per-target queue limit by setting ->can_queue in the
scsi_target structurue.  Only a small number of iSCSI offload HBAs does
this.

I need to look at the SAM scope defintions, but it doesn't sound too hard
to implement.

> There is some code for a scsi_target structure that I 
> don't understand and have just been ignoring: target_busy, 
> target_blocked, etc.  Does that represent the SCSI target 
> port over multiple logical units, or does that relate to 
> target-mode where the system is acting as the SCSI target 
> and presenting logical units itself?

It represents the target port, and is not related to target mode support at
all.  The target mode code uses completely different data structures than
the initiator side mid layer.

