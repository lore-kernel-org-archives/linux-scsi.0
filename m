From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 2/2] target/iblock: Use -EAGAIN/-ENOMEM to propigate
	SAM BUSY/TASK_SET_FULL
Date: Mon, 7 Mar 2016 08:55:49 +0100
Message-ID: <20160307075548.GB13884@lst.de>
References: <1457161634-15756-1-git-send-email-nab@daterainc.com> <1457161634-15756-2-git-send-email-nab@daterainc.com> <20160305210108.GA16337@lst.de> <1457218287.28660.70.camel@haakon3.risingtidesystems.com> <20160306061910.GA1116@infradead.org> <1457301315.32532.12.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457301315.32532.12.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Andy Grover <agrover@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Mar 06, 2016 at 01:55:15PM -0800, Nicholas A. Bellinger wrote:
> The intended use is for any make_request_fn() based driver that invokes
> bio_endio() completion directly, and sets bi_error != 0 to signal
> non GOOD status to target/iblock.

But -EAGAIN and -ENOMEM are not valid drivers for bio_endio, and as far as I
can tell no driver every returns them.  So as-is this might be well intended
but either useless or broken.
