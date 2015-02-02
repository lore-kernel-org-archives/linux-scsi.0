From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 00/11] vhost/scsi: Add ANY_LAYOUT + VERSION_1 support
Date: Mon,  2 Feb 2015 04:06:23 +0000
Message-ID: <1422849994-3419-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MST, Paolo, & Co,

This -v2 series adds vhost/scsi ANY_LAYOUT + VERSION_1 host feature bit
support.

It adds a new vhost_virtqueue ->handle_kick() callback to determine the
start of protection and data payloads iovecs past starting virtio-scsi
request and response headers, based upon data_direction.

It assumes request/CDB and response/sense_buffer headers may span more
than a single iovec using lib/iovec.c logic, and adds a new addition of
memcpy_fromiovec_out() to return the current re-calcuated **iov_out.

It also allows virtio-scsi headers + T10_PI + Data SGL payloads to span
the same iovec when pinning user-space memory via get_user_pages_fast()
code.  (Not tested yet)

It's currently functioning against v3.19-rc1 virtio-scsi LLD in T10_PI
mode with ANY_LAYOUT -> VERSION_1 guest feature bits enabled, using the
layout following existing convention with protection/data SGL payloads
residing within seperate iovecs.

Here's how the changelog is looking:

v2 changes:
  - Update memcpy_fromiovec_out usage comment
  - Clear ->tvc_sgl_count for vhost_scsi_mapal failure
  - Make vhost_scsi_mapal + vhost_scsi_calc_sgls accept max_niov
  - Update vhost_scsi_handle_vqal comments
  - Minor vhost_scsi_handle_vqal simplifications
  - Add missing minimum virtio-scsi response buffer size check
  - Fix pi_bytes* error message typo
  - Convert to use vhost_skip_iovec_bytes() common code
  - Add max_niov sanity checks vs. out + in offset into vq
  - Drop legacy pre virtio v1.0 !ANY_LAYOUT code

Also included in patch #11 is an over-due change to rename code in scsi.c
to line up with modern vhost_scsi naming convention.

Please review.

Thank you,

--nab

Nicholas Bellinger (11):
  lib/iovec: Add memcpy_fromiovec_out library function
  vhost/scsi: Convert completion path to use memcpy_toiovecend
  vhost/scsi: Fix incorrect early vhost_scsi_handle_vq failures
  vhost/scsi: Change vhost_scsi_map_to_sgl to accept iov ptr + len
  vhost/scsi: Add ANY_LAYOUT iov -> sgl mapping prerequisites
  vhost/scsi: Add ANY_LAYOUT vhost_skip_iovec_bytes helper
  vhost/scsi: Add ANY_LAYOUT vhost_virtqueue callback
  vhost/scsi: Set VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits
  vhost/scsi: Drop legacy pre virtio v1.0 !ANY_LAYOUT logic
  vhost/scsi: Drop left-over scsi_tcq.h include
  vhost/scsi: Global tcm_vhost -> vhost_scsi rename

 drivers/vhost/scsi.c | 1125 +++++++++++++++++++++++++++-----------------------
 include/linux/uio.h  |    2 +
 lib/iovec.c          |   35 ++
 3 files changed, 646 insertions(+), 516 deletions(-)

-- 
1.9.1
