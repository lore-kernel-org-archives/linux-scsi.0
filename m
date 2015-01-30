From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/8] vhost/scsi: Add ANY_LAYOUT support
Date: Fri, 30 Jan 2015 08:12:24 +0000
Message-ID: <1422605552-24797-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MST & Paolo,

The series adds initial vhost/scsi ANY_LAYOUT layout support.

It assumes request/CDB and response/sense_buffer headers may span more
than a single iovec using lib/iovec.c logic, along with a new addition
of memcpy_fromiovec_out() to return the current re-calcuated **iov_out.

This is currently done using a new vhost_scsi_handle_vqal() callback,
and doesn't modify behavior of existing !ANY_LAYOUT code.

It also allows virtio-scsi headers + T10_PI + Data SGL payloads to span
the same iovec when pinning user-space memory via get_user_pages_fast()
code.  (Not tested yet)

So far it's functioning against v3.19-rc1 virtio-scsi LLD code, with
a layout of header -> T10_PI -> Data SGL payload in seperate iovecs
and VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 guest feature bits.

Please review.

Thank you,

--nab

Nicholas Bellinger (8):
  lib/iovec: Add memcpy_fromiovec_out library function
  vhost/scsi: Convert completion path to use memcpy_toiovecend
  vhost/scsi: Fix incorrect early vhost_scsi_handle_vq failures
  vhost/scsi: Change vhost_scsi_map_to_sgl to accept iov ptr + len
  vhost/scsi: Add common vhost_scsi_queue_desc code
  vhost/scsi: Add ANY_LAYOUT prerequisites
  vhost/scsi: Add ANY_LAYOUT support
  vhost/scsi: Set VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits

 drivers/vhost/scsi.c | 512 ++++++++++++++++++++++++++++++++++++++++++++-------
 include/linux/uio.h  |   2 +
 lib/iovec.c          |  27 +++
 3 files changed, 476 insertions(+), 65 deletions(-)

-- 
1.9.1
