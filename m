From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 0/8] vhost/scsi: Add ANY_LAYOUT + VERSION_1 support
Date: Fri,  6 Feb 2015 05:06:33 +0000
Message-ID: <1423199201-14659-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:54481 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbbBFFjp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2015 00:39:45 -0500
Received: by mail-oi0-f41.google.com with SMTP id z81so10316390oif.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Feb 2015 21:39:45 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MST, Paolo, Al & Co,

Here is v4 patch series for vhost/scsi ANY_LAYOUT + VERSION_1 support.

It updates vhost_virtqueue->handle_kick() -> vhost_scsi_handle_vq()
callback code to determine the start of protection + data payloads iovecs
past the starting virtio-scsi request + response headers.  It also uses
iovec out_size vs. req_size + iovec in_size vs. rsp_size in order to
determine data_direction for use with Al's new iov_iter primitives.

It assumes request/CDB and response/sense_buffer headers may span more
than a single iovec using mm/iov_iter.c logic.

It also allows virtio-scsi headers + T10_PI + Data SGL payloads to span
the same iovec when pinning user-space memory via get_user_pages_fast()
code.  (Not tested yet)

Based upon MST + Al's review feedback, the v3 -> v4 changes include:

  - Use iov_length() helper for out_size + in_size (MST)
  - Make out_iter init correct use out_size (MST)
  - Move data_direction + exp_data_len until after copy_from_iter() (MST)
  - Avoid specific ANY_LAYOUT wording in vhost_scsi_handle_vq() comments (MST)
  - Merge patch !ANY_LAYOUT removal into #5, use existing _vq() name (MST)
  - Further comments for vhost_scsi_handle_vq() code (Viro)
  - Fix iov_iter_init() to use proper WRITE/READ i->type assignment (Viro)

Note the one part that has been left unchanged is vhost_scsi_map_to_sgl()
into get_user_pages_fast(), for which existing iov_iter_get_pages() code
will need to allow for a callback or *sgl parameter to perform the associated
scatterlists setup from **pages for protection + data payloads.

It's functioning against v3.19-rc1 virtio-scsi LLD in T10_PI mode using
TYPE-1 DIF with ANY_LAYOUT -> VERSION_1 guest feature bits enabled, following
existing layout convention with protection/data SGL payloads residing within
seperate iovecs from virtio-scsi LLD guest.

Please review.

Thank you,

--nab

Nicholas Bellinger (8):
  vhost/scsi: Convert completion path to use copy_to_iter
  vhost/scsi: Fix incorrect early vhost_scsi_handle_vq failures
  vhost/scsi: Change vhost_scsi_map_to_sgl to accept iov ptr + len
  vhost/scsi: Add ANY_LAYOUT iov -> sgl mapping prerequisites
  vhost/scsi: Add ANY_LAYOUT support in vhost_scsi_handle_vq
  vhost/scsi: Set VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits
  vhost/scsi: Drop left-over scsi_tcq.h include
  vhost/scsi: Global tcm_vhost -> vhost_scsi rename

 drivers/vhost/scsi.c | 1062 +++++++++++++++++++++++++-------------------------
 1 file changed, 538 insertions(+), 524 deletions(-)

-- 
1.9.1

