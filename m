From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v7 00/11] char:rpmb: Replay Protected Memory Block (RPMB) subsystem
Date: Mon,  7 Nov 2016 21:53:03 +0200
Message-ID: <1478548394-8184-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28198 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933648AbcKGTA5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Nov 2016 14:00:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: Avri Altman <avri.altman@gmail.com>, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>

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

The layer provides two APIs, for rpmb_req_cmd() for issuing one of RPMB
specific commands and rpmb_seq_cmd() for issuing of raw RPMB protocol
frames,  which is close to the functionality provided by emmc multi ioctl
interface.

A TEE driver can claim the RPMB interface, for example, via
class_interface_register ().

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

The code is also available from:

https://github.com/tomasbw/linux-mei.git rpmb

V7  1. Special thanks to Avri Altman <avri.altman@sandisk.com> for testing emmc and ufs.
    2. Fix char device interface.
    3. Add Documentation
    4. Addional small fixes described in individual patches.

Tomas Winkler (11):
  rpmb: add Replay Protected Memory Block (RPMB) subsystem
  rpmb: enable emmc specific read data fixup
  rpmb: add sysfs-class ABI documentation
  char: rpmb: add device attributes
  char: rpmb: provide a user space interface
  char: rpmb: add RPMB simulation device
  tools rpmb: add RPBM access tool
  mmc: block: register RPMB partition with the RPMB subsystem
  scsi: ufs: connect to RPMB subsystem
  scsi: ufs: retrieve rpmb rw size
  char: rpmb: Document Replay Protected Memory Block (RPMB) subsystem

 Documentation/ABI/testing/sysfs-class-rpmb |   47 ++
 Documentation/index.rst                    |    1 +
 Documentation/ioctl/ioctl-number.txt       |    1 +
 Documentation/rpmb/conf.py                 |    5 +
 Documentation/rpmb/index.rst               |   18 +
 Documentation/rpmb/introduction.rst        |  102 +++
 Documentation/rpmb/rpmb-tool.rst           |   19 +
 Documentation/rpmb/simulation-device.rst   |   19 +
 MAINTAINERS                                |   11 +
 drivers/char/Kconfig                       |    2 +
 drivers/char/Makefile                      |    1 +
 drivers/char/rpmb/Kconfig                  |   32 +
 drivers/char/rpmb/Makefile                 |    6 +
 drivers/char/rpmb/cdev.c                   |  331 +++++++++
 drivers/char/rpmb/core.c                   |  523 ++++++++++++++
 drivers/char/rpmb/rpmb-cdev.h              |   25 +
 drivers/char/rpmb/rpmb_sim.c               |  744 ++++++++++++++++++++
 drivers/mmc/card/Kconfig                   |    1 +
 drivers/mmc/card/block.c                   |  258 ++++++-
 drivers/scsi/ufs/Kconfig                   |    1 +
 drivers/scsi/ufs/ufs.h                     |    6 +
 drivers/scsi/ufs/ufshcd.c                  |  205 ++++++
 drivers/scsi/ufs/ufshcd.h                  |    2 +
 include/linux/rpmb.h                       |  167 +++++
 include/uapi/linux/Kbuild                  |    1 +
 include/uapi/linux/rpmb.h                  |  153 ++++
 tools/Makefile                             |   14 +-
 tools/rpmb/.gitignore                      |    2 +
 tools/rpmb/Makefile                        |   34 +
 tools/rpmb/rpmb.c                          | 1035 ++++++++++++++++++++++++++++
 30 files changed, 3758 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-rpmb
 create mode 100644 Documentation/rpmb/conf.py
 create mode 100644 Documentation/rpmb/index.rst
 create mode 100644 Documentation/rpmb/introduction.rst
 create mode 100644 Documentation/rpmb/rpmb-tool.rst
 create mode 100644 Documentation/rpmb/simulation-device.rst
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
2.7.4

