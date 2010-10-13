From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/5] tcm: Unify subsystem plugin control CDB emulation
Date: Wed, 13 Oct 2010 01:47:43 -0700
Message-ID: <1286959663-3402-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:20118 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753203Ab0JMIrs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2010 04:47:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings folks,

This patch series pushes the remaining SPC-3 control path CDB emualation for
INQUIRY, READ_CAPACITY_*, UNMAP and WRITE_SAME w/ UNMAP=1, and SYNCHRONIZE_CACHE_*
subsystem plugin handling into generic TCM code.

It follows Christoph's recommendation to pick off the non SCF_SCSI_DATA_SG_IO_CDB
struct se_tasks before hitting struct se_subsysem_api->do_task(), and removal of
struct se_subsystem_api_cdb initially added in commit 3712c6da407.

So far this has been tested with TCM/IBLOCK and TCM/FILEIO subsystem plugins on
v2.6.36-rc7 x86 HVM with sg_inquiry, sg_readcap, sg_unmap, sg_write_same -[ST] -U,
and sg_sync.

Thanks again go out to hch for pushing for IBLOCK and FILEIO to become drivers/scsi
independent and save yet another ~80 LOC from the v4.0 tree!  Thanks Christoph!!!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (5):
  tcm: Move transport_emulate_control_cdb() into
    __transport_execute_tasks()
  tcm: Unify INQUIRY subsystem plugin handling
  tcm: Unify READ_CAPACITY_* subsystem plugin handling
  tcm: Unify UNMAP and WRITE_SAME w/ UNMAP=1 subsystem plugin handling
  tcm: Unify SYNCHRONIZE_CACHE_* subsystem plugin handling

 drivers/target/target_core_file.c      |  101 +++++++++++------------------
 drivers/target/target_core_iblock.c    |  113 ++++++++++++--------------------
 drivers/target/target_core_rd.c        |   89 ++++++++-----------------
 drivers/target/target_core_transport.c |  111 ++++++++++++++++---------------
 include/target/target_core_transport.h |   48 ++++++++------
 5 files changed, 193 insertions(+), 269 deletions(-)

