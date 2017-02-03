From: Christoph Hellwig <hch@lst.de>
Subject: Re: [REGRESSION v4.10-rc1] blkdev_issue_zeroout() returns
        -EREMOTEIO on the first call for SCSI device that doesn't support
        WRITE SAME
Date: Fri, 3 Feb 2017 17:12:39 +0100
Message-ID: <20170203161239.GA3880@lst.de>
References: <cc14c28a-0f0a-640a-b576-cdfbaee75dc5@ce.jp.nec.com> <d360a634-2c95-2de5-8647-4e740e92e10a@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d360a634-2c95-2de5-8647-4e740e92e10a@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 03, 2017 at 08:21:31AM -0700, Jens Axboe wrote:
> > Error 121 (EREMOTEIO) was returned from blkdev_issue_zeroout().
> > That came from sd driver because WRITE SAME was sent to the device
> > which didn't support it.
> > 
> > The problem was introduced by commit e73c23ff736e ("block: add async
> > variant of blkdev_issue_zeroout"). Before the commit, blkdev_issue_zeroout
> > fell back to normal zero writing when WRITE SAME failed and it seems
> > sd driver's heuristics depends on that behaviour.
> 
> CC Christoph and Chaitanya.

And adding Martin as the sd.c Write Same code is his.

I suspect we'll have to restore the old way this works for 4.10 as it's
too late in the cycle, but that whole idea of trying Write Same first
and just disabling it if it doesn't work is a receipe for desaster -
it kinda works for a synchronous blkdev_issue_zeroout, but if we want
to be able to submit it asynchronously it's getting too hairy to handle.

I think we should fix sd.c to only send WRITE SAME if either of the
variants are explicitly listed as supported through
REPORT SUPPORTED OPERATION CODES, or maybe through a whitelist if
there are important enough devices.
