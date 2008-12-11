From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 00/13] st: remove scsi_execute_async usage (the second half)
Date: Thu, 11 Dec 2008 23:07:37 +0900
Message-ID: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:49527 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074AbYLKOOJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 09:14:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com

This patchset is the second half of the patchset to remove
scsi_execute_async in st driver. IOW, this converts st driver to use
the block layer functions.

st driver uses scsi_execute_async for two purposes, performing sort
management SCSI commands internally and data transfer between user and
kernel space (st_read and st_write). The former was converted and this
converts the latter.

Converting st needs some minor modifications to the block layer
mapping API. I slightly extended the modifications that I made when
converting sg driver to use the block layer mapping API. The first and
second patches are for the block layer. Jens, can I get your ACKs on
them?

The changes to st driver is not huge. It's just converting st to use
struct rq_map_data instead of struct scatterlist.

=
 block/blk-map.c        |   16 ++--
 drivers/scsi/sg.c      |    2 +
 drivers/scsi/st.c      |  282 +++++++++++++++++++++++++-----------------------
 drivers/scsi/st.h      |   14 +--
 fs/bio.c               |   11 ++-
 include/linux/blkdev.h |    2 +
 6 files changed, 170 insertions(+), 157 deletions(-)


