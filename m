From: Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 0/2] scsi: core: regression fixes for request
	batching
Date: Wed,  7 Aug 2019 16:49:46 +0200
Message-ID: <20190807144948.28265-1-maier@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Hannes Reinecke <hare@suse.com>, "Ewan D . Milne" <emilne@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-next@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

Hi James, Martin, Paolo, Ming,

multipathing with linux-next is broken since 20190723 in our CI.
The patches fix a memleak and a severe dh/multipath functional regression.
It would be nice if we could get them to 5.4/scsi-queue and also next.

I would have preferred if such a new feature had used its own
new copy scsi_mq_ops_batching instead of changing the use case and
semantics of the existing scsi_mq_ops, because this would likely
cause less regressions for all the other users not using the new feature.

Steffen Maier (2):
  scsi: core: fix missing .cleanup_rq for SCSI hosts without request
    batching
  scsi: core: fix dh and multipathing for SCSI hosts without request
    batching

 drivers/scsi/scsi_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.17.1
