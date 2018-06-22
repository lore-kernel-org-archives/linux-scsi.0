From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/5]stop normal completion path entering a timeout req
Date: Fri, 22 Jun 2018 17:10:43 +0200
Message-ID: <20180622151043.GA13470@lst.de>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com> <20180620181601.GA24145@localhost.localdomain> <e87f5946-bb21-942e-2dcc-b24cee1ad23c@oracle.com> <20180621081900.GA5183@lst.de> <a68ad043-26a1-d3d8-2009-504ba4230e0f@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a68ad043-26a1-d3d8-2009-504ba4230e0f@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jianchao.wang" <jianchao.w.wang@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, axboe@kernel.dk, martin.petersen@oracle.com, josef@toxicpanda.com, ulf.hansson@linaro.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 21, 2018 at 04:22:22PM +0800, jianchao.wang wrote:
> > Trace, please.  With the latest kernel.  I'm not saying that there
> > is nothing to fix, but the mode of never completing once timeout
> > requests as currently done is SCSI is clearly broken.
> > 
> 
> I didn't find the existing method to simulate this.
> So I modified the scsi-debug as following patch as install it as following:
> modprobe scsi-debug delay=-1 ndelay=-1
> Both 4.17-rc1 and 4.18-rc1 with this patch set could survive from the test.

What tree is this against?  I can't apply it to either current Linus'
tree or 4.17 for that matter.

Also I'm not sure this blk_abort_request call is representative
of the real world.  Drivers do drain their queues before calling
it in general, e.g. take a look at ata_eh_set_pending for the
probably most common user.
