From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 00/14] Cleanup chardev instances with helper function
Date: Mon, 20 Feb 2017 22:00:39 -0700
Message-ID: <1487653253-11497-1-git-send-email-logang@deltatee.com>
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
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sajjan Vikas C <vikas.cha.sajjan-ZPxbGqLxI0U@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hello,

Our story for this patch-set begins with a new driver I wrote and am in
the process of submitting upstream. That driver creates a fairly
standard char device and the code for it was copied from a similar
instance in device-dax. However, upon review, Greg Kroah-Hartman
noticed [1] a suspicious line that assigned to the parent field of
the underlying kobject for the char device.

I removed that from my code and endeavoured to remove it from the
code I copied as well. However, Dan Williams pointed out [2] that this
code is necessary for correct reference counting of the underlying
structures. This prompted me to do a fair bit more research and
investigation into whats going on and I found it to be a common pattern.
(Although misleading and though required to be correct, frequently
forgotten.) This pattern is used in at least 15 places in the kernel
and probably should have been used in at least 5 more.

This patch-set aims to correct this and hopefully prevent future
developers from wasting their time on it. The first patch introduces
a new helper API as originally proposed by Dan Williams [3]. Please
see the commit message for that patch for a longer description of the
problem and history.

The subsequent patches either update correct instances to use the
new API or fix incorrect usages to ensure the cdev correctly takes
a reference count using the new API (this is noted in those patches).

This moves all except four of the cdev.kobj.parent usages into the one
cdev function, the remaining four are in the infiniband subsystem and
I've left alone because that subsystem seems to make use of kobjects
directly (instead of struct devices). These are noted in patch 7 of
this series.

This series is based on v4.10 with the exception of the last patch
which is for my new driver which, as yet, has not been accepted
upstream.

@Dan the first patch in this series will need your sign-off.

Thanks,

Logan

[1] https://lkml.org/lkml/2017/2/10/370
[2] https://lkml.org/lkml/2017/2/10/607
[3] https://lkml.org/lkml/2017/2/13/700

Logan Gunthorpe (14):
  chardev: add helper function to register char devs with a struct
    device
  device-dax: utilize new device_add_cdev helper function
  input: utilize new device_add_cdev helper function
  gpiolib: utilize new device_add_cdev helper function
  tpm-chip: utilize new device_add_cdev helper function
  platform/chrome: utilize new device_add_cdev helper function
  infiniband: utilize new device_add_cdev helper function
  iio:core: utilize new device_add_cdev helper function
  media: utilize new device_add_cdev helper function
  mtd: utilize new device_add_cdev helper function
  rapidio: utilize new device_add_cdev helper function
  rtc: utilize new device_add_cdev helper function
  scsi: utilize new device_add_cdev helper function
  switchtec: utilize new device_add_cdev helper function

 drivers/char/tpm/tpm-chip.c              |  3 +--
 drivers/dax/dax.c                        |  5 ++---
 drivers/gpio/gpiolib.c                   |  3 +--
 drivers/iio/industrialio-core.c          |  3 +--
 drivers/infiniband/core/ucm.c            |  8 +++++---
 drivers/input/evdev.c                    |  3 +--
 drivers/input/joydev.c                   |  3 +--
 drivers/input/mousedev.c                 |  3 +--
 drivers/media/cec/cec-core.c             |  3 +--
 drivers/media/media-devnode.c            |  3 +--
 drivers/mtd/ubi/build.c                  |  8 +++++---
 drivers/mtd/ubi/vmt.c                    | 10 +++++-----
 drivers/pci/switch/switchtec.c           |  3 +--
 drivers/platform/chrome/cros_ec_dev.c    |  6 ++----
 drivers/rapidio/devices/rio_mport_cdev.c |  9 ++++++---
 drivers/rtc/rtc-dev.c                    |  3 +--
 drivers/scsi/osd/osd_uld.c               |  9 +++++----
 fs/char_dev.c                            | 24 ++++++++++++++++++++++++
 include/linux/cdev.h                     |  1 +
 19 files changed, 65 insertions(+), 45 deletions(-)

--
2.1.4
