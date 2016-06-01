From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v4 0/8] Replay Protected Memory Block (RPMB) subsystem
Date: Wed,  1 Jun 2016 17:41:24 -0400
Message-ID: <1464817292-5407-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

Few storage technology such is EMMC, UFS, and NVMe support RPMB
hardware partition with common protocol and frame layout.
The RPMB partition cannot be accessed via standard block layer, but
by a set of specific commands: WRITE, READ, GET_WRITE_COUNTER, and
PROGRAM_KEY.
Such a partition provides authenticated and replay protected access,
hence suitable as a secure storage.

A storage device registers its RPMB hardware (emmc) partition or
RPMB W-LUN (ufs) with the RPMB layer providing an implementation for
send_rpmb_req() handler.
There is as well simulation platform device. This is handy as an RPMB
key can be programmed only once at storage device lifetime.

The RPMB layer aims to provide in-kernel API for Trusted Execution
Environment (TEE) devices that are capable to securely compute block
frame signature. In case a TEE device wish to store a replay protected
data, it creates an RPMB frame with requested data and computes HMAC of
the frame, then it requests the storage device via RPMB layer to store
the data.
A TEE driver can claim rpmb interface, for example,
via  class_interface_register ().

A parallel user space API is provided via /dev/rpmbX character
device with a single IOCTL command similar to the one provided by
mmc/ioctl. h
This API may help applications such as 
https://android.googlesource.com/trusty/app/storage/
To be obliviose to the underlaying HW storage technology.

There is a sample tool under tools/rpmb/ directory that exercises
this interface.

Tomas Winkler (8):
  rpmb: add Replay Protected Memory Block (RPMB) subsystem
  char: rpmb: add sysfs-class ABI documentation
  char: rpmb: add device attributes
  char: rpmb: provide user space interface
  char: rpmb: add RPMB simulation device
  tools rpmb: add RPBM access tool
  mmc: block: register RPMB partition with the RPMB subsystem
  scsi: ufs: connect to RPMB subsystem

 Documentation/ABI/testing/sysfs-class-rpmb |  44 ++
 Documentation/ioctl/ioctl-number.txt       |   1 +
 MAINTAINERS                                |  10 +
 drivers/char/Kconfig                       |   2 +
 drivers/char/Makefile                      |   1 +
 drivers/char/rpmb/Kconfig                  |  25 +
 drivers/char/rpmb/Makefile                 |   6 +
 drivers/char/rpmb/cdev.c                   | 207 +++++++
 drivers/char/rpmb/core.c                   | 408 ++++++++++++++
 drivers/char/rpmb/rpmb-cdev.h              |  31 ++
 drivers/char/rpmb/rpmb_sim.c               | 589 ++++++++++++++++++++
 drivers/mmc/card/Kconfig                   |   1 +
 drivers/mmc/card/block.c                   | 292 ++++++++++
 drivers/scsi/ufs/Kconfig                   |   1 +
 drivers/scsi/ufs/ufshcd.c                  | 219 ++++++++
 drivers/scsi/ufs/ufshcd.h                  |   2 +
 include/linux/rpmb.h                       | 138 +++++
 include/uapi/linux/rpmb.h                  | 120 ++++
 tools/Makefile                             |  14 +-
 tools/rpmb/.gitignore                      |   2 +
 tools/rpmb/Makefile                        |  32 ++
 tools/rpmb/rpmb.c                          | 862 +++++++++++++++++++++++++++++
 22 files changed, 3002 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-rpmb
 create mode 100644 drivers/char/rpmb/Kconfig
 create mode 100644 drivers/char/rpmb/Makefile
 create mode 100644 drivers/char/rpmb/cdev.c
 create mode 100644 drivers/char/rpmb/core.c
 create mode 100644 drivers/char/rpmb/rpmb-cdev.h
 create mode 100644 drivers/char/rpmb/rpmb_sim.c
 create mode 100644 include/linux/rpmb.h
 create mode 100644 include/uapi/linux/rpmb.h
 create mode 100644 tools/rpmb/.gitignore
 create mode 100644 tools/rpmb/Makefile
 create mode 100644 tools/rpmb/rpmb.c

-- 
2.5.5
