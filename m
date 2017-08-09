From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [RFC PATCH 0/6] bsg: fix regression resulting in panics when sending commands via BSG and some sanity cleanups
Date: Wed,  9 Aug 2017 16:11:14 +0200
Message-ID: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Steffen Maier <maier@linux.vnet.ibm.com>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

Hello all,

Steffen noticed recently that we have a regression in the BSG code that
prevents us from sending any traffic over this interface. After I
researched this a bit, it turned out that this affects not only zFCP, but
likely all LLDs that implements the BSG API. This was introduced in 4.11
(details in Patch 1 of this series).

I imagine the regression happened because of some very "unfortunate"
variable- namings. I can not fix them, as they involve the base struct
request, but I tried to add some cleanups that should make the
relationships between stuff more visible in the future I hope.

Patch 1   - Regression Fix; Also tagged for stable
Patch 2-6 - Cleanups

I tagged this as RFC. Patches 2-6 are a 'nice to have' IMO, Patch 1 is
obviously necessary, and if it is OK, I can re-send it separately if
necessary. If you don't like the changes in the other patches, I don't mind
dropping them.

I am not sure about Patch 4. It certainly works, but it changes
user-visible behavior, in what I believe is within the behavior described
by the SG interface. It makes the different methods of how BSG passes
commands down to the LLDs more conform with each other - even though I
can't make them the exact same. More details in the patch description.

I rebased the series on Jens' for-next and I have function-tested the
series on s390x's zFCP with the tools provided in the zfcp HBA API library
(https://www.ibm.com/developerworks/linux/linux390/zfcp-hbaapi.html) and
some custom code to test the read/write interface of BSG.

Reviews are more than welcome :)


                                                Beste Grüße / Best regards,
                                                  - Benjamin Block

Benjamin Block (6):
  bsg: fix kernel panic resulting from missing allocation of a
    reply-buffer
  bsg: assign sense_len instead of fixed SCSI_SENSE_BUFFERSIZE
  bsg: scsi-transport: add compile-tests to prevent reply-buffer
    overflows
  bsg: refactor ioctl to use regular BSG-command infrastructure for
    SG_IO
  bsg: reduce unecessary arguments for bsg_map_hdr()
  bsg: reduce unecessary arguments for blk_complete_sgv4_hdr_rq()

 block/bsg-lib.c                     |  4 +-
 block/bsg.c                         | 90 ++++++++++++++++++++++---------------
 drivers/scsi/scsi_transport_fc.c    |  3 ++
 drivers/scsi/scsi_transport_iscsi.c |  3 ++
 include/linux/bsg-lib.h             |  2 +
 5 files changed, 65 insertions(+), 37 deletions(-)

--
2.12.2
