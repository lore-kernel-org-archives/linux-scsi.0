From: Tejun Heo <htejun@gmail.com>
Subject: [PATCHSET #upstream] block/libata: update and use block layer padding and draining, take 2
Date: Sat,  9 Feb 2008 10:40:19 +0900
Message-ID: <12025212262892-git-send-email-htejun@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org


This is the second take of blk-layer-padding-and-draining patchset.
Changes from the last take[L] are...

* libata-update-ATAPI-overflow-draining patch added.  This patch fixes
  up ATAPI PIO handling before updating it to use block layer
  draining.  consumed accounting and atapi_qc_may_overflow() update
  will survive blk draining conversion.

* blk-clear-drain-buffer-for-writes patch added.  This patch makes
  block layer clear drain buffer before chaining it to the sg list if
  the command in question is a write.

* libata-implement-drain-buffers updated such that
  atapi_drain_needed() uses the same logic as atapi_qc_may_overflow()
  and ATAPI PIO drain logic is replaced too.

This patchset is against the current upstream
(bc5468f52b785ffa1fe0ea289baec2c51384d436).

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.ide/28048
