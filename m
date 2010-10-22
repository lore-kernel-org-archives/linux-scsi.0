From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/10] hpsa updates, kdump fixes, PCI ID corrections and more
Date: Fri, 22 Oct 2010 14:27:19 -0500
Message-ID: <20101022192315.25694.28983.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:27130 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759106Ab0JVT1a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 15:27:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com

* The following series implements fixes to the board reset code used
  when the reset_devices kernel parameter is used (typically, kdump).
* Fixes some incorrect PCI IDs
* Also allows boards to be run in "simple" mode as well as the default
  "performant" mode.
* Adds a "commands_outstanding" entry in /sys for the scsi host controller.
* Add needed locking in hpsa_wait_for_mode_change_ack()
* Use usleep_range instead of msleep for small sleeps.

---

Stephen M. Cameron (10):
      hpsa: fix board status waiting code
      hpsa: Use kernel provided PCI state save and restore functions
      hpsa: limit commands allocated on reset_devices
      hpsa: do not reset unknown boards on reset_devices
      hpsa: take the adapter lock in hpsa_wait_for_mode_change_ack
      hpsa: allow driver to put controller in either simple or performant mode
      hpsa: use usleep_range not msleep for small sleeps
      hpsa: defend against zero sized buffers in passthru ioctls
      hpsa: Add a per controller commands_outstanding entry in /sys
      hpsa: fix some incorrect PCI IDs.


 Documentation/scsi/hpsa.txt |    6 +
 drivers/scsi/hpsa.c         |  216 ++++++++++++++++++++++---------------------
 drivers/scsi/hpsa.h         |    4 +
 3 files changed, 122 insertions(+), 104 deletions(-)

--
-- steve
