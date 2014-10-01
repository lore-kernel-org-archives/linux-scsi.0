From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 0/4] Userspace Passthrough backstore for LIO
Date: Wed,  1 Oct 2014 16:07:01 -0700
Message-ID: <1412204825-13292-1-git-send-email-agrover@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org, shli@kernel.org, linux-kernel@vger.kernel.org, rjones@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hi Nick and all,

Here's version 2, against Nick's target-pending/for-next. Note that
since that tree is still on 3.17-rc5, in testing I ran into an issue
fixed by:

genhd: fix leftover might_sleep() in blk_free_devt()

which first appears in 3.17-rc7.

Incorporates feedback from Nick.

Doc fixes
* add table of contents
* add example code for the user-side
* document specific opcodes that IO mode passes through

Code fixes
* add back support for PASS_ALL and PASS_IO pass_level option.
* Removed retry-in-kernel mechanism
* fix issues from kbuild test robot
* remove kref from tcmu_dev and call kfree(udev) from tcmu_free_device
  instead
* set hw_block_size to 512 instead of 4096
* Don't copy DMA_FROM_DEVICE data if there was a CHECK_CONDITION
* use goto-style error handling in tcmu_configure_device
* Check retval from genlmsg_multicast and ignore -ESRCH
* properly handle if device is unconfigured in tcmu_free_device

Thanks -- Andy

Andy Grover (4):
  target: Remove unneeded check in sbc_parse_cdb
  uio: Export definition of struct uio_device
  target: Add documentation on the target userspace pass-through driver
  target: Add a user-passthrough backstore

 Documentation/target/tcmu-design.txt   |  378 +++++++++++
 drivers/target/Kconfig                 |    5 +
 drivers/target/Makefile                |    1 +
 drivers/target/target_core_sbc.c       |    2 +-
 drivers/target/target_core_transport.c |    4 +
 drivers/target/target_core_user.c      | 1163 ++++++++++++++++++++++++++++++++
 drivers/uio/uio.c                      |   12 -
 include/linux/uio_driver.h             |   12 +-
 include/uapi/linux/Kbuild              |    1 +
 include/uapi/linux/target_core_user.h  |  142 ++++
 10 files changed, 1706 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/target/tcmu-design.txt
 create mode 100644 drivers/target/target_core_user.c
 create mode 100644 include/uapi/linux/target_core_user.h

-- 
1.9.3
