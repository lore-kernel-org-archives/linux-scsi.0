From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] tcm/iblock: SCSI LBA -> block_lba conversion for non 512-byte block_size
Date: Fri, 20 Aug 2010 02:06:39 -0700
Message-ID: <1282295199-8838-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:22191 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751427Ab0HTJGp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2010 05:06:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings hch, Jens and Co,

This patch adds support for TCM/IBLOCK backstores doing proper non 512-byte native TCM
struct se_task SCSI LBA conversion into 512-byte units in iblock_map_task_SG() for the
starting and subsequent struct bio->bi_sector going into bio_add_page().  The second patch
converts the same function to use for_each_sg() to follow mainline SGL walking conventions.

So far I have been testing these two with TCM_Loop virtual SCSI on top and scsi_debug
below with non 512-byte sector_sized struct scsi_devices, which now appears to be
functioning as expected.  I will need to test this with more combinations of scsi_debug
max_sectors (and will need a patch to make that a module parameter too.. ;) to ensure
N struct se_task mapping in transport_do_se_mem_map() -> transport_map_mem_to_sg() is
functioning as expected for these > 512-byte block_size / sector_size cases.

Please have a look at let me know what you think, and please let me know if there is
anything else that should be considered for this one.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  tcm/iblock: Add SCSI LBA -> block_lba conversion for non 512-byte
    block_size
  tcm/iblock: Convert iblock_map_task_SG() to use for_each_sg()

 drivers/target/target_core_iblock.c |   50 +++++++++++++++++++++++-----------
 1 files changed, 34 insertions(+), 16 deletions(-)

