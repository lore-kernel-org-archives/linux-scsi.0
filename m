From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/4] virtio-scsi performance improvements
Date: Wed, 13 Jun 2012 16:56:30 +0200
Message-ID: <1339599394-13880-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This series reorganizes the locking in virtio-scsi, introducing separate
scatterlists for each target and "pipelining" the locks so that one
command can be queued while the other is prepared.  This improves
performance when there are multiple in-flight operations.

For example, a simple "if=/dev/sda of=/dev/null bs=128M iflag=direct"
(the source being a 10G disk, residing entirely in the host buffer cache)
improve as follows.  The additional locking does not cause any penalty
with only one dd process, while 2 simultaneous I/O operations improve
their times by 3%:

               number of simultaneous dd
                   1               2
 ----------------------------------------
 current        5.9958s        10.2640s
 patched        5.9531s         9.8663s

Times are best of 10, and taken on a 2-VCPU guest.

 drivers/scsi/virtio_scsi.c   |  226 ++++++++++++++++++++++++++++---------------
 1 file changed, 151 insertions(+), 75 deletions(-)

Paolo Bonzini (4):
  virtio-scsi: unlock during kick
  virtio-scsi: split locking per vq
  virtio-scsi: release sg_lock after add_buf
  virtio-scsi: split scatterlist per target
