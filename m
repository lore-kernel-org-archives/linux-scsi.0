From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC PATCH] scsi: fix oops in scsi_uninit_cmd()
Date: Wed, 13 Mar 2019 16:51:17 -0700
Message-ID: <1552521077.45180.119.camel@acm.org>
References: <20190219072743.13606-1-yanaijie@huawei.com>
         <1550595388.31902.133.camel@acm.org> <20190220151836.GA11695@infradead.org>
         <10ea95ec-e259-3511-44c4-58e4d255eb9f@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <10ea95ec-e259-3511-44c4-58e4d255eb9f@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, Christoph Hellwig <hch@infradead.org>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Steffen Maier <maier@linux.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2019-02-21 at 16:53 +-0800, Jason Yan wrote:
+AD4 On 2019/2/20 23:18, Christoph Hellwig wrote:
+AD4 +AD4 +AFs-fullquote removed, please follow proper mail etiquette+AF0
+AD4 +AD4 
+AD4 +AD4 On Tue, Feb 19, 2019 at 08:56:28AM -0800, Bart Van Assche wrote:
+AD4 +AD4 +AD4 regression in the SCSI sd driver due to the switch from the legacy block
+AD4 +AD4 +AD4 layer to scsi-mq. The above patch introduces two atomic operations in the
+AD4 +AD4 +AD4 hot path and hence would introduce a performance regression. I think this
+AD4 +AD4 +AD4 can be avoided by making sure that sd+AF8-uninit+AF8-command() gets called before
+AD4 +AD4 +AD4 the request tag is freed. What changes would be required to make the block
+AD4 +AD4 +AD4 layer core call sd+AF8-uninit+AF8-command() before the request tag is freed? Would
+AD4 +AD4 +AD4 introducing prep+AF8-rq+AF8-fn and unprep+AF8-rq+AF8-fn callbacks in struct blk+AF8-mq+AF8-ops and
+AD4 +AD4 +AD4 making sure that the SCSI core sets these callback function pointers
+AD4 +AD4 +AD4 appropriately be sufficient? Would such a change allow to simplify the NVMe
+AD4 +AD4 +AD4 initiator driver? Are there any alternatives to this approach that are more
+AD4 +AD4 +AD4 elegant?
+AD4 +AD4 
+AD4 +AD4 Additional indirect calls in the I/O fast path is something I'd rather
+AD4 +AD4 avoid.  But I don't fully understand the problem yet - where do
+AD4 +AD4 we release a disk reference from blk+AF8-update+AF8-request?  
+AD4 
+AD4 When userspace close the fd after blk+AF8-update+AF8-request() and before
+AD4 scsi+AF8-mq+AF8-uninit+AF8-cmd(), a disk reference will be released. It is not the
+AD4 blk+AF8-update+AF8-request() directly released it.
+AD4 
+AD4 close
+AD4     -+AD4-sd+AF8-release
+AD4        -+AD4-scsi+AF8-disk+AF8-put
+AD4          -+AD4-scsi+AF8-disk+AF8-release
+AD4            -+AD4-disk-+AD4-private+AF8-data +AD0 NULL+ADs
+AD4 
+AD4 The userspace can close the fd because blk+AF8-update+AF8-request() returned the
+AD4 last IO , the userspace application does not have to stuck on read() or
+AD4 write(). The window is very small, but it can be reproduce every day
+AD4 in our testcases. So I'm very curious why. One possible explanation is
+AD4 that we enabled kernel preempt(CONFIG+AF8-PREEMPT).
+AD4 
+AD4 And why can't we move that release to +AF8AXw-blk+AF8-mq+AF8-end+AF8-request?

Hi Jason,

What is the current status of this issue?

Thanks,

Bart.
