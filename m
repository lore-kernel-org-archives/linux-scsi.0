From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 0/9] vhost/scsi: Add ANY_LAYOUT + VERSION_1 support
Date: Tue,  3 Feb 2015 06:29:54 +0000
Message-ID: <1422945003-24538-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:53367 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbbBCHDC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2015 02:03:02 -0500
Received: by mail-ob0-f170.google.com with SMTP id va2so9094628obc.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Feb 2015 23:03:01 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MST, Paolo, Al & Co,

Here is -v3 for adding vhost/scsi ANY_LAYOUT + VERSION_1 host feature
bit support.

It adds a new vhost_virtqueue ->handle_kick() callback to determine the
start of protection and data payloads iovecs past starting virtio-scsi
request and response headers, based upon data_direction using iov_iter
primitives.

It assumes request/CDB and response/sense_buffer headers may span more
than a single iovec using mm/iov_iter.c logic.

It also allows virtio-scsi headers + T10_PI + Data SGL payloads to span
the same iovec when pinning user-space memory via get_user_pages_fast()
code.  (Not tested yet)

Based upon Al & HCH's feedback, the patch series has been converted to
use copy_*_iter() for virtio-scsi header copy.  Also, patch #4 has been
updated to use iov_iter_npages() for sgl_count, and patch #5 updated to
use iov_iter_advance() for calculating prot_bytes offset to the start
of data_iter.

v3 changelog:
  - Convert memcpy_toiovecend -> copy_to_iter usage
  - Update vhost_scsi_mapal + friends to use iov_iter
  - Move iov_iter sanity checks into vhost_scsi_calc_sgls
  - Convert vhost_scsi_calc_sgls() to iov_iter_npages()
  - Convert to vhost_scsi_handle_vqal to copy_from_iter usage
  - Update vhost_scsi_handle_vqal comments for iov_iter usage
  - Convert prot_bytes offset to use iov_iter_advance
  - Drop max_niov usage in vhost_scsi_handle_vqal
  - Drop vhost_skip_iovec_bytes in favour of iov_iter

Note the one part that has been left unchanged is vhost_scsi_map_to_sgl()
into get_user_pages_fast(), for which existing iov_iter_get_pages() code
will need to allow for a callback to perform the associated scatterlists
setup from **pages for protection + data payloads.

It's functioning against v3.19-rc1 virtio-scsi LLD in T10_PI mode using
TYPE-1 DIF with ANY_LAYOUT -> VERSION_1 guest feature bits enabled, using
the layout following existing convention with protection/data SGL payloads
residing within seperate iovecs.

Also included in patch #9 is an over-due change to rename code in scsi.c
to line up with modern vhost_scsi naming convention.

Please review.

Thank you,

Nicholas Bellinger (9):
  vhost/scsi: Convert completion path to use copy_to_iser
  vhost/scsi: Fix incorrect early vhost_scsi_handle_vq failures
  vhost/scsi: Change vhost_scsi_map_to_sgl to accept iov ptr + len
  vhost/scsi: Add ANY_LAYOUT iov -> sgl mapping prerequisites
  vhost/scsi: Add ANY_LAYOUT vhost_virtqueue callback
  vhost/scsi: Set VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits
  vhost/scsi: Drop legacy pre virtio v1.0 !ANY_LAYOUT logic
  vhost/scsi: Drop left-over scsi_tcq.h include
  vhost/scsi: Global tcm_vhost -> vhost_scsi rename

 drivers/vhost/scsi.c | 1073 ++++++++++++++++++++++++++------------------------
 1 file changed, 549 insertions(+), 524 deletions(-)

-- 
1.9.1

