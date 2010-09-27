From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] tcm: Add TPE=1 / UNMAP emulation + passthrough support
Date: Mon, 27 Sep 2010 15:51:17 -0700
Message-ID: <1285627877-6429-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This series adds generic TPE=1 / UNMAP support into TCM Core and TCM/IBLOCK +
TCM/FILEIO subsystem plugin code code to issue blkdev_issue_discard() for
struct block_device that support QUEUE_FLAG_DISCARD.  Using TPE=1 / UNMAP
is also supported with direct struct request passthrough using TCM/pSCSI
and everything required for this to function is included in patch #1.

Patch #1 also includes the addition of the SBC-3 Block Limits VPD (0xb0) page
and adds the following UNMAP related knobs returned into configfs attributes in
/sys/kernel/config/target/core/$HBA/$DEV/attrib, the new ones include:

	*) optimal_sectors (currently set to our ->max_sectors)
	*) max_unmap_block_desc_count (set to 0 by default)
	*) max_unmap_lba_count (set to 0 by default)
	*) unmap_granularity (set to 0 by default)
	*) unmap_granularity_alignment (set to 0 by default)

Patch #2 includes the necessary changes to IBLOCK to detect QUEUE_FLAG_DISCARD
and call transport_generic_unmap() for each UNMAP op.

Patch #3 includes the necessary changes to FILEIO w/ a valid S_ISBLK() to
detect QUEUE_FLAG_DISCARD and call transport_generic_unmap() for each UNMAP
op.  This is the one item I am unsure about, eg: using iget() + iput() to locate
struct block_device for blk_issue_discard()..?  hch..?

So far these patches have been tested with scsi_debug LUNs w/ TPE=1 with both
IBLOCK and FILEIO TPE=1 emulation modes, along with TCM/pSCSI passthrough mode on
v2.6.36-rc4 HVM.  Here is what Block Limits VPD output looks like via TCM_Loop:

	target# sg_inq --page=0xb0 /dev/sdh
	VPD INQUIRY: Block limits page (SBC)
	  Maximum compare and write length: 0 blocks
	  Optimal transfer length granularity: 1 blocks
	  Maximum transfer length: 1024 blocks
	  Optimal transfer length: 1024 blocks
	  Maximum prefetch, xdread, xdwrite transfer length: 0 blocks
	  Maximum unmap LBA count: 0
	  Maximum unmap block descriptor count: 0
	  Optimal unmap granularity: 0
	  Unmap granularity alignment valid: 0
	  Unmap granularity alignment: 0

and with sg_unmap:

	target# sg_unmap -v --lba=78 --num=4 --verbose /dev/sdh
	open /dev/sdh with flags=0x802
	    unmap cdb: 42 00 00 00 00 00 00 00 18 00 
	    unmap parameter list:
	        00 16 00 10 00 00 00 00  00 00 00 00 00 00 00 4e    
	        00 00 00 04 00 00 00 00                         

Comments are welcome!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  tcm: Add Thin Provisioning / UNMAP emulation and Block Limits VPD
    page
  tcm/iblock: Add UNMAP / Block DISCARD support
  tcm/fileio: Add UNMAP / Block DISCARD support

 drivers/target/target_core_configfs.c  |   24 +++++
 drivers/target/target_core_device.c    |   90 +++++++++++++++++++
 drivers/target/target_core_file.c      |   53 +++++++++++-
 drivers/target/target_core_iblock.c    |   19 ++++-
 drivers/target/target_core_transport.c |  152 ++++++++++++++++++++++++++++++++
 include/target/target_core_base.h      |    9 ++-
 include/target/target_core_device.h    |    6 ++
 include/target/target_core_transport.h |   11 +++
 8 files changed, 361 insertions(+), 3 deletions(-)
