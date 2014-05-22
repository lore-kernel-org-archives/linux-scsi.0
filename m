From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Thu, 22 May 2014 02:26:16 +0000
Message-ID: <1400725582-5521-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:41330 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaEVCvA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 22:51:00 -0400
Received: by mail-ob0-f182.google.com with SMTP id wn1so3117004obc.13
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2014 19:50:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MST, MKP, Paolo & Co,

Here is the v2 patch series for adding T1O protection information (PI)
SGL passthrough support between virtio-scsi LLD + vhost-scsi fabric
endpoints.

Following MST's recommendation, it includes the changes for using
bytes intead of number of iovecs in virtio_scsi_cmd_req_pi along with
the associated changes to virtio-scsi + vhost/scsi code.

For vhost/scsi, this includes walking the leading iovec's length(s)
to determine where protection payload ends, and real data payload 
starts.  For virtio-scsi LLD code, this includes locating struct
blk_integrity for using blk_rq_sectors + ->tuple_size to calculate
the total bytes for outgoing cmd_pi->pi_bytes[out,in] values.

The full list of changes from last series include:

  - Use pi_bytesout + pi_bytesin instead of niovs in virtio-scsi PI
    header (mst + paolo)
  - Add prot_pto=1 in tcm_vhost_submission_work() when no PI buffer
    exists (nab)
  - Get rid of req + cdb pointer casts in vhost_scsi_handle_vq (mst)
  - Ensure that virtio_scsi_cmd_req_pi processing happens regardless
    of data_num in vhost_scsi_handle_vq (nab)
  - Pass TARGET_PROT_ALL into transport_init_session_tags() (nab)
  - Convert vhost_scsi_handle_vq to use memcpy_fromiovecend() (mst)
  - Convert vhost_scsi_handle_vq to use pi_bytesout + pi_bytesin (nab)
  - Convert virtio_scsi_init_hdr_pi() to use pi_bytesout + pi_bytesin
    (mst + paolo + nab)
  - Use blk_integrity->tuple_size to calculate pi bytes (nab)

Please review for v3.16-rc1 code.

Thanks!

--nab

Nicholas Bellinger (6):
  virtio-scsi.h: Add virtio_scsi_cmd_req_pi + VIRTIO_SCSI_F_T10_PI bits
  vhost/scsi: Move sanity check into vhost_scsi_map_iov_to_sgl
  vhost/scsi: Add preallocation of protection SGLs
  vhost/scsi: Add T10 PI IOV -> SGL memory mapping logic
  vhost/scsi: Enable T10 PI IOV -> SGL memory mapping
  virtio-scsi: Enable DIF/DIX modes in SCSI host LLD

 drivers/scsi/virtio_scsi.c  |   86 +++++++++---
 drivers/vhost/scsi.c        |  305 +++++++++++++++++++++++++++++--------------
 include/linux/virtio_scsi.h |   15 ++-
 3 files changed, 292 insertions(+), 114 deletions(-)

-- 
1.7.10.4

