From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH RFC] scsi: ufs: Disable blk-mq for now
Date: Fri, 14 Sep 2018 09:52:38 +0800
Message-ID: <20180914015237.GC11059@ming.t460p>
References: <20180913112848.7807-1-adrian.hunter@intel.com>
 <20180913120459.GA4965@ming.t460p>
 <e4d0c716-006a-72cb-0240-4ae5749b21b8@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e4d0c716-006a-72cb-0240-4ae5749b21b8@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Evan Green <evgreen@chromium.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Janek Kotas <jank@cadence.com>, Vivek Gautam <vivek.gautam@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Sayali Lokhande <sayalil@codeaurora.org>, Li Wei <liwei213@huawei.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, Jaegeuk Kim <jaegeuk@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 13, 2018 at 03:15:39PM +0300, Adrian Hunter wrote:
> On 13/09/18 15:05, Ming Lei wrote:
> > On Thu, Sep 13, 2018 at 02:28:48PM +0300, Adrian Hunter wrote:
> >> blk-mq does not support runtime pm, so disable blk-mq support for now.
> > 
> > So could you describe a bit what the issue you are trying to fix?
> 
> UFS is a low-power solution, so we must be able to runtime suspend.
> 
> > 
> > This is host level runtime PM you are trying to address, and if blk-mq
> > runtime isn't enabled, I guess the host won't be runtime suspended at all
> > because some of its descendant are always active.
> > 
> > So seems we need to do nothing for preventing the host controller from
> > entering runtime suspend.
> 
> We don't want to prevent the host controller from runtime suspending, quite
> the opposite.

OK, got it.

However, in previous discussion, it is strongly objected to use
per-driver/device .use_blk_mq switch, so not sure if this way can
be accepted.

BTW, I just posted the runtime PM enablement patches[1] for blk-mq,
and I verified that it works fine and passed blktests & xfstest & my
other sanity tests, could you try it on UFS?

[1] https://marc.info/?l=linux-block&m=153684095523409&w=2

Thanks,
Ming
