From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/13] Patches for cciss and hpsa
Date: Fri, 08 Oct 2010 15:06:00 -0500
Message-ID: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The following series:

* Fixes the "reset_devices" behavior of cciss and hpsa on newer
  controllers which use the "doorbell" method of resetting (this
  means kdump will work now on those controllers that have the
  doorbell reset capability).

* Remove support from cciss for controllers which are supported
  by hpsa so there is no overlap (except by use of hpsa_allow_any=1
  module parameter).

* Allow hpsa to use either "performant" (default) or "simple" mode of
  controller operation selectable by module parameter.

* Some small miscellaneous fixes for cciss and hpsa.

---

Stephen M. Cameron (13):
      cciss: remove controllers supported by hpsa
      hpsa: fix board status waiting code
      hpsa: Use kernel provided PCI state save and restore functions
      hpsa: limit commands allocated on reset_devices
      hpsa: do not reset unknown boards on reset_devices
      cciss: fix board status waiting code
      cciss: Use kernel provided PCI state save and restore functions
      cciss: limit commands allocated on reset_devices
      cciss: use usleep_range not msleep for small sleeps
      hpsa: take the adapter lock in hpsa_wait_for_mode_change_ack
      hpsa: allow driver to put controller in either simple or performant mode
      hpsa: use usleep_range not msleep for small sleeps
      hpsa: defend against zero sized buffers in passthru ioctls


 Documentation/scsi/hpsa.txt |    6 +
 drivers/block/cciss.c       |  160 +++++++++++++-----------------------
 drivers/block/cciss.h       |    4 +
 drivers/scsi/hpsa.c         |  192 +++++++++++++++++++++----------------------
 drivers/scsi/hpsa.h         |    4 +
 5 files changed, 164 insertions(+), 202 deletions(-)

-- 
Signature
