From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH-v2 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Sun, 8 Jun 2014 19:05:41 +0300
Message-ID: <20140608160541.GA21832@redhat.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400725582-5521-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 22, 2014 at 02:26:16AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi MST, MKP, Paolo & Co,
> 
> Here is the v2 patch series for adding T1O protection information (PI)
> SGL passthrough support between virtio-scsi LLD + vhost-scsi fabric
> endpoints.
> 
> Following MST's recommendation, it includes the changes for using
> bytes intead of number of iovecs in virtio_scsi_cmd_req_pi along with
> the associated changes to virtio-scsi + vhost/scsi code.
> 
> For vhost/scsi, this includes walking the leading iovec's length(s)
> to determine where protection payload ends, and real data payload 
> starts.  For virtio-scsi LLD code, this includes locating struct
> blk_integrity for using blk_rq_sectors + ->tuple_size to calculate
> the total bytes for outgoing cmd_pi->pi_bytes[out,in] values.
> 
> The full list of changes from last series include:
> 
>   - Use pi_bytesout + pi_bytesin instead of niovs in virtio-scsi PI
>     header (mst + paolo)
>   - Add prot_pto=1 in tcm_vhost_submission_work() when no PI buffer
>     exists (nab)
>   - Get rid of req + cdb pointer casts in vhost_scsi_handle_vq (mst)
>   - Ensure that virtio_scsi_cmd_req_pi processing happens regardless
>     of data_num in vhost_scsi_handle_vq (nab)
>   - Pass TARGET_PROT_ALL into transport_init_session_tags() (nab)
>   - Convert vhost_scsi_handle_vq to use memcpy_fromiovecend() (mst)
>   - Convert vhost_scsi_handle_vq to use pi_bytesout + pi_bytesin (nab)
>   - Convert virtio_scsi_init_hdr_pi() to use pi_bytesout + pi_bytesin
>     (mst + paolo + nab)
>   - Use blk_integrity->tuple_size to calculate pi bytes (nab)
> 
> Please review for v3.16-rc1 code.
> 
> Thanks!
> 
> --nab


OK, finally went over this, looks good to me:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

However, we really should stop making more changes
before fixing ANY_LAYOUT in this driver.

virtio 1.0 should be out soon and that makes ANY_LAYOUT
a required feature.



> Nicholas Bellinger (6):
>   virtio-scsi.h: Add virtio_scsi_cmd_req_pi + VIRTIO_SCSI_F_T10_PI bits
>   vhost/scsi: Move sanity check into vhost_scsi_map_iov_to_sgl
>   vhost/scsi: Add preallocation of protection SGLs
>   vhost/scsi: Add T10 PI IOV -> SGL memory mapping logic
>   vhost/scsi: Enable T10 PI IOV -> SGL memory mapping
>   virtio-scsi: Enable DIF/DIX modes in SCSI host LLD
> 
>  drivers/scsi/virtio_scsi.c  |   86 +++++++++---
>  drivers/vhost/scsi.c        |  305 +++++++++++++++++++++++++++++--------------
>  include/linux/virtio_scsi.h |   15 ++-
>  3 files changed, 292 insertions(+), 114 deletions(-)
> 
> -- 
> 1.7.10.4
