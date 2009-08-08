From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] [Target_Core_Mod/pSCSI]: Updates for v2.6.31-rc
Date: Sat, 08 Aug 2009 13:11:40 -0700
Message-ID: <1249762301.11105.213.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n12b.bullet.mail.mud.yahoo.com ([209.191.125.179]:44496 "HELO
	n12b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753177AbZHHURq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2009 16:17:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Greetings,

The following are patches for v2.6.31-rc5 to get the TCM/pSCSI subsystem plugin
running again.

The first patch converts TCM/pSCSI to use the new blk_make_request() (Thanks Boaz!)
to map physical memory (struct page) -> struct bio -> struct request for
SCF_SCSI_DATA_SG_IO_CDB type I/O.  This is done by using bio_kmalloc() to obtain
struct bio, and each struct page is  set using bio_add_pg_page() in pscsi_map_task_SG().
If the received CDB's payload exceeds BIO_MAX_PAGES, bio_kmalloc() will be called again
and the bios will be chained together before calling blk_make_request() and
pscsi_blk_init_request() to complete initialization of the struct request.

The second patch removes a call to dev_get_drvdata() for TYPE_ROM that previously
had been obtaining struct scsi_cd to access struct gendisk for passing into
blk_execute_rq_nowait().  This had been causing an OOPs on v2.6.31-rc5 with physical
TYPE_ROM, so it has been removed and blk_execute_rq_nowait() seems to work fine w/o
the struct gendisk pointer for TYPE_ROM.

Boaz and co, any comments you can make on the blk_make_request() usage in Patch 1
is greatly apperciated.

--nab

[PATCH 1/2] [Target_Core_Mod/pSCSI]: Use blk_make_request() in v2.6.31-rc
[PATCH 2/2] [Target_Core_Mod/pSCSI]: Fix bug with struct scsi_cd access for blk_execute_rq_nowait()

 drivers/target/target_core_pscsi.c |  134 ++++++++++++++++++++++-------------
 1 files changed, 84 insertions(+), 50 deletions(-)



