From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v1 3/3] TARGET/sbc,loopback: Adjust command data length
 in case pi exists on the wire
Date: Tue, 10 Jun 2014 01:04:10 -0700
Message-ID: <1402387450.5774.56.camel@haakon3.risingtidesystems.com>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com>
	 <1402223228-23768-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1402223228-23768-4-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: michaelc@cs.wisc.edu, martin.petersen@oracle.com, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Quinn Tran <quinn.tran@qlogic.com>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Sagi & Co,

On Sun, 2014-06-08 at 13:27 +0300, Sagi Grimberg wrote:
> In various areas of the code, it is assumed that
> se_cmd->data_length describes pure data. In case
> that protection information exists over the wire
> (protect bits is are on) the target core decrease
> the protection length from the data length (instead
> of each transport peeking in the cdb).
> 
> Modify loopback device to include protection information
> in the transferred data length (like other scsi transports).
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/target/loopback/tcm_loop.c |   15 ++++++++++++---
>  drivers/target/target_core_sbc.c   |   15 +++++++++++++--
>  2 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index c886ad1..1f4c015 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -179,7 +179,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
>  	struct tcm_loop_hba *tl_hba;
>  	struct tcm_loop_tpg *tl_tpg;
>  	struct scatterlist *sgl_bidi = NULL;
> -	u32 sgl_bidi_count = 0;
> +	u32 sgl_bidi_count = 0, transfer_length;
>  	int rc;
>  
>  	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
> @@ -213,12 +213,21 @@ static void tcm_loop_submission_work(struct work_struct *work)
>  
>  	}
>  
> -	if (!scsi_prot_sg_count(sc) && scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
> +	transfer_length = scsi_transfer_length(sc);
> +	if (!scsi_prot_sg_count(sc) &&
> +	    scsi_get_prot_op(sc) != SCSI_PROT_NORMAL) {
>  		se_cmd->prot_pto = true;
> +		/*
> +		 * loopback transport doesn't support
> +		 * WRITE_GENERATE, READ_STRIP protection
> +		 * information operations, go ahead unprotected.
> +		 */
> +		transfer_length = scsi_bufflen(sc);
> +	}
>  
>  	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
>  			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
> -			scsi_bufflen(sc), tcm_loop_sam_attr(sc),
> +			transfer_length, tcm_loop_sam_attr(sc),
>  			sc->sc_data_direction, 0,
>  			scsi_sglist(sc), scsi_sg_count(sc),
>  			sgl_bidi, sgl_bidi_count,
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index e022959..06f8ecd 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -665,8 +665,19 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
>  
>  	cmd->prot_type = dev->dev_attrib.pi_prot_type;
>  	cmd->prot_length = dev->prot_length * sectors;
> -	pr_debug("%s: prot_type=%d, prot_length=%d prot_op=%d prot_checks=%d\n",
> -		 __func__, cmd->prot_type, cmd->prot_length,
> +
> +	/**
> +	 * In case protection information exists over the wire
> +	 * we modify command data length to describe pure data.
> +	 * The actual transfer length is data length + protection
> +	 * length
> +	 **/
> +	if (protect)
> +		cmd->data_length -= cmd->prot_length;
> +

This fabric wide assumption breaks the vhost-scsi + tcm_qla2xxx PI code
already queued for v3.16-rc1..

A vhost-scsi side conversion to combine exp_data_len + prot_bytes is
easy enough in target-pending/for-next (see below), given that
vhost-scsi's exp_data_len is coming from virtio buffer iovecs, so
changing virtio-scsi LLD to use scsi_transfer_length() doesn't really
make any sense. (Adding CC's for MST + Paolo)

The qla2xxx target T10 PI patch in scsi/for-next (adding Quinn CC) will
also need a similar change to update qlt_do_work() to include PI bytes
for data_length being passed into tgt_ops->handle_cmd(), following what
qlt_build_ctio_crc2_pkt() is already doing for calculating
transfer_length for HW offload.

That said, there is one other small qla2xxx change to enable per-session
PI that is currently missing in Quinn's patch in scsi/for-next code. 

Sooo, I'll go ahead and include Sagi's patches with the vhost-scsi
change below if there are no objections from MKP and/or driver
maintainers, and post an -rc2 series after the merge window closes to
address the two remaining qla2xxx specific items.

--nab

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 667e72d..03e484f 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1144,7 +1144,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
                }
 
                cmd = vhost_scsi_get_tag(vq, tpg, cdb, tag, lun, task_attr,
-                                        exp_data_len, data_direction);
+                                        exp_data_len + prot_bytes,
+                                        data_direction);
                if (IS_ERR(cmd)) {
                        vq_err(vq, "vhost_scsi_get_tag failed %ld\n",
                                        PTR_ERR(cmd));
