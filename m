From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 0/6] virtio-scsi patches for 3.16 + midlayer fix
Date: Wed,  4 Jun 2014 12:11:37 +0200
Message-ID: <1401876703-10236-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com
List-Id: linux-scsi@vger.kernel.org

As mentioned in the v1 submission, these patches were delayed a bit
by the discussion and testing of patch 5.  Debugging the problem also
led to the discovery of a midlayer bug fixed by patch 4.

Paolo

v1->v2: fix all occurrences of "scmd->result |= DID_TIME_OUT << 16"
        in patch 4

Ming Lei (2):
  virtio_scsi: remove ACCESS_ONCE() and smp_read_barrier_depends()
  virtio-scsi: replace target spinlock with seqcount

Paolo Bonzini (2):
  virtio-scsi: avoid cancelling uninitialized work items
  virtio-scsi: fix various bad behavior on aborted requests

Ulrich Obergfell (1):
  scsi_error: fix invalid setting of host byte

Venkatesh Srinivas (1):
  virtio-scsi: Implement change_queue_depth for virtscsi targets

 drivers/scsi/scsi_error.c  |   6 +-
 drivers/scsi/virtio_scsi.c | 148 +++++++++++++++++++++++++++------------------
 2 files changed, 93 insertions(+), 61 deletions(-)

-- 
1.8.3.1
