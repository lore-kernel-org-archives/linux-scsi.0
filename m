From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] tcm: TPE/TPU -> Block Discard emulation updates for v4.0.0-rc5
Date: Wed, 29 Sep 2010 14:20:45 -0700
Message-ID: <1285795245-30895-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:29083 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751952Ab0I2VUs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2010 17:20:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This series adds some follow up TPE/TPU emulation patches for TCM Core
and IBLOCK + FILEIO -> Block Discard emulation.

The first renames the current DEV_ATTRIB(dev)->emulate_tpe configfs attr to an
explict signaling of UNMAP emulation support with DEV_ATTRIB(dev)->emulate_tpu.
This was done because the meaning of TPE=1 will be changing in future SBC3 specs,
and we need to support both TPU and TPWS for TCM/IBLOCK and TCM/FILEIO subsystem
plugins.

The second adds support for INQUIRY EVPD Thin Provisioning VPD (0xb2) emulation
for IBLOCK + FILEIO backstores w/ blk_queue_discard()=1 following mkp's
recommendation.

The third adds support for filling in the proper max_unmap_lba_count,
max_unmap_block_desc_count, unmap_granularity, and unmap_granularity_alignment
from generic struct request_queue->limits values reported by the underlying
SCSI (TPU/TPWS) and SATA (TRIM) HW accordingly.

So far these patches have been tested with TCM_Loop -> TCM/IBLOCK -> scsi_debug
backstores, and sg_vpd output has been included in the second and third patches
for reference.

Many, many thanks to Martin Petersen for answering questions wrt to
TPE/TPU/TPWS -> Block Discard translation and EVPD 0xb2 THRESHOLD EXPONENT usage!

Thanks mkp!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  tcm: Rename device attribute emulate_tpe to emulate_tpu
  tcm: Add Thin Provisioning VPD page emulation
  tcm/iblock,fileio: Fill in remaining Block Limits VPD from rq->limits

 drivers/target/target_core_configfs.c  |    6 ++--
 drivers/target/target_core_device.c    |    8 +++---
 drivers/target/target_core_file.c      |   18 +++++++++++-
 drivers/target/target_core_iblock.c    |   19 +++++++++++--
 drivers/target/target_core_transport.c |   44 +++++++++++++++++++++++++++----
 include/target/target_core_base.h      |    2 +-
 include/target/target_core_device.h    |    2 +-
 include/target/target_core_transport.h |    4 +-
 8 files changed, 81 insertions(+), 22 deletions(-)

