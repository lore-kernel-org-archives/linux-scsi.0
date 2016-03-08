From: Christoph Hellwig <hch@lst.de>
Subject: Re: -EAGAIN and -ENOMEM from ->bi_end_io, was Re: [PATCH-v2 2/2]
	target/iblock: Use -EAGAIN/-ENOMEM to propigate SAM
	BUSY/TASK_SET_FULL
Date: Tue, 8 Mar 2016 08:04:36 +0100
Message-ID: <20160308070436.GA14927@lst.de>
References: <1457161634-15756-1-git-send-email-nab@daterainc.com> <1457161634-15756-2-git-send-email-nab@daterainc.com> <20160305210108.GA16337@lst.de> <1457218287.28660.70.camel@haakon3.risingtidesystems.com> <20160306061910.GA1116@infradead.org> <1457301315.32532.12.camel@haakon3.risingtidesystems.com> <20160307075548.GB13884@lst.de> <1457337836.10643.2.camel@haakon3.risingtidesystems.com> <20160307161854.GA25341@lst.de> <1457390369.30747.28.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41787 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbcCHHEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2016 02:04:40 -0500
Content-Disposition: inline
In-Reply-To: <1457390369.30747.28.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Andy Grover <agrover@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, axboe@kernel.dk, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Mar 07, 2016 at 02:39:29PM -0800, Nicholas A. Bellinger wrote:
> > I explicitly wrote "as-is".  We need a way to opt into this behavior,
> > and we also somehow need to communicate the timeout.
> 
> What did you have in mind..?

You need an interface to tell the driver that it can return a timeout
status, and preferably also set the actual timeout.   The obvious
candidate would be a new method on the queue to set a user timeout,
and if one is set we could get these errors back.
