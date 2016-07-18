From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v5 0/8] Replay Protected Memory Block (RPMB) subsystem
Date: Mon, 18 Jul 2016 23:27:45 +0300
Message-ID: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
Sender: linux-mmc-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

Few storage technologies such is EMMC, UFS, and NVMe support RPMB
hardware partition with common protocol and frame layout.
The RPMB partition cannot be accessed via standard block layer, but by a
set of specific commands: WRITE, READ, GET_WRITE_COUNTER, and
PROGRAM_KEY.
Such a partition provides authenticated and replay protected access,
hence suitable as a secure storage.

The RPMB layer aims to provide in-kernel API for Trusted Execution
Environment (TEE) devices that are capable to securely compute block
frame signature. In case a TEE device wish to store a replay protected
data, it creates an RPMB frame with requested data and computes HMAC of
the frame, then it requests the storage device via RPMB layer to store
the data.
A TEE driver can claim the RPMB interface, for example, via
class_interface_register ().
The layer provides two APIs, for rpmb_req_cmd() for issuing one of RPMB
specific commands and rpmb_seq_cmd() for issuing of raw RPMB protocol
frames,  which is close to emmc multi ioctl interface.

A storage device registers its RPMB hardware (eMMC) partition or RPMB
W-LUN (UFS) with the RPMB layer providing an implementation for
rpmb_seq_cmd() handler. The interface enables sending sequence of RPMB
standard frames.

A parallel user space API is provided via /dev/rpmbX character
device with two IOCTL commands.
Simplified one, RPMB_IOC_REQ_CMD, were read result cycles is performed
by the framework on behalf the user and second, RPMB_IOC_SEQ_CMD where
the whole RPMB sequence, including RESULT_READ is supplied by the caller.
The latter is intended for easier adjusting of the applications that
use MMC_IOC_MULTI_CMD ioctl, such as 
https://android.googlesource.com/trusty/app/storage/

There is a also sample tool under tools/rpmb/ directory that exercises
these interfaces and a simulation device that implements the device part.

Tomas Winkler (8):
  rpmb: add Replay Protected Memory Block (RPMB) subsystem
  char: rpmb: add sysfs-class ABI documentation
  char: rpmb: add device attributes
  char: rpmb: provide a user space interface
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
 drivers/char/rpmb/cdev.c                   | 269 ++++++++
 drivers/char/rpmb/core.c                   | 484 +++++++++++++++
 drivers/char/rpmb/rpmb-cdev.h              |  25 +
 drivers/char/rpmb/rpmb_sim.c               | 668 ++++++++++++++++++++
 drivers/mmc/card/Kconfig                   |   1 +
 drivers/mmc/card/block.c                   | 258 +++++++-
 drivers/scsi/ufs/Kconfig                   |   1 +
 drivers/scsi/ufs/ufshcd.c                  | 183 ++++++
 drivers/scsi/ufs/ufshcd.h                  |   2 +
 include/linux/rpmb.h                       | 165 +++++
 include/uapi/linux/Kbuild                  |   1 +
 include/uapi/linux/rpmb.h                  | 152 +++++
 tools/Makefile                             |  14 +-
 tools/rpmb/.gitignore                      |   2 +
 tools/rpmb/Makefile                        |  33 +
 tools/rpmb/rpmb.c                          | 948 +++++++++++++++++++++++++++++
 23 files changed, 3287 insertions(+), 8 deletions(-)
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

