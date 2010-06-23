From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/3] convert flush request to REQ_TYPE_FS instead of BLOCK_PC
Date: Thu, 24 Jun 2010 00:07:29 +0900
Message-ID: <1277305652-2306-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

We use REQ_TYPE_BLOCK_PC for flush requests from file
systems. scsi-ml's definition of REQ_TYPE_BLOCK_PC is that we don't
retry PC requests even when we can (e.g. UNIT ATTENTION) and we send
the response to the callers, and expect the callers to decide what
they want.

File systems (and the block layer) don't have the mechnism to retry
requests so file systems hit avoidable I/O errors. We need a
workaround such as the commit 77a4229719e511a0d38d9c355317ae1469adeb54
to retry BLOCK_PC flush requests. We will need the similar workaround
for discard requests too since SCSI-ml handle them as BLOCK_PC
internally.

This uses REQ_TYPE_FS for flush requests from file systems instead of
REQ_TYPE_BLOCK_PC. flush requests are retried when appropriate.

This patchset can be applied to the block tree's for-2.6.36. It
contains of some changes to scsi so this patchset can't be applied to
scsi-misc.

=
 block/blk-barrier.c       |    4 ++--
 drivers/scsi/scsi_error.c |   19 ++++---------------
 drivers/scsi/sd.c         |   19 +++++++++++++------
 include/linux/bio.h       |    2 ++
 4 files changed, 21 insertions(+), 23 deletions(-)
