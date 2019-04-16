From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 00/26] compat_ioctl: cleanups
Date: Tue, 16 Apr 2019 22:19:38 +0200
Message-ID: <20190416202013.4034148-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, y2038@lists.linaro.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Karsten Keil <isdn@linux-pingi.de>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Marcel Holtmann <marcel@holtmann.org>, netdev@vger.kernel.org, devel@driverdev.osuosl.org, linux-integrity@vger.kernel.org, qat-linux@intel.com, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linux1394-devel@lists.sourceforge.net, amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org, linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org, linux-iio@vger.ker
List-Id: linux-scsi@vger.kernel.org

Hi Al,

It took me way longer than I had hoped to revisit this series, see
https://lore.kernel.org/lkml/20180912150142.157913-1-arnd@arndb.de/
for the previously posted version.

I've come to the point where all conversion handlers and most
COMPATIBLE_IOCTL() entries are gone from this file, but for
now, this series only has the parts that have either been reviewed
previously, or that are simple enough to include.

The main missing piece is the SG_IO/SG_GET_REQUEST_TABLE conversion.
I'll post the patches I made for that later, as they need more
testing and review from the scsi maintainers.

I hope you can still take these for the coming merge window, unless
new problems come up.

      Arnd

Arnd Bergmann (26):
  compat_ioctl: pppoe: fix PPPOEIOCSFWD handling
  compat_ioctl: move simple ppp command handling into driver
  compat_ioctl: avoid unused function warning for do_ioctl
  compat_ioctl: move PPPIOCSCOMPRESS32 to ppp-generic.c
  compat_ioctl: move PPPIOCSPASS32/PPPIOCSACTIVE32 to ppp_generic.c
  compat_ioctl: handle PPPIOCGIDLE for 64-bit time_t
  compat_ioctl: move rtc handling into rtc-dev.c
  compat_ioctl: add compat_ptr_ioctl()
  compat_ioctl: move drivers to compat_ptr_ioctl
  compat_ioctl: use correct compat_ptr() translation in drivers
  ceph: fix compat_ioctl for ceph_dir_operations
  compat_ioctl: move more drivers to compat_ptr_ioctl
  compat_ioctl: move tape handling into drivers
  compat_ioctl: move ATYFB_CLK handling to atyfb driver
  compat_ioctl: move isdn/capi ioctl translation into driver
  compat_ioctl: move rfcomm handlers into driver
  compat_ioctl: move hci_sock handlers into driver
  compat_ioctl: remove HCIUART handling
  compat_ioctl: remove HIDIO translation
  compat_ioctl: remove translation for sound ioctls
  compat_ioctl: remove IGNORE_IOCTL()
  compat_ioctl: remove /dev/random commands
  compat_ioctl: remove joystick ioctl translation
  compat_ioctl: remove PCI ioctl translation
  compat_ioctl: remove /dev/raw ioctl translation
  compat_ioctl: remove last RAID handling code

 Documentation/networking/ppp_generic.txt    |   2 +
 arch/um/drivers/hostaudio_kern.c            |   1 +
 drivers/android/binder.c                    |   2 +-
 drivers/char/ppdev.c                        |  12 +-
 drivers/char/random.c                       |   1 +
 drivers/char/tpm/tpm_vtpm_proxy.c           |  12 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c |   2 +-
 drivers/dma-buf/dma-buf.c                   |   4 +-
 drivers/dma-buf/sw_sync.c                   |   2 +-
 drivers/dma-buf/sync_file.c                 |   2 +-
 drivers/firewire/core-cdev.c                |  12 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c    |   2 +-
 drivers/hid/hidraw.c                        |   4 +-
 drivers/hid/usbhid/hiddev.c                 |  11 +-
 drivers/hwtracing/stm/core.c                |  12 +-
 drivers/ide/ide-tape.c                      |  31 +-
 drivers/iio/industrialio-core.c             |   2 +-
 drivers/infiniband/core/uverbs_main.c       |   4 +-
 drivers/isdn/capi/capi.c                    |  31 +
 drivers/isdn/i4l/isdn_ppp.c                 |  14 +-
 drivers/media/rc/lirc_dev.c                 |   4 +-
 drivers/mfd/cros_ec_dev.c                   |   4 +-
 drivers/misc/cxl/flash.c                    |   8 +-
 drivers/misc/genwqe/card_dev.c              |  23 +-
 drivers/misc/mei/main.c                     |  22 +-
 drivers/misc/vmw_vmci/vmci_host.c           |   2 +-
 drivers/mtd/ubi/cdev.c                      |  36 +-
 drivers/net/ppp/ppp_generic.c               |  99 +++-
 drivers/net/ppp/pppoe.c                     |   7 +
 drivers/net/ppp/pptp.c                      |   3 +
 drivers/net/tap.c                           |  12 +-
 drivers/nvdimm/bus.c                        |   4 +-
 drivers/nvme/host/core.c                    |   2 +-
 drivers/pci/switch/switchtec.c              |   2 +-
 drivers/platform/x86/wmi.c                  |   2 +-
 drivers/rpmsg/rpmsg_char.c                  |   4 +-
 drivers/rtc/dev.c                           |  13 +-
 drivers/rtc/rtc-vr41xx.c                    |  10 +
 drivers/s390/char/tape_char.c               |  41 +-
 drivers/sbus/char/display7seg.c             |   2 +-
 drivers/sbus/char/envctrl.c                 |   4 +-
 drivers/scsi/3w-xxxx.c                      |   4 +-
 drivers/scsi/cxlflash/main.c                |   2 +-
 drivers/scsi/esas2r/esas2r_main.c           |   2 +-
 drivers/scsi/megaraid/megaraid_mm.c         |  28 +-
 drivers/scsi/osst.c                         |  34 +-
 drivers/scsi/pmcraid.c                      |   4 +-
 drivers/scsi/st.c                           |  35 +-
 drivers/staging/android/ion/ion.c           |   4 +-
 drivers/staging/pi433/pi433_if.c            |  12 +-
 drivers/staging/vme/devices/vme_user.c      |   2 +-
 drivers/tee/tee_core.c                      |   2 +-
 drivers/usb/class/cdc-wdm.c                 |   2 +-
 drivers/usb/class/usbtmc.c                  |   4 +-
 drivers/usb/core/devio.c                    |  16 +-
 drivers/usb/gadget/function/f_fs.c          |  12 +-
 drivers/vfio/vfio.c                         |  39 +-
 drivers/vhost/net.c                         |  12 +-
 drivers/vhost/scsi.c                        |  12 +-
 drivers/vhost/test.c                        |  12 +-
 drivers/vhost/vsock.c                       |  12 +-
 drivers/video/fbdev/aty/atyfb_base.c        |  12 +-
 drivers/virt/fsl_hypervisor.c               |   2 +-
 fs/btrfs/super.c                            |   2 +-
 fs/ceph/dir.c                               |   1 +
 fs/ceph/file.c                              |   2 +-
 fs/compat_ioctl.c                           | 602 +-------------------
 fs/fat/file.c                               |  13 +-
 fs/fuse/dev.c                               |   2 +-
 fs/notify/fanotify/fanotify_user.c          |   2 +-
 fs/userfaultfd.c                            |   2 +-
 include/linux/fs.h                          |   7 +
 include/linux/if_pppox.h                    |   2 +
 include/linux/mtio.h                        |  58 ++
 include/uapi/linux/ppp-ioctl.h              |   2 +
 include/uapi/linux/ppp_defs.h               |  14 +
 net/bluetooth/hci_sock.c                    |  21 +-
 net/bluetooth/rfcomm/sock.c                 |  14 +-
 net/l2tp/l2tp_ppp.c                         |   3 +
 net/rfkill/core.c                           |   2 +-
 sound/core/oss/pcm_oss.c                    |   4 +
 sound/oss/dmasound/dmasound_core.c          |   2 +
 82 files changed, 452 insertions(+), 1034 deletions(-)
 create mode 100644 include/linux/mtio.h

-- 
2.20.0

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Cc: linux-integrity@vger.kernel.org
Cc: qat-linux@intel.com
Cc: linux-crypto@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux1394-devel@lists.sourceforge.net
Cc: amd-gfx@lists.freedesktop.org
Cc: linux-input@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-ide@vger.kernel.org
Cc: linux-iio@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-mtd@lists.infradead.org
Cc: linux-ppp@vger.kernel.org
Cc: linux-nvme@lists.infradead.org
Cc: platform-driver-x86@vger.kernel.org
Cc: linux-remoteproc@vger.kernel.org
Cc: linux-rtc@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: sparclinux@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Cc: ceph-devel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: y2038@lists.linaro.org
