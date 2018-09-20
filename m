From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH RFC] scsi: ufs: Disable blk-mq for now
Date: Thu, 20 Sep 2018 08:58:04 +0200
Message-ID: <20180920065804.GC13761@lst.de>
References: <20180913112848.7807-1-adrian.hunter@intel.com> <20180913120459.GA4965@ming.t460p> <e4d0c716-006a-72cb-0240-4ae5749b21b8@intel.com> <20180914015237.GC11059@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180914015237.GC11059@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Evan Green <evgreen@chromium.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Janek Kotas <jank@cadence.com>, Vivek Gautam <vivek.gautam@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Sayali Lokhande <sayalil@codeaurora.org>, Li Wei <liwei213@huawei.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, Jaegeu
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 14, 2018 at 09:52:38AM +0800, Ming Lei wrote:
> However, in previous discussion, it is strongly objected to use
> per-driver/device .use_blk_mq switch, so not sure if this way can
> be accepted.

I don't like the per-driver switch as module_parameter at all and
we should never do that.  We had some exceptions for drivers to force
blk_mq (e.g. virtio), and given that I don't think we'll solve the
blk-mq runtime-pm issue for 4.19 and also don't want to revert the
default I think this patch is the best compromise for 4.19, with
a revert in 4.20 once we have runtime-pm for blk-mq.

So:

Acked-by: Christoph Hellwig <hch@lst.de>
