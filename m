From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Sun,  6 Apr 2014 21:32:03 +0000
Message-ID: <1396819929-29687-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MST, MKP, Paolo & Co,

This is an updated patch series for adding T1O protection information (PI)
SGL passthrough support between virtio-scsi LLD + vhost-scsi fabric
endpoints.

Following Paolo's recommendations, this patch uses VIRTIO_SCSI_F_T10_PI
feature bits in both vhost/scsi and virtio-scsi to determine when the PI
enabled virtio_scsi_cmd_req_pi header should be used, instead of the
original virtio_scsi_cmd_req header.

As before, the change to attach protection information preceeding the
actual DataOUT + DataIN data payload, thus making a future improvement of
processing virtio buffers inline a possibility.

At this point the last item is the QEMU change to use VIRTIO_SCSI_F_T10_PI
when guest + host agree upon supported features.  Note this patch has been
tested in unprotected mode where one side does not support PI mode, and
correctly falls back to unprotected mode on both sides.

That said, I'd like to get these parts merged ASAP.

Please review.

--nab

RFCv2 -> PATCH changes:
  - Use VIRTIO_SCSI_F_T10_PI to determine PI or non PI header in
    vhost/scsi and virtio-scsi (Paolo)
  - Remove hardcoded bits to force VIRTIO_SCSI_F_T10_PI mode for
    testing

RFCv1 -> RFCv2 changes:
  - Add virtio_scsi_cmd_req_pi header (Paolo + nab)
  - Use virtio_scsi_cmd_req_pi instead of existing ->prio (Paolo + nab)
  - Make protection buffer come before data buffer (Paolo + nab)
  - Update vhost_scsi_get_tag() parameter usage (nab)

Nicholas Bellinger (6):
  virtio-scsi.h: Add virtio_scsi_cmd_req_pi + VIRTIO_SCSI_F_T10_PI bits
  vhost/scsi: Move sanity check into vhost_scsi_map_iov_to_sgl
  vhost/scsi: Add preallocation of protection SGLs
  vhost/scsi: Add T10 PI IOV -> SGL memory mapping logic
  vhost/scsi: Enable T10 PI IOV -> SGL memory mapping
  virtio-scsi: Enable DIF/DIX modes in SCSI host LLD

 drivers/scsi/virtio_scsi.c  |   78 ++++++++---
 drivers/vhost/scsi.c        |  301 +++++++++++++++++++++++++++++--------------
 include/linux/virtio_scsi.h |   15 ++-
 3 files changed, 281 insertions(+), 113 deletions(-)

-- 
1.7.10.4
