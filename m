From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFCv2 0/7] vhost/scsi: Add T10 PI SGL passthrough support
Date: Mon, 17 Mar 2014 05:32:54 +0000
Message-ID: <1395034381-656-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MST, MKP, Paolo & Co,

This is an updated -v2 series for adding T1O protection information (PI)
SGL passthrough support between virtio-scsi LLD + vhost-scsi fabric
endpoints.

The patch series is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git vhost-dif

Following Paolo's recommendations, this patch adds a new virtio_scsi command
header (virtio_scsi_cmd_req_pi) with the following elements to signal the
existence of protection information:

     ->do_pi_niov (DataOUT PI number of iovecs)
     ->di_pi_noiv (DataIN PI number of iovecs)

Also included is the change to attach protection information preceeding the
actual DataOUT + DataIN data payload, thus making a future improvement of
processing virtio buffers inline a possibility.

vhost-scsi code has also been updated to determine virtio_scsi_cmd_req or
virtio_scsi_cmd_req_pi usage based upon the first iovec's (header) length,
and then continues to process in either mode accordingly.

As with the original RFC, the virtio-scsi patch still contains a hack
to force DIX/DIF to be enabled, regardless of host provided feature bits.
This regression bug still needs to be tracked down.

v2 changes:
  - Add virtio_scsi_cmd_req_pi header (Paolo + nab)
  - Use virtio_scsi_cmd_req_pi instead of existing ->prio (Paolo + nab)
  - Make protection buffer come before data buffer (Paolo + nab)
  - Update vhost_scsi_get_tag() parameter usage (nab)

Please review.

Thanks!

--nab

Nicholas Bellinger (7):
  virtio-scsi.h: Add virtio_scsi_cmd_req_pi header definition
  vhost/scsi: Move sanity check into vhost_scsi_map_iov_to_sgl
  vhost/scsi: Add preallocation of protection SGLs
  vhost/scsi: Add T10 PI IOV -> SGL memory mapping logic
  vhost/scsi: Enable T10 PI IOV -> SGL memory mapping
  vhost/scsi: Add new VIRTIO_SCSI_F_T10_PI feature bit
  virtio-scsi: Enable DIF/DIX modes in SCSI host LLD

 drivers/scsi/virtio_scsi.c  |   79 +++++++++---
 drivers/vhost/scsi.c        |  289 +++++++++++++++++++++++++++++--------------
 include/linux/virtio_scsi.h |   15 ++-
 3 files changed, 273 insertions(+), 110 deletions(-)

-- 
1.7.2.5
