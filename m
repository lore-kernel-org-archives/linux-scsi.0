From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v5 0/3] virtio-scsi driver
Date: Sun,  5 Feb 2012 12:15:59 +0100
Message-ID: <1328440562-19425-1-git-send-email-pbonzini@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org, Pekka Enberg <penberg@kernel.org>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

This is the first implementation of the virtio-scsi driver, a virtual
HBA that will be supported by KVM.  It implements a subset of the spec,
in particular it does not implement asynchronous notifications for either
LUN reset/removal/addition or CD-ROM media events, but it is already
functional and usable.

Other matching bits:

- spec at http://people.redhat.com/pbonzini/virtio-spec.pdf

- QEMU implementation at git://github.com/bonzini/qemu.git,
  branch virtio-scsi

Please review.  Getting this in 3.3 is starting to look like wishful thinking,
but the possibility of regressions is obviously zero so I'm still dreaming.
Otherwise, that would be 3.4.

Paolo Bonzini (3):
  virtio-scsi: first version
  virtio-scsi: add error handling
  virtio-scsi: add power management support

v4->v5: change virtio id from 7 to 8

v3->v4: renamed VIRTIO_SCSI_S_UNDERRUN to VIRTIO_SCSI_S_OVERRUN;
    fixed 32-bit compilation; added power management support;
    adjusted calls to virtqueue_add_buf

 drivers/scsi/Kconfig        |    8 +
 drivers/scsi/Makefile       |    1 +
 drivers/scsi/virtio_scsi.c  |  594 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio_ids.h  |    1 +
 include/linux/virtio_scsi.h |  114 +++++++++
 5 files changed, 718 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/virtio_scsi.c
 create mode 100644 include/linux/virtio_scsi.h

