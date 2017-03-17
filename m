From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v5 00/16] Cleanup chardev instances with helper function
Date: Fri, 17 Mar 2017 12:48:07 -0600
Message-ID: <1489776503-3151-1-git-send-email-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Marek Vasut <marek.vasut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cyrille Pitchen <cyrille.pitchen-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hey,

This version of the series fixes the issue found by the kbuild test
robot with the rtc driver. I managed to reproduce the issue and this
series fixes the problem.

Logan


Changes since v4:

* Fix a kbuild robot issue with the rtc driver: the rtc driver sometimes
  does not want to add the cdev. In order to accommodate this, the new
  cdev_device helper functions check dev->devt and if it's zero they
  don't add or delete the cdev.

* Remove prototypes for functions that were removed in the rtc driver

Changes since v3:

* Added a missing "device.h" include which caused warnings with some
  build configurations

Changes since v2:

* Expanded comments as per Jason's suggestions
* Collected tags
* Updated the switchtec patch seeing it's underlying patch set changed

Changes since v1:

* Expanded the idea to take care of adding the cdev and the device

Logan


Dan Williams (1):
  device-dax: fix cdev leak

Jason Gunthorpe (1):
  IB/ucm: utilize new cdev_device_add helper function

Logan Gunthorpe (14):
  chardev: add helper function to register char devs with a struct
    device
  device-dax: utilize new cdev_device_add helper function
  input: utilize new cdev_device_add helper function
  gpiolib: utilize new cdev_device_add helper function
  tpm-chip: utilize new cdev_device_add helper function
  platform/chrome: cros_ec_dev - utilize new cdev_device_add helper
    function
  infiniband: utilize the new cdev_set_parent function
  iio:core: utilize new cdev_device_add helper function
  media: utilize new cdev_device_add helper function
  mtd: utilize new cdev_device_add helper function
  rapidio: utilize new cdev_device_add helper function
  rtc: utilize new cdev_device_add helper function
  scsi: utilize new cdev_device_add helper function
  switchtec: utilize new device_add_cdev helper function

 drivers/char/tpm/tpm-chip.c              | 19 ++-----
 drivers/dax/dax.c                        | 33 ++++++------
 drivers/gpio/gpiolib.c                   | 23 +++-----
 drivers/iio/industrialio-core.c          | 15 ++----
 drivers/infiniband/core/ucm.c            | 35 ++++++------
 drivers/infiniband/core/user_mad.c       |  4 +-
 drivers/infiniband/core/uverbs_main.c    |  2 +-
 drivers/infiniband/hw/hfi1/device.c      |  2 +-
 drivers/input/evdev.c                    | 11 +---
 drivers/input/joydev.c                   | 11 +---
 drivers/input/mousedev.c                 | 11 +---
 drivers/media/cec/cec-core.c             | 16 ++----
 drivers/media/media-devnode.c            | 20 ++-----
 drivers/mtd/ubi/build.c                  | 91 ++++++--------------------------
 drivers/mtd/ubi/vmt.c                    | 49 ++++++-----------
 drivers/pci/switch/switchtec.c           | 11 +---
 drivers/platform/chrome/cros_ec_dev.c    | 31 +++--------
 drivers/rapidio/devices/rio_mport_cdev.c | 24 +++------
 drivers/rtc/class.c                      | 14 +++--
 drivers/rtc/rtc-core.h                   | 10 ----
 drivers/rtc/rtc-dev.c                    | 17 ------
 drivers/scsi/osd/osd_uld.c               | 56 +++++++-------------
 fs/char_dev.c                            | 86 ++++++++++++++++++++++++++++++
 include/linux/cdev.h                     |  5 ++
 24 files changed, 239 insertions(+), 357 deletions(-)

--
2.1.4
