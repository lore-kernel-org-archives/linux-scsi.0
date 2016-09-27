From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/9] dm: Fix a race condition related to stopping and
 starting queues
Date: Tue, 27 Sep 2016 09:47:34 +0200
Message-ID: <20160927074734.pbgz4bbb7xpnkxre@linux-x5ow.site>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
 <ba8ddc16-b709-e7fb-1120-b6e1bd393540@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ba8ddc16-b709-e7fb-1120-b6e1bd393540@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 26, 2016 at 11:26:50AM -0700, Bart Van Assche wrote:
> Ensure that all ongoing dm_mq_queue_rq() and dm_mq_requeue_request()
> calls have stopped before setting the "queue stopped" flag. This
> allows to remove the "queue stopped" test from dm_mq_queue_rq() and
> dm_mq_requeue_request(). This patch fixes a race condition because
> dm_mq_queue_rq() is called without holding the queue lock and hence
> BLK_MQ_S_STOPPED can be set at any time while dm_mq_queue_rq() is
> in progress.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
