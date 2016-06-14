From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC-v2 00/11] nvmet: Add support for multi-tenant configfs
Date: Tue, 14 Jun 2016 16:52:43 +0200
Message-ID: <20160614145243.GA29949@lst.de>
References: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46032 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbcFNOwq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2016 10:52:46 -0400
Content-Disposition: inline
In-Reply-To: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>

On Tue, Jun 14, 2016 at 04:35:35AM +0000, Nicholas A. Bellinger wrote:
> Comments..?

Still no good reason for doing anything like this.

On a conceptual level:

The NVMe target is front end implementing a simple protocol to export
block devices to a remove host.  The SCSI target is larger front end to
expose a more complex protocol to remote hosts.  None of them should
actually implement any real protocol independent behavior, and except for
persistent reservations in the SCSI neither of them does.

On a practical level it means we drag in over 25.000 lines of code
as a dependency, without actually dropping any code in the nvmet module,
and vastly more complicated object hierarchies that don't make any
sense for the tight-knit NVMe standard.  We'd also get dragged into
into the nightmare of diverging an incompatible user space tooling,
and we'd lose all the test coverage we've built up.  We'd also have
to deal with tons of tunables that neither fit the protocol we
implement nor the philosophy of the project.




