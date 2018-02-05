From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/8] blk-mq/scsi-mq: support global tags & introduce force_blk_mq
Date: Mon,  5 Feb 2018 23:20:27 +0800
Message-ID: <20180205152035.15016-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi All,

This patchset supports global tags which was started by Hannes originally:

	https://marc.info/?l=linux-block&m=149132580511346&w=2

Also inroduce 'force_blk_mq' and 'host_tagset' to 'struct scsi_host_template',
so that driver can avoid to support two IO paths(legacy and blk-mq), especially
recent discusion mentioned that SCSI_MQ will be enabled at default soon.

	https://marc.info/?l=linux-scsi&m=151727684915589&w=2

With the above changes, it should be easier to convert SCSI drivers'
reply queue into blk-mq's hctx, then the automatic irq affinity issue can
be solved easily, please see detailed descrption in commit log and the
8th patch for converting HPSA.

Also drivers may require to complete request on the submission CPU
for avoiding hard/soft deadlock, which can be done easily with blk_mq
too.

	https://marc.info/?t=151601851400001&r=1&w=2

The 6th patch uses the introduced 'force_blk_mq' to fix virtio_scsi
so that IO hang issue can be avoided inside legacy IO path, this issue is
a bit generic, at least HPSA/virtio-scsi are found broken with v4.15+.

The 7th & 8th patch fixes HPSA's IO issue which is caused by the reply
queue selection algorithem.

Laurence has verified that this patch makes HPSA working with the linus
tree with this patchset.

The V2 can be found in the following tree/branch:

	https://github.com/ming1/linux/commits/v4.15-for-next-global-tags-v2

V2:
	- fix restart code for global tags
	- fixes HPSA's IO hang issue
	- add 'scsi: Add template flag 'host_tagset''
	- reorder patch

Thanks
Ming

Hannes Reinecke (1):
  scsi: Add template flag 'host_tagset'

Ming Lei (7):
  blk-mq: tags: define several fields of tags as pointer
  blk-mq: introduce BLK_MQ_F_GLOBAL_TAGS
  block: null_blk: introduce module parameter of 'g_global_tags'
  scsi: introduce force_blk_mq
  scsi: virtio_scsi: fix IO hang by irq vector automatic affinity
  scsi: hpsa: call hpsa_hba_inquiry() after adding host
  scsi: hpsa: use blk_mq to solve irq affinity issue

 block/bfq-iosched.c        |  4 +--
 block/blk-mq-debugfs.c     | 11 ++++----
 block/blk-mq-sched.c       | 13 ++++++++-
 block/blk-mq-tag.c         | 67 +++++++++++++++++++++++++++++-----------------
 block/blk-mq-tag.h         | 15 ++++++++---
 block/blk-mq.c             | 31 ++++++++++++++++-----
 block/blk-mq.h             |  3 ++-
 block/kyber-iosched.c      |  2 +-
 drivers/block/null_blk.c   |  6 +++++
 drivers/scsi/hosts.c       |  1 +
 drivers/scsi/hpsa.c        | 56 ++++++++++++++++++++++++--------------
 drivers/scsi/scsi_lib.c    |  2 ++
 drivers/scsi/virtio_scsi.c | 59 +++-------------------------------------
 include/linux/blk-mq.h     |  2 ++
 include/scsi/scsi_host.h   |  6 +++++
 15 files changed, 157 insertions(+), 121 deletions(-)

-- 
2.9.5
