From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 0/6] Let sleeping disks lie
Date: Sat,  9 Nov 2013 16:03:22 -0500
Message-ID: <cover.1384030893.git.psusi@ubuntu.com>
References: <527EA218.6010604@ubuntu.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <527EA218.6010604@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I've made a few corrections and extentions to this patch set after
more testing.  Changes include fixing the faked command to return
the correct status, fixing some errors and adding more commands
to be faked.

The one command I have yet to figure out how to fake is
IDENTIFY DEVICE, which I would like to just have return the
cached identify block, but am not sure how to get from the
qc's scattergather list to a memory pointer I can memcpy to.

Phillip Susi (6):
  libata: use sleep instead of standby command
  libata: avoid waking disk to check power
  sd: don't bother spinning up disks on resume
  libata: resume in the background
  libata: don't start disks on resume
  libata: fake some more commands when drive is sleeping

 drivers/ata/libata-core.c  | 34 ++++++++++++++++++++++++++--------
 drivers/ata/libata-eh.c    | 10 ++++++++--
 drivers/ata/libata-scsi.c  |  4 ++--
 drivers/ata/libata.h       |  1 +
 drivers/scsi/sd.c          |  6 +++---
 include/linux/libata.h     |  1 +
 include/scsi/scsi_device.h |  2 +-
 7 files changed, 42 insertions(+), 16 deletions(-)

-- 
1.8.3.2

