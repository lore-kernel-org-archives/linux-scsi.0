From: Jens Axboe <axboe@fb.com>
Subject: [PATCH RFC] mpt2/mpt3sas lock reduction for scsi-mq
Date: Fri, 3 Apr 2015 09:58:16 -0600
Message-ID: <1428076703-31014-1-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de
List-Id: linux-scsi@vger.kernel.org

Hi,

There's some "low" hanging fruit in the lsi mpt drivers for further
lock reduction, when running in scsi-mq mode. For each IO, they have
to lock/{get,put}/unlock a scsiio_tracker structure that is associated
with the IO. In scsi-mq mode, we can ask for some payload for each
command, so we don't have to store and manage this tracker structure
separately.

In some testing on mpt2sas, this roughly cuts the locking time in half
at just 100K IOPS. Compared to scsi-mq not being enabled, the locking
time with the patchset is reduced from ~47% to just ~4%.

-- 
Jens Axboe
