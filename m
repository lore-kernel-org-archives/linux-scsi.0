From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: [PATCH 0/2] scsi: Port buslogic driver to 64 bits
Date: Thu, 16 May 2013 12:27:57 -0600
Message-ID: <cover.1368725030.git.khalid.aziz@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: Khalid Aziz <khalid.aziz@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


This patchset ports buslogic driver to 64-bit.

Current buslogic driver is composed of two components - SCCB manager
which communicates with adapter to execute SCSI commands (contained in
FlashPoint.c), and Linux driver part that interfaces with rest of the
kernel (contained in BusLogic.c). SCCB manager code came from the
Mylex SDK. SCCB manager code is used by flashpoint adapters only.
Multimaster adapters do not need SCCB manager since the SCSI state
machine is implemented in firmware on these adapters. If the filenames
alone did not give it away already, buslogic driver code is full of
CamelCase, besides being full of very ling lines, and is just very
difficult to read and understand. So the first step was to clean up
the existing code. First patch in the set does just that. Second patch
includes necessary code modifications to allow the driver to build and
run on 64-bit kernel. Since SCCB manager code came from Mylex SDK, I
have tried to touch it only when necessary which includes not fixing
all CamelCase issues in FlashPoint.c. Many lines over 80 characters
remain in BusLogic.c. These fall into two categories generally -
(1) it prints a message and I didn't want to touch driver messages
in case there are scripts out there that parse driver messages,
(2) code is indented deeply and is hard to keep it under 80 characters.
Such code could use refactoring at some point.

I have tested this patch with a flashpoint adapter on 64-bit and 
32-bit kernels with fio running random read/write test while verifying
data. I also measured performance for current buslogic driver and 
buslogic driver with these patches with 32-bit and 64-bit kernel and
ensured there was no degradation in performance.


Khalid Aziz (2):
  Fix CamelCase and extra long lines in the BusLogic driver
  Port buslogic driver to 64-bit.

 drivers/scsi/BusLogic.c   | 4490 ++++++++++++++++++++++++---------------------
 drivers/scsi/BusLogic.h   | 1489 ++++++++-------
 drivers/scsi/FlashPoint.c |  625 +++----
 drivers/scsi/Kconfig      |    2 +-
 4 files changed, 3395 insertions(+), 3211 deletions(-)

-- 
1.7.10.4
